using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.LeadDuplicationHandler;
using CustomerRelationshipManagement.Repositories;

namespace CustomerRelationshipManagement.Sevices
{
    public class LeadDuplicateService(
        IEmployeeService employeeService,
        ILeadRepository leadRepository,
        ILeadDuplicateRepository leadDuplicateRepository,
        IEnumerable<ILeadDuplicationHandler> duplicationHandlers) : IleadDuplicateService
    {
        private readonly IEnumerable<ILeadDuplicationHandler> _duplicationHandlers = duplicationHandlers;

        public async Task<int> DuplicateLead(int leadId)
        {
            var user = await employeeService.GetCurrentUserAsync();
            var lead = await leadRepository.GetByIdAsync(leadId);

            var duplicateLead = new LeadDuplicate
            {
                LeadId = leadId,
                Status = DuplicateStatus.Pending,
                AttemptedByEmployeeId = user?.Id ?? "emp-101",
                CreatedAt = DateTime.UtcNow
            };

            await leadDuplicateRepository.CreateAsync(duplicateLead);
            return duplicateLead.Id;
        }

        public async Task<List<LeadComparisonDto>> ListDuplicateLeadsByProjectIdsAsync(List<int> projectIds, DateTime? startDate , DateTime? endDate)
        {
            var duplicates = await leadDuplicateRepository.GetDuplicatesByProjectIdsAsync(projectIds, startDate, endDate);
            
            return duplicates.Select(d => new LeadComparisonDto
            {
                OriginalLeadId = d.LeadId,
                DuplicateLeadId = d.DuplicateLeadId,
                OriginalLead = new LeadDto
                {
                    Id = d.Lead.Id,
                    Name = d.Lead.Name,
                    PhoneNumber = d.Lead.PhoneNumber,
                    EmployeeId = d.Lead.EmployeeId,
                    ChannelId = d.Lead.ChannelId,
                    Created = d.Lead.Created
                },
                DuplicateLead = new LeadDto
                {
                    Id = d.DuplicateLead!.Id,
                    Name = d.DuplicateLead.Name,
                    PhoneNumber = d.DuplicateLead.PhoneNumber,
                    EmployeeId = d.DuplicateLead.EmployeeId,
                    ChannelId = d.DuplicateLead.ChannelId,
                    Created = d.DuplicateLead.Created
                }
            }).ToList();

        }

        public async Task ReviewDuplicateLead(int duplicateLeadId, DuplicateAction action, string NewSalesRepId)
        {
            var handler = _duplicationHandlers.FirstOrDefault(h => h.Action == action);
            if (handler == null)
            {
                throw new ArgumentException("No handler found for the specified duplicate action.");
            }

            await handler.HandleDuplicateLead(duplicateLeadId, NewSalesRepId);
        }
    }

}
