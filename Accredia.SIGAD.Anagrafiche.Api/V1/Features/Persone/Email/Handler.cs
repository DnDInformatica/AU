using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Email;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFoundPersona,
        NotFound,
        Duplicate,
        InvalidTipoEmail
    }

    public static async Task<IReadOnlyList<TipoEmailLookupItem>> LookupsAsync(
        LookupsCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                t.TipoEmailId AS Id,
                t.Codice AS Code,
                t.Descrizione AS [Description]
            FROM [Tipologica].[TipoEmail] t
            WHERE t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY t.Descrizione ASC, t.Codice ASC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = (await connection.QueryAsync<TipoEmailLookupItem>(
            new CommandDefinition(sql, cancellationToken: cancellationToken))).ToList();
        return rows;
    }

    public static async Task<IReadOnlyList<PersonaEmailDto>?> ListAsync(
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
                pe.PersonaEmailId,
                pe.PersonaId,
                pe.TipoEmailId,
                pe.Email,
                pe.Principale,
                pe.Verificata,
                pe.DataVerifica,
                pe.DataCancellazione
            FROM [Persone].[PersonaEmail] pe
            WHERE pe.PersonaId = @PersonaId
              AND (@IncludeDeleted = 1 OR pe.DataCancellazione IS NULL)
              AND (pe.DataInizioValidita IS NULL OR pe.DataInizioValidita <= SYSUTCDATETIME())
              AND (pe.DataFineValidita IS NULL OR pe.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY pe.Principale DESC, pe.PersonaEmailId DESC;
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

        var rows = (await connection.QueryAsync<PersonaEmailDto>(new CommandDefinition(
            listSql,
            new { command.PersonaId, IncludeDeleted = command.IncludeDeleted ? 1 : 0 },
            cancellationToken: cancellationToken))).ToList();

        return rows;
    }

    public static async Task<(WriteResult Result, PersonaEmailDto? Item)> CreateAsync(
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
            FROM [Tipologica].[TipoEmail] t
            WHERE t.TipoEmailId = @TipoEmailId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Persone].[PersonaEmail] pe
            WHERE pe.PersonaId = @PersonaId
              AND pe.Email = @Email
              AND pe.DataCancellazione IS NULL
              AND (pe.DataInizioValidita IS NULL OR pe.DataInizioValidita <= SYSUTCDATETIME())
              AND (pe.DataFineValidita IS NULL OR pe.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string clearPrincipaleSql = """
            UPDATE [Persone].[PersonaEmail]
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

            INSERT INTO [Persone].[PersonaEmail]
                ([PersonaId], [TipoEmailId], [Email], [Principale], [Verificata], [DataVerifica], [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa], [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.PersonaEmailId INTO @newIds(Id)
            VALUES
                (@PersonaId, @TipoEmailId, @Email, @Principale, @Verificata, @DataVerifica, @Now, @ActorInt, @Now, @ActorInt, @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                pe.PersonaEmailId,
                pe.PersonaId,
                pe.TipoEmailId,
                pe.Email,
                pe.Principale,
                pe.Verificata,
                pe.DataVerifica,
                pe.DataCancellazione
            FROM [Persone].[PersonaEmail] pe
            WHERE pe.PersonaEmailId = @PersonaEmailId
              AND pe.PersonaId = @PersonaId
              AND pe.DataCancellazione IS NULL
              AND (pe.DataInizioValidita IS NULL OR pe.DataInizioValidita <= SYSUTCDATETIME())
              AND (pe.DataFineValidita IS NULL OR pe.DataFineValidita >= SYSUTCDATETIME());
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
            new { command.Request.TipoEmailId },
            cancellationToken: cancellationToken));
        if (tipoExists == 0)
        {
            return (WriteResult.InvalidTipoEmail, null);
        }

        var email = command.Request.Email.Trim();
        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.PersonaId, Email = email },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);
        var actorRaw = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actorRaw, out var parsedActor) ? parsedActor : 0;

        DateTime? dataVerifica = command.Request.Verificata
            ? command.Request.DataVerifica ?? now
            : null;

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
                command.Request.TipoEmailId,
                Email = email,
                command.Request.Principale,
                command.Request.Verificata,
                DataVerifica = dataVerifica,
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<PersonaEmailDto>(new CommandDefinition(
            byIdSql,
            new { PersonaEmailId = newId, command.PersonaId },
            tx,
            cancellationToken: cancellationToken));

        await tx.CommitAsync(cancellationToken);
        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, PersonaEmailDto? Item)> UpdateAsync(
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
            FROM [Persone].[PersonaEmail] pe
            WHERE pe.PersonaEmailId = @PersonaEmailId
              AND pe.PersonaId = @PersonaId
              AND pe.DataCancellazione IS NULL;
            """;

        const string tipoExistsSql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoEmail] t
            WHERE t.TipoEmailId = @TipoEmailId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Persone].[PersonaEmail] pe
            WHERE pe.PersonaEmailId <> @PersonaEmailId
              AND pe.PersonaId = @PersonaId
              AND pe.Email = @Email
              AND pe.DataCancellazione IS NULL
              AND (pe.DataInizioValidita IS NULL OR pe.DataInizioValidita <= SYSUTCDATETIME())
              AND (pe.DataFineValidita IS NULL OR pe.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string clearPrincipaleSql = """
            UPDATE [Persone].[PersonaEmail]
            SET Principale = CAST(0 AS bit),
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE PersonaId = @PersonaId
              AND PersonaEmailId <> @PersonaEmailId
              AND DataCancellazione IS NULL
              AND Principale = CAST(1 AS bit)
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string updateSql = """
            UPDATE [Persone].[PersonaEmail]
            SET TipoEmailId = @TipoEmailId,
                Email = @Email,
                Principale = @Principale,
                Verificata = @Verificata,
                DataVerifica = @DataVerifica,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE PersonaEmailId = @PersonaEmailId
              AND PersonaId = @PersonaId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string byIdSql = """
            SELECT
                pe.PersonaEmailId,
                pe.PersonaId,
                pe.TipoEmailId,
                pe.Email,
                pe.Principale,
                pe.Verificata,
                pe.DataVerifica,
                pe.DataCancellazione
            FROM [Persone].[PersonaEmail] pe
            WHERE pe.PersonaEmailId = @PersonaEmailId
              AND pe.PersonaId = @PersonaId
              AND pe.DataCancellazione IS NULL
              AND (pe.DataInizioValidita IS NULL OR pe.DataInizioValidita <= SYSUTCDATETIME())
              AND (pe.DataFineValidita IS NULL OR pe.DataFineValidita >= SYSUTCDATETIME());
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
            new { command.PersonaId, command.PersonaEmailId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        var tipoExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            tipoExistsSql,
            new { command.Request.TipoEmailId },
            cancellationToken: cancellationToken));
        if (tipoExists == 0)
        {
            return (WriteResult.InvalidTipoEmail, null);
        }

        var email = command.Request.Email.Trim();
        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.PersonaId, command.PersonaEmailId, Email = email },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var actorRaw = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actorRaw, out var parsedActor) ? parsedActor : 0;

        DateTime? dataVerifica = command.Request.Verificata
            ? command.Request.DataVerifica ?? now
            : null;

        await using var tx = await connection.BeginTransactionAsync(cancellationToken);
        if (command.Request.Principale)
        {
            await connection.ExecuteAsync(new CommandDefinition(
                clearPrincipaleSql,
                new { command.PersonaId, command.PersonaEmailId, Now = now, ActorInt = actorInt },
                tx,
                cancellationToken: cancellationToken));
        }

        await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new
            {
                command.PersonaId,
                command.PersonaEmailId,
                command.Request.TipoEmailId,
                Email = email,
                command.Request.Principale,
                command.Request.Verificata,
                DataVerifica = dataVerifica,
                Now = now,
                ActorInt = actorInt
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<PersonaEmailDto>(new CommandDefinition(
            byIdSql,
            new { command.PersonaId, command.PersonaEmailId },
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
            UPDATE [Persone].[PersonaEmail]
            SET DataCancellazione = @Now,
                CancellatoDa = @ActorInt,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE PersonaEmailId = @PersonaEmailId
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
            new { command.PersonaId, command.PersonaEmailId, Now = now, ActorInt = actorInt },
            cancellationToken: cancellationToken));

        return rows == 0 ? WriteResult.NotFound : WriteResult.Success;
    }
}
