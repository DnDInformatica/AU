using Dapper;
using Accredia.SIGAD.Identity.Api.Database;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.Logout;

internal static class Handler
{
    public static async Task<bool> Handle(
        Command command,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string sql = @"
UPDATE [Identity].[RefreshToken]
SET [RevokedAt] = @RevokedAt
WHERE [Token] = @Token AND [RevokedAt] IS NULL;
";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var affected = await connection.ExecuteAsync(
            new CommandDefinition(sql, new { Token = command.RefreshToken, RevokedAt = DateTime.UtcNow }, cancellationToken: cancellationToken));

        return affected > 0;
    }
}
