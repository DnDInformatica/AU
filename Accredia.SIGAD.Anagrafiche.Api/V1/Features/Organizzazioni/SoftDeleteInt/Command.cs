namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SoftDeleteInt;

internal sealed record Command(int OrganizzazioneId, string? Actor);

