using CustomerRelationshipManagement.Entities;
using Microsoft.EntityFrameworkCore;

namespace CustomerRelationshipManagement.Repositories
{
    public class LeadRepository(AppDbContext dbContext) : ILeadRepository
    {
        public async Task CreateAsync(Lead lead)
        {

            var existingLead = await dbContext.Leads.Include(_ =>_.Project).FirstOrDefaultAsync(_ => _.PhoneNumber == lead.PhoneNumber);
            if (existingLead != null)
            {
                throw new Exception($"Lead with phone number {lead.PhoneNumber} already exists! in {existingLead.Project.Name}");
            }
            lead.Created = DateTime.UtcNow;
            dbContext.Leads.Add(lead);
            await dbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var existingLead = await dbContext.Leads.FirstOrDefaultAsync(_ => _.Id == id);
            if (existingLead == null)
            {
                throw new Exception($"Lead with {id} not found!"); 
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
                throw new Exception($"Lead with id {id} not found");
            }
            return lead;
        }

        public async Task UpdateAsync(Lead lead)
        {
            var existingLead = await dbContext.Leads.FirstOrDefaultAsync(_ => _.Id == lead.Id);
            if (existingLead is null)
            {
                throw new Exception($"Lead with id {lead.Id} not found");
            }
            existingLead.Name = lead.Name;
            existingLead.PhoneNumber = lead.PhoneNumber;
            existingLead.ChannelId = lead.ChannelId;
            existingLead.ProjectId = lead.ProjectId;
            existingLead.Updated = DateTime.UtcNow;
            existingLead.Budget = lead.Budget;
            existingLead.EmployeeId = lead.EmployeeId;
            existingLead.Status = lead.Status;

            dbContext.Leads.Update(existingLead);
            await dbContext.SaveChangesAsync();
        }
    }
}
