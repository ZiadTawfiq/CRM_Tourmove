using CustomerRelationshipManagement.Dtos;

namespace CustomerRelationshipManagement.Sevices
{
    public interface IleadDuplicateService
    {
        Task DuplicateLead(int leadId);
        Task ReviewDuplicateLead(int duplicateLeadId , DuplicateAction action , string NewSalesRepId);
        Task<List<LeadComparisonDto>> ListDuplicateLeadsByProjectIdsAsync(List<int> projectIds, DateTime? startDate, DateTime? endDate);
    }
}
