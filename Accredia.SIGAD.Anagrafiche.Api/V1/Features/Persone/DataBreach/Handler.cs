using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.DataBreach;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFound,
        DuplicateCodice,
        InvalidResponsabileGestione
    }

    public static async Task<IReadOnlyList<DataBreachDto>> ListAsync(
        ListCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                d.DataBreachId,
                d.Codice,
                d.Titolo,
                d.Descrizione,
                d.DataScoperta,
                d.DataInizioViolazione,
                d.DataFineViolazione,
                d.TipoViolazione,
                d.CausaViolazione,
                d.CategorieDatiCoinvolti,
                d.DatiParticolariCoinvolti,
                d.NumeroInteressatiStimato,
                d.CategorieInteressati,
                d.RischioPerInteressati,
                d.DescrizioneRischio,
                d.NotificaGaranteRichiesta,
                d.DataNotificaGarante,
                d.ProtocolloGarante,
                d.TermineNotificaGarante,
                d.ComunicazioneInteressatiRichiesta,
                d.DataComunicazioneInteressati,
                d.ModalitaComunicazione,
                d.MisureContenimento,
                d.MisurePrevenzione,
                d.ResponsabileGestioneId,
                d.DPOCoinvolto,
                d.Stato,
                d.DataChiusura,
                d.DataCancellazione
            FROM [Persone].[DataBreach] d
            WHERE (@IncludeDeleted = 1 OR d.DataCancellazione IS NULL)
              AND (d.DataInizioValidita IS NULL OR d.DataInizioValidita <= SYSUTCDATETIME())
              AND (d.DataFineValidita IS NULL OR d.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY d.DataScoperta DESC, d.DataBreachId DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return (await connection.QueryAsync<DataBreachDto>(new CommandDefinition(
            sql,
            new { IncludeDeleted = command.IncludeDeleted ? 1 : 0 },
            cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<DataBreachDto?> GetByIdAsync(
        GetByIdCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                d.DataBreachId,
                d.Codice,
                d.Titolo,
                d.Descrizione,
                d.DataScoperta,
                d.DataInizioViolazione,
                d.DataFineViolazione,
                d.TipoViolazione,
                d.CausaViolazione,
                d.CategorieDatiCoinvolti,
                d.DatiParticolariCoinvolti,
                d.NumeroInteressatiStimato,
                d.CategorieInteressati,
                d.RischioPerInteressati,
                d.DescrizioneRischio,
                d.NotificaGaranteRichiesta,
                d.DataNotificaGarante,
                d.ProtocolloGarante,
                d.TermineNotificaGarante,
                d.ComunicazioneInteressatiRichiesta,
                d.DataComunicazioneInteressati,
                d.ModalitaComunicazione,
                d.MisureContenimento,
                d.MisurePrevenzione,
                d.ResponsabileGestioneId,
                d.DPOCoinvolto,
                d.Stato,
                d.DataChiusura,
                d.DataCancellazione
            FROM [Persone].[DataBreach] d
            WHERE d.DataBreachId = @DataBreachId
              AND d.DataCancellazione IS NULL
              AND (d.DataInizioValidita IS NULL OR d.DataInizioValidita <= SYSUTCDATETIME())
              AND (d.DataFineValidita IS NULL OR d.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return await connection.QuerySingleOrDefaultAsync<DataBreachDto>(new CommandDefinition(
            sql,
            new { command.DataBreachId },
            cancellationToken: cancellationToken));
    }

    public static async Task<(WriteResult Result, DataBreachDto? Item)> CreateAsync(
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

        const string duplicateCodiceSql = """
            SELECT COUNT(1)
            FROM [Persone].[DataBreach] d
            WHERE d.Codice = @Codice
              AND d.DataCancellazione IS NULL
              AND (d.DataInizioValidita IS NULL OR d.DataInizioValidita <= SYSUTCDATETIME())
              AND (d.DataFineValidita IS NULL OR d.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string insertSql = """
            DECLARE @newIds TABLE (Id int);

            INSERT INTO [Persone].[DataBreach]
                ([Codice], [Titolo], [Descrizione], [DataScoperta], [DataInizioViolazione], [DataFineViolazione],
                 [TipoViolazione], [CausaViolazione], [CategorieDatiCoinvolti], [DatiParticolariCoinvolti], [NumeroInteressatiStimato],
                 [CategorieInteressati], [RischioPerInteressati], [DescrizioneRischio],
                 [NotificaGaranteRichiesta], [DataNotificaGarante], [ProtocolloGarante], [TermineNotificaGarante],
                 [ComunicazioneInteressatiRichiesta], [DataComunicazioneInteressati], [ModalitaComunicazione],
                 [MisureContenimento], [MisurePrevenzione], [ResponsabileGestioneId], [DPOCoinvolto], [Stato], [DataChiusura],
                 [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa],
                 [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.DataBreachId INTO @newIds(Id)
            VALUES
                (@Codice, @Titolo, @Descrizione, @DataScoperta, @DataInizioViolazione, @DataFineViolazione,
                 @TipoViolazione, @CausaViolazione, @CategorieDatiCoinvolti, @DatiParticolariCoinvolti, @NumeroInteressatiStimato,
                 @CategorieInteressati, @RischioPerInteressati, @DescrizioneRischio,
                 @NotificaGaranteRichiesta, @DataNotificaGarante, @ProtocolloGarante, @TermineNotificaGarante,
                 @ComunicazioneInteressatiRichiesta, @DataComunicazioneInteressati, @ModalitaComunicazione,
                 @MisureContenimento, @MisurePrevenzione, @ResponsabileGestioneId, @DPOCoinvolto, @Stato, @DataChiusura,
                 @Now, @ActorInt, @Now, @ActorInt,
                 @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                d.DataBreachId,
                d.Codice,
                d.Titolo,
                d.Descrizione,
                d.DataScoperta,
                d.DataInizioViolazione,
                d.DataFineViolazione,
                d.TipoViolazione,
                d.CausaViolazione,
                d.CategorieDatiCoinvolti,
                d.DatiParticolariCoinvolti,
                d.NumeroInteressatiStimato,
                d.CategorieInteressati,
                d.RischioPerInteressati,
                d.DescrizioneRischio,
                d.NotificaGaranteRichiesta,
                d.DataNotificaGarante,
                d.ProtocolloGarante,
                d.TermineNotificaGarante,
                d.ComunicazioneInteressatiRichiesta,
                d.DataComunicazioneInteressati,
                d.ModalitaComunicazione,
                d.MisureContenimento,
                d.MisurePrevenzione,
                d.ResponsabileGestioneId,
                d.DPOCoinvolto,
                d.Stato,
                d.DataChiusura,
                d.DataCancellazione
            FROM [Persone].[DataBreach] d
            WHERE d.DataBreachId = @DataBreachId
              AND d.DataCancellazione IS NULL
              AND (d.DataInizioValidita IS NULL OR d.DataInizioValidita <= SYSUTCDATETIME())
              AND (d.DataFineValidita IS NULL OR d.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

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
                Codice = codice,
                Titolo = command.Request.Titolo.Trim(),
                Descrizione = command.Request.Descrizione.Trim(),
                command.Request.DataScoperta,
                command.Request.DataInizioViolazione,
                command.Request.DataFineViolazione,
                TipoViolazione = command.Request.TipoViolazione.Trim(),
                CausaViolazione = command.Request.CausaViolazione.Trim(),
                CategorieDatiCoinvolti = command.Request.CategorieDatiCoinvolti.Trim(),
                command.Request.DatiParticolariCoinvolti,
                command.Request.NumeroInteressatiStimato,
                CategorieInteressati = command.Request.CategorieInteressati.Trim(),
                RischioPerInteressati = command.Request.RischioPerInteressati.Trim(),
                command.Request.DescrizioneRischio,
                command.Request.NotificaGaranteRichiesta,
                command.Request.DataNotificaGarante,
                command.Request.ProtocolloGarante,
                command.Request.TermineNotificaGarante,
                command.Request.ComunicazioneInteressatiRichiesta,
                command.Request.DataComunicazioneInteressati,
                command.Request.ModalitaComunicazione,
                command.Request.MisureContenimento,
                command.Request.MisurePrevenzione,
                command.Request.ResponsabileGestioneId,
                command.Request.DPOCoinvolto,
                Stato = command.Request.Stato.Trim(),
                DataChiusura = command.Request.DataChiusura?.Date,
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<DataBreachDto>(new CommandDefinition(
            byIdSql,
            new { DataBreachId = newId },
            cancellationToken: cancellationToken));

        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, DataBreachDto? Item)> UpdateAsync(
        UpdateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string existsSql = """
            SELECT COUNT(1)
            FROM [Persone].[DataBreach] d
            WHERE d.DataBreachId = @DataBreachId
              AND d.DataCancellazione IS NULL;
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
            FROM [Persone].[DataBreach] d
            WHERE d.DataBreachId <> @DataBreachId
              AND d.Codice = @Codice
              AND d.DataCancellazione IS NULL
              AND (d.DataInizioValidita IS NULL OR d.DataInizioValidita <= SYSUTCDATETIME())
              AND (d.DataFineValidita IS NULL OR d.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string updateSql = """
            UPDATE [Persone].[DataBreach]
            SET Codice = @Codice,
                Titolo = @Titolo,
                Descrizione = @Descrizione,
                DataScoperta = @DataScoperta,
                DataInizioViolazione = @DataInizioViolazione,
                DataFineViolazione = @DataFineViolazione,
                TipoViolazione = @TipoViolazione,
                CausaViolazione = @CausaViolazione,
                CategorieDatiCoinvolti = @CategorieDatiCoinvolti,
                DatiParticolariCoinvolti = @DatiParticolariCoinvolti,
                NumeroInteressatiStimato = @NumeroInteressatiStimato,
                CategorieInteressati = @CategorieInteressati,
                RischioPerInteressati = @RischioPerInteressati,
                DescrizioneRischio = @DescrizioneRischio,
                NotificaGaranteRichiesta = @NotificaGaranteRichiesta,
                DataNotificaGarante = @DataNotificaGarante,
                ProtocolloGarante = @ProtocolloGarante,
                TermineNotificaGarante = @TermineNotificaGarante,
                ComunicazioneInteressatiRichiesta = @ComunicazioneInteressatiRichiesta,
                DataComunicazioneInteressati = @DataComunicazioneInteressati,
                ModalitaComunicazione = @ModalitaComunicazione,
                MisureContenimento = @MisureContenimento,
                MisurePrevenzione = @MisurePrevenzione,
                ResponsabileGestioneId = @ResponsabileGestioneId,
                DPOCoinvolto = @DPOCoinvolto,
                Stato = @Stato,
                DataChiusura = @DataChiusura,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE DataBreachId = @DataBreachId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string byIdSql = """
            SELECT
                d.DataBreachId,
                d.Codice,
                d.Titolo,
                d.Descrizione,
                d.DataScoperta,
                d.DataInizioViolazione,
                d.DataFineViolazione,
                d.TipoViolazione,
                d.CausaViolazione,
                d.CategorieDatiCoinvolti,
                d.DatiParticolariCoinvolti,
                d.NumeroInteressatiStimato,
                d.CategorieInteressati,
                d.RischioPerInteressati,
                d.DescrizioneRischio,
                d.NotificaGaranteRichiesta,
                d.DataNotificaGarante,
                d.ProtocolloGarante,
                d.TermineNotificaGarante,
                d.ComunicazioneInteressatiRichiesta,
                d.DataComunicazioneInteressati,
                d.ModalitaComunicazione,
                d.MisureContenimento,
                d.MisurePrevenzione,
                d.ResponsabileGestioneId,
                d.DPOCoinvolto,
                d.Stato,
                d.DataChiusura,
                d.DataCancellazione
            FROM [Persone].[DataBreach] d
            WHERE d.DataBreachId = @DataBreachId
              AND d.DataCancellazione IS NULL
              AND (d.DataInizioValidita IS NULL OR d.DataInizioValidita <= SYSUTCDATETIME())
              AND (d.DataFineValidita IS NULL OR d.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            existsSql,
            new { command.DataBreachId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
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
            new { command.DataBreachId, Codice = codice },
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
                command.DataBreachId,
                Codice = codice,
                Titolo = command.Request.Titolo.Trim(),
                Descrizione = command.Request.Descrizione.Trim(),
                command.Request.DataScoperta,
                command.Request.DataInizioViolazione,
                command.Request.DataFineViolazione,
                TipoViolazione = command.Request.TipoViolazione.Trim(),
                CausaViolazione = command.Request.CausaViolazione.Trim(),
                CategorieDatiCoinvolti = command.Request.CategorieDatiCoinvolti.Trim(),
                command.Request.DatiParticolariCoinvolti,
                command.Request.NumeroInteressatiStimato,
                CategorieInteressati = command.Request.CategorieInteressati.Trim(),
                RischioPerInteressati = command.Request.RischioPerInteressati.Trim(),
                command.Request.DescrizioneRischio,
                command.Request.NotificaGaranteRichiesta,
                command.Request.DataNotificaGarante,
                command.Request.ProtocolloGarante,
                command.Request.TermineNotificaGarante,
                command.Request.ComunicazioneInteressatiRichiesta,
                command.Request.DataComunicazioneInteressati,
                command.Request.ModalitaComunicazione,
                command.Request.MisureContenimento,
                command.Request.MisurePrevenzione,
                command.Request.ResponsabileGestioneId,
                command.Request.DPOCoinvolto,
                Stato = command.Request.Stato.Trim(),
                DataChiusura = command.Request.DataChiusura?.Date,
                Now = now,
                ActorInt = actorInt
            },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<DataBreachDto>(new CommandDefinition(
            byIdSql,
            new { command.DataBreachId },
            cancellationToken: cancellationToken));

        return (WriteResult.Success, item);
    }

    public static async Task<WriteResult> DeleteAsync(
        DeleteCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string deleteSql = """
            UPDATE [Persone].[DataBreach]
            SET DataCancellazione = @Now,
                CancellatoDa = @ActorInt,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE DataBreachId = @DataBreachId
              AND DataCancellazione IS NULL;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var now = DateTime.UtcNow;
        var actorRaw = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actorRaw, out var parsedActor) ? parsedActor : 0;

        var rows = await connection.ExecuteAsync(new CommandDefinition(
            deleteSql,
            new { command.DataBreachId, Now = now, ActorInt = actorInt },
            cancellationToken: cancellationToken));

        return rows == 0 ? WriteResult.NotFound : WriteResult.Success;
    }
}

