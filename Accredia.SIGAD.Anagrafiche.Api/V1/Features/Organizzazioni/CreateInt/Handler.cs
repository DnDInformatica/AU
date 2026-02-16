using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetByIdInt;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.CreateInt;

internal static class Handler
{
    public static async Task<OrganizzazioneDetailDto?> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        var columns = await DbIntrospection.GetColumnsAsync(connectionFactory, cancellationToken);

        // Required columns for the current SIGAD UX (search/detail). If missing, we cannot create reliably.
        var required = new[] { "Denominazione" };
        foreach (var r in required)
        {
            if (!columns.ContainsKey(r))
            {
                throw new InvalidOperationException($"Colonna richiesta mancante su [Organizzazioni].[Organizzazione]: {r}");
            }
        }

        // Build INSERT using only known columns that exist. This prevents runtime failures across schema variants.
        var now = DateTime.UtcNow;
        var actor = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);

        var colNames = new List<string>();
        var colValues = new List<string>();
        var p = new DynamicParameters();

        void Add(string col, string sqlValue, object? value = null)
        {
            if (!columns.TryGetValue(col, out var info))
            {
                return;
            }

            if (!info.IsInsertable)
            {
                return;
            }

            colNames.Add($"[{col}]");
            colValues.Add(sqlValue);
            p.Add(col, value);
        }

        Add("Denominazione", "@Denominazione", command.Request.Denominazione.Trim());
        Add("RagioneSociale", "@RagioneSociale", string.IsNullOrWhiteSpace(command.Request.RagioneSociale) ? null : command.Request.RagioneSociale.Trim());
        Add("PartitaIVA", "@PartitaIVA", string.IsNullOrWhiteSpace(command.Request.PartitaIVA) ? null : command.Request.PartitaIVA.Trim());
        Add("CodiceFiscale", "@CodiceFiscale", string.IsNullOrWhiteSpace(command.Request.CodiceFiscale) ? null : command.Request.CodiceFiscale.Trim());
        Add("StatoAttivitaId", "@StatoAttivitaId", command.Request.StatoAttivitaId ?? (byte)1);
        Add("NRegistroImprese", "@NRegistroImprese", string.IsNullOrWhiteSpace(command.Request.NRegistroImprese) ? null : command.Request.NRegistroImprese.Trim());
        Add("OggettoSociale", "@OggettoSociale", string.IsNullOrWhiteSpace(command.Request.OggettoSociale) ? null : command.Request.OggettoSociale.Trim());
        Add("DataIscrizioneIscrizioneRI", "@DataIscrizioneIscrizioneRI", command.Request.DataIscrizioneIscrizioneRI);
        Add("DataCostituzione", "@DataCostituzione", command.Request.DataCostituzione);
        Add("TipoCodiceNaturaGiuridicaId", "@TipoCodiceNaturaGiuridicaId", command.Request.TipoCodiceNaturaGiuridicaId);

        // NOTE: if the table uses temporal period columns (GENERATED ALWAYS), DbIntrospection marks them as non-insertable.
        Add("DataInizioValidita", "@DataInizioValidita", now);
        Add("DataFineValidita", "@DataFineValidita", fineValidita);

        // Audit (best-effort).
        Add("UniqueRowId", "@UniqueRowId", Guid.NewGuid());
        Add("DataCreazione", "@DataCreazione", now);
        Add("CreatoDa", "@CreatoDa", DbIntrospection.GetActorDbValue(columns, "CreatoDa", actor));
        Add("DataModifica", "@DataModifica", now);
        Add("ModificatoDa", "@ModificatoDa", DbIntrospection.GetActorDbValue(columns, "ModificatoDa", actor));

        if (colNames.Count == 0)
        {
            throw new InvalidOperationException("Impossibile costruire INSERT per Organizzazione: nessuna colonna mappata.");
        }

        // NOTE: SQL Server blocks "OUTPUT inserted.*" without INTO when the target table has enabled triggers.
        // Use OUTPUT ... INTO a table variable and then SELECT the generated id.
        var insertSql = $"""
            DECLARE @newIds TABLE (OrganizzazioneId int);

            INSERT INTO [Organizzazioni].[Organizzazione]
                ({string.Join(", ", colNames)})
            OUTPUT INSERTED.OrganizzazioneId INTO @newIds(OrganizzazioneId)
            VALUES
                ({string.Join(", ", colValues)});

            SELECT TOP (1) OrganizzazioneId FROM @newIds;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var organizzazioneId = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(insertSql, p, cancellationToken: cancellationToken));

        return await GetByIdInt.Handler.Handle(new GetByIdInt.Command(organizzazioneId), connectionFactory, cancellationToken);
    }
}
