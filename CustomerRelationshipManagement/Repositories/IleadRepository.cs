using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.Repositories
{
    public interface ILeadRepository
    {
        Task CreateAsync(Lead lead);
        Task UpdateAsync(Lead lead);
        Task DeleteAsync(int id);
        Task<Lead?> GetByIdAsync(int id);
        Task<IEnumerable<Lead>> GetAllAsync();
    }
}
