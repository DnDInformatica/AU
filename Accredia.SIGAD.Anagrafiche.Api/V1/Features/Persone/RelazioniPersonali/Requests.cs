namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.RelazioniPersonali;

internal sealed record CreateRequest(
    int PersonaCollegataId,
    int TipoRelazionePersonaleId,
    string? Note);

internal sealed record UpdateRequest(
    int PersonaCollegataId,
    int TipoRelazionePersonaleId,
    string? Note);

