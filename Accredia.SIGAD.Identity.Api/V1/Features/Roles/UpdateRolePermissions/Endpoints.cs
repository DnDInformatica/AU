using Dapper;
using Accredia.SIGAD.Identity.Api.Contracts;
using Accredia.SIGAD.Identity.Api.Database;
using Accredia.SIGAD.Identity.Api.Services;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Roles.UpdateRolePermissions;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPut(app, "/roles/{roleId}/permissions", "UpdateRolePermissions", async (
                string roleId,
                UpdateRolePermissionsRequest request,
                ISqlConnectionFactory connectionFactory,
                ILogger<EndpointConfiguration> logger,
                CancellationToken cancellationToken) =>
            {
                using var scope = AuthAudit.BeginScope(logger, "RolePermissionsUpdate", roleId: roleId);

                if (string.IsNullOrWhiteSpace(roleId))
                {
                    logger.LogWarning(AuthAudit.Events.RolePermissionsValidationFailed, "RolePermissionsValidationFailed");
                    return Results.BadRequest(new { error = "RoleId is required." });
                }

                if (request.Permissions is null || request.Permissions.Count == 0)
                {
                    logger.LogWarning(AuthAudit.Events.RolePermissionsValidationFailed, "RolePermissionsValidationFailed");
                    return Results.BadRequest(new { error = "Permissions is required." });
                }

                const string roleSql = @"
SELECT [Id] AS RoleId
FROM [Identity].[AspNetRoles]
WHERE [Id] = @RoleId;
";

                const string permIdsSql = @"
SELECT [PermissionId]
FROM [Identity].[Permission]
WHERE [Code] IN @Codes AND [IsDeleted] = 0;
";

                const string deleteSql = @"
DELETE FROM [Identity].[RolePermission]
WHERE [RoleId] = @RoleId;
";

                const string insertSql = @"
INSERT INTO [Identity].[RolePermission] ([RoleId], [PermissionId])
VALUES (@RoleId, @PermissionId);
";

                await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

                var roleExists = await connection.QuerySingleOrDefaultAsync<string>(
                    new CommandDefinition(roleSql, new { RoleId = roleId }, cancellationToken: cancellationToken));

                if (roleExists is null)
                {
                    logger.LogInformation(AuthAudit.Events.RolePermissionsNotFound, "RolePermissionsNotFound for {RoleId}", roleId);
                    return Results.NotFound();
                }

                var permissionIds = (await connection.QueryAsync<int>(
                    new CommandDefinition(permIdsSql, new { Codes = request.Permissions }, cancellationToken: cancellationToken))).ToList();

                if (permissionIds.Count != request.Permissions.Count)
                {
                    logger.LogWarning(AuthAudit.Events.RolePermissionsValidationFailed, "RolePermissionsValidationFailed invalid permissions for {RoleId}", roleId);
                    return Results.BadRequest(new { error = "One or more permissions are invalid." });
                }

                using var tx = connection.BeginTransaction();

                await connection.ExecuteAsync(
                    new CommandDefinition(deleteSql, new { RoleId = roleId }, transaction: tx, cancellationToken: cancellationToken));

                foreach (var permissionId in permissionIds)
                {
                    await connection.ExecuteAsync(
                        new CommandDefinition(insertSql, new { RoleId = roleId, PermissionId = permissionId }, transaction: tx, cancellationToken: cancellationToken));
                }

                tx.Commit();

                logger.LogInformation(AuthAudit.Events.RolePermissionsUpdated, "RolePermissionsUpdated count={Count}", permissionIds.Count);
                return Results.NoContent();
            },
            builder => builder
                .Produces(StatusCodes.Status204NoContent)
                .Produces(StatusCodes.Status400BadRequest)
                .Produces(StatusCodes.Status401Unauthorized)
                .Produces(StatusCodes.Status403Forbidden)
                .Produces(StatusCodes.Status404NotFound)
                .RequireAuthorization("Admin"));
    }
}
