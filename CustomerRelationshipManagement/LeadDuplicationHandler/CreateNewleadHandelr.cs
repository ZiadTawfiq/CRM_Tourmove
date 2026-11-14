using CustomerRelationshipManagement.Entities;
using CustomerRelationshipManagement.Repositories;
using CustomerRelationshipManagement.Sevices;

namespace CustomerRelationshipManagement.LeadDuplicationHandler
{
    public class CreateNewleadHandelr(ILeadDuplicateRepository leadDuplicateRepository ,ILeadRepository leadRepository, IEmployeeService employeeService ) : ILeadDuplicationHandler
    {
        public DuplicateAction Action => DuplicateAction.CreateNewLead;

        public async Task HandleDuplicateLead(int DuplicateLeadId,string newSalesRepId)
        {
            var duplicateLead = await leadDuplicateRepository.GetByIdAsync(DuplicateLeadId);


            if (duplicateLead == null)
            {
                throw new InvalidOperationException(
                  "Duplicate request already processed.");

            }
            if (duplicateLead.Status != DuplicateStatus.Pending)
            {
                throw new ArgumentException($"Lead with ID {DuplicateLeadId} is not a duplicate.");
            }
            var Rep = await employeeService.GetByIdAsync(newSalesRepId);
            if (Rep == null)
            {
                throw new ArgumentException($"Sales representative with ID {newSalesRepId} not found.");
            }
            var lead = await leadRepository.GetByIdAsync(duplicateLead.LeadId);
            if (lead == null)
            {
                throw new ArgumentException($"Lead with ID {duplicateLead.LeadId} not found.");
            }

          var newLead = new Lead
            {
                Name = lead.Name,
                PhoneNumber = lead.PhoneNumber,
                Budget = lead.Budget,
                ChannelId = lead.ChannelId,
                TypeLead = lead.TypeLead,

                EmployeeId = newSalesRepId,

                Status = Status.FreshLead,
                Created = DateTime.UtcNow,
                Assigned = DateTime.UtcNow,

                LeadGroups = lead.LeadGroups.Select(x => new LeadGroup
                {
                    GroupId = x.GroupId,
                    PhoneNumber = x.PhoneNumber
                }).ToList(),

                ProjectLeads = lead.ProjectLeads.Select(x => new ProjectLead
                {
                    ProjectId = x.ProjectId,

                }).ToList()
            };

            await leadRepository.CreateAsync(newLead);

            duplicateLead.Status = DuplicateStatus.Created;
            duplicateLead.DuplicateLeadId = newLead.Id;

            await leadDuplicateRepository.SaveChangesAsync();
        }
    }
}
