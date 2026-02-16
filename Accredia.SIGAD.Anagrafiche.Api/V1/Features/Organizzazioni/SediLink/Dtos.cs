namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediLink;

internal sealed record OrganizzazioneSedeLinkDto(
    int OrganizzazioneSedeId,
    int OrganizzazioneId,
    byte TipoOrganizzazioneSedeId,
    string? Denominazione,
    string? Insegna,
    DateTime? DataApertura,
    DateTime? DataCessazioneUL,
    DateTime? DataDenunciaCessazione,
    DateTime? DataCancellazione);

