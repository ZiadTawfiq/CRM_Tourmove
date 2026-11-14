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

        public async Task<List<LeadDuplicate>> GetDuplicatesByProjectIdsAsync(List<int> projectIds,DateTime? startDate,DateTime? endDate)
        {
            startDate = startDate ?? DateTime.Today.AddDays(-1);
            endDate = endDate ?? DateTime.Today.AddDays(1);

            return await dbContext.LeadDuplicates
            .Include(d => d.Lead)
                .ThenInclude(l => l.Employee)

            .Include(d => d.Lead)
                .ThenInclude(l => l.Channel)

            .Include(d => d.Lead)
                .ThenInclude(l => l.ProjectLeads)
                    .ThenInclude(pl => pl.Project)

            .Include(d => d.DuplicateLead)
                .ThenInclude(l => l.Employee)

            .Include(d => d.DuplicateLead)
                .ThenInclude(l => l.Channel)

            .Include(d => d.DuplicateLead)
                .ThenInclude(l => l.ProjectLeads)
                    .ThenInclude(pl => pl.Project)

            .Where(d =>
                d.Status == DuplicateStatus.Created &&
                d.CreatedAt >= startDate &&
                d.CreatedAt <= endDate &&
                projectIds.Contains(
                    d.Lead.ProjectLeads.FirstOrDefault()!.ProjectId))
            .AsSplitQuery()
            .AsNoTracking()
            .ToListAsync();

          
        }

        public async Task SaveChangesAsync()
        {
            await dbContext.SaveChangesAsync();
        }
    }
}
