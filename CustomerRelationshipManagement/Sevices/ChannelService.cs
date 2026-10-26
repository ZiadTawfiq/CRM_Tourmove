using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using CustomerRelationshipManagement.Repositories;

namespace CustomerRelationshipManagement.Sevices
{
    public class ChannelService(IChannelRepository channelRepository) : IChannelService
    {
        public async Task<IEnumerable<ChannelDto>> GetAllAsync()
        {
            var channels = await channelRepository.GetAllAsync();
            return channels.Select(c => new ChannelDto
            {
                Id = c.Id,
                Name = c.Name,
                LeadsCount = c.Leads?.Count ?? 0
            });
        }

        public async Task<ChannelDto?> GetByIdAsync(int id)
        {
            var channel = await channelRepository.GetByIdAsync(id);
            if (channel is null)
            {
                return null;
            }

            return new ChannelDto
            {
                Id = channel.Id,
                Name = channel.Name,
                LeadsCount = channel.Leads?.Count ?? 0
            };
        }

        public async Task<ChannelDto> CreateAsync(CreateChannelDto createChannelDto)
        {
            var channel = new Channel
            {
                Name = createChannelDto.Name
            };

            await channelRepository.CreateAsync(channel);

            return new ChannelDto
            {
                Id = channel.Id,
                Name = channel.Name,
                LeadsCount = 0
            };
        }

        public async Task UpdateAsync(UpdateChannelDto updateChannelDto)
        {
            await channelRepository.UpdateAsync(updateChannelDto);
        }

        public async Task DeleteAsync(int id)
        {
            await channelRepository.DeleteAsync(id);
        }
    }
}
