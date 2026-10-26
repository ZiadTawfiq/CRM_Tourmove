using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.Repositories
{
    public interface IOwnerRepository
    {
        Task CreateAsync(Owner owner);
        Task UpdateAsync(UpdateOwnerDto updateOwnerDto);
        Task DeleteAsync(int id);
        Task<Owner?> GetByIdAsync(int id);
        Task<IEnumerable<Owner>> GetAllAsync();
    }
}
