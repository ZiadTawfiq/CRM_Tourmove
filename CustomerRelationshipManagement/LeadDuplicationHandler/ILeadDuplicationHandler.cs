namespace CustomerRelationshipManagement.LeadDuplicationHandler
{
    public interface ILeadDuplicationHandler
    {
        public DuplicateAction Action { get; }
        Task HandleDuplicateLead(int leadId,string newSalesRepId);
    }
}
