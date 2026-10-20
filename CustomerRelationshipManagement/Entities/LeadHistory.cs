namespace CustomerRelationshipManagement.Entities
{
    public enum LeadHistoryAction
    {
        AssignedToSalesRep,
        ChannelChanged,
        ProjectChanged,
        StatusChanged,
        TypeChanged
    }

    public class LeadHistory
    {
        public int Id { get; set; }

        public int LeadId { get; set; }
        public Lead Lead { get; set; } = null!;

        public LeadHistoryAction Action { get; set; }

        public string? OldValue { get; set; }
        public string? NewValue { get; set; }

        public string ChangedByEmployeeId { get; set; } = null!;
        public Employee ChangedByEmployee { get; set; } = null!;

        public DateTime ChangedAt { get; set; }
    }
}