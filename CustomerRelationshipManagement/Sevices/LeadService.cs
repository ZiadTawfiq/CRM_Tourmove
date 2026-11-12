using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using CustomerRelationshipManagement.LeadStatusHandler;
using CustomerRelationshipManagement.Repositories;

namespace CustomerRelationshipManagement.Sevices
{
    public class LeadService(ILeadRepository repository, IEnumerable<ILeadStatusHandler> statusHandlers, IEmployeeService employeeService) : ILeadService
    {
        private readonly IEnumerable<ILeadStatusHandler> _statusHandlers = statusHandlers;
        private static readonly Dictionary<Lead, List<LeadDuplicate>> _duplicateLeads = new();


        public async Task AssignLeadsToSalesRep(List<int> leadIds, int salesRepId)
        {
            var leads = await repository.GetLeadsByIdsAsync(leadIds);

            foreach (var lead in leads)
            {
                lead.EmployeeId = salesRepId.ToString();
            }
            await repository.SaveChangesAsync();
        }
        public async Task<LeadDto> CreateAsync(
            CreateLeadDto createLeadDto,
            int groupId)
        {
            var lead = await repository.GetLeadByPhoneNumberAndGroupId(
                createLeadDto.PhoneNumber, groupId);

            
            var loginUser = await employeeService.GetCurrentUserAsync();

            var allowDuplicate = false;

            if (loginUser.Role == Role.Admin)
            {
                allowDuplicate = true;
                
            }
            else if (loginUser.Role == Role.TeamLeader)
            {
                if (loginUser.GroupId != groupId)
                    throw new UnauthorizedAccessException();

                allowDuplicate = true;
            }
            if (loginUser.Role == Role.SalesRep)
            {
                if (loginUser.GroupId != groupId)
                {
                    allowDuplicate = true;

                }
                    
            }
            if (lead != null && !allowDuplicate)
            {
                lead.IsDuplicated = true;

                await repository.SaveChangesAsync();

                throw new Exception(
                    "A lead with this phone number already exists in the specified group.");
            }
           
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
                        ProjectId = createLeadDto.ProjectId,
                       

                        
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

        public async Task DuplicateLead()
        {
            

        }

        public Task<List<LeadDto>> FilterLeads(LeadFilterDto filterDto)
        {
            throw new NotImplementedException();
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

        public Task<List<LeadDto>> GetLeadsThatSalesTriedToDublicateByProject(List<int> ProjectIds)
        {
            throw new NotImplementedException();
        }

        public async Task<List<LeadDto>> SearchByPhoneNumber(string phoneNumber)
        {
            var leads = await repository.SearchByPhoneNumber(phoneNumber);

            return leads.Select(MapToDto).ToList();
        }

        public async Task UpdateAsync(UpdateLeadDto updateLeadDto)
        {
            var lead = await repository.GetByIdAsync(updateLeadDto.Id);
            if (lead == null)
            {
                throw new Exception($"Lead with ID {updateLeadDto.Id} not found.");
            }
            await repository.UpdateAsync(updateLeadDto);
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
    }
}
