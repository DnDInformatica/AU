namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record OrganizzazioneListItem(
    int OrganizzazioneId,
    string Denominazione,
    string RagioneSociale,
    string? CodiceFiscale,
    string? PartitaIVA,
    byte? StatoAttivitaId);
