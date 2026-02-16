using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetIdentificativi;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.IdentificativiUpdate;

internal static class Handler
{
    internal enum Result
    {
        Updated,
        NotFound,
        Duplicate
    }

    public static async Task<(Result Result, IdentificativoDto? Item)> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string existsSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[OrganizzazioneIdentificativoFiscale]
            WHERE OrganizzazioneIdentificativoFiscaleId = @IdentificativoId
              AND OrganizzazioneId = @OrganizzazioneId
              AND DataInizioValidita <= SYSUTCDATETIME()
              AND DataFineValidita >= SYSUTCDATETIME();
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[OrganizzazioneIdentificativoFiscale]
            WHERE OrganizzazioneId = @OrganizzazioneId
              AND OrganizzazioneIdentificativoFiscaleId <> @IdentificativoId
              AND TipoIdentificativo = @TipoIdentificativo
              AND Valore = @Valore
              AND DataInizioValidita <= SYSUTCDATETIME()
              AND DataFineValidita >= SYSUTCDATETIME();
            """;

        const string clearPrincipaleSql = """
            UPDATE [Organizzazioni].[OrganizzazioneIdentificativoFiscale]
            SET Principale = CAST(0 AS bit),
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE OrganizzazioneId = @OrganizzazioneId
              AND OrganizzazioneIdentificativoFiscaleId <> @IdentificativoId
              AND DataInizioValidita <= SYSUTCDATETIME()
              AND DataFineValidita >= SYSUTCDATETIME()
              AND Principale = CAST(1 AS bit);
            """;

        const string updateSql = """
            UPDATE [Organizzazioni].[OrganizzazioneIdentificativoFiscale]
            SET PaeseISO2 = @PaeseISO2,
                TipoIdentificativo = @TipoIdentificativo,
                Valore = @Valore,
                Principale = @Principale,
                Note = @Note,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE OrganizzazioneIdentificativoFiscaleId = @IdentificativoId
              AND OrganizzazioneId = @OrganizzazioneId
              AND DataInizioValidita <= SYSUTCDATETIME()
              AND DataFineValidita >= SYSUTCDATETIME();
            """;

        const string byIdSql = """
            SELECT
                i.OrganizzazioneIdentificativoFiscaleId AS Id,
                RTRIM(i.PaeseISO2) AS PaeseISO2,
                i.TipoIdentificativo,
                i.Valore,
                i.Principale,
                i.Note
            FROM [Organizzazioni].[OrganizzazioneIdentificativoFiscale] i
            WHERE i.OrganizzazioneIdentificativoFiscaleId = @IdentificativoId
              AND i.OrganizzazioneId = @OrganizzazioneId
              AND i.DataInizioValidita <= SYSUTCDATETIME()
              AND i.DataFineValidita >= SYSUTCDATETIME();
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            existsSql,
            new { command.IdentificativoId, command.OrganizzazioneId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (Result.NotFound, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new
            {
                command.IdentificativoId,
                command.OrganizzazioneId,
                TipoIdentificativo = command.Request.TipoIdentificativo.Trim(),
                Valore = command.Request.Valore.Trim()
            },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (Result.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;

        await using var tx = await connection.BeginTransactionAsync(cancellationToken);

        if (command.Request.Principale)
        {
            await connection.ExecuteAsync(new CommandDefinition(
                clearPrincipaleSql,
                new { command.OrganizzazioneId, command.IdentificativoId, Now = now, ActorInt = actorInt },
                tx,
                cancellationToken: cancellationToken));
        }

        await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new
            {
                command.IdentificativoId,
                command.OrganizzazioneId,
                PaeseISO2 = command.Request.PaeseISO2.Trim().ToUpperInvariant(),
                TipoIdentificativo = command.Request.TipoIdentificativo.Trim().ToUpperInvariant(),
                Valore = command.Request.Valore.Trim(),
                command.Request.Principale,
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                Now = now,
                ActorInt = actorInt
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<IdentificativoDto>(new CommandDefinition(
            byIdSql,
            new { command.IdentificativoId, command.OrganizzazioneId },
            tx,
            cancellationToken: cancellationToken));

        await tx.CommitAsync(cancellationToken);
        return (Result.Updated, item);
    }
}

