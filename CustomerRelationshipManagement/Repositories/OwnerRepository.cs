using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using Microsoft.EntityFrameworkCore;

namespace CustomerRelationshipManagement.Repositories
{
    public class OwnerRepository(AppDbContext dbContext) : IOwnerRepository
    {
        public async Task CreateAsync(Owner owner)
        {
            dbContext.Owners.Add(owner);
            await dbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var existingOwner = await dbContext.Owners.FindAsync(id);
            if (existingOwner == null)
            {
                throw new KeyNotFoundException($"Owner with id {id} not found!");
            }
            dbContext.Owners.Remove(existingOwner);
            await dbContext.SaveChangesAsync();
        }

        public async Task<IEnumerable<Owner>> GetAllAsync()
        {
            return await dbContext.Owners.ToListAsync();
        }

        public async Task<Owner?> GetByIdAsync(int id)
        {
            var owner = await dbContext.Owners.FirstOrDefaultAsync(_ => _.Id == id);
            if (owner is null)
            {
                throw new KeyNotFoundException($"Owner with id {id} not found");
            }
            return owner;
        }

        public async Task UpdateAsync(UpdateOwnerDto updateOwnerDto)
        {
            var existingOwner = await dbContext.Owners.FindAsync(updateOwnerDto.Id);
            if (existingOwner is null)
            {
                throw new KeyNotFoundException($"Owner with id {updateOwnerDto.Id} not found");
            }

            existingOwner.Name = updateOwnerDto.Name;
            existingOwner.PhoneNumber = updateOwnerDto.PhoneNumber;

            if (int.TryParse(updateOwnerDto.EmployeeId, out var empId))
            {
                existingOwner.EmployeeId = empId;
            }
            else
            {
                existingOwner.EmployeeId = null;
            }

            await dbContext.SaveChangesAsync();
        }
    }
}
