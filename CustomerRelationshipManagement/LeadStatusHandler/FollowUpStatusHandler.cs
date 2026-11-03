using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.LeadStatusHandler
{
    public class FollowUpStatusHandler : ILeadStatusHandler
    {
        public Status status => Status.FollowUp;
        public Task HandleAsync(Lead lead, string commentText)
        {
            if (lead.FollowUpDate == null)
            {
                lead.FollowUpDate = DateTime.UtcNow;
            }
            lead.Status = status;
            if (!string.IsNullOrEmpty(commentText))
            {
           
                    var comment = new Comment
                    {
                        LeadId = lead.Id,
                        EmployeeId = lead.EmployeeId,
                        Text = commentText,
                        CreatedAt = DateTime.UtcNow
                    };
                

            }

           
            return Task.CompletedTask;
        }
    
    }
}
