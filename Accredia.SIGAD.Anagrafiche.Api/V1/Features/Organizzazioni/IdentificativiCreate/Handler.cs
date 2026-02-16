using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetIdentificativi;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.IdentificativiCreate;

internal static class Handler
{
    internal enum Result
    {
        Created,
        NotFound,
        Duplicate
    }

    public static async Task<(Result Result, IdentificativoDto? Item)> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string orgExistsSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[Organizzazione]
            WHERE OrganizzazioneId = @OrganizzazioneId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[OrganizzazioneIdentificativoFiscale]
            WHERE OrganizzazioneId = @OrganizzazioneId
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
              AND DataInizioValidita <= SYSUTCDATETIME()
              AND DataFineValidita >= SYSUTCDATETIME()
              AND Principale = CAST(1 AS bit);
            """;

        const string insertSql = """
            DECLARE @newIds TABLE (Id int);

            INSERT INTO [Organizzazioni].[OrganizzazioneIdentificativoFiscale]
                ([OrganizzazioneId], [PaeseISO2], [TipoIdentificativo], [Valore], [Principale], [Note], [CreatoDa], [ModificatoDa], [DataCreazione], [DataModifica], [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.OrganizzazioneIdentificativoFiscaleId INTO @newIds(Id)
            VALUES
                (@OrganizzazioneId, @PaeseISO2, @TipoIdentificativo, @Valore, @Principale, @Note, @ActorInt, @ActorInt, @Now, @Now, @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
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
            WHERE i.OrganizzazioneId = @OrganizzazioneId
              AND i.OrganizzazioneIdentificativoFiscaleId = @Id
              AND i.DataInizioValidita <= SYSUTCDATETIME()
              AND i.DataFineValidita >= SYSUTCDATETIME();
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            orgExistsSql,
            new { command.OrganizzazioneId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (Result.NotFound, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new
            {
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
        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);

        await using var tx = await connection.BeginTransactionAsync(cancellationToken);

        if (command.Request.Principale)
        {
            await connection.ExecuteAsync(new CommandDefinition(
                clearPrincipaleSql,
                new { command.OrganizzazioneId, Now = now, ActorInt = actorInt },
                tx,
                cancellationToken: cancellationToken));
        }

        var id = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            insertSql,
            new
            {
                command.OrganizzazioneId,
                PaeseISO2 = command.Request.PaeseISO2.Trim().ToUpperInvariant(),
                TipoIdentificativo = command.Request.TipoIdentificativo.Trim().ToUpperInvariant(),
                Valore = command.Request.Valore.Trim(),
                Principale = command.Request.Principale,
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                ActorInt = actorInt,
                Now = now,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<IdentificativoDto>(new CommandDefinition(
            byIdSql,
            new { command.OrganizzazioneId, Id = id },
            tx,
            cancellationToken: cancellationToken));

        await tx.CommitAsync(cancellationToken);
        return (Result.Created, item);
    }
}

