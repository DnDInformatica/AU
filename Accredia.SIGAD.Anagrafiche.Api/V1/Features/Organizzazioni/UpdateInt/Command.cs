namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UpdateInt;

internal sealed record Command(int OrganizzazioneId, UpdateOrganizzazioneIntRequest Request, string? Actor);

