namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record PersonaStoricoEvent(
    int PersonaId,
    string? CodiceFiscale,
    string Cognome,
    string Nome,
    DateTime DataNascita,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

public sealed record PersonaEmailStoricoEvent(
    int PersonaEmailId,
    int PersonaId,
    int TipoEmailId,
    string Email,
    bool Principale,
    bool Verificata,
    DateTime? DataVerifica,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

public sealed record PersonaTelefonoStoricoEvent(
    int PersonaTelefonoId,
    int PersonaId,
    int TipoTelefonoId,
    string? PrefissoInternazionale,
    string Numero,
    string? Estensione,
    bool Principale,
    bool Verificato,
    DateTime? DataVerifica,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);
