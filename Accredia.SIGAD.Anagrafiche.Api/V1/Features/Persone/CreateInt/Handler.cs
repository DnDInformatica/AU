using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.GetByIdInt;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.CreateInt;

internal static class Handler
{
    public static async Task<PersonaDetailDto?> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        var columns = await DbIntrospection.GetColumnsAsync(connectionFactory, cancellationToken);

        foreach (var r in new[] { "Cognome", "Nome", "DataNascita" })
        {
            if (!columns.ContainsKey(r))
            {
                throw new InvalidOperationException($"Colonna richiesta mancante su [Persone].[Persona]: {r}");
            }
        }

        var now = DateTime.UtcNow;
        var actor = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actor, out var parsedActor) ? parsedActor : 0;
        var fineValidita = new DateTime(9999, 12, 31);

        // Optional duplicate check on CF (best-effort).
        if (columns.ContainsKey("CodiceFiscale") && !string.IsNullOrWhiteSpace(command.Request.CodiceFiscale))
        {
            const string dupSql = """
                SELECT COUNT(1)
                FROM [Persone].[Persona] p
                WHERE p.CodiceFiscale = @CodiceFiscale
                  AND p.DataCancellazione IS NULL
                  AND (p.DataInizioValidita IS NULL OR p.DataInizioValidita <= SYSUTCDATETIME())
                  AND (p.DataFineValidita IS NULL OR p.DataFineValidita >= SYSUTCDATETIME());
                """;

            await using var dupConn = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
            var dup = await dupConn.ExecuteScalarAsync<int>(new CommandDefinition(
                dupSql,
                new { CodiceFiscale = command.Request.CodiceFiscale.Trim() },
                cancellationToken: cancellationToken));

            if (dup > 0)
            {
                return null;
            }
        }

        var colNames = new List<string>();
        var colValues = new List<string>();
        var p = new DynamicParameters();

        void Add(string col, string sqlValue, object? value = null)
        {
            if (!columns.ContainsKey(col))
            {
                return;
            }

            colNames.Add($"[{col}]");
            colValues.Add(sqlValue);
            if (value is not null)
            {
                p.Add(col, value);
            }
        }

        Add("Cognome", "@Cognome", command.Request.Cognome.Trim());
        Add("Nome", "@Nome", command.Request.Nome.Trim());
        Add("CodiceFiscale", "@CodiceFiscale", string.IsNullOrWhiteSpace(command.Request.CodiceFiscale) ? null : command.Request.CodiceFiscale.Trim());
        Add("DataNascita", "@DataNascita", command.Request.DataNascita);

        Add("DataInizioValidita", "@DataInizioValidita", now);
        Add("DataFineValidita", "@DataFineValidita", fineValidita);

        Add("UniqueRowId", "@UniqueRowId", Guid.NewGuid());
        Add("DataCreazione", "@DataCreazione", now);
        Add("CreatoDa", "@CreatoDa", actorInt);
        Add("DataModifica", "@DataModifica", now);
        Add("ModificatoDa", "@ModificatoDa", actorInt);

        var insertSql = $"""
            INSERT INTO [Persone].[Persona]
                ({string.Join(", ", colNames)})
            OUTPUT INSERTED.PersonaId
            VALUES
                ({string.Join(", ", colValues)});
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var personaId = await connection.ExecuteScalarAsync<int>(new CommandDefinition(insertSql, p, cancellationToken: cancellationToken));

        return await GetByIdInt.Handler.Handle(new GetByIdInt.Command(personaId), connectionFactory, cancellationToken);
    }
}
