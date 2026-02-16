using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediSoftDelete;

internal static class Handler
{
    public static async Task<bool> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        var now = DateTime.UtcNow;
        var actor = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var columns = await SediCreate.DbIntrospection.GetColumnsAsync(connectionFactory, cancellationToken);
        var actorDb = SediCreate.DbIntrospection.GetActorDbValue(columns, "ModificatoDa", actor);

        const string sql = @"
UPDATE [Organizzazioni].[Sede]
SET DataCancellazione = @Now,
    DataModifica = @Now,
    ModificatoDa = @Actor
WHERE OrganizzazioneId = @OrganizzazioneId
  AND SedeId = @SedeId
  AND DataCancellazione IS NULL;";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(
            sql,
            new { command.OrganizzazioneId, command.SedeId, Now = now, Actor = actorDb },
            cancellationToken: cancellationToken));

        return rows > 0;
    }
}
