using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.GetIncarichi;

internal static class Handler
{
    public static async Task<IReadOnlyList<IncaricoDto>?> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string personaExistsSql = @"
SELECT COUNT(1)
FROM [Persone].[Persona] p
WHERE p.PersonaId = @PersonaId
  AND p.DataCancellazione IS NULL
  AND (p.DataInizioValidita IS NULL OR p.DataInizioValidita <= SYSUTCDATETIME())
  AND (p.DataFineValidita IS NULL OR p.DataFineValidita >= SYSUTCDATETIME());";

        const string sql = @"
SELECT
    i.IncaricoId,
    i.OrganizzazioneId,
    o.Denominazione AS OrganizzazioneDenominazione,
    COALESCE(tr.Descrizione, CAST(i.TipoRuoloId AS nvarchar(50))) AS Ruolo,
    i.StatoIncarico,
    i.DataInizio,
    i.DataFine,
    i.UnitaOrganizzativaId,
    i.DataCancellazione
FROM [Organizzazioni].[Incarico] i
LEFT JOIN [Organizzazioni].[Organizzazione] o ON o.OrganizzazioneId = i.OrganizzazioneId
LEFT JOIN [Tipologica].[TipoRuolo] tr ON tr.TipoRuoloId = i.TipoRuoloId
WHERE i.PersonaId = @PersonaId
  AND (@IncludeDeleted = 1 OR i.DataCancellazione IS NULL)
  AND (i.DataInizioValidita IS NULL OR i.DataInizioValidita <= SYSUTCDATETIME())
  AND (i.DataFineValidita IS NULL OR i.DataFineValidita >= SYSUTCDATETIME())
ORDER BY i.DataInizio DESC;";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var exists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(personaExistsSql, new { command.PersonaId }, cancellationToken: cancellationToken));

        if (exists == 0)
        {
            return null;
        }

        var rows = (await connection.QueryAsync<IncaricoDto>(
            new CommandDefinition(
                sql,
                new { command.PersonaId, IncludeDeleted = command.IncludeDeleted ? 1 : 0 },
                cancellationToken: cancellationToken))).ToList();

        return rows;
    }
}

