namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.RichiesteEsercizioDiritti;

internal sealed record LookupsCommand();

internal sealed record ListCommand(int? PersonaId, bool IncludeDeleted);

internal sealed record GetByIdCommand(int RichiestaEsercizioDirittiId);

internal sealed record CreateCommand(CreateRequest Request, string? Actor);

internal sealed record UpdateCommand(int RichiestaEsercizioDirittiId, UpdateRequest Request, string? Actor);

internal sealed record DeleteCommand(int RichiestaEsercizioDirittiId, string? Actor);

