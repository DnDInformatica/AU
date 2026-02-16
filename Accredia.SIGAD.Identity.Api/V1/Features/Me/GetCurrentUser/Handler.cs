using Dapper;
using Accredia.SIGAD.Identity.Api.Contracts;
using Accredia.SIGAD.Identity.Api.Database;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Me.GetCurrentUser;

internal static class Handler
{
    private sealed record AspNetUserRecord(
        string Id,
        string UserName,
        string Email);

    public static async Task<MeResponse?> Handle(
        Command command,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string userSql = @"
SELECT [Id], [UserName], [Email]
FROM [Identity].[AspNetUsers]
WHERE [Id] = @UserId;
";

        const string rolesSql = @"
SELECT r.[Name]
FROM [Identity].[AspNetUserRoles] ur
INNER JOIN [Identity].[AspNetRoles] r ON ur.[RoleId] = r.[Id]
WHERE ur.[UserId] = @UserId;
";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var user = await connection.QuerySingleOrDefaultAsync<AspNetUserRecord>(
            new CommandDefinition(userSql, new { command.UserId }, cancellationToken: cancellationToken));

        if (user is null)
            return null;

        var roles = (await connection.QueryAsync<string>(
            new CommandDefinition(rolesSql, new { command.UserId }, cancellationToken: cancellationToken))).ToList();

        const string permissionsSql = @"
SELECT DISTINCT p.[Code]
FROM [Identity].[RolePermission] rp
INNER JOIN [Identity].[Permission] p ON rp.[PermissionId] = p.[PermissionId]
WHERE rp.[RoleId] IN (
    SELECT ur.[RoleId]
    FROM [Identity].[AspNetUserRoles] ur
    WHERE ur.[UserId] = @UserId
);
";

        var permissions = (await connection.QueryAsync<string>(
            new CommandDefinition(permissionsSql, new { command.UserId }, cancellationToken: cancellationToken))).ToList();

        return new MeResponse(
            user.Id,
            user.UserName,
            roles,
            permissions);
    }
}
