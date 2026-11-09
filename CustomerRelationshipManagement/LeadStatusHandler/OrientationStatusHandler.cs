using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using CustomerRelationshipManagement.Sevices;

namespace CustomerRelationshipManagement.LeadStatusHandler
{
    public class OrientationStatusHandler(ICommentService commentService) : ILeadStatusHandler
    {
        public Status status => Status.Orientation;

        public async Task HandleAsync(Lead lead, CreateCommentDto createCommentDto)
        {

            if (lead.OrientationDate == null)
            {
                lead.OrientationDate = DateTime.UtcNow;
            }
            lead.Status = status;

            await commentService.CreateAsync(createCommentDto);
        }

      

    }
}       
