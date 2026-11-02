using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using Microsoft.EntityFrameworkCore;

namespace CustomerRelationshipManagement.Repositories
{
    public class LeadRepository(AppDbContext dbContext) : ILeadRepository
    {
        public async Task CreateAsync(Lead lead)
        {

          
            lead.Status = Status.FreshLead;
            lead.Created = DateTime.UtcNow;
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
            var lead = await dbContext.Leads.FirstOrDefaultAsync(_ => _.Id == id);
            if (lead is null)
            {
                throw new KeyNotFoundException($"Lead with id {id} not found");
            }
            return lead;
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
    }
}
