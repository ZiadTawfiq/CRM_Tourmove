using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.Repositories
{
    public interface ICommentRepository
    {
        Task CreateAsync(Comment comment);
        Task UpdateAsync(Comment comment);
        Task DeleteAsync(int id);
        Task<Comment?> GetByIdAsync(int id);
        Task<IEnumerable<Comment>> GetAllAsync();
        Task<IEnumerable<Comment>> GetByLeadIdAsync(int leadId);
    }
}
