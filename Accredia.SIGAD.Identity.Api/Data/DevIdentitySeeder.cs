using Dapper;
using Accredia.SIGAD.Identity.Api.Database;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;

namespace Accredia.SIGAD.Identity.Api.Data;

internal sealed class DevIdentitySeeder
{
    private const string DefaultAdminPassword = "Password!12345";
    private readonly ISqlConnectionFactory _connectionFactory;
    private readonly IOptions<DatabaseOptions> _dbOptions;
    private readonly IOptions<DevSeedOptions> _seedOptions;
    private readonly ILogger<DevIdentitySeeder> _logger;

    public DevIdentitySeeder(
        ISqlConnectionFactory connectionFactory,
        IOptions<DatabaseOptions> dbOptions,
        IOptions<DevSeedOptions> seedOptions,
        ILogger<DevIdentitySeeder> logger)
    {
        _connectionFactory = connectionFactory;
        _dbOptions = dbOptions;
        _seedOptions = seedOptions;
        _logger = logger;
    }

    public async Task SeedAsync(CancellationToken cancellationToken = default)
    {
        var options = _seedOptions.Value;
        if (string.IsNullOrWhiteSpace(options.AdminUserName) || string.IsNullOrWhiteSpace(options.AdminEmail))
        {
            _logger.LogWarning("DevSeed disabilitato: AdminUserName o AdminEmail mancanti.");
            return;
        }

        var schema = string.IsNullOrWhiteSpace(_dbOptions.Value.Schema) ? "Identity" : _dbOptions.Value.Schema;
        var adminPassword = string.IsNullOrWhiteSpace(options.AdminPassword)
            ? DefaultAdminPassword
            : options.AdminPassword!;

        if (string.IsNullOrWhiteSpace(options.AdminPassword))
        {
            _logger.LogWarning("DevSeed usa la password di default per admin. Imposta DevSeed:AdminPassword per override.");
        }

        var normalizedUserName = options.AdminUserName.ToUpperInvariant();
        var normalizedEmail = options.AdminEmail.ToUpperInvariant();
        var normalizedRole = options.AdminRole.ToUpperInvariant();

        await using var connection = await _connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var roleId = await EnsureRoleAsync(connection, schema, options.AdminRole, normalizedRole, cancellationToken);
        var userId = await EnsureAdminUserAsync(
            connection,
            schema,
            options.AdminUserName,
            normalizedUserName,
            options.AdminEmail,
            normalizedEmail,
            adminPassword,
            cancellationToken);

        if (!string.IsNullOrWhiteSpace(roleId) && !string.IsNullOrWhiteSpace(userId))
        {
            await EnsureUserRoleAsync(connection, schema, userId, roleId, cancellationToken);
            await EnsureAdminPermissionsAsync(connection, schema, roleId, cancellationToken);
        }
    }

    private async Task EnsureAdminPermissionsAsync(
        System.Data.Common.DbConnection connection,
        string schema,
        string roleId,
        CancellationToken cancellationToken)
    {
        // Keep this minimal: the Web menu requires these permissions to show Admin/User management entries.
        // In DEV we guarantee they exist and are assigned to the configured AdminRole.
        var now = DateTime.UtcNow;

        var moduleAdminAccessId = await EnsurePermissionAsync(
            connection,
            schema,
            code: "MODULE.ADMIN.ACCESS",
            description: "Accesso modulo amministrazione",
            module: "ADMIN",
            scope: "MODULE",
            createdAt: now,
            createdBy: "dev-seed",
            cancellationToken);

        var usersManageId = await EnsurePermissionAsync(
            connection,
            schema,
            code: "ADMIN.USERS.MANAGE",
            description: "Gestione utenti",
            module: "ADMIN",
            scope: "ACTION",
            createdAt: now,
            createdBy: "dev-seed",
            cancellationToken);

        var rolesManageId = await EnsurePermissionAsync(
            connection,
            schema,
            code: "ADMIN.ROLES.MANAGE",
            description: "Gestione ruoli",
            module: "ADMIN",
            scope: "ACTION",
            createdAt: now,
            createdBy: "dev-seed",
            cancellationToken);

        var permissionsManageId = await EnsurePermissionAsync(
            connection,
            schema,
            code: "ADMIN.PERMISSIONS.MANAGE",
            description: "Gestione permessi",
            module: "ADMIN",
            scope: "ACTION",
            createdAt: now,
            createdBy: "dev-seed",
            cancellationToken);

        if (moduleAdminAccessId.HasValue)
        {
            await EnsureRolePermissionAsync(connection, schema, roleId, moduleAdminAccessId.Value, cancellationToken);
        }

        if (usersManageId.HasValue)
        {
            await EnsureRolePermissionAsync(connection, schema, roleId, usersManageId.Value, cancellationToken);
        }

        if (rolesManageId.HasValue)
        {
            await EnsureRolePermissionAsync(connection, schema, roleId, rolesManageId.Value, cancellationToken);
        }

        if (permissionsManageId.HasValue)
        {
            await EnsureRolePermissionAsync(connection, schema, roleId, permissionsManageId.Value, cancellationToken);
        }
    }

    private static async Task<int?> EnsurePermissionAsync(
        System.Data.Common.DbConnection connection,
        string schema,
        string code,
        string description,
        string module,
        string scope,
        DateTime createdAt,
        string createdBy,
        CancellationToken cancellationToken)
    {
        var selectSql = $@"
SELECT [PermissionId]
FROM [{schema}].[Permission]
WHERE [Code] = @Code AND [IsDeleted] = 0;
";

        var permissionId = await connection.QuerySingleOrDefaultAsync<int?>(
            new CommandDefinition(selectSql, new { Code = code }, cancellationToken: cancellationToken));

        if (permissionId.HasValue)
        {
            return permissionId.Value;
        }

        var insertSql = $@"
INSERT INTO [{schema}].[Permission] ([Code], [Description], [Module], [Scope], [Attivo], [CreatedAt], [CreatedBy], [IsDeleted])
OUTPUT INSERTED.[PermissionId]
VALUES (@Code, @Description, @Module, @Scope, 1, @CreatedAt, @CreatedBy, 0);
";

        return await connection.QuerySingleAsync<int>(
            new CommandDefinition(
                insertSql,
                new
                {
                    Code = code,
                    Description = description,
                    Module = module,
                    Scope = scope,
                    CreatedAt = createdAt,
                    CreatedBy = createdBy
                },
                cancellationToken: cancellationToken));
    }

    private static async Task EnsureRolePermissionAsync(
        System.Data.Common.DbConnection connection,
        string schema,
        string roleId,
        int permissionId,
        CancellationToken cancellationToken)
    {
        var existsSql = $@"
SELECT 1
FROM [{schema}].[RolePermission]
WHERE [RoleId] = @RoleId AND [PermissionId] = @PermissionId;
";

        var exists = await connection.QuerySingleOrDefaultAsync<int?>(
            new CommandDefinition(
                existsSql,
                new { RoleId = roleId, PermissionId = permissionId },
                cancellationToken: cancellationToken));

        if (exists.HasValue)
        {
            return;
        }

        var insertSql = $@"
INSERT INTO [{schema}].[RolePermission] ([RoleId], [PermissionId])
VALUES (@RoleId, @PermissionId);
";

        await connection.ExecuteAsync(
            new CommandDefinition(
                insertSql,
                new { RoleId = roleId, PermissionId = permissionId },
                cancellationToken: cancellationToken));
    }

    private static async Task<string?> EnsureRoleAsync(
        System.Data.Common.DbConnection connection,
        string schema,
        string roleName,
        string normalizedRoleName,
        CancellationToken cancellationToken)
    {
        var selectRoleSql = $@"
SELECT [Id]
FROM [{schema}].[AspNetRoles]
WHERE [NormalizedName] = @NormalizedRoleName;
";

        var roleId = await connection.QuerySingleOrDefaultAsync<string>(
            new CommandDefinition(
                selectRoleSql,
                new { NormalizedRoleName = normalizedRoleName },
                cancellationToken: cancellationToken));

        if (!string.IsNullOrWhiteSpace(roleId))
        {
            return roleId;
        }

        roleId = Guid.NewGuid().ToString();
        var insertRoleSql = $@"
INSERT INTO [{schema}].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp])
VALUES (@Id, @Name, @NormalizedName, @ConcurrencyStamp);
";

        await connection.ExecuteAsync(
            new CommandDefinition(
                insertRoleSql,
                new
                {
                    Id = roleId,
                    Name = roleName,
                    NormalizedName = normalizedRoleName,
                    ConcurrencyStamp = Guid.NewGuid().ToString()
                },
                cancellationToken: cancellationToken));

        return roleId;
    }

    private static async Task<string?> EnsureAdminUserAsync(
        System.Data.Common.DbConnection connection,
        string schema,
        string userName,
        string normalizedUserName,
        string email,
        string normalizedEmail,
        string password,
        CancellationToken cancellationToken)
    {
        var selectUserSql = $@"
SELECT [Id]
FROM [{schema}].[AspNetUsers]
WHERE [NormalizedUserName] = @NormalizedUserName;
";

        var userId = await connection.QuerySingleOrDefaultAsync<string>(
            new CommandDefinition(
                selectUserSql,
                new { NormalizedUserName = normalizedUserName },
                cancellationToken: cancellationToken));

        if (!string.IsNullOrWhiteSpace(userId))
        {
            return userId;
        }

        var hasher = new PasswordHasher<object>();
        var passwordHash = hasher.HashPassword(new object(), password);
        userId = Guid.NewGuid().ToString();

        var insertUserSql = $@"
INSERT INTO [{schema}].[AspNetUsers] (
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

        await connection.ExecuteAsync(
            new CommandDefinition(
                insertUserSql,
                new
                {
                    Id = userId,
                    UserName = userName,
                    NormalizedUserName = normalizedUserName,
                    Email = email,
                    NormalizedEmail = normalizedEmail,
                    PasswordHash = passwordHash,
                    SecurityStamp = Guid.NewGuid().ToString(),
                    ConcurrencyStamp = Guid.NewGuid().ToString()
                },
                cancellationToken: cancellationToken));

        return userId;
    }

    private static async Task EnsureUserRoleAsync(
        System.Data.Common.DbConnection connection,
        string schema,
        string userId,
        string roleId,
        CancellationToken cancellationToken)
    {
        var existsSql = $@"
SELECT 1
FROM [{schema}].[AspNetUserRoles]
WHERE [UserId] = @UserId AND [RoleId] = @RoleId;
";

        var exists = await connection.QuerySingleOrDefaultAsync<int?>(
            new CommandDefinition(
                existsSql,
                new { UserId = userId, RoleId = roleId },
                cancellationToken: cancellationToken));

        if (exists.HasValue)
        {
            return;
        }

        var insertSql = $@"
INSERT INTO [{schema}].[AspNetUserRoles] ([UserId], [RoleId])
VALUES (@UserId, @RoleId);
";

        await connection.ExecuteAsync(
            new CommandDefinition(
                insertSql,
                new { UserId = userId, RoleId = roleId },
                cancellationToken: cancellationToken));
    }
}
