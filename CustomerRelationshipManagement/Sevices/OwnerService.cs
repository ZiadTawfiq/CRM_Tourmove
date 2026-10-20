using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using CustomerRelationshipManagement.Repositories;

namespace CustomerRelationshipManagement.Sevices
{
    public class OwnerService(IOwnerRepository ownerRepository) : IOwnerService
    {
        public async Task<IEnumerable<OwnerDto>> GetAllAsync()
        {
            var owners = await ownerRepository.GetAllAsync();
            return owners.Select(MapToDto);
        }

        public async Task<OwnerDto?> GetByIdAsync(int id)
        {
            var owner = await ownerRepository.GetByIdAsync(id);
            return owner is null ? null : MapToDto(owner);
        }

        public async Task<OwnerDto> CreateAsync(CreateOwnerDto createOwnerDto)
        {
            var owner = new Owner
            {
                Name = createOwnerDto.Name,
                PhoneNumber = createOwnerDto.PhoneNumber
            };

            if (int.TryParse(createOwnerDto.EmployeeId, out var empId))
            {
                owner.EmployeeId = empId;
            }

            await ownerRepository.CreateAsync(owner);

            return MapToDto(owner);
        }

        public async Task UpdateAsync(UpdateOwnerDto updateOwnerDto)
        {
            var owner = await ownerRepository.GetByIdAsync(updateOwnerDto.Id);
            if (owner is null)
            {
                throw new KeyNotFoundException($"Owner with id {updateOwnerDto.Id} not found");
            }

            owner.Name = updateOwnerDto.Name;
            owner.PhoneNumber = updateOwnerDto.PhoneNumber;

            if (int.TryParse(updateOwnerDto.EmployeeId, out var empId))
            {
                owner.EmployeeId = empId;
            }

            await ownerRepository.UpdateAsync(owner);
        }

        public async Task DeleteAsync(int id)
        {
            await ownerRepository.DeleteAsync(id);
        }

        private static OwnerDto MapToDto(Owner owner)
        {
            return new OwnerDto
            {
                Id = owner.Id,
                Name = owner.Name,
                PhoneNumber = owner.PhoneNumber,
                EmployeeId = owner.EmployeeId?.ToString(),
                EmployeeName = owner.Employee?.Name
            };
        }
    }
}
