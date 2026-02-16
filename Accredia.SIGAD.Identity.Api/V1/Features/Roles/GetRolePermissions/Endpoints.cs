using Dapper;
using Accredia.SIGAD.Identity.Api.Contracts;
using Accredia.SIGAD.Identity.Api.Database;
using Accredia.SIGAD.Identity.Api.Services;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Roles.GetRolePermissions;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/roles/{roleId}/permissions", "GetRolePermissions", async (
                string roleId,
                ISqlConnectionFactory connectionFactory,
                ILogger<EndpointConfiguration> logger,
                CancellationToken cancellationToken) =>
            {
                using var scope = AuthAudit.BeginScope(logger, "RolePermissionsGet", roleId: roleId);

                if (string.IsNullOrWhiteSpace(roleId))
                {
                    logger.LogWarning(AuthAudit.Events.RolePermissionsValidationFailed, "RolePermissionsValidationFailed");
                    return Results.BadRequest(new { error = "RoleId is required." });
                }

                const string roleSql = @"
SELECT [Id] AS RoleId, [Name]
FROM [Identity].[AspNetRoles]
WHERE [Id] = @RoleId;
";

                const string permsSql = @"
SELECT p.[Code]
FROM [Identity].[RolePermission] rp
INNER JOIN [Identity].[Permission] p ON rp.[PermissionId] = p.[PermissionId]
WHERE rp.[RoleId] = @RoleId
ORDER BY p.[Code];
";

                await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
                var role = await connection.QuerySingleOrDefaultAsync<RoleDto>(
                    new CommandDefinition(roleSql, new { RoleId = roleId }, cancellationToken: cancellationToken));

                if (role is null)
                {
                    logger.LogInformation(AuthAudit.Events.RolePermissionsNotFound, "RolePermissionsNotFound for {RoleId}", roleId);
                    return Results.NotFound();
                }

                var permissions = (await connection.QueryAsync<string>(
                    new CommandDefinition(permsSql, new { RoleId = roleId }, cancellationToken: cancellationToken))).ToList();

                logger.LogInformation(AuthAudit.Events.RolePermissionsFetched, "RolePermissionsFetched count={Count}", permissions.Count);
                return Results.Ok(new RolePermissionsResponse(role.RoleId, role.Name, permissions));
            },
            builder => builder
                .Produces<RolePermissionsResponse>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status400BadRequest)
                .Produces(StatusCodes.Status401Unauthorized)
                .Produces(StatusCodes.Status403Forbidden)
                .Produces(StatusCodes.Status404NotFound)
                .RequireAuthorization("Admin"));
    }
}
