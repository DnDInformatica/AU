using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Poteri;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFound,
        Duplicate,
        InvalidTipoPotere
    }

    public static async Task<IReadOnlyList<PotereDto>?> ListAsync(
        ListCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string orgExistsSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[Organizzazione] o
            WHERE o.OrganizzazioneId = @OrganizzazioneId
              AND o.DataCancellazione IS NULL
              AND (o.DataInizioValidita IS NULL OR o.DataInizioValidita <= SYSUTCDATETIME())
              AND (o.DataFineValidita IS NULL OR o.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string listSql = """
            SELECT
                p.PotereId,
                p.IncaricoId,
                p.TipoPotereId,
                CAST(p.DataInizio AS datetime2) AS DataInizio,
                CAST(p.DataFine AS datetime2) AS DataFine,
                p.LimiteImportoSingolo,
                p.LimiteImportoGiornaliero,
                p.LimiteImportoMensile,
                p.LimiteImportoAnnuo,
                p.Valuta,
                p.ModalitaFirma,
                p.AmbitoTerritoriale,
                p.AmbitoMateriale,
                p.PuoDelegare,
                p.DelegatoDa,
                p.StatoPotere,
                CAST(p.DataRevoca AS datetime2) AS DataRevoca,
                p.MotivoRevoca,
                p.Note
            FROM [Organizzazioni].[Potere] p
            INNER JOIN [Organizzazioni].[Incarico] i ON i.IncaricoId = p.IncaricoId
            LEFT JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = i.UnitaOrganizzativaId
            WHERE (i.OrganizzazioneId = @OrganizzazioneId OR u.OrganizzazioneId = @OrganizzazioneId)
              AND p.DataCancellazione IS NULL
              AND i.DataCancellazione IS NULL
              AND (p.DataInizioValidita IS NULL OR p.DataInizioValidita <= SYSUTCDATETIME())
              AND (p.DataFineValidita IS NULL OR p.DataFineValidita >= SYSUTCDATETIME())
              AND (i.DataInizioValidita IS NULL OR i.DataInizioValidita <= SYSUTCDATETIME())
              AND (i.DataFineValidita IS NULL OR i.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY p.PotereId DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(orgExistsSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return null;
        }

        var rows = (await connection.QueryAsync<PotereDto>(
            new CommandDefinition(listSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();
        return rows;
    }

    public static async Task<(WriteResult Result, PotereDto? Item)> CreateAsync(
        CreateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[Potere] p
            WHERE p.IncaricoId = @IncaricoId
              AND p.TipoPotereId = @TipoPotereId
              AND p.DataInizio = @DataInizio
              AND p.DataCancellazione IS NULL
              AND (p.DataInizioValidita IS NULL OR p.DataInizioValidita <= SYSUTCDATETIME())
              AND (p.DataFineValidita IS NULL OR p.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string insertSql = """
            DECLARE @newIds TABLE (Id int);

            INSERT INTO [Organizzazioni].[Potere]
                ([IncaricoId], [TipoPotereId], [DataInizio], [DataFine], [LimiteImportoSingolo], [LimiteImportoGiornaliero], [LimiteImportoMensile], [LimiteImportoAnnuo], [Valuta], [ModalitaFirma], [AmbitoTerritoriale], [AmbitoMateriale], [PuoDelegare], [DelegatoDa], [StatoPotere], [DataRevoca], [MotivoRevoca], [Note], [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa], [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.PotereId INTO @newIds(Id)
            VALUES
                (@IncaricoId, @TipoPotereId, @DataInizio, @DataFine, @LimiteImportoSingolo, @LimiteImportoGiornaliero, @LimiteImportoMensile, @LimiteImportoAnnuo, @Valuta, @ModalitaFirma, @AmbitoTerritoriale, @AmbitoMateriale, @PuoDelegare, @DelegatoDa, @StatoPotere, @DataRevoca, @MotivoRevoca, @Note, @Now, @ActorInt, @Now, @ActorInt, @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                p.PotereId,
                p.IncaricoId,
                p.TipoPotereId,
                CAST(p.DataInizio AS datetime2) AS DataInizio,
                CAST(p.DataFine AS datetime2) AS DataFine,
                p.LimiteImportoSingolo,
                p.LimiteImportoGiornaliero,
                p.LimiteImportoMensile,
                p.LimiteImportoAnnuo,
                p.Valuta,
                p.ModalitaFirma,
                p.AmbitoTerritoriale,
                p.AmbitoMateriale,
                p.PuoDelegare,
                p.DelegatoDa,
                p.StatoPotere,
                CAST(p.DataRevoca AS datetime2) AS DataRevoca,
                p.MotivoRevoca,
                p.Note
            FROM [Organizzazioni].[Potere] p
            WHERE p.PotereId = @Id
              AND p.DataCancellazione IS NULL
              AND (p.DataInizioValidita IS NULL OR p.DataInizioValidita <= SYSUTCDATETIME())
              AND (p.DataFineValidita IS NULL OR p.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await IncaricoBelongsToOrgAsync(connection, command.OrganizzazioneId, command.Request.IncaricoId, cancellationToken))
        {
            return (WriteResult.NotFound, null);
        }

        if (!await TipoPotereExistsAsync(connection, command.Request.TipoPotereId, cancellationToken))
        {
            return (WriteResult.InvalidTipoPotere, null);
        }

        var now = DateTime.UtcNow;
        var dataInizio = (command.Request.DataInizio ?? now).Date;
        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.Request.IncaricoId, command.Request.TipoPotereId, DataInizio = dataInizio },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);

        var id = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            insertSql,
            new
            {
                command.Request.IncaricoId,
                command.Request.TipoPotereId,
                DataInizio = dataInizio,
                DataFine = command.Request.DataFine?.Date,
                command.Request.LimiteImportoSingolo,
                command.Request.LimiteImportoGiornaliero,
                command.Request.LimiteImportoMensile,
                command.Request.LimiteImportoAnnuo,
                Valuta = string.IsNullOrWhiteSpace(command.Request.Valuta) ? "EUR" : command.Request.Valuta.Trim(),
                ModalitaFirma = string.IsNullOrWhiteSpace(command.Request.ModalitaFirma) ? null : command.Request.ModalitaFirma.Trim(),
                AmbitoTerritoriale = string.IsNullOrWhiteSpace(command.Request.AmbitoTerritoriale) ? null : command.Request.AmbitoTerritoriale.Trim(),
                AmbitoMateriale = string.IsNullOrWhiteSpace(command.Request.AmbitoMateriale) ? null : command.Request.AmbitoMateriale.Trim(),
                command.Request.PuoDelegare,
                command.Request.DelegatoDa,
                StatoPotere = string.IsNullOrWhiteSpace(command.Request.StatoPotere) ? "ATTIVO" : command.Request.StatoPotere.Trim(),
                DataRevoca = command.Request.DataRevoca?.Date,
                MotivoRevoca = string.IsNullOrWhiteSpace(command.Request.MotivoRevoca) ? null : command.Request.MotivoRevoca.Trim(),
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<PotereDto>(new CommandDefinition(
            byIdSql,
            new { Id = id },
            cancellationToken: cancellationToken));
        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, PotereDto? Item)> UpdateAsync(
        UpdateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string existsSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[Potere] p
            INNER JOIN [Organizzazioni].[Incarico] i ON i.IncaricoId = p.IncaricoId
            LEFT JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = i.UnitaOrganizzativaId
            WHERE p.PotereId = @PotereId
              AND (i.OrganizzazioneId = @OrganizzazioneId OR u.OrganizzazioneId = @OrganizzazioneId)
              AND p.DataCancellazione IS NULL
              AND i.DataCancellazione IS NULL;
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[Potere] p
            WHERE p.PotereId <> @PotereId
              AND p.IncaricoId = @IncaricoId
              AND p.TipoPotereId = @TipoPotereId
              AND p.DataInizio = @DataInizio
              AND p.DataCancellazione IS NULL
              AND (p.DataInizioValidita IS NULL OR p.DataInizioValidita <= SYSUTCDATETIME())
              AND (p.DataFineValidita IS NULL OR p.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string updateSql = """
            UPDATE [Organizzazioni].[Potere]
            SET IncaricoId = @IncaricoId,
                TipoPotereId = @TipoPotereId,
                DataInizio = @DataInizio,
                DataFine = @DataFine,
                LimiteImportoSingolo = @LimiteImportoSingolo,
                LimiteImportoGiornaliero = @LimiteImportoGiornaliero,
                LimiteImportoMensile = @LimiteImportoMensile,
                LimiteImportoAnnuo = @LimiteImportoAnnuo,
                Valuta = @Valuta,
                ModalitaFirma = @ModalitaFirma,
                AmbitoTerritoriale = @AmbitoTerritoriale,
                AmbitoMateriale = @AmbitoMateriale,
                PuoDelegare = @PuoDelegare,
                DelegatoDa = @DelegatoDa,
                StatoPotere = @StatoPotere,
                DataRevoca = @DataRevoca,
                MotivoRevoca = @MotivoRevoca,
                Note = @Note,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE PotereId = @PotereId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string byIdSql = """
            SELECT
                p.PotereId,
                p.IncaricoId,
                p.TipoPotereId,
                CAST(p.DataInizio AS datetime2) AS DataInizio,
                CAST(p.DataFine AS datetime2) AS DataFine,
                p.LimiteImportoSingolo,
                p.LimiteImportoGiornaliero,
                p.LimiteImportoMensile,
                p.LimiteImportoAnnuo,
                p.Valuta,
                p.ModalitaFirma,
                p.AmbitoTerritoriale,
                p.AmbitoMateriale,
                p.PuoDelegare,
                p.DelegatoDa,
                p.StatoPotere,
                CAST(p.DataRevoca AS datetime2) AS DataRevoca,
                p.MotivoRevoca,
                p.Note
            FROM [Organizzazioni].[Potere] p
            WHERE p.PotereId = @PotereId
              AND p.DataCancellazione IS NULL
              AND (p.DataInizioValidita IS NULL OR p.DataInizioValidita <= SYSUTCDATETIME())
              AND (p.DataFineValidita IS NULL OR p.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            existsSql,
            new { command.PotereId, command.OrganizzazioneId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        if (!await IncaricoBelongsToOrgAsync(connection, command.OrganizzazioneId, command.Request.IncaricoId, cancellationToken))
        {
            return (WriteResult.NotFound, null);
        }

        if (!await TipoPotereExistsAsync(connection, command.Request.TipoPotereId, cancellationToken))
        {
            return (WriteResult.InvalidTipoPotere, null);
        }

        var dataInizio = (command.Request.DataInizio ?? DateTime.UtcNow).Date;
        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.PotereId, command.Request.IncaricoId, command.Request.TipoPotereId, DataInizio = dataInizio },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;

        await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new
            {
                command.PotereId,
                command.Request.IncaricoId,
                command.Request.TipoPotereId,
                DataInizio = dataInizio,
                DataFine = command.Request.DataFine?.Date,
                command.Request.LimiteImportoSingolo,
                command.Request.LimiteImportoGiornaliero,
                command.Request.LimiteImportoMensile,
                command.Request.LimiteImportoAnnuo,
                Valuta = string.IsNullOrWhiteSpace(command.Request.Valuta) ? "EUR" : command.Request.Valuta.Trim(),
                ModalitaFirma = string.IsNullOrWhiteSpace(command.Request.ModalitaFirma) ? null : command.Request.ModalitaFirma.Trim(),
                AmbitoTerritoriale = string.IsNullOrWhiteSpace(command.Request.AmbitoTerritoriale) ? null : command.Request.AmbitoTerritoriale.Trim(),
                AmbitoMateriale = string.IsNullOrWhiteSpace(command.Request.AmbitoMateriale) ? null : command.Request.AmbitoMateriale.Trim(),
                command.Request.PuoDelegare,
                command.Request.DelegatoDa,
                StatoPotere = string.IsNullOrWhiteSpace(command.Request.StatoPotere) ? "ATTIVO" : command.Request.StatoPotere.Trim(),
                DataRevoca = command.Request.DataRevoca?.Date,
                MotivoRevoca = string.IsNullOrWhiteSpace(command.Request.MotivoRevoca) ? null : command.Request.MotivoRevoca.Trim(),
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                Now = now,
                ActorInt = actorInt
            },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<PotereDto>(new CommandDefinition(
            byIdSql,
            new { command.PotereId },
            cancellationToken: cancellationToken));
        return (WriteResult.Success, item);
    }

    public static async Task<WriteResult> DeleteAsync(
        DeleteCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string deleteSql = """
            UPDATE p
            SET p.DataCancellazione = @Now,
                p.CancellatoDa = @ActorInt,
                p.DataModifica = @Now,
                p.ModificatoDa = @ActorInt,
                p.DataFineValidita = @Now
            FROM [Organizzazioni].[Potere] p
            INNER JOIN [Organizzazioni].[Incarico] i ON i.IncaricoId = p.IncaricoId
            LEFT JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = i.UnitaOrganizzativaId
            WHERE p.PotereId = @PotereId
              AND (i.OrganizzazioneId = @OrganizzazioneId OR u.OrganizzazioneId = @OrganizzazioneId)
              AND p.DataCancellazione IS NULL
              AND i.DataCancellazione IS NULL;
            """;

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(
            deleteSql,
            new { command.PotereId, command.OrganizzazioneId, Now = now, ActorInt = actorInt },
            cancellationToken: cancellationToken));
        return rows == 0 ? WriteResult.NotFound : WriteResult.Success;
    }

    private static async Task<bool> IncaricoBelongsToOrgAsync(
        System.Data.Common.DbConnection connection,
        int organizzazioneId,
        int incaricoId,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[Incarico] i
            LEFT JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = i.UnitaOrganizzativaId
            WHERE i.IncaricoId = @IncaricoId
              AND (i.OrganizzazioneId = @OrganizzazioneId OR u.OrganizzazioneId = @OrganizzazioneId)
              AND i.DataCancellazione IS NULL
              AND (i.DataInizioValidita IS NULL OR i.DataInizioValidita <= SYSUTCDATETIME())
              AND (i.DataFineValidita IS NULL OR i.DataFineValidita >= SYSUTCDATETIME());
            """;

        var count = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            sql,
            new { OrganizzazioneId = organizzazioneId, IncaricoId = incaricoId },
            cancellationToken: cancellationToken));
        return count > 0;
    }

    private static async Task<bool> TipoPotereExistsAsync(
        System.Data.Common.DbConnection connection,
        int tipoPotereId,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoPotere] t
            WHERE t.TipoPotereId = @TipoPotereId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        var count = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            sql,
            new { TipoPotereId = tipoPotereId },
            cancellationToken: cancellationToken));
        return count > 0;
    }
}
