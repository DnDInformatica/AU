using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;
using Dapper;
using Accredia.SIGAD.Identity.Api.Contracts;
using Accredia.SIGAD.Identity.Api.Database;
using Microsoft.Data.SqlClient;
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
        var normalizedUserNameOrEmail = command.UserName.Trim().ToUpperInvariant();

        // Query separate per evitare piano pessimo con OR su colonne diverse.
        // Strategia graduale: prima query in READ COMMITTED, fallback a NOLOCK solo su timeout.
        const string userByUserNameSql = @"
SELECT [Id], [UserName], [Email], [PasswordHash], [LockoutEnabled], [LockoutEnd]
FROM [Identity].[AspNetUsers]
WHERE [NormalizedUserName] = @NormalizedValue
  AND ([LockoutEnd] IS NULL OR [LockoutEnd] < SYSDATETIMEOFFSET());
";

        const string userByUserNameSqlNoLock = @"
SELECT [Id], [UserName], [Email], [PasswordHash], [LockoutEnabled], [LockoutEnd]
FROM [Identity].[AspNetUsers] WITH (NOLOCK)
WHERE [NormalizedUserName] = @NormalizedValue
  AND ([LockoutEnd] IS NULL OR [LockoutEnd] < SYSDATETIMEOFFSET());
";

        const string userByEmailSql = @"
SELECT [Id], [UserName], [Email], [PasswordHash], [LockoutEnabled], [LockoutEnd]
FROM [Identity].[AspNetUsers]
WHERE [NormalizedEmail] = @NormalizedValue
  AND ([LockoutEnd] IS NULL OR [LockoutEnd] < SYSDATETIMEOFFSET());
";

        const string userByEmailSqlNoLock = @"
SELECT [Id], [UserName], [Email], [PasswordHash], [LockoutEnabled], [LockoutEnd]
FROM [Identity].[AspNetUsers] WITH (NOLOCK)
WHERE [NormalizedEmail] = @NormalizedValue
  AND ([LockoutEnd] IS NULL OR [LockoutEnd] < SYSDATETIMEOFFSET());
";

        // Query per i ruoli da AspNetUserRoles + AspNetRoles
        const string rolesSql = @"
SELECT r.[Name]
FROM [Identity].[AspNetUserRoles] ur
INNER JOIN [Identity].[AspNetRoles] r ON ur.[RoleId] = r.[Id]
WHERE ur.[UserId] = @UserId;
";

        const string rolesSqlNoLock = @"
SELECT r.[Name]
FROM [Identity].[AspNetUserRoles] ur WITH (NOLOCK)
INNER JOIN [Identity].[AspNetRoles] r WITH (NOLOCK) ON ur.[RoleId] = r.[Id]
WHERE ur.[UserId] = @UserId;
";

        const string permissionsSql = @"
SELECT DISTINCT p.[Code]
FROM [Identity].[AspNetUserRoles] ur
INNER JOIN [Identity].[RolePermission] rp ON rp.[RoleId] = ur.[RoleId]
INNER JOIN [Identity].[Permission] p ON p.[PermissionId] = rp.[PermissionId]
WHERE ur.[UserId] = @UserId
  AND p.[IsDeleted] = 0
  AND p.[Attivo] = 1;
";

        const string permissionsSqlNoLock = @"
SELECT DISTINCT p.[Code]
FROM [Identity].[AspNetUserRoles] ur WITH (NOLOCK)
INNER JOIN [Identity].[RolePermission] rp WITH (NOLOCK) ON rp.[RoleId] = ur.[RoleId]
INNER JOIN [Identity].[Permission] p WITH (NOLOCK) ON p.[PermissionId] = rp.[PermissionId]
WHERE ur.[UserId] = @UserId
  AND p.[IsDeleted] = 0
  AND p.[Attivo] = 1;
";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        // 1) lookup per username (index seek su UserNameIndex)
        var user = await QueryUserWithTimeoutFallbackAsync(
            connection,
            userByUserNameSql,
            userByUserNameSqlNoLock,
            normalizedUserNameOrEmail,
            cancellationToken);

        // 2) fallback lookup per email (index seek su EmailIndex)
        if (user is null && normalizedUserNameOrEmail.Contains('@'))
        {
            user = await QueryUserWithTimeoutFallbackAsync(
                connection,
                userByEmailSql,
                userByEmailSqlNoLock,
                normalizedUserNameOrEmail,
                cancellationToken);
        }

        if (user is null)
            return null;

        // Verify password using ASP.NET Identity's PasswordHasher
        var hasher = new PasswordHasher<DummyUser>();
        var result = hasher.VerifyHashedPassword(new DummyUser(), user.PasswordHash, command.Password);

        if (result == PasswordVerificationResult.Failed)
            return null;

        // Get roles
        var roles = await QueryRolesWithTimeoutFallbackAsync(
            connection,
            rolesSql,
            rolesSqlNoLock,
            user.Id,
            cancellationToken);
        var permissions = await QueryPermissionsWithTimeoutFallbackAsync(
            connection,
            permissionsSql,
            permissionsSqlNoLock,
            user.Id,
            cancellationToken);

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
        foreach (var permission in permissions)
        {
            claims.Add(new Claim("perm", permission));
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

    private static async Task<AspNetUserRecord?> QueryUserWithTimeoutFallbackAsync(
        System.Data.Common.DbConnection connection,
        string primarySql,
        string fallbackSqlNoLock,
        string normalizedValue,
        CancellationToken cancellationToken)
    {
        try
        {
            // Timeout breve sulla query "pulita" per privilegiare consistenza quando il DB e' sano.
            return await connection.QuerySingleOrDefaultAsync<AspNetUserRecord>(
                new CommandDefinition(
                    primarySql,
                    new { NormalizedValue = normalizedValue },
                    commandTimeout: 5,
                    cancellationToken: cancellationToken));
        }
        catch (SqlException ex) when (ex.Number == -2)
        {
            // Fallback di resilienza su ambienti con lock transitori lunghi.
            return await connection.QuerySingleOrDefaultAsync<AspNetUserRecord>(
                new CommandDefinition(
                    fallbackSqlNoLock,
                    new { NormalizedValue = normalizedValue },
                    cancellationToken: cancellationToken));
        }
    }

    private static async Task<IEnumerable<string>> QueryRolesWithTimeoutFallbackAsync(
        System.Data.Common.DbConnection connection,
        string primarySql,
        string fallbackSqlNoLock,
        string userId,
        CancellationToken cancellationToken)
    {
        try
        {
            return await connection.QueryAsync<string>(
                new CommandDefinition(
                    primarySql,
                    new { UserId = userId },
                    commandTimeout: 5,
                    cancellationToken: cancellationToken));
        }
        catch (SqlException ex) when (ex.Number == -2)
        {
            return await connection.QueryAsync<string>(
                new CommandDefinition(
                    fallbackSqlNoLock,
                    new { UserId = userId },
                    cancellationToken: cancellationToken));
        }
    }

    private static async Task<IEnumerable<string>> QueryPermissionsWithTimeoutFallbackAsync(
        System.Data.Common.DbConnection connection,
        string primarySql,
        string fallbackSqlNoLock,
        string userId,
        CancellationToken cancellationToken)
    {
        try
        {
            return await connection.QueryAsync<string>(
                new CommandDefinition(
                    primarySql,
                    new { UserId = userId },
                    commandTimeout: 5,
                    cancellationToken: cancellationToken));
        }
        catch (SqlException ex) when (ex.Number == -2)
        {
            return await connection.QueryAsync<string>(
                new CommandDefinition(
                    fallbackSqlNoLock,
                    new { UserId = userId },
                    cancellationToken: cancellationToken));
        }
    }

    private static string GenerateSecureToken()
    {
        var bytes = new byte[64];
        RandomNumberGenerator.Fill(bytes);
        return Convert.ToBase64String(bytes);
    }
}
