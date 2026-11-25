using CustomerRelationshipManagement.Data;
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

   

        public Task<List<Comment>> GetCommentsForLead(int leadId)
        {
            return dbContext.Comments
                .Where(c => c.LeadId == leadId)
                .ToListAsync();
        }

      

        public IQueryable<Lead> GetLeadsQuery()
        {
            return dbContext.Leads;
        }

      
    }
}
