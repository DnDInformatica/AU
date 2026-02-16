using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaSoftDelete;

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
        var columns = await UnitaCreate.DbIntrospection.GetColumnsAsync(connectionFactory, cancellationToken);
        var actorDb = UnitaCreate.DbIntrospection.GetActorDbValue(columns, "ModificatoDa", actor);

        const string sql = @"
UPDATE [Organizzazioni].[UnitaOrganizzativa]
SET DataCancellazione = @Now,
    DataModifica = @Now,
    ModificatoDa = @Actor
WHERE OrganizzazioneId = @OrganizzazioneId
  AND UnitaOrganizzativaId = @UnitaOrganizzativaId
  AND DataCancellazione IS NULL;";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(
            sql,
            new { command.OrganizzazioneId, command.UnitaOrganizzativaId, Now = now, Actor = actorDb },
            cancellationToken: cancellationToken));

        return rows > 0;
    }
}
