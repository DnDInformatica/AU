using Dapper;
using Accredia.SIGAD.Identity.Api.Contracts;
using Accredia.SIGAD.Identity.Api.Database;
using Accredia.SIGAD.Identity.Api.Services;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Users.SetRoles;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedPut(app, "/users/{userId}/roles", "SetUserRoles", async (
                string userId,
                SetUserRolesRequest request,
                ISqlConnectionFactory connectionFactory,
                ILogger<EndpointConfiguration> logger,
                CancellationToken cancellationToken) =>
            {
                using var scope = AuthAudit.BeginScope(logger, "UserRolesSet", userId: userId, userCount: request.Roles.Count);

                if (string.IsNullOrWhiteSpace(userId))
                {
                    return Results.BadRequest(new { error = "UserId is required." });
                }

                if (request.Roles is null)
                {
                    return Results.BadRequest(new { error = "Roles is required." });
                }

                var normalizedRoles = request.Roles
                    .Select(role => role?.Trim())
                    .Where(role => !string.IsNullOrWhiteSpace(role))
                    .Select(role => role!.ToUpperInvariant())
                    .Distinct()
                    .ToArray();

                const string userExistsSql = "SELECT COUNT(1) FROM [Identity].[AspNetUsers] WHERE [Id] = @UserId;";

                const string rolesSql = @"
SELECT [Id], [NormalizedName]
FROM [Identity].[AspNetRoles]
WHERE [NormalizedName] IN @Roles;";

                const string deleteSql = "DELETE FROM [Identity].[AspNetUserRoles] WHERE [UserId] = @UserId;";

                const string insertSql = @"
INSERT INTO [Identity].[AspNetUserRoles] ([UserId], [RoleId])
VALUES (@UserId, @RoleId);";

                await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

                var userExists = await connection.ExecuteScalarAsync<int>(
                    new CommandDefinition(userExistsSql, new { UserId = userId }, cancellationToken: cancellationToken));
                if (userExists == 0)
                {
                    return Results.NotFound();
                }

                var roleRows = new List<RoleRow>();
                if (normalizedRoles.Length > 0)
                {
                    roleRows = (await connection.QueryAsync<RoleRow>(
                        new CommandDefinition(rolesSql, new { Roles = normalizedRoles }, cancellationToken: cancellationToken))).ToList();

                    var missing = normalizedRoles
                        .Except(roleRows.Select(r => r.NormalizedName), StringComparer.OrdinalIgnoreCase)
                        .ToArray();
                    if (missing.Length > 0)
                    {
                        return Results.BadRequest(new { error = $"Ruoli non trovati: {string.Join(", ", missing)}" });
                    }
                }

                using var tx = connection.BeginTransaction();

                var removed = await connection.ExecuteAsync(
                    new CommandDefinition(deleteSql, new { UserId = userId }, transaction: tx, cancellationToken: cancellationToken));

                var added = 0;
                foreach (var role in roleRows)
                {
                    added += await connection.ExecuteAsync(
                        new CommandDefinition(insertSql, new { UserId = userId, RoleId = role.Id }, transaction: tx, cancellationToken: cancellationToken));
                }

                tx.Commit();

                logger.LogInformation(AuthAudit.Events.AssignRolesSucceeded, "UserRolesSetSucceeded removed={Removed} added={Added}", removed, added);
                return Results.Ok(new SetUserRolesResponse(userId, removed, added));
            },
            builder => builder
                .Produces<SetUserRolesResponse>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status400BadRequest)
                .Produces(StatusCodes.Status401Unauthorized)
                .Produces(StatusCodes.Status403Forbidden)
                .Produces(StatusCodes.Status404NotFound)
                .RequireAuthorization("Admin"));
    }

    private sealed record RoleRow(string Id, string NormalizedName);
}

