namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Qualifiche;

internal sealed record PersonaQualificaDto(
    int PersonaQualificaId,
    int PersonaId,
    int TipoQualificaId,
    int? EnteRilascioQualificaId,
    string? CodiceAttestato,
    DateTime? DataRilascio,
    DateTime? DataScadenza,
    bool Valida,
    string? Note,
    DateTime? DataCancellazione);

internal sealed record TipoQualificaLookupItem(
    int Id,
    string Code,
    string Description,
    string? Category,
    bool RichiedeScadenza);

internal sealed record EnteRilascioQualificaLookupItem(
    int Id,
    string Code,
    string Description);

internal sealed record QualificheLookupsResponse(
    IReadOnlyList<TipoQualificaLookupItem> Tipi,
    IReadOnlyList<EnteRilascioQualificaLookupItem> Enti);
