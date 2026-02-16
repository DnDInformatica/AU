namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetIdentificativi;

// Keep aligned with Accredia.SIGAD.Web.Models.Anagrafiche.OrganizzazioneIdentificativoFiscaleItem
internal sealed record IdentificativoDto(
    int Id,
    string PaeseISO2,
    string TipoIdentificativo,
    string Valore,
    bool Principale,
    string? Note);

