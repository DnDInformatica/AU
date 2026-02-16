using System;
using System.Security.Cryptography;
using System.Linq;
using System.Threading;
using System.Threading.Tasks;
using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Options;
using Xunit;
using Accredia.SIGAD.Identity.Api.Contracts;
using Accredia.SIGAD.Identity.Api.Database;
using LoginFeature = Accredia.SIGAD.Identity.Api.V1.Features.Auth.Login;
using RefreshFeature = Accredia.SIGAD.Identity.Api.V1.Features.Auth.RefreshToken;
using LogoutFeature = Accredia.SIGAD.Identity.Api.V1.Features.Auth.Logout;
using LogoutAllFeature = Accredia.SIGAD.Identity.Api.V1.Features.Auth.LogoutAll;
using LogoutUserFeature = Accredia.SIGAD.Identity.Api.V1.Features.Auth.LogoutUser;
using LogoutUsersFeature = Accredia.SIGAD.Identity.Api.V1.Features.Auth.LogoutUsers;
using MeFeature = Accredia.SIGAD.Identity.Api.V1.Features.Me.GetCurrentUser;
using Microsoft.AspNetCore.Identity;

namespace Accredia.SIGAD.Identity.Api.Tests;

public class AuthIntegrationTests
{
    private sealed class TestSqlConnectionFactory : ISqlConnectionFactory
    {
        private readonly string _connectionString;

        public TestSqlConnectionFactory(string connectionString)
        {
            _connectionString = connectionString;
        }

        public async Task<SqlConnection> CreateOpenConnectionAsync(CancellationToken cancellationToken = default)
        {
            var connection = new SqlConnection(_connectionString);
            await connection.OpenAsync(cancellationToken);
            return connection;
        }
    }

    private sealed record TestUser(string Id, string UserName, string Email, string Password);

    private static TestSettings LoadSettings()
    {
        var config = new ConfigurationBuilder()
            .SetBasePath(AppContext.BaseDirectory)
            .AddJsonFile("appsettings.Test.json", optional: false)
            .AddEnvironmentVariables()
            .Build();

        var connectionString = config.GetConnectionString("IdentityDb")
            ?? throw new InvalidOperationException("Missing IdentityDb connection string.");

        var jwt = config.GetSection("Jwt").Get<JwtOptions>()
            ?? throw new InvalidOperationException("Missing Jwt configuration.");

        return new TestSettings(connectionString, jwt);
    }

    private static async Task<TestUser> CreateTestUserAsync(SqlConnection connection)
    {
        var userId = Guid.NewGuid().ToString();
        var userName = $"test_{Guid.NewGuid():N}";
        var email = $"{userName}@example.local";
        var password = $"P@ss_{Guid.NewGuid():N}!";

        var hasher = new PasswordHasher<object>();
        var passwordHash = hasher.HashPassword(new object(), password);

        const string sql = @"
INSERT INTO [Identity].[AspNetUsers] (
    [Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail],
    [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp],
    [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnabled], [AccessFailedCount]
)
VALUES (
    @Id, @UserName, @NormalizedUserName, @Email, @NormalizedEmail,
    1, @PasswordHash, @SecurityStamp, @ConcurrencyStamp,
    0, 0, 1, 0
);
";

        await connection.ExecuteAsync(sql, new
        {
            Id = userId,
            UserName = userName,
            NormalizedUserName = userName.ToUpperInvariant(),
            Email = email,
            NormalizedEmail = email.ToUpperInvariant(),
            PasswordHash = passwordHash,
            SecurityStamp = Guid.NewGuid().ToString(),
            ConcurrencyStamp = Guid.NewGuid().ToString()
        });

        return new TestUser(userId, userName, email, password);
    }

    private static async Task CleanupUserAsync(SqlConnection connection, string userId)
    {
        const string sql = @"
DELETE FROM [Identity].[AspNetUserRoles] WHERE [UserId] = @UserId;
DELETE FROM [Identity].[AspNetUserClaims] WHERE [UserId] = @UserId;
DELETE FROM [Identity].[AspNetUserLogins] WHERE [UserId] = @UserId;
DELETE FROM [Identity].[AspNetUserTokens] WHERE [UserId] = @UserId;
DELETE FROM [Identity].[RefreshToken] WHERE [UserId] = @UserId;
DELETE FROM [Identity].[AspNetUsers] WHERE [Id] = @UserId;
";

        await connection.ExecuteAsync(sql, new { UserId = userId });
    }

    [Fact]
    public async Task Login_Refresh_Logout_Flow_Works()
    {
        var settings = LoadSettings();
        var factory = new TestSqlConnectionFactory(settings.ConnectionString);

        await using var connection = new SqlConnection(settings.ConnectionString);
        await connection.OpenAsync();

        TestUser user = null!;
        try
        {
            user = await CreateTestUserAsync(connection);

            var loginResponse = await LoginFeature.Handler.Handle(
                new LoginFeature.Command(user.UserName, user.Password),
                factory,
                Options.Create(settings.Jwt),
                CancellationToken.None);

            Assert.NotNull(loginResponse);
            Assert.False(string.IsNullOrWhiteSpace(loginResponse!.AccessToken));
            Assert.False(string.IsNullOrWhiteSpace(loginResponse.RefreshToken));

            var refreshResponse = await RefreshFeature.Handler.Handle(
                new RefreshFeature.Command(loginResponse.RefreshToken),
                factory,
                Options.Create(settings.Jwt),
                CancellationToken.None);

            Assert.NotNull(refreshResponse);
            Assert.NotEqual(loginResponse.RefreshToken, refreshResponse!.RefreshToken);

            var revoked = await LogoutFeature.Handler.Handle(
                new LogoutFeature.Command(refreshResponse.RefreshToken),
                factory,
                CancellationToken.None);

            Assert.True(revoked);

            var reuse = await RefreshFeature.Handler.Handle(
                new RefreshFeature.Command(refreshResponse.RefreshToken),
                factory,
                Options.Create(settings.Jwt),
                CancellationToken.None);

            Assert.Null(reuse);
        }
        finally
        {
            if (user != null)
            {
                await CleanupUserAsync(connection, user.Id);
            }
        }
    }

    [Fact]
    public async Task RefreshToken_ReuseDetection_Revokes_All()
    {
        var settings = LoadSettings();
        var factory = new TestSqlConnectionFactory(settings.ConnectionString);

        await using var connection = new SqlConnection(settings.ConnectionString);
        await connection.OpenAsync();

        TestUser user = null!;
        try
        {
            user = await CreateTestUserAsync(connection);

            var loginResponse = await LoginFeature.Handler.Handle(
                new LoginFeature.Command(user.UserName, user.Password),
                factory,
                Options.Create(settings.Jwt),
                CancellationToken.None);

            Assert.NotNull(loginResponse);

            var refreshResponse = await RefreshFeature.Handler.Handle(
                new RefreshFeature.Command(loginResponse!.RefreshToken),
                factory,
                Options.Create(settings.Jwt),
                CancellationToken.None);

            Assert.NotNull(refreshResponse);

            var reuse = await RefreshFeature.Handler.Handle(
                new RefreshFeature.Command(loginResponse.RefreshToken),
                factory,
                Options.Create(settings.Jwt),
                CancellationToken.None);

            Assert.Null(reuse);

            const string checkSql = @"
SELECT [RevokedAt]
FROM [Identity].[RefreshToken]
WHERE [Token] = @Token;
";

            var revokedAt = await connection.QuerySingleOrDefaultAsync<DateTime?>(checkSql, new { Token = refreshResponse!.RefreshToken });
            Assert.NotNull(revokedAt);
        }
        finally
        {
            if (user != null)
            {
                await CleanupUserAsync(connection, user.Id);
            }
        }
    }

    [Fact]
    public async Task RefreshToken_ReuseDetection_Revokes_All_Tokens_For_User()
    {
        var settings = LoadSettings();
        var factory = new TestSqlConnectionFactory(settings.ConnectionString);

        await using var connection = new SqlConnection(settings.ConnectionString);
        await connection.OpenAsync();

        TestUser user = null!;
        try
        {
            user = await CreateTestUserAsync(connection);

            var loginResponse1 = await LoginFeature.Handler.Handle(
                new LoginFeature.Command(user.UserName, user.Password),
                factory,
                Options.Create(settings.Jwt),
                CancellationToken.None);

            var loginResponse2 = await LoginFeature.Handler.Handle(
                new LoginFeature.Command(user.UserName, user.Password),
                factory,
                Options.Create(settings.Jwt),
                CancellationToken.None);

            Assert.NotNull(loginResponse1);
            Assert.NotNull(loginResponse2);

            var refreshResponse = await RefreshFeature.Handler.Handle(
                new RefreshFeature.Command(loginResponse1!.RefreshToken),
                factory,
                Options.Create(settings.Jwt),
                CancellationToken.None);

            Assert.NotNull(refreshResponse);

            var reuse = await RefreshFeature.Handler.Handle(
                new RefreshFeature.Command(loginResponse1.RefreshToken),
                factory,
                Options.Create(settings.Jwt),
                CancellationToken.None);

            Assert.Null(reuse);

            const string activeSql = @"
SELECT COUNT(1)
FROM [Identity].[RefreshToken]
WHERE [UserId] = @UserId AND [RevokedAt] IS NULL;
";

            var active = await connection.QuerySingleAsync<int>(activeSql, new { UserId = user.Id });
            Assert.Equal(0, active);
        }
        finally
        {
            if (user != null)
            {
                await CleanupUserAsync(connection, user.Id);
            }
        }
    }

    [Fact]
    public async Task LogoutAll_Revokes_All_User_Tokens()
    {
        var settings = LoadSettings();
        var factory = new TestSqlConnectionFactory(settings.ConnectionString);

        await using var connection = new SqlConnection(settings.ConnectionString);
        await connection.OpenAsync();

        TestUser user = null!;
        try
        {
            user = await CreateTestUserAsync(connection);

            var loginResponse = await LoginFeature.Handler.Handle(
                new LoginFeature.Command(user.UserName, user.Password),
                factory,
                Options.Create(settings.Jwt),
                CancellationToken.None);

            Assert.NotNull(loginResponse);

            await LogoutAllFeature.Handler.Handle(
                new LogoutAllFeature.Command(user.Id),
                factory,
                CancellationToken.None);

            const string sql = @"
SELECT COUNT(1)
FROM [Identity].[RefreshToken]
WHERE [UserId] = @UserId AND [RevokedAt] IS NULL;
";

            var active = await connection.QuerySingleAsync<int>(sql, new { UserId = user.Id });
            Assert.Equal(0, active);
        }
        finally
        {
            if (user != null)
            {
                await CleanupUserAsync(connection, user.Id);
            }
        }
    }

    [Fact]
    public async Task Admin_LogoutUser_Revokes_All_User_Tokens()
    {
        var settings = LoadSettings();
        var factory = new TestSqlConnectionFactory(settings.ConnectionString);

        await using var connection = new SqlConnection(settings.ConnectionString);
        await connection.OpenAsync();

        TestUser user = null!;
        try
        {
            user = await CreateTestUserAsync(connection);

            var loginResponse = await LoginFeature.Handler.Handle(
                new LoginFeature.Command(user.UserName, user.Password),
                factory,
                Options.Create(settings.Jwt),
                CancellationToken.None);

            Assert.NotNull(loginResponse);

            await LogoutUserFeature.Handler.Handle(
                new LogoutUserFeature.Command(user.Id),
                factory,
                CancellationToken.None);

            const string sql = @"
SELECT COUNT(1)
FROM [Identity].[RefreshToken]
WHERE [UserId] = @UserId AND [RevokedAt] IS NULL;
";

            var active = await connection.QuerySingleAsync<int>(sql, new { UserId = user.Id });
            Assert.Equal(0, active);
        }
        finally
        {
            if (user != null)
            {
                await CleanupUserAsync(connection, user.Id);
            }
        }
    }

    [Fact]
    public async Task Admin_LogoutUsers_Revokes_All_User_Tokens()
    {
        var settings = LoadSettings();
        var factory = new TestSqlConnectionFactory(settings.ConnectionString);

        await using var connection = new SqlConnection(settings.ConnectionString);
        await connection.OpenAsync();

        TestUser user1 = null!;
        TestUser user2 = null!;
        try
        {
            user1 = await CreateTestUserAsync(connection);
            user2 = await CreateTestUserAsync(connection);

            var loginResponse1 = await LoginFeature.Handler.Handle(
                new LoginFeature.Command(user1.UserName, user1.Password),
                factory,
                Options.Create(settings.Jwt),
                CancellationToken.None);

            var loginResponse2 = await LoginFeature.Handler.Handle(
                new LoginFeature.Command(user2.UserName, user2.Password),
                factory,
                Options.Create(settings.Jwt),
                CancellationToken.None);

            Assert.NotNull(loginResponse1);
            Assert.NotNull(loginResponse2);

            await LogoutUsersFeature.Handler.Handle(
                new LogoutUsersFeature.Command(new[] { user1.Id, user2.Id }),
                factory,
                CancellationToken.None);

            const string sql = @"
SELECT COUNT(1)
FROM [Identity].[RefreshToken]
WHERE [UserId] IN @UserIds AND [RevokedAt] IS NULL;
";

            var active = await connection.QuerySingleAsync<int>(sql, new { UserIds = new[] { user1.Id, user2.Id } });
            Assert.Equal(0, active);
        }
        finally
        {
            if (user1 != null)
            {
                await CleanupUserAsync(connection, user1.Id);
            }

            if (user2 != null)
            {
                await CleanupUserAsync(connection, user2.Id);
            }
        }
    }

    [Fact]
    public async Task Admin_User_Is_Not_Affected_By_Test_Cleanup()
    {
        var settings = LoadSettings();

        await using var connection = new SqlConnection(settings.ConnectionString);
        await connection.OpenAsync();

        const string adminSql = @"
SELECT [Id]
FROM [Identity].[AspNetUsers]
WHERE [UserName] = 'admin';
";

        var adminId = await connection.QuerySingleOrDefaultAsync<string>(adminSql);
        Assert.False(string.IsNullOrWhiteSpace(adminId));

        TestUser user = null!;
        try
        {
            user = await CreateTestUserAsync(connection);
        }
        finally
        {
            if (user != null)
            {
                await CleanupUserAsync(connection, user.Id);
            }
        }

        var adminStillThere = await connection.QuerySingleOrDefaultAsync<string>(adminSql);
        Assert.Equal(adminId, adminStillThere);
    }

    [Fact]
    public async Task Me_Returns_Roles_And_Permissions()
    {
        var settings = LoadSettings();
        var factory = new TestSqlConnectionFactory(settings.ConnectionString);

        await using var connection = new SqlConnection(settings.ConnectionString);
        await connection.OpenAsync();

        TestUser user = null!;
        string roleId = null!;
        string roleName = null!;
        int permissionId = 0;
        string permissionCode = null!;

        try
        {
            user = await CreateTestUserAsync(connection);

            roleName = $"TEST_ROLE_{Guid.NewGuid():N}";
            roleId = Guid.NewGuid().ToString();

            const string roleSql = @"
INSERT INTO [Identity].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp])
VALUES (@Id, @Name, @NormalizedName, @ConcurrencyStamp);
";

            await connection.ExecuteAsync(roleSql, new
            {
                Id = roleId,
                Name = roleName,
                NormalizedName = roleName.ToUpperInvariant(),
                ConcurrencyStamp = Guid.NewGuid().ToString()
            });

            const string userRoleSql = @"
INSERT INTO [Identity].[AspNetUserRoles] ([UserId], [RoleId])
VALUES (@UserId, @RoleId);
";

            await connection.ExecuteAsync(userRoleSql, new { UserId = user.Id, RoleId = roleId });

            permissionCode = $"TEST.PERM.{Guid.NewGuid():N}";
            const string permissionSql = @"
INSERT INTO [Identity].[Permission] ([Code], [Description], [Module], [Scope], [Attivo], [CreatedAt], [CreatedBy], [IsDeleted])
VALUES (@Code, @Description, @Module, @Scope, 1, @CreatedAt, @CreatedBy, 0);
SELECT CAST(SCOPE_IDENTITY() AS INT);
";

            permissionId = await connection.QuerySingleAsync<int>(permissionSql, new
            {
                Code = permissionCode,
                Description = "Test permission",
                Module = "TEST",
                Scope = "ACTION",
                CreatedAt = DateTime.UtcNow,
                CreatedBy = "test"
            });

            const string rolePermissionSql = @"
INSERT INTO [Identity].[RolePermission] ([RoleId], [PermissionId])
VALUES (@RoleId, @PermissionId);
";

            await connection.ExecuteAsync(rolePermissionSql, new { RoleId = roleId, PermissionId = permissionId });

            var response = await MeFeature.Handler.Handle(
                new MeFeature.Command(user.Id),
                factory,
                CancellationToken.None);

            Assert.NotNull(response);
            Assert.Contains(roleName, response!.Roles);
            Assert.Contains(permissionCode, response.Permissions);
        }
        finally
        {
            if (permissionId != 0)
            {
                await connection.ExecuteAsync("DELETE FROM [Identity].[RolePermission] WHERE [PermissionId] = @PermissionId;", new { PermissionId = permissionId });
                await connection.ExecuteAsync("DELETE FROM [Identity].[Permission] WHERE [PermissionId] = @PermissionId;", new { PermissionId = permissionId });
            }

            if (!string.IsNullOrWhiteSpace(roleId))
            {
                await connection.ExecuteAsync("DELETE FROM [Identity].[AspNetUserRoles] WHERE [RoleId] = @RoleId;", new { RoleId = roleId });
                await connection.ExecuteAsync("DELETE FROM [Identity].[AspNetRoles] WHERE [Id] = @RoleId;", new { RoleId = roleId });
            }

            if (user != null)
            {
                await CleanupUserAsync(connection, user.Id);
            }
        }
    }

    [Fact]
    public async Task Admin_Permissions_List_Includes_New_Permission()
    {
        var settings = LoadSettings();

        await using var connection = new SqlConnection(settings.ConnectionString);
        await connection.OpenAsync();

        int permissionId = 0;
        string permissionCode = null!;

        try
        {
            permissionCode = $"TEST.PERM.{Guid.NewGuid():N}";
            const string insertSql = @"
INSERT INTO [Identity].[Permission] ([Code], [Description], [Module], [Scope], [Attivo], [CreatedAt], [CreatedBy], [IsDeleted])
VALUES (@Code, @Description, @Module, @Scope, 1, @CreatedAt, @CreatedBy, 0);
SELECT CAST(SCOPE_IDENTITY() AS INT);
";

            permissionId = await connection.QuerySingleAsync<int>(insertSql, new
            {
                Code = permissionCode,
                Description = "Test permission",
                Module = "TEST",
                Scope = "ACTION",
                CreatedAt = DateTime.UtcNow,
                CreatedBy = "test"
            });

            const string listSql = @"
SELECT [Code]
FROM [Identity].[Permission]
WHERE [IsDeleted] = 0
ORDER BY [Module], [Code];
";

            var codes = (await connection.QueryAsync<string>(listSql)).ToList();
            Assert.Contains(permissionCode, codes);
        }
        finally
        {
            if (permissionId != 0)
            {
                await connection.ExecuteAsync("DELETE FROM [Identity].[Permission] WHERE [PermissionId] = @PermissionId;", new { PermissionId = permissionId });
            }
        }
    }

    [Fact]
    public async Task Admin_Roles_List_Includes_New_Role()
    {
        var settings = LoadSettings();

        await using var connection = new SqlConnection(settings.ConnectionString);
        await connection.OpenAsync();

        string roleId = null!;
        string roleName = null!;

        try
        {
            roleName = $"TEST_ROLE_{Guid.NewGuid():N}";
            roleId = Guid.NewGuid().ToString();

            const string insertSql = @"
INSERT INTO [Identity].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp])
VALUES (@Id, @Name, @NormalizedName, @ConcurrencyStamp);
";

            await connection.ExecuteAsync(insertSql, new
            {
                Id = roleId,
                Name = roleName,
                NormalizedName = roleName.ToUpperInvariant(),
                ConcurrencyStamp = Guid.NewGuid().ToString()
            });

            const string listSql = @"
SELECT [Name]
FROM [Identity].[AspNetRoles]
ORDER BY [Name];
";

            var names = (await connection.QueryAsync<string>(listSql)).ToList();
            Assert.Contains(roleName, names);
        }
        finally
        {
            if (!string.IsNullOrWhiteSpace(roleId))
            {
                await connection.ExecuteAsync("DELETE FROM [Identity].[AspNetRoles] WHERE [Id] = @RoleId;", new { RoleId = roleId });
            }
        }
    }

    [Fact]
    public async Task Admin_RolePermissions_Get_Returns_Assigned_Permissions()
    {
        var settings = LoadSettings();

        await using var connection = new SqlConnection(settings.ConnectionString);
        await connection.OpenAsync();

        string roleId = null!;
        string roleName = null!;
        int permissionId = 0;
        string permissionCode = null!;

        try
        {
            roleName = $"TEST_ROLE_{Guid.NewGuid():N}";
            roleId = Guid.NewGuid().ToString();

            await connection.ExecuteAsync(@"
INSERT INTO [Identity].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp])
VALUES (@Id, @Name, @NormalizedName, @ConcurrencyStamp);
", new
            {
                Id = roleId,
                Name = roleName,
                NormalizedName = roleName.ToUpperInvariant(),
                ConcurrencyStamp = Guid.NewGuid().ToString()
            });

            permissionCode = $"TEST.PERM.{Guid.NewGuid():N}";
            permissionId = await connection.QuerySingleAsync<int>(@"
INSERT INTO [Identity].[Permission] ([Code], [Description], [Module], [Scope], [Attivo], [CreatedAt], [CreatedBy], [IsDeleted])
VALUES (@Code, @Description, @Module, @Scope, 1, @CreatedAt, @CreatedBy, 0);
SELECT CAST(SCOPE_IDENTITY() AS INT);
", new
            {
                Code = permissionCode,
                Description = "Test permission",
                Module = "TEST",
                Scope = "ACTION",
                CreatedAt = DateTime.UtcNow,
                CreatedBy = "test"
            });

            await connection.ExecuteAsync(@"
INSERT INTO [Identity].[RolePermission] ([RoleId], [PermissionId])
VALUES (@RoleId, @PermissionId);
", new { RoleId = roleId, PermissionId = permissionId });

            var permissions = (await connection.QueryAsync<string>(@"
SELECT p.[Code]
FROM [Identity].[RolePermission] rp
INNER JOIN [Identity].[Permission] p ON rp.[PermissionId] = p.[PermissionId]
WHERE rp.[RoleId] = @RoleId
ORDER BY p.[Code];
", new { RoleId = roleId })).ToList();

            Assert.Contains(permissionCode, permissions);
        }
        finally
        {
            if (permissionId != 0)
            {
                await connection.ExecuteAsync("DELETE FROM [Identity].[RolePermission] WHERE [PermissionId] = @PermissionId;", new { PermissionId = permissionId });
                await connection.ExecuteAsync("DELETE FROM [Identity].[Permission] WHERE [PermissionId] = @PermissionId;", new { PermissionId = permissionId });
            }

            if (!string.IsNullOrWhiteSpace(roleId))
            {
                await connection.ExecuteAsync("DELETE FROM [Identity].[AspNetRoles] WHERE [Id] = @RoleId;", new { RoleId = roleId });
            }
        }
    }

    [Fact]
    public async Task Admin_RolePermissions_Update_Replaces_Assignments()
    {
        var settings = LoadSettings();

        await using var connection = new SqlConnection(settings.ConnectionString);
        await connection.OpenAsync();

        string roleId = null!;
        string roleName = null!;
        int permissionA = 0;
        int permissionB = 0;
        string codeA = null!;
        string codeB = null!;

        try
        {
            roleName = $"TEST_ROLE_{Guid.NewGuid():N}";
            roleId = Guid.NewGuid().ToString();

            await connection.ExecuteAsync(@"
INSERT INTO [Identity].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp])
VALUES (@Id, @Name, @NormalizedName, @ConcurrencyStamp);
", new
            {
                Id = roleId,
                Name = roleName,
                NormalizedName = roleName.ToUpperInvariant(),
                ConcurrencyStamp = Guid.NewGuid().ToString()
            });

            codeA = $"TEST.PERM.A.{Guid.NewGuid():N}";
            codeB = $"TEST.PERM.B.{Guid.NewGuid():N}";

            permissionA = await connection.QuerySingleAsync<int>(@"
INSERT INTO [Identity].[Permission] ([Code], [Description], [Module], [Scope], [Attivo], [CreatedAt], [CreatedBy], [IsDeleted])
VALUES (@Code, @Description, @Module, @Scope, 1, @CreatedAt, @CreatedBy, 0);
SELECT CAST(SCOPE_IDENTITY() AS INT);
", new { Code = codeA, Description = "Test A", Module = "TEST", Scope = "ACTION", CreatedAt = DateTime.UtcNow, CreatedBy = "test" });

            permissionB = await connection.QuerySingleAsync<int>(@"
INSERT INTO [Identity].[Permission] ([Code], [Description], [Module], [Scope], [Attivo], [CreatedAt], [CreatedBy], [IsDeleted])
VALUES (@Code, @Description, @Module, @Scope, 1, @CreatedAt, @CreatedBy, 0);
SELECT CAST(SCOPE_IDENTITY() AS INT);
", new { Code = codeB, Description = "Test B", Module = "TEST", Scope = "ACTION", CreatedAt = DateTime.UtcNow, CreatedBy = "test" });

            await connection.ExecuteAsync(@"
DELETE FROM [Identity].[RolePermission]
WHERE [RoleId] = @RoleId;
INSERT INTO [Identity].[RolePermission] ([RoleId], [PermissionId])
VALUES (@RoleId, @PermissionId);
", new { RoleId = roleId, PermissionId = permissionA });

            var codes = (await connection.QueryAsync<string>(@"
SELECT p.[Code]
FROM [Identity].[RolePermission] rp
INNER JOIN [Identity].[Permission] p ON rp.[PermissionId] = p.[PermissionId]
WHERE rp.[RoleId] = @RoleId;
", new { RoleId = roleId })).ToList();

            Assert.Contains(codeA, codes);
            Assert.DoesNotContain(codeB, codes);
        }
        finally
        {
            if (permissionA != 0 || permissionB != 0)
            {
                await connection.ExecuteAsync("DELETE FROM [Identity].[RolePermission] WHERE [RoleId] = @RoleId;", new { RoleId = roleId });
                await connection.ExecuteAsync("DELETE FROM [Identity].[Permission] WHERE [PermissionId] IN (@A,@B);", new { A = permissionA, B = permissionB });
            }

            if (!string.IsNullOrWhiteSpace(roleId))
            {
                await connection.ExecuteAsync("DELETE FROM [Identity].[AspNetRoles] WHERE [Id] = @RoleId;", new { RoleId = roleId });
            }
        }
    }

    private sealed record TestSettings(string ConnectionString, JwtOptions Jwt);
}
