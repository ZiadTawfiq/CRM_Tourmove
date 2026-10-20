namespace CustomerRelationshipManagement.Dtos
{
    public class OwnerDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;
        public string? EmployeeId { get; set; }
        public string? EmployeeName { get; set; }
    }

    public class CreateOwnerDto
    {
        public string Name { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;
        public string? EmployeeId { get; set; }
    }

    public class UpdateOwnerDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;
        public string? EmployeeId { get; set; }
    }
}
