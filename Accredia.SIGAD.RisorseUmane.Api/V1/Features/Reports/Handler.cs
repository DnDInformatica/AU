using Dapper;
using Accredia.SIGAD.RisorseUmane.Api.Database;

namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.Reports;

internal static class Handler
{
    public static async Task<IResult> FormazioneInScadenzaAsync(
        int days,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
SELECT
  f.FormazioneObbligatoriaId,
  f.DipendenteId,
  f.TipoFormazioneObbligatoriaId,
  f.DataCompletamento,
  f.DataScadenza,
  DATEDIFF(DAY, CAST(SYSUTCDATETIME() AS date), f.DataScadenza) AS GiorniAllaScadenza
FROM [RisorseUmane].[FormazioneObbligatoria] f
WHERE f.DataCancellazione IS NULL
  AND f.DataScadenza IS NOT NULL
  AND f.DataScadenza >= CAST(SYSUTCDATETIME() AS date)
  AND f.DataScadenza <= DATEADD(DAY, @Days, CAST(SYSUTCDATETIME() AS date))
ORDER BY f.DataScadenza ASC, f.DipendenteId ASC;
""";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = (await connection.QueryAsync<FormazioneInScadenzaDbRow>(
            new CommandDefinition(sql, new { Days = days }, cancellationToken: cancellationToken))).ToArray();

        return Results.Ok(rows.Select(Map).ToArray());
    }

    public static async Task<IResult> DotazioniNonRestituiteCessatiAsync(
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        const string sql = """
SELECT
  d.DipendenteId,
  d.DataCessazione,
  z.DotazioneId,
  z.TipoDotazioneId,
  z.Descrizione,
  z.DataAssegnazione,
  z.DataRestituzione,
  z.IsRestituito
FROM [RisorseUmane].[Dipendente] d
INNER JOIN [RisorseUmane].[Dotazione] z ON z.DipendenteId = d.DipendenteId
WHERE d.DataCancellazione IS NULL
  AND z.DataCancellazione IS NULL
  AND d.DataCessazione IS NOT NULL
  AND d.DataCessazione <= CAST(SYSUTCDATETIME() AS date)
  AND (z.IsRestituito = 0 OR z.DataRestituzione IS NULL)
ORDER BY d.DataCessazione DESC, d.DipendenteId ASC, z.DotazioneId ASC;
""";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var rows = (await connection.QueryAsync<DotazioneNonRestituitaDbRow>(
            new CommandDefinition(sql, cancellationToken: cancellationToken))).ToArray();

        return Results.Ok(rows.Select(Map).ToArray());
    }

    private static FormazioneInScadenzaDto Map(FormazioneInScadenzaDbRow row)
        => new(
            row.FormazioneObbligatoriaId,
            row.DipendenteId,
            row.TipoFormazioneObbligatoriaId,
            DateOnly.FromDateTime(row.DataCompletamento),
            DateOnly.FromDateTime(row.DataScadenza),
            row.GiorniAllaScadenza);

    private static DotazioneNonRestituitaCessatoDto Map(DotazioneNonRestituitaDbRow row)
        => new(
            row.DipendenteId,
            DateOnly.FromDateTime(row.DataCessazione),
            row.DotazioneId,
            row.TipoDotazioneId,
            row.Descrizione,
            DateOnly.FromDateTime(row.DataAssegnazione),
            row.DataRestituzione.HasValue ? DateOnly.FromDateTime(row.DataRestituzione.Value) : null,
            row.IsRestituito);
}

internal sealed record FormazioneInScadenzaDbRow(
    int FormazioneObbligatoriaId,
    int DipendenteId,
    int TipoFormazioneObbligatoriaId,
    DateTime DataCompletamento,
    DateTime DataScadenza,
    int GiorniAllaScadenza);

internal sealed record DotazioneNonRestituitaDbRow(
    int DipendenteId,
    DateTime DataCessazione,
    int DotazioneId,
    int TipoDotazioneId,
    string Descrizione,
    DateTime DataAssegnazione,
    DateTime? DataRestituzione,
    bool IsRestituito);
