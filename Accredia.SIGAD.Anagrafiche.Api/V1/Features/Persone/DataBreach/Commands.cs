namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.DataBreach;

internal sealed record ListCommand(bool IncludeDeleted);

internal sealed record GetByIdCommand(int DataBreachId);

internal sealed record CreateCommand(CreateRequest Request, string? Actor);

internal sealed record UpdateCommand(int DataBreachId, UpdateRequest Request, string? Actor);

internal sealed record DeleteCommand(int DataBreachId, string? Actor);

