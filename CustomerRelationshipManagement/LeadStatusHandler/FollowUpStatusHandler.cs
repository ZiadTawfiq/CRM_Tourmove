using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using CustomerRelationshipManagement.Sevices;

namespace CustomerRelationshipManagement.LeadStatusHandler
{
    public class FollowUpStatusHandler(ICommentService commentService) : ILeadStatusHandler
    {
        public Status status => Status.FollowUp;
        public async Task HandleAsync(Lead lead, CreateCommentDto createCommentDto)
        {
            if (lead.FollowUpDate == null)
            {
                lead.FollowUpDate = DateTime.UtcNow;
            }
            lead.Status = status;

            await commentService.CreateAsync(createCommentDto);
        }
    
    }
}
