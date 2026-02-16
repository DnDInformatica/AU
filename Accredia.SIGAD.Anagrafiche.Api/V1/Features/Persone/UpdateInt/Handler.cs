using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.GetByIdInt;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.UpdateInt;

internal static class Handler
{
    public static async Task<PersonaDetailDto?> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        var columns = await CreateInt.DbIntrospection.GetColumnsAsync(connectionFactory, cancellationToken);
        if (!columns.ContainsKey("Cognome") || !columns.ContainsKey("Nome") || !columns.ContainsKey("DataNascita"))
        {
            throw new InvalidOperationException("Schema [Persone].[Persona] non compatibile (mancano colonne base).");
        }

        var now = DateTime.UtcNow;
        var actor = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actor, out var parsedActor) ? parsedActor : 0;

        var sets = new List<string>();
        var p = new DynamicParameters();
        p.Add("PersonaId", command.PersonaId);

        void Set(string col, string sql, object? value = null)
        {
            if (!columns.ContainsKey(col))
            {
                return;
            }

            sets.Add(sql);
            if (value is not null)
            {
                p.Add(col, value);
            }
        }

        Set("Cognome", "[Cognome] = @Cognome", command.Request.Cognome.Trim());
        Set("Nome", "[Nome] = @Nome", command.Request.Nome.Trim());
        Set("CodiceFiscale", "[CodiceFiscale] = @CodiceFiscale", string.IsNullOrWhiteSpace(command.Request.CodiceFiscale) ? null : command.Request.CodiceFiscale.Trim());
        Set("DataNascita", "[DataNascita] = @DataNascita", command.Request.DataNascita);

        Set("DataModifica", "[DataModifica] = @DataModifica", now);
        Set("ModificatoDa", "[ModificatoDa] = @ModificatoDa", actorInt);

        var updateSql = $"""
            UPDATE [Persone].[Persona]
            SET {string.Join(", ", sets)}
            WHERE [PersonaId] = @PersonaId
              AND [DataCancellazione] IS NULL;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(updateSql, p, cancellationToken: cancellationToken));
        if (rows == 0)
        {
            return null;
        }

        return await GetByIdInt.Handler.Handle(new GetByIdInt.Command(command.PersonaId), connectionFactory, cancellationToken);
    }
}
