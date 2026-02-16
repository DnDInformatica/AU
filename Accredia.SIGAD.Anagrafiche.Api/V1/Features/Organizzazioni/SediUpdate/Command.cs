namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediUpdate;

internal sealed record Command(int OrganizzazioneId, int SedeId, UpdateSedeRequest Request, string? Actor);

