using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.RichiesteEsercizioDiritti;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFound,
        InvalidTipoDirittoGdpr,
        InvalidPersona,
        InvalidResponsabileGestione,
        DuplicateCodice
    }

    public static async Task<IReadOnlyList<TipoDirittoGdprLookupItem>> LookupsAsync(
        LookupsCommand _,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                t.TipoDirittoGDPRId AS Id,
                t.Codice AS Code,
                t.Descrizione AS [Description],
                t.ArticoloGDPR AS Article
            FROM [Tipologica].[TipoDirittoGDPR] t
            WHERE t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY t.Ordine ASC, t.Descrizione ASC, t.Codice ASC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return (await connection.QueryAsync<TipoDirittoGdprLookupItem>(new CommandDefinition(
            sql, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<RichiestaEsercizioDirittiDto>> ListAsync(
        ListCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                r.RichiestaEsercizioDirittiId,
                r.PersonaId,
                r.NomeRichiedente,
                r.EmailRichiedente,
                r.TelefonoRichiedente,
                r.Codice,
                r.TipoDirittoGDPRId AS TipoDirittoGdprId,
                r.DataRichiesta,
                r.ModalitaRichiesta,
                r.TestoRichiesta,
                r.DocumentoRichiesta,
                r.IdentitaVerificata,
                r.DataVerificaIdentita,
                r.ModalitaVerifica,
                CAST(r.DataScadenza AS datetime2) AS DataScadenza,
                CAST(r.DataProrogaRichiesta AS datetime2) AS DataProrogaRichiesta,
                r.MotivoProrogaRichiesta,
                r.Stato,
                r.ResponsabileGestioneId,
                r.Note,
                r.DataRisposta,
                r.EsitoRisposta,
                r.MotivoRifiuto,
                r.TestoRisposta,
                r.DocumentoRisposta,
                r.DataEsecuzione,
                r.DatiCancellati,
                r.DataCancellazione
            FROM [Persone].[RichiestaEsercizioDiritti] r
            WHERE (@PersonaId IS NULL OR r.PersonaId = @PersonaId)
              AND (@IncludeDeleted = 1 OR r.DataCancellazione IS NULL)
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY r.DataRichiesta DESC, r.RichiestaEsercizioDirittiId DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return (await connection.QueryAsync<RichiestaEsercizioDirittiDto>(new CommandDefinition(
            sql,
            new { PersonaId = command.PersonaId, IncludeDeleted = command.IncludeDeleted ? 1 : 0 },
            cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<RichiestaEsercizioDirittiDto?> GetByIdAsync(
        GetByIdCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                r.RichiestaEsercizioDirittiId,
                r.PersonaId,
                r.NomeRichiedente,
                r.EmailRichiedente,
                r.TelefonoRichiedente,
                r.Codice,
                r.TipoDirittoGDPRId AS TipoDirittoGdprId,
                r.DataRichiesta,
                r.ModalitaRichiesta,
                r.TestoRichiesta,
                r.DocumentoRichiesta,
                r.IdentitaVerificata,
                r.DataVerificaIdentita,
                r.ModalitaVerifica,
                CAST(r.DataScadenza AS datetime2) AS DataScadenza,
                CAST(r.DataProrogaRichiesta AS datetime2) AS DataProrogaRichiesta,
                r.MotivoProrogaRichiesta,
                r.Stato,
                r.ResponsabileGestioneId,
                r.Note,
                r.DataRisposta,
                r.EsitoRisposta,
                r.MotivoRifiuto,
                r.TestoRisposta,
                r.DocumentoRisposta,
                r.DataEsecuzione,
                r.DatiCancellati,
                r.DataCancellazione
            FROM [Persone].[RichiestaEsercizioDiritti] r
            WHERE r.RichiestaEsercizioDirittiId = @RichiestaEsercizioDirittiId
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return await connection.QuerySingleOrDefaultAsync<RichiestaEsercizioDirittiDto>(new CommandDefinition(
            sql,
            new { command.RichiestaEsercizioDirittiId },
            cancellationToken: cancellationToken));
    }

    public static async Task<(WriteResult Result, RichiestaEsercizioDirittiDto? Item)> CreateAsync(
        CreateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string tipoExistsSql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoDirittoGDPR] t
            WHERE t.TipoDirittoGDPRId = @TipoDirittoGdprId
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
            FROM [Persone].[RichiestaEsercizioDiritti] r
            WHERE r.Codice = @Codice
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string insertSql = """
            DECLARE @newIds TABLE (Id int);

            INSERT INTO [Persone].[RichiestaEsercizioDiritti]
                ([PersonaId], [NomeRichiedente], [EmailRichiedente], [TelefonoRichiedente], [Codice], [TipoDirittoGDPRId],
                 [DataRichiesta], [ModalitaRichiesta], [TestoRichiesta], [DocumentoRichiesta],
                 [IdentitaVerificata], [DataVerificaIdentita], [ModalitaVerifica],
                 [DataScadenza], [DataProrogaRichiesta], [MotivoProrogaRichiesta],
                 [Stato], [ResponsabileGestioneId], [Note],
                 [DataRisposta], [EsitoRisposta], [MotivoRifiuto], [TestoRisposta], [DocumentoRisposta],
                 [DataEsecuzione], [DatiCancellati],
                 [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa],
                 [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.RichiestaEsercizioDirittiId INTO @newIds(Id)
            VALUES
                (@PersonaId, @NomeRichiedente, @EmailRichiedente, @TelefonoRichiedente, @Codice, @TipoDirittoGdprId,
                 @DataRichiesta, @ModalitaRichiesta, @TestoRichiesta, @DocumentoRichiesta,
                 @IdentitaVerificata, @DataVerificaIdentita, @ModalitaVerifica,
                 @DataScadenza, @DataProrogaRichiesta, @MotivoProrogaRichiesta,
                 @Stato, @ResponsabileGestioneId, @Note,
                 @DataRisposta, @EsitoRisposta, @MotivoRifiuto, @TestoRisposta, @DocumentoRisposta,
                 @DataEsecuzione, @DatiCancellati,
                 @Now, @ActorInt, @Now, @ActorInt,
                 @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                r.RichiestaEsercizioDirittiId,
                r.PersonaId,
                r.NomeRichiedente,
                r.EmailRichiedente,
                r.TelefonoRichiedente,
                r.Codice,
                r.TipoDirittoGDPRId AS TipoDirittoGdprId,
                r.DataRichiesta,
                r.ModalitaRichiesta,
                r.TestoRichiesta,
                r.DocumentoRichiesta,
                r.IdentitaVerificata,
                r.DataVerificaIdentita,
                r.ModalitaVerifica,
                CAST(r.DataScadenza AS datetime2) AS DataScadenza,
                CAST(r.DataProrogaRichiesta AS datetime2) AS DataProrogaRichiesta,
                r.MotivoProrogaRichiesta,
                r.Stato,
                r.ResponsabileGestioneId,
                r.Note,
                r.DataRisposta,
                r.EsitoRisposta,
                r.MotivoRifiuto,
                r.TestoRisposta,
                r.DocumentoRisposta,
                r.DataEsecuzione,
                r.DatiCancellati,
                r.DataCancellazione
            FROM [Persone].[RichiestaEsercizioDiritti] r
            WHERE r.RichiestaEsercizioDirittiId = @RichiestaEsercizioDirittiId
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var tipoExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            tipoExistsSql,
            new { TipoDirittoGdprId = command.Request.TipoDirittoGdprId },
            cancellationToken: cancellationToken));
        if (tipoExists == 0)
        {
            return (WriteResult.InvalidTipoDirittoGdpr, null);
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
                EmailRichiedente = command.Request.EmailRichiedente.Trim(),
                command.Request.TelefonoRichiedente,
                Codice = codice,
                TipoDirittoGdprId = command.Request.TipoDirittoGdprId,
                command.Request.DataRichiesta,
                ModalitaRichiesta = command.Request.ModalitaRichiesta.Trim(),
                command.Request.TestoRichiesta,
                command.Request.DocumentoRichiesta,
                command.Request.IdentitaVerificata,
                command.Request.DataVerificaIdentita,
                command.Request.ModalitaVerifica,
                DataScadenza = command.Request.DataScadenza.Date,
                DataProrogaRichiesta = command.Request.DataProrogaRichiesta?.Date,
                command.Request.MotivoProrogaRichiesta,
                Stato = command.Request.Stato.Trim(),
                command.Request.ResponsabileGestioneId,
                command.Request.Note,
                command.Request.DataRisposta,
                EsitoRisposta = string.IsNullOrWhiteSpace(command.Request.EsitoRisposta) ? null : command.Request.EsitoRisposta.Trim(),
                command.Request.MotivoRifiuto,
                command.Request.TestoRisposta,
                command.Request.DocumentoRisposta,
                command.Request.DataEsecuzione,
                command.Request.DatiCancellati,
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<RichiestaEsercizioDirittiDto>(new CommandDefinition(
            byIdSql,
            new { RichiestaEsercizioDirittiId = newId },
            cancellationToken: cancellationToken));

        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, RichiestaEsercizioDirittiDto? Item)> UpdateAsync(
        UpdateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string existsSql = """
            SELECT COUNT(1)
            FROM [Persone].[RichiestaEsercizioDiritti] r
            WHERE r.RichiestaEsercizioDirittiId = @RichiestaEsercizioDirittiId
              AND r.DataCancellazione IS NULL;
            """;

        const string tipoExistsSql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoDirittoGDPR] t
            WHERE t.TipoDirittoGDPRId = @TipoDirittoGdprId
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
            FROM [Persone].[RichiestaEsercizioDiritti] r
            WHERE r.RichiestaEsercizioDirittiId <> @RichiestaEsercizioDirittiId
              AND r.Codice = @Codice
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string updateSql = """
            UPDATE [Persone].[RichiestaEsercizioDiritti]
            SET PersonaId = @PersonaId,
                NomeRichiedente = @NomeRichiedente,
                EmailRichiedente = @EmailRichiedente,
                TelefonoRichiedente = @TelefonoRichiedente,
                Codice = @Codice,
                TipoDirittoGDPRId = @TipoDirittoGdprId,
                DataRichiesta = @DataRichiesta,
                ModalitaRichiesta = @ModalitaRichiesta,
                TestoRichiesta = @TestoRichiesta,
                DocumentoRichiesta = @DocumentoRichiesta,
                IdentitaVerificata = @IdentitaVerificata,
                DataVerificaIdentita = @DataVerificaIdentita,
                ModalitaVerifica = @ModalitaVerifica,
                DataScadenza = @DataScadenza,
                DataProrogaRichiesta = @DataProrogaRichiesta,
                MotivoProrogaRichiesta = @MotivoProrogaRichiesta,
                Stato = @Stato,
                ResponsabileGestioneId = @ResponsabileGestioneId,
                Note = @Note,
                DataRisposta = @DataRisposta,
                EsitoRisposta = @EsitoRisposta,
                MotivoRifiuto = @MotivoRifiuto,
                TestoRisposta = @TestoRisposta,
                DocumentoRisposta = @DocumentoRisposta,
                DataEsecuzione = @DataEsecuzione,
                DatiCancellati = @DatiCancellati,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE RichiestaEsercizioDirittiId = @RichiestaEsercizioDirittiId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string byIdSql = """
            SELECT
                r.RichiestaEsercizioDirittiId,
                r.PersonaId,
                r.NomeRichiedente,
                r.EmailRichiedente,
                r.TelefonoRichiedente,
                r.Codice,
                r.TipoDirittoGDPRId AS TipoDirittoGdprId,
                r.DataRichiesta,
                r.ModalitaRichiesta,
                r.TestoRichiesta,
                r.DocumentoRichiesta,
                r.IdentitaVerificata,
                r.DataVerificaIdentita,
                r.ModalitaVerifica,
                CAST(r.DataScadenza AS datetime2) AS DataScadenza,
                CAST(r.DataProrogaRichiesta AS datetime2) AS DataProrogaRichiesta,
                r.MotivoProrogaRichiesta,
                r.Stato,
                r.ResponsabileGestioneId,
                r.Note,
                r.DataRisposta,
                r.EsitoRisposta,
                r.MotivoRifiuto,
                r.TestoRisposta,
                r.DocumentoRisposta,
                r.DataEsecuzione,
                r.DatiCancellati,
                r.DataCancellazione
            FROM [Persone].[RichiestaEsercizioDiritti] r
            WHERE r.RichiestaEsercizioDirittiId = @RichiestaEsercizioDirittiId
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            existsSql,
            new { command.RichiestaEsercizioDirittiId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        var tipoExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            tipoExistsSql,
            new { TipoDirittoGdprId = command.Request.TipoDirittoGdprId },
            cancellationToken: cancellationToken));
        if (tipoExists == 0)
        {
            return (WriteResult.InvalidTipoDirittoGdpr, null);
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
            new { command.RichiestaEsercizioDirittiId, Codice = codice },
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
                command.RichiestaEsercizioDirittiId,
                PersonaId = command.Request.PersonaId,
                NomeRichiedente = command.Request.NomeRichiedente.Trim(),
                EmailRichiedente = command.Request.EmailRichiedente.Trim(),
                command.Request.TelefonoRichiedente,
                Codice = codice,
                TipoDirittoGdprId = command.Request.TipoDirittoGdprId,
                command.Request.DataRichiesta,
                ModalitaRichiesta = command.Request.ModalitaRichiesta.Trim(),
                command.Request.TestoRichiesta,
                command.Request.DocumentoRichiesta,
                command.Request.IdentitaVerificata,
                command.Request.DataVerificaIdentita,
                command.Request.ModalitaVerifica,
                DataScadenza = command.Request.DataScadenza.Date,
                DataProrogaRichiesta = command.Request.DataProrogaRichiesta?.Date,
                command.Request.MotivoProrogaRichiesta,
                Stato = command.Request.Stato.Trim(),
                command.Request.ResponsabileGestioneId,
                command.Request.Note,
                command.Request.DataRisposta,
                EsitoRisposta = string.IsNullOrWhiteSpace(command.Request.EsitoRisposta) ? null : command.Request.EsitoRisposta.Trim(),
                command.Request.MotivoRifiuto,
                command.Request.TestoRisposta,
                command.Request.DocumentoRisposta,
                command.Request.DataEsecuzione,
                command.Request.DatiCancellati,
                Now = now,
                ActorInt = actorInt
            },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<RichiestaEsercizioDirittiDto>(new CommandDefinition(
            byIdSql,
            new { command.RichiestaEsercizioDirittiId },
            cancellationToken: cancellationToken));

        return (WriteResult.Success, item);
    }

    public static async Task<WriteResult> DeleteAsync(
        DeleteCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string deleteSql = """
            UPDATE [Persone].[RichiestaEsercizioDiritti]
            SET DataCancellazione = @Now,
                CancellatoDa = @ActorInt,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE RichiestaEsercizioDirittiId = @RichiestaEsercizioDirittiId
              AND DataCancellazione IS NULL;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var now = DateTime.UtcNow;
        var actorRaw = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actorRaw, out var parsedActor) ? parsedActor : 0;

        var rows = await connection.ExecuteAsync(new CommandDefinition(
            deleteSql,
            new { command.RichiestaEsercizioDirittiId, Now = now, ActorInt = actorInt },
            cancellationToken: cancellationToken));

        return rows == 0 ? WriteResult.NotFound : WriteResult.Success;
    }
}

