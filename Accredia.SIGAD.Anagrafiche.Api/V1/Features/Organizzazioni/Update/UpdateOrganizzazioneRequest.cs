namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Update;

internal sealed record UpdateOrganizzazioneRequest(
    string Codice,
    string Denominazione,
    bool IsActive);
