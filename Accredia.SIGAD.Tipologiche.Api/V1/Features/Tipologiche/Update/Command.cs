namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche.Update;

internal sealed record Command(int Id, string Code, string Description, bool IsActive, int Ordine);
