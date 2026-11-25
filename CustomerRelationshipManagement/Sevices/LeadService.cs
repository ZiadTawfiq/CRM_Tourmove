using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using CustomerRelationshipManagement.LeadStatusHandler;
using CustomerRelationshipManagement.Repositories;
using Microsoft.EntityFrameworkCore;
using static Microsoft.EntityFrameworkCore.DbLoggerCategory;

namespace CustomerRelationshipManagement.Sevices
{
    // <summary> cohesive service for managing leads, including creation, deletion, filtering, and status updates
    // and apply strategy pattern for handling different lead statuses. It also includes functionality for assigning leads to sales representatives and managing duplicate leads.
    // and implement OCP   </summary>
    public class LeadService(ILeadRepository repository, IProjectRepository projectRepository,IEnumerable<ILeadStatusHandler> statusHandlers , ILeadAssignmentService leadAssignmentService, IEmployeeService employeeService ,IleadDuplicateService leadDuplicateService) : ILeadService
    {
        private readonly IEnumerable<ILeadStatusHandler> _statusHandlers = statusHandlers;

        
        public async Task<LeadDto> CreateAsync(
            CreateLeadDto createLeadDto,
            int groupId)
        {
            var loginUser = await employeeService.GetCurrentUserAsync();

            // Admin has full access. Other employees can only work
            // within their own group.
            if (loginUser.Role != Role.Admin &&
                loginUser.GroupId != groupId)
            {
                throw new UnauthorizedAccessException(
                    "You are not allowed to access this group.");
            }

            // Check if the phone number exists in the requested group.
            var existingLead = await repository.GetLeadByPhoneNumberAndGroupId(
                createLeadDto.PhoneNumber, groupId);

            // Duplicate found in the same group.
            if (existingLead != null)
            {
                // SalesRep cannot create duplicate leads.
                if (loginUser.Role == Role.SalesRep)
                {
                    await leadDuplicateService.DuplicateLead(existingLead.Id);

                    throw new InvalidOperationException(
                        "A lead with this phone number already exists in your group.");
                }

                // Admin and TeamLeader can review the duplicate.
                if (loginUser.Role == Role.Admin ||
                    loginUser.Role == Role.TeamLeader)
                {
                    // Create duplicate request and get its ID.
                    var duplicateRequestId =
                        await leadDuplicateService.DuplicateLead(existingLead.Id);
                    if (createLeadDto.EmployeeId == null)
                    {
                        throw new InvalidOperationException(
                            "Employee ID is required for reviewing duplicate leads.");
                    }
                    // Execute the selected action.
                    await leadDuplicateService.ReviewDuplicateLead(
                        duplicateRequestId,
                        createLeadDto.Action,
                        createLeadDto.EmployeeId);

                    throw new InvalidOperationException(
                        "Duplicate lead has been processed.");
                }
            }

            // No duplicate found in the requested group.
            var newLead = new Lead
            {
                Name = createLeadDto.Name,
                PhoneNumber = createLeadDto.PhoneNumber,
                EmployeeId = createLeadDto.EmployeeId,
                ChannelId = createLeadDto.ChannelId,
                Budget = createLeadDto.Budget,
                Status = Status.FreshLead,
                TypeLead = createLeadDto.TypeLead,
                Created = DateTime.UtcNow,

                LeadGroups = new List<LeadGroup>
        {
            new LeadGroup
            {
                GroupId = groupId,
                PhoneNumber = createLeadDto.PhoneNumber
            }
        },

                ProjectLeads = new List<ProjectLead>
        {
            new ProjectLead
            {
                ProjectId = createLeadDto.ProjectId
            }
        }
            };

            await repository.CreateAsync(newLead);

            return MapToDto(newLead);
        }

        public async Task DeleteAsync(int id)
        {
            await repository.DeleteAsync(id);
        }


        public async Task<List<LeadDto>> FilterLeads(LeadFilterDto filterDto)
        {
            var query = repository.GetLeadsQuery();

            if (filterDto.Status?.Any() == true)
                query = query.Where(l => filterDto.Status.Contains(l.Status));

            if (filterDto.PhoneNumber != null)
                query = query.Where(l => l.PhoneNumber.Contains(filterDto.PhoneNumber));

            if (filterDto.ProjectIds?.Any() == true)
                query = query.Where(l =>
                    l.ProjectLeads.Any(p => filterDto.ProjectIds.Contains(p.ProjectId)));

            var leads = await query.ToListAsync();

            return leads.Select(MapToDto).ToList();
        }
        

        public async Task<IEnumerable<LeadDto>> GetAllAsync()
        {
            var leads = await repository.GetAllAsync();
            return leads.Select(MapToDto);
        }

        public async Task<LeadDto?> GetByIdAsync(int id)
        {
            var lead = await repository.GetByIdAsync(id);
            return lead != null ? MapToDto(lead) : null;
        }


        public async Task<List<LeadDto>> SearchByPhoneNumber(string phoneNumber)
        {
            var leads = await repository.SearchByPhoneNumber(phoneNumber);

            return leads.Select(MapToDto).ToList();
        }

        public async Task UpdateAsync(UpdateLeadDto dto)
        {
            var lead = await repository.GetByIdAsync(dto.Id);
        
            if (lead == null)
                throw new KeyNotFoundException("Lead not found");

            // Update basic information
            lead.Name = dto.Name;
            lead.PhoneNumber = dto.PhoneNumber;
            lead.Budget = dto.Budget;
            lead.EmployeeId = dto.EmployeeId;
            lead.ChannelId = dto.ChannelId;
            lead.TypeLead = dto.TypeLead;

            // Change specific project
            if (dto.OldProjectId.HasValue && dto.NewProjectId.HasValue)
            {
                var leadProject = lead.ProjectLeads
                    .FirstOrDefault(lp => lp.ProjectId == dto.OldProjectId);

                if (leadProject == null)
                    throw new Exception("Lead is not associated with this project");

                var newProjectExists = await projectRepository.CheckExistenceProject(dto.NewProjectId.Value);

                if (!newProjectExists)
                    throw new KeyNotFoundException("New project not found");

                var alreadyLinked = lead.ProjectLeads
                    .Any(lp => lp.ProjectId == dto.NewProjectId);

                if (alreadyLinked)
                    throw new Exception("Lead is already associated with this project");

                leadProject.ProjectId = dto.NewProjectId.Value;
            }

            lead.Updated = DateTime.UtcNow;


            await repository.SaveChangesAsync();
        }

        public async Task UpdateLeadStatus(int leadId, Status status, CreateCommentDto notes)
        {
            var lead = await repository.GetByIdAsync(leadId);
            if (lead == null)
            {
                throw new Exception($"Lead with ID {leadId} not found.");
            }
            var statusHandler = _statusHandlers.FirstOrDefault(h => h.status == status);
            if (statusHandler == null)
            {
                throw new Exception($"No handler found for status {status}.");
            }
            await statusHandler.HandleAsync(lead, notes);
            await repository.SaveChangesAsync();

        }
        private static LeadDto MapToDto(Lead lead)
        {

            return new LeadDto
            {
                Id = lead.Id,
                Name = lead.Name,
                PhoneNumber = lead.PhoneNumber,
                Status = lead.Status,
                ProjectNames = lead.ProjectLeads
                .Select(lp => lp.Project.Name)
                .ToList(),
                ChannelName = lead.Channel?.Name,
                EmployeeName = lead.Employee?.Name,
                Budget = lead.Budget,
                TypeLead = lead.TypeLead,
                Created = lead.Created,

            };
        }

        public async Task SaveChangesAsync()
        {
          await repository.SaveChangesAsync();
        }

        public async Task AssignLeadsToSalesRep(List<int> leadIds, int salesRepId)
        {
           await leadAssignmentService.Assign(leadIds, salesRepId);
        }

        public async Task<List<LeadComparisonDto>> GetLeadsThatSalesTriedToDublicateByProject(List<int> ProjectIds, DateTime? startDate, DateTime? endDate)
        {
            return await leadDuplicateService.ListDuplicateLeadsByProjectIdsAsync(ProjectIds, startDate, endDate);
        }
    }
}
