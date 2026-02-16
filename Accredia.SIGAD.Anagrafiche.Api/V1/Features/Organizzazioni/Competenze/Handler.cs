using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Competenze;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFound,
        Duplicate
    }

    public static async Task<IReadOnlyList<CompetenzaDto>> ListAsync(
        ListCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string listSql = """
            SELECT
                c.CompetenzaId,
                c.CodiceCompetenza,
                c.DescrizioneCompetenza,
                c.Principale,
                c.Attivo,
                c.Verificato
            FROM [Organizzazioni].[Competenza] c
            WHERE c.DataCancellazione IS NULL
              AND c.Cancellato = CAST(0 AS bit)
              AND (c.DataInizioValidita IS NULL OR c.DataInizioValidita <= SYSUTCDATETIME())
              AND (c.DataFineValidita IS NULL OR c.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY c.CodiceCompetenza ASC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = (await connection.QueryAsync<CompetenzaDto>(
            new CommandDefinition(listSql, cancellationToken: cancellationToken))).ToList();
        return rows;
    }

    public static async Task<(WriteResult Result, CompetenzaDto? Item)> CreateAsync(
        CreateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[Competenza] c
            WHERE c.CodiceCompetenza = @CodiceCompetenza
              AND c.DataCancellazione IS NULL
              AND c.Cancellato = CAST(0 AS bit)
              AND (c.DataInizioValidita IS NULL OR c.DataInizioValidita <= SYSUTCDATETIME())
              AND (c.DataFineValidita IS NULL OR c.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string clearPrincipaleSql = """
            UPDATE [Organizzazioni].[Competenza]
            SET Principale = CAST(0 AS bit),
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE DataCancellazione IS NULL
              AND Cancellato = CAST(0 AS bit)
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME())
              AND Principale = CAST(1 AS bit);
            """;

        const string insertSql = """
            DECLARE @newIds TABLE (Id int);

            INSERT INTO [Organizzazioni].[Competenza]
                ([CodiceCompetenza], [DescrizioneCompetenza], [Principale], [Attivo], [Cancellato], [Verificato], [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa], [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.CompetenzaId INTO @newIds(Id)
            VALUES
                (@CodiceCompetenza, @DescrizioneCompetenza, @Principale, @Attivo, CAST(0 AS bit), @Verificato, @Now, @ActorInt, @Now, @ActorInt, @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                c.CompetenzaId,
                c.CodiceCompetenza,
                c.DescrizioneCompetenza,
                c.Principale,
                c.Attivo,
                c.Verificato
            FROM [Organizzazioni].[Competenza] c
            WHERE c.CompetenzaId = @Id
              AND c.DataCancellazione IS NULL
              AND c.Cancellato = CAST(0 AS bit)
              AND (c.DataInizioValidita IS NULL OR c.DataInizioValidita <= SYSUTCDATETIME())
              AND (c.DataFineValidita IS NULL OR c.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { CodiceCompetenza = command.Request.CodiceCompetenza.Trim() },
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
                new { Now = now, ActorInt = actorInt },
                tx,
                cancellationToken: cancellationToken));
        }

        var id = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            insertSql,
            new
            {
                CodiceCompetenza = command.Request.CodiceCompetenza.Trim(),
                DescrizioneCompetenza = string.IsNullOrWhiteSpace(command.Request.DescrizioneCompetenza) ? null : command.Request.DescrizioneCompetenza.Trim(),
                command.Request.Principale,
                command.Request.Attivo,
                command.Request.Verificato,
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<CompetenzaDto>(new CommandDefinition(
            byIdSql,
            new { Id = id },
            tx,
            cancellationToken: cancellationToken));
        await tx.CommitAsync(cancellationToken);

        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, CompetenzaDto? Item)> UpdateAsync(
        UpdateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string existsSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[Competenza] c
            WHERE c.CompetenzaId = @CompetenzaId
              AND c.DataCancellazione IS NULL
              AND c.Cancellato = CAST(0 AS bit);
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[Competenza] c
            WHERE c.CompetenzaId <> @CompetenzaId
              AND c.CodiceCompetenza = @CodiceCompetenza
              AND c.DataCancellazione IS NULL
              AND c.Cancellato = CAST(0 AS bit)
              AND (c.DataInizioValidita IS NULL OR c.DataInizioValidita <= SYSUTCDATETIME())
              AND (c.DataFineValidita IS NULL OR c.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string clearPrincipaleSql = """
            UPDATE [Organizzazioni].[Competenza]
            SET Principale = CAST(0 AS bit),
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE CompetenzaId <> @CompetenzaId
              AND DataCancellazione IS NULL
              AND Cancellato = CAST(0 AS bit)
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME())
              AND Principale = CAST(1 AS bit);
            """;

        const string updateSql = """
            UPDATE [Organizzazioni].[Competenza]
            SET CodiceCompetenza = @CodiceCompetenza,
                DescrizioneCompetenza = @DescrizioneCompetenza,
                Principale = @Principale,
                Attivo = @Attivo,
                Verificato = @Verificato,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE CompetenzaId = @CompetenzaId
              AND DataCancellazione IS NULL
              AND Cancellato = CAST(0 AS bit)
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string byIdSql = """
            SELECT
                c.CompetenzaId,
                c.CodiceCompetenza,
                c.DescrizioneCompetenza,
                c.Principale,
                c.Attivo,
                c.Verificato
            FROM [Organizzazioni].[Competenza] c
            WHERE c.CompetenzaId = @CompetenzaId
              AND c.DataCancellazione IS NULL
              AND c.Cancellato = CAST(0 AS bit)
              AND (c.DataInizioValidita IS NULL OR c.DataInizioValidita <= SYSUTCDATETIME())
              AND (c.DataFineValidita IS NULL OR c.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            existsSql,
            new { command.CompetenzaId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.CompetenzaId, CodiceCompetenza = command.Request.CodiceCompetenza.Trim() },
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
                new { command.CompetenzaId, Now = now, ActorInt = actorInt },
                tx,
                cancellationToken: cancellationToken));
        }

        await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new
            {
                command.CompetenzaId,
                CodiceCompetenza = command.Request.CodiceCompetenza.Trim(),
                DescrizioneCompetenza = string.IsNullOrWhiteSpace(command.Request.DescrizioneCompetenza) ? null : command.Request.DescrizioneCompetenza.Trim(),
                command.Request.Principale,
                command.Request.Attivo,
                command.Request.Verificato,
                Now = now,
                ActorInt = actorInt
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<CompetenzaDto>(new CommandDefinition(
            byIdSql,
            new { command.CompetenzaId },
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
            UPDATE [Organizzazioni].[Competenza]
            SET Cancellato = CAST(1 AS bit),
                DataCancellazione = @Now,
                CancellatoDa = @ActorInt,
                DataModifica = @Now,
                ModificatoDa = @ActorInt,
                DataFineValidita = @Now
            WHERE CompetenzaId = @CompetenzaId
              AND DataCancellazione IS NULL
              AND Cancellato = CAST(0 AS bit);
            """;

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(
            deleteSql,
            new { command.CompetenzaId, Now = now, ActorInt = actorInt },
            cancellationToken: cancellationToken));
        return rows == 0 ? WriteResult.NotFound : WriteResult.Success;
    }
}
