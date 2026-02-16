namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaCreate;

internal sealed record Command(int OrganizzazioneId, CreateUnitaOrganizzativaRequest Request, string? Actor);

