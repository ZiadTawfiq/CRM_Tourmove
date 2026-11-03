using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.LeadStatusHandler
{
    public class OrientationStatusHandler
    {
        public Status status => Status.Orientation;
        public async Task HandleStatusChangeAsync(Lead lead)
        {
            if (lead.OrientationDate == null)
            {
                lead.OrientationDate = DateTime.UtcNow;
            }
            lead.Status = status;
        }

    }
}
