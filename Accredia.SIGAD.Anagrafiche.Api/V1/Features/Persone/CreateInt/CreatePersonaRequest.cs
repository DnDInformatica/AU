namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.CreateInt;

internal sealed record CreatePersonaRequest(
    string Cognome,
    string Nome,
    string? CodiceFiscale,
    DateTime DataNascita);

