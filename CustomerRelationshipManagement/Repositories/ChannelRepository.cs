using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using Microsoft.EntityFrameworkCore;

namespace CustomerRelationshipManagement.Repositories
{
    public class ChannelRepository(AppDbContext dbContext) : IChannelRepository
    {
        public async Task CreateAsync(Channel channel)
        {
            dbContext.Channels.Add(channel);
            await dbContext.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            var existingChannel = await dbContext.Channels.FindAsync(id);
            if (existingChannel == null)
            {
                throw new KeyNotFoundException($"Channel with id {id} not found!");
            }
            dbContext.Channels.Remove(existingChannel);
            await dbContext.SaveChangesAsync();
        }

        public async Task<IEnumerable<Channel>> GetAllAsync()
        {
            return await dbContext.Channels.In.ToListAsync();
        }

        public async Task<Channel?> GetByIdAsync(int id)
        {
            var channel = await dbContext.Channels.FirstOrDefaultAsync(_ => _.Id == id);
            if (channel is null)
            {
                throw new KeyNotFoundException($"Channel with id {id} not found");
            }
            return channel;
        }

        public async Task UpdateAsync(UpdateChannelDto updateChannelDto)
        {
            var existingChannel = await dbContext.Channels.FindAsync(updateChannelDto.Id);
            if (existingChannel is null)
            {
                throw new KeyNotFoundException($"Channel with id {updateChannelDto.Id} not found");
            }

            existingChannel.Name = updateChannelDto.Name;

            await dbContext.SaveChangesAsync();
        }
    }
}
