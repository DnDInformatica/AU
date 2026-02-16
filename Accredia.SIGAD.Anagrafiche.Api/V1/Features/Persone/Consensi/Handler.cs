using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Consensi;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFoundPersona,
        NotFound,
        Duplicate,
        InvalidTipoFinalitaTrattamento
    }

    public static async Task<IReadOnlyList<TipoFinalitaTrattamentoLookupItem>> LookupsAsync(
        LookupsCommand _,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                t.TipoFinalitaTrattamentoId AS Id,
                t.Codice AS Code,
                t.Descrizione AS [Description],
                t.Categoria AS Category,
                t.RichiedeConsensoEsplicito AS RequiresExplicitConsent,
                t.IsObbligatorio AS IsMandatory
            FROM [Tipologica].[TipoFinalitaTrattamento] t
            WHERE t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY t.Ordine ASC, t.Descrizione ASC, t.Codice ASC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return (await connection.QueryAsync<TipoFinalitaTrattamentoLookupItem>(new CommandDefinition(
            sql, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<ConsensoPersonaDto>?> ListAsync(
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
                c.ConsensoPersonaId,
                c.PersonaId,
                c.TipoFinalitaTrattamentoId,
                c.Consenso,
                c.DataConsenso,
                c.DataScadenza,
                c.DataRevoca,
                c.ModalitaAcquisizione,
                c.ModalitaRevoca,
                c.RiferimentoDocumento,
                c.IPAddress,
                c.UserAgent,
                c.MotivoRevoca,
                c.VersioneInformativa,
                c.DataInformativa,
                c.Note,
                c.DataCancellazione
            FROM [Persone].[ConsensoPersona] c
            WHERE c.PersonaId = @PersonaId
              AND (@IncludeDeleted = 1 OR c.DataCancellazione IS NULL)
              AND (c.DataInizioValidita IS NULL OR c.DataInizioValidita <= SYSUTCDATETIME())
              AND (c.DataFineValidita IS NULL OR c.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY c.DataConsenso DESC, c.ConsensoPersonaId DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            personaExistsSql, new { command.PersonaId }, cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return null;
        }

        return (await connection.QueryAsync<ConsensoPersonaDto>(new CommandDefinition(
            listSql,
            new { command.PersonaId, IncludeDeleted = command.IncludeDeleted ? 1 : 0 },
            cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<(WriteResult Result, ConsensoPersonaDto? Item)> CreateAsync(
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

        const string finalitaExistsSql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoFinalitaTrattamento] t
            WHERE t.TipoFinalitaTrattamentoId = @TipoFinalitaTrattamentoId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Persone].[ConsensoPersona] c
            WHERE c.PersonaId = @PersonaId
              AND c.TipoFinalitaTrattamentoId = @TipoFinalitaTrattamentoId
              AND c.DataCancellazione IS NULL
              AND (c.DataInizioValidita IS NULL OR c.DataInizioValidita <= SYSUTCDATETIME())
              AND (c.DataFineValidita IS NULL OR c.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string insertSql = """
            DECLARE @newIds TABLE (Id int);

            INSERT INTO [Persone].[ConsensoPersona]
                ([PersonaId], [TipoFinalitaTrattamentoId], [Consenso], [DataConsenso], [DataScadenza], [DataRevoca],
                 [ModalitaAcquisizione], [RiferimentoDocumento], [IPAddress], [UserAgent], [MotivoRevoca], [ModalitaRevoca],
                 [VersioneInformativa], [DataInformativa], [Note],
                 [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa],
                 [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.ConsensoPersonaId INTO @newIds(Id)
            VALUES
                (@PersonaId, @TipoFinalitaTrattamentoId, @Consenso, @DataConsenso, @DataScadenza, @DataRevoca,
                 @ModalitaAcquisizione, @RiferimentoDocumento, @IPAddress, @UserAgent, @MotivoRevoca, @ModalitaRevoca,
                 @VersioneInformativa, @DataInformativa, @Note,
                 @Now, @ActorInt, @Now, @ActorInt,
                 @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                c.ConsensoPersonaId,
                c.PersonaId,
                c.TipoFinalitaTrattamentoId,
                c.Consenso,
                c.DataConsenso,
                c.DataScadenza,
                c.DataRevoca,
                c.ModalitaAcquisizione,
                c.ModalitaRevoca,
                c.RiferimentoDocumento,
                c.IPAddress,
                c.UserAgent,
                c.MotivoRevoca,
                c.VersioneInformativa,
                c.DataInformativa,
                c.Note,
                c.DataCancellazione
            FROM [Persone].[ConsensoPersona] c
            WHERE c.ConsensoPersonaId = @ConsensoPersonaId
              AND c.PersonaId = @PersonaId
              AND c.DataCancellazione IS NULL
              AND (c.DataInizioValidita IS NULL OR c.DataInizioValidita <= SYSUTCDATETIME())
              AND (c.DataFineValidita IS NULL OR c.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var personaExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            personaExistsSql, new { command.PersonaId }, cancellationToken: cancellationToken));
        if (personaExists == 0)
        {
            return (WriteResult.NotFoundPersona, null);
        }

        var finalitaExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            finalitaExistsSql,
            new { TipoFinalitaTrattamentoId = command.Request.TipoFinalitaTrattamentoId },
            cancellationToken: cancellationToken));
        if (finalitaExists == 0)
        {
            return (WriteResult.InvalidTipoFinalitaTrattamento, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.PersonaId, TipoFinalitaTrattamentoId = command.Request.TipoFinalitaTrattamentoId },
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
                command.Request.TipoFinalitaTrattamentoId,
                command.Request.Consenso,
                DataConsenso = command.Request.DataConsenso ?? now,
                DataScadenza = command.Request.DataScadenza?.Date,
                command.Request.DataRevoca,
                ModalitaAcquisizione = command.Request.ModalitaAcquisizione.Trim(),
                ModalitaRevoca = string.IsNullOrWhiteSpace(command.Request.ModalitaRevoca) ? null : command.Request.ModalitaRevoca.Trim(),
                command.Request.RiferimentoDocumento,
                command.Request.IPAddress,
                command.Request.UserAgent,
                command.Request.MotivoRevoca,
                command.Request.VersioneInformativa,
                DataInformativa = command.Request.DataInformativa?.Date,
                command.Request.Note,
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<ConsensoPersonaDto>(new CommandDefinition(
            byIdSql,
            new { command.PersonaId, ConsensoPersonaId = newId },
            cancellationToken: cancellationToken));

        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, ConsensoPersonaDto? Item)> UpdateAsync(
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
            FROM [Persone].[ConsensoPersona] c
            WHERE c.ConsensoPersonaId = @ConsensoPersonaId
              AND c.PersonaId = @PersonaId
              AND c.DataCancellazione IS NULL;
            """;

        const string finalitaExistsSql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoFinalitaTrattamento] t
            WHERE t.TipoFinalitaTrattamentoId = @TipoFinalitaTrattamentoId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Persone].[ConsensoPersona] c
            WHERE c.ConsensoPersonaId <> @ConsensoPersonaId
              AND c.PersonaId = @PersonaId
              AND c.TipoFinalitaTrattamentoId = @TipoFinalitaTrattamentoId
              AND c.DataCancellazione IS NULL
              AND (c.DataInizioValidita IS NULL OR c.DataInizioValidita <= SYSUTCDATETIME())
              AND (c.DataFineValidita IS NULL OR c.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string updateSql = """
            UPDATE [Persone].[ConsensoPersona]
            SET TipoFinalitaTrattamentoId = @TipoFinalitaTrattamentoId,
                Consenso = @Consenso,
                DataConsenso = @DataConsenso,
                DataScadenza = @DataScadenza,
                DataRevoca = @DataRevoca,
                ModalitaAcquisizione = @ModalitaAcquisizione,
                ModalitaRevoca = @ModalitaRevoca,
                RiferimentoDocumento = @RiferimentoDocumento,
                IPAddress = @IPAddress,
                UserAgent = @UserAgent,
                MotivoRevoca = @MotivoRevoca,
                VersioneInformativa = @VersioneInformativa,
                DataInformativa = @DataInformativa,
                Note = @Note,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE ConsensoPersonaId = @ConsensoPersonaId
              AND PersonaId = @PersonaId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string byIdSql = """
            SELECT
                c.ConsensoPersonaId,
                c.PersonaId,
                c.TipoFinalitaTrattamentoId,
                c.Consenso,
                c.DataConsenso,
                c.DataScadenza,
                c.DataRevoca,
                c.ModalitaAcquisizione,
                c.ModalitaRevoca,
                c.RiferimentoDocumento,
                c.IPAddress,
                c.UserAgent,
                c.MotivoRevoca,
                c.VersioneInformativa,
                c.DataInformativa,
                c.Note,
                c.DataCancellazione
            FROM [Persone].[ConsensoPersona] c
            WHERE c.ConsensoPersonaId = @ConsensoPersonaId
              AND c.PersonaId = @PersonaId
              AND c.DataCancellazione IS NULL
              AND (c.DataInizioValidita IS NULL OR c.DataInizioValidita <= SYSUTCDATETIME())
              AND (c.DataFineValidita IS NULL OR c.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var personaExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            personaExistsSql, new { command.PersonaId }, cancellationToken: cancellationToken));
        if (personaExists == 0)
        {
            return (WriteResult.NotFoundPersona, null);
        }

        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            existsSql, new { command.PersonaId, command.ConsensoPersonaId }, cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        var finalitaExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            finalitaExistsSql,
            new { TipoFinalitaTrattamentoId = command.Request.TipoFinalitaTrattamentoId },
            cancellationToken: cancellationToken));
        if (finalitaExists == 0)
        {
            return (WriteResult.InvalidTipoFinalitaTrattamento, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new
            {
                command.PersonaId,
                command.ConsensoPersonaId,
                TipoFinalitaTrattamentoId = command.Request.TipoFinalitaTrattamentoId
            },
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
                command.ConsensoPersonaId,
                command.Request.TipoFinalitaTrattamentoId,
                command.Request.Consenso,
                DataConsenso = command.Request.DataConsenso ?? now,
                DataScadenza = command.Request.DataScadenza?.Date,
                command.Request.DataRevoca,
                ModalitaAcquisizione = command.Request.ModalitaAcquisizione.Trim(),
                ModalitaRevoca = string.IsNullOrWhiteSpace(command.Request.ModalitaRevoca) ? null : command.Request.ModalitaRevoca.Trim(),
                command.Request.RiferimentoDocumento,
                command.Request.IPAddress,
                command.Request.UserAgent,
                command.Request.MotivoRevoca,
                command.Request.VersioneInformativa,
                DataInformativa = command.Request.DataInformativa?.Date,
                command.Request.Note,
                Now = now,
                ActorInt = actorInt
            },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<ConsensoPersonaDto>(new CommandDefinition(
            byIdSql,
            new { command.PersonaId, command.ConsensoPersonaId },
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
            UPDATE [Persone].[ConsensoPersona]
            SET DataCancellazione = @Now,
                CancellatoDa = @ActorInt,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE ConsensoPersonaId = @ConsensoPersonaId
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
            new { command.PersonaId, command.ConsensoPersonaId, Now = now, ActorInt = actorInt },
            cancellationToken: cancellationToken));

        return rows == 0 ? WriteResult.NotFound : WriteResult.Success;
    }
}

