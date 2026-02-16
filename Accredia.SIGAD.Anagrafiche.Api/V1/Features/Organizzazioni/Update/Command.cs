namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Update;

internal sealed record Command(Guid OrganizzazioneId, UpdateOrganizzazioneRequest Request);
