using Microsoft.EntityFrameworkCore;

namespace CustomerRelationshipManagement.Repositories
{
    public class LeadDuplicateRepository(AppDbContext dbContext):ILeadDuplicateRepository
    {
        public async Task CreateAsync(LeadDuplicate leadDuplicate)
        {
            dbContext.LeadDuplicates.Add(leadDuplicate);
            await dbContext.SaveChangesAsync();
        }

        public async Task<LeadDuplicate?> GetByIdAsync(int id)
        {
            return await dbContext.LeadDuplicates
                .Include(d => d.Lead)
                .FirstOrDefaultAsync(d => d.Id == id);
        }

        public async Task SaveChangesAsync()
        {
            await dbContext.SaveChangesAsync();
        }
    }
}
