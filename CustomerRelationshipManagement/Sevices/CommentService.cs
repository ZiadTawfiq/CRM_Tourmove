using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using CustomerRelationshipManagement.Repositories;

namespace CustomerRelationshipManagement.Sevices
{
    public class CommentService(ICommentRepository commentRepository) : ICommentService
    {
        public async Task<IEnumerable<CommentDto>> GetAllAsync()
        {
            var comments = await commentRepository.GetAllAsync();
            return comments.Select(MapToDto);
        }

        public async Task<CommentDto?> GetByIdAsync(int id)
        {
            var comment = await commentRepository.GetByIdAsync(id);
            return comment is null ? null : MapToDto(comment);
        }

        public async Task<IEnumerable<CommentDto>> GetByLeadIdAsync(int leadId)
        {
            var comments = await commentRepository.GetByLeadIdAsync(leadId);
            return comments.Select(MapToDto);
        }

        public async Task<CommentDto> CreateAsync(CreateCommentDto createCommentDto)
        {
            if (string.IsNullOrEmpty(createCommentDto.Text))
            {
                throw new ArgumentException("Comment text cannot be empty.");
            }
            var comment = new Comment
            {
                Text = createCommentDto.Text,
                EmployeeId = createCommentDto.EmployeeId,
                CreatedAt = DateTime.UtcNow,
                LeadId = createCommentDto.LeadId

            };
           
            await commentRepository.CreateAsync(comment);

            return MapToDto(comment);
        }

   
        public async Task DeleteAsync(int id)
        {
            await commentRepository.DeleteAsync(id);
        }

        private static CommentDto MapToDto(Comment comment)
        {
            return new CommentDto
            {
                Id = comment.Id,
                Text = comment.Text,
                CreatedAt = comment.CreatedAt,
                EmployeeId = comment.EmployeeId.ToString(),
                EmployeeName = comment.Employee?.Name,
                LeadId = comment.LeadId
            };
        }

        public async Task<IEnumerable<CommentDto>> GetCommentsByLeadIdAsync(int leadId)
        {
           
            var comments = await commentRepository.GetByLeadIdAsync(leadId);
            return comments.Select(MapToDto);

        }
    }
}
