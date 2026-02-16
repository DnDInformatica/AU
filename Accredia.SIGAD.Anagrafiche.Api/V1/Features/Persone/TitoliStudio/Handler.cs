using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.TitoliStudio;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFoundPersona,
        NotFound,
        Duplicate,
        InvalidTipoTitoloStudio
    }

    public static async Task<TitoliStudioLookupsResponse> LookupsAsync(
        LookupsCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string tipiSql = """
            SELECT
                t.TipoTitoloStudioId AS Id,
                t.Codice AS Code,
                t.Descrizione AS [Description],
                t.LivelloTitoloStudioId,
                t.TipoSistemaFormativoId,
                t.HaValoreLegale,
                t.RichiedeTitoloPrevio
            FROM [Tipologica].[TipoTitoloStudio] t
            WHERE t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY t.Ordine ASC, t.Descrizione ASC, t.Codice ASC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var tipi = (await connection.QueryAsync<TipoTitoloStudioLookupItem>(new CommandDefinition(
            tipiSql,
            cancellationToken: cancellationToken))).ToList();

        return new TitoliStudioLookupsResponse(tipi);
    }

    public static async Task<IReadOnlyList<PersonaTitoloStudioDto>?> ListAsync(
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
                pts.PersonaTitoloStudioId,
                pts.PersonaId,
                pts.TipoTitoloStudioId,
                pts.Istituzione,
                pts.Corso,
                pts.DataConseguimento,
                pts.Voto,
                pts.Lode,
                pts.Paese,
                pts.Note,
                pts.Principale,
                pts.DataCancellazione
            FROM [Persone].[PersonaTitoloStudio] pts
            WHERE pts.PersonaId = @PersonaId
              AND (@IncludeDeleted = 1 OR pts.DataCancellazione IS NULL)
              AND (pts.DataInizioValidita IS NULL OR pts.DataInizioValidita <= SYSUTCDATETIME())
              AND (pts.DataFineValidita IS NULL OR pts.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY pts.Principale DESC, pts.DataConseguimento DESC, pts.PersonaTitoloStudioId DESC;
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

        var rows = (await connection.QueryAsync<PersonaTitoloStudioDto>(new CommandDefinition(
            listSql,
            new { command.PersonaId, IncludeDeleted = command.IncludeDeleted ? 1 : 0 },
            cancellationToken: cancellationToken))).ToList();

        return rows;
    }

    public static async Task<(WriteResult Result, PersonaTitoloStudioDto? Item)> CreateAsync(
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
            FROM [Tipologica].[TipoTitoloStudio] t
            WHERE t.TipoTitoloStudioId = @TipoTitoloStudioId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Persone].[PersonaTitoloStudio] pts
            WHERE pts.PersonaId = @PersonaId
              AND pts.TipoTitoloStudioId = @TipoTitoloStudioId
              AND pts.DataCancellazione IS NULL
              AND (pts.DataInizioValidita IS NULL OR pts.DataInizioValidita <= SYSUTCDATETIME())
              AND (pts.DataFineValidita IS NULL OR pts.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string clearPrincipaleSql = """
            UPDATE [Persone].[PersonaTitoloStudio]
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

            INSERT INTO [Persone].[PersonaTitoloStudio]
                ([PersonaId], [TipoTitoloStudioId], [Istituzione], [Corso], [DataConseguimento], [Voto], [Lode], [Paese], [Note], [Principale], [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa], [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.PersonaTitoloStudioId INTO @newIds(Id)
            VALUES
                (@PersonaId, @TipoTitoloStudioId, @Istituzione, @Corso, @DataConseguimento, @Voto, @Lode, @Paese, @Note, @Principale, @Now, @ActorInt, @Now, @ActorInt, @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                pts.PersonaTitoloStudioId,
                pts.PersonaId,
                pts.TipoTitoloStudioId,
                pts.Istituzione,
                pts.Corso,
                pts.DataConseguimento,
                pts.Voto,
                pts.Lode,
                pts.Paese,
                pts.Note,
                pts.Principale,
                pts.DataCancellazione
            FROM [Persone].[PersonaTitoloStudio] pts
            WHERE pts.PersonaTitoloStudioId = @PersonaTitoloStudioId
              AND pts.PersonaId = @PersonaId
              AND pts.DataCancellazione IS NULL
              AND (pts.DataInizioValidita IS NULL OR pts.DataInizioValidita <= SYSUTCDATETIME())
              AND (pts.DataFineValidita IS NULL OR pts.DataFineValidita >= SYSUTCDATETIME());
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
            new { command.Request.TipoTitoloStudioId },
            cancellationToken: cancellationToken));
        if (tipoExists == 0)
        {
            return (WriteResult.InvalidTipoTitoloStudio, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.PersonaId, command.Request.TipoTitoloStudioId },
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
                command.Request.TipoTitoloStudioId,
                Istituzione = string.IsNullOrWhiteSpace(command.Request.Istituzione) ? null : command.Request.Istituzione.Trim(),
                Corso = string.IsNullOrWhiteSpace(command.Request.Corso) ? null : command.Request.Corso.Trim(),
                command.Request.DataConseguimento,
                Voto = string.IsNullOrWhiteSpace(command.Request.Voto) ? null : command.Request.Voto.Trim(),
                command.Request.Lode,
                Paese = string.IsNullOrWhiteSpace(command.Request.Paese) ? null : command.Request.Paese.Trim(),
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                command.Request.Principale,
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<PersonaTitoloStudioDto>(new CommandDefinition(
            byIdSql,
            new { PersonaTitoloStudioId = newId, command.PersonaId },
            tx,
            cancellationToken: cancellationToken));

        await tx.CommitAsync(cancellationToken);
        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, PersonaTitoloStudioDto? Item)> UpdateAsync(
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
            FROM [Persone].[PersonaTitoloStudio] pts
            WHERE pts.PersonaTitoloStudioId = @PersonaTitoloStudioId
              AND pts.PersonaId = @PersonaId
              AND pts.DataCancellazione IS NULL;
            """;

        const string tipoExistsSql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoTitoloStudio] t
            WHERE t.TipoTitoloStudioId = @TipoTitoloStudioId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Persone].[PersonaTitoloStudio] pts
            WHERE pts.PersonaTitoloStudioId <> @PersonaTitoloStudioId
              AND pts.PersonaId = @PersonaId
              AND pts.TipoTitoloStudioId = @TipoTitoloStudioId
              AND pts.DataCancellazione IS NULL
              AND (pts.DataInizioValidita IS NULL OR pts.DataInizioValidita <= SYSUTCDATETIME())
              AND (pts.DataFineValidita IS NULL OR pts.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string clearPrincipaleSql = """
            UPDATE [Persone].[PersonaTitoloStudio]
            SET Principale = CAST(0 AS bit),
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE PersonaId = @PersonaId
              AND PersonaTitoloStudioId <> @PersonaTitoloStudioId
              AND DataCancellazione IS NULL
              AND Principale = CAST(1 AS bit)
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string updateSql = """
            UPDATE [Persone].[PersonaTitoloStudio]
            SET TipoTitoloStudioId = @TipoTitoloStudioId,
                Istituzione = @Istituzione,
                Corso = @Corso,
                DataConseguimento = @DataConseguimento,
                Voto = @Voto,
                Lode = @Lode,
                Paese = @Paese,
                Note = @Note,
                Principale = @Principale,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE PersonaTitoloStudioId = @PersonaTitoloStudioId
              AND PersonaId = @PersonaId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string byIdSql = """
            SELECT
                pts.PersonaTitoloStudioId,
                pts.PersonaId,
                pts.TipoTitoloStudioId,
                pts.Istituzione,
                pts.Corso,
                pts.DataConseguimento,
                pts.Voto,
                pts.Lode,
                pts.Paese,
                pts.Note,
                pts.Principale,
                pts.DataCancellazione
            FROM [Persone].[PersonaTitoloStudio] pts
            WHERE pts.PersonaTitoloStudioId = @PersonaTitoloStudioId
              AND pts.PersonaId = @PersonaId
              AND pts.DataCancellazione IS NULL
              AND (pts.DataInizioValidita IS NULL OR pts.DataInizioValidita <= SYSUTCDATETIME())
              AND (pts.DataFineValidita IS NULL OR pts.DataFineValidita >= SYSUTCDATETIME());
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
            new { command.PersonaId, command.PersonaTitoloStudioId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        var tipoExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            tipoExistsSql,
            new { command.Request.TipoTitoloStudioId },
            cancellationToken: cancellationToken));
        if (tipoExists == 0)
        {
            return (WriteResult.InvalidTipoTitoloStudio, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.PersonaId, command.PersonaTitoloStudioId, command.Request.TipoTitoloStudioId },
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
                new { command.PersonaId, command.PersonaTitoloStudioId, Now = now, ActorInt = actorInt },
                tx,
                cancellationToken: cancellationToken));
        }

        await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new
            {
                command.PersonaId,
                command.PersonaTitoloStudioId,
                command.Request.TipoTitoloStudioId,
                Istituzione = string.IsNullOrWhiteSpace(command.Request.Istituzione) ? null : command.Request.Istituzione.Trim(),
                Corso = string.IsNullOrWhiteSpace(command.Request.Corso) ? null : command.Request.Corso.Trim(),
                command.Request.DataConseguimento,
                Voto = string.IsNullOrWhiteSpace(command.Request.Voto) ? null : command.Request.Voto.Trim(),
                command.Request.Lode,
                Paese = string.IsNullOrWhiteSpace(command.Request.Paese) ? null : command.Request.Paese.Trim(),
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                command.Request.Principale,
                Now = now,
                ActorInt = actorInt
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<PersonaTitoloStudioDto>(new CommandDefinition(
            byIdSql,
            new { command.PersonaId, command.PersonaTitoloStudioId },
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
            UPDATE [Persone].[PersonaTitoloStudio]
            SET DataCancellazione = @Now,
                CancellatoDa = @ActorInt,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE PersonaTitoloStudioId = @PersonaTitoloStudioId
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
            new { command.PersonaId, command.PersonaTitoloStudioId, Now = now, ActorInt = actorInt },
            cancellationToken: cancellationToken));

        return rows == 0 ? WriteResult.NotFound : WriteResult.Success;
    }
}

