namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediLink;

internal sealed record ListCommand(int OrganizzazioneId);
internal sealed record LinkCommand(int OrganizzazioneId, LinkRequest Request, string? Actor);
internal sealed record UnlinkCommand(int OrganizzazioneId, int OrganizzazioneSedeId, string? Actor);

