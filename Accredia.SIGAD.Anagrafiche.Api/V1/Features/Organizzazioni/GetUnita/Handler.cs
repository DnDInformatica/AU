using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetUnita;

internal static class Handler
{
    public static async Task<IReadOnlyList<UnitaOrganizzativaDto>?> Handle(
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

        // Assumption (data model): UnitaOrganizzativa table lives in schema Organizzazioni and uses the same validity + soft-delete pattern.
        const string unitaSql = @"
SELECT
    u.UnitaOrganizzativaId,
    u.Nome,
    u.Codice,
    u.Principale,
    u.TipoUnitaOrganizzativaId,
    u.TipoSedeId
FROM [Organizzazioni].[UnitaOrganizzativa] u
WHERE u.OrganizzazioneId = @OrganizzazioneId
  AND u.DataCancellazione IS NULL
  AND (u.DataInizioValidita IS NULL OR u.DataInizioValidita <= SYSUTCDATETIME())
  AND (u.DataFineValidita IS NULL OR u.DataFineValidita >= SYSUTCDATETIME())
ORDER BY u.Principale DESC, u.Nome;";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var exists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(orgExistsSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken));

        if (exists == 0)
        {
            return null;
        }

        var rows = (await connection.QueryAsync<UnitaOrganizzativaDto>(
            new CommandDefinition(unitaSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();

        return rows;
    }
}
