using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.Dtos
{
    public class LeadDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;
        public int ProjectId { get; set; }
        public string? ProjectName { get; set; }
        public string? EmployeeId { get; set; }
        public string? EmployeeName { get; set; }
        public int? ChannelId { get; set; }
        public string? ChannelName { get; set; }
        public decimal? Budget { get; set; }
        public Status Status { get; set; }
        public TypeLead TypeLead { get; set; }
        public DateTime Created { get; set; }
        public DateTime Updated { get; set; }
        public DateTime? Assigned { get; set; }
        public List<CommentDto>? Comments { get; set; }
    }

    public class CreateLeadDto
    {
        public string Name { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;
        public int ProjectId { get; set; }
        public string? EmployeeId { get; set; }
        public int? ChannelId { get; set; }
        public decimal? Budget { get; set; }
        public Status Status { get; set; } = Status.FreshLead;
        public TypeLead TypeLead { get; set; }
    }

    public class UpdateLeadDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string PhoneNumber { get; set; } = string.Empty;
        public int? ProjectId { get; set; }
        public string? EmployeeId { get; set; }
        public int? ChannelId { get; set; }
        public decimal? Budget { get; set; }
        public Status Status { get; set; }
        public TypeLead TypeLead { get; set; }
    }
}
