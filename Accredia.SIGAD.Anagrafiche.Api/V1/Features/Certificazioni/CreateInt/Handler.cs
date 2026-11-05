using Dapper;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.GetByIdInt;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Certificazioni.CreateInt;

internal static class Handler
{
    public static async Task<CertificazioneDetailDto?> Handle(
        Command command,
        IDbConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        var columns = await DbIntrospection.GetColumnsAsync(connectionFactory, cancellationToken);
        var now = DateTime.UtcNow;
        var fineValidita = new DateTime(9999, 12, 31, 23, 59, 59, DateTimeKind.Utc);
        var actor = string.IsNullOrWhiteSpace(command.Actor) ? "system" : command.Actor.Trim();

        var colNames = new List<string>();
        var colValues = new List<string>();
        var p = new DynamicParameters();

        void Add(string col, string sqlValue, object? value)
        {
            if (!columns.TryGetValue(col, out var info)) return;
            if (!info.IsInsertable) return;
            colNames.Add($"[{col}]");
            colValues.Add(sqlValue);
            p.Add(col, value);
        }

        Add("Denominazione", "@Denominazione", command.Request.Denominazione.Trim());
        Add("Sigla", "@Sigla", string.IsNullOrWhiteSpace(command.Request.Sigla) ? null : command.Request.Sigla.Trim());
        Add("Note", "@Note", string.IsNullOrWhiteSpace(command.Request.Note) ? null : command.Request.Note.Trim());
        Add("DataFondazione", "@DataFondazione", command.Request.DataFondazione?.Date);

        Add("DataInizioValidita", "@DataInizioValidita", now);
        Add("DataFineValidita", "@DataFineValidita", fineValidita);
        Add("UniqueRowId", "@UniqueRowId", Guid.NewGuid());
        Add("DataCreazione", "@DataCreazione", now);
        Add("CreatoDa", "@CreatoDa", DbIntrospection.GetActorDbValue(columns, "CreatoDa", actor));
        Add("DataModifica", "@DataModifica", now);
        Add("ModificatoDa", "@ModificatoDa", DbIntrospection.GetActorDbValue(columns, "ModificatoDa", actor));

        var insertSql = $"""
            DECLARE @newIds TABLE (CertificazioneId int);

            INSERT INTO [Accreditamento].[EnteAccreditamento]
                ({string.Join(", ", colNames)})
            OUTPUT INSERTED.EnteAccreditamentoId INTO @newIds(CertificazioneId)
            VALUES
                ({string.Join(", ", colValues)});

            SELECT TOP (1) CertificazioneId FROM @newIds;
            """;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var certificazioneId = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(insertSql, p, cancellationToken: cancellationToken));

        return await GetByIdInt.Handler.Handle(new GetByIdInt.Command(certificazioneId), connectionFactory, cancellationToken);
    }
}
