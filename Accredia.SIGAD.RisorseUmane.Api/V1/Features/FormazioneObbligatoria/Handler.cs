using Dapper;
using Microsoft.Data.SqlClient;
using Accredia.SIGAD.RisorseUmane.Api.Database;

namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.FormazioneObbligatoria;

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
  FormazioneObbligatoriaId,
  DipendenteId,
  TipoFormazioneObbligatoriaId,
  DataCompletamento,
  DataScadenza,
  EstremiAttestato,
  EnteFormatore,
  DurataOreCorso,
  Note,
  DataCreazione,
  DataModifica,
  DataCancellazione
FROM [RisorseUmane].[FormazioneObbligatoria]
WHERE FormazioneObbligatoriaId = @Id
  AND (@IncludeDeleted = 1 OR DataCancellazione IS NULL);
""";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var row = await connection.QuerySingleOrDefaultAsync<FormazioneObbligatoriaDbRow>(
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
  FormazioneObbligatoriaId,
  DipendenteId,
  TipoFormazioneObbligatoriaId,
  DataCompletamento,
  DataScadenza,
  EstremiAttestato,
  EnteFormatore,
  DurataOreCorso,
  Note,
  DataCreazione,
  DataModifica,
  DataCancellazione
FROM [RisorseUmane].[FormazioneObbligatoria]
WHERE DipendenteId = @DipendenteId
  AND (@IncludeDeleted = 1 OR DataCancellazione IS NULL)
ORDER BY DataCompletamento DESC, FormazioneObbligatoriaId DESC;
""";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = (await connection.QueryAsync<FormazioneObbligatoriaDbRow>(
            new CommandDefinition(sql, new { DipendenteId = dipendenteId, IncludeDeleted = includeDeleted ? 1 : 0 }, cancellationToken: cancellationToken))).ToArray();

        return Results.Ok(rows.Select(Map).ToArray());
    }

    public static async Task<IResult> CreateAsync(
        int dipendenteId,
        FormazioneObbligatoriaCreateRequest request,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
INSERT INTO [RisorseUmane].[FormazioneObbligatoria]
(
  DipendenteId,
  TipoFormazioneObbligatoriaId,
  DataCompletamento,
  DataScadenza,
  EstremiAttestato,
  EnteFormatore,
  DurataOreCorso,
  Note
)
OUTPUT INSERTED.FormazioneObbligatoriaId
VALUES
(
  @DipendenteId,
  @TipoFormazioneObbligatoriaId,
  @DataCompletamento,
  @DataScadenza,
  @EstremiAttestato,
  @EnteFormatore,
  @DurataOreCorso,
  @Note
);
""";

        try
        {
            await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

            var formazioneData = await ResolveFormazioneDataAsync(
                connection,
                request.TipoFormazioneObbligatoriaId,
                request.DataCompletamento,
                request.DataScadenza,
                request.DurataOreCorso,
                cancellationToken);
            if (formazioneData.ValidationResult is not null)
            {
                return formazioneData.ValidationResult;
            }

            var id = await connection.ExecuteScalarAsync<int>(
                new CommandDefinition(sql, new
                {
                    DipendenteId = dipendenteId,
                    request.TipoFormazioneObbligatoriaId,
                    DataCompletamento = request.DataCompletamento.ToDateTime(TimeOnly.MinValue),
                    DataScadenza = formazioneData.DataScadenza?.ToDateTime(TimeOnly.MinValue),
                    request.EstremiAttestato,
                    request.EnteFormatore,
                    request.DurataOreCorso,
                    request.Note
                }, cancellationToken: cancellationToken));

            return Results.Created($"/v1/formazione-obbligatoria/{id}", new FormazioneObbligatoriaCreateResponse(id));
        }
        catch (SqlException ex) when (ex.Number == 547)
        {
            return Results.Conflict(new ErrorResponse("Vincolo FK violato (verificare riferimenti)."));
        }
    }

    public static async Task<IResult> UpdateAsync(
        int dipendenteId,
        int id,
        FormazioneObbligatoriaUpdateRequest request,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
UPDATE [RisorseUmane].[FormazioneObbligatoria]
SET
  TipoFormazioneObbligatoriaId = @TipoFormazioneObbligatoriaId,
  DataCompletamento = @DataCompletamento,
  DataScadenza = @DataScadenza,
  EstremiAttestato = @EstremiAttestato,
  EnteFormatore = @EnteFormatore,
  DurataOreCorso = @DurataOreCorso,
  Note = @Note,
  DataModifica = SYSUTCDATETIME()
WHERE FormazioneObbligatoriaId = @Id
  AND DipendenteId = @DipendenteId
  AND DataCancellazione IS NULL;

SELECT @@ROWCOUNT;
""";

        try
        {
            await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);

            var formazioneData = await ResolveFormazioneDataAsync(
                connection,
                request.TipoFormazioneObbligatoriaId,
                request.DataCompletamento,
                request.DataScadenza,
                request.DurataOreCorso,
                cancellationToken);
            if (formazioneData.ValidationResult is not null)
            {
                return formazioneData.ValidationResult;
            }

            var rows = await connection.ExecuteScalarAsync<int>(
                new CommandDefinition(sql, new
                {
                    Id = id,
                    DipendenteId = dipendenteId,
                    request.TipoFormazioneObbligatoriaId,
                    DataCompletamento = request.DataCompletamento.ToDateTime(TimeOnly.MinValue),
                    DataScadenza = formazioneData.DataScadenza?.ToDateTime(TimeOnly.MinValue),
                    request.EstremiAttestato,
                    request.EnteFormatore,
                    request.DurataOreCorso,
                    request.Note
                }, cancellationToken: cancellationToken));

            return rows == 0 ? Results.NotFound() : Results.NoContent();
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
UPDATE [RisorseUmane].[FormazioneObbligatoria]
SET
  DataCancellazione = SYSUTCDATETIME(),
  DataModifica = SYSUTCDATETIME()
WHERE FormazioneObbligatoriaId = @Id
  AND DipendenteId = @DipendenteId
  AND DataCancellazione IS NULL;

SELECT @@ROWCOUNT;
""";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(sql, new { Id = id, DipendenteId = dipendenteId }, cancellationToken: cancellationToken));

        return rows == 0 ? Results.NotFound() : Results.NoContent();
    }

    private static FormazioneObbligatoriaDto Map(FormazioneObbligatoriaDbRow row)
        => new(
            row.FormazioneObbligatoriaId,
            row.DipendenteId,
            row.TipoFormazioneObbligatoriaId,
            DateOnly.FromDateTime(row.DataCompletamento),
            row.DataScadenza.HasValue ? DateOnly.FromDateTime(row.DataScadenza.Value) : null,
            row.EstremiAttestato,
            row.EnteFormatore,
            row.DurataOreCorso,
            row.Note,
            row.DataCreazione,
            row.DataModifica,
            row.DataCancellazione);

    private static async Task<FormazioneDataResolution> ResolveFormazioneDataAsync(
        SqlConnection connection,
        int tipoFormazioneObbligatoriaId,
        DateOnly dataCompletamento,
        DateOnly? dataScadenzaInput,
        int? durataOreCorso,
        CancellationToken cancellationToken)
    {
        const string sql = """
SELECT
  DurataOreMinima,
  ValiditaMesi
FROM [Tipologica].[TipoFormazioneObbligatoria]
WHERE TipoFormazioneObbligatoriaId = @TipoFormazioneObbligatoriaId
  AND DataCancellazione IS NULL
  AND Attivo = 1;
""";

        var tipo = await connection.QuerySingleOrDefaultAsync<TipoFormazioneRegola>(
            new CommandDefinition(sql, new { TipoFormazioneObbligatoriaId = tipoFormazioneObbligatoriaId }, cancellationToken: cancellationToken));

        if (tipo is null)
        {
            return new(
                null,
                Results.ValidationProblem(new Dictionary<string, string[]>(StringComparer.Ordinal)
                {
                    ["tipoFormazioneObbligatoriaId"] = ["TipoFormazioneObbligatoria non valido o non attivo."]
                }));
        }

        var errors = new Dictionary<string, string[]>(StringComparer.Ordinal);

        if (tipo.DurataOreMinima is int durataMinima && durataMinima > 0 && durataOreCorso is int durataOre && durataOre < durataMinima)
        {
            errors["durataOreCorso"] = [$"DurataOreCorso inferiore al minimo previsto ({durataMinima} ore)."];
        }

        var resolvedScadenza = dataScadenzaInput;
        if (resolvedScadenza is null && tipo.ValiditaMesi is int validitaMesi && validitaMesi > 0)
        {
            resolvedScadenza = dataCompletamento.AddMonths(validitaMesi);
        }

        if (resolvedScadenza.HasValue && resolvedScadenza.Value < dataCompletamento)
        {
            errors["dataScadenza"] = ["DataScadenza non puo essere antecedente a DataCompletamento."];
        }

        return errors.Count > 0
            ? new(null, Results.ValidationProblem(errors))
            : new(resolvedScadenza, null);
    }
}

internal sealed record ErrorResponse(string Error);

internal sealed record FormazioneObbligatoriaDbRow(
    int FormazioneObbligatoriaId,
    int DipendenteId,
    int TipoFormazioneObbligatoriaId,
    DateTime DataCompletamento,
    DateTime? DataScadenza,
    string? EstremiAttestato,
    string? EnteFormatore,
    int? DurataOreCorso,
    string? Note,
    DateTime DataCreazione,
    DateTime? DataModifica,
    DateTime? DataCancellazione);

internal sealed record TipoFormazioneRegola(
    int? DurataOreMinima,
    int? ValiditaMesi);

internal sealed record FormazioneDataResolution(
    DateOnly? DataScadenza,
    IResult? ValidationResult);
