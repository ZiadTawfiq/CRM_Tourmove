using CustomerRelationshipManagement.Repositories;

namespace CustomerRelationshipManagement.Sevices
{
    public class LeadDuplicateService(IEmployeeService employeeService ,ILeadService leadService , ILeadDuplicateRepository leadDuplicateRepository) : IleadDuplicateService
    {
        public async Task DuplicateLead(int leadId)
        {
            var user = await employeeService.GetCurrentUserAsync();
            var lead = await leadService.GetByIdAsync(leadId);

            var duplicateLead = new LeadDuplicate
            {
                LeadId = leadId,
                Status = DuplicateStatus.Pending,
                AttemptedByEmployeeId = user.Id,
                CreatedAt = DateTime.UtcNow
            };

            await leadDuplicateRepository.CreateAsync(duplicateLead);

        }

        public Task ReviewDuplicateLead(int duplicateLeadId, DuplicateAction action, string NewSalesRepId)
        {
            


        }
    }
}
