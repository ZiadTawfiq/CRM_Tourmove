using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using Microsoft.EntityFrameworkCore;

namespace CustomerRelationshipManagement.Repositories
{
    public class CommentRepository(AppDbContext dbContext) : ICommentRepository
    {
        public async Task CreateAsync(Comment comment)
        {
            comment.CreatedAt = DateTime.UtcNow;
            comment.LastUpdated = DateTime.UtcNow;
            dbContext.Comments.Add(comment);
            await dbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var existingComment = await dbContext.Comments.FindAsync(id);
            if (existingComment == null)
            {
                throw new KeyNotFoundException($"Comment with id {id} not found!");
            }
            dbContext.Comments.Remove(existingComment);
            await dbContext.SaveChangesAsync();
        }

        public async Task<IEnumerable<Comment>> GetAllAsync()
        {
            return await dbContext.Comments.ToListAsync();
        }

        public async Task<Comment?> GetByIdAsync(int id)
        {
            var comment = await dbContext.Comments.FirstOrDefaultAsync(c => c.Id == id);
            if (comment is null)
            {
                throw new KeyNotFoundException($"Comment with id {id} not found");
            }
            return comment;
        }

        public async Task<IEnumerable<Comment>> GetByLeadIdAsync(int leadId)
        {
            return await dbContext.Comments
                .Where(c => c.LeadId == leadId)
                .ToListAsync();
        }

      
    }
}
