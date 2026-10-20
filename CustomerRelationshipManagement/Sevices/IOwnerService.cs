using CustomerRelationshipManagement.Dtos;

namespace CustomerRelationshipManagement.Sevices
{
    public interface IOwnerService
    {
        Task<IEnumerable<OwnerDto>> GetAllAsync();
        Task<OwnerDto?> GetByIdAsync(int id);
        Task<OwnerDto> CreateAsync(CreateOwnerDto createOwnerDto);
        Task UpdateAsync(UpdateOwnerDto updateOwnerDto);
        Task DeleteAsync(int id);
    }
}
