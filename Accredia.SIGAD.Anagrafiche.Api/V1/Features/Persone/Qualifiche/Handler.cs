using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Qualifiche;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFoundPersona,
        NotFound,
        Duplicate,
        InvalidTipoQualifica,
        InvalidEnteRilascioQualifica
    }

    public static async Task<(IReadOnlyList<TipoQualificaLookupItem> Tipi, IReadOnlyList<EnteRilascioQualificaLookupItem> Enti)> LookupsAsync(
        LookupsCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string tipiSql = """
            SELECT
                t.TipoQualificaId AS Id,
                t.Codice AS Code,
                t.Descrizione AS [Description],
                t.Categoria AS Category,
                t.RichiedeScadenza
            FROM [Tipologica].[TipoQualifica] t
            WHERE t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY t.Descrizione ASC, t.Codice ASC;
            """;

        const string entiSql = """
            SELECT
                e.EnteRilascioQualificaId AS Id,
                e.Codice AS Code,
                e.Descrizione AS [Description]
            FROM [Tipologica].[EnteRilascioQualifica] e
            WHERE e.DataCancellazione IS NULL
              AND (e.DataInizioValidita IS NULL OR e.DataInizioValidita <= SYSUTCDATETIME())
              AND (e.DataFineValidita IS NULL OR e.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY e.Descrizione ASC, e.Codice ASC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var tipi = (await connection.QueryAsync<TipoQualificaLookupItem>(new CommandDefinition(
            tipiSql,
            cancellationToken: cancellationToken))).ToList();
        var enti = (await connection.QueryAsync<EnteRilascioQualificaLookupItem>(new CommandDefinition(
            entiSql,
            cancellationToken: cancellationToken))).ToList();

        return (tipi, enti);
    }

    public static async Task<IReadOnlyList<PersonaQualificaDto>?> ListAsync(
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
                pq.PersonaQualificaId,
                pq.PersonaId,
                pq.TipoQualificaId,
                pq.EnteRilascioQualificaId,
                pq.CodiceAttestato,
                pq.DataRilascio,
                pq.DataScadenza,
                pq.Valida,
                pq.Note,
                pq.DataCancellazione
            FROM [Persone].[PersonaQualifica] pq
            WHERE pq.PersonaId = @PersonaId
              AND (@IncludeDeleted = 1 OR pq.DataCancellazione IS NULL)
              AND (pq.DataInizioValidita IS NULL OR pq.DataInizioValidita <= SYSUTCDATETIME())
              AND (pq.DataFineValidita IS NULL OR pq.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY pq.DataRilascio DESC, pq.PersonaQualificaId DESC;
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

        var rows = (await connection.QueryAsync<PersonaQualificaDto>(new CommandDefinition(
            listSql,
            new { command.PersonaId, IncludeDeleted = command.IncludeDeleted ? 1 : 0 },
            cancellationToken: cancellationToken))).ToList();

        return rows;
    }

    public static async Task<(WriteResult Result, PersonaQualificaDto? Item)> CreateAsync(
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
            FROM [Tipologica].[TipoQualifica] t
            WHERE t.TipoQualificaId = @TipoQualificaId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string enteExistsSql = """
            SELECT COUNT(1)
            FROM [Tipologica].[EnteRilascioQualifica] e
            WHERE e.EnteRilascioQualificaId = @EnteRilascioQualificaId
              AND e.DataCancellazione IS NULL
              AND (e.DataInizioValidita IS NULL OR e.DataInizioValidita <= SYSUTCDATETIME())
              AND (e.DataFineValidita IS NULL OR e.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Persone].[PersonaQualifica] pq
            WHERE pq.PersonaId = @PersonaId
              AND pq.TipoQualificaId = @TipoQualificaId
              AND pq.DataCancellazione IS NULL
              AND (pq.DataInizioValidita IS NULL OR pq.DataInizioValidita <= SYSUTCDATETIME())
              AND (pq.DataFineValidita IS NULL OR pq.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string insertSql = """
            DECLARE @newIds TABLE (Id int);

            INSERT INTO [Persone].[PersonaQualifica]
                ([PersonaId], [TipoQualificaId], [EnteRilascioQualificaId], [CodiceAttestato], [DataRilascio], [DataScadenza], [Valida], [Note], [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa], [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.PersonaQualificaId INTO @newIds(Id)
            VALUES
                (@PersonaId, @TipoQualificaId, @EnteRilascioQualificaId, @CodiceAttestato, @DataRilascio, @DataScadenza, @Valida, @Note, @Now, @ActorInt, @Now, @ActorInt, @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                pq.PersonaQualificaId,
                pq.PersonaId,
                pq.TipoQualificaId,
                pq.EnteRilascioQualificaId,
                pq.CodiceAttestato,
                pq.DataRilascio,
                pq.DataScadenza,
                pq.Valida,
                pq.Note,
                pq.DataCancellazione
            FROM [Persone].[PersonaQualifica] pq
            WHERE pq.PersonaQualificaId = @PersonaQualificaId
              AND pq.PersonaId = @PersonaId
              AND pq.DataCancellazione IS NULL
              AND (pq.DataInizioValidita IS NULL OR pq.DataInizioValidita <= SYSUTCDATETIME())
              AND (pq.DataFineValidita IS NULL OR pq.DataFineValidita >= SYSUTCDATETIME());
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
            new { command.Request.TipoQualificaId },
            cancellationToken: cancellationToken));
        if (tipoExists == 0)
        {
            return (WriteResult.InvalidTipoQualifica, null);
        }

        if (command.Request.EnteRilascioQualificaId is not null)
        {
            var enteExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
                enteExistsSql,
                new { command.Request.EnteRilascioQualificaId },
                cancellationToken: cancellationToken));
            if (enteExists == 0)
            {
                return (WriteResult.InvalidEnteRilascioQualifica, null);
            }
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.PersonaId, command.Request.TipoQualificaId },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
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
                command.Request.TipoQualificaId,
                command.Request.EnteRilascioQualificaId,
                CodiceAttestato = string.IsNullOrWhiteSpace(command.Request.CodiceAttestato) ? null : command.Request.CodiceAttestato.Trim(),
                command.Request.DataRilascio,
                command.Request.DataScadenza,
                command.Request.Valida,
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<PersonaQualificaDto>(new CommandDefinition(
            byIdSql,
            new { PersonaQualificaId = newId, command.PersonaId },
            cancellationToken: cancellationToken));

        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, PersonaQualificaDto? Item)> UpdateAsync(
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
            FROM [Persone].[PersonaQualifica] pq
            WHERE pq.PersonaQualificaId = @PersonaQualificaId
              AND pq.PersonaId = @PersonaId
              AND pq.DataCancellazione IS NULL;
            """;

        const string tipoExistsSql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoQualifica] t
            WHERE t.TipoQualificaId = @TipoQualificaId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string enteExistsSql = """
            SELECT COUNT(1)
            FROM [Tipologica].[EnteRilascioQualifica] e
            WHERE e.EnteRilascioQualificaId = @EnteRilascioQualificaId
              AND e.DataCancellazione IS NULL
              AND (e.DataInizioValidita IS NULL OR e.DataInizioValidita <= SYSUTCDATETIME())
              AND (e.DataFineValidita IS NULL OR e.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Persone].[PersonaQualifica] pq
            WHERE pq.PersonaQualificaId <> @PersonaQualificaId
              AND pq.PersonaId = @PersonaId
              AND pq.TipoQualificaId = @TipoQualificaId
              AND pq.DataCancellazione IS NULL
              AND (pq.DataInizioValidita IS NULL OR pq.DataInizioValidita <= SYSUTCDATETIME())
              AND (pq.DataFineValidita IS NULL OR pq.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string updateSql = """
            UPDATE [Persone].[PersonaQualifica]
            SET TipoQualificaId = @TipoQualificaId,
                EnteRilascioQualificaId = @EnteRilascioQualificaId,
                CodiceAttestato = @CodiceAttestato,
                DataRilascio = @DataRilascio,
                DataScadenza = @DataScadenza,
                Valida = @Valida,
                Note = @Note,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE PersonaQualificaId = @PersonaQualificaId
              AND PersonaId = @PersonaId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string byIdSql = """
            SELECT
                pq.PersonaQualificaId,
                pq.PersonaId,
                pq.TipoQualificaId,
                pq.EnteRilascioQualificaId,
                pq.CodiceAttestato,
                pq.DataRilascio,
                pq.DataScadenza,
                pq.Valida,
                pq.Note,
                pq.DataCancellazione
            FROM [Persone].[PersonaQualifica] pq
            WHERE pq.PersonaQualificaId = @PersonaQualificaId
              AND pq.PersonaId = @PersonaId
              AND pq.DataCancellazione IS NULL
              AND (pq.DataInizioValidita IS NULL OR pq.DataInizioValidita <= SYSUTCDATETIME())
              AND (pq.DataFineValidita IS NULL OR pq.DataFineValidita >= SYSUTCDATETIME());
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
            new { command.PersonaId, command.PersonaQualificaId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        var tipoExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            tipoExistsSql,
            new { command.Request.TipoQualificaId },
            cancellationToken: cancellationToken));
        if (tipoExists == 0)
        {
            return (WriteResult.InvalidTipoQualifica, null);
        }

        if (command.Request.EnteRilascioQualificaId is not null)
        {
            var enteExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
                enteExistsSql,
                new { command.Request.EnteRilascioQualificaId },
                cancellationToken: cancellationToken));
            if (enteExists == 0)
            {
                return (WriteResult.InvalidEnteRilascioQualifica, null);
            }
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.PersonaId, command.PersonaQualificaId, command.Request.TipoQualificaId },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var actorRaw = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actorRaw, out var parsedActor) ? parsedActor : 0;

        await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new
            {
                command.PersonaId,
                command.PersonaQualificaId,
                command.Request.TipoQualificaId,
                command.Request.EnteRilascioQualificaId,
                CodiceAttestato = string.IsNullOrWhiteSpace(command.Request.CodiceAttestato) ? null : command.Request.CodiceAttestato.Trim(),
                command.Request.DataRilascio,
                command.Request.DataScadenza,
                command.Request.Valida,
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                Now = now,
                ActorInt = actorInt
            },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<PersonaQualificaDto>(new CommandDefinition(
            byIdSql,
            new { command.PersonaId, command.PersonaQualificaId },
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
            UPDATE [Persone].[PersonaQualifica]
            SET DataCancellazione = @Now,
                CancellatoDa = @ActorInt,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE PersonaQualificaId = @PersonaQualificaId
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
            new { command.PersonaId, command.PersonaQualificaId, Now = now, ActorInt = actorInt },
            cancellationToken: cancellationToken));

        return rows == 0 ? WriteResult.NotFound : WriteResult.Success;
    }
}

