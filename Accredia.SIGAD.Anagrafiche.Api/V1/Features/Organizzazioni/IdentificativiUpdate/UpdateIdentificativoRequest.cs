namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.IdentificativiUpdate;

internal sealed record UpdateIdentificativoRequest(
    string PaeseISO2,
    string TipoIdentificativo,
    string Valore,
    bool Principale,
    string? Note);

