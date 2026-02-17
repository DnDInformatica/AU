using System.Net;
using Accredia.SIGAD.RisorseUmane.Bff.Api.Services;

namespace Accredia.SIGAD.RisorseUmane.Bff.Api.V1.Features.Reports;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/report/formazione-in-scadenza", "BffReportFormazioneInScadenza", async (
                int? days,
                IRisorseUmaneClient risorseUmane,
                CancellationToken cancellationToken) =>
            {
                var windowDays = days ?? 90;
                if (windowDays <= 0 || windowDays > 365)
                {
                    return Results.ValidationProblem(new Dictionary<string, string[]>(StringComparer.Ordinal)
                    {
                        ["days"] = ["days deve essere compreso tra 1 e 365."]
                    });
                }

                var (status, value) = await risorseUmane.GetFormazioneInScadenzaAsync(windowDays, cancellationToken);
                if (status != HttpStatusCode.OK || value is null)
                {
                    return Results.Problem("Downstream RisorseUmane error.", statusCode: StatusCodes.Status503ServiceUnavailable);
                }

                return Results.Ok(value);
            },
            builder => builder
                .Produces<IReadOnlyCollection<FormazioneInScadenzaDto>>(StatusCodes.Status200OK)
                .ProducesValidationProblem()
                .ProducesProblem(StatusCodes.Status503ServiceUnavailable));

        ApiVersioning.MapVersionedGet(app, "/report/dotazioni-non-restituite-cessati", "BffReportDotazioniNonRestituiteCessati", async (
                IRisorseUmaneClient risorseUmane,
                CancellationToken cancellationToken) =>
            {
                var (status, value) = await risorseUmane.GetDotazioniNonRestituiteCessatiAsync(cancellationToken);
                if (status != HttpStatusCode.OK || value is null)
                {
                    return Results.Problem("Downstream RisorseUmane error.", statusCode: StatusCodes.Status503ServiceUnavailable);
                }

                return Results.Ok(value);
            },
            builder => builder
                .Produces<IReadOnlyCollection<DotazioneNonRestituitaCessatoDto>>(StatusCodes.Status200OK)
                .ProducesProblem(StatusCodes.Status503ServiceUnavailable));
    }
}
