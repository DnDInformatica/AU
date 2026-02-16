using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.GetByIdInt;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.CreateInt;

internal static class Handler
{
    public static async Task<IncaricoDetailDto?> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string personaExistsSql = @"
SELECT COUNT(1)
FROM [Persone].[Persona] p
WHERE p.PersonaId = @PersonaId
  AND p.DataCancellazione IS NULL
  AND (p.DataInizioValidita IS NULL OR p.DataInizioValidita <= SYSUTCDATETIME())
  AND (p.DataFineValidita IS NULL OR p.DataFineValidita >= SYSUTCDATETIME());";

        const string orgExistsSql = @"
SELECT COUNT(1)
FROM [Organizzazioni].[Organizzazione] o
WHERE o.OrganizzazioneId = @OrganizzazioneId
  AND o.DataCancellazione IS NULL
  AND (o.DataInizioValidita IS NULL OR o.DataInizioValidita <= SYSUTCDATETIME())
  AND (o.DataFineValidita IS NULL OR o.DataFineValidita >= SYSUTCDATETIME());";

        const string uoExistsSql = @"
SELECT COUNT(1)
FROM [Organizzazioni].[UnitaOrganizzativa] u
WHERE u.UnitaOrganizzativaId = @UnitaOrganizzativaId
  AND u.OrganizzazioneId = @OrganizzazioneId
  AND u.DataCancellazione IS NULL
  AND (u.DataInizioValidita IS NULL OR u.DataInizioValidita <= SYSUTCDATETIME())
  AND (u.DataFineValidita IS NULL OR u.DataFineValidita >= SYSUTCDATETIME());";

        var columns = await DbIntrospection.GetColumnsAsync(connectionFactory, cancellationToken);
        var now = DateTime.UtcNow;
        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);
        var actor = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();

        var colNames = new List<string>();
        var colValues = new List<string>();
        var p = new DynamicParameters();

        void Add(string col, string sqlValue, object? value)
        {
            if (!columns.TryGetValue(col, out var info)) return;
            if (!info.IsInsertable) return;
            colNames.Add($"[{col}]");
            colValues.Add(sqlValue);
            p.Add(col, value);
        }

        int? organizzazioneIdForPersistence = command.Request.UnitaOrganizzativaId.HasValue
            ? null
            : command.Request.OrganizzazioneId;

        Add("PersonaId", "@PersonaId", command.Request.PersonaId);
        Add("OrganizzazioneId", "@OrganizzazioneId", organizzazioneIdForPersistence);
        Add("TipoRuoloId", "@TipoRuoloId", command.Request.TipoRuoloId);
        Add("StatoIncarico", "@StatoIncarico", command.Request.StatoIncarico.Trim());
        Add("DataInizio", "@DataInizio", command.Request.DataInizio);
        Add("DataFine", "@DataFine", command.Request.DataFine);
        Add("UnitaOrganizzativaId", "@UnitaOrganizzativaId", command.Request.UnitaOrganizzativaId);

        Add("DataInizioValidita", "@DataInizioValidita", now);
        Add("DataFineValidita", "@DataFineValidita", fineValidita);
        Add("UniqueRowId", "@UniqueRowId", Guid.NewGuid());
        Add("DataCreazione", "@DataCreazione", now);
        Add("CreatoDa", "@CreatoDa", DbIntrospection.GetActorDbValue(columns, "CreatoDa", actor));
        Add("DataModifica", "@DataModifica", now);
        Add("ModificatoDa", "@ModificatoDa", DbIntrospection.GetActorDbValue(columns, "ModificatoDa", actor));

        var insertSql = $"""
            DECLARE @newIds TABLE (IncaricoId int);

            INSERT INTO [Organizzazioni].[Incarico]
                ({string.Join(", ", colNames)})
            OUTPUT INSERTED.IncaricoId INTO @newIds(IncaricoId)
            VALUES
                ({string.Join(", ", colValues)});

            SELECT TOP (1) IncaricoId FROM @newIds;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var personaExists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(personaExistsSql, new { command.Request.PersonaId }, cancellationToken: cancellationToken));
        if (personaExists == 0)
        {
            return null;
        }

        var orgExists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(orgExistsSql, new { command.Request.OrganizzazioneId }, cancellationToken: cancellationToken));
        if (orgExists == 0)
        {
            return null;
        }

        if (command.Request.UnitaOrganizzativaId.HasValue)
        {
            var uoExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
                uoExistsSql,
                new
                {
                    command.Request.UnitaOrganizzativaId,
                    command.Request.OrganizzazioneId
                },
                cancellationToken: cancellationToken));
            if (uoExists == 0)
            {
                return null;
            }
        }

        if (command.Request.TipoRuoloId.HasValue)
        {
            var hasRuolo = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
                "SELECT COUNT(1) FROM [Tipologica].[TipoRuolo] WHERE [TipoRuoloId] = @Id;",
                new { Id = command.Request.TipoRuoloId.Value },
                cancellationToken: cancellationToken));
            if (hasRuolo == 0)
            {
                return null;
            }
        }

        var incaricoId = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(insertSql, p, cancellationToken: cancellationToken));

        return await GetByIdInt.Handler.Handle(new GetByIdInt.Command(incaricoId), connectionFactory, cancellationToken);
    }
}
