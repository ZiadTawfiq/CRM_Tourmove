using CustomerRelationshipManagement.Dtos;

namespace CustomerRelationshipManagement.Sevices
{
    public interface IChannelService
    {
        Task<IEnumerable<ChannelDto>> GetAllAsync();
        Task<ChannelDto?> GetByIdAsync(int id);
        Task<ChannelDto> CreateAsync(CreateChannelDto createChannelDto);
        Task UpdateAsync(UpdateChannelDto updateChannelDto);
        Task DeleteAsync(int id);
    }
}
