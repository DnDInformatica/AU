using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaRelazioni;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFound,
        Duplicate
    }

    private sealed record UnitOwnership(int UnitaOrganizzativaId);

    public static async Task<IReadOnlyList<UnitaRelazioneDto>?> ListAsync(
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
                r.UnitaRelazioneId,
                r.UnitaPadreId,
                r.UnitaFigliaId,
                r.TipoRelazioneId
            FROM [Organizzazioni].[UnitaRelazione] r
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] up ON up.UnitaOrganizzativaId = r.UnitaPadreId
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] uf ON uf.UnitaOrganizzativaId = r.UnitaFigliaId
            WHERE up.OrganizzazioneId = @OrganizzazioneId
              AND uf.OrganizzazioneId = @OrganizzazioneId
              AND r.DataCancellazione IS NULL
              AND up.DataCancellazione IS NULL
              AND uf.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME())
              AND (up.DataInizioValidita IS NULL OR up.DataInizioValidita <= SYSUTCDATETIME())
              AND (up.DataFineValidita IS NULL OR up.DataFineValidita >= SYSUTCDATETIME())
              AND (uf.DataInizioValidita IS NULL OR uf.DataInizioValidita <= SYSUTCDATETIME())
              AND (uf.DataFineValidita IS NULL OR uf.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY r.UnitaRelazioneId DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(orgExistsSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return null;
        }

        var rows = (await connection.QueryAsync<UnitaRelazioneDto>(
            new CommandDefinition(listSql, new { command.OrganizzazioneId }, cancellationToken: cancellationToken))).ToList();
        return rows;
    }

    public static async Task<(WriteResult Result, UnitaRelazioneDto? Item)> CreateAsync(
        CreateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[UnitaRelazione] r
            WHERE r.UnitaPadreId = @UnitaPadreId
              AND r.UnitaFigliaId = @UnitaFigliaId
              AND r.TipoRelazioneId = @TipoRelazioneId
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string insertSql = """
            DECLARE @newIds TABLE (Id int);

            INSERT INTO [Organizzazioni].[UnitaRelazione]
                ([UnitaPadreId], [UnitaFigliaId], [TipoRelazioneId], [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa], [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.UnitaRelazioneId INTO @newIds(Id)
            VALUES
                (@UnitaPadreId, @UnitaFigliaId, @TipoRelazioneId, @Now, @ActorInt, @Now, @ActorInt, @UniqueRowId, @Now, @DataFineValidita);

            SELECT TOP (1) Id FROM @newIds;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await UnitsBelongToOrgAsync(connection, command.OrganizzazioneId, [command.Request.UnitaPadreId, command.Request.UnitaFigliaId], cancellationToken))
        {
            return (WriteResult.NotFound, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new
            {
                command.Request.UnitaPadreId,
                command.Request.UnitaFigliaId,
                command.Request.TipoRelazioneId
            },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);

        var id = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            insertSql,
            new
            {
                command.Request.UnitaPadreId,
                command.Request.UnitaFigliaId,
                command.Request.TipoRelazioneId,
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            cancellationToken: cancellationToken));

        return (WriteResult.Success, new UnitaRelazioneDto(id, command.Request.UnitaPadreId, command.Request.UnitaFigliaId, command.Request.TipoRelazioneId));
    }

    public static async Task<(WriteResult Result, UnitaRelazioneDto? Item)> UpdateAsync(
        UpdateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string existsSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[UnitaRelazione] r
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] up ON up.UnitaOrganizzativaId = r.UnitaPadreId
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] uf ON uf.UnitaOrganizzativaId = r.UnitaFigliaId
            WHERE r.UnitaRelazioneId = @UnitaRelazioneId
              AND up.OrganizzazioneId = @OrganizzazioneId
              AND uf.OrganizzazioneId = @OrganizzazioneId
              AND r.DataCancellazione IS NULL
              AND up.DataCancellazione IS NULL
              AND uf.DataCancellazione IS NULL;
            """;

        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[UnitaRelazione] r
            WHERE r.UnitaRelazioneId <> @UnitaRelazioneId
              AND r.UnitaPadreId = @UnitaPadreId
              AND r.UnitaFigliaId = @UnitaFigliaId
              AND r.TipoRelazioneId = @TipoRelazioneId
              AND r.DataCancellazione IS NULL
              AND (r.DataInizioValidita IS NULL OR r.DataInizioValidita <= SYSUTCDATETIME())
              AND (r.DataFineValidita IS NULL OR r.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string updateSql = """
            UPDATE [Organizzazioni].[UnitaRelazione]
            SET UnitaPadreId = @UnitaPadreId,
                UnitaFigliaId = @UnitaFigliaId,
                TipoRelazioneId = @TipoRelazioneId,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE UnitaRelazioneId = @UnitaRelazioneId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            existsSql,
            new { command.UnitaRelazioneId, command.OrganizzazioneId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        if (!await UnitsBelongToOrgAsync(connection, command.OrganizzazioneId, [command.Request.UnitaPadreId, command.Request.UnitaFigliaId], cancellationToken))
        {
            return (WriteResult.NotFound, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new
            {
                command.UnitaRelazioneId,
                command.Request.UnitaPadreId,
                command.Request.UnitaFigliaId,
                command.Request.TipoRelazioneId
            },
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
                command.UnitaRelazioneId,
                command.Request.UnitaPadreId,
                command.Request.UnitaFigliaId,
                command.Request.TipoRelazioneId,
                Now = now,
                ActorInt = actorInt
            },
            cancellationToken: cancellationToken));

        return (WriteResult.Success, new UnitaRelazioneDto(command.UnitaRelazioneId, command.Request.UnitaPadreId, command.Request.UnitaFigliaId, command.Request.TipoRelazioneId));
    }

    public static async Task<WriteResult> DeleteAsync(
        DeleteCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string deleteSql = """
            UPDATE r
            SET r.DataCancellazione = @Now,
                r.CancellatoDa = @ActorInt,
                r.DataModifica = @Now,
                r.ModificatoDa = @ActorInt,
                r.DataFineValidita = @Now
            FROM [Organizzazioni].[UnitaRelazione] r
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] up ON up.UnitaOrganizzativaId = r.UnitaPadreId
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] uf ON uf.UnitaOrganizzativaId = r.UnitaFigliaId
            WHERE r.UnitaRelazioneId = @UnitaRelazioneId
              AND up.OrganizzazioneId = @OrganizzazioneId
              AND uf.OrganizzazioneId = @OrganizzazioneId
              AND r.DataCancellazione IS NULL
              AND up.DataCancellazione IS NULL
              AND uf.DataCancellazione IS NULL;
            """;

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(
            deleteSql,
            new
            {
                command.UnitaRelazioneId,
                command.OrganizzazioneId,
                Now = now,
                ActorInt = actorInt
            },
            cancellationToken: cancellationToken));

        return rows == 0 ? WriteResult.NotFound : WriteResult.Success;
    }

    private static async Task<bool> UnitsBelongToOrgAsync(
        System.Data.Common.DbConnection connection,
        int organizzazioneId,
        int[] unitIds,
        CancellationToken cancellationToken)
    {
        const string unitsSql = """
            SELECT u.UnitaOrganizzativaId
            FROM [Organizzazioni].[UnitaOrganizzativa] u
            WHERE u.OrganizzazioneId = @OrganizzazioneId
              AND u.UnitaOrganizzativaId IN @UnitIds
              AND u.DataCancellazione IS NULL
              AND (u.DataInizioValidita IS NULL OR u.DataInizioValidita <= SYSUTCDATETIME())
              AND (u.DataFineValidita IS NULL OR u.DataFineValidita >= SYSUTCDATETIME());
            """;

        var found = (await connection.QueryAsync<UnitOwnership>(new CommandDefinition(
            unitsSql,
            new { OrganizzazioneId = organizzazioneId, UnitIds = unitIds.Distinct().ToArray() },
            cancellationToken: cancellationToken))).Select(x => x.UnitaOrganizzativaId).Distinct().ToList();

        return unitIds.Distinct().All(x => found.Contains(x));
    }
}
