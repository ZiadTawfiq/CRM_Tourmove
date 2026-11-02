using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.Repositories
{
    public interface IGroupRepository
    {
        Task<IEnumerable<Group>> GetAllAsync();
        Task<Group?> GetByIdAsync(int id);
        Task CreateAsync(Group group);
        Task UpdateAsync(int id , UpdateGroupDto updateGroupDto);
        Task DeleteAsync(int id);
        Task SaveChangesAsync();

    }
}
