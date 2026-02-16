namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.TitoliStudio;

internal sealed record PersonaTitoloStudioDto(
    int PersonaTitoloStudioId,
    int PersonaId,
    int TipoTitoloStudioId,
    string? Istituzione,
    string? Corso,
    DateTime? DataConseguimento,
    string? Voto,
    bool Lode,
    string? Paese,
    string? Note,
    bool Principale,
    DateTime? DataCancellazione);

internal sealed record TipoTitoloStudioLookupItem(
    int Id,
    string Code,
    string Description,
    int LivelloTitoloStudioId,
    int TipoSistemaFormativoId,
    bool HaValoreLegale,
    bool RichiedeTitoloPrevio);

internal sealed record TitoliStudioLookupsResponse(
    IReadOnlyList<TipoTitoloStudioLookupItem> Tipi);

