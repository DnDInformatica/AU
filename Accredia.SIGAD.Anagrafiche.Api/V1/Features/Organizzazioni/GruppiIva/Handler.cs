using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GruppiIva;

internal static class Handler
{
    internal enum WriteResult
    {
        Success,
        NotFound,
        Duplicate,
        InvalidOrganizzazioneCapogruppo
    }

    public static async Task<IReadOnlyList<GruppoIvaDto>> ListAsync(
        ListCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string listSql = """
            SELECT
                g.GruppoIVAId AS GruppoIvaId,
                g.PartitaIVAGruppo AS PartitaIvaGruppo,
                g.Denominazione,
                g.CodiceGruppo,
                CAST(g.DataCostituzione AS datetime2) AS DataCostituzione,
                CAST(g.DataApprovazione AS datetime2) AS DataApprovazione,
                g.ProtocolloAgenziaEntrate,
                g.NumeroProvvedimento,
                g.StatoGruppo,
                CAST(g.DataCessazione AS datetime2) AS DataCessazione,
                g.MotivoCessazione,
                g.OrganizzazioneCapogruppoId,
                g.Note,
                g.DocumentazioneRiferimento
            FROM [Organizzazioni].[GruppoIVA] g
            WHERE g.DataCancellazione IS NULL
              AND (g.DataInizioValidita IS NULL OR g.DataInizioValidita <= SYSUTCDATETIME())
              AND (g.DataFineValidita IS NULL OR g.DataFineValidita >= SYSUTCDATETIME())
            ORDER BY g.GruppoIVAId DESC;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = (await connection.QueryAsync<GruppoIvaDto>(
            new CommandDefinition(listSql, cancellationToken: cancellationToken))).ToList();
        return rows;
    }

    public static async Task<(WriteResult Result, GruppoIvaDto? Item)> CreateAsync(
        CreateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[GruppoIVA] g
            WHERE g.PartitaIVAGruppo = @PartitaIvaGruppo
              AND g.DataCancellazione IS NULL
              AND (g.DataInizioValidita IS NULL OR g.DataInizioValidita <= SYSUTCDATETIME())
              AND (g.DataFineValidita IS NULL OR g.DataFineValidita >= SYSUTCDATETIME());
            """;

        const string insertSql = """
            DECLARE @newIds TABLE (Id int);
            INSERT INTO [Organizzazioni].[GruppoIVA]
                ([PartitaIVAGruppo], [Denominazione], [CodiceGruppo], [DataCostituzione], [DataApprovazione], [ProtocolloAgenziaEntrate], [NumeroProvvedimento], [StatoGruppo], [DataCessazione], [MotivoCessazione], [OrganizzazioneCapogruppoId], [Note], [DocumentazioneRiferimento], [DataCreazione], [CreatoDa], [DataModifica], [ModificatoDa], [UniqueRowId], [DataInizioValidita], [DataFineValidita])
            OUTPUT INSERTED.GruppoIVAId INTO @newIds(Id)
            VALUES
                (@PartitaIvaGruppo, @Denominazione, @CodiceGruppo, @DataCostituzione, @DataApprovazione, @ProtocolloAgenziaEntrate, @NumeroProvvedimento, @StatoGruppo, @DataCessazione, @MotivoCessazione, @OrganizzazioneCapogruppoId, @Note, @DocumentazioneRiferimento, @Now, @ActorInt, @Now, @ActorInt, @UniqueRowId, @Now, @DataFineValidita);
            SELECT TOP (1) Id FROM @newIds;
            """;

        const string byIdSql = """
            SELECT
                g.GruppoIVAId AS GruppoIvaId,
                g.PartitaIVAGruppo AS PartitaIvaGruppo,
                g.Denominazione,
                g.CodiceGruppo,
                CAST(g.DataCostituzione AS datetime2) AS DataCostituzione,
                CAST(g.DataApprovazione AS datetime2) AS DataApprovazione,
                g.ProtocolloAgenziaEntrate,
                g.NumeroProvvedimento,
                g.StatoGruppo,
                CAST(g.DataCessazione AS datetime2) AS DataCessazione,
                g.MotivoCessazione,
                g.OrganizzazioneCapogruppoId,
                g.Note,
                g.DocumentazioneRiferimento
            FROM [Organizzazioni].[GruppoIVA] g
            WHERE g.GruppoIVAId = @Id
              AND g.DataCancellazione IS NULL
              AND (g.DataInizioValidita IS NULL OR g.DataInizioValidita <= SYSUTCDATETIME())
              AND (g.DataFineValidita IS NULL OR g.DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        if (command.Request.OrganizzazioneCapogruppoId.HasValue
            && !await OrganizzazioneExistsAsync(connection, command.Request.OrganizzazioneCapogruppoId.Value, cancellationToken))
        {
            return (WriteResult.InvalidOrganizzazioneCapogruppo, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { PartitaIvaGruppo = command.Request.PartitaIvaGruppo.Trim() },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        var dataCostituzione = (command.Request.DataCostituzione ?? now).Date;
        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);

        var id = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            insertSql,
            new
            {
                PartitaIvaGruppo = command.Request.PartitaIvaGruppo.Trim(),
                Denominazione = command.Request.Denominazione.Trim(),
                CodiceGruppo = string.IsNullOrWhiteSpace(command.Request.CodiceGruppo) ? null : command.Request.CodiceGruppo.Trim(),
                DataCostituzione = dataCostituzione,
                DataApprovazione = command.Request.DataApprovazione?.Date,
                ProtocolloAgenziaEntrate = string.IsNullOrWhiteSpace(command.Request.ProtocolloAgenziaEntrate) ? null : command.Request.ProtocolloAgenziaEntrate.Trim(),
                NumeroProvvedimento = string.IsNullOrWhiteSpace(command.Request.NumeroProvvedimento) ? null : command.Request.NumeroProvvedimento.Trim(),
                StatoGruppo = string.IsNullOrWhiteSpace(command.Request.StatoGruppo) ? "ATTIVO" : command.Request.StatoGruppo.Trim(),
                DataCessazione = command.Request.DataCessazione?.Date,
                MotivoCessazione = string.IsNullOrWhiteSpace(command.Request.MotivoCessazione) ? null : command.Request.MotivoCessazione.Trim(),
                command.Request.OrganizzazioneCapogruppoId,
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                DocumentazioneRiferimento = string.IsNullOrWhiteSpace(command.Request.DocumentazioneRiferimento) ? null : command.Request.DocumentazioneRiferimento.Trim(),
                Now = now,
                ActorInt = actorInt,
                UniqueRowId = Guid.NewGuid(),
                DataFineValidita = fineValidita
            },
            cancellationToken: cancellationToken));

        var item = await connection.QuerySingleAsync<GruppoIvaDto>(new CommandDefinition(
            byIdSql,
            new { Id = id },
            cancellationToken: cancellationToken));
        return (WriteResult.Success, item);
    }

    public static async Task<(WriteResult Result, GruppoIvaDto? Item)> UpdateAsync(
        UpdateCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string existsSql = """
            SELECT COUNT(1) FROM [Organizzazioni].[GruppoIVA]
            WHERE GruppoIVAId = @GruppoIvaId AND DataCancellazione IS NULL;
            """;
        const string duplicateSql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[GruppoIVA] g
            WHERE g.GruppoIVAId <> @GruppoIvaId
              AND g.PartitaIVAGruppo = @PartitaIvaGruppo
              AND g.DataCancellazione IS NULL
              AND (g.DataInizioValidita IS NULL OR g.DataInizioValidita <= SYSUTCDATETIME())
              AND (g.DataFineValidita IS NULL OR g.DataFineValidita >= SYSUTCDATETIME());
            """;
        const string updateSql = """
            UPDATE [Organizzazioni].[GruppoIVA]
            SET PartitaIVAGruppo = @PartitaIvaGruppo,
                Denominazione = @Denominazione,
                CodiceGruppo = @CodiceGruppo,
                DataCostituzione = @DataCostituzione,
                DataApprovazione = @DataApprovazione,
                ProtocolloAgenziaEntrate = @ProtocolloAgenziaEntrate,
                NumeroProvvedimento = @NumeroProvvedimento,
                StatoGruppo = @StatoGruppo,
                DataCessazione = @DataCessazione,
                MotivoCessazione = @MotivoCessazione,
                OrganizzazioneCapogruppoId = @OrganizzazioneCapogruppoId,
                Note = @Note,
                DocumentazioneRiferimento = @DocumentazioneRiferimento,
                DataModifica = @Now,
                ModificatoDa = @ActorInt
            WHERE GruppoIVAId = @GruppoIvaId
              AND DataCancellazione IS NULL
              AND (DataInizioValidita IS NULL OR DataInizioValidita <= SYSUTCDATETIME())
              AND (DataFineValidita IS NULL OR DataFineValidita >= SYSUTCDATETIME());
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var exists = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            existsSql,
            new { command.GruppoIvaId },
            cancellationToken: cancellationToken));
        if (exists == 0)
        {
            return (WriteResult.NotFound, null);
        }

        if (command.Request.OrganizzazioneCapogruppoId.HasValue
            && !await OrganizzazioneExistsAsync(connection, command.Request.OrganizzazioneCapogruppoId.Value, cancellationToken))
        {
            return (WriteResult.InvalidOrganizzazioneCapogruppo, null);
        }

        var duplicate = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            duplicateSql,
            new { command.GruppoIvaId, PartitaIvaGruppo = command.Request.PartitaIvaGruppo.Trim() },
            cancellationToken: cancellationToken));
        if (duplicate > 0)
        {
            return (WriteResult.Duplicate, null);
        }

        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        var dataCostituzione = (command.Request.DataCostituzione ?? now).Date;

        await connection.ExecuteAsync(new CommandDefinition(
            updateSql,
            new
            {
                command.GruppoIvaId,
                PartitaIvaGruppo = command.Request.PartitaIvaGruppo.Trim(),
                Denominazione = command.Request.Denominazione.Trim(),
                CodiceGruppo = string.IsNullOrWhiteSpace(command.Request.CodiceGruppo) ? null : command.Request.CodiceGruppo.Trim(),
                DataCostituzione = dataCostituzione,
                DataApprovazione = command.Request.DataApprovazione?.Date,
                ProtocolloAgenziaEntrate = string.IsNullOrWhiteSpace(command.Request.ProtocolloAgenziaEntrate) ? null : command.Request.ProtocolloAgenziaEntrate.Trim(),
                NumeroProvvedimento = string.IsNullOrWhiteSpace(command.Request.NumeroProvvedimento) ? null : command.Request.NumeroProvvedimento.Trim(),
                StatoGruppo = string.IsNullOrWhiteSpace(command.Request.StatoGruppo) ? "ATTIVO" : command.Request.StatoGruppo.Trim(),
                DataCessazione = command.Request.DataCessazione?.Date,
                MotivoCessazione = string.IsNullOrWhiteSpace(command.Request.MotivoCessazione) ? null : command.Request.MotivoCessazione.Trim(),
                command.Request.OrganizzazioneCapogruppoId,
                Note = string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim(),
                DocumentazioneRiferimento = string.IsNullOrWhiteSpace(command.Request.DocumentazioneRiferimento) ? null : command.Request.DocumentazioneRiferimento.Trim(),
                Now = now,
                ActorInt = actorInt
            },
            cancellationToken: cancellationToken));

        var list = await ListAsync(new ListCommand(), connectionFactory, cancellationToken);
        return (WriteResult.Success, list.First(x => x.GruppoIvaId == command.GruppoIvaId));
    }

    public static async Task<WriteResult> DeleteAsync(
        DeleteCommand command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
            UPDATE [Organizzazioni].[GruppoIVA]
            SET DataCancellazione = @Now,
                CancellatoDa = @ActorInt,
                DataModifica = @Now,
                ModificatoDa = @ActorInt,
                DataFineValidita = @Now
            WHERE GruppoIVAId = @GruppoIvaId
              AND DataCancellazione IS NULL;
            """;
        var now = DateTime.UtcNow;
        var actorInt = int.TryParse(command.Actor, out var parsedActor) ? parsedActor : 0;
        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteAsync(new CommandDefinition(
            sql,
            new { command.GruppoIvaId, Now = now, ActorInt = actorInt },
            cancellationToken: cancellationToken));
        return rows == 0 ? WriteResult.NotFound : WriteResult.Success;
    }

    private static async Task<bool> OrganizzazioneExistsAsync(
        System.Data.Common.DbConnection connection,
        int organizzazioneId,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT COUNT(1)
            FROM [Organizzazioni].[Organizzazione] o
            WHERE o.OrganizzazioneId = @OrganizzazioneId
              AND o.DataCancellazione IS NULL
              AND (o.DataInizioValidita IS NULL OR o.DataInizioValidita <= SYSUTCDATETIME())
              AND (o.DataFineValidita IS NULL OR o.DataFineValidita >= SYSUTCDATETIME());
            """;
        var count = await connection.ExecuteScalarAsync<int>(new CommandDefinition(
            sql,
            new { OrganizzazioneId = organizzazioneId },
            cancellationToken: cancellationToken));
        return count > 0;
    }
}
