using Dapper;
using Microsoft.Data.SqlClient;
using Accredia.SIGAD.RisorseUmane.Api.Database;

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
        var dto = await connection.QuerySingleOrDefaultAsync<ContrattoDto>(
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
        var items = (await connection.QueryAsync<ContrattoDto>(
            new CommandDefinition(sql, new { DipendenteId = dipendenteId, IncludeDeleted = includeDeleted ? 1 : 0 }, cancellationToken: cancellationToken))).ToArray();

        return Results.Ok(items);
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
            var id = await connection.ExecuteScalarAsync<int>(
                new CommandDefinition(sql, new
                {
                    DipendenteId = dipendenteId,
                    request.TipoContrattoId,
                    request.DataInizio,
                    request.DataFine,
                    request.LivelloInquadramento,
                    request.CCNLApplicato,
                    request.RAL,
                    request.PercentualePartTime,
                    request.OreLavoroSettimanali,
                    IsContrattoCorrente = request.IsContrattoCorrente ?? false,
                    request.Note
                }, cancellationToken: cancellationToken));

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
            var rows = await connection.ExecuteScalarAsync<int>(
                new CommandDefinition(sql, new
                {
                    Id = id,
                    DipendenteId = dipendenteId,
                    request.TipoContrattoId,
                    request.DataInizio,
                    request.DataFine,
                    request.LivelloInquadramento,
                    request.CCNLApplicato,
                    request.RAL,
                    request.PercentualePartTime,
                    request.OreLavoroSettimanali,
                    IsContrattoCorrente = request.IsContrattoCorrente ?? false,
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
        var items = (await connection.QueryAsync<ContrattoStoricoDto>(
            new CommandDefinition(sql, new { Id = id }, cancellationToken: cancellationToken))).ToArray();

        return Results.Ok(items);
    }
}

internal sealed record ErrorResponse(string Error);

