namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record CreatePersonaRequest(
    string Cognome,
    string Nome,
    string? CodiceFiscale,
    DateTime DataNascita);

public sealed record UpdatePersonaRequest(
    string Cognome,
    string Nome,
    string? CodiceFiscale,
    DateTime DataNascita);

