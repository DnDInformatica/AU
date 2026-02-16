using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Dapper;
using Accredia.SIGAD.Identity.Api.Contracts;
using Accredia.SIGAD.Identity.Api.Database;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.RefreshToken;

internal static class Handler
{
    private sealed record RefreshTokenRecord(
        int RefreshTokenId,
        string UserId,
        string Token,
        DateTime CreatedAt,
        DateTime ExpiresAt,
        DateTime? RevokedAt);

    private sealed record UserRecord(
        string Id,
        string UserName,
        string Email);

    public static async Task<TokenResponse?> Handle(
        Command command,
        ISqlConnectionFactory connectionFactory,
        IOptions<JwtOptions> jwtOptions,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string tokenSql = @"
SELECT [RefreshTokenId], [UserId], [Token], [CreatedAt], [ExpiresAt], [RevokedAt]
FROM [Identity].[RefreshToken]
WHERE [Token] = @Token;
";

        const string userSql = @"
SELECT [Id], [UserName], [Email]
FROM [Identity].[AspNetUsers]
WHERE [Id] = @UserId;
";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var refreshToken = await connection.QuerySingleOrDefaultAsync<RefreshTokenRecord>(
            new CommandDefinition(tokenSql, new { Token = command.RefreshToken }, cancellationToken: cancellationToken));

        if (refreshToken is null)
            return null;

        if (refreshToken.RevokedAt.HasValue)
        {
            await RevokeAllForUserAsync(connection, refreshToken.UserId, cancellationToken);
            return null;
        }

        if (refreshToken.ExpiresAt <= DateTime.UtcNow)
            return null;

        var user = await connection.QuerySingleOrDefaultAsync<UserRecord>(
            new CommandDefinition(userSql, new { UserId = refreshToken.UserId }, cancellationToken: cancellationToken));

        if (user is null)
            return null;

        var jwt = jwtOptions.Value;
        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.Sub, user.Id),
            new(ClaimTypes.NameIdentifier, user.Id),
            new(JwtRegisteredClaimNames.UniqueName, user.UserName ?? string.Empty),
            new(JwtRegisteredClaimNames.Email, user.Email ?? string.Empty),
            new(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };

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

        // rotate refresh token
        var newRefreshToken = GenerateSecureToken();
        var now = DateTime.UtcNow;
        var newExpiresAt = now.AddDays(jwt.RefreshTokenDays);

        const string updateSql = @"
UPDATE [Identity].[RefreshToken]
SET [RevokedAt] = @RevokedAt,
    [ReplacedByToken] = @ReplacedByToken
WHERE [RefreshTokenId] = @RefreshTokenId;

INSERT INTO [Identity].[RefreshToken] ([UserId], [Token], [CreatedAt], [ExpiresAt])
VALUES (@UserId, @Token, @CreatedAt, @ExpiresAt);
";

        await connection.ExecuteAsync(
            new CommandDefinition(updateSql, new
            {
                RefreshTokenId = refreshToken.RefreshTokenId,
                RevokedAt = now,
                ReplacedByToken = newRefreshToken,
                UserId = refreshToken.UserId,
                Token = newRefreshToken,
                CreatedAt = now,
                ExpiresAt = newExpiresAt
            }, cancellationToken: cancellationToken));

        return new TokenResponse(accessToken, newRefreshToken, expiresInSeconds);
    }

    private static async Task RevokeAllForUserAsync(
        System.Data.Common.DbConnection connection,
        string userId,
        CancellationToken cancellationToken)
    {
        const string revokeSql = @"
UPDATE [Identity].[RefreshToken]
SET [RevokedAt] = @RevokedAt
WHERE [UserId] = @UserId AND [RevokedAt] IS NULL;
";

        await connection.ExecuteAsync(
            new CommandDefinition(revokeSql, new
            {
                UserId = userId,
                RevokedAt = DateTime.UtcNow
            }, cancellationToken: cancellationToken));
    }

    private static string GenerateSecureToken()
    {
        var bytes = new byte[64];
        RandomNumberGenerator.Fill(bytes);
        return Convert.ToBase64String(bytes);
    }
}
