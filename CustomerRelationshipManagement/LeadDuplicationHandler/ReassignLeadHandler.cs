using CustomerRelationshipManagement.Repositories;
using CustomerRelationshipManagement.Sevices;

namespace CustomerRelationshipManagement.LeadDuplicationHandler
{
    public class ReassignLeadHandler(ILeadDuplicateRepository leadDuplicateRepository, ILeadService leadService)
    {
        public DuplicateAction Action => DuplicateAction.ReassignToAnotherSalesRep;
        public async Task HandleDuplicateLead(int duplicateLeadId, string newSalesRepId)
        {
           var duplicateLead = await leadDuplicateRepository.GetByIdAsync(duplicateLeadId);
            if (duplicateLead == null)
            {
                throw new Exception("Duplicate lead not found.");
            }

            if (duplicateLead.Status != DuplicateStatus.Pending)
                throw new InvalidOperationException(
                    "Duplicate request already processed.");

            var leadId = duplicateLead.LeadId;

            var lead = await leadService.GetByIdAsync(leadId);
            if (lead == null)
            {
                throw new Exception("Lead not found.");
            }
            lead.EmployeeId = newSalesRepId;
         
            duplicateLead.Status = DuplicateStatus.Reassigned;
           
            lead.Assigned = DateTime.UtcNow;

            await leadService.SaveChangesAsync();


        }
    }
}
