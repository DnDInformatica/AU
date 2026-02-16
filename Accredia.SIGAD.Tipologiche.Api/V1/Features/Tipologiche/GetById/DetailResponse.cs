namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche.GetById;

internal sealed record DetailResponse(int Id, string Code, string Description, bool IsActive, int Ordine);
