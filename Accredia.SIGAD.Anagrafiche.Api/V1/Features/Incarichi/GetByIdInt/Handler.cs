using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.GetByIdInt;

internal static class Handler
{
    public static async Task<IncaricoDetailDto?> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string sql = @"
SELECT
    i.IncaricoId,
    i.PersonaId,
    p.Cognome AS PersonaCognome,
    p.Nome AS PersonaNome,
    p.CodiceFiscale AS PersonaCodiceFiscale,
    COALESCE(i.OrganizzazioneId, u.OrganizzazioneId) AS OrganizzazioneId,
    COALESCE(o.Denominazione, ou.Denominazione) AS OrganizzazioneDenominazione,
    i.TipoRuoloId,
    COALESCE(tr.Descrizione, CAST(i.TipoRuoloId AS nvarchar(50))) AS Ruolo,
    i.StatoIncarico,
    i.DataInizio,
    i.DataFine,
    i.UnitaOrganizzativaId,
    i.DataCancellazione
FROM [Organizzazioni].[Incarico] i
LEFT JOIN [Persone].[Persona] p ON p.PersonaId = i.PersonaId
LEFT JOIN [Organizzazioni].[Organizzazione] o ON o.OrganizzazioneId = i.OrganizzazioneId
LEFT JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = i.UnitaOrganizzativaId
LEFT JOIN [Organizzazioni].[Organizzazione] ou ON ou.OrganizzazioneId = u.OrganizzazioneId
LEFT JOIN [Tipologica].[TipoRuolo] tr ON tr.TipoRuoloId = i.TipoRuoloId
WHERE i.IncaricoId = @IncaricoId
  AND (i.DataInizioValidita IS NULL OR i.DataInizioValidita <= SYSUTCDATETIME())
  AND (i.DataFineValidita IS NULL OR i.DataFineValidita >= SYSUTCDATETIME());";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return await connection.QuerySingleOrDefaultAsync<IncaricoDetailDto>(
            new CommandDefinition(sql, new { command.IncaricoId }, cancellationToken: cancellationToken));
    }
}
