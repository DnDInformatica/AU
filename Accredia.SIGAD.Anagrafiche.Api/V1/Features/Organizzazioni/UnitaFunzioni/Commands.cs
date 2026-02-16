namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaFunzioni;

internal sealed record ListCommand(int OrganizzazioneId);
internal sealed record CreateCommand(int OrganizzazioneId, CreateRequest Request, string? Actor);
internal sealed record UpdateCommand(int OrganizzazioneId, int UnitaOrganizzativaFunzioneId, UpdateRequest Request, string? Actor);
internal sealed record DeleteCommand(int OrganizzazioneId, int UnitaOrganizzativaFunzioneId, string? Actor);

