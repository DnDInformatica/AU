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
        var row = await connection.QuerySingleOrDefaultAsync<DipendenteDbRow>(
            new CommandDefinition(sql, new { Id = id, IncludeDeleted = includeDeleted ? 1 : 0 }, cancellationToken: cancellationToken));

        return row is null ? Results.NotFound() : Results.Ok(ToDipendenteDto(row));
    }

    public static async Task<IResult> ListAsync(
        int? personaId,
        string? matricola,
        string? q,
        int? statoDipendenteId,
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
  AND (@Q IS NULL OR Matricola LIKE '%' + @Q + '%' OR EmailAziendale LIKE '%' + @Q + '%' OR TelefonoInterno LIKE '%' + @Q + '%')
  AND (@StatoDipendenteId IS NULL OR StatoDipendenteId = @StatoDipendenteId)
  AND (@IncludeDeleted = 1 OR DataCancellazione IS NULL)
ORDER BY DipendenteId
OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY;

SELECT COUNT(1)
FROM [RisorseUmane].[Dipendente]
WHERE (@PersonaId IS NULL OR PersonaId = @PersonaId)
  AND (@Matricola IS NULL OR Matricola LIKE '%' + @Matricola + '%')
  AND (@Q IS NULL OR Matricola LIKE '%' + @Q + '%' OR EmailAziendale LIKE '%' + @Q + '%' OR TelefonoInterno LIKE '%' + @Q + '%')
  AND (@StatoDipendenteId IS NULL OR StatoDipendenteId = @StatoDipendenteId)
  AND (@IncludeDeleted = 1 OR DataCancellazione IS NULL);
""";

        var normalizedMatricola = string.IsNullOrWhiteSpace(matricola) ? null : matricola.Trim();
        var normalizedQ = string.IsNullOrWhiteSpace(q) ? null : q.Trim();
        var normalizedStatoDipendenteId = statoDipendenteId > 0 ? statoDipendenteId : null;
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
                    Q = normalizedQ,
                    StatoDipendenteId = normalizedStatoDipendenteId,
                    IncludeDeleted = includeDeleted ? 1 : 0,
                    Offset = offset,
                    PageSize = normalizedPageSize
                },
                cancellationToken: cancellationToken));

        var items = (await multi.ReadAsync<DipendenteDbRow>())
            .Select(ToDipendenteDto)
            .ToArray();
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
            var dataAssunzione = request.DataAssunzione.ToDateTime(TimeOnly.MinValue);
            var dataCessazione = request.DataCessazione?.ToDateTime(TimeOnly.MinValue);

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
                    DataAssunzione = dataAssunzione,
                    DataCessazione = dataCessazione,
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
        catch (SqlException ex) when (ex.Number == 2628)
        {
            return Results.ValidationProblem(new Dictionary<string, string[]>
            {
                ["request"] = ["Dati troppo lunghi per il formato previsto dal database."]
            });
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
            var dataAssunzione = request.DataAssunzione.ToDateTime(TimeOnly.MinValue);
            var dataCessazione = request.DataCessazione?.ToDateTime(TimeOnly.MinValue);

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
                    DataAssunzione = dataAssunzione,
                    DataCessazione = dataCessazione,
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
        catch (SqlException ex) when (ex.Number == 2628)
        {
            return Results.ValidationProblem(new Dictionary<string, string[]>
            {
                ["request"] = ["Dati troppo lunghi per il formato previsto dal database."]
            });
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
        var items = (await connection.QueryAsync<DipendenteStoricoDbRow>(
                new CommandDefinition(sql, new { Id = id }, cancellationToken: cancellationToken)))
            .Select(ToDipendenteStoricoDto)
            .ToArray();

        return Results.Ok(items);
    }

    private static DipendenteDto ToDipendenteDto(DipendenteDbRow row)
        => new(
            row.DipendenteId,
            row.PersonaId,
            row.Matricola,
            row.EmailAziendale,
            row.TelefonoInterno,
            row.UnitaOrganizzativaId,
            row.ResponsabileDirettoId,
            DateOnly.FromDateTime(row.DataAssunzione),
            row.DataCessazione is null ? null : DateOnly.FromDateTime(row.DataCessazione.Value),
            row.StatoDipendenteId,
            row.AbilitatoAttivitaIspettiva,
            row.Note,
            row.DataCreazione,
            row.DataModifica,
            row.DataCancellazione);

    private static DipendenteStoricoDto ToDipendenteStoricoDto(DipendenteStoricoDbRow row)
        => new(
            row.DipendenteId,
            row.PersonaId,
            row.Matricola,
            row.EmailAziendale,
            row.TelefonoInterno,
            row.UnitaOrganizzativaId,
            row.ResponsabileDirettoId,
            DateOnly.FromDateTime(row.DataAssunzione),
            row.DataCessazione is null ? null : DateOnly.FromDateTime(row.DataCessazione.Value),
            row.StatoDipendenteId,
            row.AbilitatoAttivitaIspettiva,
            row.Note,
            row.DataCreazione,
            row.DataModifica,
            row.DataCancellazione,
            row.DataInizioValidita,
            row.DataFineValidita);
}

internal sealed record ErrorResponse(string Error);

internal sealed record PagedResponse<T>(
    IReadOnlyCollection<T> Items,
    int Page,
    int PageSize,
    int TotalCount);

internal sealed record DipendenteDbRow(
    int DipendenteId,
    int PersonaId,
    string Matricola,
    string? EmailAziendale,
    string? TelefonoInterno,
    int? UnitaOrganizzativaId,
    int? ResponsabileDirettoId,
    DateTime DataAssunzione,
    DateTime? DataCessazione,
    int StatoDipendenteId,
    bool AbilitatoAttivitaIspettiva,
    string? Note,
    DateTime DataCreazione,
    DateTime? DataModifica,
    DateTime? DataCancellazione);

internal sealed record DipendenteStoricoDbRow(
    int DipendenteId,
    int PersonaId,
    string Matricola,
    string? EmailAziendale,
    string? TelefonoInterno,
    int? UnitaOrganizzativaId,
    int? ResponsabileDirettoId,
    DateTime DataAssunzione,
    DateTime? DataCessazione,
    int StatoDipendenteId,
    bool AbilitatoAttivitaIspettiva,
    string? Note,
    DateTime DataCreazione,
    DateTime? DataModifica,
    DateTime? DataCancellazione,
    DateTime DataInizioValidita,
    DateTime DataFineValidita);
