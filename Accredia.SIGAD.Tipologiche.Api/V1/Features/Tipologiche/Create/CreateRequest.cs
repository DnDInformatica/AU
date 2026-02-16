namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche.Create;

internal sealed record CreateRequest(string? Code, string? Description, bool? IsActive, int? Ordine);
