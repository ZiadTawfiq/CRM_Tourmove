namespace CustomerRelationshipManagement.Dtos
{
    public class LeadComparisonDto
    {
        public int OriginalLeadId { get; set; }
        public int? DuplicateLeadId { get; set; }

        public LeadDto OriginalLead { get; set; } = null!;
        public LeadDto DuplicateLead { get; set; } = null!;
    }
}
