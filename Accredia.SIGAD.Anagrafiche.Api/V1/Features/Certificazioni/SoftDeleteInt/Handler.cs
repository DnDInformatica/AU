using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.CreateInt;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.SoftDeleteInt;

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
        var actorModifica = DbIntrospection.GetActorDbValue(columns, "ModificatoDa", actor);
        var actorCancellazione = DbIntrospection.GetActorDbValue(columns, "CancellatoDa", actor);

        var sets = new List<string> { "[DataCancellazione] = @Now" };
        var p = new DynamicParameters();
        p.Add("CertificazioneId", command.CertificazioneId);
        p.Add("Now", now);

        if (columns.ContainsKey("DataModifica"))
        {
            sets.Add("[DataModifica] = @Now");
        }

        if (columns.ContainsKey("ModificatoDa"))
        {
            sets.Add("[ModificatoDa] = @ActorModifica");
            p.Add("ActorModifica", actorModifica);
        }

        if (columns.ContainsKey("CancellatoDa"))
        {
            sets.Add("[CancellatoDa] = @ActorCancellazione");
            p.Add("ActorCancellazione", actorCancellazione);
        }

        var sql = $"""
            UPDATE [Accreditamento].[EnteAccreditamento]
            SET {string.Join(", ", sets)}
            WHERE [EnteAccreditamentoId] = @CertificazioneId
              AND [DataCancellazione] IS NULL;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(sql, p, cancellationToken: cancellationToken));
        return rows > 0;
    }
}
