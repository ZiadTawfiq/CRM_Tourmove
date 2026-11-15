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

public class TokenService
{
    private readonly JwtSettings _settings;
    private readonly UserManager<Employee> _userManager;
    private readonly AppDbContext _context;

    public TokenService(IOptions<JwtSettings> options, UserManager<Employee> userManager,AppDbContext context)
    {
        _settings = options.Value;
        _userManager = userManager;
        _context = context;
    }
    public async Task<string> GenerateAccessTokenAsync(Employee user)
    {
       var roles = await _userManager.GetRolesAsync(user);
        var claims = new List<Claim>
        {
            new Claim(ClaimTypes.NameIdentifier, user.Id),
            new Claim(ClaimTypes.Name, user.Name),
           
        };
        foreach (var role in roles)
        {
            claims.Add(new Claim(ClaimTypes.Role, role));
        }
        var key = new SymmetricSecurityKey(System.Text.Encoding.UTF8.GetBytes(_settings.SecretKey));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
        var token = new JwtSecurityToken(
            issuer: _settings.Issuer,
            audience: _settings.Audience,
            claims: claims,
            expires: DateTime.UtcNow.AddMinutes(_settings.AccessTokenExpirationMinutes),
            signingCredentials: creds
        );
        return new JwtSecurityTokenHandler().WriteToken(token);
    }
    public async Task<string> GenerateRefreshTokenAsync(Employee user)
    {
        var randomBytes = RandomNumberGenerator.GetBytes(64);

        var refreshToken = Convert.ToBase64String(randomBytes);

        var hashBytes = SHA256.HashData(System.Text.Encoding.UTF8.GetBytes(refreshToken));

        var refreshTokenEntity = new RefreshToken
        {
            TokenHash = Convert.ToBase64String(hashBytes),
            UserId = user.Id,
            ExpiresAt = DateTime.UtcNow.AddDays(_settings.RefreshTokenExpirationDays),
            CreatedAt = DateTime.UtcNow,
            FamilyId = Guid.NewGuid().ToString()
        };
        await _context.RefreshTokens.AddAsync(refreshTokenEntity);
        await _context.SaveChangesAsync();
        return refreshToken;
    }
    public async Task RevokeRefreshTokenAsync(string refreshToken)
    {
        
        var tokenHash = HashRefreshToken(refreshToken);
        var refreshTokenEntity = await _context.RefreshTokens.FirstOrDefaultAsync(rt => rt.TokenHash == tokenHash);
       
        if (refreshTokenEntity == null || refreshTokenEntity.RevokedAt != null)
            return;

        if (refreshTokenEntity != null)
        {
            refreshTokenEntity.RevokedAt = DateTime.UtcNow;
            await _context.SaveChangesAsync();
        }
    }
    public async Task RevokeFamilyRefreshTokensAsync(string familyId)
    {
        var familyTokens = await _context.RefreshTokens.Where(rt => rt.FamilyId == familyId && rt.RevokedAt == null).ToListAsync();
        foreach (var token in familyTokens)
        {
            token.RevokedAt = DateTime.UtcNow;
        }
        await _context.SaveChangesAsync();
    }
    private string HashRefreshToken(string refreshToken)
    {
        var hashBytes = SHA256.HashData(
            System.Text.Encoding.UTF8.GetBytes(refreshToken));

        return Convert.ToBase64String(hashBytes);
    }
    public async Task<RefreshToken?> GetRefreshTokenAsync(string token)
    {
        var tokenHash = HashRefreshToken(token);

        return await _context.RefreshTokens
            .FirstOrDefaultAsync(rt => rt.TokenHash == tokenHash);
    }
    private bool IsTokenValid(RefreshToken refreshToken)
    {
        return refreshToken != null && refreshToken.IsActive;
    }
}      