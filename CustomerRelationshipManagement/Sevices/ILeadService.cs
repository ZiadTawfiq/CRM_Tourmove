using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.Sevices
{
    public interface ILeadService
    {
        Task<IEnumerable<LeadDto>> GetAllAsync();
        Task<LeadDto?> GetByIdAsync(int id);
        Task<LeadDto> CreateAsync(CreateLeadDto createLeadDto , int groupId);
        Task UpdateAsync(UpdateLeadDto updateLeadDto);
        Task DeleteAsync(int id);
        Task AssignLeadsToSalesRep(List<int> leadIds, int salesRepId);
        Task<List<LeadDto>> FilterLeads(LeadFilterDto filterDto);
        Task<List<LeadDto>> SearchByPhoneNumber(string phoneNumber);
        Task<List<LeadComparisonDto>> GetLeadsThatSalesTriedToDublicateByProject(List<int> ProjectIds ,DateTime? startDate, DateTime? endDate);
        Task UpdateLeadStatus(int leadId , Status status, CreateCommentDto notes);
        Task SaveChangesAsync(); 

    }
}
