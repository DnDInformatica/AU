using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaFunzioni;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFound,
        Duplicate,
        InvalidTipoFunzione
    }

    public static async Task<IReadOnlyList<UnitaFunzioneDto>?> ListAsync(
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
                f.UnitaOrganizzativaFunzioneId,
                f.UnitaOrganizzativaId,
                f.TipoFunzioneUnitaLocaleId,
                t.Descrizione AS TipoFunzioneDescrizione,
                f.Principale,
                f.Note
            FROM [Organizzazioni].[UnitaOrganizzativaFunzione] f
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = f.UnitaOrganizzativaId
            LEFT JOIN [Tipologica].[TipoFunzioneUnitaLocale] t ON t.TipoFunzioneUnitaLocaleId = f.TipoFunzioneUnitaLocaleId
            WHERE u.OrganizzazioneId = @OrganizzazioneId
              AND f.DataCancellazione IS NULL
              AND u.DataCancellazione IS NULL
              AND (f.DataInizioValidita IS NULL OR f.DataInizioValidita <= SYSUTCDATETIME())
              AND (f.DataFineValidita IS NULL OR f.DataFineValidita >= SYSUTCDATETIME())
              AND (u.DataInizioValidita IS NULL OR u.DataInizioValidita <= SYSUTCDATETIME())
              AND (u.DataFineValidita IS NULL OR u.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY f.UnitaOrganizzativaFunzioneId DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(orgExistsSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return null;
        }

        var rows = (await connection.QueryAsync<UnitaFunzioneDto>(
            new CommandDefinition(listSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();
        return rows;
    }

    public static async Task<(WriteResult Result, UnitaFunzioneDto? Item)> CreateAsync(
        CreateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[UnitaOrganizzativaFunzione] f
            WHERE f.UnitaOrganizzativaId = @UnitaOrganizzativaId
              AND f.TipoFunzioneUnitaLocaleId = @TipoFunzioneUnitaLocaleId
              AND f.DataCancellazione IS NULL
              AND (f.DataInizioValidita IS NULL OR f.DataInizioValidita <= SYSUTCDATETIME())
              AND (f.DataFineValidita IS NULL OR f.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string clearPrincipaleSql = """
            UPDATE [Organizzazioni].[UnitaOrganizzativaFunzione]
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

            INSERT INTO [Organizzazioni].[UnitaOrganizzativaFunzione]
                ([UnitaOrganizzativaId], [TipoFunzioneUnitaLocaleId], [Principale], [Note], [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa], [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.UnitaOrganizzativaFunzioneId INTO @newIds(Id)
            VALUES
                (@UnitaOrganizzativaId, @TipoFunzioneUnitaLocaleId, @Principale, @Note, @Now, @ActorInt, @Now, @ActorInt, @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                f.UnitaOrganizzativaFunzioneId,
                f.UnitaOrganizzativaId,
                f.TipoFunzioneUnitaLocaleId,
                t.Descrizione AS TipoFunzioneDescrizione,
                f.Principale,
                f.Note
            FROM [Organizzazioni].[UnitaOrganizzativaFunzione] f
            LEFT JOIN [Tipologica].[TipoFunzioneUnitaLocale] t ON t.TipoFunzioneUnitaLocaleId = f.TipoFunzioneUnitaLocaleId
            WHERE f.UnitaOrganizzativaFunzioneId = @Id
              AND f.DataCancellazione IS NULL
              AND (f.DataInizioValidita IS NULL OR f.DataInizioValidita <= SYSUTCDATETIME())
              AND (f.DataFineValidita IS NULL OR f.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await UnitBelongsToOrgAsync(connection, command.OrganizzazioneId, command.Request.UnitaOrganizzativaId, cancellationToken))
        {
            return (WriteResult.NotFound, null);
        }

        if (!await TipoFunzioneExistsAsync(connection, command.Request.TipoFunzioneUnitaLocaleId, cancellationToken))
        {
            return (WriteResult.InvalidTipoFunzione, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new
            {
                command.Request.UnitaOrganizzativaId,
                command.Request.TipoFunzioneUnitaLocaleId
            },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);

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
                command.Request.TipoFunzioneUnitaLocaleId,
                command.Request.Principale,
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<UnitaFunzioneDto>(new CommandDefinition(
            byIdSql,
            new { Id = id },
            tx,
            cancellationToken: cancellationToken));

        await tx.CommitAsync(cancellationToken);
        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, UnitaFunzioneDto? Item)> UpdateAsync(
        UpdateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string existsSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[UnitaOrganizzativaFunzione] f
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = f.UnitaOrganizzativaId
            WHERE f.UnitaOrganizzativaFunzioneId = @UnitaOrganizzativaFunzioneId
              AND u.OrganizzazioneId = @OrganizzazioneId
              AND f.DataCancellazione IS NULL
              AND u.DataCancellazione IS NULL;
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[UnitaOrganizzativaFunzione] f
            WHERE f.UnitaOrganizzativaFunzioneId <> @UnitaOrganizzativaFunzioneId
              AND f.UnitaOrganizzativaId = @UnitaOrganizzativaId
              AND f.TipoFunzioneUnitaLocaleId = @TipoFunzioneUnitaLocaleId
              AND f.DataCancellazione IS NULL
              AND (f.DataInizioValidita IS NULL OR f.DataInizioValidita <= SYSUTCDATETIME())
              AND (f.DataFineValidita IS NULL OR f.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string clearPrincipaleSql = """
            UPDATE [Organizzazioni].[UnitaOrganizzativaFunzione]
            SET Principale = CAST(0 AS bit),
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE UnitaOrganizzativaId = @UnitaOrganizzativaId
              AND UnitaOrganizzativaFunzioneId <> @UnitaOrganizzativaFunzioneId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME())
              AND Principale = CAST(1 AS bit);
            """;

        const string updateSql = """
            UPDATE [Organizzazioni].[UnitaOrganizzativaFunzione]
            SET UnitaOrganizzativaId = @UnitaOrganizzativaId,
                TipoFunzioneUnitaLocaleId = @TipoFunzioneUnitaLocaleId,
                Principale = @Principale,
                Note = @Note,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE UnitaOrganizzativaFunzioneId = @UnitaOrganizzativaFunzioneId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string byIdSql = """
            SELECT
                f.UnitaOrganizzativaFunzioneId,
                f.UnitaOrganizzativaId,
                f.TipoFunzioneUnitaLocaleId,
                t.Descrizione AS TipoFunzioneDescrizione,
                f.Principale,
                f.Note
            FROM [Organizzazioni].[UnitaOrganizzativaFunzione] f
            LEFT JOIN [Tipologica].[TipoFunzioneUnitaLocale] t ON t.TipoFunzioneUnitaLocaleId = f.TipoFunzioneUnitaLocaleId
            WHERE f.UnitaOrganizzativaFunzioneId = @UnitaOrganizzativaFunzioneId
              AND f.DataCancellazione IS NULL
              AND (f.DataInizioValidita IS NULL OR f.DataInizioValidita <= SYSUTCDATETIME())
              AND (f.DataFineValidita IS NULL OR f.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            existsSql,
            new { command.UnitaOrganizzativaFunzioneId, command.OrganizzazioneId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        if (!await UnitBelongsToOrgAsync(connection, command.OrganizzazioneId, command.Request.UnitaOrganizzativaId, cancellationToken))
        {
            return (WriteResult.NotFound, null);
        }

        if (!await TipoFunzioneExistsAsync(connection, command.Request.TipoFunzioneUnitaLocaleId, cancellationToken))
        {
            return (WriteResult.InvalidTipoFunzione, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new
            {
                command.UnitaOrganizzativaFunzioneId,
                command.Request.UnitaOrganizzativaId,
                command.Request.TipoFunzioneUnitaLocaleId
            },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;

        await using var tx = await connection.BeginTransactionAsync(cancellationToken);
        if (command.Request.Principale)
        {
            await connection.ExecuteAsync(new CommandDefinition(
                clearPrincipaleSql,
                new { command.Request.UnitaOrganizzativaId, command.UnitaOrganizzativaFunzioneId, Now = now, ActorInt = actorInt },
                tx,
                cancellationToken: cancellationToken));
        }

        await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new
            {
                command.UnitaOrganizzativaFunzioneId,
                command.Request.UnitaOrganizzativaId,
                command.Request.TipoFunzioneUnitaLocaleId,
                command.Request.Principale,
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                Now = now,
                ActorInt = actorInt
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<UnitaFunzioneDto>(new CommandDefinition(
            byIdSql,
            new { command.UnitaOrganizzativaFunzioneId },
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
            UPDATE f
            SET f.DataCancellazione = @Now,
                f.CancellatoDa = @ActorInt,
                f.DataModifica = @Now,
                f.ModificatoDa = @ActorInt,
                f.DataFineValidita = @Now
            FROM [Organizzazioni].[UnitaOrganizzativaFunzione] f
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = f.UnitaOrganizzativaId
            WHERE f.UnitaOrganizzativaFunzioneId = @UnitaOrganizzativaFunzioneId
              AND u.OrganizzazioneId = @OrganizzazioneId
              AND f.DataCancellazione IS NULL
              AND u.DataCancellazione IS NULL;
            """;

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(
            deleteSql,
            new
            {
                command.UnitaOrganizzativaFunzioneId,
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

    private static async Task<bool> TipoFunzioneExistsAsync(
        System.Data.Common.DbConnection connection,
        int tipoFunzioneId,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoFunzioneUnitaLocale] t
            WHERE t.TipoFunzioneUnitaLocaleId = @TipoFunzioneId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        var count = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            sql,
            new { TipoFunzioneId = tipoFunzioneId },
            cancellationToken: cancellationToken));
        return count > 0;
    }
}

