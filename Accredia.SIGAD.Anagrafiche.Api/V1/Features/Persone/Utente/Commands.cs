namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Utente;

internal sealed record GetCommand(int PersonaId, bool IncludeDeleted);

internal sealed record CreateCommand(int PersonaId, CreateRequest Request, string? Actor);

internal sealed record UpdateCommand(int PersonaId, int PersonaUtenteId, UpdateRequest Request, string? Actor);

internal sealed record DeleteCommand(int PersonaId, int PersonaUtenteId, string? Actor);

