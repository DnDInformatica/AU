using Dapper;
using Accredia.SIGAD.Identity.Api.Contracts;
using Accredia.SIGAD.Identity.Api.Database;
using Accredia.SIGAD.Identity.Api.Services;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Roles.GetAll;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/roles", "GetRoles", async (
                ISqlConnectionFactory connectionFactory,
                ILogger<EndpointConfiguration> logger,
                CancellationToken cancellationToken) =>
            {
                using var scope = AuthAudit.BeginScope(logger, "RolesList");

                const string sql = @"
SELECT [Id] AS RoleId, [Name]
FROM [Identity].[AspNetRoles]
ORDER BY [Name];
";

                await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
                var roles = (await connection.QueryAsync<RoleDto>(
                    new CommandDefinition(sql, cancellationToken: cancellationToken))).ToList();

                logger.LogInformation(AuthAudit.Events.RolesListed, "RolesListed count={Count}", roles.Count);
                return Results.Ok(roles);
            },
            builder => builder
                .Produces<IReadOnlyList<RoleDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status401Unauthorized)
                .Produces(StatusCodes.Status403Forbidden)
                .RequireAuthorization("Admin"));
    }
}
