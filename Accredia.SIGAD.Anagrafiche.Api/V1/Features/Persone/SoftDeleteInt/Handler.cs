using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.SoftDeleteInt;

internal static class Handler
{
    public static async Task<bool> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        var columns = await V1.Features.Persone.CreateInt.DbIntrospection.GetColumnsAsync(connectionFactory, cancellationToken);
        if (!columns.ContainsKey("DataCancellazione"))
        {
            throw new InvalidOperationException("Colonna DataCancellazione mancante su [Persone].[Persona].");
        }

        var now = DateTime.UtcNow;
        var actor = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actor, out var parsedActor) ? parsedActor : 0;

        var sets = new List<string> { "[DataCancellazione] = @Now" };
        var p = new DynamicParameters();
        p.Add("PersonaId", command.PersonaId);
        p.Add("Now", now);

        if (columns.ContainsKey("DataModifica"))
        {
            sets.Add("[DataModifica] = @Now");
        }
        if (columns.ContainsKey("ModificatoDa"))
        {
            sets.Add("[ModificatoDa] = @Actor");
            p.Add("Actor", actorInt);
        }

        var sql = $"""
            UPDATE [Persone].[Persona]
            SET {string.Join(", ", sets)}
            WHERE [PersonaId] = @PersonaId
              AND [DataCancellazione] IS NULL;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(sql, p, cancellationToken: cancellationToken));
        return rows > 0;
    }
}
