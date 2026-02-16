using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetUnita;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaGetById;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaCreate;

internal static class Handler
{
    public static async Task<UnitaOrganizzativaDto?> Handle(
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

        var columns = await DbIntrospection.GetColumnsAsync(connectionFactory, cancellationToken);
        foreach (var r in new[] { "OrganizzazioneId", "Nome", "Principale", "TipoUnitaOrganizzativaId" })
        {
            if (!columns.ContainsKey(r))
            {
                throw new InvalidOperationException($"Colonna richiesta mancante su [Organizzazioni].[UnitaOrganizzativa]: {r}");
            }
        }

        var now = DateTime.UtcNow;
        var fineValidita = new DateTime(9999, 12, 31);
        var actor = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();

        var colNames = new List<string>();
        var colValues = new List<string>();
        var p = new DynamicParameters();

        void Add(string col, string sqlValue, object? value = null)
        {
            if (!columns.TryGetValue(col, out var info)) return;
            if (!info.IsInsertable) return;
            colNames.Add($"[{col}]");
            colValues.Add(sqlValue);
            p.Add(col, value);
        }

        Add("OrganizzazioneId", "@OrganizzazioneId", command.OrganizzazioneId);
        Add("Nome", "@Nome", command.Request.Nome.Trim());
        Add("Codice", "@Codice", string.IsNullOrWhiteSpace(command.Request.Codice) ? null : command.Request.Codice.Trim());
        Add("Principale", "@Principale", command.Request.Principale ? 1 : 0);
        Add("TipoUnitaOrganizzativaId", "@TipoUnitaOrganizzativaId", command.Request.TipoUnitaOrganizzativaId);
        Add("TipoSedeId", "@TipoSedeId", command.Request.TipoSedeId);

        // NOTE: if the table uses temporal period columns (GENERATED ALWAYS), DbIntrospection marks them as non-insertable.
        Add("DataInizioValidita", "@DataInizioValidita", now);
        Add("DataFineValidita", "@DataFineValidita", fineValidita);
        Add("UniqueRowId", "@UniqueRowId", Guid.NewGuid());
        Add("DataCreazione", "@DataCreazione", now);
        Add("CreatoDa", "@CreatoDa", DbIntrospection.GetActorDbValue(columns, "CreatoDa", actor));
        Add("DataModifica", "@DataModifica", now);
        Add("ModificatoDa", "@ModificatoDa", DbIntrospection.GetActorDbValue(columns, "ModificatoDa", actor));

        // NOTE: SQL Server blocks "OUTPUT inserted.*" without INTO when the target table has enabled triggers.
        // Use OUTPUT ... INTO a table variable and then SELECT the generated id.
        var insertSql = $"""
            DECLARE @newIds TABLE (UnitaOrganizzativaId int);

            INSERT INTO [Organizzazioni].[UnitaOrganizzativa]
                ({string.Join(", ", colNames)})
            OUTPUT INSERTED.UnitaOrganizzativaId INTO @newIds(UnitaOrganizzativaId)
            VALUES
                ({string.Join(", ", colValues)});

            SELECT TOP (1) UnitaOrganizzativaId FROM @newIds;
            """;

        const string clearOtherPrincipalsSql = @"
UPDATE [Organizzazioni].[UnitaOrganizzativa]
SET Principale = 0,
    DataModifica = @Now,
    ModificatoDa = @Actor
WHERE OrganizzazioneId = @OrganizzazioneId
  AND UnitaOrganizzativaId <> @UnitaOrganizzativaId
  AND DataCancellazione IS NULL
  AND Principale = 1;";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(orgExistsSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return null;
        }

        await using var tx = connection.BeginTransaction();
        var uoId = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(insertSql, p, tx, cancellationToken: cancellationToken));

        if (command.Request.Principale)
        {
            await connection.ExecuteAsync(new CommandDefinition(
                clearOtherPrincipalsSql,
                new { command.OrganizzazioneId, UnitaOrganizzativaId = uoId, Now = now, Actor = actor },
                tx,
                cancellationToken: cancellationToken));
        }

        tx.Commit();

        return await UnitaGetById.Handler.Handle(new UnitaGetById.Command(command.OrganizzazioneId, uoId), connectionFactory, cancellationToken);
    }
}
