namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UpdateInt;

internal sealed record UpdateOrganizzazioneIntRequest(
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
