namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.TitoliStudio;

internal sealed record ListCommand(int PersonaId, bool IncludeDeleted);

internal sealed record CreateCommand(int PersonaId, CreateRequest Request, string? Actor);

internal sealed record UpdateCommand(int PersonaId, int PersonaTitoloStudioId, UpdateRequest Request, string? Actor);

internal sealed record DeleteCommand(int PersonaId, int PersonaTitoloStudioId, string? Actor);

internal sealed record LookupsCommand();

