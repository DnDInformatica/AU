using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaContatti;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFound,
        Duplicate,
        InvalidTipoContatto
    }

    public static async Task<IReadOnlyList<ContattoDto>?> ListAsync(
        ListCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string orgExistsSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[Organizzazione] o
            WHERE o.OrganizzazioneId = @OrganizzazioneId
              AND o.DataCancellazione IS NULL
              AND (o.DataInizioValidita IS NULL OR o.DataInizioValidita <= SYSUTCDATETIME())
              AND (o.DataFineValidita IS NULL OR o.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string listSql = """
            SELECT
                c.ContattoId,
                c.UnitaOrganizzativaId,
                c.TipoContattoId,
                c.Valore,
                c.ValoreSecondario,
                c.Descrizione,
                c.Note,
                CAST(c.DataInizio AS datetime2) AS DataInizio,
                CAST(c.DataFine AS datetime2) AS DataFine,
                c.Principale,
                c.OrdinePriorita,
                c.IsVerificato,
                c.DataVerifica,
                c.IsPubblico
            FROM [Organizzazioni].[ContattoUnitaOrganizzativa] c
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = c.UnitaOrganizzativaId
            WHERE u.OrganizzazioneId = @OrganizzazioneId
              AND c.DataCancellazione IS NULL
              AND u.DataCancellazione IS NULL
              AND (c.DataInizioValidita IS NULL OR c.DataInizioValidita <= SYSUTCDATETIME())
              AND (c.DataFineValidita IS NULL OR c.DataFineValidita >= SYSUTCDATETIME())
              AND (u.DataInizioValidita IS NULL OR u.DataInizioValidita <= SYSUTCDATETIME())
              AND (u.DataFineValidita IS NULL OR u.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY c.Principale DESC, c.OrdinePriorita ASC, c.ContattoId DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(orgExistsSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return null;
        }

        var rows = (await connection.QueryAsync<ContattoDto>(
            new CommandDefinition(listSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();
        return rows;
    }

    public static async Task<(WriteResult Result, ContattoDto? Item)> CreateAsync(
        CreateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[ContattoUnitaOrganizzativa] c
            WHERE c.UnitaOrganizzativaId = @UnitaOrganizzativaId
              AND c.TipoContattoId = @TipoContattoId
              AND c.Valore = @Valore
              AND c.DataCancellazione IS NULL
              AND (c.DataInizioValidita IS NULL OR c.DataInizioValidita <= SYSUTCDATETIME())
              AND (c.DataFineValidita IS NULL OR c.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string clearPrincipaleSql = """
            UPDATE [Organizzazioni].[ContattoUnitaOrganizzativa]
            SET Principale = CAST(0 AS bit),
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE UnitaOrganizzativaId = @UnitaOrganizzativaId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME())
              AND Principale = CAST(1 AS bit);
            """;

        const string insertSql = """
            DECLARE @newIds TABLE (Id int);

            INSERT INTO [Organizzazioni].[ContattoUnitaOrganizzativa]
                ([UnitaOrganizzativaId], [TipoContattoId], [Valore], [ValoreSecondario], [Descrizione], [Note], [DataInizio], [DataFine], [Principale], [OrdinePriorita], [IsVerificato], [DataVerifica], [IsPubblico], [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa], [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.ContattoId INTO @newIds(Id)
            VALUES
                (@UnitaOrganizzativaId, @TipoContattoId, @Valore, @ValoreSecondario, @Descrizione, @Note, @DataInizio, @DataFine, @Principale, @OrdinePriorita, @IsVerificato, @DataVerifica, @IsPubblico, @Now, @ActorInt, @Now, @ActorInt, @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                c.ContattoId,
                c.UnitaOrganizzativaId,
                c.TipoContattoId,
                c.Valore,
                c.ValoreSecondario,
                c.Descrizione,
                c.Note,
                CAST(c.DataInizio AS datetime2) AS DataInizio,
                CAST(c.DataFine AS datetime2) AS DataFine,
                c.Principale,
                c.OrdinePriorita,
                c.IsVerificato,
                c.DataVerifica,
                c.IsPubblico
            FROM [Organizzazioni].[ContattoUnitaOrganizzativa] c
            WHERE c.ContattoId = @Id
              AND c.DataCancellazione IS NULL
              AND (c.DataInizioValidita IS NULL OR c.DataInizioValidita <= SYSUTCDATETIME())
              AND (c.DataFineValidita IS NULL OR c.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await UnitBelongsToOrgAsync(connection, command.OrganizzazioneId, command.Request.UnitaOrganizzativaId, cancellationToken))
        {
            return (WriteResult.NotFound, null);
        }

        if (!await TipoContattoExistsAsync(connection, command.Request.TipoContattoId, cancellationToken))
        {
            return (WriteResult.InvalidTipoContatto, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new
            {
                command.Request.UnitaOrganizzativaId,
                command.Request.TipoContattoId,
                Valore = command.Request.Valore.Trim()
            },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);
        var dataInizio = (command.Request.DataInizio ?? now).Date;
        var dataFine = command.Request.DataFine?.Date;

        await using var tx = await connection.BeginTransactionAsync(cancellationToken);
        if (command.Request.Principale)
        {
            await connection.ExecuteAsync(new CommandDefinition(
                clearPrincipaleSql,
                new { command.Request.UnitaOrganizzativaId, Now = now, ActorInt = actorInt },
                tx,
                cancellationToken: cancellationToken));
        }

        var id = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            insertSql,
            new
            {
                command.Request.UnitaOrganizzativaId,
                command.Request.TipoContattoId,
                Valore = command.Request.Valore.Trim(),
                ValoreSecondario = string.IsNullOrWhiteSpace(command.Request.ValoreSecondario) ? null : command.Request.ValoreSecondario.Trim(),
                Descrizione = string.IsNullOrWhiteSpace(command.Request.Descrizione) ? null : command.Request.Descrizione.Trim(),
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                DataInizio = dataInizio,
                DataFine = dataFine,
                command.Request.Principale,
                command.Request.OrdinePriorita,
                command.Request.IsVerificato,
                command.Request.DataVerifica,
                command.Request.IsPubblico,
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<ContattoDto>(new CommandDefinition(
            byIdSql,
            new { Id = id },
            tx,
            cancellationToken: cancellationToken));

        await tx.CommitAsync(cancellationToken);
        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, ContattoDto? Item)> UpdateAsync(
        UpdateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string existsSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[ContattoUnitaOrganizzativa] c
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = c.UnitaOrganizzativaId
            WHERE c.ContattoId = @ContattoId
              AND u.OrganizzazioneId = @OrganizzazioneId
              AND c.DataCancellazione IS NULL
              AND u.DataCancellazione IS NULL;
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[ContattoUnitaOrganizzativa] c
            WHERE c.ContattoId <> @ContattoId
              AND c.UnitaOrganizzativaId = @UnitaOrganizzativaId
              AND c.TipoContattoId = @TipoContattoId
              AND c.Valore = @Valore
              AND c.DataCancellazione IS NULL
              AND (c.DataInizioValidita IS NULL OR c.DataInizioValidita <= SYSUTCDATETIME())
              AND (c.DataFineValidita IS NULL OR c.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string clearPrincipaleSql = """
            UPDATE [Organizzazioni].[ContattoUnitaOrganizzativa]
            SET Principale = CAST(0 AS bit),
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE UnitaOrganizzativaId = @UnitaOrganizzativaId
              AND ContattoId <> @ContattoId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME())
              AND Principale = CAST(1 AS bit);
            """;

        const string updateSql = """
            UPDATE [Organizzazioni].[ContattoUnitaOrganizzativa]
            SET UnitaOrganizzativaId = @UnitaOrganizzativaId,
                TipoContattoId = @TipoContattoId,
                Valore = @Valore,
                ValoreSecondario = @ValoreSecondario,
                Descrizione = @Descrizione,
                Note = @Note,
                DataInizio = @DataInizio,
                DataFine = @DataFine,
                Principale = @Principale,
                OrdinePriorita = @OrdinePriorita,
                IsVerificato = @IsVerificato,
                DataVerifica = @DataVerifica,
                IsPubblico = @IsPubblico,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE ContattoId = @ContattoId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string byIdSql = """
            SELECT
                c.ContattoId,
                c.UnitaOrganizzativaId,
                c.TipoContattoId,
                c.Valore,
                c.ValoreSecondario,
                c.Descrizione,
                c.Note,
                CAST(c.DataInizio AS datetime2) AS DataInizio,
                CAST(c.DataFine AS datetime2) AS DataFine,
                c.Principale,
                c.OrdinePriorita,
                c.IsVerificato,
                c.DataVerifica,
                c.IsPubblico
            FROM [Organizzazioni].[ContattoUnitaOrganizzativa] c
            WHERE c.ContattoId = @ContattoId
              AND c.DataCancellazione IS NULL
              AND (c.DataInizioValidita IS NULL OR c.DataInizioValidita <= SYSUTCDATETIME())
              AND (c.DataFineValidita IS NULL OR c.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            existsSql,
            new { command.ContattoId, command.OrganizzazioneId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        if (!await UnitBelongsToOrgAsync(connection, command.OrganizzazioneId, command.Request.UnitaOrganizzativaId, cancellationToken))
        {
            return (WriteResult.NotFound, null);
        }

        if (!await TipoContattoExistsAsync(connection, command.Request.TipoContattoId, cancellationToken))
        {
            return (WriteResult.InvalidTipoContatto, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new
            {
                command.ContattoId,
                command.Request.UnitaOrganizzativaId,
                command.Request.TipoContattoId,
                Valore = command.Request.Valore.Trim()
            },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        var dataInizio = (command.Request.DataInizio ?? now).Date;
        var dataFine = command.Request.DataFine?.Date;

        await using var tx = await connection.BeginTransactionAsync(cancellationToken);
        if (command.Request.Principale)
        {
            await connection.ExecuteAsync(new CommandDefinition(
                clearPrincipaleSql,
                new { command.Request.UnitaOrganizzativaId, command.ContattoId, Now = now, ActorInt = actorInt },
                tx,
                cancellationToken: cancellationToken));
        }

        await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new
            {
                command.ContattoId,
                command.Request.UnitaOrganizzativaId,
                command.Request.TipoContattoId,
                Valore = command.Request.Valore.Trim(),
                ValoreSecondario = string.IsNullOrWhiteSpace(command.Request.ValoreSecondario) ? null : command.Request.ValoreSecondario.Trim(),
                Descrizione = string.IsNullOrWhiteSpace(command.Request.Descrizione) ? null : command.Request.Descrizione.Trim(),
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                DataInizio = dataInizio,
                DataFine = dataFine,
                command.Request.Principale,
                command.Request.OrdinePriorita,
                command.Request.IsVerificato,
                command.Request.DataVerifica,
                command.Request.IsPubblico,
                Now = now,
                ActorInt = actorInt
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<ContattoDto>(new CommandDefinition(
            byIdSql,
            new { command.ContattoId },
            tx,
            cancellationToken: cancellationToken));
        await tx.CommitAsync(cancellationToken);

        return (WriteResult.Success, item);
    }

    public static async Task<WriteResult> DeleteAsync(
        DeleteCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string deleteSql = """
            UPDATE c
            SET c.DataCancellazione = @Now,
                c.CancellatoDa = @ActorInt,
                c.DataModifica = @Now,
                c.ModificatoDa = @ActorInt,
                c.DataFineValidita = @Now
            FROM [Organizzazioni].[ContattoUnitaOrganizzativa] c
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = c.UnitaOrganizzativaId
            WHERE c.ContattoId = @ContattoId
              AND u.OrganizzazioneId = @OrganizzazioneId
              AND c.DataCancellazione IS NULL
              AND u.DataCancellazione IS NULL;
            """;

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(
            deleteSql,
            new
            {
                command.ContattoId,
                command.OrganizzazioneId,
                Now = now,
                ActorInt = actorInt
            },
            cancellationToken: cancellationToken));
        return rows == 0 ? WriteResult.NotFound : WriteResult.Success;
    }

    private static async Task<bool> UnitBelongsToOrgAsync(
        System.Data.Common.DbConnection connection,
        int organizzazioneId,
        int unitaOrganizzativaId,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[UnitaOrganizzativa] u
            WHERE u.OrganizzazioneId = @OrganizzazioneId
              AND u.UnitaOrganizzativaId = @UnitaOrganizzativaId
              AND u.DataCancellazione IS NULL
              AND (u.DataInizioValidita IS NULL OR u.DataInizioValidita <= SYSUTCDATETIME())
              AND (u.DataFineValidita IS NULL OR u.DataFineValidita >= SYSUTCDATETIME());
            """;

        var count = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            sql,
            new { OrganizzazioneId = organizzazioneId, UnitaOrganizzativaId = unitaOrganizzativaId },
            cancellationToken: cancellationToken));
        return count > 0;
    }

    private static async Task<bool> TipoContattoExistsAsync(
        System.Data.Common.DbConnection connection,
        int tipoContattoId,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoContatto] t
            WHERE t.TipoContattoId = @TipoContattoId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        var count = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            sql,
            new { TipoContattoId = tipoContattoId },
            cancellationToken: cancellationToken));
        return count > 0;
    }
}
