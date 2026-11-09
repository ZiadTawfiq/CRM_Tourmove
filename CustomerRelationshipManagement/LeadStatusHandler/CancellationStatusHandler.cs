using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using CustomerRelationshipManagement.Sevices;

namespace CustomerRelationshipManagement.LeadStatusHandler
{
    public class CancellationStatusHandler(ICommentService commentService) : ILeadStatusHandler
    {
        public Status status => Status.Cancellation;

        public async Task HandleAsync(Lead lead, CreateCommentDto createCommentDto)
        {

            if (lead.CancellationReasonId == null)
            {
                throw new ArgumentException("Cancellation reason is required for cancellation status.");
            }
            lead.CancellationDate = DateTime.UtcNow;
            lead.Status = status;
            await commentService.CreateAsync(createCommentDto);

        }
    }
}
