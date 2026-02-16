namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.RichiesteGdpr;

internal sealed record LookupsCommand();

internal sealed record ListCommand(int? PersonaId, bool IncludeDeleted);

internal sealed record GetByIdCommand(int RichiestaGdprId);

internal sealed record CreateCommand(CreateRequest Request, string? Actor);

internal sealed record UpdateCommand(int RichiestaGdprId, UpdateRequest Request, string? Actor);

internal sealed record DeleteCommand(int RichiestaGdprId, string? Actor);

