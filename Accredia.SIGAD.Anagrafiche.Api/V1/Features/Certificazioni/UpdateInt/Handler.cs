using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.CreateInt;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.GetByIdInt;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.UpdateInt;

internal static class Handler
{
    public static async Task<CertificazioneDetailDto?> Handle(
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

        var sets = new List<string>();
        var p = new DynamicParameters();
        p.Add("CertificazioneId", command.CertificazioneId);

        sets.Add("[Denominazione] = @Denominazione");
        p.Add("Denominazione", command.Request.Denominazione.Trim());

        if (columns.ContainsKey("Sigla"))
        {
            sets.Add("[Sigla] = @Sigla");
            p.Add("Sigla", string.IsNullOrWhiteSpace(command.Request.Sigla) ? null : command.Request.Sigla.Trim());
        }

        if (columns.ContainsKey("Note"))
        {
            sets.Add("[Note] = @Note");
            p.Add("Note", string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim());
        }

        if (columns.ContainsKey("DataFondazione"))
        {
            sets.Add("[DataFondazione] = @DataFondazione");
            p.Add("DataFondazione", command.Request.DataFondazione?.Date);
        }

        if (columns.ContainsKey("DataModifica"))
        {
            sets.Add("[DataModifica] = @Now");
            p.Add("Now", now);
        }

        if (columns.ContainsKey("ModificatoDa"))
        {
            sets.Add("[ModificatoDa] = @Actor");
            p.Add("Actor", actorDb);
        }

        var sql = $"""
            UPDATE [Accreditamento].[EnteAccreditamento]
            SET {string.Join(", ", sets)}
            WHERE [EnteAccreditamentoId] = @CertificazioneId
              AND [DataCancellazione] IS NULL;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(sql, p, cancellationToken: cancellationToken));
        if (rows == 0)
        {
            return null;
        }

        return await GetByIdInt.Handler.Handle(new GetByIdInt.Command(command.CertificazioneId), connectionFactory, cancellationToken);
    }
}
