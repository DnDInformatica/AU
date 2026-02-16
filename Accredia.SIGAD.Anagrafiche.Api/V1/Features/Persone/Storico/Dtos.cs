namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Storico;

internal sealed record PersonaStoricoDto(
    int PersonaId,
    string? CodiceFiscale,
    string Cognome,
    string Nome,
    DateTime DataNascita,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record PersonaEmailStoricoDto(
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

internal sealed record PersonaTelefonoStoricoDto(
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

internal sealed record PersonaIndirizzoStoricoDto(
    int PersonaIndirizzoId,
    int PersonaId,
    int IndirizzoId,
    int TipoIndirizzoId,
    bool Principale,
    bool Attivo,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record PersonaQualificaStoricoDto(
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

internal sealed record PersonaTitoloStudioStoricoDto(
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

internal sealed record PersonaRelazionePersonaleStoricoDto(
    int PersonaRelazionePersonaleId,
    int PersonaId,
    int PersonaCollegataId,
    int TipoRelazionePersonaleId,
    string? Note,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record PersonaUtenteStoricoDto(
    int PersonaUtenteId,
    int PersonaId,
    string UserId,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record ConsensoPersonaStoricoDto(
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

internal sealed record RegistroTrattamentiStoricoDto(
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

internal sealed record RichiestaGdprStoricoDto(
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

internal sealed record RichiestaEsercizioDirittiStoricoDto(
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

internal sealed record DataBreachStoricoDto(
    int DataBreachId,
    string Codice,
    DateTime DataScoperta,
    string Stato,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

