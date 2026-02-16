namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni;

internal sealed record OrganizzazioneDto(
    Guid OrganizzazioneId,
    string Codice,
    string Denominazione,
    bool IsActive,
    DateTime CreatedUtc);
