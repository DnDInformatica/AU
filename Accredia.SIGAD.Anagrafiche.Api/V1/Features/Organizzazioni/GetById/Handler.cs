using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetById;

internal static class Handler
{
    public static async Task<OrganizzazioneDto?> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string sql = @"
SELECT
    [OrganizzazioneId],
    [Codice],
    [Denominazione],
    [IsActive],
    [CreatedUtc]
FROM [Anagrafiche].[Organizzazioni]
WHERE [OrganizzazioneId] = @OrganizzazioneId;";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return await connection.QuerySingleOrDefaultAsync<OrganizzazioneDto>(
            new CommandDefinition(
                sql,
                new { command.OrganizzazioneId },
                cancellationToken: cancellationToken));
    }
}
