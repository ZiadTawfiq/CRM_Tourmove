using CustomerRelationshipManagement.Repositories;

namespace CustomerRelationshipManagement.Sevices
{
    public class LeadAssignmentService(ILeadRepository repository) : ILeadAssignmentService
    {
        public async Task Assign(List<int> leadsId, int salesRepId)
        {
         
            var leads = await repository.GetLeadsByIdsAsync(leadsId);

            foreach (var lead in leads)
            {
                lead.EmployeeId = salesRepId.ToString();
            }
            await repository.SaveChangesAsync();
        }
    
    }
}
