using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaIndirizzi;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFound,
        Duplicate,
        InvalidTipoIndirizzo
    }

    public static async Task<IReadOnlyList<IndirizzoDto>?> ListAsync(
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
                i.IndirizzoId,
                i.UnitaOrganizzativaId,
                i.TipoIndirizzoId,
                i.ComuneId,
                i.Indirizzo,
                i.NumeroCivico,
                i.CAP,
                i.Localita,
                i.Presso,
                i.Latitudine,
                i.Longitudine,
                i.Piano,
                i.Interno,
                i.Edificio,
                i.ZonaIndustriale,
                CAST(i.DataInizio AS datetime2) AS DataInizio,
                CAST(i.DataFine AS datetime2) AS DataFine,
                i.Principale
            FROM [Organizzazioni].[IndirizzoUnitaOrganizzativa] i
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = i.UnitaOrganizzativaId
            WHERE u.OrganizzazioneId = @OrganizzazioneId
              AND i.DataCancellazione IS NULL
              AND u.DataCancellazione IS NULL
              AND (i.DataInizioValidita IS NULL OR i.DataInizioValidita <= SYSUTCDATETIME())
              AND (i.DataFineValidita IS NULL OR i.DataFineValidita >= SYSUTCDATETIME())
              AND (u.DataInizioValidita IS NULL OR u.DataInizioValidita <= SYSUTCDATETIME())
              AND (u.DataFineValidita IS NULL OR u.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY i.Principale DESC, i.IndirizzoId DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(orgExistsSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return null;
        }

        var rows = (await connection.QueryAsync<IndirizzoDto>(
            new CommandDefinition(listSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();
        return rows;
    }

    public static async Task<(WriteResult Result, IndirizzoDto? Item)> CreateAsync(
        CreateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[IndirizzoUnitaOrganizzativa] i
            WHERE i.UnitaOrganizzativaId = @UnitaOrganizzativaId
              AND i.TipoIndirizzoId = @TipoIndirizzoId
              AND i.Indirizzo = @Indirizzo
              AND ISNULL(i.NumeroCivico, '') = ISNULL(@NumeroCivico, '')
              AND ISNULL(i.CAP, '') = ISNULL(@CAP, '')
              AND i.DataCancellazione IS NULL
              AND (i.DataInizioValidita IS NULL OR i.DataInizioValidita <= SYSUTCDATETIME())
              AND (i.DataFineValidita IS NULL OR i.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string clearPrincipaleSql = """
            UPDATE [Organizzazioni].[IndirizzoUnitaOrganizzativa]
            SET Principale = CAST(0 AS bit),
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE UnitaOrganizzativaId = @UnitaOrganizzativaId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME())
              AND Principale = CAST(1 AS bit);
            """;

        const string insertSql = """
            DECLARE @newIds TABLE (Id int);

            INSERT INTO [Organizzazioni].[IndirizzoUnitaOrganizzativa]
                ([UnitaOrganizzativaId], [TipoIndirizzoId], [ComuneId], [Indirizzo], [NumeroCivico], [CAP], [Localita], [Presso], [Latitudine], [Longitudine], [Piano], [Interno], [Edificio], [ZonaIndustriale], [DataInizio], [DataFine], [Principale], [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa], [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.IndirizzoId INTO @newIds(Id)
            VALUES
                (@UnitaOrganizzativaId, @TipoIndirizzoId, @ComuneId, @Indirizzo, @NumeroCivico, @CAP, @Localita, @Presso, @Latitudine, @Longitudine, @Piano, @Interno, @Edificio, @ZonaIndustriale, @DataInizio, @DataFine, @Principale, @Now, @ActorInt, @Now, @ActorInt, @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                i.IndirizzoId,
                i.UnitaOrganizzativaId,
                i.TipoIndirizzoId,
                i.ComuneId,
                i.Indirizzo,
                i.NumeroCivico,
                i.CAP,
                i.Localita,
                i.Presso,
                i.Latitudine,
                i.Longitudine,
                i.Piano,
                i.Interno,
                i.Edificio,
                i.ZonaIndustriale,
                CAST(i.DataInizio AS datetime2) AS DataInizio,
                CAST(i.DataFine AS datetime2) AS DataFine,
                i.Principale
            FROM [Organizzazioni].[IndirizzoUnitaOrganizzativa] i
            WHERE i.IndirizzoId = @Id
              AND i.DataCancellazione IS NULL
              AND (i.DataInizioValidita IS NULL OR i.DataInizioValidita <= SYSUTCDATETIME())
              AND (i.DataFineValidita IS NULL OR i.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await UnitBelongsToOrgAsync(connection, command.OrganizzazioneId, command.Request.UnitaOrganizzativaId, cancellationToken))
        {
            return (WriteResult.NotFound, null);
        }

        if (!await TipoIndirizzoExistsAsync(connection, command.Request.TipoIndirizzoId, cancellationToken))
        {
            return (WriteResult.InvalidTipoIndirizzo, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new
            {
                command.Request.UnitaOrganizzativaId,
                command.Request.TipoIndirizzoId,
                Indirizzo = command.Request.Indirizzo.Trim(),
                NumeroCivico = string.IsNullOrWhiteSpace(command.Request.NumeroCivico) ? null : command.Request.NumeroCivico.Trim(),
                CAP = string.IsNullOrWhiteSpace(command.Request.CAP) ? null : command.Request.CAP.Trim()
            },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);
        var dataInizio = (command.Request.DataInizio ?? now).Date;
        var dataFine = command.Request.DataFine?.Date;

        await using var tx = await connection.BeginTransactionAsync(cancellationToken);
        if (command.Request.Principale)
        {
            await connection.ExecuteAsync(new CommandDefinition(
                clearPrincipaleSql,
                new { command.Request.UnitaOrganizzativaId, Now = now, ActorInt = actorInt },
                tx,
                cancellationToken: cancellationToken));
        }

        var id = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            insertSql,
            new
            {
                command.Request.UnitaOrganizzativaId,
                command.Request.TipoIndirizzoId,
                command.Request.ComuneId,
                Indirizzo = command.Request.Indirizzo.Trim(),
                NumeroCivico = string.IsNullOrWhiteSpace(command.Request.NumeroCivico) ? null : command.Request.NumeroCivico.Trim(),
                CAP = string.IsNullOrWhiteSpace(command.Request.CAP) ? null : command.Request.CAP.Trim(),
                Localita = string.IsNullOrWhiteSpace(command.Request.Localita) ? null : command.Request.Localita.Trim(),
                Presso = string.IsNullOrWhiteSpace(command.Request.Presso) ? null : command.Request.Presso.Trim(),
                command.Request.Latitudine,
                command.Request.Longitudine,
                Piano = string.IsNullOrWhiteSpace(command.Request.Piano) ? null : command.Request.Piano.Trim(),
                Interno = string.IsNullOrWhiteSpace(command.Request.Interno) ? null : command.Request.Interno.Trim(),
                Edificio = string.IsNullOrWhiteSpace(command.Request.Edificio) ? null : command.Request.Edificio.Trim(),
                ZonaIndustriale = string.IsNullOrWhiteSpace(command.Request.ZonaIndustriale) ? null : command.Request.ZonaIndustriale.Trim(),
                DataInizio = dataInizio,
                DataFine = dataFine,
                command.Request.Principale,
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<IndirizzoDto>(new CommandDefinition(
            byIdSql,
            new { Id = id },
            tx,
            cancellationToken: cancellationToken));

        await tx.CommitAsync(cancellationToken);
        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, IndirizzoDto? Item)> UpdateAsync(
        UpdateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string existsSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[IndirizzoUnitaOrganizzativa] i
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = i.UnitaOrganizzativaId
            WHERE i.IndirizzoId = @IndirizzoId
              AND u.OrganizzazioneId = @OrganizzazioneId
              AND i.DataCancellazione IS NULL
              AND u.DataCancellazione IS NULL;
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[IndirizzoUnitaOrganizzativa] i
            WHERE i.IndirizzoId <> @IndirizzoId
              AND i.UnitaOrganizzativaId = @UnitaOrganizzativaId
              AND i.TipoIndirizzoId = @TipoIndirizzoId
              AND i.Indirizzo = @Indirizzo
              AND ISNULL(i.NumeroCivico, '') = ISNULL(@NumeroCivico, '')
              AND ISNULL(i.CAP, '') = ISNULL(@CAP, '')
              AND i.DataCancellazione IS NULL
              AND (i.DataInizioValidita IS NULL OR i.DataInizioValidita <= SYSUTCDATETIME())
              AND (i.DataFineValidita IS NULL OR i.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string clearPrincipaleSql = """
            UPDATE [Organizzazioni].[IndirizzoUnitaOrganizzativa]
            SET Principale = CAST(0 AS bit),
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE UnitaOrganizzativaId = @UnitaOrganizzativaId
              AND IndirizzoId <> @IndirizzoId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME())
              AND Principale = CAST(1 AS bit);
            """;

        const string updateSql = """
            UPDATE [Organizzazioni].[IndirizzoUnitaOrganizzativa]
            SET UnitaOrganizzativaId = @UnitaOrganizzativaId,
                TipoIndirizzoId = @TipoIndirizzoId,
                ComuneId = @ComuneId,
                Indirizzo = @Indirizzo,
                NumeroCivico = @NumeroCivico,
                CAP = @CAP,
                Localita = @Localita,
                Presso = @Presso,
                Latitudine = @Latitudine,
                Longitudine = @Longitudine,
                Piano = @Piano,
                Interno = @Interno,
                Edificio = @Edificio,
                ZonaIndustriale = @ZonaIndustriale,
                DataInizio = @DataInizio,
                DataFine = @DataFine,
                Principale = @Principale,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE IndirizzoId = @IndirizzoId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        const string byIdSql = """
            SELECT
                i.IndirizzoId,
                i.UnitaOrganizzativaId,
                i.TipoIndirizzoId,
                i.ComuneId,
                i.Indirizzo,
                i.NumeroCivico,
                i.CAP,
                i.Localita,
                i.Presso,
                i.Latitudine,
                i.Longitudine,
                i.Piano,
                i.Interno,
                i.Edificio,
                i.ZonaIndustriale,
                CAST(i.DataInizio AS datetime2) AS DataInizio,
                CAST(i.DataFine AS datetime2) AS DataFine,
                i.Principale
            FROM [Organizzazioni].[IndirizzoUnitaOrganizzativa] i
            WHERE i.IndirizzoId = @IndirizzoId
              AND i.DataCancellazione IS NULL
              AND (i.DataInizioValidita IS NULL OR i.DataInizioValidita <= SYSUTCDATETIME())
              AND (i.DataFineValidita IS NULL OR i.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            existsSql,
            new { command.IndirizzoId, command.OrganizzazioneId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        if (!await UnitBelongsToOrgAsync(connection, command.OrganizzazioneId, command.Request.UnitaOrganizzativaId, cancellationToken))
        {
            return (WriteResult.NotFound, null);
        }

        if (!await TipoIndirizzoExistsAsync(connection, command.Request.TipoIndirizzoId, cancellationToken))
        {
            return (WriteResult.InvalidTipoIndirizzo, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new
            {
                command.IndirizzoId,
                command.Request.UnitaOrganizzativaId,
                command.Request.TipoIndirizzoId,
                Indirizzo = command.Request.Indirizzo.Trim(),
                NumeroCivico = string.IsNullOrWhiteSpace(command.Request.NumeroCivico) ? null : command.Request.NumeroCivico.Trim(),
                CAP = string.IsNullOrWhiteSpace(command.Request.CAP) ? null : command.Request.CAP.Trim()
            },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        var dataInizio = (command.Request.DataInizio ?? now).Date;
        var dataFine = command.Request.DataFine?.Date;

        await using var tx = await connection.BeginTransactionAsync(cancellationToken);
        if (command.Request.Principale)
        {
            await connection.ExecuteAsync(new CommandDefinition(
                clearPrincipaleSql,
                new { command.Request.UnitaOrganizzativaId, command.IndirizzoId, Now = now, ActorInt = actorInt },
                tx,
                cancellationToken: cancellationToken));
        }

        await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new
            {
                command.IndirizzoId,
                command.Request.UnitaOrganizzativaId,
                command.Request.TipoIndirizzoId,
                command.Request.ComuneId,
                Indirizzo = command.Request.Indirizzo.Trim(),
                NumeroCivico = string.IsNullOrWhiteSpace(command.Request.NumeroCivico) ? null : command.Request.NumeroCivico.Trim(),
                CAP = string.IsNullOrWhiteSpace(command.Request.CAP) ? null : command.Request.CAP.Trim(),
                Localita = string.IsNullOrWhiteSpace(command.Request.Localita) ? null : command.Request.Localita.Trim(),
                Presso = string.IsNullOrWhiteSpace(command.Request.Presso) ? null : command.Request.Presso.Trim(),
                command.Request.Latitudine,
                command.Request.Longitudine,
                Piano = string.IsNullOrWhiteSpace(command.Request.Piano) ? null : command.Request.Piano.Trim(),
                Interno = string.IsNullOrWhiteSpace(command.Request.Interno) ? null : command.Request.Interno.Trim(),
                Edificio = string.IsNullOrWhiteSpace(command.Request.Edificio) ? null : command.Request.Edificio.Trim(),
                ZonaIndustriale = string.IsNullOrWhiteSpace(command.Request.ZonaIndustriale) ? null : command.Request.ZonaIndustriale.Trim(),
                DataInizio = dataInizio,
                DataFine = dataFine,
                command.Request.Principale,
                Now = now,
                ActorInt = actorInt
            },
            tx,
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<IndirizzoDto>(new CommandDefinition(
            byIdSql,
            new { command.IndirizzoId },
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
        const string deleteSql = """
            UPDATE i
            SET i.DataCancellazione = @Now,
                i.CancellatoDa = @ActorInt,
                i.DataModifica = @Now,
                i.ModificatoDa = @ActorInt,
                i.DataFineValidita = @Now
            FROM [Organizzazioni].[IndirizzoUnitaOrganizzativa] i
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = i.UnitaOrganizzativaId
            WHERE i.IndirizzoId = @IndirizzoId
              AND u.OrganizzazioneId = @OrganizzazioneId
              AND i.DataCancellazione IS NULL
              AND u.DataCancellazione IS NULL;
            """;

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(
            deleteSql,
            new
            {
                command.IndirizzoId,
                command.OrganizzazioneId,
                Now = now,
                ActorInt = actorInt
            },
            cancellationToken: cancellationToken));
        return rows == 0 ? WriteResult.NotFound : WriteResult.Success;
    }

    private static async Task<bool> UnitBelongsToOrgAsync(
        System.Data.Common.DbConnection connection,
        int organizzazioneId,
        int unitaOrganizzativaId,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[UnitaOrganizzativa] u
            WHERE u.OrganizzazioneId = @OrganizzazioneId
              AND u.UnitaOrganizzativaId = @UnitaOrganizzativaId
              AND u.DataCancellazione IS NULL
              AND (u.DataInizioValidita IS NULL OR u.DataInizioValidita <= SYSUTCDATETIME())
              AND (u.DataFineValidita IS NULL OR u.DataFineValidita >= SYSUTCDATETIME());
            """;

        var count = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            sql,
            new { OrganizzazioneId = organizzazioneId, UnitaOrganizzativaId = unitaOrganizzativaId },
            cancellationToken: cancellationToken));
        return count > 0;
    }

    private static async Task<bool> TipoIndirizzoExistsAsync(
        System.Data.Common.DbConnection connection,
        int tipoIndirizzoId,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoIndirizzo] t
            WHERE t.TipoIndirizzoId = @TipoIndirizzoId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        var count = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            sql,
            new { TipoIndirizzoId = tipoIndirizzoId },
            cancellationToken: cancellationToken));
        return count > 0;
    }
}
