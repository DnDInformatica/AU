namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record CreateOrganizzazioneRequest(
    string Denominazione,
    string? RagioneSociale,
    string? PartitaIVA,
    string? CodiceFiscale,
    byte? StatoAttivitaId,
    string? NRegistroImprese,
    int? TipoCodiceNaturaGiuridicaId,
    string? OggettoSociale,
    DateTime? DataIscrizioneIscrizioneRI,
    DateTime? DataCostituzione);

public sealed record UpdateOrganizzazioneRequest(
    string Denominazione,
    string? RagioneSociale,
    string? PartitaIVA,
    string? CodiceFiscale,
    byte? StatoAttivitaId,
    string? NRegistroImprese,
    int? TipoCodiceNaturaGiuridicaId,
    string? OggettoSociale,
    DateTime? DataIscrizioneIscrizioneRI,
    DateTime? DataCostituzione);

public sealed record CreateOrganizzazioneIdentificativoRequest(
    string PaeseISO2,
    string TipoIdentificativo,
    string Valore,
    bool Principale,
    string? Note);

public sealed record UpdateOrganizzazioneIdentificativoRequest(
    string PaeseISO2,
    string TipoIdentificativo,
    string Valore,
    bool Principale,
    string? Note);
