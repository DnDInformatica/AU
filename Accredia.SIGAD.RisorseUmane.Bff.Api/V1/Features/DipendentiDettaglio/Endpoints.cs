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
                string? q,
                int? statoDipendenteId,
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
                    q,
                    statoDipendenteId,
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

        ApiVersioning.MapVersionedGet(app, "/dipendenti/dettaglio-completo", "DipendentiDettaglioCompletoList", async (
                int? personaId,
                string? matricola,
                string? q,
                int? statoDipendenteId,
                bool? includeDeleted,
                bool? includeDeletedAnagrafiche,
                int? page,
                int? pageSize,
                IRisorseUmaneClient risorseUmane,
                IAnagraficheClient anagrafiche,
                CancellationToken cancellationToken) =>
            {
                var (hrStatus, hrPage) = await risorseUmane.ListDipendentiAsync(
                    personaId,
                    matricola,
                    q,
                    statoDipendenteId,
                    includeDeleted,
                    page,
                    pageSize,
                    cancellationToken);

                if (hrStatus != HttpStatusCode.OK || hrPage is null)
                {
                    return Results.Problem("Downstream RisorseUmane error.", statusCode: StatusCodes.Status503ServiceUnavailable);
                }

                var anagraficheIncludeDeleted = includeDeletedAnagrafiche ?? false;
                var dipendenti = hrPage.Items.ToArray();
                var items = new DipendenteDettaglioCompletoListItemDto[dipendenti.Length];

                using var gate = new SemaphoreSlim(4);
                var tasks = dipendenti.Select(async (dipendente, index) =>
                {
                    await gate.WaitAsync(cancellationToken);
                    try
                    {
                        var result = await GetPersonaCompletaAsync(
                            dipendente.PersonaId,
                            anagraficheIncludeDeleted,
                            anagrafiche,
                            cancellationToken);

                        if (result.StatusCode != 0 || result.Value is null)
                        {
                            return (Index: index, StatusCode: result.StatusCode, Item: (DipendenteDettaglioCompletoListItemDto?)null);
                        }

                        return (
                            Index: index,
                            StatusCode: 0,
                            Item: new DipendenteDettaglioCompletoListItemDto(dipendente, result.Value));
                    }
                    finally
                    {
                        gate.Release();
                    }
                }).ToArray();

                var results = await Task.WhenAll(tasks);
                var firstError = results.FirstOrDefault(x => x.StatusCode != 0);
                if (firstError.StatusCode != 0)
                {
                    return firstError.StatusCode == StatusCodes.Status502BadGateway
                        ? Results.Problem("Persona not found in Anagrafiche.", statusCode: StatusCodes.Status502BadGateway)
                        : Results.Problem("Downstream Anagrafiche error.", statusCode: StatusCodes.Status503ServiceUnavailable);
                }

                foreach (var result in results)
                {
                    items[result.Index] = result.Item!;
                }

                return Results.Ok(new PagedResponse<DipendenteDettaglioCompletoListItemDto>(
                    items,
                    hrPage.Page,
                    hrPage.PageSize,
                    hrPage.TotalCount));
            },
            builder => builder
                .Produces<PagedResponse<DipendenteDettaglioCompletoListItemDto>>(StatusCodes.Status200OK)
                .ProducesProblem(StatusCodes.Status502BadGateway)
                .ProducesProblem(StatusCodes.Status503ServiceUnavailable));

        ApiVersioning.MapVersionedGet(app, "/dipendenti/{id:int}/dettaglio-completo", "DipendentiDettaglioCompletoGetById", async (
                int id,
                bool? includeDeletedAnagrafiche,
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

                var result = await GetPersonaCompletaAsync(
                    dipendente.PersonaId,
                    includeDeletedAnagrafiche ?? false,
                    anagrafiche,
                    cancellationToken);

                if (result.StatusCode != 0 || result.Value is null)
                {
                    return result.StatusCode == StatusCodes.Status502BadGateway
                        ? Results.Problem("Persona not found in Anagrafiche.", statusCode: StatusCodes.Status502BadGateway)
                        : Results.Problem("Downstream Anagrafiche error.", statusCode: StatusCodes.Status503ServiceUnavailable);
                }

                return Results.Ok(new DipendenteDettaglioCompletoDto(dipendente, result.Value));
            },
            builder => builder
                .Produces<DipendenteDettaglioCompletoDto>(StatusCodes.Status200OK)
                .Produces(StatusCodes.Status404NotFound)
                .ProducesProblem(StatusCodes.Status502BadGateway)
                .ProducesProblem(StatusCodes.Status503ServiceUnavailable));

        ApiVersioning.MapVersionedGet(app, "/persone/lookup", "PersoneLookup", async (
                string q,
                int? page,
                int? pageSize,
                IAnagraficheClient anagrafiche,
                CancellationToken cancellationToken) =>
            {
                if (string.IsNullOrWhiteSpace(q))
                {
                    return Results.ValidationProblem(new Dictionary<string, string[]>
                    {
                        ["q"] = ["Il parametro q e obbligatorio."]
                    });
                }

                var (status, response) = await anagrafiche.SearchPersoneAsync(q.Trim(), page, pageSize, cancellationToken);
                if (status != HttpStatusCode.OK || response is null)
                {
                    return Results.Problem("Downstream Anagrafiche error.", statusCode: StatusCodes.Status503ServiceUnavailable);
                }

                var items = response.Items
                    .Select(x => new PersonaLookupItemDto(
                        x.PersonaId,
                        x.Cognome,
                        x.Nome,
                        x.CodiceFiscale,
                        x.DataNascita))
                    .ToArray();

                return Results.Ok(new PagedResponse<PersonaLookupItemDto>(
                    items,
                    response.Page,
                    response.PageSize,
                    response.TotalCount));
            },
            builder => builder
                .Produces<PagedResponse<PersonaLookupItemDto>>(StatusCodes.Status200OK)
                .ProducesValidationProblem()
                .ProducesProblem(StatusCodes.Status503ServiceUnavailable));
    }

    private static async Task<(int StatusCode, PersonaCompletaDto? Value)> GetPersonaCompletaAsync(
        int personaId,
        bool includeDeletedAnagrafiche,
        IAnagraficheClient anagrafiche,
        CancellationToken cancellationToken)
    {
        var personaTask = anagrafiche.GetPersonaByIdAsync(personaId, cancellationToken);
        var emailTask = anagrafiche.GetPersonaEmailAsync(personaId, includeDeletedAnagrafiche, cancellationToken);
        var telefoniTask = anagrafiche.GetPersonaTelefoniAsync(personaId, includeDeletedAnagrafiche, cancellationToken);
        var indirizziTask = anagrafiche.GetPersonaIndirizziAsync(personaId, includeDeletedAnagrafiche, cancellationToken);
        var qualificheTask = anagrafiche.GetPersonaQualificheAsync(personaId, includeDeletedAnagrafiche, cancellationToken);
        var relazioniTask = anagrafiche.GetPersonaRelazioniPersonaliAsync(personaId, includeDeletedAnagrafiche, cancellationToken);
        var consensiTask = anagrafiche.GetPersonaConsensiAsync(personaId, includeDeletedAnagrafiche, cancellationToken);
        var richiesteGdprTask = anagrafiche.GetRichiesteGdprAsync(personaId, includeDeletedAnagrafiche, cancellationToken);
        var richiesteDirittiTask = anagrafiche.GetRichiesteEsercizioDirittiAsync(personaId, includeDeletedAnagrafiche, cancellationToken);

        await Task.WhenAll(
            personaTask,
            emailTask,
            telefoniTask,
            indirizziTask,
            qualificheTask,
            relazioniTask,
            consensiTask,
            richiesteGdprTask,
            richiesteDirittiTask);

        var (personaStatus, persona) = await personaTask;
        if (personaStatus != HttpStatusCode.OK || persona is null)
        {
            return (MapAnagraficheStatus(personaStatus), null);
        }

        var checks = new[]
        {
            (await emailTask).StatusCode,
            (await telefoniTask).StatusCode,
            (await indirizziTask).StatusCode,
            (await qualificheTask).StatusCode,
            (await relazioniTask).StatusCode,
            (await consensiTask).StatusCode,
            (await richiesteGdprTask).StatusCode,
            (await richiesteDirittiTask).StatusCode
        };

        var firstError = checks.FirstOrDefault(x => x != HttpStatusCode.OK);
        if (firstError != default)
        {
            return (MapAnagraficheStatus(firstError), null);
        }

        return (0, new PersonaCompletaDto(
            persona,
            (await emailTask).Value ?? [],
            (await telefoniTask).Value ?? [],
            (await indirizziTask).Value ?? [],
            (await qualificheTask).Value ?? [],
            (await relazioniTask).Value ?? [],
            (await consensiTask).Value ?? [],
            (await richiesteGdprTask).Value ?? [],
            (await richiesteDirittiTask).Value ?? []));
    }

    private static int MapAnagraficheStatus(HttpStatusCode statusCode)
        => statusCode == HttpStatusCode.NotFound
            ? StatusCodes.Status502BadGateway
            : StatusCodes.Status503ServiceUnavailable;
}

internal sealed record DipendenteDettaglioDto(
    DipendenteDto Dipendente,
    PersonaDetailDto Persona);

internal sealed record DipendenteDettaglioListItemDto(
    DipendenteDto Dipendente,
    PersonaDetailDto Persona);

internal sealed record DipendenteDettaglioCompletoDto(
    DipendenteDto Dipendente,
    PersonaCompletaDto Persona);

internal sealed record DipendenteDettaglioCompletoListItemDto(
    DipendenteDto Dipendente,
    PersonaCompletaDto Persona);

internal sealed record PersonaCompletaDto(
    PersonaDetailDto Dettaglio,
    IReadOnlyList<PersonaEmailItem> Email,
    IReadOnlyList<PersonaTelefonoItem> Telefoni,
    IReadOnlyList<PersonaIndirizzoItem> Indirizzi,
    IReadOnlyList<PersonaQualificaItem> Qualifiche,
    IReadOnlyList<PersonaRelazionePersonaleItem> RelazioniPersonali,
    IReadOnlyList<ConsensoPersonaItem> Consensi,
    IReadOnlyList<RichiestaGdprItem> RichiesteGdpr,
    IReadOnlyList<RichiestaEsercizioDirittiItem> RichiesteEsercizioDiritti);

internal sealed record PersonaLookupItemDto(
    int PersonaId,
    string Cognome,
    string Nome,
    string? CodiceFiscale,
    DateTime DataNascita);
