namespace CustomerRelationshipManagement.Repositories
{

    public interface ILeadDuplicateRepository
    {
        Task CreateAsync(LeadDuplicate leadDuplicate);
        Task<LeadDuplicate?> GetByIdAsync(int id);
        Task SaveChangesAsync();
    }
}
