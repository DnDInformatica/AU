namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaRelazioni;

internal sealed record ListCommand(int OrganizzazioneId);
internal sealed record CreateCommand(int OrganizzazioneId, CreateRequest Request, string? Actor);
internal sealed record UpdateCommand(int OrganizzazioneId, int UnitaRelazioneId, UpdateRequest Request, string? Actor);
internal sealed record DeleteCommand(int OrganizzazioneId, int UnitaRelazioneId, string? Actor);

