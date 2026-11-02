using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using Microsoft.EntityFrameworkCore;

namespace CustomerRelationshipManagement.Repositories
{
    public class GroupRepository(AppDbContext dbContext ) : IGroupRepository
    {
        public async Task<IEnumerable<Group>> GetAllAsync()
        {
            return await dbContext.Groups
                .AsNoTracking()
                .ToListAsync();
        }

        public async Task<Group?> GetByIdAsync(int id)
        {
            return await dbContext.Groups
                .Include(g => g.Projects)
                .FirstOrDefaultAsync(g => g.Id == id);
        }

        public async Task CreateAsync(Group group)
        {
            dbContext.Groups.Add(group);
            await dbContext.SaveChangesAsync();
        }

        public async Task UpdateAsync(int id, UpdateGroupDto updateGroupDto)
        {
            var group = await GetByIdAsync(id);
            if (group == null)
                throw new KeyNotFoundException($"Group with ID {id} not found");

            var projects = await dbContext.Projects
            .Where(p => updateGroupDto.ProjectIds.Contains(p.Id))
            .ToListAsync();

             if (projects.Count != updateGroupDto.ProjectIds.Distinct().Count())
               throw new KeyNotFoundException("One or more projects were not found.");
            var assignedToAnotherGroup = projects
             .Any(p => p.GroupId != null && p.GroupId != id);

            if (assignedToAnotherGroup)
                throw new Exception("One or more projects already belong to another group.");

            group.Name = updateGroupDto.Name;

            group.Projects.Clear(); 
            group.Projects.AddRange(await dbContext.Projects.Where(p => updateGroupDto.ProjectIds.Contains(p.Id)).ToListAsync());

            dbContext.Groups.Update(group);
            await dbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var group = await dbContext.Groups.FindAsync(id);

            if (group == null)
                throw new KeyNotFoundException($"Group with ID {id} not found");

            dbContext.Groups.Remove(group);
            await dbContext.SaveChangesAsync();
        }

        public async Task SaveChangesAsync()
        {
            await dbContext.SaveChangesAsync();
        }
    }
}