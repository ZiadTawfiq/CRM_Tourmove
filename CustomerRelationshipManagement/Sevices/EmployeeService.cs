using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System.Security.Claims;

namespace CustomerRelationshipManagement.Sevices
{
    public class EmployeeService(
        UserManager<Employee> userManager,
        RoleManager<IdentityRole> roleManager, IHttpContextAccessor httpContextAccessor) : IEmployeeService
    {
        public async Task<IEnumerable<EmployeeDto>> GetAllAsync()
        {
            var employees = await userManager.Users.ToListAsync();
            var result = new List<EmployeeDto>();

            foreach (var emp in employees)
            {
                var roles = await userManager.GetRolesAsync(emp);
                result.Add(MapToDto(emp, roles.FirstOrDefault()));
            }

            return result;
        }

        public async Task<EmployeeDto?> GetByIdAsync(string id)
        {
            var employee = await userManager.FindByIdAsync(id);
            if (employee is null)
            {
                return null;
            }

            var roles = await userManager.GetRolesAsync(employee);
            return MapToDto(employee, roles.FirstOrDefault());
        }

        public async Task<EmployeeDto> CreateAsync(CreateEmployeeDto createEmployeeDto)
        {
            var employee = new Employee
            {
                Email = createEmployeeDto.Email,
                Name = createEmployeeDto.FullName,
            };
            var CreateResult = await userManager.CreateAsync(employee, createEmployeeDto.Password);
            var roleName = createEmployeeDto.Role.ToString();
            var roleExists = await roleManager.RoleExistsAsync(roleName);
            if (!roleExists)
            {
                throw new InvalidOperationException($"Role '{roleName}' does not exist.");
            }
            var addToRoleResult = await userManager.AddToRoleAsync(employee, roleName);
            return MapToDto(employee, roleName);
        }

        public async Task UpdateAsync(UpdateEmployeeDto updateEmployeeDto)
        {
            var employee = await userManager.FindByIdAsync(updateEmployeeDto.Id);
            if (employee is null)
            {
                throw new KeyNotFoundException($"Employee with id {updateEmployeeDto.Id} not found");
            }

            employee.Name = updateEmployeeDto.FullName;
            employee.Email = updateEmployeeDto.Email;
            employee.UserName = updateEmployeeDto.Email;

            var updateResult = await userManager.UpdateAsync(employee);
            if (!updateResult.Succeeded)
            {
                var errors = string.Join(", ", updateResult.Errors.Select(e => e.Description));
                throw new InvalidOperationException($"Failed to update employee: {errors}");
            }

            if (updateEmployeeDto.Role.HasValue)
            {
                var currentRoles = await userManager.GetRolesAsync(employee);
                await userManager.RemoveFromRolesAsync(employee, currentRoles);

                var roleName = updateEmployeeDto.Role.Value.ToString();
                if (!await roleManager.RoleExistsAsync(roleName))
                {
                    throw new InvalidOperationException($"Role '{roleName}' does not exist.");
                }

                await userManager.AddToRoleAsync(employee, roleName);
            }
        }

        public async Task DeleteAsync(string id)
        {
            var employee = await userManager.FindByIdAsync(id);
            if (employee is null)
            {
                throw new KeyNotFoundException($"Employee with id {id} not found");
            }

            var result = await userManager.DeleteAsync(employee);
            if (!result.Succeeded)
            {
                var errors = string.Join(", ", result.Errors.Select(e => e.Description));
                throw new InvalidOperationException($"Failed to delete employee: {errors}");
            }
        }

        public async Task<IEnumerable<EmployeeDto>> GetByRoleAsync(Role role)
        {
            var roleName = role.ToString();
            var employees = await userManager.GetUsersInRoleAsync(roleName);

            return employees.Select(emp => MapToDto(emp, roleName));
        }

        private static EmployeeDto MapToDto(Employee employee, string? role)
        {
            return new EmployeeDto
            {
                Id = employee.Id,
                FullName = employee.Name,
                Email = employee.Email ?? string.Empty,
                Role = role != null ? Enum.Parse<Role>(role) : null,
                GroupId = employee.GroupId
            }; 
        }

        public async Task<EmployeeDto> GetCurrentUserAsync()
        {
            var userId = httpContextAccessor.HttpContext?
                     .User.FindFirstValue(ClaimTypes.NameIdentifier);
            if (userId == null)
            {
                throw new KeyNotFoundException($"{userId} not found");
            }
            var employee = await userManager.FindByIdAsync(userId); 
            if (employee == null)
            {
                throw new KeyNotFoundException($"Employee with id {userId} not found");
            }
            return MapToDto(employee, (await userManager.GetRolesAsync(employee)).FirstOrDefault());
        }
    }
}
