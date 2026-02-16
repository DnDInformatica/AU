using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Utente;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFoundPersona,
        NotFound,
        DuplicatePersona,
        DuplicateUser
    }

    public static async Task<PersonaUtenteDto?> GetAsync(
        GetCommand command,
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

        const string sql = """
            SELECT TOP (1)
                pu.PersonaUtenteId,
                pu.PersonaId,
                pu.UserId,
                pu.DataCancellazione
            FROM [Persone].[PersonaUtente] pu
            WHERE pu.PersonaId = @PersonaId
              AND (@IncludeDeleted = 1 OR pu.DataCancellazione IS NULL)
              AND (pu.DataInizioValidita IS NULL OR pu.DataInizioValidita <= SYSUTCDATETIME())
              AND (pu.DataFineValidita IS NULL OR pu.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY pu.PersonaUtenteId DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            personaExistsSql, new { command.PersonaId }, cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return null;
        }

        return await connection.QuerySingleOrDefaultAsync<PersonaUtenteDto>(new CommandDefinition(
            sql,
            new { command.PersonaId, IncludeDeleted = command.IncludeDeleted ? 1 : 0 },
            cancellationToken: cancellationToken));
    }

    public static async Task<(WriteResult Result, PersonaUtenteDto? Item)> CreateAsync(
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

        const string duplicatePersonaSql = """
            SELECT COUNT(1)
            FROM [Persone].[PersonaUtente] pu
            WHERE pu.PersonaId = @PersonaId
              AND pu.DataCancellazione IS NULL
              AND (pu.DataInizioValidita IS NULL OR pu.DataInizioValidita <= SYSUTCDATETIME())
              AND (pu.DataFineValidita IS NULL OR pu.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string duplicateUserSql = """
            SELECT COUNT(1)
            FROM [Persone].[PersonaUtente] pu
            WHERE pu.UserId = @UserId
              AND pu.DataCancellazione IS NULL
              AND (pu.DataInizioValidita IS NULL OR pu.DataInizioValidita <= SYSUTCDATETIME())
              AND (pu.DataFineValidita IS NULL OR pu.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string insertSql = """
            DECLARE @newIds TABLE (Id int);

            INSERT INTO [Persone].[PersonaUtente]
                ([PersonaId], [UserId],
                 [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa],
                 [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.PersonaUtenteId INTO @newIds(Id)
            VALUES
                (@PersonaId, @UserId,
                 @Now, @ActorInt, @Now, @ActorInt,
                 @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                pu.PersonaUtenteId,
                pu.PersonaId,
                pu.UserId,
                pu.DataCancellazione
            FROM [Persone].[PersonaUtente] pu
            WHERE pu.PersonaUtenteId = @PersonaUtenteId
              AND pu.PersonaId = @PersonaId
              AND pu.DataCancellazione IS NULL
              AND (pu.DataInizioValidita IS NULL OR pu.DataInizioValidita <= SYSUTCDATETIME())
              AND (pu.DataFineValidita IS NULL OR pu.DataFineValidita >= SYSUTCDATETIME());
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

        var duplicatePersona = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicatePersonaSql,
            new { command.PersonaId },
            cancellationToken: cancellationToken));
        if (duplicatePersona > 0)
        {
            return (WriteResult.DuplicatePersona, null);
        }

        var userId = command.Request.UserId.Trim();
        var duplicateUser = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateUserSql,
            new { UserId = userId },
            cancellationToken: cancellationToken));
        if (duplicateUser > 0)
        {
            return (WriteResult.DuplicateUser, null);
        }

        var now = DateTime.UtcNow;
        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);
        var actorRaw = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actorRaw, out var parsedActor) ? parsedActor : 0;

        var newId = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            insertSql,
            new
            {
                command.PersonaId,
                UserId = userId,
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<PersonaUtenteDto>(new CommandDefinition(
            byIdSql,
            new { command.PersonaId, PersonaUtenteId = newId },
            cancellationToken: cancellationToken));

        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, PersonaUtenteDto? Item)> UpdateAsync(
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
            FROM [Persone].[PersonaUtente] pu
            WHERE pu.PersonaUtenteId = @PersonaUtenteId
              AND pu.PersonaId = @PersonaId
              AND pu.DataCancellazione IS NULL;
            """;

        const string duplicateUserSql = """
            SELECT COUNT(1)
            FROM [Persone].[PersonaUtente] pu
            WHERE pu.PersonaUtenteId <> @PersonaUtenteId
              AND pu.UserId = @UserId
              AND pu.DataCancellazione IS NULL
              AND (pu.DataInizioValidita IS NULL OR pu.DataInizioValidita <= SYSUTCDATETIME())
              AND (pu.DataFineValidita IS NULL OR pu.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string updateSql = """
            UPDATE [Persone].[PersonaUtente]
            SET UserId = @UserId,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE PersonaUtenteId = @PersonaUtenteId
              AND PersonaId = @PersonaId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string byIdSql = """
            SELECT
                pu.PersonaUtenteId,
                pu.PersonaId,
                pu.UserId,
                pu.DataCancellazione
            FROM [Persone].[PersonaUtente] pu
            WHERE pu.PersonaUtenteId = @PersonaUtenteId
              AND pu.PersonaId = @PersonaId
              AND pu.DataCancellazione IS NULL
              AND (pu.DataInizioValidita IS NULL OR pu.DataInizioValidita <= SYSUTCDATETIME())
              AND (pu.DataFineValidita IS NULL OR pu.DataFineValidita >= SYSUTCDATETIME());
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
            new { command.PersonaId, command.PersonaUtenteId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        var userId = command.Request.UserId.Trim();
        var duplicateUser = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateUserSql,
            new { command.PersonaUtenteId, UserId = userId },
            cancellationToken: cancellationToken));
        if (duplicateUser > 0)
        {
            return (WriteResult.DuplicateUser, null);
        }

        var now = DateTime.UtcNow;
        var actorRaw = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actorRaw, out var parsedActor) ? parsedActor : 0;

        await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new { command.PersonaId, command.PersonaUtenteId, UserId = userId, Now = now, ActorInt = actorInt },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<PersonaUtenteDto>(new CommandDefinition(
            byIdSql,
            new { command.PersonaId, command.PersonaUtenteId },
            cancellationToken: cancellationToken));

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
            UPDATE [Persone].[PersonaUtente]
            SET DataCancellazione = @Now,
                CancellatoDa = @ActorInt,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE PersonaUtenteId = @PersonaUtenteId
              AND PersonaId = @PersonaId
              AND DataCancellazione IS NULL;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var personaExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            personaExistsSql, new { command.PersonaId }, cancellationToken: cancellationToken));
        if (personaExists == 0)
        {
            return WriteResult.NotFoundPersona;
        }

        var now = DateTime.UtcNow;
        var actorRaw = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actorRaw, out var parsedActor) ? parsedActor : 0;

        var rows = await connection.ExecuteAsync(new CommandDefinition(
            deleteSql,
            new { command.PersonaId, command.PersonaUtenteId, Now = now, ActorInt = actorInt },
            cancellationToken: cancellationToken));

        return rows == 0 ? WriteResult.NotFound : WriteResult.Success;
    }
}

