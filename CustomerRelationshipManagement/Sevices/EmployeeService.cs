using CustomerRelationshipManagement.Dtos;
using CustomerRelationshipManagement.Entities;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace CustomerRelationshipManagement.Sevices
{
    public class EmployeeService(
        UserManager<Employee> userManager,
        RoleManager<IdentityRole> roleManager) : IEmployeeService
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
                UserName = createEmployeeDto.Email,
                Email = createEmployeeDto.Email,
                Name = createEmployeeDto.Name,
                PhoneNumber = createEmployeeDto.PhoneNumber
            };

            var createResult = await userManager.CreateAsync(employee, createEmployeeDto.Password);
            if (!createResult.Succeeded)
            {
                var errors = string.Join(", ", createResult.Errors.Select(e => e.Description));
                throw new InvalidOperationException($"Failed to create employee: {errors}");
            }

            var roleName = createEmployeeDto.Role.ToString();
            if (!await roleManager.RoleExistsAsync(roleName))
            {
                await roleManager.CreateAsync(new IdentityRole(roleName));
            }

            await userManager.AddToRoleAsync(employee, roleName);

            return MapToDto(employee, roleName);
        }

        public async Task UpdateAsync(UpdateEmployeeDto updateEmployeeDto)
        {
            var employee = await userManager.FindByIdAsync(updateEmployeeDto.Id);
            if (employee is null)
            {
                throw new KeyNotFoundException($"Employee with id {updateEmployeeDto.Id} not found");
            }

            employee.Name = updateEmployeeDto.Name;
            employee.Email = updateEmployeeDto.Email;
            employee.UserName = updateEmployeeDto.Email;
            employee.PhoneNumber = updateEmployeeDto.PhoneNumber;

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
                    await roleManager.CreateAsync(new IdentityRole(roleName));
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
                Name = employee.Name,
                Email = employee.Email ?? string.Empty,
                PhoneNumber = employee.PhoneNumber,
                Role = role
            };
        }
    }
}
