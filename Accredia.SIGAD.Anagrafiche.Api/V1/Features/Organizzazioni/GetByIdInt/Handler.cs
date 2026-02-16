using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetByIdInt;

internal static class Handler
{
    private sealed record OrgNaturaColumns(int? TipoCodiceNaturaGiuridicaId, int? CodiceNaturaGiuridicaId, int? NaturaGiuridicaId);

    private sealed record OrgOptionalColumns(
        int? NRegistroImprese,
        int? OggettoSociale,
        int? DataIscrizioneIscrizioneRI,
        int? DataCostituzione);

    private sealed record TipologicaCandidate(string Table, string IdColumn, string DescriptionColumn);

    private sealed record OrgAuditColumns(
        int? UniqueRowId,
        int? DataCreazione,
        int? CreatoDa,
        int? DataModifica,
        int? ModificatoDa,
        int? DataInizioValidita,
        int? DataFineValidita);

    public static async Task<OrganizzazioneDetailDto?> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        // NOTE: The Organizzazioni schema is the one used by /organizzazioni/search (int identity).
        // Some fields are not available yet in the current data model, so we project NULLs with aliases.
        // The DB model may evolve, so we detect optional columns/tables and join them only when present.
        var naturaCols = await connection.QuerySingleAsync<OrgNaturaColumns>(
            new CommandDefinition(
                """
                SELECT
                    CAST(COL_LENGTH('[Organizzazioni].[Organizzazione]', 'TipoCodiceNaturaGiuridicaId') AS int) AS TipoCodiceNaturaGiuridicaId,
                    CAST(COL_LENGTH('[Organizzazioni].[Organizzazione]', 'CodiceNaturaGiuridicaId') AS int) AS CodiceNaturaGiuridicaId,
                    CAST(COL_LENGTH('[Organizzazioni].[Organizzazione]', 'NaturaGiuridicaId') AS int) AS NaturaGiuridicaId;
                """,
                cancellationToken: cancellationToken));

        // Prefer the current contract name, but accept older/alternate schemas too.
        var orgNaturaIdColumn =
            naturaCols.TipoCodiceNaturaGiuridicaId is not null ? "TipoCodiceNaturaGiuridicaId" :
            naturaCols.CodiceNaturaGiuridicaId is not null ? "CodiceNaturaGiuridicaId" :
            naturaCols.NaturaGiuridicaId is not null ? "NaturaGiuridicaId" :
            null;

        TipologicaCandidate? chosenTipologica = null;
        if (orgNaturaIdColumn is not null)
        {
            // Best-effort: try common Tipologica tables for Natura Giuridica.
            // If none match, we still return the id (when available) and a null description.
            var candidates = new[]
            {
                // Most likely naming (aligned with other tables like Tipologica.TipoOrganizzazione)
                new TipologicaCandidate("[Tipologica].[TipoCodiceNaturaGiuridica]", "TipoCodiceNaturaGiuridicaId", "Descrizione"),
                new TipologicaCandidate("[Tipologica].[CodiceNaturaGiuridica]", "CodiceNaturaGiuridicaId", "Descrizione"),
                new TipologicaCandidate("[Tipologica].[NaturaGiuridica]", "NaturaGiuridicaId", "Descrizione"),
                new TipologicaCandidate("[Tipologica].[TipoNaturaGiuridica]", "TipoNaturaGiuridicaId", "Descrizione"),
            };

            foreach (var candidate in candidates)
            {
                // Only consider candidates that can join on the chosen org column name.
                if (!string.Equals(candidate.IdColumn, orgNaturaIdColumn, StringComparison.OrdinalIgnoreCase))
                {
                    continue;
                }

                var isUsable = await connection.ExecuteScalarAsync<int>(
                    new CommandDefinition(
                        """
                        SELECT
                            CASE
                                WHEN OBJECT_ID(@Table, 'U') IS NOT NULL
                                 AND COL_LENGTH(@Table, @IdColumn) IS NOT NULL
                                 AND COL_LENGTH(@Table, @DescriptionColumn) IS NOT NULL
                                THEN 1
                                ELSE 0
                            END;
                        """,
                        new
                        {
                            candidate.Table,
                            candidate.IdColumn,
                            candidate.DescriptionColumn,
                        },
                        cancellationToken: cancellationToken));

                if (isUsable == 1)
                {
                    chosenTipologica = candidate;
                    break;
                }
            }
        }

        var auditCols = await connection.QuerySingleAsync<OrgAuditColumns>(
            new CommandDefinition(
                """
                SELECT
                    CAST(COL_LENGTH('[Organizzazioni].[Organizzazione]', 'UniqueRowId') AS int) AS UniqueRowId,
                    CAST(COL_LENGTH('[Organizzazioni].[Organizzazione]', 'DataCreazione') AS int) AS DataCreazione,
                    CAST(COL_LENGTH('[Organizzazioni].[Organizzazione]', 'CreatoDa') AS int) AS CreatoDa,
                    CAST(COL_LENGTH('[Organizzazioni].[Organizzazione]', 'DataModifica') AS int) AS DataModifica,
                    CAST(COL_LENGTH('[Organizzazioni].[Organizzazione]', 'ModificatoDa') AS int) AS ModificatoDa,
                    CAST(COL_LENGTH('[Organizzazioni].[Organizzazione]', 'DataInizioValidita') AS int) AS DataInizioValidita,
                    CAST(COL_LENGTH('[Organizzazioni].[Organizzazione]', 'DataFineValidita') AS int) AS DataFineValidita;
                """,
                cancellationToken: cancellationToken));

        var optionalCols = await connection.QuerySingleAsync<OrgOptionalColumns>(
            new CommandDefinition(
                """
                SELECT
                    CAST(COL_LENGTH('[Organizzazioni].[Organizzazione]', 'NRegistroImprese') AS int) AS NRegistroImprese,
                    CAST(COL_LENGTH('[Organizzazioni].[Organizzazione]', 'OggettoSociale') AS int) AS OggettoSociale,
                    CAST(COL_LENGTH('[Organizzazioni].[Organizzazione]', 'DataIscrizioneIscrizioneRI') AS int) AS DataIscrizioneIscrizioneRI,
                    CAST(COL_LENGTH('[Organizzazioni].[Organizzazione]', 'DataCostituzione') AS int) AS DataCostituzione;
                """,
                cancellationToken: cancellationToken));

        // Ensure the returned SQL types match the DTO constructor parameters exactly
        // (DTO uses settable properties, but we still keep casts predictable across schema variants).
        var uniqueRowSql = auditCols.UniqueRowId is null ? "CAST(NULL AS uniqueidentifier)" : "CAST(o.UniqueRowId AS uniqueidentifier)";
        var dataCreazioneSql = auditCols.DataCreazione is null ? "CAST(NULL AS datetime2)" : "CAST(o.DataCreazione AS datetime2)";
        var creatoDaSql = auditCols.CreatoDa is null ? "CAST(NULL AS nvarchar(256))" : "CAST(o.CreatoDa AS nvarchar(256))";
        var dataModificaSql = auditCols.DataModifica is null ? "CAST(NULL AS datetime2)" : "CAST(o.DataModifica AS datetime2)";
        var modificatoDaSql = auditCols.ModificatoDa is null ? "CAST(NULL AS nvarchar(256))" : "CAST(o.ModificatoDa AS nvarchar(256))";
        var dataInizioValiditaSql = auditCols.DataInizioValidita is null ? "CAST(NULL AS datetime2)" : "CAST(o.DataInizioValidita AS datetime2)";
        var dataFineValiditaSql = auditCols.DataFineValidita is null ? "CAST(NULL AS datetime2)" : "CAST(o.DataFineValidita AS datetime2)";

        var nRegistroImpreseSql = optionalCols.NRegistroImprese is null
            ? "CAST(NULL AS nvarchar(50))"
            : "CAST(o.NRegistroImprese AS nvarchar(50))";

        var oggettoSocialeSql = optionalCols.OggettoSociale is null
            ? "CAST(NULL AS nvarchar(max))"
            : "CAST(o.OggettoSociale AS nvarchar(max))";

        var dataIscrizioneRiSql = optionalCols.DataIscrizioneIscrizioneRI is null
            ? "CAST(NULL AS datetime2)"
            : "CAST(o.DataIscrizioneIscrizioneRI AS datetime2)";

        var dataCostituzioneSql = optionalCols.DataCostituzione is null
            ? "CAST(NULL AS datetime2)"
            : "CAST(o.DataCostituzione AS datetime2)";

        var naturaIdSql = orgNaturaIdColumn is null
            ? "CAST(NULL AS int)"
            : $"CAST(o.{orgNaturaIdColumn} AS int)";

        var naturaJoinSql = chosenTipologica is null || orgNaturaIdColumn is null
            ? string.Empty
            : $"LEFT JOIN {chosenTipologica.Table} ng ON ng.{chosenTipologica.IdColumn} = o.{orgNaturaIdColumn}";

        var naturaDescrizioneSql = chosenTipologica is null || orgNaturaIdColumn is null
            ? "CAST(NULL AS nvarchar(256))"
            : $"ng.{chosenTipologica.DescriptionColumn}";

        var sql = $"""
            SELECT
                o.OrganizzazioneId,
                CAST(o.Denominazione AS nvarchar(256)) AS Denominazione,
                CAST(o.RagioneSociale AS nvarchar(256)) AS RagioneSociale,
                CAST(o.PartitaIVA AS nvarchar(50)) AS PartitaIVA,
                CAST(o.CodiceFiscale AS nvarchar(50)) AS CodiceFiscale,
                {nRegistroImpreseSql} AS NRegistroImprese,
                {naturaIdSql} AS TipoCodiceNaturaGiuridicaId,
                {naturaDescrizioneSql} AS NaturaGiuridicaDescrizione,
                CAST(o.StatoAttivitaId AS tinyint) AS StatoAttivitaId,
                {oggettoSocialeSql} AS OggettoSociale,
                {dataIscrizioneRiSql} AS DataIscrizioneIscrizioneRI,
                {dataCostituzioneSql} AS DataCostituzione,
                CAST(o.DataCancellazione AS datetime2) AS DataCancellazione,
                {uniqueRowSql} AS UniqueRowId,
                {dataCreazioneSql} AS DataCreazione,
                {creatoDaSql} AS CreatoDa,
                {dataModificaSql} AS DataModifica,
                {modificatoDaSql} AS ModificatoDa,
                {dataInizioValiditaSql} AS DataInizioValidita,
                {dataFineValiditaSql} AS DataFineValidita
            FROM [Organizzazioni].[Organizzazione] o
            {naturaJoinSql}
            WHERE o.OrganizzazioneId = @OrganizzazioneId;
            """;

        return await connection.QuerySingleOrDefaultAsync<OrganizzazioneDetailDto>(
            new CommandDefinition(sql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken));
    }
}
