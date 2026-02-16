using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.StatiAttivitaLookups;

internal static class Handler
{
    private sealed record Meta(
        int? TableObjectId,
        int? IdCodiceStatoAttivitaId,
        int? IdStatoAttivitaId,
        int? IdId,
        int? Codice,
        int? Descrizione,
        int? Nome,
        int? Ordine,
        int? Ordinamento);

    public static async Task<IReadOnlyList<LookupItem>> Handle(
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(connectionFactory);

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var meta = await connection.QuerySingleAsync<Meta>(
            new CommandDefinition(
                """
                SELECT
                    CAST(OBJECT_ID('[Tipologica].[CodiceStatoAttivita]', 'U') AS int) AS TableObjectId,
                    CAST(COL_LENGTH('[Tipologica].[CodiceStatoAttivita]', 'CodiceStatoAttivitaId') AS int) AS IdCodiceStatoAttivitaId,
                    CAST(COL_LENGTH('[Tipologica].[CodiceStatoAttivita]', 'StatoAttivitaId') AS int) AS IdStatoAttivitaId,
                    CAST(COL_LENGTH('[Tipologica].[CodiceStatoAttivita]', 'Id') AS int) AS IdId,
                    CAST(COL_LENGTH('[Tipologica].[CodiceStatoAttivita]', 'Codice') AS int) AS Codice,
                    CAST(COL_LENGTH('[Tipologica].[CodiceStatoAttivita]', 'Descrizione') AS int) AS Descrizione,
                    CAST(COL_LENGTH('[Tipologica].[CodiceStatoAttivita]', 'Nome') AS int) AS Nome,
                    CAST(COL_LENGTH('[Tipologica].[CodiceStatoAttivita]', 'Ordine') AS int) AS Ordine,
                    CAST(COL_LENGTH('[Tipologica].[CodiceStatoAttivita]', 'Ordinamento') AS int) AS Ordinamento;
                """,
                cancellationToken: cancellationToken));

        // Fallback (legacy UX), but in normal DB this table exists (FK) so we will query it.
        if (meta.TableObjectId is null)
        {
            return new[]
            {
                new LookupItem(1, "Attiva"),
                new LookupItem(2, "Sospesa"),
                new LookupItem(3, "Cessata"),
            };
        }

        var idColumn =
            meta.IdCodiceStatoAttivitaId is not null ? "CodiceStatoAttivitaId" :
            meta.IdStatoAttivitaId is not null ? "StatoAttivitaId" :
            meta.IdId is not null ? "Id" :
            null;

        var descColumn =
            meta.Descrizione is not null ? "Descrizione" :
            meta.Nome is not null ? "Nome" :
            meta.Codice is not null ? "Codice" :
            null;

        if (idColumn is null || descColumn is null)
        {
            // Schema unexpected: return empty to avoid sending invalid ids to UI.
            return Array.Empty<LookupItem>();
        }

        var labelSql =
            meta.Codice is not null && !string.Equals(descColumn, "Codice", StringComparison.OrdinalIgnoreCase)
                ? $"CONCAT(CAST(s.[Codice] AS nvarchar(50)), N' - ', CAST(s.[{descColumn}] AS nvarchar(256)))"
                : $"CAST(s.[{descColumn}] AS nvarchar(256))";

        var orderSql =
            meta.Ordine is not null ? "s.[Ordine]" :
            meta.Ordinamento is not null ? "s.[Ordinamento]" :
            "Label";

        var sql = $"""
            SELECT
                CAST(s.[{idColumn}] AS int) AS Id,
                {labelSql} AS Label
            FROM [Tipologica].[CodiceStatoAttivita] s
            ORDER BY {orderSql};
            """;

        var rows = await connection.QueryAsync<LookupItem>(new CommandDefinition(sql, cancellationToken: cancellationToken));
        return rows.ToList();
    }
}

