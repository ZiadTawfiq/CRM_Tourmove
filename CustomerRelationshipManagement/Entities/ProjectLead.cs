namespace CustomerRelationshipManagement.Entities
{
    public class ProjectLead
    {
        public int ProjectId { get; set; }
        public Project Project { get; set; } = null!;
        public int LeadId { get; set; }
        public Lead Lead { get; set; } = null!;

    }
}
