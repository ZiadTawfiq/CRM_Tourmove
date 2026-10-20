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
            var existingChannel = await dbContext.Channels.FirstOrDefaultAsync(_ => _.Id == id);
            if (existingChannel == null)
            {
                throw new Exception($"Channel with id {id} not found!");
            }
            dbContext.Channels.Remove(existingChannel);
            await dbContext.SaveChangesAsync();
        }

        public async Task<IEnumerable<Channel>> GetAllAsync()
        {
            return await dbContext.Channels.ToListAsync();
        }

        public async Task<Channel?> GetByIdAsync(int id)
        {
            var channel = await dbContext.Channels.FirstOrDefaultAsync(_ => _.Id == id);
            if (channel is null)
            {
                throw new Exception($"Channel with id {id} not found");
            }
            return channel;
        }

        public async Task UpdateAsync(Channel channel)
        {
            var existingChannel = await dbContext.Channels.FirstOrDefaultAsync(_ => _.Id == channel.Id);
            if (existingChannel is null)
            {
                throw new Exception($"Channel with id {channel.Id} not found");
            }

            existingChannel.Name = channel.Name;

            dbContext.Channels.Update(existingChannel);
            await dbContext.SaveChangesAsync();
        }
    }
}
