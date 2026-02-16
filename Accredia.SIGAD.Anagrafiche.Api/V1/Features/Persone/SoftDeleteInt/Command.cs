namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.SoftDeleteInt;

internal sealed record Command(int PersonaId, string? Actor);

