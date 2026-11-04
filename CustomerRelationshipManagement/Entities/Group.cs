namespace CustomerRelationshipManagement.Entities
{
    public class Group
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public List<Project> Projects { get; set; } = new List<Project>();
        public ICollection<LeadGroup> LeadGroups { get; set; }
                = new List<LeadGroup>();
        public List<Employee> Employees { get; set; } = new List<Employee>(); 
    }
}
