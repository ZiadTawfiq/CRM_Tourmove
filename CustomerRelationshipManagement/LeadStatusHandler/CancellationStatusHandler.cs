using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.LeadStatusHandler
{
    public class CancellationStatusHandler : ILeadStatusHandler
    {
        public Status status => Status.Cancellation;

        public Task HandleAsync(Lead lead)
        {

            if (lead.CancellationReasonId == null)
            {
                throw new ArgumentException("Cancellation reason is required for cancellation status.");
            }
            lead.CancellationDate = DateTime.UtcNow;
            lead.Status = status;

            return Task.CompletedTask;
        }
    }
}
