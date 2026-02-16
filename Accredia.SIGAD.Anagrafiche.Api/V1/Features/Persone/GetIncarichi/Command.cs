namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.GetIncarichi;

internal sealed record Command(int PersonaId, bool IncludeDeleted);

