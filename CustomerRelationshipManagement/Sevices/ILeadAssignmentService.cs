namespace CustomerRelationshipManagement.Sevices
{
    public interface ILeadAssignmentService
    {
        Task Assign(List<int> leads, int salesRepId);
    }
}
