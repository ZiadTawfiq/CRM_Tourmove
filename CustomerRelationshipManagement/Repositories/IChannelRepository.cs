using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.Repositories
{
    public interface IChannelRepository
    {
        Task CreateAsync(Channel channel);
        Task UpdateAsync(UpdateChannelDto updateChannelDto);
        Task DeleteAsync(int id);
        Task<Channel?> GetByIdAsync(int id);
        Task<IEnumerable<Channel>> GetAllAsync();
    }
}