using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.Sevices
{
    public interface IGroupService
    {
        // Group CRUD
        Task<IEnumerable<GroupDto>> GetAllAsync();
        Task<GroupDto> GetByIdAsync(int id);
        Task CreateAsync(CreateGroupDto createGroupDto);
        Task UpdateAsync(int id, UpdateGroupDto updateGroupDto);
        Task DeleteAsync(int id);

        // Group Projects
        Task AddProjectToGroup(int groupId, int projectId);
        Task RemoveProjectFromGroup(int groupId, int projectId);
    }
}