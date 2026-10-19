namespace CustomerRelationshipManagement.Entities
{
    public class Project
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public List<Lead> Leads { get; set; } = new List<Lead>();
        public List<Employee>Employees { get; set; } = new List<Employee>();
    }
}
