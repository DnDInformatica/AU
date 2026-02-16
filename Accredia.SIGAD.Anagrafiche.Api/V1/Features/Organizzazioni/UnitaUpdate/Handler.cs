using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetUnita;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaGetById;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaUpdate;

internal static class Handler
{
    public static async Task<UnitaOrganizzativaDto?> Handle(
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

        const string updateSql = @"
UPDATE [Organizzazioni].[UnitaOrganizzativa]
SET Nome = @Nome,
    Codice = @Codice,
    Principale = @Principale,
    TipoUnitaOrganizzativaId = @TipoUnitaOrganizzativaId,
    TipoSedeId = @TipoSedeId,
    DataModifica = @Now,
    ModificatoDa = @Actor
WHERE OrganizzazioneId = @OrganizzazioneId
  AND UnitaOrganizzativaId = @UnitaOrganizzativaId
  AND DataCancellazione IS NULL;";

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
        await using var tx = connection.BeginTransaction();

        var rows = await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new
            {
                command.OrganizzazioneId,
                command.UnitaOrganizzativaId,
                Nome = command.Request.Nome.Trim(),
                Codice = string.IsNullOrWhiteSpace(command.Request.Codice) ? null : command.Request.Codice.Trim(),
                Principale = command.Request.Principale ? 1 : 0,
                command.Request.TipoUnitaOrganizzativaId,
                command.Request.TipoSedeId,
                Now = now,
                Actor = actorDb
            },
            tx,
            cancellationToken: cancellationToken));

        if (rows == 0)
        {
            tx.Rollback();
            return null;
        }

        if (command.Request.Principale)
        {
            await connection.ExecuteAsync(new CommandDefinition(
                clearOtherPrincipalsSql,
                new { command.OrganizzazioneId, command.UnitaOrganizzativaId, Now = now, Actor = actorDb },
                tx,
                cancellationToken: cancellationToken));
        }

        tx.Commit();

        return await UnitaGetById.Handler.Handle(new UnitaGetById.Command(command.OrganizzazioneId, command.UnitaOrganizzativaId), connectionFactory, cancellationToken);
    }
}
