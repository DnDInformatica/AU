using System.Data;
using Dapper;
using Microsoft.Data.SqlClient;
using Accredia.SIGAD.RisorseUmane.Api.Database;

namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.Dipendenti;

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
  DipendenteId,
  PersonaId,
  Matricola,
  EmailAziendale,
  TelefonoInterno,
  UnitaOrganizzativaId,
  ResponsabileDirettoId,
  DataAssunzione,
  DataCessazione,
  StatoDipendenteId,
  AbilitatoAttivitaIspettiva,
  Note,
  DataCreazione,
  DataModifica,
  DataCancellazione
FROM [RisorseUmane].[Dipendente]
WHERE DipendenteId = @Id
  AND (@IncludeDeleted = 1 OR DataCancellazione IS NULL);
""";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var dto = await connection.QuerySingleOrDefaultAsync<DipendenteDto>(
            new CommandDefinition(sql, new { Id = id, IncludeDeleted = includeDeleted ? 1 : 0 }, cancellationToken: cancellationToken));

        return dto is null ? Results.NotFound() : Results.Ok(dto);
    }

    public static async Task<IResult> ListAsync(
        int? personaId,
        string? matricola,
        bool includeDeleted,
        int page,
        int pageSize,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
SELECT
  DipendenteId,
  PersonaId,
  Matricola,
  EmailAziendale,
  TelefonoInterno,
  UnitaOrganizzativaId,
  ResponsabileDirettoId,
  DataAssunzione,
  DataCessazione,
  StatoDipendenteId,
  AbilitatoAttivitaIspettiva,
  Note,
  DataCreazione,
  DataModifica,
  DataCancellazione
FROM [RisorseUmane].[Dipendente]
WHERE (@PersonaId IS NULL OR PersonaId = @PersonaId)
  AND (@Matricola IS NULL OR Matricola LIKE '%' + @Matricola + '%')
  AND (@IncludeDeleted = 1 OR DataCancellazione IS NULL)
ORDER BY DipendenteId
OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;

SELECT COUNT(1)
FROM [RisorseUmane].[Dipendente]
WHERE (@PersonaId IS NULL OR PersonaId = @PersonaId)
  AND (@Matricola IS NULL OR Matricola LIKE '%' + @Matricola + '%')
  AND (@IncludeDeleted = 1 OR DataCancellazione IS NULL);
""";

        var normalizedMatricola = string.IsNullOrWhiteSpace(matricola) ? null : matricola.Trim();
        var normalizedPage = Math.Max(1, page);
        var normalizedPageSize = Math.Clamp(pageSize, 1, 200);
        var offset = (normalizedPage - 1) * normalizedPageSize;

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        using var multi = await connection.QueryMultipleAsync(
            new CommandDefinition(
                sql,
                new
                {
                    PersonaId = personaId,
                    Matricola = normalizedMatricola,
                    IncludeDeleted = includeDeleted ? 1 : 0,
                    Offset = offset,
                    PageSize = normalizedPageSize
                },
                cancellationToken: cancellationToken));

        var items = (await multi.ReadAsync<DipendenteDto>()).ToArray();
        var totalCount = await multi.ReadSingleAsync<int>();

        return Results.Ok(new PagedResponse<DipendenteDto>(items, normalizedPage, normalizedPageSize, totalCount));
    }

    public static async Task<IResult> CreateAsync(
        DipendenteCreateRequest request,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
INSERT INTO [RisorseUmane].[Dipendente]
(
  PersonaId,
  Matricola,
  EmailAziendale,
  TelefonoInterno,
  UnitaOrganizzativaId,
  ResponsabileDirettoId,
  DataAssunzione,
  DataCessazione,
  StatoDipendenteId,
  AbilitatoAttivitaIspettiva,
  Note
)
OUTPUT INSERTED.DipendenteId
VALUES
(
  @PersonaId,
  @Matricola,
  @EmailAziendale,
  @TelefonoInterno,
  @UnitaOrganizzativaId,
  @ResponsabileDirettoId,
  @DataAssunzione,
  @DataCessazione,
  @StatoDipendenteId,
  @AbilitatoAttivitaIspettiva,
  @Note
);
""";

        try
        {
            await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
            var id = await connection.ExecuteScalarAsync<int>(
                new CommandDefinition(sql, new
                {
                    request.PersonaId,
                    Matricola = request.Matricola.Trim(),
                    request.EmailAziendale,
                    request.TelefonoInterno,
                    request.UnitaOrganizzativaId,
                    request.ResponsabileDirettoId,
                    request.DataAssunzione,
                    request.DataCessazione,
                    request.StatoDipendenteId,
                    AbilitatoAttivitaIspettiva = request.AbilitatoAttivitaIspettiva ?? false,
                    request.Note
                }, cancellationToken: cancellationToken));

            return Results.Created($"/v1/dipendenti/{id}", new DipendenteCreateResponse(id));
        }
        catch (SqlException ex) when (ex.Number is 2627 or 2601)
        {
            return Results.Conflict(new ErrorResponse("Dipendente gia presente (vincolo univocita violato)."));
        }
        catch (SqlException ex) when (ex.Number == 547)
        {
            return Results.Conflict(new ErrorResponse("Vincolo FK violato (verificare riferimenti)."));
        }
    }

    public static async Task<IResult> UpdateAsync(
        int id,
        DipendenteUpdateRequest request,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
UPDATE [RisorseUmane].[Dipendente]
SET
  PersonaId = @PersonaId,
  Matricola = @Matricola,
  EmailAziendale = @EmailAziendale,
  TelefonoInterno = @TelefonoInterno,
  UnitaOrganizzativaId = @UnitaOrganizzativaId,
  ResponsabileDirettoId = @ResponsabileDirettoId,
  DataAssunzione = @DataAssunzione,
  DataCessazione = @DataCessazione,
  StatoDipendenteId = @StatoDipendenteId,
  AbilitatoAttivitaIspettiva = @AbilitatoAttivitaIspettiva,
  Note = @Note,
  DataModifica = SYSUTCDATETIME()
WHERE DipendenteId = @Id
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
                    request.PersonaId,
                    Matricola = request.Matricola.Trim(),
                    request.EmailAziendale,
                    request.TelefonoInterno,
                    request.UnitaOrganizzativaId,
                    request.ResponsabileDirettoId,
                    request.DataAssunzione,
                    request.DataCessazione,
                    request.StatoDipendenteId,
                    AbilitatoAttivitaIspettiva = request.AbilitatoAttivitaIspettiva ?? false,
                    request.Note
                }, cancellationToken: cancellationToken));

            return rows == 0 ? Results.NotFound() : Results.NoContent();
        }
        catch (SqlException ex) when (ex.Number is 2627 or 2601)
        {
            return Results.Conflict(new ErrorResponse("Dipendente gia presente (vincolo univocita violato)."));
        }
        catch (SqlException ex) when (ex.Number == 547)
        {
            return Results.Conflict(new ErrorResponse("Vincolo FK violato (verificare riferimenti)."));
        }
    }

    public static async Task<IResult> SoftDeleteAsync(
        int id,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
UPDATE [RisorseUmane].[Dipendente]
SET
  DataCancellazione = SYSUTCDATETIME(),
  DataModifica = SYSUTCDATETIME()
WHERE DipendenteId = @Id
  AND DataCancellazione IS NULL;

SELECT @@ROWCOUNT;
""";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = await connection.ExecuteScalarAsync<int>(
            new CommandDefinition(sql, new { Id = id }, cancellationToken: cancellationToken));

        return rows == 0 ? Results.NotFound() : Results.NoContent();
    }

    public static async Task<IResult> StoricoAsync(
        int id,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
SELECT
  DipendenteId,
  PersonaId,
  Matricola,
  EmailAziendale,
  TelefonoInterno,
  UnitaOrganizzativaId,
  ResponsabileDirettoId,
  DataAssunzione,
  DataCessazione,
  StatoDipendenteId,
  AbilitatoAttivitaIspettiva,
  Note,
  DataCreazione,
  DataModifica,
  DataCancellazione,
  DataInizioValidita,
  DataFineValidita
FROM [RisorseUmane].[DipendenteStorico]
WHERE DipendenteId = @Id
ORDER BY DataInizioValidita;
""";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var items = (await connection.QueryAsync<DipendenteStoricoDto>(
            new CommandDefinition(sql, new { Id = id }, cancellationToken: cancellationToken))).ToArray();

        return Results.Ok(items);
    }
}

internal sealed record ErrorResponse(string Error);

internal sealed record PagedResponse<T>(
    IReadOnlyCollection<T> Items,
    int Page,
    int PageSize,
    int TotalCount);

