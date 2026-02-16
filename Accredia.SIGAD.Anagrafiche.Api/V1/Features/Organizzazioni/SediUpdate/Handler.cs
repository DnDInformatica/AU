using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetSedi;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediGetById;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediUpdate;

internal static class Handler
{
    public static async Task<SedeDto?> Handle(
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

        const string updateSql = @"
UPDATE [Organizzazioni].[Sede]
SET Denominazione = @Denominazione,
    Indirizzo = @Indirizzo,
    NumeroCivico = @NumeroCivico,
    CAP = @CAP,
    Localita = @Localita,
    Provincia = @Provincia,
    Nazione = @Nazione,
    StatoSede = @StatoSede,
    IsSedePrincipale = @IsSedePrincipale,
    IsSedeOperativa = @IsSedeOperativa,
    DataApertura = @DataApertura,
    DataCessazione = @DataCessazione,
    TipoSedeId = @TipoSedeId,
    DataModifica = @Now,
    ModificatoDa = @Actor
WHERE OrganizzazioneId = @OrganizzazioneId
  AND SedeId = @SedeId
  AND DataCancellazione IS NULL;";

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
        await using var tx = connection.BeginTransaction();

        var rows = await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new
            {
                command.OrganizzazioneId,
                command.SedeId,
                command.Request.Denominazione,
                command.Request.Indirizzo,
                command.Request.NumeroCivico,
                command.Request.CAP,
                command.Request.Localita,
                command.Request.Provincia,
                command.Request.Nazione,
                command.Request.StatoSede,
                IsSedePrincipale = command.Request.IsSedePrincipale ? 1 : 0,
                IsSedeOperativa = command.Request.IsSedeOperativa ? 1 : 0,
                command.Request.DataApertura,
                command.Request.DataCessazione,
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

        if (command.Request.IsSedePrincipale)
        {
            await connection.ExecuteAsync(new CommandDefinition(
                clearOtherPrincipalsSql,
                new { command.OrganizzazioneId, command.SedeId, Now = now, Actor = actorDb },
                tx,
                cancellationToken: cancellationToken));
        }

        tx.Commit();

        return await SediGetById.Handler.Handle(new SediGetById.Command(command.OrganizzazioneId, command.SedeId), connectionFactory, cancellationToken);
    }
}
