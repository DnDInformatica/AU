using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetIdentificativi;

internal static class Handler
{
    private sealed record OrgIdsRow(string? PartitaIVA, string? CodiceFiscale);

    public static async Task<IReadOnlyList<IdentificativoDto>?> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string orgSql = @"
SELECT o.PartitaIVA, o.CodiceFiscale
FROM [Organizzazioni].[Organizzazione] o
WHERE o.OrganizzazioneId = @OrganizzazioneId
  AND o.DataCancellazione IS NULL
  AND (o.DataInizioValidita IS NULL OR o.DataInizioValidita <= SYSUTCDATETIME())
  AND (o.DataFineValidita IS NULL OR o.DataFineValidita >= SYSUTCDATETIME());";

        const string hasBridgeSql = @"
SELECT CASE WHEN OBJECT_ID('[Organizzazioni].[OrganizzazioneIdentificativoFiscale]') IS NULL THEN 0 ELSE 1 END;";

        const string bridgeSql = @"
SELECT
    i.OrganizzazioneIdentificativoFiscaleId AS Id,
    RTRIM(i.PaeseISO2) AS PaeseISO2,
    i.TipoIdentificativo,
    i.Valore,
    i.Principale,
    i.Note
FROM [Organizzazioni].[OrganizzazioneIdentificativoFiscale] i
WHERE i.OrganizzazioneId = @OrganizzazioneId
  AND i.DataInizioValidita <= SYSUTCDATETIME()
  AND i.DataFineValidita >= SYSUTCDATETIME()
ORDER BY i.Principale DESC, i.OrganizzazioneIdentificativoFiscaleId DESC;";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var row = await connection.QuerySingleOrDefaultAsync<OrgIdsRow>(
            new CommandDefinition(orgSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken));

        if (row is null)
        {
            return null;
        }

        var hasBridge = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(hasBridgeSql, cancellationToken: cancellationToken));

        if (hasBridge == 1)
        {
            var bridgeRows = (await connection.QueryAsync<IdentificativoDto>(
                new CommandDefinition(bridgeSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();

            if (bridgeRows.Count > 0)
            {
                return bridgeRows;
            }
        }

        // Minimal, deterministic IDs for client-side keys (not DB PKs).
        var nextId = 1;
        var list = new List<IdentificativoDto>();

        if (!string.IsNullOrWhiteSpace(row.PartitaIVA))
        {
            list.Add(new IdentificativoDto(
                Id: nextId++,
                PaeseISO2: "IT",
                TipoIdentificativo: "PIVA",
                Valore: row.PartitaIVA.Trim(),
                Principale: true,
                Note: null));
        }

        if (!string.IsNullOrWhiteSpace(row.CodiceFiscale))
        {
            list.Add(new IdentificativoDto(
                Id: nextId++,
                PaeseISO2: "IT",
                TipoIdentificativo: "CF",
                Valore: row.CodiceFiscale.Trim(),
                Principale: list.Count == 0,
                Note: null));
        }

        return list;
    }
}
