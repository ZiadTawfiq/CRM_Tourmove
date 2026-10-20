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
            var existingOwner = await dbContext.Owners.FirstOrDefaultAsync(_ => _.Id == id);
            if (existingOwner == null)
            {
                throw new Exception($"Owner with id {id} not found!");
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
                throw new Exception($"Owner with id {id} not found");
            }
            return owner;
        }

        public async Task UpdateAsync(Owner owner)
        {
            var existingOwner = await dbContext.Owners.FirstOrDefaultAsync(_ => _.Id == owner.Id);
            if (existingOwner is null)
            {
                throw new Exception($"Owner with id {owner.Id} not found");
            }

            existingOwner.Name = owner.Name;
            existingOwner.PhoneNumber = owner.PhoneNumber;
            existingOwner.EmployeeId = owner.EmployeeId;

            dbContext.Owners.Update(existingOwner);
            await dbContext.SaveChangesAsync();
        }
    }
}
