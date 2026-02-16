using Dapper;
using Accredia.SIGAD.Identity.Api.Contracts;
using Accredia.SIGAD.Identity.Api.Database;
using Accredia.SIGAD.Identity.Api.Services;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Permissions.GetAll;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/permissions", "GetPermissions", async (
                ISqlConnectionFactory connectionFactory,
                ILogger<EndpointConfiguration> logger,
                CancellationToken cancellationToken) =>
            {
                using var scope = AuthAudit.BeginScope(logger, "PermissionsList");

                const string sql = @"
SELECT [PermissionId], [Code], [Description], [Module], [Scope], [Attivo]
FROM [Identity].[Permission]
WHERE [IsDeleted] = 0
ORDER BY [Module], [Code];
";

                await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
                var permissions = (await connection.QueryAsync<PermissionDto>(
                    new CommandDefinition(sql, cancellationToken: cancellationToken))).ToList();

                logger.LogInformation(AuthAudit.Events.PermissionsListed, "PermissionsListed count={Count}", permissions.Count);
                return Results.Ok(permissions);
            },
            builder => builder
                .Produces<IReadOnlyList<PermissionDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status401Unauthorized)
                .Produces(StatusCodes.Status403Forbidden)
                .RequireAuthorization("Admin"));
    }
}
