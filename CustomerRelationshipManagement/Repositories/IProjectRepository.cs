using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.Repositories
{
    public interface IProjectRepository
    {
        Task CreateAsync(Project project);
        Task UpdateAsync(Project project);
        Task DeleteAsync(int id);
        Task<Project?> GetByIdAsync(int id);
        Task<IEnumerable<Project>> GetAllAsync();
    }
}
