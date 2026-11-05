using Accredia.SIGAD.Shared.Auth;
using Accredia.SIGAD.RisorseUmane.Api.Database;

namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.Reports;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/report/formazione-in-scadenza", "ReportFormazioneInScadenza",
            async (int? days, ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken) =>
            {
                var windowDays = days ?? 90;
                if (windowDays <= 0 || windowDays > 365)
                {
                    return Results.ValidationProblem(new Dictionary<string, string[]>(StringComparer.Ordinal)
                    {
                        ["days"] = ["days deve essere compreso tra 1 e 365."]
                    });
                }

                return await Handler.FormazioneInScadenzaAsync(windowDays, connectionFactory, cancellationToken);
            },
            builder => builder
                .RichiedePermesso("HR.FORM.LIST", "HR.FORM.READ")
                .Produces<IReadOnlyCollection<FormazioneInScadenzaDto>>(StatusCodes.Status200OK)
                .ProducesValidationProblem());

        ApiVersioning.MapVersionedGet(app, "/report/dotazioni-non-restituite-cessati", "ReportDotazioniNonRestituiteCessati",
            async (ISqlConnectionFactory connectionFactory, CancellationToken cancellationToken)
                => await Handler.DotazioniNonRestituiteCessatiAsync(connectionFactory, cancellationToken),
            builder => builder
                .RichiedePermesso("HR.DOTAZIONI.LIST", "HR.DOTAZIONI.READ")
                .Produces<IReadOnlyCollection<DotazioneNonRestituitaCessatoDto>>(StatusCodes.Status200OK));
    }
}
