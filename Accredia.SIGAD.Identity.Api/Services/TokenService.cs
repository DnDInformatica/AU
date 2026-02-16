using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Accredia.SIGAD.Identity.Api.Contracts;
using Accredia.SIGAD.Identity.Api.Data;
using Accredia.SIGAD.Identity.Api.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace Accredia.SIGAD.Identity.Api.Services;

public interface ITokenService
{
    Task<(string AccessToken, int ExpiresInSeconds)> CreateAccessTokenAsync(ApplicationUser user);
    Task<RefreshToken> CreateRefreshTokenAsync(string userId);
    Task<RefreshToken?> GetRefreshTokenAsync(string token);
    Task RevokeRefreshTokenAsync(RefreshToken token, string? replacedByToken = null);
}

public class TokenService : ITokenService
{
    private readonly JwtOptions _options;
    private readonly AppIdentityDbContext _db;
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly IPermissionService _permissionService;

    public TokenService(IOptions<JwtOptions> options, AppIdentityDbContext db, UserManager<ApplicationUser> userManager, IPermissionService permissionService)
    {
        _options = options.Value;
        _db = db;
        _userManager = userManager;
        _permissionService = permissionService;
    }

    public async Task<(string AccessToken, int ExpiresInSeconds)> CreateAccessTokenAsync(ApplicationUser user)
    {
        var roles = await _userManager.GetRolesAsync(user);
        var permissions = await _permissionService.GetPermissionsForUserAsync(user.Id);

        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.Sub, user.Id),
            new(ClaimTypes.NameIdentifier, user.Id),
            new(JwtRegisteredClaimNames.UniqueName, user.UserName ?? string.Empty),
            new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };

        foreach (var role in roles)
        {
            claims.Add(new Claim(ClaimTypes.Role, role));
        }

        foreach (var perm in permissions)
        {
            claims.Add(new Claim("perm", perm));
        }

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_options.Key));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
        var expires = DateTime.UtcNow.AddMinutes(_options.AccessTokenMinutes);

        var token = new JwtSecurityToken(
            issuer: _options.Issuer,
            audience: _options.Audience,
            claims: claims,
            notBefore: DateTime.UtcNow,
            expires: expires,
            signingCredentials: creds);

        var handler = new JwtSecurityTokenHandler();
        var jwt = handler.WriteToken(token);
        var expiresInSeconds = (int)TimeSpan.FromMinutes(_options.AccessTokenMinutes).TotalSeconds;

        return (jwt, expiresInSeconds);
    }

    public async Task<RefreshToken> CreateRefreshTokenAsync(string userId)
    {
        var token = new RefreshToken
        {
            UserId = userId,
            Token = GenerateSecureToken(),
            CreatedAt = DateTime.UtcNow,
            ExpiresAt = DateTime.UtcNow.AddDays(_options.RefreshTokenDays)
        };

        _db.RefreshTokens.Add(token);
        await _db.SaveChangesAsync();

        return token;
    }

    public async Task<RefreshToken?> GetRefreshTokenAsync(string token)
    {
        return await _db.RefreshTokens
            .Include(rt => rt.User)
            .FirstOrDefaultAsync(rt => rt.Token == token);
    }

    public async Task RevokeRefreshTokenAsync(RefreshToken token, string? replacedByToken = null)
    {
        token.RevokedAt = DateTime.UtcNow;
        token.ReplacedByToken = replacedByToken;
        await _db.SaveChangesAsync();
    }

    private static string GenerateSecureToken()
    {
        var bytes = new byte[64];
        RandomNumberGenerator.Fill(bytes);
        return Convert.ToBase64String(bytes);
    }
}
