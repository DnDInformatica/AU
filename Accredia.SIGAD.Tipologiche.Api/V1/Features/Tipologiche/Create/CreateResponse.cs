namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche.Create;

internal sealed record CreateResponse(int Id, string Code, string Description, bool IsActive, int Ordine);
