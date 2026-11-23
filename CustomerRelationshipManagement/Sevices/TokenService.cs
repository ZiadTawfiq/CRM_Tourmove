
using CustomerRelationshipManagement;
using CustomerRelationshipManagement.Entities;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using System.Data;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

public class TokenService
{
    private readonly JwtSettings _settings;
    private readonly UserManager<Employee> _userManager;
    private readonly AppDbContext _context;

    public TokenService(
        IOptions<JwtSettings> options,
        UserManager<Employee> userManager,
        AppDbContext context)
    {
        _settings = options.Value;
        _userManager = userManager;
        _context = context;
    }

    // 1. Generate Access Token
    public async Task<string> GenerateAccessTokenAsync(Employee user)
    {
        var roles = await _userManager.GetRolesAsync(user);

        var claims = new List<Claim>
        {
            new Claim(ClaimTypes.NameIdentifier, user.Id),
            new Claim(
                ClaimTypes.Name,
                user.Name ?? user.UserName ?? user.Id)
        };

        foreach (var role in roles)
        {
            claims.Add(new Claim(ClaimTypes.Role, role));
        }

        var key = new SymmetricSecurityKey(
            Encoding.UTF8.GetBytes(_settings.SecretKey));

        var credentials = new SigningCredentials(
            key,
            SecurityAlgorithms.HmacSha256);

        var token = new JwtSecurityToken(
            issuer: _settings.Issuer,
            audience: _settings.Audience,
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(
                _settings.AccessTokenExpirationMinutes),
            signingCredentials: credentials
        );

        return new JwtSecurityTokenHandler().WriteToken(token);
    }

    // 2. Generate Refresh Token for a NEW login
    public async Task<string> GenerateRefreshTokenAsync(Employee user)
    {
        var familyId = Guid.NewGuid().ToString();

        var result = CreateRefreshToken(user, familyId);

        _context.RefreshTokens.Add(result.Entity);

        await _context.SaveChangesAsync();

        return result.RawToken;
    }

    // 3. Create Refresh Token without saving
    private (string RawToken, RefreshToken Entity) CreateRefreshToken(
        Employee user,
        string familyId)
    {
        var randomBytes = RandomNumberGenerator.GetBytes(64);

        var rawToken = Convert.ToBase64String(randomBytes);

        var now = DateTime.UtcNow;

        var entity = new RefreshToken
        {
            TokenHash = HashRefreshToken(rawToken),
            UserId = user.Id,
            FamilyId = familyId,
            CreatedAt = now,
            ExpiresAt = now.AddDays(
                _settings.RefreshTokenExpirationDays)
        };

        return (rawToken, entity);
    }

    // 4. Hash Refresh Token
    private string HashRefreshToken(string refreshToken)
    {
        var hashBytes = SHA256.HashData(
            Encoding.UTF8.GetBytes(refreshToken));

        return Convert.ToBase64String(hashBytes);
    }

    // 5. Find Refresh Token
    public async Task<RefreshToken?> GetRefreshTokenAsync(string token)
    {
        var tokenHash = HashRefreshToken(token);

        return await _context.RefreshTokens
            .AsNoTracking()
            .FirstOrDefaultAsync(rt => rt.TokenHash == tokenHash);
    }

    // 6. Revoke a single Refresh Token
    public async Task RevokeRefreshTokenAsync(string refreshToken)
    {
        var tokenHash = HashRefreshToken(refreshToken);
        var now = DateTime.UtcNow;

        await _context.RefreshTokens
            .Where(rt => rt.TokenHash == tokenHash &&
                         rt.RevokedAt == null)
            .ExecuteUpdateAsync(setters => setters
                .SetProperty(rt => rt.RevokedAt, now));
    }

    // 7. Revoke one Token Family
    public async Task RevokeFamilyRefreshTokensAsync(string familyId)
    {
        var now = DateTime.UtcNow;

        await _context.RefreshTokens
            .Where(rt => rt.FamilyId == familyId &&
                         rt.RevokedAt == null)
            .ExecuteUpdateAsync(setters => setters
                .SetProperty(rt => rt.RevokedAt, now));
    }

    // 8. Revoke all sessions belonging to a user
    public async Task RevokeAllUserTokensAsync(string userId)
    {
        var now = DateTime.UtcNow;

        await _context.RefreshTokens
            .Where(rt => rt.UserId == userId &&
                         rt.RevokedAt == null)
            .ExecuteUpdateAsync(setters => setters
                .SetProperty(rt => rt.RevokedAt, now));
    }

    // 9. Logout from one device
    public async Task LogoutAsync(string rawRefreshToken)
    {
        var token = await GetRefreshTokenAsync(rawRefreshToken);

        if (token == null)
            return;

        await RevokeFamilyRefreshTokensAsync(token.FamilyId);
    }

    // 10. Refresh Token Rotation
    public async Task<TokenResponse> RefreshAsync(
        string rawRefreshToken)
    {
        if (string.IsNullOrWhiteSpace(rawRefreshToken))
            throw new UnauthorizedAccessException(
                "Refresh token is required");

        await using var transaction =
            await _context.Database.BeginTransactionAsync(
                IsolationLevel.ReadCommitted);

        var oldToken = await GetRefreshTokenAsync(rawRefreshToken);

        if (oldToken == null)
            throw new UnauthorizedAccessException(
                "Invalid refresh token");

        // Check reuse before expiration
        if (oldToken.RevokedAt != null)
        {
            if (oldToken.ReplaceedByTokenHash != null)
            {
                await RevokeFamilyRefreshTokensAsync(
                    oldToken.FamilyId);

                await transaction.CommitAsync();

                throw new UnauthorizedAccessException(
                    "Refresh token reuse detected");
            }

            throw new UnauthorizedAccessException(
                "Refresh token has been revoked");
        }

        if (oldToken.ExpiresAt <= DateTime.UtcNow)
            throw new UnauthorizedAccessException(
                "Refresh token expired");

        // Find token owner
        var user = await _userManager.FindByIdAsync(
            oldToken.UserId);

        if (user == null)
            throw new UnauthorizedAccessException(
                "User not found");

        // Prepare new tokens
        var newAccessToken =
            await GenerateAccessTokenAsync(user);

        var result = CreateRefreshToken(
            user,
            oldToken.FamilyId);

        var now = DateTime.UtcNow;

        // Atomically consume the old refresh token
        var affectedRows = await _context.RefreshTokens
            .Where(rt => rt.Id == oldToken.Id &&
                         rt.RevokedAt == null &&
                         rt.ExpiresAt > now)
            .ExecuteUpdateAsync(setters => setters
                .SetProperty(rt => rt.RevokedAt, now)
                .SetProperty(
                    rt => rt.ReplaceedByTokenHash,
                    result.Entity.TokenHash));

        // Another request may have consumed this token
        if (affectedRows == 0)
        {
            var latestToken = await _context.RefreshTokens
                .AsNoTracking()
                .FirstOrDefaultAsync(rt => rt.Id == oldToken.Id);

            if (latestToken?.ReplaceedByTokenHash != null)
            {
                await RevokeFamilyRefreshTokensAsync(
                    oldToken.FamilyId);

                await transaction.CommitAsync();

                throw new UnauthorizedAccessException(
                    "Refresh token reuse detected");
            }

            throw new UnauthorizedAccessException(
                "Refresh token is no longer valid");
        }

        // Save the new refresh token
        _context.RefreshTokens.Add(result.Entity);

        await _context.SaveChangesAsync();

        await transaction.CommitAsync();

        return new TokenResponse
        {
            AccessToken = newAccessToken,
            RefreshToken = result.RawToken
        };
    }
}
