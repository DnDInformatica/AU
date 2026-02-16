using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.RegistroTrattamenti;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFound,
        DuplicateCodice,
        InvalidTipoFinalitaTrattamento,
        InvalidResponsabileTrattamento
    }

    public static async Task<IReadOnlyList<TipoFinalitaLookupItem>> LookupsAsync(
        LookupsCommand _,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                t.TipoFinalitaTrattamentoId AS Id,
                t.Codice AS Code,
                t.Descrizione AS [Description],
                t.Categoria AS Category
            FROM [Tipologica].[TipoFinalitaTrattamento] t
            WHERE t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY t.Ordine ASC, t.Descrizione ASC, t.Codice ASC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return (await connection.QueryAsync<TipoFinalitaLookupItem>(new CommandDefinition(
            sql, cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<IReadOnlyList<RegistroTrattamentiDto>> ListAsync(
        ListCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                r.RegistroTrattamentiId,
                r.Codice,
                r.NomeTrattamento,
                r.Descrizione,
                r.TipoFinalitaTrattamentoId,
                r.BaseGiuridica,
                r.CategorieDati,
                r.CategorieInteressati,
                r.DatiParticolari,
                r.DatiGiudiziari,
                r.CategorieDestinatari,
                r.TrasferimentoExtraUE,
                r.PaesiExtraUE,
                r.GaranzieExtraUE,
                r.TermineConservazione,
                r.TermineConservazioneGiorni,
                r.MisureSicurezza,
                r.ResponsabileTrattamentoId,
                r.ContitolareId,
                r.DPONotificato,
                r.Stato,
                r.DataInizioTrattamento,
                r.DataFineTrattamento,
                r.DataCancellazione
            FROM [Persone].[RegistroTrattamenti] r
            WHERE (@IncludeDeleted = 1 OR r.DataCancellazione IS NULL)
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY r.DataInizioTrattamento DESC, r.RegistroTrattamentiId DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return (await connection.QueryAsync<RegistroTrattamentiDto>(new CommandDefinition(
            sql,
            new { IncludeDeleted = command.IncludeDeleted ? 1 : 0 },
            cancellationToken: cancellationToken))).ToList();
    }

    public static async Task<RegistroTrattamentiDto?> GetByIdAsync(
        GetByIdCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT
                r.RegistroTrattamentiId,
                r.Codice,
                r.NomeTrattamento,
                r.Descrizione,
                r.TipoFinalitaTrattamentoId,
                r.BaseGiuridica,
                r.CategorieDati,
                r.CategorieInteressati,
                r.DatiParticolari,
                r.DatiGiudiziari,
                r.CategorieDestinatari,
                r.TrasferimentoExtraUE,
                r.PaesiExtraUE,
                r.GaranzieExtraUE,
                r.TermineConservazione,
                r.TermineConservazioneGiorni,
                r.MisureSicurezza,
                r.ResponsabileTrattamentoId,
                r.ContitolareId,
                r.DPONotificato,
                r.Stato,
                r.DataInizioTrattamento,
                r.DataFineTrattamento,
                r.DataCancellazione
            FROM [Persone].[RegistroTrattamenti] r
            WHERE r.RegistroTrattamentiId = @RegistroTrattamentiId
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        return await connection.QuerySingleOrDefaultAsync<RegistroTrattamentiDto>(new CommandDefinition(
            sql,
            new { command.RegistroTrattamentiId },
            cancellationToken: cancellationToken));
    }

    public static async Task<(WriteResult Result, RegistroTrattamentiDto? Item)> CreateAsync(
        CreateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string finalitaExistsSql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoFinalitaTrattamento] t
            WHERE t.TipoFinalitaTrattamentoId = @TipoFinalitaTrattamentoId
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
            FROM [Persone].[RegistroTrattamenti] r
            WHERE r.Codice = @Codice
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string insertSql = """
            DECLARE @newIds TABLE (Id int);

            INSERT INTO [Persone].[RegistroTrattamenti]
                ([Codice], [NomeTrattamento], [Descrizione], [TipoFinalitaTrattamentoId], [BaseGiuridica],
                 [CategorieDati], [CategorieInteressati], [DatiParticolari], [DatiGiudiziari], [CategorieDestinatari],
                 [TrasferimentoExtraUE], [PaesiExtraUE], [GaranzieExtraUE], [TermineConservazione], [TermineConservazioneGiorni],
                 [MisureSicurezza], [ResponsabileTrattamentoId], [ContitolareId], [DPONotificato], [Stato],
                 [DataInizioTrattamento], [DataFineTrattamento],
                 [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa],
                 [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.RegistroTrattamentiId INTO @newIds(Id)
            VALUES
                (@Codice, @NomeTrattamento, @Descrizione, @TipoFinalitaTrattamentoId, @BaseGiuridica,
                 @CategorieDati, @CategorieInteressati, @DatiParticolari, @DatiGiudiziari, @CategorieDestinatari,
                 @TrasferimentoExtraUE, @PaesiExtraUE, @GaranzieExtraUE, @TermineConservazione, @TermineConservazioneGiorni,
                 @MisureSicurezza, @ResponsabileTrattamentoId, @ContitolareId, @DPONotificato, @Stato,
                 @DataInizioTrattamento, @DataFineTrattamento,
                 @Now, @ActorInt, @Now, @ActorInt,
                 @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                r.RegistroTrattamentiId,
                r.Codice,
                r.NomeTrattamento,
                r.Descrizione,
                r.TipoFinalitaTrattamentoId,
                r.BaseGiuridica,
                r.CategorieDati,
                r.CategorieInteressati,
                r.DatiParticolari,
                r.DatiGiudiziari,
                r.CategorieDestinatari,
                r.TrasferimentoExtraUE,
                r.PaesiExtraUE,
                r.GaranzieExtraUE,
                r.TermineConservazione,
                r.TermineConservazioneGiorni,
                r.MisureSicurezza,
                r.ResponsabileTrattamentoId,
                r.ContitolareId,
                r.DPONotificato,
                r.Stato,
                r.DataInizioTrattamento,
                r.DataFineTrattamento,
                r.DataCancellazione
            FROM [Persone].[RegistroTrattamenti] r
            WHERE r.RegistroTrattamentiId = @RegistroTrattamentiId
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var finalitaExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            finalitaExistsSql,
            new { command.Request.TipoFinalitaTrattamentoId },
            cancellationToken: cancellationToken));
        if (finalitaExists == 0)
        {
            return (WriteResult.InvalidTipoFinalitaTrattamento, null);
        }

        if (command.Request.ResponsabileTrattamentoId is not null)
        {
            var responsabileExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
                personaExistsSql,
                new { PersonaId = command.Request.ResponsabileTrattamentoId.Value },
                cancellationToken: cancellationToken));
            if (responsabileExists == 0)
            {
                return (WriteResult.InvalidResponsabileTrattamento, null);
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
                NomeTrattamento = command.Request.NomeTrattamento.Trim(),
                command.Request.Descrizione,
                command.Request.TipoFinalitaTrattamentoId,
                BaseGiuridica = command.Request.BaseGiuridica.Trim(),
                CategorieDati = command.Request.CategorieDati.Trim(),
                CategorieInteressati = command.Request.CategorieInteressati.Trim(),
                command.Request.DatiParticolari,
                command.Request.DatiGiudiziari,
                command.Request.CategorieDestinatari,
                command.Request.TrasferimentoExtraUE,
                command.Request.PaesiExtraUE,
                command.Request.GaranzieExtraUE,
                TermineConservazione = command.Request.TermineConservazione.Trim(),
                command.Request.TermineConservazioneGiorni,
                command.Request.MisureSicurezza,
                command.Request.ResponsabileTrattamentoId,
                command.Request.ContitolareId,
                command.Request.DPONotificato,
                Stato = command.Request.Stato.Trim(),
                DataInizioTrattamento = command.Request.DataInizioTrattamento.Date,
                DataFineTrattamento = command.Request.DataFineTrattamento?.Date,
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<RegistroTrattamentiDto>(new CommandDefinition(
            byIdSql,
            new { RegistroTrattamentiId = newId },
            cancellationToken: cancellationToken));

        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, RegistroTrattamentiDto? Item)> UpdateAsync(
        UpdateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string existsSql = """
            SELECT COUNT(1)
            FROM [Persone].[RegistroTrattamenti] r
            WHERE r.RegistroTrattamentiId = @RegistroTrattamentiId
              AND r.DataCancellazione IS NULL;
            """;

        const string finalitaExistsSql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoFinalitaTrattamento] t
            WHERE t.TipoFinalitaTrattamentoId = @TipoFinalitaTrattamentoId
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
            FROM [Persone].[RegistroTrattamenti] r
            WHERE r.RegistroTrattamentiId <> @RegistroTrattamentiId
              AND r.Codice = @Codice
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string updateSql = """
            UPDATE [Persone].[RegistroTrattamenti]
            SET Codice = @Codice,
                NomeTrattamento = @NomeTrattamento,
                Descrizione = @Descrizione,
                TipoFinalitaTrattamentoId = @TipoFinalitaTrattamentoId,
                BaseGiuridica = @BaseGiuridica,
                CategorieDati = @CategorieDati,
                CategorieInteressati = @CategorieInteressati,
                DatiParticolari = @DatiParticolari,
                DatiGiudiziari = @DatiGiudiziari,
                CategorieDestinatari = @CategorieDestinatari,
                TrasferimentoExtraUE = @TrasferimentoExtraUE,
                PaesiExtraUE = @PaesiExtraUE,
                GaranzieExtraUE = @GaranzieExtraUE,
                TermineConservazione = @TermineConservazione,
                TermineConservazioneGiorni = @TermineConservazioneGiorni,
                MisureSicurezza = @MisureSicurezza,
                ResponsabileTrattamentoId = @ResponsabileTrattamentoId,
                ContitolareId = @ContitolareId,
                DPONotificato = @DPONotificato,
                Stato = @Stato,
                DataInizioTrattamento = @DataInizioTrattamento,
                DataFineTrattamento = @DataFineTrattamento,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE RegistroTrattamentiId = @RegistroTrattamentiId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string byIdSql = """
            SELECT
                r.RegistroTrattamentiId,
                r.Codice,
                r.NomeTrattamento,
                r.Descrizione,
                r.TipoFinalitaTrattamentoId,
                r.BaseGiuridica,
                r.CategorieDati,
                r.CategorieInteressati,
                r.DatiParticolari,
                r.DatiGiudiziari,
                r.CategorieDestinatari,
                r.TrasferimentoExtraUE,
                r.PaesiExtraUE,
                r.GaranzieExtraUE,
                r.TermineConservazione,
                r.TermineConservazioneGiorni,
                r.MisureSicurezza,
                r.ResponsabileTrattamentoId,
                r.ContitolareId,
                r.DPONotificato,
                r.Stato,
                r.DataInizioTrattamento,
                r.DataFineTrattamento,
                r.DataCancellazione
            FROM [Persone].[RegistroTrattamenti] r
            WHERE r.RegistroTrattamentiId = @RegistroTrattamentiId
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            existsSql,
            new { command.RegistroTrattamentiId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        var finalitaExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            finalitaExistsSql,
            new { command.Request.TipoFinalitaTrattamentoId },
            cancellationToken: cancellationToken));
        if (finalitaExists == 0)
        {
            return (WriteResult.InvalidTipoFinalitaTrattamento, null);
        }

        if (command.Request.ResponsabileTrattamentoId is not null)
        {
            var responsabileExists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
                personaExistsSql,
                new { PersonaId = command.Request.ResponsabileTrattamentoId.Value },
                cancellationToken: cancellationToken));
            if (responsabileExists == 0)
            {
                return (WriteResult.InvalidResponsabileTrattamento, null);
            }
        }

        var codice = command.Request.Codice.Trim();
        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateCodiceSql,
            new { command.RegistroTrattamentiId, Codice = codice },
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
                command.RegistroTrattamentiId,
                Codice = codice,
                NomeTrattamento = command.Request.NomeTrattamento.Trim(),
                command.Request.Descrizione,
                command.Request.TipoFinalitaTrattamentoId,
                BaseGiuridica = command.Request.BaseGiuridica.Trim(),
                CategorieDati = command.Request.CategorieDati.Trim(),
                CategorieInteressati = command.Request.CategorieInteressati.Trim(),
                command.Request.DatiParticolari,
                command.Request.DatiGiudiziari,
                command.Request.CategorieDestinatari,
                command.Request.TrasferimentoExtraUE,
                command.Request.PaesiExtraUE,
                command.Request.GaranzieExtraUE,
                TermineConservazione = command.Request.TermineConservazione.Trim(),
                command.Request.TermineConservazioneGiorni,
                command.Request.MisureSicurezza,
                command.Request.ResponsabileTrattamentoId,
                command.Request.ContitolareId,
                command.Request.DPONotificato,
                Stato = command.Request.Stato.Trim(),
                DataInizioTrattamento = command.Request.DataInizioTrattamento.Date,
                DataFineTrattamento = command.Request.DataFineTrattamento?.Date,
                Now = now,
                ActorInt = actorInt
            },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<RegistroTrattamentiDto>(new CommandDefinition(
            byIdSql,
            new { command.RegistroTrattamentiId },
            cancellationToken: cancellationToken));

        return (WriteResult.Success, item);
    }

    public static async Task<WriteResult> DeleteAsync(
        DeleteCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string deleteSql = """
            UPDATE [Persone].[RegistroTrattamenti]
            SET DataCancellazione = @Now,
                CancellatoDa = @ActorInt,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE RegistroTrattamentiId = @RegistroTrattamentiId
              AND DataCancellazione IS NULL;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var now = DateTime.UtcNow;
        var actorRaw = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();
        var actorInt = int.TryParse(actorRaw, out var parsedActor) ? parsedActor : 0;

        var rows = await connection.ExecuteAsync(new CommandDefinition(
            deleteSql,
            new { command.RegistroTrattamentiId, Now = now, ActorInt = actorInt },
            cancellationToken: cancellationToken));

        return rows == 0 ? WriteResult.NotFound : WriteResult.Success;
    }
}

