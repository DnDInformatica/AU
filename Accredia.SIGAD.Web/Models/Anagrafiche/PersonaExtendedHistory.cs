namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record PersonaIndirizzoStoricoEvent(
    int PersonaIndirizzoId,
    int PersonaId,
    int IndirizzoId,
    int TipoIndirizzoId,
    bool Principale,
    bool Attivo,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

public sealed record PersonaQualificaStoricoEvent(
    int PersonaQualificaId,
    int PersonaId,
    int TipoQualificaId,
    int? EnteRilascioQualificaId,
    string? CodiceAttestato,
    DateTime? DataRilascio,
    DateTime? DataScadenza,
    bool Valida,
    string? Note,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

public sealed record PersonaTitoloStudioStoricoEvent(
    int PersonaTitoloStudioId,
    int PersonaId,
    int TipoTitoloStudioId,
    string? Istituzione,
    string? Corso,
    DateTime? DataConseguimento,
    string? Voto,
    bool Lode,
    string? Paese,
    string? Note,
    bool Principale,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

public sealed record PersonaRelazionePersonaleStoricoEvent(
    int PersonaRelazionePersonaleId,
    int PersonaId,
    int PersonaCollegataId,
    int TipoRelazionePersonaleId,
    string? Note,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

public sealed record PersonaUtenteStoricoEvent(
    int PersonaUtenteId,
    int PersonaId,
    string UserId,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

public sealed record ConsensoPersonaStoricoEvent(
    int ConsensoPersonaId,
    int PersonaId,
    int TipoFinalitaTrattamentoId,
    bool Consenso,
    DateTime DataConsenso,
    DateTime? DataRevoca,
    string ModalitaAcquisizione,
    string? ModalitaRevoca,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

public sealed record RichiestaGdprStoricoEvent(
    int RichiestaGdprId,
    string Codice,
    int? PersonaId,
    int TipoDirittoInteressatoId,
    DateTime DataRichiesta,
    DateTime DataScadenzaRisposta,
    string Stato,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

public sealed record RegistroTrattamentiStoricoEvent(
    int RegistroTrattamentiId,
    string Codice,
    string NomeTrattamento,
    int TipoFinalitaTrattamentoId,
    string BaseGiuridica,
    string Stato,
    DateTime DataInizioTrattamento,
    DateTime? DataFineTrattamento,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

public sealed record RichiestaEsercizioDirittiStoricoEvent(
    int RichiestaEsercizioDirittiId,
    string Codice,
    int? PersonaId,
    int TipoDirittoGdprId,
    DateTime DataRichiesta,
    DateTime DataScadenza,
    string Stato,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

public sealed record DataBreachStoricoEvent(
    int DataBreachId,
    string Codice,
    DateTime DataScoperta,
    string Stato,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);
