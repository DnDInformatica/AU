using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaAttivita;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFound,
        Duplicate
    }

    public static async Task<IReadOnlyList<UnitaAttivitaDto>?> ListAsync(
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
                a.UnitaAttivitaId,
                a.UnitaOrganizzativaId,
                a.CodiceATECORI AS CodiceAtecoRi,
                a.DescrizioneAttivita,
                a.Importanza,
                CAST(a.DataInizioAttivita AS datetime2) AS DataInizioAttivita,
                CAST(a.DataFineAttivita AS datetime2) AS DataFineAttivita,
                a.FonteDato,
                a.Note
            FROM [Organizzazioni].[UnitaAttivita] a
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = a.UnitaOrganizzativaId
            WHERE u.OrganizzazioneId = @OrganizzazioneId
              AND a.DataCancellazione IS NULL
              AND u.DataCancellazione IS NULL
              AND (a.DataInizioValidita IS NULL OR a.DataInizioValidita <= SYSUTCDATETIME())
              AND (a.DataFineValidita IS NULL OR a.DataFineValidita >= SYSUTCDATETIME())
              AND (u.DataInizioValidita IS NULL OR u.DataInizioValidita <= SYSUTCDATETIME())
              AND (u.DataFineValidita IS NULL OR u.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY a.UnitaAttivitaId DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            orgExistsSql,
            new { command.OrganizzazioneId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return null;
        }

        var rows = (await connection.QueryAsync<UnitaAttivitaDto>(new CommandDefinition(
            listSql,
            new { command.OrganizzazioneId },
            cancellationToken: cancellationToken))).ToList();
        return rows;
    }

    public static async Task<(WriteResult Result, UnitaAttivitaDto? Item)> CreateAsync(
        CreateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[UnitaAttivita] a
            WHERE a.UnitaOrganizzativaId = @UnitaOrganizzativaId
              AND a.CodiceATECORI = @CodiceAtecoRi
              AND a.DataCancellazione IS NULL
              AND (a.DataInizioValidita IS NULL OR a.DataInizioValidita <= SYSUTCDATETIME())
              AND (a.DataFineValidita IS NULL OR a.DataFineValidita >= SYSUTCDATETIME());
            """;
        const string insertSql = """
            DECLARE @newIds TABLE (Id int);
            INSERT INTO [Organizzazioni].[UnitaAttivita]
                ([UnitaOrganizzativaId], [CodiceATECORI], [DescrizioneAttivita], [Importanza], [DataInizioAttivita], [DataFineAttivita], [FonteDato], [Note], [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa], [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.UnitaAttivitaId INTO @newIds(Id)
            VALUES
                (@UnitaOrganizzativaId, @CodiceAtecoRi, @DescrizioneAttivita, @Importanza, @DataInizioAttivita, @DataFineAttivita, @FonteDato, @Note, @Now, @ActorInt, @Now, @ActorInt, @UniqueRowId, @Now, @DataFineValidita);
            SELECT TOP (1) Id FROM @newIds;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (!await UnitBelongsToOrgAsync(connection, command.OrganizzazioneId, command.Request.UnitaOrganizzativaId, cancellationToken))
        {
            return (WriteResult.NotFound, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.Request.UnitaOrganizzativaId, CodiceAtecoRi = command.Request.CodiceAtecoRi.Trim() },
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
                command.Request.UnitaOrganizzativaId,
                CodiceAtecoRi = command.Request.CodiceAtecoRi.Trim(),
                DescrizioneAttivita = string.IsNullOrWhiteSpace(command.Request.DescrizioneAttivita) ? null : command.Request.DescrizioneAttivita.Trim(),
                Importanza = string.IsNullOrWhiteSpace(command.Request.Importanza) ? "secondaria" : command.Request.Importanza.Trim(),
                DataInizioAttivita = command.Request.DataInizioAttivita?.Date,
                DataFineAttivita = command.Request.DataFineAttivita?.Date,
                FonteDato = string.IsNullOrWhiteSpace(command.Request.FonteDato) ? "RegistroImprese" : command.Request.FonteDato.Trim(),
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            cancellationToken: cancellationToken));

        var list = await ListAsync(new ListCommand(command.OrganizzazioneId), connectionFactory, cancellationToken);
        return (WriteResult.Success, list!.First(x => x.UnitaAttivitaId == id));
    }

    public static async Task<(WriteResult Result, UnitaAttivitaDto? Item)> UpdateAsync(
        UpdateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string existsSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[UnitaAttivita] a
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = a.UnitaOrganizzativaId
            WHERE a.UnitaAttivitaId = @UnitaAttivitaId
              AND u.OrganizzazioneId = @OrganizzazioneId
              AND a.DataCancellazione IS NULL
              AND u.DataCancellazione IS NULL;
            """;
        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[UnitaAttivita] a
            WHERE a.UnitaAttivitaId <> @UnitaAttivitaId
              AND a.UnitaOrganizzativaId = @UnitaOrganizzativaId
              AND a.CodiceATECORI = @CodiceAtecoRi
              AND a.DataCancellazione IS NULL
              AND (a.DataInizioValidita IS NULL OR a.DataInizioValidita <= SYSUTCDATETIME())
              AND (a.DataFineValidita IS NULL OR a.DataFineValidita >= SYSUTCDATETIME());
            """;
        const string updateSql = """
            UPDATE [Organizzazioni].[UnitaAttivita]
            SET UnitaOrganizzativaId = @UnitaOrganizzativaId,
                CodiceATECORI = @CodiceAtecoRi,
                DescrizioneAttivita = @DescrizioneAttivita,
                Importanza = @Importanza,
                DataInizioAttivita = @DataInizioAttivita,
                DataFineAttivita = @DataFineAttivita,
                FonteDato = @FonteDato,
                Note = @Note,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE UnitaAttivitaId = @UnitaAttivitaId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            existsSql,
            new { command.UnitaAttivitaId, command.OrganizzazioneId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        if (!await UnitBelongsToOrgAsync(connection, command.OrganizzazioneId, command.Request.UnitaOrganizzativaId, cancellationToken))
        {
            return (WriteResult.NotFound, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.UnitaAttivitaId, command.Request.UnitaOrganizzativaId, CodiceAtecoRi = command.Request.CodiceAtecoRi.Trim() },
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
                command.UnitaAttivitaId,
                command.Request.UnitaOrganizzativaId,
                CodiceAtecoRi = command.Request.CodiceAtecoRi.Trim(),
                DescrizioneAttivita = string.IsNullOrWhiteSpace(command.Request.DescrizioneAttivita) ? null : command.Request.DescrizioneAttivita.Trim(),
                Importanza = string.IsNullOrWhiteSpace(command.Request.Importanza) ? "secondaria" : command.Request.Importanza.Trim(),
                DataInizioAttivita = command.Request.DataInizioAttivita?.Date,
                DataFineAttivita = command.Request.DataFineAttivita?.Date,
                FonteDato = string.IsNullOrWhiteSpace(command.Request.FonteDato) ? "RegistroImprese" : command.Request.FonteDato.Trim(),
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                Now = now,
                ActorInt = actorInt
            },
            cancellationToken: cancellationToken));

        var list = await ListAsync(new ListCommand(command.OrganizzazioneId), connectionFactory, cancellationToken);
        return (WriteResult.Success, list!.First(x => x.UnitaAttivitaId == command.UnitaAttivitaId));
    }

    public static async Task<WriteResult> DeleteAsync(
        DeleteCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            UPDATE a
            SET a.DataCancellazione = @Now,
                a.CancellatoDa = @ActorInt,
                a.DataModifica = @Now,
                a.ModificatoDa = @ActorInt,
                a.DataFineValidita = @Now
            FROM [Organizzazioni].[UnitaAttivita] a
            INNER JOIN [Organizzazioni].[UnitaOrganizzativa] u ON u.UnitaOrganizzativaId = a.UnitaOrganizzativaId
            WHERE a.UnitaAttivitaId = @UnitaAttivitaId
              AND u.OrganizzazioneId = @OrganizzazioneId
              AND a.DataCancellazione IS NULL
              AND u.DataCancellazione IS NULL;
            """;
        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(
            sql,
            new { command.UnitaAttivitaId, command.OrganizzazioneId, Now = now, ActorInt = actorInt },
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
}
