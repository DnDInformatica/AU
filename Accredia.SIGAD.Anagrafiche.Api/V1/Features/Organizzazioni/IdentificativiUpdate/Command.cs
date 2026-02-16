namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.IdentificativiUpdate;

internal sealed record Command(int OrganizzazioneId, int IdentificativoId, UpdateIdentificativoRequest Request, string? Actor);

