namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaContatti;

internal sealed record ListCommand(int OrganizzazioneId);
internal sealed record CreateCommand(int OrganizzazioneId, CreateRequest Request, string? Actor);
internal sealed record UpdateCommand(int OrganizzazioneId, int ContattoId, UpdateRequest Request, string? Actor);
internal sealed record DeleteCommand(int OrganizzazioneId, int ContattoId, string? Actor);
