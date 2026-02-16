namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaIndirizzi;

internal sealed record ListCommand(int OrganizzazioneId);
internal sealed record CreateCommand(int OrganizzazioneId, CreateRequest Request, string? Actor);
internal sealed record UpdateCommand(int OrganizzazioneId, int IndirizzoId, UpdateRequest Request, string? Actor);
internal sealed record DeleteCommand(int OrganizzazioneId, int IndirizzoId, string? Actor);
