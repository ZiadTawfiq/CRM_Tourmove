using CustomerRelationshipManagement.Dtos;

namespace CustomerRelationshipManagement.Sevices
{
    public interface ICommentService
    {
        Task<IEnumerable<CommentDto>> GetAllAsync();
        Task<CommentDto?> GetByIdAsync(int id);
        Task<IEnumerable<CommentDto>> GetByLeadIdAsync(int leadId);
        Task<CommentDto> CreateAsync(CreateCommentDto createCommentDto);
        Task UpdateAsync(UpdateCommentDto updateCommentDto);
        Task DeleteAsync(int id);
    }
}
