namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediLink;

internal sealed record LinkRequest(
    byte TipoOrganizzazioneSedeId,
    string? Denominazione,
    string? Insegna,
    DateTime? DataApertura,
    string? DescrizioneAttivita,
    DateTime? DataInizioAttivita);

