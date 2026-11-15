using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using Microsoft.EntityFrameworkCore;

namespace CustomerRelationshipManagement.Repositories
{
    public class LeadRepository(AppDbContext dbContext) : ILeadRepository
    {
        public async Task CreateAsync(Lead lead)
        {
  
            dbContext.Leads.Add(lead);
            await dbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var existingLead = await dbContext.Leads.FindAsync(id);
            if (existingLead == null)
            {
                throw new KeyNotFoundException($"Lead with id {id} not found!"); 
            }
            dbContext.Leads.Remove(existingLead);
            await dbContext.SaveChangesAsync(); 

        }

        public async Task<IEnumerable<Lead>> GetAllAsync()
        {
            return await dbContext.Leads.ToListAsync();
        }

        public async Task<Lead?> GetByIdAsync(int id)
        {
            var lead = await dbContext.Leads
                .Include(l => l.LeadGroups)
                .Include(l => l.ProjectLeads)
                .FirstOrDefaultAsync(l => l.Id == id);

            if (lead is null)
                throw new KeyNotFoundException($"Lead with id {id} not found");

            return lead;
        }

        public async Task<List<Lead>> GetLeadsByIdsAsync(List<int> leadIds)
        {
           var leads = await dbContext.Leads.Where(l => leadIds.Contains(l.Id)).ToListAsync();
           return leads;
        }

        public async Task<Lead?> GetLeadByPhoneNumberAndGroupId(
            string phoneNumber, int groupId)
         {

               return await dbContext.Leads
               .Include(l => l.LeadGroups)
               .FirstOrDefaultAsync(l =>
               l.PhoneNumber == phoneNumber &&
               l.LeadGroups.Any(lg => lg.GroupId == groupId));
         }

        public async Task SaveChangesAsync()
        {
            await dbContext.SaveChangesAsync();
        }

        public async Task<List<Lead>> SearchByPhoneNumber(string phoneNumber)
        {
            var leads = await dbContext.Leads
                .Where(l => l.PhoneNumber.Contains(phoneNumber))
                .ToListAsync();
            return leads;
        }

        public async Task UpdateAsync(UpdateLeadDto dto)
        {
            var lead = await dbContext.Leads
                .Include(l => l.ProjectLeads)
                .FirstOrDefaultAsync(l => l.Id == dto.Id);

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

                var newProjectExists = await dbContext.Projects
                    .AnyAsync(p => p.Id == dto.NewProjectId);

                if (!newProjectExists)
                    throw new KeyNotFoundException("New project not found");

                var alreadyLinked = lead.ProjectLeads
                    .Any(lp => lp.ProjectId == dto.NewProjectId);

                if (alreadyLinked)
                    throw new Exception("Lead is already associated with this project");

                leadProject.ProjectId = dto.NewProjectId.Value;
            }

            lead.Updated = DateTime.UtcNow;

            await dbContext.SaveChangesAsync();
        }

        public Task<List<Comment>> GetCommentsForLead(int leadId)
        {
            return dbContext.Comments
                .Where(c => c.LeadId == leadId)
                .ToListAsync();
        }

        public Task<List<Lead>> FilterLeadsAsync(LeadFilterDto filterDto)
        {
            var leadsQuery = dbContext.Leads.AsQueryable();
            if (filterDto == null)
            {
                throw new ArgumentNullException(nameof(filterDto));
            }
            if (filterDto.CreatedFrom.HasValue && filterDto.CreatedTo.HasValue)
            {
                if (filterDto.CreatedFrom > filterDto.CreatedTo)
                {
                    throw new ArgumentException("CreatedFrom date cannot be later than CreatedTo date.");
                }
                leadsQuery = leadsQuery.Where(l => l.Created >= filterDto.CreatedFrom.Value && l.Created <= filterDto.CreatedTo.Value);
            }
            if (filterDto.AssignedFrom.HasValue && filterDto.AssignedTo.HasValue)
            {
                if (filterDto.AssignedFrom > filterDto.AssignedTo)
                {
                    throw new ArgumentException("AssignedFrom date cannot be later than AssignedTo date.");
                }
                leadsQuery = leadsQuery.Where(l => l.Assigned >= filterDto.AssignedFrom.Value && l.Assigned <= filterDto.AssignedTo.Value);
            }
            if (!string.IsNullOrEmpty(filterDto.PhoneNumber))
            {
                leadsQuery = leadsQuery.Where(l => l.PhoneNumber.Contains(filterDto.PhoneNumber));
            }
            if (filterDto.Status != null && filterDto.Status.Any())
            {
                leadsQuery = leadsQuery.Where(l => filterDto.Status.Contains(l.Status));
            }
            if (!string.IsNullOrWhiteSpace(filterDto.TypeLead))
            {
                if (Enum.TryParse<TypeLead>(
                    filterDto.TypeLead,
                    true,
                    out var typeLead))
                {
                    leadsQuery = leadsQuery.Where(l => l.TypeLead == typeLead);
                }
                else
                {
                    throw new ArgumentException("Invalid TypeLead value.");
                }
            }
            if (filterDto.ProjectId != null && filterDto.ProjectId.Any())
            {
                leadsQuery = leadsQuery.Where(l => l.ProjectLeads.Any(pl => filterDto.ProjectId.Contains(pl.ProjectId)));
            }
            if (filterDto.ChannelId != null && filterDto.ChannelId.Any())
            {
                leadsQuery = leadsQuery.Where(l => l.ChannelId.HasValue && filterDto.ChannelId.Contains(l.ChannelId.Value));
            }
            if (filterDto.EmployeeIds != null && filterDto.EmployeeIds.Any())
            {
                leadsQuery = leadsQuery.Where(l => filterDto.EmployeeIds.Contains(l.EmployeeId));
            }

            return leadsQuery.ToListAsync();
        }
    }
}
