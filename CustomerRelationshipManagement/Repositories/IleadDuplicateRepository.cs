namespace CustomerRelationshipManagement.Repositories
{

    public interface ILeadDuplicateRepository
    {
        Task CreateAsync(LeadDuplicate leadDuplicate);
        Task<LeadDuplicate?> GetByIdAsync(int id);
        Task<List<LeadDuplicate>> GetDuplicatesByProjectIdsAsync(List<int> projectIds, DateTime? startDate, DateTime? endDate);
        Task SaveChangesAsync();
    }
}
