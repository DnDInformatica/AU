using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediUnita;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFound,
        Duplicate
    }

    public static async Task<IReadOnlyList<SedeUnitaDto>?> ListAsync(
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
                suo.SedeUnitaOrganizzativaId,
                suo.SedeId,
                suo.UnitaOrganizzativaId,
                suo.RuoloOperativo,
                suo.DescrizioneRuolo,
                CAST(suo.DataInizio AS datetime2) AS DataInizio,
                CAST(suo.DataFine AS datetime2) AS DataFine,
                suo.Principale,
                suo.IsTemporanea,
                suo.PercentualeAttivita,
                suo.Note
            FROM [Organizzazioni].[SedeUnitaOrganizzativa] suo
            INNER JOIN [Organizzazioni].[Sede] s ON s.SedeId = suo.SedeId
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = suo.UnitaOrganizzativaId
            WHERE s.OrganizzazioneId = @OrganizzazioneId
              AND u.OrganizzazioneId = @OrganizzazioneId
              AND suo.DataCancellazione IS NULL
              AND s.DataCancellazione IS NULL
              AND u.DataCancellazione IS NULL
              AND (suo.DataInizioValidita IS NULL OR suo.DataInizioValidita <= SYSUTCDATETIME())
              AND (suo.DataFineValidita IS NULL OR suo.DataFineValidita >= SYSUTCDATETIME())
              AND (s.DataInizioValidita IS NULL OR s.DataInizioValidita <= SYSUTCDATETIME())
              AND (s.DataFineValidita IS NULL OR s.DataFineValidita >= SYSUTCDATETIME())
              AND (u.DataInizioValidita IS NULL OR u.DataInizioValidita <= SYSUTCDATETIME())
              AND (u.DataFineValidita IS NULL OR u.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY suo.Principale DESC, suo.SedeUnitaOrganizzativaId DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(orgExistsSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return null;
        }

        var rows = (await connection.QueryAsync<SedeUnitaDto>(
            new CommandDefinition(listSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();
        return rows;
    }

    public static async Task<(WriteResult Result, SedeUnitaDto? Item)> CreateAsync(
        CreateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[SedeUnitaOrganizzativa] suo
            WHERE suo.SedeId = @SedeId
              AND suo.UnitaOrganizzativaId = @UnitaOrganizzativaId
              AND suo.DataCancellazione IS NULL
              AND (suo.DataInizioValidita IS NULL OR suo.DataInizioValidita <= SYSUTCDATETIME())
              AND (suo.DataFineValidita IS NULL OR suo.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string clearPrincipaleSql = """
            UPDATE [Organizzazioni].[SedeUnitaOrganizzativa]
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

            INSERT INTO [Organizzazioni].[SedeUnitaOrganizzativa]
                ([SedeId], [UnitaOrganizzativaId], [RuoloOperativo], [DescrizioneRuolo], [DataInizio], [DataFine], [Principale], [IsTemporanea], [PercentualeAttivita], [Note], [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa], [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.SedeUnitaOrganizzativaId INTO @newIds(Id)
            VALUES
                (@SedeId, @UnitaOrganizzativaId, @RuoloOperativo, @DescrizioneRuolo, @DataInizio, @DataFine, @Principale, @IsTemporanea, @PercentualeAttivita, @Note, @Now, @ActorInt, @Now, @ActorInt, @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                suo.SedeUnitaOrganizzativaId,
                suo.SedeId,
                suo.UnitaOrganizzativaId,
                suo.RuoloOperativo,
                suo.DescrizioneRuolo,
                CAST(suo.DataInizio AS datetime2) AS DataInizio,
                CAST(suo.DataFine AS datetime2) AS DataFine,
                suo.Principale,
                suo.IsTemporanea,
                suo.PercentualeAttivita,
                suo.Note
            FROM [Organizzazioni].[SedeUnitaOrganizzativa] suo
            WHERE suo.SedeUnitaOrganizzativaId = @Id
              AND suo.DataCancellazione IS NULL
              AND (suo.DataInizioValidita IS NULL OR suo.DataInizioValidita <= SYSUTCDATETIME())
              AND (suo.DataFineValidita IS NULL OR suo.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await UnitBelongsToOrgAsync(connection, command.OrganizzazioneId, command.Request.UnitaOrganizzativaId, cancellationToken)
            || !await SedeBelongsToOrgAsync(connection, command.OrganizzazioneId, command.Request.SedeId, cancellationToken))
        {
            return (WriteResult.NotFound, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new
            {
                command.Request.SedeId,
                command.Request.UnitaOrganizzativaId
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
                command.Request.SedeId,
                command.Request.UnitaOrganizzativaId,
                RuoloOperativo = string.IsNullOrWhiteSpace(command.Request.RuoloOperativo) ? null : command.Request.RuoloOperativo.Trim(),
                DescrizioneRuolo = string.IsNullOrWhiteSpace(command.Request.DescrizioneRuolo) ? null : command.Request.DescrizioneRuolo.Trim(),
                DataInizio = dataInizio,
                DataFine = dataFine,
                command.Request.Principale,
                command.Request.IsTemporanea,
                command.Request.PercentualeAttivita,
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<SedeUnitaDto>(new CommandDefinition(
            byIdSql,
            new { Id = id },
            tx,
            cancellationToken: cancellationToken));

        await tx.CommitAsync(cancellationToken);
        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, SedeUnitaDto? Item)> UpdateAsync(
        UpdateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string existsSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[SedeUnitaOrganizzativa] suo
            INNER JOIN [Organizzazioni].[Sede] s ON s.SedeId = suo.SedeId
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = suo.UnitaOrganizzativaId
            WHERE suo.SedeUnitaOrganizzativaId = @SedeUnitaOrganizzativaId
              AND s.OrganizzazioneId = @OrganizzazioneId
              AND u.OrganizzazioneId = @OrganizzazioneId
              AND suo.DataCancellazione IS NULL
              AND s.DataCancellazione IS NULL
              AND u.DataCancellazione IS NULL;
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[SedeUnitaOrganizzativa] suo
            WHERE suo.SedeUnitaOrganizzativaId <> @SedeUnitaOrganizzativaId
              AND suo.SedeId = @SedeId
              AND suo.UnitaOrganizzativaId = @UnitaOrganizzativaId
              AND suo.DataCancellazione IS NULL
              AND (suo.DataInizioValidita IS NULL OR suo.DataInizioValidita <= SYSUTCDATETIME())
              AND (suo.DataFineValidita IS NULL OR suo.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string clearPrincipaleSql = """
            UPDATE [Organizzazioni].[SedeUnitaOrganizzativa]
            SET Principale = CAST(0 AS bit),
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE UnitaOrganizzativaId = @UnitaOrganizzativaId
              AND SedeUnitaOrganizzativaId <> @SedeUnitaOrganizzativaId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME())
              AND Principale = CAST(1 AS bit);
            """;

        const string updateSql = """
            UPDATE [Organizzazioni].[SedeUnitaOrganizzativa]
            SET SedeId = @SedeId,
                UnitaOrganizzativaId = @UnitaOrganizzativaId,
                RuoloOperativo = @RuoloOperativo,
                DescrizioneRuolo = @DescrizioneRuolo,
                DataInizio = @DataInizio,
                DataFine = @DataFine,
                Principale = @Principale,
                IsTemporanea = @IsTemporanea,
                PercentualeAttivita = @PercentualeAttivita,
                Note = @Note,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE SedeUnitaOrganizzativaId = @SedeUnitaOrganizzativaId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string byIdSql = """
            SELECT
                suo.SedeUnitaOrganizzativaId,
                suo.SedeId,
                suo.UnitaOrganizzativaId,
                suo.RuoloOperativo,
                suo.DescrizioneRuolo,
                CAST(suo.DataInizio AS datetime2) AS DataInizio,
                CAST(suo.DataFine AS datetime2) AS DataFine,
                suo.Principale,
                suo.IsTemporanea,
                suo.PercentualeAttivita,
                suo.Note
            FROM [Organizzazioni].[SedeUnitaOrganizzativa] suo
            WHERE suo.SedeUnitaOrganizzativaId = @SedeUnitaOrganizzativaId
              AND suo.DataCancellazione IS NULL
              AND (suo.DataInizioValidita IS NULL OR suo.DataInizioValidita <= SYSUTCDATETIME())
              AND (suo.DataFineValidita IS NULL OR suo.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            existsSql,
            new { command.SedeUnitaOrganizzativaId, command.OrganizzazioneId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        if (!await UnitBelongsToOrgAsync(connection, command.OrganizzazioneId, command.Request.UnitaOrganizzativaId, cancellationToken)
            || !await SedeBelongsToOrgAsync(connection, command.OrganizzazioneId, command.Request.SedeId, cancellationToken))
        {
            return (WriteResult.NotFound, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new
            {
                command.SedeUnitaOrganizzativaId,
                command.Request.SedeId,
                command.Request.UnitaOrganizzativaId
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
                new { command.Request.UnitaOrganizzativaId, command.SedeUnitaOrganizzativaId, Now = now, ActorInt = actorInt },
                tx,
                cancellationToken: cancellationToken));
        }

        await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new
            {
                command.SedeUnitaOrganizzativaId,
                command.Request.SedeId,
                command.Request.UnitaOrganizzativaId,
                RuoloOperativo = string.IsNullOrWhiteSpace(command.Request.RuoloOperativo) ? null : command.Request.RuoloOperativo.Trim(),
                DescrizioneRuolo = string.IsNullOrWhiteSpace(command.Request.DescrizioneRuolo) ? null : command.Request.DescrizioneRuolo.Trim(),
                DataInizio = dataInizio,
                DataFine = dataFine,
                command.Request.Principale,
                command.Request.IsTemporanea,
                command.Request.PercentualeAttivita,
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                Now = now,
                ActorInt = actorInt
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<SedeUnitaDto>(new CommandDefinition(
            byIdSql,
            new { command.SedeUnitaOrganizzativaId },
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
            UPDATE suo
            SET suo.DataCancellazione = @Now,
                suo.CancellatoDa = @ActorInt,
                suo.DataModifica = @Now,
                suo.ModificatoDa = @ActorInt,
                suo.DataFineValidita = @Now
            FROM [Organizzazioni].[SedeUnitaOrganizzativa] suo
            INNER JOIN [Organizzazioni].[Sede] s ON s.SedeId = suo.SedeId
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = suo.UnitaOrganizzativaId
            WHERE suo.SedeUnitaOrganizzativaId = @SedeUnitaOrganizzativaId
              AND s.OrganizzazioneId = @OrganizzazioneId
              AND u.OrganizzazioneId = @OrganizzazioneId
              AND suo.DataCancellazione IS NULL
              AND s.DataCancellazione IS NULL
              AND u.DataCancellazione IS NULL;
            """;

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(
            deleteSql,
            new
            {
                command.SedeUnitaOrganizzativaId,
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

    private static async Task<bool> SedeBelongsToOrgAsync(
        System.Data.Common.DbConnection connection,
        int organizzazioneId,
        int sedeId,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[Sede] s
            WHERE s.OrganizzazioneId = @OrganizzazioneId
              AND s.SedeId = @SedeId
              AND s.DataCancellazione IS NULL
              AND (s.DataInizioValidita IS NULL OR s.DataInizioValidita <= SYSUTCDATETIME())
              AND (s.DataFineValidita IS NULL OR s.DataFineValidita >= SYSUTCDATETIME());
            """;

        var count = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            sql,
            new { OrganizzazioneId = organizzazioneId, SedeId = sedeId },
            cancellationToken: cancellationToken));
        return count > 0;
    }
}
