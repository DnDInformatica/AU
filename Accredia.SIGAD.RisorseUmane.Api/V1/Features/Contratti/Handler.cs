using Dapper;
using Microsoft.Data.SqlClient;
using Accredia.SIGAD.RisorseUmane.Api.Database;
using System.Data;

namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.Contratti;

internal static class Handler
{
    public static async Task<IResult> GetByIdAsync(
        int id,
        bool includeDeleted,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
SELECT
  ContrattoId,
  DipendenteId,
  TipoContrattoId,
  DataInizio,
  DataFine,
  LivelloInquadramento,
  CCNLApplicato,
  RAL,
  PercentualePartTime,
  OreLavoroSettimanali,
  IsContrattoCorrente,
  Note,
  DataCreazione,
  DataModifica,
  DataCancellazione
FROM [RisorseUmane].[Contratto]
WHERE ContrattoId = @Id
  AND (@IncludeDeleted = 1 OR DataCancellazione IS NULL);
""";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var row = await connection.QuerySingleOrDefaultAsync<ContrattoDbRow>(
            new CommandDefinition(sql, new { Id = id, IncludeDeleted = includeDeleted ? 1 : 0 }, cancellationToken: cancellationToken));

        return row is null ? Results.NotFound() : Results.Ok(Map(row));
    }

    public static async Task<IResult> ListByDipendenteAsync(
        int dipendenteId,
        bool includeDeleted,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
SELECT
  ContrattoId,
  DipendenteId,
  TipoContrattoId,
  DataInizio,
  DataFine,
  LivelloInquadramento,
  CCNLApplicato,
  RAL,
  PercentualePartTime,
  OreLavoroSettimanali,
  IsContrattoCorrente,
  Note,
  DataCreazione,
  DataModifica,
  DataCancellazione
FROM [RisorseUmane].[Contratto]
WHERE DipendenteId = @DipendenteId
  AND (@IncludeDeleted = 1 OR DataCancellazione IS NULL)
ORDER BY DataInizio DESC, ContrattoId DESC;
""";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = (await connection.QueryAsync<ContrattoDbRow>(
            new CommandDefinition(sql, new { DipendenteId = dipendenteId, IncludeDeleted = includeDeleted ? 1 : 0 }, cancellationToken: cancellationToken))).ToArray();

        return Results.Ok(rows.Select(Map).ToArray());
    }

    public static async Task<IResult> CreateAsync(
        int dipendenteId,
        ContrattoCreateRequest request,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
INSERT INTO [RisorseUmane].[Contratto]
(
  DipendenteId,
  TipoContrattoId,
  DataInizio,
  DataFine,
  LivelloInquadramento,
  CCNLApplicato,
  RAL,
  PercentualePartTime,
  OreLavoroSettimanali,
  IsContrattoCorrente,
  Note
)
OUTPUT INSERTED.ContrattoId
VALUES
(
  @DipendenteId,
  @TipoContrattoId,
  @DataInizio,
  @DataFine,
  @LivelloInquadramento,
  @CCNLApplicato,
  @RAL,
  @PercentualePartTime,
  @OreLavoroSettimanali,
  @IsContrattoCorrente,
  @Note
);
""";

        try
        {
            await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
            await using var transaction = await connection.BeginTransactionAsync(IsolationLevel.Serializable, cancellationToken);

            var validationResult = await ValidateTipoContrattoRulesAsync(
                connection,
                transaction,
                request.TipoContrattoId,
                request.DataInizio,
                request.DataFine,
                cancellationToken);
            if (validationResult is not null)
            {
                await transaction.RollbackAsync(cancellationToken);
                return validationResult;
            }

            var isCorrente = request.IsContrattoCorrente ?? false;
            if (isCorrente)
            {
                await ResetContrattoCorrenteAsync(connection, transaction, dipendenteId, excludeContrattoId: null, cancellationToken);
            }

            var id = await connection.ExecuteScalarAsync<int>(
                new CommandDefinition(sql, new
                {
                    DipendenteId = dipendenteId,
                    request.TipoContrattoId,
                    DataInizio = request.DataInizio.ToDateTime(TimeOnly.MinValue),
                    DataFine = request.DataFine?.ToDateTime(TimeOnly.MinValue),
                    request.LivelloInquadramento,
                    request.CCNLApplicato,
                    request.RAL,
                    request.PercentualePartTime,
                    request.OreLavoroSettimanali,
                    IsContrattoCorrente = isCorrente,
                    request.Note
                }, transaction: transaction, cancellationToken: cancellationToken));

            await transaction.CommitAsync(cancellationToken);
            return Results.Created($"/v1/contratti/{id}", new ContrattoCreateResponse(id));
        }
        catch (SqlException ex) when (ex.Number == 547)
        {
            return Results.Conflict(new ErrorResponse("Vincolo FK violato (verificare riferimenti)."));
        }
    }

    public static async Task<IResult> UpdateAsync(
        int dipendenteId,
        int id,
        ContrattoUpdateRequest request,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
UPDATE [RisorseUmane].[Contratto]
SET
  TipoContrattoId = @TipoContrattoId,
  DataInizio = @DataInizio,
  DataFine = @DataFine,
  LivelloInquadramento = @LivelloInquadramento,
  CCNLApplicato = @CCNLApplicato,
  RAL = @RAL,
  PercentualePartTime = @PercentualePartTime,
  OreLavoroSettimanali = @OreLavoroSettimanali,
  IsContrattoCorrente = @IsContrattoCorrente,
  Note = @Note,
  DataModifica = SYSUTCDATETIME()
WHERE ContrattoId = @Id
  AND DipendenteId = @DipendenteId
  AND DataCancellazione IS NULL;

SELECT @@ROWCOUNT;
""";

        try
        {
            await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
            await using var transaction = await connection.BeginTransactionAsync(IsolationLevel.Serializable, cancellationToken);

            var validationResult = await ValidateTipoContrattoRulesAsync(
                connection,
                transaction,
                request.TipoContrattoId,
                request.DataInizio,
                request.DataFine,
                cancellationToken);
            if (validationResult is not null)
            {
                await transaction.RollbackAsync(cancellationToken);
                return validationResult;
            }

            var isCorrente = request.IsContrattoCorrente ?? false;
            if (isCorrente)
            {
                await ResetContrattoCorrenteAsync(connection, transaction, dipendenteId, excludeContrattoId: id, cancellationToken);
            }

            var rows = await connection.ExecuteScalarAsync<int>(
                new CommandDefinition(sql, new
                {
                    Id = id,
                    DipendenteId = dipendenteId,
                    request.TipoContrattoId,
                    DataInizio = request.DataInizio.ToDateTime(TimeOnly.MinValue),
                    DataFine = request.DataFine?.ToDateTime(TimeOnly.MinValue),
                    request.LivelloInquadramento,
                    request.CCNLApplicato,
                    request.RAL,
                    request.PercentualePartTime,
                    request.OreLavoroSettimanali,
                    IsContrattoCorrente = isCorrente,
                    request.Note
                }, transaction: transaction, cancellationToken: cancellationToken));

            if (rows == 0)
            {
                await transaction.RollbackAsync(cancellationToken);
                return Results.NotFound();
            }

            await transaction.CommitAsync(cancellationToken);
            return Results.NoContent();
        }
        catch (SqlException ex) when (ex.Number == 547)
        {
            return Results.Conflict(new ErrorResponse("Vincolo FK violato (verificare riferimenti)."));
        }
    }

    public static async Task<IResult> SoftDeleteAsync(
        int dipendenteId,
        int id,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
UPDATE [RisorseUmane].[Contratto]
SET
  DataCancellazione = SYSUTCDATETIME(),
  DataModifica = SYSUTCDATETIME()
WHERE ContrattoId = @Id
  AND DipendenteId = @DipendenteId
  AND DataCancellazione IS NULL;

SELECT @@ROWCOUNT;
""";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(sql, new { Id = id, DipendenteId = dipendenteId }, cancellationToken: cancellationToken));

        return rows == 0 ? Results.NotFound() : Results.NoContent();
    }

    public static async Task<IResult> StoricoAsync(
        int id,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
SELECT
  ContrattoId,
  DipendenteId,
  TipoContrattoId,
  DataInizio,
  DataFine,
  LivelloInquadramento,
  CCNLApplicato,
  RAL,
  PercentualePartTime,
  OreLavoroSettimanali,
  IsContrattoCorrente,
  Note,
  DataCreazione,
  DataModifica,
  DataCancellazione,
  DataInizioValidita,
  DataFineValidita
FROM [RisorseUmane].[ContrattoStorico]
WHERE ContrattoId = @Id
ORDER BY DataInizioValidita;
""";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = (await connection.QueryAsync<ContrattoStoricoDbRow>(
            new CommandDefinition(sql, new { Id = id }, cancellationToken: cancellationToken))).ToArray();

        return Results.Ok(rows.Select(Map).ToArray());
    }

    private static ContrattoDto Map(ContrattoDbRow row)
        => new(
            row.ContrattoId,
            row.DipendenteId,
            row.TipoContrattoId,
            DateOnly.FromDateTime(row.DataInizio),
            row.DataFine.HasValue ? DateOnly.FromDateTime(row.DataFine.Value) : null,
            row.LivelloInquadramento,
            row.CCNLApplicato,
            row.RAL,
            row.PercentualePartTime,
            row.OreLavoroSettimanali,
            row.IsContrattoCorrente,
            row.Note,
            row.DataCreazione,
            row.DataModifica,
            row.DataCancellazione);

    private static ContrattoStoricoDto Map(ContrattoStoricoDbRow row)
        => new(
            row.ContrattoId,
            row.DipendenteId,
            row.TipoContrattoId,
            DateOnly.FromDateTime(row.DataInizio),
            row.DataFine.HasValue ? DateOnly.FromDateTime(row.DataFine.Value) : null,
            row.LivelloInquadramento,
            row.CCNLApplicato,
            row.RAL,
            row.PercentualePartTime,
            row.OreLavoroSettimanali,
            row.IsContrattoCorrente,
            row.Note,
            row.DataCreazione,
            row.DataModifica,
            row.DataCancellazione,
            row.DataInizioValidita,
            row.DataFineValidita);

    private static async Task<IResult?> ValidateTipoContrattoRulesAsync(
        SqlConnection connection,
        IDbTransaction transaction,
        int tipoContrattoId,
        DateOnly dataInizio,
        DateOnly? dataFine,
        CancellationToken cancellationToken)
    {
        const string sql = """
SELECT
  IsTempoIndeterminato,
  RichiedeDataScadenza,
  DurataMaxMesi
FROM [Tipologica].[TipoContratto]
WHERE TipoContrattoId = @TipoContrattoId
  AND DataCancellazione IS NULL
  AND Attivo = 1;
""";

        var tipo = await connection.QuerySingleOrDefaultAsync<TipoContrattoRegola>(
            new CommandDefinition(sql, new { TipoContrattoId = tipoContrattoId }, transaction: transaction, cancellationToken: cancellationToken));

        if (tipo is null)
        {
            return Results.ValidationProblem(new Dictionary<string, string[]>(StringComparer.Ordinal)
            {
                ["tipoContrattoId"] = ["TipoContratto non valido o non attivo."]
            });
        }

        var errors = new Dictionary<string, string[]>(StringComparer.Ordinal);

        if (tipo.RichiedeDataScadenza && dataFine is null)
        {
            errors["dataFine"] = ["DataFine obbligatoria per il tipo contratto selezionato."];
        }

        if (tipo.DurataMaxMesi is int durataMaxMesi && durataMaxMesi > 0 && dataFine.HasValue)
        {
            var mesi = ((dataFine.Value.Year - dataInizio.Year) * 12) + dataFine.Value.Month - dataInizio.Month;
            if (dataFine.Value.Day < dataInizio.Day)
            {
                mesi--;
            }

            if (mesi > durataMaxMesi)
            {
                errors["dataFine"] = [$"Durata contratto superiore al massimo consentito ({durataMaxMesi} mesi)."];
            }
        }

        return errors.Count > 0 ? Results.ValidationProblem(errors) : null;
    }

    private static async Task ResetContrattoCorrenteAsync(
        SqlConnection connection,
        IDbTransaction transaction,
        int dipendenteId,
        int? excludeContrattoId,
        CancellationToken cancellationToken)
    {
        const string sql = """
UPDATE [RisorseUmane].[Contratto]
SET
  IsContrattoCorrente = 0,
  DataModifica = SYSUTCDATETIME()
WHERE DipendenteId = @DipendenteId
  AND DataCancellazione IS NULL
  AND IsContrattoCorrente = 1
  AND (@ExcludeContrattoId IS NULL OR ContrattoId <> @ExcludeContrattoId);
""";

        await connection.ExecuteAsync(
            new CommandDefinition(
                sql,
                new { DipendenteId = dipendenteId, ExcludeContrattoId = excludeContrattoId },
                transaction: transaction,
                cancellationToken: cancellationToken));
    }
}

internal sealed record ErrorResponse(string Error);

internal sealed record ContrattoDbRow(
    int ContrattoId,
    int DipendenteId,
    int TipoContrattoId,
    DateTime DataInizio,
    DateTime? DataFine,
    string? LivelloInquadramento,
    string? CCNLApplicato,
    decimal? RAL,
    decimal? PercentualePartTime,
    decimal? OreLavoroSettimanali,
    bool IsContrattoCorrente,
    string? Note,
    DateTime DataCreazione,
    DateTime? DataModifica,
    DateTime? DataCancellazione);

internal sealed record ContrattoStoricoDbRow(
    int ContrattoId,
    int DipendenteId,
    int TipoContrattoId,
    DateTime DataInizio,
    DateTime? DataFine,
    string? LivelloInquadramento,
    string? CCNLApplicato,
    decimal? RAL,
    decimal? PercentualePartTime,
    decimal? OreLavoroSettimanali,
    bool IsContrattoCorrente,
    string? Note,
    DateTime DataCreazione,
    DateTime? DataModifica,
    DateTime? DataCancellazione,
    DateTime DataInizioValidita,
    DateTime DataFineValidita);

internal sealed record TipoContrattoRegola(
    bool IsTempoIndeterminato,
    bool RichiedeDataScadenza,
    int? DurataMaxMesi);
