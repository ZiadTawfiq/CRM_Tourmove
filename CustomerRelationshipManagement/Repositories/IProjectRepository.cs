using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.Repositories
{
    public interface IProjectRepository
    {
        Task CreateAsync(Project project);
        Task UpdateAsync(UpdateProjectDto updateProjectDto);
        Task DeleteAsync(int id);
        Task<Project?> GetByIdAsync(int id);
        Task<IEnumerable<Project>> GetAllAsync();
        Task<IEnumerable<Project>> GetProjectsByGroupIdAsync(int groupId);
    }
}
