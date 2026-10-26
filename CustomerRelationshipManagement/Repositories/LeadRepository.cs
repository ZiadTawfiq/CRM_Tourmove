using CustomerRelationshipManagement.Dtos;
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

        public async Task UpdateAsync(UpdateLeadDto updateLeadDto)
        {
            var existingLead = await dbContext.Leads.FindAsync(updateLeadDto.Id);
            if (existingLead is null)
            {
                throw new KeyNotFoundException($"Lead with id {updateLeadDto.Id} not found");
            }

            if (existingLead.PhoneNumber != updateLeadDto.PhoneNumber)
            {
                var duplicateLead = await dbContext.Leads
                    .Include(_ => _.Project)
                    .FirstOrDefaultAsync(_ => _.PhoneNumber == updateLeadDto.PhoneNumber && _.Id != updateLeadDto.Id);
                if (duplicateLead != null)
                {
                    throw new Exception($"Lead with phone number {updateLeadDto.PhoneNumber} already exists! in {duplicateLead.Project.Name}");
                }
            }

            existingLead.Name = updateLeadDto.Name;
            existingLead.PhoneNumber = updateLeadDto.PhoneNumber;
            existingLead.ChannelId = updateLeadDto.ChannelId;
            if (updateLeadDto.ProjectId.HasValue)
            {
                existingLead.ProjectId = updateLeadDto.ProjectId.Value;
            }
            existingLead.Budget = updateLeadDto.Budget;
            existingLead.EmployeeId = updateLeadDto.EmployeeId;
            existingLead.Status = updateLeadDto.Status;
            existingLead.TypeLead = updateLeadDto.TypeLead;

            existingLead.Updated = DateTime.UtcNow;

            await dbContext.SaveChangesAsync();
        }
    }
}
