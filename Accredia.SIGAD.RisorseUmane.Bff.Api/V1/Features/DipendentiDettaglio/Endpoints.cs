using System.Net;
using Accredia.SIGAD.RisorseUmane.Bff.Api.Services;

namespace Accredia.SIGAD.RisorseUmane.Bff.Api.V1.Features.DipendentiDettaglio;

internal static class Endpoints
{
    public static void Map(IEndpointRouteBuilder app)
    {
        ApiVersioning.MapVersionedGet(app, "/dipendenti/dettaglio", "DipendentiDettaglioList", async (
                int? personaId,
                string? matricola,
                bool? includeDeleted,
                int? page,
                int? pageSize,
                IRisorseUmaneClient risorseUmane,
                IAnagraficheClient anagrafiche,
                CancellationToken cancellationToken) =>
            {
                var (hrStatus, hrPage) = await risorseUmane.ListDipendentiAsync(
                    personaId,
                    matricola,
                    includeDeleted,
                    page,
                    pageSize,
                    cancellationToken);

                if (hrStatus != HttpStatusCode.OK || hrPage is null)
                {
                    return Results.Problem("Downstream RisorseUmane error.", statusCode: StatusCodes.Status503ServiceUnavailable);
                }

                var personaIds = hrPage.Items.Select(x => x.PersonaId).Distinct().ToArray();
                var personaById = new Dictionary<int, PersonaDetailDto>(capacity: personaIds.Length);

                // Avoid firing too many concurrent requests to Anagrafiche.
                using var gate = new SemaphoreSlim(10);
                var tasks = personaIds.Select(async pid =>
                {
                    await gate.WaitAsync(cancellationToken);
                    try
                    {
                        var (anStatus, persona) = await anagrafiche.GetPersonaByIdAsync(pid, cancellationToken);
                        if (anStatus == HttpStatusCode.NotFound)
                        {
                            return (pid, StatusCodes.Status502BadGateway, (PersonaDetailDto?)null);
                        }

                        if (anStatus != HttpStatusCode.OK || persona is null)
                        {
                            return (pid, StatusCodes.Status503ServiceUnavailable, (PersonaDetailDto?)null);
                        }

                        return (pid, 0, persona);
                    }
                    finally
                    {
                        gate.Release();
                    }
                }).ToArray();

                var results = await Task.WhenAll(tasks);
                var firstError = results.FirstOrDefault(x => x.Item2 != 0);
                if (firstError.Item2 != 0)
                {
                    return firstError.Item2 == StatusCodes.Status502BadGateway
                        ? Results.Problem("Persona not found in Anagrafiche.", statusCode: StatusCodes.Status502BadGateway)
                        : Results.Problem("Downstream Anagrafiche error.", statusCode: StatusCodes.Status503ServiceUnavailable);
                }

                foreach (var r in results)
                {
                    personaById[r.pid] = r.Item3!;
                }

                var items = hrPage.Items
                    .Select(d => new DipendenteDettaglioListItemDto(d, personaById[d.PersonaId]))
                    .ToArray();

                return Results.Ok(new PagedResponse<DipendenteDettaglioListItemDto>(
                    items,
                    hrPage.Page,
                    hrPage.PageSize,
                    hrPage.TotalCount));
            },
            builder => builder
                .Produces<PagedResponse<DipendenteDettaglioListItemDto>>(StatusCodes.Status200OK)
                .ProducesProblem(StatusCodes.Status502BadGateway)
                .ProducesProblem(StatusCodes.Status503ServiceUnavailable));

        ApiVersioning.MapVersionedGet(app, "/dipendenti/{id:int}/dettaglio", "DipendentiDettaglioGetById", async (
                int id,
                IRisorseUmaneClient risorseUmane,
                IAnagraficheClient anagrafiche,
                CancellationToken cancellationToken) =>
            {
                var (hrStatus, dipendente) = await risorseUmane.GetDipendenteAsync(id, cancellationToken);
                if (hrStatus == HttpStatusCode.NotFound)
                {
                    return Results.NotFound();
                }

                if (hrStatus != HttpStatusCode.OK || dipendente is null)
                {
                    return Results.Problem("Downstream RisorseUmane error.", statusCode: StatusCodes.Status503ServiceUnavailable);
                }

                var (anStatus, persona) = await anagrafiche.GetPersonaByIdAsync(dipendente.PersonaId, cancellationToken);
                if (anStatus == HttpStatusCode.NotFound)
                {
                    // Invariant violation: HR references a missing Persona.
                    return Results.Problem("Persona not found in Anagrafiche.", statusCode: StatusCodes.Status502BadGateway);
                }

                if (anStatus != HttpStatusCode.OK || persona is null)
                {
                    return Results.Problem("Downstream Anagrafiche error.", statusCode: StatusCodes.Status503ServiceUnavailable);
                }

                return Results.Ok(new DipendenteDettaglioDto(dipendente, persona));
            },
            builder => builder
                .Produces<DipendenteDettaglioDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesProblem(StatusCodes.Status502BadGateway)
                .ProducesProblem(StatusCodes.Status503ServiceUnavailable));
    }
}

internal sealed record DipendenteDettaglioDto(
    DipendenteDto Dipendente,
    PersonaDetailDto Persona);

internal sealed record DipendenteDettaglioListItemDto(
    DipendenteDto Dipendente,
    PersonaDetailDto Persona);
