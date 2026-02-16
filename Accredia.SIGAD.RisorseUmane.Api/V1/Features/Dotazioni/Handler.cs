using Dapper;
using Microsoft.Data.SqlClient;
using Accredia.SIGAD.RisorseUmane.Api.Database;

namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.Dotazioni;

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
  DotazioneId,
  DipendenteId,
  TipoDotazioneId,
  Descrizione,
  NumeroInventario,
  NumeroSerie,
  DataAssegnazione,
  DataRestituzione,
  IsRestituito,
  Note,
  DataCreazione,
  DataModifica,
  DataCancellazione
FROM [RisorseUmane].[Dotazione]
WHERE DotazioneId = @Id
  AND (@IncludeDeleted = 1 OR DataCancellazione IS NULL);
""";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var dto = await connection.QuerySingleOrDefaultAsync<DotazioneDto>(
            new CommandDefinition(sql, new { Id = id, IncludeDeleted = includeDeleted ? 1 : 0 }, cancellationToken: cancellationToken));

        return dto is null ? Results.NotFound() : Results.Ok(dto);
    }

    public static async Task<IResult> ListByDipendenteAsync(
        int dipendenteId,
        bool includeDeleted,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
SELECT
  DotazioneId,
  DipendenteId,
  TipoDotazioneId,
  Descrizione,
  NumeroInventario,
  NumeroSerie,
  DataAssegnazione,
  DataRestituzione,
  IsRestituito,
  Note,
  DataCreazione,
  DataModifica,
  DataCancellazione
FROM [RisorseUmane].[Dotazione]
WHERE DipendenteId = @DipendenteId
  AND (@IncludeDeleted = 1 OR DataCancellazione IS NULL)
ORDER BY DataAssegnazione DESC, DotazioneId DESC;
""";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var items = (await connection.QueryAsync<DotazioneDto>(
            new CommandDefinition(sql, new { DipendenteId = dipendenteId, IncludeDeleted = includeDeleted ? 1 : 0 }, cancellationToken: cancellationToken))).ToArray();

        return Results.Ok(items);
    }

    public static async Task<IResult> CreateAsync(
        int dipendenteId,
        DotazioneCreateRequest request,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
INSERT INTO [RisorseUmane].[Dotazione]
(
  DipendenteId,
  TipoDotazioneId,
  Descrizione,
  NumeroInventario,
  NumeroSerie,
  DataAssegnazione,
  DataRestituzione,
  IsRestituito,
  Note
)
OUTPUT INSERTED.DotazioneId
VALUES
(
  @DipendenteId,
  @TipoDotazioneId,
  @Descrizione,
  @NumeroInventario,
  @NumeroSerie,
  @DataAssegnazione,
  @DataRestituzione,
  @IsRestituito,
  @Note
);
""";

        try
        {
            await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
            var id = await connection.ExecuteScalarAsync<int>(
                new CommandDefinition(sql, new
                {
                    DipendenteId = dipendenteId,
                    request.TipoDotazioneId,
                    Descrizione = request.Descrizione.Trim(),
                    request.NumeroInventario,
                    request.NumeroSerie,
                    request.DataAssegnazione,
                    request.DataRestituzione,
                    IsRestituito = request.IsRestituito ?? false,
                    request.Note
                }, cancellationToken: cancellationToken));

            return Results.Created($"/v1/dotazioni/{id}", new DotazioneCreateResponse(id));
        }
        catch (SqlException ex) when (ex.Number == 547)
        {
            return Results.Conflict(new ErrorResponse("Vincolo FK violato (verificare riferimenti)."));
        }
    }

    public static async Task<IResult> UpdateAsync(
        int dipendenteId,
        int id,
        DotazioneUpdateRequest request,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
UPDATE [RisorseUmane].[Dotazione]
SET
  TipoDotazioneId = @TipoDotazioneId,
  Descrizione = @Descrizione,
  NumeroInventario = @NumeroInventario,
  NumeroSerie = @NumeroSerie,
  DataAssegnazione = @DataAssegnazione,
  DataRestituzione = @DataRestituzione,
  IsRestituito = @IsRestituito,
  Note = @Note,
  DataModifica = SYSUTCDATETIME()
WHERE DotazioneId = @Id
  AND DipendenteId = @DipendenteId
  AND DataCancellazione IS NULL;

SELECT @@ROWCOUNT;
""";

        try
        {
            await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
            var rows = await connection.ExecuteScalarAsync<int>(
                new CommandDefinition(sql, new
                {
                    Id = id,
                    DipendenteId = dipendenteId,
                    request.TipoDotazioneId,
                    Descrizione = request.Descrizione.Trim(),
                    request.NumeroInventario,
                    request.NumeroSerie,
                    request.DataAssegnazione,
                    request.DataRestituzione,
                    IsRestituito = request.IsRestituito ?? false,
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
UPDATE [RisorseUmane].[Dotazione]
SET
  DataCancellazione = SYSUTCDATETIME(),
  DataModifica = SYSUTCDATETIME()
WHERE DotazioneId = @Id
  AND DipendenteId = @DipendenteId
  AND DataCancellazione IS NULL;

SELECT @@ROWCOUNT;
""";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(sql, new { Id = id, DipendenteId = dipendenteId }, cancellationToken: cancellationToken));

        return rows == 0 ? Results.NotFound() : Results.NoContent();
    }
}

internal sealed record ErrorResponse(string Error);

