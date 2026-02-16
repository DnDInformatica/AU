namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.IdentificativiCreate;

internal sealed record CreateIdentificativoRequest(
    string PaeseISO2,
    string TipoIdentificativo,
    string Valore,
    bool Principale,
    string? Note);

