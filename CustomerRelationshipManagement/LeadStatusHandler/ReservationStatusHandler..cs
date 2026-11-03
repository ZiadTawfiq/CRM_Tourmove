using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.LeadStatusHandler
{
    public class ReservationStatusHandler : ILeadStatusHandler
    {
        public Status status => Status.Reservation;

        public Task HandleAsync(Lead lead, string commentText)
        {
            if (lead.ReservationDate == null)
            {
                lead.ReservationDate = DateTime.UtcNow;
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
