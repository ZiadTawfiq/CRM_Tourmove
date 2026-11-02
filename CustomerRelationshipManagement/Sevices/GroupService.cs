using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using CustomerRelationshipManagement.Repositories;

namespace CustomerRelationshipManagement.Sevices
{
    public class GroupService(IGroupRepository groupRepository , IProjectRepository projectRepository) : IGroupService
    {
        public async Task AddProjectToGroup(int groupId, int projectId)
        {
            var group = await groupRepository.GetByIdAsync(groupId);

            if (group == null)
                throw new KeyNotFoundException($"Group {groupId} not found.");

            var project = await projectRepository.GetByIdAsync(projectId);

            if (project == null)
                throw new KeyNotFoundException($"Project {projectId} not found.");

            if (project.GroupId == groupId)
                throw new Exception("Project already belongs to this group.");

            if (project.GroupId != null)
                throw new Exception("Project already belongs to another group.");

            project.GroupId = groupId;

            await groupRepository.SaveChangesAsync();
        }
        public async Task CreateAsync(CreateGroupDto groupDto)
        {
            var group = new Group
            {
                Name = groupDto.Name
            };
            await groupRepository.CreateAsync(group);
        }

        public async Task DeleteAsync(int id)
        {
           await groupRepository.DeleteAsync(id);
        }

        public async Task<IEnumerable<GroupDto>> GetAllAsync()
        {
            var groups = await groupRepository.GetAllAsync();
            return groups.Select(MapToGroupDto);
        }

        public async Task<IEnumerable<Project>> GetAllProjectInGroup(int groupId)
        {
            return await projectRepository.GetProjectsByGroupIdAsync(groupId);
        }

        public async Task<GroupDto> GetByIdAsync(int id)
        {
            var group = await groupRepository.GetByIdAsync(id);
            return group != null ? MapToGroupDto(group) : throw new Exception($"Group with id {id} not found.");
        }
       

        public async Task RemoveProjectFromGroup(int groupId, int projectId)
        {
            var group =await  groupRepository.GetByIdAsync(groupId);
            var project = await projectRepository.GetByIdAsync(projectId);
            if (group == null)
            {
                throw new Exception($"Group with id {groupId} not found.");
            }
            if (project == null)
            {
                throw new Exception($"Project with id {projectId} not found.");
            }
            var projectInGroup = group.Projects
            .FirstOrDefault(p => p.Id == projectId);

            if (projectInGroup == null)
                throw new Exception("Project does not belong to this group.");

            projectInGroup.GroupId = null;
            await groupRepository.SaveChangesAsync();
        }

        public async Task UpdateAsync(int id, UpdateGroupDto updateGroupDto)
        {
            await groupRepository.UpdateAsync(id, updateGroupDto);
        }


        private static GroupDto MapToGroupDto(Group group)
        {
            return new GroupDto
            {
                Id = group.Id,
                Name = group.Name,
                Projects = group.Projects.Select(p => new ProjectDto
                {
                    Id = p.Id,
                    Name = p.Name
                }).ToList()
            };
        }
    }
}
