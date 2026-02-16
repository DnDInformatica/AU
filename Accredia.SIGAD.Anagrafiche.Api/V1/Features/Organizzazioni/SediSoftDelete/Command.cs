namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediSoftDelete;

internal sealed record Command(int OrganizzazioneId, int SedeId, string? Actor);

