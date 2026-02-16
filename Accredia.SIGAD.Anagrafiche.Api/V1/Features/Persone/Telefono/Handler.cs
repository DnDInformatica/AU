using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Telefono;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFoundPersona,
        NotFound,
        Duplicate,
        InvalidTipoTelefono
    }

    public static async Task<IReadOnlyList<TipoTelefonoLookupItem>> LookupsAsync(
        LookupsCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                t.TipoTelefonoId AS Id,
                t.Codice AS Code,
                t.Descrizione AS [Description]
            FROM [Tipologica].[TipoTelefono] t
            WHERE t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY t.Descrizione ASC, t.Codice ASC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = (await connection.QueryAsync<TipoTelefonoLookupItem>(
            new CommandDefinition(sql, cancellationToken: cancellationToken))).ToList();
        return rows;
    }

    public static async Task<IReadOnlyList<PersonaTelefonoDto>?> ListAsync(
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
                pt.PersonaTelefonoId,
                pt.PersonaId,
                pt.TipoTelefonoId,
                pt.PrefissoInternazionale,
                pt.Numero,
                pt.Estensione,
                pt.Principale,
                pt.Verificato,
                pt.DataVerifica,
                pt.DataCancellazione
            FROM [Persone].[PersonaTelefono] pt
            WHERE pt.PersonaId = @PersonaId
              AND (@IncludeDeleted = 1 OR pt.DataCancellazione IS NULL)
              AND (pt.DataInizioValidita IS NULL OR pt.DataInizioValidita <= SYSUTCDATETIME())
              AND (pt.DataFineValidita IS NULL OR pt.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY pt.Principale DESC, pt.PersonaTelefonoId DESC;
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

        var rows = (await connection.QueryAsync<PersonaTelefonoDto>(new CommandDefinition(
            listSql,
            new { command.PersonaId, IncludeDeleted = command.IncludeDeleted ? 1 : 0 },
            cancellationToken: cancellationToken))).ToList();

        return rows;
    }

    public static async Task<(WriteResult Result, PersonaTelefonoDto? Item)> CreateAsync(
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
            FROM [Tipologica].[TipoTelefono] t
            WHERE t.TipoTelefonoId = @TipoTelefonoId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Persone].[PersonaTelefono] pt
            WHERE pt.PersonaId = @PersonaId
              AND ISNULL(pt.PrefissoInternazionale, '') = ISNULL(@PrefissoInternazionale, '')
              AND pt.Numero = @Numero
              AND ISNULL(pt.Estensione, '') = ISNULL(@Estensione, '')
              AND pt.DataCancellazione IS NULL
              AND (pt.DataInizioValidita IS NULL OR pt.DataInizioValidita <= SYSUTCDATETIME())
              AND (pt.DataFineValidita IS NULL OR pt.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string clearPrincipaleSql = """
            UPDATE [Persone].[PersonaTelefono]
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

            INSERT INTO [Persone].[PersonaTelefono]
                ([PersonaId], [TipoTelefonoId], [PrefissoInternazionale], [Numero], [Estensione], [Principale], [Verificato], [DataVerifica], [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa], [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.PersonaTelefonoId INTO @newIds(Id)
            VALUES
                (@PersonaId, @TipoTelefonoId, @PrefissoInternazionale, @Numero, @Estensione, @Principale, @Verificato, @DataVerifica, @Now, @ActorInt, @Now, @ActorInt, @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                pt.PersonaTelefonoId,
                pt.PersonaId,
                pt.TipoTelefonoId,
                pt.PrefissoInternazionale,
                pt.Numero,
                pt.Estensione,
                pt.Principale,
                pt.Verificato,
                pt.DataVerifica,
                pt.DataCancellazione
            FROM [Persone].[PersonaTelefono] pt
            WHERE pt.PersonaTelefonoId = @PersonaTelefonoId
              AND pt.PersonaId = @PersonaId
              AND pt.DataCancellazione IS NULL
              AND (pt.DataInizioValidita IS NULL OR pt.DataInizioValidita <= SYSUTCDATETIME())
              AND (pt.DataFineValidita IS NULL OR pt.DataFineValidita >= SYSUTCDATETIME());
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
            new { command.Request.TipoTelefonoId },
            cancellationToken: cancellationToken));
        if (tipoExists == 0)
        {
            return (WriteResult.InvalidTipoTelefono, null);
        }

        var pref = string.IsNullOrWhiteSpace(command.Request.PrefissoInternazionale) ? null : command.Request.PrefissoInternazionale.Trim();
        var num = command.Request.Numero.Trim();
        var ext = string.IsNullOrWhiteSpace(command.Request.Estensione) ? null : command.Request.Estensione.Trim();

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.PersonaId, PrefissoInternazionale = pref, Numero = num, Estensione = ext },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);
        var actorRaw = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actorRaw, out var parsedActor) ? parsedActor : 0;

        DateTime? dataVerifica = command.Request.Verificato
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
                command.Request.TipoTelefonoId,
                PrefissoInternazionale = pref,
                Numero = num,
                Estensione = ext,
                command.Request.Principale,
                command.Request.Verificato,
                DataVerifica = dataVerifica,
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<PersonaTelefonoDto>(new CommandDefinition(
            byIdSql,
            new { PersonaTelefonoId = newId, command.PersonaId },
            tx,
            cancellationToken: cancellationToken));

        await tx.CommitAsync(cancellationToken);
        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, PersonaTelefonoDto? Item)> UpdateAsync(
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
            FROM [Persone].[PersonaTelefono] pt
            WHERE pt.PersonaTelefonoId = @PersonaTelefonoId
              AND pt.PersonaId = @PersonaId
              AND pt.DataCancellazione IS NULL;
            """;

        const string tipoExistsSql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoTelefono] t
            WHERE t.TipoTelefonoId = @TipoTelefonoId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Persone].[PersonaTelefono] pt
            WHERE pt.PersonaTelefonoId <> @PersonaTelefonoId
              AND pt.PersonaId = @PersonaId
              AND ISNULL(pt.PrefissoInternazionale, '') = ISNULL(@PrefissoInternazionale, '')
              AND pt.Numero = @Numero
              AND ISNULL(pt.Estensione, '') = ISNULL(@Estensione, '')
              AND pt.DataCancellazione IS NULL
              AND (pt.DataInizioValidita IS NULL OR pt.DataInizioValidita <= SYSUTCDATETIME())
              AND (pt.DataFineValidita IS NULL OR pt.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string clearPrincipaleSql = """
            UPDATE [Persone].[PersonaTelefono]
            SET Principale = CAST(0 AS bit),
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE PersonaId = @PersonaId
              AND PersonaTelefonoId <> @PersonaTelefonoId
              AND DataCancellazione IS NULL
              AND Principale = CAST(1 AS bit)
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string updateSql = """
            UPDATE [Persone].[PersonaTelefono]
            SET TipoTelefonoId = @TipoTelefonoId,
                PrefissoInternazionale = @PrefissoInternazionale,
                Numero = @Numero,
                Estensione = @Estensione,
                Principale = @Principale,
                Verificato = @Verificato,
                DataVerifica = @DataVerifica,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE PersonaTelefonoId = @PersonaTelefonoId
              AND PersonaId = @PersonaId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string byIdSql = """
            SELECT
                pt.PersonaTelefonoId,
                pt.PersonaId,
                pt.TipoTelefonoId,
                pt.PrefissoInternazionale,
                pt.Numero,
                pt.Estensione,
                pt.Principale,
                pt.Verificato,
                pt.DataVerifica,
                pt.DataCancellazione
            FROM [Persone].[PersonaTelefono] pt
            WHERE pt.PersonaTelefonoId = @PersonaTelefonoId
              AND pt.PersonaId = @PersonaId
              AND pt.DataCancellazione IS NULL
              AND (pt.DataInizioValidita IS NULL OR pt.DataInizioValidita <= SYSUTCDATETIME())
              AND (pt.DataFineValidita IS NULL OR pt.DataFineValidita >= SYSUTCDATETIME());
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
            new { command.PersonaId, command.PersonaTelefonoId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        var tipoExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            tipoExistsSql,
            new { command.Request.TipoTelefonoId },
            cancellationToken: cancellationToken));
        if (tipoExists == 0)
        {
            return (WriteResult.InvalidTipoTelefono, null);
        }

        var pref = string.IsNullOrWhiteSpace(command.Request.PrefissoInternazionale) ? null : command.Request.PrefissoInternazionale.Trim();
        var num = command.Request.Numero.Trim();
        var ext = string.IsNullOrWhiteSpace(command.Request.Estensione) ? null : command.Request.Estensione.Trim();

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.PersonaId, command.PersonaTelefonoId, PrefissoInternazionale = pref, Numero = num, Estensione = ext },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var actorRaw = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actorRaw, out var parsedActor) ? parsedActor : 0;

        DateTime? dataVerifica = command.Request.Verificato
            ? command.Request.DataVerifica ?? now
            : null;

        await using var tx = await connection.BeginTransactionAsync(cancellationToken);
        if (command.Request.Principale)
        {
            await connection.ExecuteAsync(new CommandDefinition(
                clearPrincipaleSql,
                new { command.PersonaId, command.PersonaTelefonoId, Now = now, ActorInt = actorInt },
                tx,
                cancellationToken: cancellationToken));
        }

        await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new
            {
                command.PersonaId,
                command.PersonaTelefonoId,
                command.Request.TipoTelefonoId,
                PrefissoInternazionale = pref,
                Numero = num,
                Estensione = ext,
                command.Request.Principale,
                command.Request.Verificato,
                DataVerifica = dataVerifica,
                Now = now,
                ActorInt = actorInt
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<PersonaTelefonoDto>(new CommandDefinition(
            byIdSql,
            new { command.PersonaId, command.PersonaTelefonoId },
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
            UPDATE [Persone].[PersonaTelefono]
            SET DataCancellazione = @Now,
                CancellatoDa = @ActorInt,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE PersonaTelefonoId = @PersonaTelefonoId
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
            new { command.PersonaId, command.PersonaTelefonoId, Now = now, ActorInt = actorInt },
            cancellationToken: cancellationToken));

        return rows == 0 ? WriteResult.NotFound : WriteResult.Success;
    }
}

