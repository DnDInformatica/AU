using Dapper;
using Accredia.SIGAD.Identity.Api.Database;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Users.AssignRoles;

internal static class Handler
{
    public static async Task<AssignRolesResponse?> Handle(
        Command command,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        const string userExistsSql = "SELECT COUNT(1) FROM [Identity].[AspNetUsers] WHERE [Id] = @UserId;";
        var userExists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(userExistsSql, new { UserId = command.UserId }, cancellationToken: cancellationToken));
        if (userExists == 0)
        {
            return null;
        }

        var normalizedRoles = command.Roles
            .Select(role => role.Trim())
            .Where(role => !string.IsNullOrWhiteSpace(role))
            .Select(role => role.ToUpperInvariant())
            .Distinct()
            .ToArray();

        const string rolesSql = @"
SELECT [Id], [NormalizedName]
FROM [Identity].[AspNetRoles]
WHERE [NormalizedName] IN @Roles;";

        var roleRows = (await connection.QueryAsync<RoleRow>(
            new CommandDefinition(rolesSql, new { Roles = normalizedRoles }, cancellationToken: cancellationToken)))
            .ToList();

        var missing = normalizedRoles
            .Except(roleRows.Select(r => r.NormalizedName), StringComparer.OrdinalIgnoreCase)
            .ToArray();
        if (missing.Length > 0)
        {
            throw new ArgumentException($"Ruoli non trovati: {string.Join(", ", missing)}");
        }

        const string insertSql = @"
IF NOT EXISTS (
    SELECT 1 FROM [Identity].[AspNetUserRoles]
    WHERE [UserId] = @UserId AND [RoleId] = @RoleId
)
BEGIN
    INSERT INTO [Identity].[AspNetUserRoles] ([UserId], [RoleId])
    VALUES (@UserId, @RoleId);
END";

        var added = 0;
        foreach (var role in roleRows)
        {
            var rows = await connection.ExecuteAsync(
                new CommandDefinition(insertSql, new { UserId = command.UserId, RoleId = role.Id }, cancellationToken: cancellationToken));
            if (rows > 0)
            {
                added += 1;
            }
        }

        return new AssignRolesResponse(command.UserId, added);
    }

    private sealed record RoleRow(string Id, string NormalizedName);
}
