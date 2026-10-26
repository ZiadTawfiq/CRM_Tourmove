using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using CustomerRelationshipManagement.Repositories;

namespace CustomerRelationshipManagement.Sevices
{
    public class ProjectService(IProjectRepository projectRepository) : IProjectService
    {
        public async Task<IEnumerable<ProjectDto>> GetAllAsync()
        {
            var projects = await projectRepository.GetAllAsync();
            return projects.Select(MapToDto);
        }

        public async Task<ProjectDto?> GetByIdAsync(int id)
        {
            var project = await projectRepository.GetByIdAsync(id);
            return project is null ? null : MapToDto(project);
        }

        public async Task<ProjectDto> CreateAsync(CreateProjectDto createProjectDto)
        {
            var project = new Project
            {
                Name = createProjectDto.Name
            };

            await projectRepository.CreateAsync(project);

            return MapToDto(project);
        }

        public async Task UpdateAsync(UpdateProjectDto updateProjectDto)
        {
            await projectRepository.UpdateAsync(updateProjectDto);
        }

        public async Task DeleteAsync(int id)
        {
            await projectRepository.DeleteAsync(id);
        }

        private static ProjectDto MapToDto(Project project)
        {
            return new ProjectDto
            {
                Id = project.Id,
                Name = project.Name,
                LeadsCount = project.Leads?.Count ?? 0,
                EmployeesCount = project.Employees?.Count ?? 0
            };
        }
    }
}
