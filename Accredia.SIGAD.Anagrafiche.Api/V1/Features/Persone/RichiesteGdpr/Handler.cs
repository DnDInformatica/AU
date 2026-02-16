using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.RichiesteGdpr;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFound,
        InvalidTipoDirittoInteressato,
        InvalidPersona,
        InvalidResponsabileGestione,
        DuplicateCodice
    }

    public static async Task<IReadOnlyList<TipoDirittoInteressatoLookupItem>> LookupsAsync(
        LookupsCommand _,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                t.TipoDirittoInteressatoId AS Id,
                t.Codice AS Code,
                t.Descrizione AS [Description],
                t.ArticoloGDPR AS Article
            FROM [Tipologica].[TipoDirittoInteressato] t
            WHERE t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY t.Ordine ASC, t.Descrizione ASC, t.Codice ASC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return (await connection.QueryAsync<TipoDirittoInteressatoLookupItem>(new CommandDefinition(
            sql, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<RichiestaGdprDto>> ListAsync(
        ListCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                r.RichiestaGDPRId AS RichiestaGdprId,
                r.PersonaId,
                r.NomeRichiedente,
                r.CognomeRichiedente,
                r.EmailRichiedente,
                r.TelefonoRichiedente,
                r.TipoDirittoInteressatoId,
                r.Codice,
                r.DataRichiesta,
                r.CanaleRichiesta,
                r.DescrizioneRichiesta,
                r.DocumentoIdentita,
                CAST(r.DataScadenzaRisposta AS datetime2) AS DataScadenzaRisposta,
                r.Stato,
                r.ResponsabileGestioneId,
                r.DataPresaInCarico,
                r.DataRisposta,
                r.EsitoRichiesta,
                r.MotivoRifiuto,
                r.DescrizioneRisposta,
                r.ModalitaRisposta,
                r.RiferimentoDocumentoRisposta,
                r.Note,
                r.DataCancellazione
            FROM [Persone].[RichiestaGDPR] r
            WHERE (@PersonaId IS NULL OR r.PersonaId = @PersonaId)
              AND (@IncludeDeleted = 1 OR r.DataCancellazione IS NULL)
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY r.DataRichiesta DESC, r.RichiestaGDPRId DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return (await connection.QueryAsync<RichiestaGdprDto>(new CommandDefinition(
            sql,
            new { PersonaId = command.PersonaId, IncludeDeleted = command.IncludeDeleted ? 1 : 0 },
            cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<RichiestaGdprDto?> GetByIdAsync(
        GetByIdCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                r.RichiestaGDPRId AS RichiestaGdprId,
                r.PersonaId,
                r.NomeRichiedente,
                r.CognomeRichiedente,
                r.EmailRichiedente,
                r.TelefonoRichiedente,
                r.TipoDirittoInteressatoId,
                r.Codice,
                r.DataRichiesta,
                r.CanaleRichiesta,
                r.DescrizioneRichiesta,
                r.DocumentoIdentita,
                CAST(r.DataScadenzaRisposta AS datetime2) AS DataScadenzaRisposta,
                r.Stato,
                r.ResponsabileGestioneId,
                r.DataPresaInCarico,
                r.DataRisposta,
                r.EsitoRichiesta,
                r.MotivoRifiuto,
                r.DescrizioneRisposta,
                r.ModalitaRisposta,
                r.RiferimentoDocumentoRisposta,
                r.Note,
                r.DataCancellazione
            FROM [Persone].[RichiestaGDPR] r
            WHERE r.RichiestaGDPRId = @RichiestaGdprId
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return await connection.QuerySingleOrDefaultAsync<RichiestaGdprDto>(new CommandDefinition(
            sql,
            new { command.RichiestaGdprId },
            cancellationToken: cancellationToken));
    }

    public static async Task<(WriteResult Result, RichiestaGdprDto? Item)> CreateAsync(
        CreateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string tipoExistsSql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoDirittoInteressato] t
            WHERE t.TipoDirittoInteressatoId = @TipoDirittoInteressatoId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string personaExistsSql = """
            SELECT COUNT(1)
            FROM [Persone].[Persona] p
            WHERE p.PersonaId = @PersonaId
              AND p.DataCancellazione IS NULL
              AND (p.DataInizioValidita IS NULL OR p.DataInizioValidita <= SYSUTCDATETIME())
              AND (p.DataFineValidita IS NULL OR p.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string duplicateCodiceSql = """
            SELECT COUNT(1)
            FROM [Persone].[RichiestaGDPR] r
            WHERE r.Codice = @Codice
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string insertSql = """
            DECLARE @newIds TABLE (Id int);

            INSERT INTO [Persone].[RichiestaGDPR]
                ([PersonaId], [NomeRichiedente], [CognomeRichiedente], [EmailRichiedente], [TelefonoRichiedente],
                 [TipoDirittoInteressatoId], [Codice], [DataRichiesta], [CanaleRichiesta], [DescrizioneRichiesta],
                 [DocumentoIdentita], [DataScadenzaRisposta], [Stato], [ResponsabileGestioneId], [DataPresaInCarico],
                 [DataRisposta], [EsitoRichiesta], [MotivoRifiuto], [DescrizioneRisposta], [ModalitaRisposta],
                 [RiferimentoDocumentoRisposta], [Note],
                 [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa],
                 [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.RichiestaGDPRId INTO @newIds(Id)
            VALUES
                (@PersonaId, @NomeRichiedente, @CognomeRichiedente, @EmailRichiedente, @TelefonoRichiedente,
                 @TipoDirittoInteressatoId, @Codice, @DataRichiesta, @CanaleRichiesta, @DescrizioneRichiesta,
                 @DocumentoIdentita, @DataScadenzaRisposta, @Stato, @ResponsabileGestioneId, @DataPresaInCarico,
                 @DataRisposta, @EsitoRichiesta, @MotivoRifiuto, @DescrizioneRisposta, @ModalitaRisposta,
                 @RiferimentoDocumentoRisposta, @Note,
                 @Now, @ActorInt, @Now, @ActorInt,
                 @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                r.RichiestaGDPRId AS RichiestaGdprId,
                r.PersonaId,
                r.NomeRichiedente,
                r.CognomeRichiedente,
                r.EmailRichiedente,
                r.TelefonoRichiedente,
                r.TipoDirittoInteressatoId,
                r.Codice,
                r.DataRichiesta,
                r.CanaleRichiesta,
                r.DescrizioneRichiesta,
                r.DocumentoIdentita,
                CAST(r.DataScadenzaRisposta AS datetime2) AS DataScadenzaRisposta,
                r.Stato,
                r.ResponsabileGestioneId,
                r.DataPresaInCarico,
                r.DataRisposta,
                r.EsitoRichiesta,
                r.MotivoRifiuto,
                r.DescrizioneRisposta,
                r.ModalitaRisposta,
                r.RiferimentoDocumentoRisposta,
                r.Note,
                r.DataCancellazione
            FROM [Persone].[RichiestaGDPR] r
            WHERE r.RichiestaGDPRId = @RichiestaGdprId
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var tipoExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            tipoExistsSql,
            new { command.Request.TipoDirittoInteressatoId },
            cancellationToken: cancellationToken));
        if (tipoExists == 0)
        {
            return (WriteResult.InvalidTipoDirittoInteressato, null);
        }

        if (command.Request.PersonaId is not null)
        {
            var personaExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
                personaExistsSql,
                new { PersonaId = command.Request.PersonaId.Value },
                cancellationToken: cancellationToken));
            if (personaExists == 0)
            {
                return (WriteResult.InvalidPersona, null);
            }
        }

        if (command.Request.ResponsabileGestioneId is not null)
        {
            var responsabileExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
                personaExistsSql,
                new { PersonaId = command.Request.ResponsabileGestioneId.Value },
                cancellationToken: cancellationToken));
            if (responsabileExists == 0)
            {
                return (WriteResult.InvalidResponsabileGestione, null);
            }
        }

        var codice = command.Request.Codice.Trim();
        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateCodiceSql,
            new { Codice = codice },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.DuplicateCodice, null);
        }

        var now = DateTime.UtcNow;
        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);
        var actorRaw = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actorRaw, out var parsedActor) ? parsedActor : 0;

        var newId = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            insertSql,
            new
            {
                PersonaId = command.Request.PersonaId,
                NomeRichiedente = command.Request.NomeRichiedente.Trim(),
                CognomeRichiedente = command.Request.CognomeRichiedente.Trim(),
                command.Request.EmailRichiedente,
                command.Request.TelefonoRichiedente,
                command.Request.TipoDirittoInteressatoId,
                Codice = codice,
                command.Request.DataRichiesta,
                CanaleRichiesta = command.Request.CanaleRichiesta.Trim(),
                command.Request.DescrizioneRichiesta,
                command.Request.DocumentoIdentita,
                DataScadenzaRisposta = command.Request.DataScadenzaRisposta.Date,
                Stato = command.Request.Stato.Trim(),
                command.Request.ResponsabileGestioneId,
                command.Request.DataPresaInCarico,
                command.Request.DataRisposta,
                EsitoRichiesta = string.IsNullOrWhiteSpace(command.Request.EsitoRichiesta) ? null : command.Request.EsitoRichiesta.Trim(),
                command.Request.MotivoRifiuto,
                command.Request.DescrizioneRisposta,
                command.Request.ModalitaRisposta,
                command.Request.RiferimentoDocumentoRisposta,
                command.Request.Note,
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<RichiestaGdprDto>(new CommandDefinition(
            byIdSql,
            new { RichiestaGdprId = newId },
            cancellationToken: cancellationToken));

        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, RichiestaGdprDto? Item)> UpdateAsync(
        UpdateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string existsSql = """
            SELECT COUNT(1)
            FROM [Persone].[RichiestaGDPR] r
            WHERE r.RichiestaGDPRId = @RichiestaGdprId
              AND r.DataCancellazione IS NULL;
            """;

        const string tipoExistsSql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoDirittoInteressato] t
            WHERE t.TipoDirittoInteressatoId = @TipoDirittoInteressatoId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string personaExistsSql = """
            SELECT COUNT(1)
            FROM [Persone].[Persona] p
            WHERE p.PersonaId = @PersonaId
              AND p.DataCancellazione IS NULL
              AND (p.DataInizioValidita IS NULL OR p.DataInizioValidita <= SYSUTCDATETIME())
              AND (p.DataFineValidita IS NULL OR p.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string duplicateCodiceSql = """
            SELECT COUNT(1)
            FROM [Persone].[RichiestaGDPR] r
            WHERE r.RichiestaGDPRId <> @RichiestaGdprId
              AND r.Codice = @Codice
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string updateSql = """
            UPDATE [Persone].[RichiestaGDPR]
            SET PersonaId = @PersonaId,
                NomeRichiedente = @NomeRichiedente,
                CognomeRichiedente = @CognomeRichiedente,
                EmailRichiedente = @EmailRichiedente,
                TelefonoRichiedente = @TelefonoRichiedente,
                TipoDirittoInteressatoId = @TipoDirittoInteressatoId,
                Codice = @Codice,
                DataRichiesta = @DataRichiesta,
                CanaleRichiesta = @CanaleRichiesta,
                DescrizioneRichiesta = @DescrizioneRichiesta,
                DocumentoIdentita = @DocumentoIdentita,
                DataScadenzaRisposta = @DataScadenzaRisposta,
                Stato = @Stato,
                ResponsabileGestioneId = @ResponsabileGestioneId,
                DataPresaInCarico = @DataPresaInCarico,
                DataRisposta = @DataRisposta,
                EsitoRichiesta = @EsitoRichiesta,
                MotivoRifiuto = @MotivoRifiuto,
                DescrizioneRisposta = @DescrizioneRisposta,
                ModalitaRisposta = @ModalitaRisposta,
                RiferimentoDocumentoRisposta = @RiferimentoDocumentoRisposta,
                Note = @Note,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE RichiestaGDPRId = @RichiestaGdprId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string byIdSql = """
            SELECT
                r.RichiestaGDPRId AS RichiestaGdprId,
                r.PersonaId,
                r.NomeRichiedente,
                r.CognomeRichiedente,
                r.EmailRichiedente,
                r.TelefonoRichiedente,
                r.TipoDirittoInteressatoId,
                r.Codice,
                r.DataRichiesta,
                r.CanaleRichiesta,
                r.DescrizioneRichiesta,
                r.DocumentoIdentita,
                CAST(r.DataScadenzaRisposta AS datetime2) AS DataScadenzaRisposta,
                r.Stato,
                r.ResponsabileGestioneId,
                r.DataPresaInCarico,
                r.DataRisposta,
                r.EsitoRichiesta,
                r.MotivoRifiuto,
                r.DescrizioneRisposta,
                r.ModalitaRisposta,
                r.RiferimentoDocumentoRisposta,
                r.Note,
                r.DataCancellazione
            FROM [Persone].[RichiestaGDPR] r
            WHERE r.RichiestaGDPRId = @RichiestaGdprId
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            existsSql,
            new { command.RichiestaGdprId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        var tipoExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            tipoExistsSql,
            new { command.Request.TipoDirittoInteressatoId },
            cancellationToken: cancellationToken));
        if (tipoExists == 0)
        {
            return (WriteResult.InvalidTipoDirittoInteressato, null);
        }

        if (command.Request.PersonaId is not null)
        {
            var personaExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
                personaExistsSql,
                new { PersonaId = command.Request.PersonaId.Value },
                cancellationToken: cancellationToken));
            if (personaExists == 0)
            {
                return (WriteResult.InvalidPersona, null);
            }
        }

        if (command.Request.ResponsabileGestioneId is not null)
        {
            var responsabileExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
                personaExistsSql,
                new { PersonaId = command.Request.ResponsabileGestioneId.Value },
                cancellationToken: cancellationToken));
            if (responsabileExists == 0)
            {
                return (WriteResult.InvalidResponsabileGestione, null);
            }
        }

        var codice = command.Request.Codice.Trim();
        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateCodiceSql,
            new { command.RichiestaGdprId, Codice = codice },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.DuplicateCodice, null);
        }

        var now = DateTime.UtcNow;
        var actorRaw = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actorRaw, out var parsedActor) ? parsedActor : 0;

        await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new
            {
                RichiestaGdprId = command.RichiestaGdprId,
                PersonaId = command.Request.PersonaId,
                NomeRichiedente = command.Request.NomeRichiedente.Trim(),
                CognomeRichiedente = command.Request.CognomeRichiedente.Trim(),
                command.Request.EmailRichiedente,
                command.Request.TelefonoRichiedente,
                command.Request.TipoDirittoInteressatoId,
                Codice = codice,
                command.Request.DataRichiesta,
                CanaleRichiesta = command.Request.CanaleRichiesta.Trim(),
                command.Request.DescrizioneRichiesta,
                command.Request.DocumentoIdentita,
                DataScadenzaRisposta = command.Request.DataScadenzaRisposta.Date,
                Stato = command.Request.Stato.Trim(),
                command.Request.ResponsabileGestioneId,
                command.Request.DataPresaInCarico,
                command.Request.DataRisposta,
                EsitoRichiesta = string.IsNullOrWhiteSpace(command.Request.EsitoRichiesta) ? null : command.Request.EsitoRichiesta.Trim(),
                command.Request.MotivoRifiuto,
                command.Request.DescrizioneRisposta,
                command.Request.ModalitaRisposta,
                command.Request.RiferimentoDocumentoRisposta,
                command.Request.Note,
                Now = now,
                ActorInt = actorInt
            },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<RichiestaGdprDto>(new CommandDefinition(
            byIdSql,
            new { command.RichiestaGdprId },
            cancellationToken: cancellationToken));

        return (WriteResult.Success, item);
    }

    public static async Task<WriteResult> DeleteAsync(
        DeleteCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string deleteSql = """
            UPDATE [Persone].[RichiestaGDPR]
            SET DataCancellazione = @Now,
                CancellatoDa = @ActorInt,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE RichiestaGDPRId = @RichiestaGdprId
              AND DataCancellazione IS NULL;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var now = DateTime.UtcNow;
        var actorRaw = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actorRaw, out var parsedActor) ? parsedActor : 0;

        var rows = await connection.ExecuteAsync(new CommandDefinition(
            deleteSql,
            new { command.RichiestaGdprId, Now = now, ActorInt = actorInt },
            cancellationToken: cancellationToken));

        return rows == 0 ? WriteResult.NotFound : WriteResult.Success;
    }
}

