using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.Dtos
{
    public class LeadFilterDto
    {
        public string? PhoneNumber { get; set; }
        public List<Status>? Status { get; set; }
        public string? TypeLead { get; set; }
        public List<int>? ProjectId { get; set; }
        public List<int>? ChannelId { get; set; }
        public List<string>? EmployeeIds { get; set; }
        public DateTime? CreatedFrom { get; set; }
        public DateTime? CreatedTo { get; set; }
        public DateTime? AssignedFrom { get; set; }
        public DateTime? AssignedTo { get; set; }
    }
}
