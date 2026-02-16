namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediCreate;

internal sealed record Command(int OrganizzazioneId, CreateSedeRequest Request, string? Actor);

