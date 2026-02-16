namespace Accredia.SIGAD.Tipologiche.Api.V1.Features.Tipologiche.Create;

internal sealed record Command(string Code, string Description, bool IsActive, int Ordine);
