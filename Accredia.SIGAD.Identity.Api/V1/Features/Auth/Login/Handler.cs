using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Dapper;
using Accredia.SIGAD.Identity.Api.Contracts;
using Accredia.SIGAD.Identity.Api.Database;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.Login;

internal static class Handler
{
    // ASP.NET Identity user record (Id è stringa, non GUID)
    private sealed record AspNetUserRecord(
        string Id,
        string UserName,
        string Email,
        string PasswordHash,
        bool LockoutEnabled,
        DateTimeOffset? LockoutEnd);

    // Dummy user class for password verification
    private sealed class DummyUser { }

    public static async Task<TokenResponse?> Handle(
        Command command,
        ISqlConnectionFactory connectionFactory,
        IOptions<JwtOptions> jwtOptions,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        // Query per AspNetUsers (accetta UserName o Email)
        const string userSql = @"
SELECT [Id], [UserName], [Email], [PasswordHash], [LockoutEnabled], [LockoutEnd]
FROM [Identity].[AspNetUsers]
WHERE ([UserName] = @UserName OR [Email] = @UserName)
  AND ([LockoutEnd] IS NULL OR [LockoutEnd] < SYSDATETIMEOFFSET());
";

        // Query per i ruoli da AspNetUserRoles + AspNetRoles
        const string rolesSql = @"
SELECT r.[Name]
FROM [Identity].[AspNetUserRoles] ur
INNER JOIN [Identity].[AspNetRoles] r ON ur.[RoleId] = r.[Id]
WHERE ur.[UserId] = @UserId;
";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        // Get user
        var user = await connection.QuerySingleOrDefaultAsync<AspNetUserRecord>(
            new CommandDefinition(userSql, new { command.UserName }, cancellationToken: cancellationToken));

        if (user is null)
            return null;

        // Verify password using ASP.NET Identity's PasswordHasher
        var hasher = new PasswordHasher<DummyUser>();
        var result = hasher.VerifyHashedPassword(new DummyUser(), user.PasswordHash, command.Password);

        if (result == PasswordVerificationResult.Failed)
            return null;

        // Get roles
        var roles = await connection.QueryAsync<string>(
            new CommandDefinition(rolesSql, new { UserId = user.Id }, cancellationToken: cancellationToken));

        // Generate JWT
        var jwt = jwtOptions.Value;
        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.Sub, user.Id),
            new(ClaimTypes.NameIdentifier, user.Id),
            new(JwtRegisteredClaimNames.UniqueName, user.UserName),
            new(JwtRegisteredClaimNames.Email, user.Email),
            new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };

        foreach (var role in roles)
        {
            claims.Add(new Claim(ClaimTypes.Role, role));
        }

        var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwt.Key));
        var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);
        var expiresUtc = DateTime.UtcNow.AddMinutes(jwt.AccessTokenMinutes);

        var token = new JwtSecurityToken(
            issuer: jwt.Issuer,
            audience: jwt.Audience,
            claims: claims,
            notBefore: DateTime.UtcNow,
            expires: expiresUtc,
            signingCredentials: creds);

        var accessToken = new JwtSecurityTokenHandler().WriteToken(token);
        var expiresInSeconds = (int)TimeSpan.FromMinutes(jwt.AccessTokenMinutes).TotalSeconds;

        var refreshToken = await CreateRefreshTokenAsync(connection, user.Id, jwt, cancellationToken);

        return new TokenResponse(accessToken, refreshToken, expiresInSeconds);
    }

    private static async Task<string> CreateRefreshTokenAsync(
        System.Data.Common.DbConnection connection,
        string userId,
        JwtOptions jwt,
        CancellationToken cancellationToken)
    {
        var token = GenerateSecureToken();
        var now = DateTime.UtcNow;
        var expiresAt = now.AddDays(jwt.RefreshTokenDays);

        const string insertSql = @"
INSERT INTO [Identity].[RefreshToken] ([UserId], [Token], [CreatedAt], [ExpiresAt])
VALUES (@UserId, @Token, @CreatedAt, @ExpiresAt);
";

        await connection.ExecuteAsync(
            new CommandDefinition(
                insertSql,
                new
                {
                    UserId = userId,
                    Token = token,
                    CreatedAt = now,
                    ExpiresAt = expiresAt
                },
                cancellationToken: cancellationToken));

        return token;
    }

    private static string GenerateSecureToken()
    {
        var bytes = new byte[64];
        RandomNumberGenerator.Fill(bytes);
        return Convert.ToBase64String(bytes);
    }
}
