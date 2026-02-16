namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Consensi;

internal sealed record LookupsCommand();

internal sealed record ListCommand(int PersonaId, bool IncludeDeleted);

internal sealed record CreateCommand(int PersonaId, CreateRequest Request, string? Actor);

internal sealed record UpdateCommand(int PersonaId, int ConsensoPersonaId, UpdateRequest Request, string? Actor);

internal sealed record DeleteCommand(int PersonaId, int ConsensoPersonaId, string? Actor);

