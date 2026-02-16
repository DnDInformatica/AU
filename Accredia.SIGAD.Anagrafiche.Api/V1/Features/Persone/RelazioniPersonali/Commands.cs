namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.RelazioniPersonali;

internal sealed record LookupsCommand();

internal sealed record ListCommand(int PersonaId, bool IncludeDeleted);

internal sealed record CreateCommand(int PersonaId, CreateRequest Request, string? Actor);

internal sealed record UpdateCommand(int PersonaId, int PersonaRelazionePersonaleId, UpdateRequest Request, string? Actor);

internal sealed record DeleteCommand(int PersonaId, int PersonaRelazionePersonaleId, string? Actor);

