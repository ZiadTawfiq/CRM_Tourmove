namespace CustomerRelationshipManagement.Dtos
{
    public class CreateGroupDto
    {
        public string Name { get; set; } = string.Empty;
    }
    public class UpdateGroupDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public List<int> ProjectIds { get; set; } = new List<int>();
    }
    public class GroupDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public List<ProjectDto> Projects { get; set; } = new List<ProjectDto>();
    }
}
