namespace CustomerRelationshipManagement.Sevices
{
    public interface IleadDuplicateService
    {
        Task DuplicateLead(int leadId);
        Task ReviewDuplicateLead(int duplicateLeadId , DuplicateAction action , string NewSalesRepId);
    }
}
