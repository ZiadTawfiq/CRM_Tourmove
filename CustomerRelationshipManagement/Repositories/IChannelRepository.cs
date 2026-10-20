using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.Repositories
{
    public interface IChannelRepository
    {
        Task CreateAsync(Channel channel);
        Task UpdateAsync(Channel channel);
        Task DeleteAsync(int id);
        Task<Channel?> GetByIdAsync(int id);
        Task<IEnumerable<Channel>> GetAllAsync();
    }
}