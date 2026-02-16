using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetSedi;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediGetById;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediCreate;

internal static class Handler
{
    public static async Task<SedeDto?> Handle(
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

        var now = DateTime.UtcNow;
        var fineValidita = new DateTime(9999, 12, 31);
        var actor = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();

        var columns = await DbIntrospection.GetColumnsAsync(connectionFactory, cancellationToken);
        foreach (var r in new[] { "OrganizzazioneId", "IsSedePrincipale", "IsSedeOperativa" })
        {
            if (!columns.ContainsKey(r))
            {
                throw new InvalidOperationException($"Colonna richiesta mancante su [Organizzazioni].[Sede]: {r}");
            }
        }

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
        Add("Denominazione", "@Denominazione", command.Request.Denominazione);
        Add("Indirizzo", "@Indirizzo", command.Request.Indirizzo);
        Add("NumeroCivico", "@NumeroCivico", command.Request.NumeroCivico);
        Add("CAP", "@CAP", command.Request.CAP);
        Add("Localita", "@Localita", command.Request.Localita);
        Add("Provincia", "@Provincia", command.Request.Provincia);
        Add("Nazione", "@Nazione", command.Request.Nazione);
        Add("StatoSede", "@StatoSede", command.Request.StatoSede);

        Add("IsSedePrincipale", "@IsSedePrincipale", command.Request.IsSedePrincipale ? 1 : 0);
        Add("IsSedeOperativa", "@IsSedeOperativa", command.Request.IsSedeOperativa ? 1 : 0);
        Add("DataApertura", "@DataApertura", command.Request.DataApertura);
        Add("DataCessazione", "@DataCessazione", command.Request.DataCessazione);
        Add("TipoSedeId", "@TipoSedeId", command.Request.TipoSedeId);

        Add("DataInizioValidita", "@DataInizioValidita", now);
        Add("DataFineValidita", "@DataFineValidita", fineValidita);
        Add("UniqueRowId", "@UniqueRowId", Guid.NewGuid());
        Add("DataCreazione", "@DataCreazione", now);
        Add("CreatoDa", "@CreatoDa", DbIntrospection.GetActorDbValue(columns, "CreatoDa", actor));
        Add("DataModifica", "@DataModifica", now);
        Add("ModificatoDa", "@ModificatoDa", DbIntrospection.GetActorDbValue(columns, "ModificatoDa", actor));

        // Use OUTPUT ... INTO to support tables with enabled triggers.
        var insertSql = $"""
            DECLARE @newIds TABLE (SedeId int);

            INSERT INTO [Organizzazioni].[Sede]
                ({string.Join(", ", colNames)})
            OUTPUT INSERTED.SedeId INTO @newIds(SedeId)
            VALUES
                ({string.Join(", ", colValues)});

            SELECT TOP (1) SedeId FROM @newIds;
            """;

        const string clearOtherPrincipalsSql = @"
UPDATE [Organizzazioni].[Sede]
SET IsSedePrincipale = 0,
    DataModifica = @Now,
    ModificatoDa = @Actor
WHERE OrganizzazioneId = @OrganizzazioneId
  AND SedeId <> @SedeId
  AND DataCancellazione IS NULL
  AND IsSedePrincipale = 1;";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var exists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(orgExistsSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return null;
        }

        await using var tx = connection.BeginTransaction();

        var sedeId = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            insertSql,
            p,
            tx,
            cancellationToken: cancellationToken));

        if (command.Request.IsSedePrincipale)
        {
            var actorDb = DbIntrospection.GetActorDbValue(columns, "ModificatoDa", actor);
            await connection.ExecuteAsync(new CommandDefinition(
                clearOtherPrincipalsSql,
                new { command.OrganizzazioneId, SedeId = sedeId, Now = now, Actor = actorDb },
                tx,
                cancellationToken: cancellationToken));
        }

        tx.Commit();

        return await SediGetById.Handler.Handle(new SediGetById.Command(command.OrganizzazioneId, sedeId), connectionFactory, cancellationToken);
    }
}
