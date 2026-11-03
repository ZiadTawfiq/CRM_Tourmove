using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.LeadStatusHandler
{
    public class ReservationStatusHandler : ILeadStatusHandler
    {
        public Status status => Status.Reservation;

        public Task HandleAsync(Lead lead)
        {
            if (lead.ReservationDate == null)
            {
                lead.ReservationDate = DateTime.UtcNow;
            }
            lead.Status = status;
            return Task.CompletedTask;
        }

      
    }
}
