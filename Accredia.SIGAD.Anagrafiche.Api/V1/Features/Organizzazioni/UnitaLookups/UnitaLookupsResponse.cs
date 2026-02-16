namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaLookups;

internal sealed record UnitaLookupsResponse(
    IReadOnlyList<LookupItem> TipiUnitaOrganizzativa,
    IReadOnlyList<LookupItem> TipiSede);

