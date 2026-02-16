using Dapper;
using Accredia.SIGAD.Identity.Api.Database;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.LogoutUsers;

internal static class Handler
{
    public static async Task Handle(
        Command command,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string sql = @"
UPDATE [Identity].[RefreshToken]
SET [RevokedAt] = @RevokedAt
WHERE [UserId] IN @UserIds AND [RevokedAt] IS NULL;
";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        await connection.ExecuteAsync(
            new CommandDefinition(sql, new { UserIds = command.UserIds, RevokedAt = DateTime.UtcNow }, cancellationToken: cancellationToken));
    }
}
