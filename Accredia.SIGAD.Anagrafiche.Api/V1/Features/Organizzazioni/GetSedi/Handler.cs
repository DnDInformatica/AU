using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetSedi;

internal static class Handler
{
    public static async Task<IReadOnlyList<SedeDto>?> Handle(
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

        // Assumption (data model): Sede table lives in schema Organizzazioni and uses the same validity + soft-delete pattern.
        const string sediSql = @"
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
  AND s.DataCancellazione IS NULL
  AND (s.DataInizioValidita IS NULL OR s.DataInizioValidita <= SYSUTCDATETIME())
  AND (s.DataFineValidita IS NULL OR s.DataFineValidita >= SYSUTCDATETIME())
ORDER BY s.IsSedePrincipale DESC, s.Denominazione;";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var exists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(orgExistsSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken));

        if (exists == 0)
        {
            return null;
        }

        var rows = (await connection.QueryAsync<SedeDto>(
            new CommandDefinition(sediSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();

        return rows;
    }
}
