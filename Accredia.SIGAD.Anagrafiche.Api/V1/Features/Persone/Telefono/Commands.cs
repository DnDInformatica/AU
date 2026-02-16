namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Telefono;

internal sealed record ListCommand(int PersonaId, bool IncludeDeleted);

internal sealed record CreateCommand(int PersonaId, CreateRequest Request, string? Actor);

internal sealed record UpdateCommand(int PersonaId, int PersonaTelefonoId, UpdateRequest Request, string? Actor);

internal sealed record DeleteCommand(int PersonaId, int PersonaTelefonoId, string? Actor);

internal sealed record LookupsCommand();

