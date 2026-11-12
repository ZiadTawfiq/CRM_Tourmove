namespace CustomerRelationshipManagement.LeadDuplicationHandler
{
    public interface ILeadDuplicationHandler
    {
        Task HandleDuplicateLead(int leadId, DuplicateAction action, string newSalesRepId);
    }
}
