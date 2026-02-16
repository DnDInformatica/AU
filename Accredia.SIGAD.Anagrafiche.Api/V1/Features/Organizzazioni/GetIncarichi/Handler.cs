using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetIncarichi;

internal static class Handler
{
    public static async Task<IReadOnlyList<IncaricoDto>?> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string orgExistsSql = @"
SELECT COUNT(1)
FROM [Organizzazioni].[Organizzazione] o
WHERE o.OrganizzazioneId = @OrganizzazioneId
  AND o.DataCancellazione IS NULL
  AND (o.DataInizioValidita IS NULL OR o.DataInizioValidita <= SYSUTCDATETIME())
  AND (o.DataFineValidita IS NULL OR o.DataFineValidita >= SYSUTCDATETIME());";

        const string incarichiSql = @"
SELECT
    i.IncaricoId,
    i.PersonaId,
    p.Cognome AS PersonaCognome,
    p.Nome AS PersonaNome,
    p.CodiceFiscale AS PersonaCodiceFiscale,
    COALESCE(tr.Descrizione, CAST(i.TipoRuoloId AS nvarchar(50))) AS Ruolo,
    i.DataInizio,
    i.DataFine,
    i.StatoIncarico,
    i.UnitaOrganizzativaId,
    i.DataCancellazione
FROM [Organizzazioni].[Incarico] i
LEFT JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = i.UnitaOrganizzativaId
LEFT JOIN [Persone].[Persona] p ON p.PersonaId = i.PersonaId
LEFT JOIN [Tipologica].[TipoRuolo] tr ON tr.TipoRuoloId = i.TipoRuoloId
WHERE (i.OrganizzazioneId = @OrganizzazioneId OR u.OrganizzazioneId = @OrganizzazioneId)
  AND (@IncludeDeleted = 1 OR i.DataCancellazione IS NULL)
  AND (i.DataInizioValidita IS NULL OR i.DataInizioValidita <= SYSUTCDATETIME())
  AND (i.DataFineValidita IS NULL OR i.DataFineValidita >= SYSUTCDATETIME())
ORDER BY i.DataInizio DESC;";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var exists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(orgExistsSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken));

        if (exists == 0)
        {
            return null;
        }

        var rows = (await connection.QueryAsync<IncaricoDto>(
            new CommandDefinition(
                incarichiSql,
                new { command.OrganizzazioneId, IncludeDeleted = command.IncludeDeleted ? 1 : 0 },
                cancellationToken: cancellationToken))).ToList();

        return rows;
    }
}
