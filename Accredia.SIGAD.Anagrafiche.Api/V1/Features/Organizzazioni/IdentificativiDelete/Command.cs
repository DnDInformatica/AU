namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.IdentificativiDelete;

internal sealed record Command(int OrganizzazioneId, int IdentificativoId, string? Actor);

