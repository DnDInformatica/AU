namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GruppiIva;

internal sealed record ListCommand();
internal sealed record CreateCommand(CreateRequest Request, string? Actor);
internal sealed record UpdateCommand(int GruppoIvaId, UpdateRequest Request, string? Actor);
internal sealed record DeleteCommand(int GruppoIvaId, string? Actor);
