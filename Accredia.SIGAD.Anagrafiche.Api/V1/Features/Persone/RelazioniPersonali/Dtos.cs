namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.RelazioniPersonali;

internal sealed record TipoRelazionePersonaleLookupItem(
    int Id,
    string Code,
    string Description,
    bool Symmetric,
    int? InverseId);

internal sealed record PersonaRelazionePersonaleDto(
    int PersonaRelazionePersonaleId,
    int PersonaId,
    int PersonaCollegataId,
    int TipoRelazionePersonaleId,
    string? Note,
    DateTime? DataCancellazione);

