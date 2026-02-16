namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Competenze;

internal sealed record ListCommand();
internal sealed record CreateCommand(CreateRequest Request, string? Actor);
internal sealed record UpdateCommand(int CompetenzaId, UpdateRequest Request, string? Actor);
internal sealed record DeleteCommand(int CompetenzaId, string? Actor);
