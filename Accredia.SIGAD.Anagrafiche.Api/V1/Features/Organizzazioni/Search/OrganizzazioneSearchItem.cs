namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Search;

internal sealed record OrganizzazioneSearchItem(
    int OrganizzazioneId,
    string Denominazione,
    string RagioneSociale,
    string? CodiceFiscale,
    string? PartitaIVA,
    byte? StatoAttivitaId);
