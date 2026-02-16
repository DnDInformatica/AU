using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Indirizzi;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFoundPersona,
        NotFound,
        Duplicate,
        InvalidTipoIndirizzo
    }

    public static async Task<IReadOnlyList<TipoIndirizzoLookupItem>> LookupsAsync(
        LookupsCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                t.TipoIndirizzoId AS Id,
                t.Codice AS Code,
                t.Descrizione AS [Description]
            FROM [Tipologica].[TipoIndirizzo] t
            WHERE t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY t.Descrizione ASC, t.Codice ASC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = (await connection.QueryAsync<TipoIndirizzoLookupItem>(
            new CommandDefinition(sql, cancellationToken: cancellationToken))).ToList();
        return rows;
    }

    public static async Task<IReadOnlyList<PersonaIndirizzoDto>?> ListAsync(
        ListCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string personaExistsSql = """
            SELECT COUNT(1)
            FROM [Persone].[Persona] p
            WHERE p.PersonaId = @PersonaId
              AND p.DataCancellazione IS NULL
              AND (p.DataInizioValidita IS NULL OR p.DataInizioValidita <= SYSUTCDATETIME())
              AND (p.DataFineValidita IS NULL OR p.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string listSql = """
            SELECT
                pi.PersonaIndirizzoId,
                pi.PersonaId,
                pi.IndirizzoId,
                pi.TipoIndirizzoId,
                pi.Principale,
                pi.Attivo,
                pi.DataCancellazione
            FROM [Persone].[PersonaIndirizzo] pi
            WHERE pi.PersonaId = @PersonaId
              AND (@IncludeDeleted = 1 OR pi.DataCancellazione IS NULL)
              AND (pi.DataInizioValidita IS NULL OR pi.DataInizioValidita <= SYSUTCDATETIME())
              AND (pi.DataFineValidita IS NULL OR pi.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY pi.Principale DESC, pi.PersonaIndirizzoId DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            personaExistsSql,
            new { command.PersonaId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return null;
        }

        var rows = (await connection.QueryAsync<PersonaIndirizzoDto>(new CommandDefinition(
            listSql,
            new { command.PersonaId, IncludeDeleted = command.IncludeDeleted ? 1 : 0 },
            cancellationToken: cancellationToken))).ToList();

        return rows;
    }

    public static async Task<(WriteResult Result, PersonaIndirizzoDto? Item)> CreateAsync(
        CreateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string personaExistsSql = """
            SELECT COUNT(1)
            FROM [Persone].[Persona] p
            WHERE p.PersonaId = @PersonaId
              AND p.DataCancellazione IS NULL
              AND (p.DataInizioValidita IS NULL OR p.DataInizioValidita <= SYSUTCDATETIME())
              AND (p.DataFineValidita IS NULL OR p.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string tipoExistsSql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoIndirizzo] t
            WHERE t.TipoIndirizzoId = @TipoIndirizzoId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Persone].[PersonaIndirizzo] pi
            WHERE pi.PersonaId = @PersonaId
              AND pi.IndirizzoId = @IndirizzoId
              AND pi.DataCancellazione IS NULL
              AND (pi.DataInizioValidita IS NULL OR pi.DataInizioValidita <= SYSUTCDATETIME())
              AND (pi.DataFineValidita IS NULL OR pi.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string clearPrincipaleSql = """
            UPDATE [Persone].[PersonaIndirizzo]
            SET Principale = CAST(0 AS bit),
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE PersonaId = @PersonaId
              AND DataCancellazione IS NULL
              AND Principale = CAST(1 AS bit)
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string insertSql = """
            DECLARE @newIds TABLE (Id int);

            INSERT INTO [Persone].[PersonaIndirizzo]
                ([PersonaId], [IndirizzoId], [TipoIndirizzoId], [Principale], [Attivo], [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa], [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.PersonaIndirizzoId INTO @newIds(Id)
            VALUES
                (@PersonaId, @IndirizzoId, @TipoIndirizzoId, @Principale, @Attivo, @Now, @ActorInt, @Now, @ActorInt, @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                pi.PersonaIndirizzoId,
                pi.PersonaId,
                pi.IndirizzoId,
                pi.TipoIndirizzoId,
                pi.Principale,
                pi.Attivo,
                pi.DataCancellazione
            FROM [Persone].[PersonaIndirizzo] pi
            WHERE pi.PersonaIndirizzoId = @PersonaIndirizzoId
              AND pi.PersonaId = @PersonaId
              AND pi.DataCancellazione IS NULL
              AND (pi.DataInizioValidita IS NULL OR pi.DataInizioValidita <= SYSUTCDATETIME())
              AND (pi.DataFineValidita IS NULL OR pi.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var personaExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            personaExistsSql,
            new { command.PersonaId },
            cancellationToken: cancellationToken));
        if (personaExists == 0)
        {
            return (WriteResult.NotFoundPersona, null);
        }

        var tipoExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            tipoExistsSql,
            new { command.Request.TipoIndirizzoId },
            cancellationToken: cancellationToken));
        if (tipoExists == 0)
        {
            return (WriteResult.InvalidTipoIndirizzo, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.PersonaId, command.Request.IndirizzoId },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);
        var actorRaw = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actorRaw, out var parsedActor) ? parsedActor : 0;

        await using var tx = await connection.BeginTransactionAsync(cancellationToken);
        if (command.Request.Principale)
        {
            await connection.ExecuteAsync(new CommandDefinition(
                clearPrincipaleSql,
                new { command.PersonaId, Now = now, ActorInt = actorInt },
                tx,
                cancellationToken: cancellationToken));
        }

        var newId = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            insertSql,
            new
            {
                command.PersonaId,
                command.Request.IndirizzoId,
                command.Request.TipoIndirizzoId,
                command.Request.Principale,
                command.Request.Attivo,
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<PersonaIndirizzoDto>(new CommandDefinition(
            byIdSql,
            new { PersonaIndirizzoId = newId, command.PersonaId },
            tx,
            cancellationToken: cancellationToken));

        await tx.CommitAsync(cancellationToken);
        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, PersonaIndirizzoDto? Item)> UpdateAsync(
        UpdateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string personaExistsSql = """
            SELECT COUNT(1)
            FROM [Persone].[Persona] p
            WHERE p.PersonaId = @PersonaId
              AND p.DataCancellazione IS NULL
              AND (p.DataInizioValidita IS NULL OR p.DataInizioValidita <= SYSUTCDATETIME())
              AND (p.DataFineValidita IS NULL OR p.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string existsSql = """
            SELECT COUNT(1)
            FROM [Persone].[PersonaIndirizzo] pi
            WHERE pi.PersonaIndirizzoId = @PersonaIndirizzoId
              AND pi.PersonaId = @PersonaId
              AND pi.DataCancellazione IS NULL;
            """;

        const string tipoExistsSql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoIndirizzo] t
            WHERE t.TipoIndirizzoId = @TipoIndirizzoId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Persone].[PersonaIndirizzo] pi
            WHERE pi.PersonaIndirizzoId <> @PersonaIndirizzoId
              AND pi.PersonaId = @PersonaId
              AND pi.IndirizzoId = @IndirizzoId
              AND pi.DataCancellazione IS NULL
              AND (pi.DataInizioValidita IS NULL OR pi.DataInizioValidita <= SYSUTCDATETIME())
              AND (pi.DataFineValidita IS NULL OR pi.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string clearPrincipaleSql = """
            UPDATE [Persone].[PersonaIndirizzo]
            SET Principale = CAST(0 AS bit),
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE PersonaId = @PersonaId
              AND PersonaIndirizzoId <> @PersonaIndirizzoId
              AND DataCancellazione IS NULL
              AND Principale = CAST(1 AS bit)
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string updateSql = """
            UPDATE [Persone].[PersonaIndirizzo]
            SET IndirizzoId = @IndirizzoId,
                TipoIndirizzoId = @TipoIndirizzoId,
                Principale = @Principale,
                Attivo = @Attivo,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE PersonaIndirizzoId = @PersonaIndirizzoId
              AND PersonaId = @PersonaId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string byIdSql = """
            SELECT
                pi.PersonaIndirizzoId,
                pi.PersonaId,
                pi.IndirizzoId,
                pi.TipoIndirizzoId,
                pi.Principale,
                pi.Attivo,
                pi.DataCancellazione
            FROM [Persone].[PersonaIndirizzo] pi
            WHERE pi.PersonaIndirizzoId = @PersonaIndirizzoId
              AND pi.PersonaId = @PersonaId
              AND pi.DataCancellazione IS NULL
              AND (pi.DataInizioValidita IS NULL OR pi.DataInizioValidita <= SYSUTCDATETIME())
              AND (pi.DataFineValidita IS NULL OR pi.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var personaExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            personaExistsSql,
            new { command.PersonaId },
            cancellationToken: cancellationToken));
        if (personaExists == 0)
        {
            return (WriteResult.NotFoundPersona, null);
        }

        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            existsSql,
            new { command.PersonaId, command.PersonaIndirizzoId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        var tipoExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            tipoExistsSql,
            new { command.Request.TipoIndirizzoId },
            cancellationToken: cancellationToken));
        if (tipoExists == 0)
        {
            return (WriteResult.InvalidTipoIndirizzo, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.PersonaId, command.PersonaIndirizzoId, command.Request.IndirizzoId },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var actorRaw = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actorRaw, out var parsedActor) ? parsedActor : 0;

        await using var tx = await connection.BeginTransactionAsync(cancellationToken);
        if (command.Request.Principale)
        {
            await connection.ExecuteAsync(new CommandDefinition(
                clearPrincipaleSql,
                new { command.PersonaId, command.PersonaIndirizzoId, Now = now, ActorInt = actorInt },
                tx,
                cancellationToken: cancellationToken));
        }

        await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new
            {
                command.PersonaId,
                command.PersonaIndirizzoId,
                command.Request.IndirizzoId,
                command.Request.TipoIndirizzoId,
                command.Request.Principale,
                command.Request.Attivo,
                Now = now,
                ActorInt = actorInt
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<PersonaIndirizzoDto>(new CommandDefinition(
            byIdSql,
            new { command.PersonaId, command.PersonaIndirizzoId },
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
        const string personaExistsSql = """
            SELECT COUNT(1)
            FROM [Persone].[Persona] p
            WHERE p.PersonaId = @PersonaId
              AND p.DataCancellazione IS NULL
              AND (p.DataInizioValidita IS NULL OR p.DataInizioValidita <= SYSUTCDATETIME())
              AND (p.DataFineValidita IS NULL OR p.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string deleteSql = """
            UPDATE [Persone].[PersonaIndirizzo]
            SET DataCancellazione = @Now,
                CancellatoDa = @ActorInt,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE PersonaIndirizzoId = @PersonaIndirizzoId
              AND PersonaId = @PersonaId
              AND DataCancellazione IS NULL;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var personaExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            personaExistsSql,
            new { command.PersonaId },
            cancellationToken: cancellationToken));
        if (personaExists == 0)
        {
            return WriteResult.NotFoundPersona;
        }

        var now = DateTime.UtcNow;
        var actorRaw = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actorRaw, out var parsedActor) ? parsedActor : 0;

        var rows = await connection.ExecuteAsync(new CommandDefinition(
            deleteSql,
            new { command.PersonaId, command.PersonaIndirizzoId, Now = now, ActorInt = actorInt },
            cancellationToken: cancellationToken));

        return rows == 0 ? WriteResult.NotFound : WriteResult.Success;
    }
}

