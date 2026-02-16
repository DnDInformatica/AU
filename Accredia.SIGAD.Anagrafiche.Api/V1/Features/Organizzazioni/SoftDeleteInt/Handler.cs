using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SoftDeleteInt;

internal static class Handler
{
    public static async Task<bool> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        var columns = await V1.Features.Organizzazioni.CreateInt.DbIntrospection.GetColumnsAsync(connectionFactory, cancellationToken);
        if (!columns.ContainsKey("DataCancellazione"))
        {
            throw new InvalidOperationException("Colonna DataCancellazione mancante su [Organizzazioni].[Organizzazione].");
        }

        var now = DateTime.UtcNow;
        var actor = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();

        var sets = new List<string> { "[DataCancellazione] = @Now" };
        var p = new DynamicParameters();
        p.Add("OrganizzazioneId", command.OrganizzazioneId);
        p.Add("Now", now);

        if (columns.ContainsKey("DataModifica"))
        {
            sets.Add("[DataModifica] = @Now");
        }
        if (columns.ContainsKey("ModificatoDa"))
        {
            sets.Add("[ModificatoDa] = @Actor");
            var actorDb = V1.Features.Organizzazioni.CreateInt.DbIntrospection.GetActorDbValue(columns, "ModificatoDa", actor);
            p.Add("Actor", actorDb);
        }

        var sql = $"""
            UPDATE [Organizzazioni].[Organizzazione]
            SET {string.Join(", ", sets)}
            WHERE [OrganizzazioneId] = @OrganizzazioneId
              AND [DataCancellazione] IS NULL;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(sql, p, cancellationToken: cancellationToken));
        return rows > 0;
    }
}
