using CustomerRelationshipManagement.Dtos;

namespace CustomerRelationshipManagement.Sevices
{
    public interface IAuthService
    {
        Task<AuthResponseDto?> LoginAsync(LoginDto loginDto);
        Task<AuthResponseDto> RegisterAsync(CreateEmployeeDto registerDto);
        Task<AuthResponseDto> ResetPasswordAsync(ResetPasswordDto dto); 
        Task<AuthResponseDto> RefreshTokenAsync(string refreshToken);
        Task LogoutAsync(string refreshToken);
    }
}
