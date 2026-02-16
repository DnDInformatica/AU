namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.RegistroTrattamenti;

internal sealed record LookupsCommand();

internal sealed record ListCommand(bool IncludeDeleted);

internal sealed record GetByIdCommand(int RegistroTrattamentiId);

internal sealed record CreateCommand(CreateRequest Request, string? Actor);

internal sealed record UpdateCommand(int RegistroTrattamentiId, UpdateRequest Request, string? Actor);

internal sealed record DeleteCommand(int RegistroTrattamentiId, string? Actor);

