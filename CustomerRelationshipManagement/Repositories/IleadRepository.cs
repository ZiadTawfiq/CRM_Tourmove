using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.Repositories
{
    public interface ILeadRepository
    {
        Task CreateAsync(Lead lead);
        Task UpdateAsync(UpdateLeadDto updateLeadDto);
        Task DeleteAsync(int id);
        Task<Lead?> GetByIdAsync(int id);
        Task<IEnumerable<Lead>> GetAllAsync();
        Task<List<Lead>> SearchByPhoneNumber(string phoneNumber);
        Task<List<Lead>> GetLeadsByIdsAsync(List<int> leadIds);
        Task SaveChangesAsync();
        Task<Lead?> GetLeadByPhoneNumberAndGroupId(string phoneNumber, int groupId);
        Task<List<Comment>> GetCommentsForLead(int leadId);
        Task<List<Lead>> FilterLeadsAsync(LeadFilterDto filterDto);

    }
}
