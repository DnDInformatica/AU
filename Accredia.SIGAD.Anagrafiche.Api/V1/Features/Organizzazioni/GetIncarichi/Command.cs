namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetIncarichi;

internal sealed record Command(int OrganizzazioneId, bool IncludeDeleted);
