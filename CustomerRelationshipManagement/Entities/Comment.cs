namespace CustomerRelationshipManagement.Entities;

public class Comment
{
    public int Id { get; set; }

    public string Text { get; set; } = string.Empty;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public DateTime? LastUpdated { get; set; }
    public int EmployeeId { get; set; }
    public Employee Employee { get; set; }

    public int LeadId { get; set; }

    public Lead Lead { get; set; } = null!;
}