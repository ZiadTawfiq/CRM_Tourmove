using CustomerRelationshipManagement.Entities;

public class LeadDuplicate
{
    public int Id { get; set; }

    // الـ Lead الأصلي
    public int LeadId { get; set; }
    public Lead Lead { get; set; } = null!;

    // الـ Lead الجديد لو تم إنشاؤه فعلاً
    public int? DuplicateLeadId { get; set; }
    public Lead? DuplicateLead { get; set; }

    // الموظف اللي حاول يعمل Duplicate
    public string AttemptedByEmployeeId { get; set; } = null!;
    public Employee AttemptedByEmployee { get; set; } = null!;

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public DuplicateStatus Status { get; set; }
}

public enum DuplicateStatus
{
        Pending,
        Created,
        Reassigned,
}
public enum DuplicateAction
{
    CreateNewLead,
    ReassignToAnotherSalesRep,
}



