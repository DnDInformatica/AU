namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Search;

internal sealed record PersonaSearchItem(
    int PersonaId,
    string Cognome,
    string Nome,
    string? CodiceFiscale,
    DateTime DataNascita);
