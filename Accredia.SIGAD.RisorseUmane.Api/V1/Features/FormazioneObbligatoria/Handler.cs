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
        var dto = await connection.QuerySingleOrDefaultAsync<FormazioneObbligatoriaDto>(
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
        var items = (await connection.QueryAsync<FormazioneObbligatoriaDto>(
            new CommandDefinition(sql, new { DipendenteId = dipendenteId, IncludeDeleted = includeDeleted ? 1 : 0 }, cancellationToken: cancellationToken))).ToArray();

        return Results.Ok(items);
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
            var id = await connection.ExecuteScalarAsync<int>(
                new CommandDefinition(sql, new
                {
                    DipendenteId = dipendenteId,
                    request.TipoFormazioneObbligatoriaId,
                    request.DataCompletamento,
                    request.DataScadenza,
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
            var rows = await connection.ExecuteScalarAsync<int>(
                new CommandDefinition(sql, new
                {
                    Id = id,
                    DipendenteId = dipendenteId,
                    request.TipoFormazioneObbligatoriaId,
                    request.DataCompletamento,
                    request.DataScadenza,
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
}

internal sealed record ErrorResponse(string Error);

