namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.UpdateInt;

internal sealed record UpdatePersonaRequest(
    string Cognome,
    string Nome,
    string? CodiceFiscale,
    DateTime DataNascita);

