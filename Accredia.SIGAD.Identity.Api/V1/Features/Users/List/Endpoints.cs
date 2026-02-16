using Dapper;
using Accredia.SIGAD.Identity.Api.Contracts;
using Accredia.SIGAD.Identity.Api.Database;
using Accredia.SIGAD.Identity.Api.Services;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Users.List;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/users", "GetUsers", async (
                int? page,
                int? pageSize,
                ISqlConnectionFactory connectionFactory,
                ILogger<EndpointConfiguration> logger,
                CancellationToken cancellationToken) =>
            {
                var pageValue = page ?? 1;
                var pageSizeValue = pageSize ?? 50;

                using var scope = AuthAudit.BeginScope(logger, "UsersList", userCount: pageSizeValue);

                if (pageValue <= 0)
                {
                    return Results.BadRequest(new { error = "Page must be >= 1." });
                }

                if (pageSizeValue <= 0 || pageSizeValue > 200)
                {
                    return Results.BadRequest(new { error = "PageSize must be between 1 and 200." });
                }

                var offset = (pageValue - 1) * pageSizeValue;

                const string countSql = "SELECT COUNT(1) FROM [Identity].[AspNetUsers];";

                const string usersSql = @"
SELECT
    [Id] AS UserId,
    [UserName] AS Username,
    [Email],
    [EmailConfirmed],
    [LockoutEnabled],
    [LockoutEnd],
    [AccessFailedCount]
FROM [Identity].[AspNetUsers]
ORDER BY [UserName]
OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;
";

                const string rolesSql = @"
SELECT ur.[UserId], r.[Name]
FROM [Identity].[AspNetUserRoles] ur
INNER JOIN [Identity].[AspNetRoles] r ON ur.[RoleId] = r.[Id]
WHERE ur.[UserId] IN @UserIds
ORDER BY r.[Name];
";

                await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

                var totalCount = await connection.ExecuteScalarAsync<int>(
                    new CommandDefinition(countSql, cancellationToken: cancellationToken));

                var users = (await connection.QueryAsync<UserRow>(
                    new CommandDefinition(usersSql, new { Offset = offset, PageSize = pageSizeValue }, cancellationToken: cancellationToken))).ToList();

                var userIds = users.Select(u => u.UserId).ToArray();
                var rolesByUser = new Dictionary<string, List<string>>(StringComparer.OrdinalIgnoreCase);

                if (userIds.Length > 0)
                {
                    var roleRows = await connection.QueryAsync<UserRoleRow>(
                        new CommandDefinition(rolesSql, new { UserIds = userIds }, cancellationToken: cancellationToken));

                    foreach (var row in roleRows)
                    {
                        if (string.IsNullOrWhiteSpace(row.Name))
                        {
                            continue;
                        }

                        if (!rolesByUser.TryGetValue(row.UserId, out var list))
                        {
                            list = new List<string>();
                            rolesByUser[row.UserId] = list;
                        }

                        list.Add(row.Name);
                    }
                }

                var responseUsers = users
                    .Select(u =>
                    {
                        IReadOnlyList<string> userRoles =
                            rolesByUser.TryGetValue(u.UserId, out var roles)
                                ? roles
                                : Array.Empty<string>();
                        return new UserDto(
                            u.UserId,
                            u.Username,
                            u.Email,
                            u.EmailConfirmed,
                            u.LockoutEnabled,
                            u.LockoutEnd,
                            u.AccessFailedCount,
                            userRoles);
                    })
                    .ToList();

                return Results.Ok(new UsersListResponse(responseUsers, totalCount, pageValue, pageSizeValue));
            },
            builder => builder
                .Produces<UsersListResponse>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status400BadRequest)
                .Produces(StatusCodes.Status401Unauthorized)
                .Produces(StatusCodes.Status403Forbidden)
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

    private sealed record UserRoleRow(string UserId, string? Name);
}
