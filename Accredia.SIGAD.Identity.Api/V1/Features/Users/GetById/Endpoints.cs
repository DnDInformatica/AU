using Dapper;
using Accredia.SIGAD.Identity.Api.Contracts;
using Accredia.SIGAD.Identity.Api.Database;
using Accredia.SIGAD.Identity.Api.Services;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Users.GetById;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/users/{userId}", "GetUserById", async (
                string userId,
                ISqlConnectionFactory connectionFactory,
                ILogger<EndpointConfiguration> logger,
                CancellationToken cancellationToken) =>
            {
                using var scope = AuthAudit.BeginScope(logger, "UserGetById", userId: userId);

                if (string.IsNullOrWhiteSpace(userId))
                {
                    return Results.BadRequest(new { error = "UserId is required." });
                }

                const string userSql = @"
SELECT
    [Id] AS UserId,
    [UserName] AS Username,
    [Email],
    [EmailConfirmed],
    [LockoutEnabled],
    [LockoutEnd],
    [AccessFailedCount]
FROM [Identity].[AspNetUsers]
WHERE [Id] = @UserId;
";

                const string rolesSql = @"
SELECT r.[Name]
FROM [Identity].[AspNetUserRoles] ur
INNER JOIN [Identity].[AspNetRoles] r ON ur.[RoleId] = r.[Id]
WHERE ur.[UserId] = @UserId
ORDER BY r.[Name];
";

                await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

                var user = await connection.QuerySingleOrDefaultAsync<UserRow>(
                    new CommandDefinition(userSql, new { UserId = userId }, cancellationToken: cancellationToken));

                if (user is null)
                {
                    return Results.NotFound();
                }

                var roles = (await connection.QueryAsync<string?>(
                        new CommandDefinition(rolesSql, new { UserId = userId }, cancellationToken: cancellationToken)))
                    .Where(r => !string.IsNullOrWhiteSpace(r))
                    .Cast<string>()
                    .ToList();

                return Results.Ok(new UserDto(
                    user.UserId,
                    user.Username,
                    user.Email,
                    user.EmailConfirmed,
                    user.LockoutEnabled,
                    user.LockoutEnd,
                    user.AccessFailedCount,
                    roles));
            },
            builder => builder
                .Produces<UserDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status400BadRequest)
                .Produces(StatusCodes.Status401Unauthorized)
                .Produces(StatusCodes.Status403Forbidden)
                .Produces(StatusCodes.Status404NotFound)
                .RequireAuthorization("Admin"));
    }

    private sealed record UserRow(
        string UserId,
        string? Username,
        string? Email,
        bool EmailConfirmed,
        bool LockoutEnabled,
        DateTimeOffset? LockoutEnd,
        int AccessFailedCount);
}

