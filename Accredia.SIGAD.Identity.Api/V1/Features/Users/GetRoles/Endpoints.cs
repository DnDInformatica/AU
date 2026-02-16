using Dapper;
using Accredia.SIGAD.Identity.Api.Contracts;
using Accredia.SIGAD.Identity.Api.Database;
using Accredia.SIGAD.Identity.Api.Services;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Users.GetRoles;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/users/{userId}/roles", "GetUserRoles", async (
                string userId,
                ISqlConnectionFactory connectionFactory,
                ILogger<EndpointConfiguration> logger,
                CancellationToken cancellationToken) =>
            {
                using var scope = AuthAudit.BeginScope(logger, "UserRolesGet", userId: userId);

                if (string.IsNullOrWhiteSpace(userId))
                {
                    return Results.BadRequest(new { error = "UserId is required." });
                }

                const string userExistsSql = "SELECT COUNT(1) FROM [Identity].[AspNetUsers] WHERE [Id] = @UserId;";
                const string rolesSql = @"
SELECT r.[Id] AS RoleId, r.[Name]
FROM [Identity].[AspNetUserRoles] ur
INNER JOIN [Identity].[AspNetRoles] r ON ur.[RoleId] = r.[Id]
WHERE ur.[UserId] = @UserId
ORDER BY r.[Name];
";

                await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

                var userExists = await connection.ExecuteScalarAsync<int>(
                    new CommandDefinition(userExistsSql, new { UserId = userId }, cancellationToken: cancellationToken));
                if (userExists == 0)
                {
                    return Results.NotFound();
                }

                var roles = (await connection.QueryAsync<RoleDto>(
                    new CommandDefinition(rolesSql, new { UserId = userId }, cancellationToken: cancellationToken))).ToList();

                return Results.Ok(roles);
            },
            builder => builder
                .Produces<IReadOnlyList<RoleDto>>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status400BadRequest)
                .Produces(StatusCodes.Status401Unauthorized)
                .Produces(StatusCodes.Status403Forbidden)
                .Produces(StatusCodes.Status404NotFound)
                .RequireAuthorization("Admin"));
    }
}

