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
            var comment = new Comment();
           

            if (int.TryParse(createCommentDto.EmployeeId, out var empId))
            {
                comment.EmployeeId = empId;
            }
            
            comment.LeadId = createCommentDto.LeadId;
           
            await commentRepository.CreateAsync(comment);

            return MapToDto(comment);
        }

        public async Task UpdateAsync(UpdateCommentDto updateCommentDto)
        {
            await commentRepository.UpdateAsync(updateCommentDto);
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
                LastUpdated = comment.LastUpdated,
                EmployeeId = comment.EmployeeId.ToString(),
                EmployeeName = comment.Employee?.Name,
                LeadId = comment.LeadId
            };
        }
    }
}
