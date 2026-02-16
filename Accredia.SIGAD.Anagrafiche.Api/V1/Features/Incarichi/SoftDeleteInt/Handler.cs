using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.CreateInt;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Incarichi.SoftDeleteInt;

internal static class Handler
{
    public static async Task<bool> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        var columns = await DbIntrospection.GetColumnsAsync(connectionFactory, cancellationToken);
        var now = DateTime.UtcNow;
        var actor = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorDb = DbIntrospection.GetActorDbValue(columns, "ModificatoDa", actor);

        var sets = new List<string> { "[DataCancellazione] = @Now" };
        var p = new DynamicParameters();
        p.Add("IncaricoId", command.IncaricoId);
        p.Add("Now", now);

        if (columns.ContainsKey("DataModifica"))
        {
            sets.Add("[DataModifica] = @Now");
        }

        if (columns.ContainsKey("ModificatoDa"))
        {
            sets.Add("[ModificatoDa] = @Actor");
            p.Add("Actor", actorDb);
        }

        var sql = $"""
            UPDATE [Organizzazioni].[Incarico]
            SET {string.Join(", ", sets)}
            WHERE [IncaricoId] = @IncaricoId
              AND [DataCancellazione] IS NULL;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(sql, p, cancellationToken: cancellationToken));
        return rows > 0;
    }
}

