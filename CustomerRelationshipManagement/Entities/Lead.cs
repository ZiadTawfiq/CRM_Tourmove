
namespace CustomerRelationshipManagement.Entities
{
    public class Lead
    {
        public int Id { get; set; }

        // Basic Information
        public string Name { get; set; } = string.Empty;

        public string PhoneNumber { get; set; } = string.Empty;

        public decimal? Budget { get; set; }

        // Project Relationship
        public List<ProjectLead> ProjectLeads { get; set; } = new List<ProjectLead>();

        // Employee Relationship
        public string? EmployeeId { get; set; }
        public Employee? Employee { get; set; }

        // Channel Relationship
        public int? ChannelId { get; set; }
        public Channel? Channel { get; set; }

        // Lead Status

        public Status Status { get; set; } = Status.FreshLead;

        public TypeLead TypeLead { get; set; }

        // Comments
        public ICollection<Comment> Comments { get; set; }
            = new List<Comment>();

        // Dates
        public DateTime Created { get; set; } = DateTime.UtcNow;

        public DateTime? Updated { get; set; }

        public DateTime? Assigned { get; set; }

        public DateTime? OrientationDate { get; set; }

        public DateTime? ReservationDate { get; set; }

        public DateTime? CancellationDate { get; set; }
        public DateTime? FollowUpDate { get; set; }

        // Cancellation Reason
        public int? CancellationReasonId { get; set; }

        public CancellationReason? CancellationReason { get; set; }

        // Duplicate Tracking
        public bool IsDuplicated { get; set; } = false;

        public ICollection<LeadGroup> LeadGroups { get; set; }
            = new List<LeadGroup>();
        public ICollection<LeadDuplicate> LeadDuplicates { get; set; }
            = new List<LeadDuplicate>();
    }
    
}
