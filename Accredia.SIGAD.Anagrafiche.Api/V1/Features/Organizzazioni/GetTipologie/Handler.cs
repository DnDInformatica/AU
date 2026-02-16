using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetTipologie;

internal static class Handler
{
    private sealed record OrgTypeRow(int? TipoOrganizzazioneId);

    public static async Task<IReadOnlyList<OrganizzazioneTipoDto>?> Handle(
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

        const string hasBridgeTableSql = "SELECT CASE WHEN OBJECT_ID('[Organizzazioni].[OrganizzazioneTipoOrganizzazione]') IS NULL THEN 0 ELSE 1 END;";

        const string bridgeSql = @"
SELECT
    j.TipoOrganizzazioneId,
    t.Codice,
    t.Descrizione,
    CAST(t.CodiceSchemaAccreditamento AS nvarchar(50)) AS CodiceSchemaAccreditamento,
    CAST(t.NormaRiferimento AS nvarchar(200)) AS NormaRiferimento,
    CAST(j.Principale AS bit) AS Principale,
    CAST(j.DataAssegnazione AS datetime2) AS DataAssegnazione,
    CAST(j.DataRevoca AS datetime2) AS DataRevoca,
    j.MotivoRevoca
FROM [Organizzazioni].[OrganizzazioneTipoOrganizzazione] j
INNER JOIN [Tipologica].[TipoOrganizzazione] t ON t.TipoOrganizzazioneId = j.TipoOrganizzazioneId
WHERE j.OrganizzazioneId = @OrganizzazioneId
  AND j.DataCancellazione IS NULL
  AND (j.DataInizioValidita IS NULL OR j.DataInizioValidita <= SYSUTCDATETIME())
  AND (j.DataFineValidita IS NULL OR j.DataFineValidita >= SYSUTCDATETIME())
ORDER BY j.Principale DESC, t.Descrizione ASC;";

        // Backward-compatible fallback for environments still populated on single FK column.
        const string typeIdSql = @"
SELECT o.TipoOrganizzazioneId
FROM [Organizzazioni].[Organizzazione] o
WHERE o.OrganizzazioneId = @OrganizzazioneId;";

        const string tipoSql = @"
SELECT
    t.TipoOrganizzazioneId,
    t.Codice,
    t.Descrizione,
    CAST(NULL AS nvarchar(50)) AS CodiceSchemaAccreditamento,
    CAST(NULL AS nvarchar(200)) AS NormaRiferimento
FROM [Tipologica].[TipoOrganizzazione] t
WHERE t.TipoOrganizzazioneId = @TipoOrganizzazioneId;";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var exists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(orgExistsSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return null;
        }

        // Preferred model: bridge table OrganizzazioneTipoOrganizzazione.
        var hasBridgeTable = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(hasBridgeTableSql, cancellationToken: cancellationToken));
        if (hasBridgeTable == 1)
        {
            var hasTipoTableForBridge = await connection.ExecuteScalarAsync<int>(
                new CommandDefinition(
                    "SELECT CASE WHEN OBJECT_ID('[Tipologica].[TipoOrganizzazione]') IS NULL THEN 0 ELSE 1 END;",
                    cancellationToken: cancellationToken));
            if (hasTipoTableForBridge == 1)
            {
                var bridgeItems = (await connection.QueryAsync<OrganizzazioneTipoDto>(
                    new CommandDefinition(bridgeSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();
                if (bridgeItems.Count > 0)
                {
                    return bridgeItems;
                }
            }
        }

        // Legacy fallback: single FK on Organizzazione.
        var hasColumn = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(
                "SELECT CASE WHEN COL_LENGTH('[Organizzazioni].[Organizzazione]', 'TipoOrganizzazioneId') IS NULL THEN 0 ELSE 1 END;",
                cancellationToken: cancellationToken));

        if (hasColumn == 0)
        {
            return Array.Empty<OrganizzazioneTipoDto>();
        }

        OrgTypeRow? row;
        try
        {
            row = await connection.QuerySingleOrDefaultAsync<OrgTypeRow>(
                new CommandDefinition(typeIdSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken));
        }
        catch
        {
            // Column exists check succeeded, but the DB may still differ; keep UX stable.
            return Array.Empty<OrganizzazioneTipoDto>();
        }

        if (row?.TipoOrganizzazioneId is null)
        {
            return Array.Empty<OrganizzazioneTipoDto>();
        }

        // If the Tipologica table isn't present, return empty (no crash).
        var hasTipoTable = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(
                "SELECT CASE WHEN OBJECT_ID('[Tipologica].[TipoOrganizzazione]') IS NULL THEN 0 ELSE 1 END;",
                cancellationToken: cancellationToken));
        if (hasTipoTable == 0)
        {
            return Array.Empty<OrganizzazioneTipoDto>();
        }

        var tipo = await connection.QuerySingleOrDefaultAsync<OrganizzazioneTipoDto>(
            new CommandDefinition(tipoSql, new { TipoOrganizzazioneId = row.TipoOrganizzazioneId.Value }, cancellationToken: cancellationToken));

        if (tipo is null)
        {
            return Array.Empty<OrganizzazioneTipoDto>();
        }

        // Promote as principale. Multi-type support can be added later via a junction table.
        return new[]
        {
            tipo with
            {
                Principale = true,
                DataAssegnazione = null,
                DataRevoca = null,
                MotivoRevoca = null
            }
        };
    }
}
