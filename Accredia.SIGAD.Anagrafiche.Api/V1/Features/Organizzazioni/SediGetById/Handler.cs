using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetSedi;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediGetById;

internal static class Handler
{
    public static async Task<SedeDto?> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string sql = @"
SELECT
    s.SedeId,
    s.Denominazione,
    s.Indirizzo,
    s.NumeroCivico,
    s.CAP,
    s.Localita,
    s.Provincia,
    s.Nazione,
    s.StatoSede,
    s.IsSedePrincipale,
    s.IsSedeOperativa,
    s.DataApertura,
    s.DataCessazione,
    s.TipoSedeId
FROM [Organizzazioni].[Sede] s
WHERE s.OrganizzazioneId = @OrganizzazioneId
  AND s.SedeId = @SedeId
  AND s.DataCancellazione IS NULL
  AND (s.DataInizioValidita IS NULL OR s.DataInizioValidita <= SYSUTCDATETIME())
  AND (s.DataFineValidita IS NULL OR s.DataFineValidita >= SYSUTCDATETIME());";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return await connection.QuerySingleOrDefaultAsync<SedeDto>(
            new CommandDefinition(sql, new { command.OrganizzazioneId, command.SedeId }, cancellationToken: cancellationToken));
    }
}

