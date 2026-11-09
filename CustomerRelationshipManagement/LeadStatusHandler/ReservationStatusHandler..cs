using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using CustomerRelationshipManagement.Sevices;

namespace CustomerRelationshipManagement.LeadStatusHandler
{
    public class ReservationStatusHandler(ICommentService commentService) : ILeadStatusHandler
    {
        public Status status => Status.Reservation;

        public async Task HandleAsync(Lead lead, CreateCommentDto createCommentDto)
        {
            if (lead.ReservationDate == null)
            {
                lead.ReservationDate = DateTime.UtcNow;
            }
            lead.Status = status;

            await commentService.CreateAsync(createCommentDto);

        }

      
    }
}
