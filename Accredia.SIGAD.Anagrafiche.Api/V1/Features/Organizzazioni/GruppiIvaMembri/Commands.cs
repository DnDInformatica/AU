namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GruppiIvaMembri;

internal sealed record ListCommand(int GruppoIvaId);
internal sealed record CreateCommand(int GruppoIvaId, CreateRequest Request, string? Actor);
internal sealed record UpdateCommand(int GruppoIvaId, int GruppoIvaMembroId, UpdateRequest Request, string? Actor);
internal sealed record DeleteCommand(int GruppoIvaId, int GruppoIvaMembroId, string? Actor);
