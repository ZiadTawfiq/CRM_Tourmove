using CustomerRelationshipManagement.Entities;
using Microsoft.EntityFrameworkCore;

namespace CustomerRelationshipManagement.Repositories
{
    public class CommentRepository(AppDbContext dbContext) : ICommentRepository
    {
        public async Task CreateAsync(Comment comment)
        {
            comment.CreatedAt = DateTime.UtcNow;
            dbContext.Comments.Add(comment);
            await dbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var existingComment = await dbContext.Comments.FirstOrDefaultAsync(_ => _.Id == id);
            if (existingComment == null)
            {
                throw new Exception($"Comment with id {id} not found!");
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
            var comment = await dbContext.Comments.FirstOrDefaultAsync(_ => _.Id == id);
            if (comment is null)
            {
                throw new Exception($"Comment with id {id} not found");
            }
            return comment;
        }

        public async Task<IEnumerable<Comment>> GetByLeadIdAsync(int leadId)
        {
            return await dbContext.Comments
                .Where(c => c.LeadId == leadId)
                .ToListAsync();
        }

        public async Task UpdateAsync(Comment comment)
        {
            var existingComment = await dbContext.Comments.FirstOrDefaultAsync(_ => _.Id == comment.Id);
            if (existingComment is null)
            {
                throw new Exception($"Comment with id {comment.Id} not found");
            }

            existingComment.Text = comment.Text;
            existingComment.LastUpdated = DateTime.UtcNow;

            dbContext.Comments.Update(existingComment);
            await dbContext.SaveChangesAsync();
        }
    }
}
