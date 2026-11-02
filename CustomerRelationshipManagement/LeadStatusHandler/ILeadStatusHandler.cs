using CustomerRelationshipManagement.Entities;

namespace CustomerRelationshipManagement.LeadStatusHandler
{
    public interface ILeadStatusHandler
    {
        Status status { get; }
        Task HandleAsync(Lead lead); 
    }
}
