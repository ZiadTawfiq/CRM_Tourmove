namespace CustomerRelationshipManagement.Entities
{
    public class Owner
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string PhoneNumber { get; set; } = string.Empty;
        public int? EmployeeId { get; set; }
        public Employee Employee { get; set; }
    }
}
