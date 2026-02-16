namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.UpdateInt;

internal sealed record Command(int PersonaId, UpdatePersonaRequest Request, string? Actor);

