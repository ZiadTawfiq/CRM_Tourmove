using CustomerRelationshipManagement.Entities;

public class LeadGroup
{
    public int LeadId { get; set; }
    public Lead Lead { get; set; } = null!;

    public int? GroupId { get; set; }
    public Group Group { get; set; } = null!;

    public string PhoneNumber { get; set; } = string.Empty;
}