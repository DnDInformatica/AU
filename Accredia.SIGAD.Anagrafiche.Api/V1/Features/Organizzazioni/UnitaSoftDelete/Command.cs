namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaSoftDelete;

internal sealed record Command(int OrganizzazioneId, int UnitaOrganizzativaId, string? Actor);

