using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.LeadStatusHandler
{
    public class OrientationStatusHandler : ILeadStatusHandler
    {
        public Status status => Status.Orientation;

        public Task HandleAsync(Lead lead, string commentText)
        {

            if (lead.OrientationDate == null)
            {
                lead.OrientationDate = DateTime.UtcNow;
            }
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

            lead.Status = status;
            return Task.CompletedTask;
        }

      

    }
}
