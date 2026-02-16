using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GruppiIvaMembri;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFound,
        Duplicate,
        InvalidOrganizzazione
    }

    public static async Task<IReadOnlyList<GruppoIvaMembroDto>?> ListAsync(
        ListCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string groupExistsSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[GruppoIVA] g
            WHERE g.GruppoIVAId = @GruppoIvaId
              AND g.DataCancellazione IS NULL;
            """;
        const string listSql = """
            SELECT
                m.GruppoIVAMembroId AS GruppoIvaMembroId,
                m.GruppoIVAId AS GruppoIvaId,
                m.OrganizzazioneId,
                CAST(m.DataAdesione AS datetime2) AS DataAdesione,
                CAST(m.DataUscita AS datetime2) AS DataUscita,
                m.MotivoUscita,
                m.ProtocolloUscita,
                m.IsCapogruppo,
                m.RuoloNelGruppo,
                m.PercentualePartecipazione,
                m.StatoMembro,
                m.Note
            FROM [Organizzazioni].[GruppoIVAMembri] m
            WHERE m.GruppoIVAId = @GruppoIvaId
              AND m.DataCancellazione IS NULL
              AND (m.DataInizioValidita IS NULL OR m.DataInizioValidita <= SYSUTCDATETIME())
              AND (m.DataFineValidita IS NULL OR m.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY m.GruppoIVAMembroId DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            groupExistsSql,
            new { command.GruppoIvaId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return null;
        }

        var rows = (await connection.QueryAsync<GruppoIvaMembroDto>(new CommandDefinition(
            listSql,
            new { command.GruppoIvaId },
            cancellationToken: cancellationToken))).ToList();
        return rows;
    }

    public static async Task<(WriteResult Result, GruppoIvaMembroDto? Item)> CreateAsync(
        CreateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[GruppoIVAMembri] m
            WHERE m.GruppoIVAId = @GruppoIvaId
              AND m.OrganizzazioneId = @OrganizzazioneId
              AND m.DataCancellazione IS NULL
              AND (m.DataInizioValidita IS NULL OR m.DataInizioValidita <= SYSUTCDATETIME())
              AND (m.DataFineValidita IS NULL OR m.DataFineValidita >= SYSUTCDATETIME());
            """;
        const string clearCapogruppoSql = """
            UPDATE [Organizzazioni].[GruppoIVAMembri]
            SET IsCapogruppo = CAST(0 AS bit),
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE GruppoIVAId = @GruppoIvaId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME())
              AND IsCapogruppo = CAST(1 AS bit);
            """;
        const string insertSql = """
            DECLARE @newIds TABLE (Id int);
            INSERT INTO [Organizzazioni].[GruppoIVAMembri]
                ([GruppoIVAId], [OrganizzazioneId], [DataAdesione], [DataUscita], [MotivoUscita], [ProtocolloUscita], [IsCapogruppo], [RuoloNelGruppo], [PercentualePartecipazione], [StatoMembro], [Note], [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa], [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.GruppoIVAMembroId INTO @newIds(Id)
            VALUES
                (@GruppoIvaId, @OrganizzazioneId, @DataAdesione, @DataUscita, @MotivoUscita, @ProtocolloUscita, @IsCapogruppo, @RuoloNelGruppo, @PercentualePartecipazione, @StatoMembro, @Note, @Now, @ActorInt, @Now, @ActorInt, @UniqueRowId, @Now, @DataFineValidita);
            SELECT TOP (1) Id FROM @newIds;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await GruppoExistsAsync(connection, command.GruppoIvaId, cancellationToken))
        {
            return (WriteResult.NotFound, null);
        }

        if (!await OrganizzazioneExistsAsync(connection, command.Request.OrganizzazioneId, cancellationToken))
        {
            return (WriteResult.InvalidOrganizzazione, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.GruppoIvaId, command.Request.OrganizzazioneId },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        var dataAdesione = (command.Request.DataAdesione ?? now).Date;
        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);

        await using var tx = await connection.BeginTransactionAsync(cancellationToken);
        if (command.Request.IsCapogruppo)
        {
            await connection.ExecuteAsync(new CommandDefinition(
                clearCapogruppoSql,
                new { command.GruppoIvaId, Now = now, ActorInt = actorInt },
                tx,
                cancellationToken: cancellationToken));
        }

        var id = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            insertSql,
            new
            {
                command.GruppoIvaId,
                command.Request.OrganizzazioneId,
                DataAdesione = dataAdesione,
                DataUscita = command.Request.DataUscita?.Date,
                MotivoUscita = string.IsNullOrWhiteSpace(command.Request.MotivoUscita) ? null : command.Request.MotivoUscita.Trim(),
                ProtocolloUscita = string.IsNullOrWhiteSpace(command.Request.ProtocolloUscita) ? null : command.Request.ProtocolloUscita.Trim(),
                command.Request.IsCapogruppo,
                RuoloNelGruppo = string.IsNullOrWhiteSpace(command.Request.RuoloNelGruppo) ? null : command.Request.RuoloNelGruppo.Trim(),
                command.Request.PercentualePartecipazione,
                StatoMembro = string.IsNullOrWhiteSpace(command.Request.StatoMembro) ? "ATTIVO" : command.Request.StatoMembro.Trim(),
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            tx,
            cancellationToken: cancellationToken));

        var list = await ListAsync(new ListCommand(command.GruppoIvaId), connectionFactory, cancellationToken);
        var item = list!.First(x => x.GruppoIvaMembroId == id);
        await tx.CommitAsync(cancellationToken);
        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, GruppoIvaMembroDto? Item)> UpdateAsync(
        UpdateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string existsSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[GruppoIVAMembri] m
            WHERE m.GruppoIVAMembroId = @GruppoIvaMembroId
              AND m.GruppoIVAId = @GruppoIvaId
              AND m.DataCancellazione IS NULL;
            """;
        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[GruppoIVAMembri] m
            WHERE m.GruppoIVAMembroId <> @GruppoIvaMembroId
              AND m.GruppoIVAId = @GruppoIvaId
              AND m.OrganizzazioneId = @OrganizzazioneId
              AND m.DataCancellazione IS NULL
              AND (m.DataInizioValidita IS NULL OR m.DataInizioValidita <= SYSUTCDATETIME())
              AND (m.DataFineValidita IS NULL OR m.DataFineValidita >= SYSUTCDATETIME());
            """;
        const string clearCapogruppoSql = """
            UPDATE [Organizzazioni].[GruppoIVAMembri]
            SET IsCapogruppo = CAST(0 AS bit),
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE GruppoIVAId = @GruppoIvaId
              AND GruppoIVAMembroId <> @GruppoIvaMembroId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME())
              AND IsCapogruppo = CAST(1 AS bit);
            """;
        const string updateSql = """
            UPDATE [Organizzazioni].[GruppoIVAMembri]
            SET OrganizzazioneId = @OrganizzazioneId,
                DataAdesione = @DataAdesione,
                DataUscita = @DataUscita,
                MotivoUscita = @MotivoUscita,
                ProtocolloUscita = @ProtocolloUscita,
                IsCapogruppo = @IsCapogruppo,
                RuoloNelGruppo = @RuoloNelGruppo,
                PercentualePartecipazione = @PercentualePartecipazione,
                StatoMembro = @StatoMembro,
                Note = @Note,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE GruppoIVAMembroId = @GruppoIvaMembroId
              AND GruppoIVAId = @GruppoIvaId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            existsSql,
            new { command.GruppoIvaId, command.GruppoIvaMembroId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        if (!await OrganizzazioneExistsAsync(connection, command.Request.OrganizzazioneId, cancellationToken))
        {
            return (WriteResult.InvalidOrganizzazione, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.GruppoIvaId, command.GruppoIvaMembroId, command.Request.OrganizzazioneId },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        var dataAdesione = (command.Request.DataAdesione ?? now).Date;

        await using var tx = await connection.BeginTransactionAsync(cancellationToken);
        if (command.Request.IsCapogruppo)
        {
            await connection.ExecuteAsync(new CommandDefinition(
                clearCapogruppoSql,
                new { command.GruppoIvaId, command.GruppoIvaMembroId, Now = now, ActorInt = actorInt },
                tx,
                cancellationToken: cancellationToken));
        }

        await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new
            {
                command.GruppoIvaId,
                command.GruppoIvaMembroId,
                command.Request.OrganizzazioneId,
                DataAdesione = dataAdesione,
                DataUscita = command.Request.DataUscita?.Date,
                MotivoUscita = string.IsNullOrWhiteSpace(command.Request.MotivoUscita) ? null : command.Request.MotivoUscita.Trim(),
                ProtocolloUscita = string.IsNullOrWhiteSpace(command.Request.ProtocolloUscita) ? null : command.Request.ProtocolloUscita.Trim(),
                command.Request.IsCapogruppo,
                RuoloNelGruppo = string.IsNullOrWhiteSpace(command.Request.RuoloNelGruppo) ? null : command.Request.RuoloNelGruppo.Trim(),
                command.Request.PercentualePartecipazione,
                StatoMembro = string.IsNullOrWhiteSpace(command.Request.StatoMembro) ? "ATTIVO" : command.Request.StatoMembro.Trim(),
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                Now = now,
                ActorInt = actorInt
            },
            tx,
            cancellationToken: cancellationToken));

        var list = await ListAsync(new ListCommand(command.GruppoIvaId), connectionFactory, cancellationToken);
        var item = list!.First(x => x.GruppoIvaMembroId == command.GruppoIvaMembroId);
        await tx.CommitAsync(cancellationToken);
        return (WriteResult.Success, item);
    }

    public static async Task<WriteResult> DeleteAsync(
        DeleteCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            UPDATE [Organizzazioni].[GruppoIVAMembri]
            SET DataCancellazione = @Now,
                CancellatoDa = @ActorInt,
                DataModifica = @Now,
                ModificatoDa = @ActorInt,
                DataFineValidita = @Now
            WHERE GruppoIVAMembroId = @GruppoIvaMembroId
              AND GruppoIVAId = @GruppoIvaId
              AND DataCancellazione IS NULL;
            """;
        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(
            sql,
            new { command.GruppoIvaId, command.GruppoIvaMembroId, Now = now, ActorInt = actorInt },
            cancellationToken: cancellationToken));
        return rows == 0 ? WriteResult.NotFound : WriteResult.Success;
    }

    private static async Task<bool> GruppoExistsAsync(System.Data.Common.DbConnection connection, int gruppoIvaId, CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT COUNT(1) FROM [Organizzazioni].[GruppoIVA]
            WHERE GruppoIVAId = @GruppoIvaId AND DataCancellazione IS NULL;
            """;
        var count = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            sql,
            new { GruppoIvaId = gruppoIvaId },
            cancellationToken: cancellationToken));
        return count > 0;
    }

    private static async Task<bool> OrganizzazioneExistsAsync(System.Data.Common.DbConnection connection, int organizzazioneId, CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[Organizzazione]
            WHERE OrganizzazioneId = @OrganizzazioneId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;
        var count = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            sql,
            new { OrganizzazioneId = organizzazioneId },
            cancellationToken: cancellationToken));
        return count > 0;
    }
}
