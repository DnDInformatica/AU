namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Create;

internal sealed record CreateOrganizzazioneRequest(
    string Codice,
    string Denominazione,
    bool IsActive = true);
