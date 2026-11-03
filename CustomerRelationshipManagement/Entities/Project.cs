namespace CustomerRelationshipManagement.Entities
{
    public class Project
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public List<ProjectLead> ProjectLeads { get; set; } = new List<ProjectLead>();
        public List<Employee>Employees { get; set; } = new List<Employee>();
        public int? GroupId { get; set; }
        public Group? Group { get; set; }
    }
}
