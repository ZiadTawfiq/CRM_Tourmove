using CustomerRelationshipManagement.Entities;
using Microsoft.EntityFrameworkCore;

namespace CustomerRelationshipManagement.Repositories
{
    public class ProjectRepository(AppDbContext dbContext) : IProjectRepository
    {
        public async Task CreateAsync(Project project)
        {
            dbContext.Projects.Add(project);
            await dbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var existingProject = await dbContext.Projects.FirstOrDefaultAsync(_ => _.Id == id);
            if (existingProject == null)
            {
                throw new Exception($"Project with id {id} not found!");
            }
            dbContext.Projects.Remove(existingProject);
            await dbContext.SaveChangesAsync();
        }

        public async Task<IEnumerable<Project>> GetAllAsync()
        {
            return await dbContext.Projects.ToListAsync();
        }

        public async Task<Project?> GetByIdAsync(int id)
        {
            var project = await dbContext.Projects.FirstOrDefaultAsync(_ => _.Id == id);
            if (project is null)
            {
                throw new Exception($"Project with id {id} not found");
            }
            return project;
        }

        public async Task UpdateAsync(Project project)
        {
            var existingProject = await dbContext.Projects.FirstOrDefaultAsync(_ => _.Id == project.Id);
            if (existingProject is null)
            {
                throw new Exception($"Project with id {project.Id} not found");
            }

            existingProject.Name = project.Name;

            dbContext.Projects.Update(existingProject);
            await dbContext.SaveChangesAsync();
        }
    }
}
