using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using CustomerRelationshipManagement.LeadStatusHandler;
using CustomerRelationshipManagement.Repositories;

namespace CustomerRelationshipManagement.Sevices
{
    public class LeadService(ILeadRepository repository , IEnumerable<ILeadStatusHandler> statusHandlers) : ILeadService
    {
        private readonly IEnumerable<ILeadStatusHandler> _statusHandlers = statusHandlers;
      

        public async Task AssignLeadsToSalesRep(List<int> leadIds, int salesRepId)
        {
            var leads = await repository.GetLeadsByIdsAsync(leadIds);

            foreach (var lead in leads)
            {
                lead.EmployeeId = salesRepId.ToString();
            }
            await repository.SaveChangesAsync();
        }

        public Task<LeadDto> CreateAsync(CreateLeadDto createLeadDto)
        {
           
        }

        public async Task DeleteAsync(int id)
        {
            await repository.DeleteAsync(id);
        }

        public Task DuplicateLead(int leadId)
        {
            throw new NotImplementedException();
        }

        public Task<List<LeadDto>> FilterLeads(LeadFilterDto filterDto)
        {
            throw new NotImplementedException();
        }

        public async Task<IEnumerable<LeadDto>> GetAllAsync()
        {
           var leads = await repository.GetAllAsync();
            return leads.Select(MapToDto);
        }

        public async Task<LeadDto?> GetByIdAsync(int id)
        {
            var lead = await repository.GetByIdAsync(id);
            return lead != null ? MapToDto(lead) : null;
        }

        public Task<List<CommentDto>> GetCommentsForLead(int leadId)
        {
            throw new NotImplementedException();
        }

        public Task<List<LeadDto>> GetLeadsThatSalesTriedToDublicateByProject(List<int> ProjectIds)
        {
            throw new NotImplementedException();
        }

        public async Task<List<LeadDto>> SearchByPhoneNumber(string phoneNumber)
        {
            var leads = await  repository.SearchByPhoneNumber(phoneNumber);
           
            return leads.Select(MapToDto).ToList();
        }

        public async Task UpdateAsync(UpdateLeadDto updateLeadDto)
        {
            var lead = await repository.GetByIdAsync(updateLeadDto.Id);
            if (lead == null)
            {
                throw new Exception($"Lead with ID {updateLeadDto.Id} not found.");
            }
            await repository.UpdateAsync(updateLeadDto);
        }

        public async Task UpdateLeadStatus(int leadId , Status status, string? notes = null)
        {
           var lead = await repository.GetByIdAsync(leadId);
            if (lead == null)
            {
                throw new Exception($"Lead with ID {leadId} not found.");
            }
            var statusHandler = _statusHandlers.FirstOrDefault(h => h.status == status);
            if (statusHandler == null)
            {
                throw new Exception($"No handler found for status {status}.");
            }
            await statusHandler.HandleAsync(lead, notes);
            await repository.SaveChangesAsync();

        }
        private static LeadDto MapToDto(Lead lead)
        {   
            
            return new LeadDto
            {
                Id = lead.Id,
                Name = lead.Name,
                PhoneNumber = lead.PhoneNumber,
                Status = lead.Status,
                ProjectNames = lead.ProjectLeads
                .Select(lp => lp.Project.Name)
                .ToList(),
                ChannelName = lead.Channel?.Name,
                EmployeeName = lead.Employee?.Name,
                Budget = lead.Budget,
                TypeLead = lead.TypeLead,
                Created = lead.Created,

            };
        }
    }
}
