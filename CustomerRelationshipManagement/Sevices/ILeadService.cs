using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.Sevices
{
    public interface ILeadService
    {
        Task AssignLeadToSalesRep(int leadId, int salesRepId);
        Task DuplicateLead(int leadId);
        Task<List<CommentDto>> GetCommentsForLead(int leadId);
        Task<List<LeadDto>> FilterLeads(LeadFilterDto filterDto);
        Task<List<LeadDto>> SearchByPhoneNumber(string phoneNumber);
        Task AddActionToLead(ActionDto actionDto);
        Task<List<LeadDto>> GetLeadsThatSalesTriedToDublicate();






    }
}
