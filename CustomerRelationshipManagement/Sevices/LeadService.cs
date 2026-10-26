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

        public Task<IEnumerable<LeadDto>> GetAllAsync()
        {
            throw new NotImplementedException();
        }

        public Task<LeadDto?> GetByIdAsync(int id)
        {
            throw new NotImplementedException();
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
            await repository.UpdateAsync(updateLeadDto);
        }

        public Task UpdateLeadStatus(int leadId)
        {
            throw new NotImplementedException();
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
                EmployeeName = lead.Employee?.Name,
                Budget = lead.Budget,
                TypeLead = lead.TypeLead,
                Created = lead.Created,
                Updated = lead.Updated,

            };
        }
    }
}
