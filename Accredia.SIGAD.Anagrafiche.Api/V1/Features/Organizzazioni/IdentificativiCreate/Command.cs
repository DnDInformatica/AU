namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.IdentificativiCreate;

internal sealed record Command(int OrganizzazioneId, CreateIdentificativoRequest Request, string? Actor);

