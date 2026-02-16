using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediLink;

internal static class Handler
{
    internal enum LinkResult
    {
        Created,
        NotFoundOrganizzazione,
        InvalidTipoOrganizzazioneSede
    }

    internal enum UnlinkResult
    {
        Deleted,
        NotFound
    }

    public static async Task<IReadOnlyList<OrganizzazioneSedeLinkDto>?> ListAsync(
        ListCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

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
                os.OrganizzazioneSedeId,
                os.OrganizzazioneId,
                os.TipoOrganizzazioneSedeId,
                os.Denominazione,
                os.Insegna,
                os.DataApertura,
                os.DataCessazioneUL,
                os.DataDenunciaCessazione,
                os.DataCancellazione
            FROM [Organizzazioni].[OrganizzazioneSede] os
            WHERE os.OrganizzazioneId = @OrganizzazioneId
              AND os.DataCancellazione IS NULL
              AND (os.DataInizioValidita IS NULL OR os.DataInizioValidita <= SYSUTCDATETIME())
              AND (os.DataFineValidita IS NULL OR os.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY os.DataApertura DESC, os.OrganizzazioneSedeId DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(orgExistsSql, new { OrganizzazioneId = command.OrganizzazioneId }, cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return null;
        }

        var rows = (await connection.QueryAsync<OrganizzazioneSedeLinkDto>(
            new CommandDefinition(listSql, new { OrganizzazioneId = command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();
        return rows;
    }

    public static async Task<(LinkResult Result, OrganizzazioneSedeLinkDto? Item)> LinkAsync(
        LinkCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string orgExistsSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[Organizzazione] o
            WHERE o.OrganizzazioneId = @OrganizzazioneId
              AND o.DataCancellazione IS NULL
              AND (o.DataInizioValidita IS NULL OR o.DataInizioValidita <= SYSUTCDATETIME())
              AND (o.DataFineValidita IS NULL OR o.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string tipoExistsSql = """
            SELECT COUNT(1)
            FROM [Tipologica].[TipoOrganizzazioneSede] t
            WHERE t.TipoOrganizzazioneSedeId = @TipoOrganizzazioneSedeId
              AND t.DataCancellazione IS NULL
              AND (t.DataInizioValidita IS NULL OR t.DataInizioValidita <= SYSUTCDATETIME())
              AND (t.DataFineValidita IS NULL OR t.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string insertSql = """
            DECLARE @newIds TABLE (OrganizzazioneSedeId int);

            INSERT INTO [Organizzazioni].[OrganizzazioneSede]
                ([OrganizzazioneId], [TipoOrganizzazioneSedeId], [Denominazione], [Insegna], [DataApertura], [DescrizioneAttivita], [DataInizioAttivita], [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa], [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.OrganizzazioneSedeId INTO @newIds(OrganizzazioneSedeId)
            VALUES
                (@OrganizzazioneId, @TipoOrganizzazioneSedeId, @Denominazione, @Insegna, @DataApertura, @DescrizioneAttivita, @DataInizioAttivita, @Now, @ActorInt, @Now, @ActorInt, @UniqueRowId, @DataInizioValidita, @DataFineValidita);

            SELECT TOP (1) OrganizzazioneSedeId FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                os.OrganizzazioneSedeId,
                os.OrganizzazioneId,
                os.TipoOrganizzazioneSedeId,
                os.Denominazione,
                os.Insegna,
                os.DataApertura,
                os.DataCessazioneUL,
                os.DataDenunciaCessazione,
                os.DataCancellazione
            FROM [Organizzazioni].[OrganizzazioneSede] os
            WHERE os.OrganizzazioneSedeId = @OrganizzazioneSedeId
              AND os.OrganizzazioneId = @OrganizzazioneId
              AND os.DataCancellazione IS NULL
              AND (os.DataInizioValidita IS NULL OR os.DataInizioValidita <= SYSUTCDATETIME())
              AND (os.DataFineValidita IS NULL OR os.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

        var orgExists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(orgExistsSql, new { OrganizzazioneId = command.OrganizzazioneId }, cancellationToken: cancellationToken));
        if (orgExists == 0)
        {
            return (LinkResult.NotFoundOrganizzazione, null);
        }

        var tipoExists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(tipoExistsSql, new { command.Request.TipoOrganizzazioneSedeId }, cancellationToken: cancellationToken));
        if (tipoExists == 0)
        {
            return (LinkResult.InvalidTipoOrganizzazioneSede, null);
        }

        var now = DateTime.UtcNow;
        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;

        var newId = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            insertSql,
            new
            {
                OrganizzazioneId = command.OrganizzazioneId,
                TipoOrganizzazioneSedeId = command.Request.TipoOrganizzazioneSedeId,
                Denominazione = string.IsNullOrWhiteSpace(command.Request.Denominazione) ? null : command.Request.Denominazione.Trim(),
                Insegna = string.IsNullOrWhiteSpace(command.Request.Insegna) ? null : command.Request.Insegna.Trim(),
                command.Request.DataApertura,
                DescrizioneAttivita = string.IsNullOrWhiteSpace(command.Request.DescrizioneAttivita) ? null : command.Request.DescrizioneAttivita.Trim(),
                command.Request.DataInizioAttivita,
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataInizioValidita = now,
                DataFineValidita = fineValidita
            },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<OrganizzazioneSedeLinkDto>(new CommandDefinition(
            byIdSql,
            new { OrganizzazioneSedeId = newId, OrganizzazioneId = command.OrganizzazioneId },
            cancellationToken: cancellationToken));

        return (LinkResult.Created, item);
    }

    public static async Task<UnlinkResult> UnlinkAsync(
        UnlinkCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        const string unlinkSql = """
            UPDATE [Organizzazioni].[OrganizzazioneSede]
            SET DataCancellazione = @Now,
                CancellatoDa = @ActorInt,
                DataModifica = @Now,
                ModificatoDa = @ActorInt,
                DataFineValidita = @Now
            WHERE OrganizzazioneSedeId = @OrganizzazioneSedeId
              AND OrganizzazioneId = @OrganizzazioneId
              AND DataCancellazione IS NULL;
            """;

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(
            unlinkSql,
            new
            {
                command.OrganizzazioneSedeId,
                command.OrganizzazioneId,
                Now = now,
                ActorInt = actorInt
            },
            cancellationToken: cancellationToken));

        return rows == 0 ? UnlinkResult.NotFound : UnlinkResult.Deleted;
    }
}

