namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaUpdate;

internal sealed record Command(int OrganizzazioneId, int UnitaOrganizzativaId, UpdateUnitaOrganizzativaRequest Request, string? Actor);

