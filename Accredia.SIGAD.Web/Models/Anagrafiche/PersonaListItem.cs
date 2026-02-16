namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record PersonaListItem(
    int PersonaId,
    string Cognome,
    string Nome,
    string? CodiceFiscale,
    DateTime DataNascita);

