using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.IdentificativiDelete;

internal static class Handler
{
    public static async Task<bool> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            UPDATE [Organizzazioni].[OrganizzazioneIdentificativoFiscale]
            SET DataFineValidita = @Now,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE OrganizzazioneId = @OrganizzazioneId
              AND OrganizzazioneIdentificativoFiscaleId = @IdentificativoId
              AND DataInizioValidita <= SYSUTCDATETIME()
              AND DataFineValidita >= SYSUTCDATETIME();
            """;

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(
            sql,
            new
            {
                command.OrganizzazioneId,
                command.IdentificativoId,
                Now = now,
                ActorInt = actorInt
            },
            cancellationToken: cancellationToken));

        return rows > 0;
    }
}

