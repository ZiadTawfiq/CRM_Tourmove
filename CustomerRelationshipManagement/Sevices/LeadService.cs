using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using CustomerRelationshipManagement.Repositories;

namespace CustomerRelationshipManagement.Sevices
{
    public class LeadService(ILeadRepository repository) : ILeadService
    {
        public Task AddActionToLead(ActionDto actionDto)
        {
            throw new NotImplementedException();
        }

        public Task AssignLeadToSalesRep(int leadId, int salesRepId)
        {
            throw new NotImplementedException();
        }

        public Task<LeadDto> CreateAsync(CreateLeadDto createLeadDto)
        {
            throw new NotImplementedException();
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

        public Task<List<LeadDto>> SearchByPhoneNumber(string phoneNumber)
        {
            throw new NotImplementedException();
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

        public async Task UpdateLeadStatus(int leadId , Status status)
        {
           var lead = await repository.GetByIdAsync(leadId);
            if (lead == null)
            {
                throw new Exception($"Lead with ID {leadId} not found.");
            }
            if ()
            
            
        }
        private static LeadDto MapToDto(Lead lead)
        {
            return new LeadDto
            {
                Id = lead.Id,
                Name = lead.Name,
                PhoneNumber = lead.PhoneNumber,
                Status = lead.Status,
                ProjectName = lead.Project.Name,
                ChannelName = lead.Channel.Name,
                EmployeeName = lead.Employee?.FullName,
                Budget = lead.Budget,
                TypeLead = lead.TypeLead,
                Created = lead.Created,
                Updated = lead.Updated,

            };
        }
    }
}
