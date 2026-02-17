namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record PersonaIndirizzoItem(
    int PersonaIndirizzoId,
    int PersonaId,
    int IndirizzoId,
    int TipoIndirizzoId,
    bool Principale,
    bool Attivo,
    DateTime? DataCancellazione);

public sealed record CreatePersonaIndirizzoRequest(
    int IndirizzoId,
    int TipoIndirizzoId,
    bool Principale,
    bool Attivo);

public sealed record UpdatePersonaIndirizzoRequest(
    int IndirizzoId,
    int TipoIndirizzoId,
    bool Principale,
    bool Attivo);

public sealed record PersonaQualificaItem(
    int PersonaQualificaId,
    int PersonaId,
    int TipoQualificaId,
    int? EnteRilascioQualificaId,
    string? CodiceAttestato,
    DateTime? DataRilascio,
    DateTime? DataScadenza,
    bool Valida,
    string? Note,
    DateTime? DataCancellazione);

public sealed record TipoQualificaLookupItem(
    int Id,
    string Code,
    string Description,
    string? Category,
    bool RichiedeScadenza);

public sealed record EnteRilascioQualificaLookupItem(
    int Id,
    string Code,
    string Description);

public sealed record QualificheLookupsResponse(
    IReadOnlyList<TipoQualificaLookupItem> Tipi,
    IReadOnlyList<EnteRilascioQualificaLookupItem> Enti);

public sealed record CreatePersonaQualificaRequest(
    int TipoQualificaId,
    int? EnteRilascioQualificaId,
    string? CodiceAttestato,
    DateTime? DataRilascio,
    DateTime? DataScadenza,
    bool Valida,
    string? Note);

public sealed record UpdatePersonaQualificaRequest(
    int TipoQualificaId,
    int? EnteRilascioQualificaId,
    string? CodiceAttestato,
    DateTime? DataRilascio,
    DateTime? DataScadenza,
    bool Valida,
    string? Note);

public sealed record TipoRelazionePersonaleLookupItem(
    int Id,
    string Code,
    string Description,
    bool Symmetric,
    int? InverseId);

public sealed record PersonaRelazionePersonaleItem(
    int PersonaRelazionePersonaleId,
    int PersonaId,
    int PersonaCollegataId,
    int TipoRelazionePersonaleId,
    string? Note,
    DateTime? DataCancellazione);

public sealed record CreatePersonaRelazionePersonaleRequest(
    int PersonaCollegataId,
    int TipoRelazionePersonaleId,
    string? Note);

public sealed record UpdatePersonaRelazionePersonaleRequest(
    int PersonaCollegataId,
    int TipoRelazionePersonaleId,
    string? Note);

public sealed record PersonaTitoloStudioItem(
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
    DateTime? DataCancellazione);

public sealed record TipoTitoloStudioLookupItem(
    int Id,
    string Code,
    string Description,
    int LivelloTitoloStudioId,
    int TipoSistemaFormativoId,
    bool HaValoreLegale,
    bool RichiedeTitoloPrevio);

public sealed record TitoliStudioLookupsResponse(
    IReadOnlyList<TipoTitoloStudioLookupItem> Tipi);

public sealed record CreatePersonaTitoloStudioRequest(
    int TipoTitoloStudioId,
    string? Istituzione,
    string? Corso,
    DateTime? DataConseguimento,
    string? Voto,
    bool Lode,
    string? Paese,
    string? Note,
    bool Principale);

public sealed record UpdatePersonaTitoloStudioRequest(
    int TipoTitoloStudioId,
    string? Istituzione,
    string? Corso,
    DateTime? DataConseguimento,
    string? Voto,
    bool Lode,
    string? Paese,
    string? Note,
    bool Principale);

public sealed record TipoFinalitaTrattamentoLookupItem(
    int Id,
    string Code,
    string Description,
    string Category,
    bool RequiresExplicitConsent,
    bool IsMandatory);

public sealed record ConsensoPersonaItem(
    int ConsensoPersonaId,
    int PersonaId,
    int TipoFinalitaTrattamentoId,
    bool Consenso,
    DateTime DataConsenso,
    DateTime? DataScadenza,
    DateTime? DataRevoca,
    string ModalitaAcquisizione,
    string? ModalitaRevoca,
    string? RiferimentoDocumento,
    string? IPAddress,
    string? UserAgent,
    string? MotivoRevoca,
    string? VersioneInformativa,
    DateTime? DataInformativa,
    string? Note,
    DateTime? DataCancellazione);

public sealed record CreateConsensoPersonaRequest(
    int TipoFinalitaTrattamentoId,
    bool Consenso,
    DateTime? DataConsenso,
    DateTime? DataScadenza,
    DateTime? DataRevoca,
    string ModalitaAcquisizione,
    string? ModalitaRevoca,
    string? RiferimentoDocumento,
    string? IPAddress,
    string? UserAgent,
    string? MotivoRevoca,
    string? VersioneInformativa,
    DateTime? DataInformativa,
    string? Note);

public sealed record UpdateConsensoPersonaRequest(
    int TipoFinalitaTrattamentoId,
    bool Consenso,
    DateTime? DataConsenso,
    DateTime? DataScadenza,
    DateTime? DataRevoca,
    string ModalitaAcquisizione,
    string? ModalitaRevoca,
    string? RiferimentoDocumento,
    string? IPAddress,
    string? UserAgent,
    string? MotivoRevoca,
    string? VersioneInformativa,
    DateTime? DataInformativa,
    string? Note);

public sealed record PersonaUtenteItem(
    int PersonaUtenteId,
    int PersonaId,
    string UserId,
    DateTime? DataCancellazione);

public sealed record CreatePersonaUtenteRequest(string UserId);

public sealed record UpdatePersonaUtenteRequest(string UserId);

public sealed record TipoDirittoInteressatoLookupItem(
    int Id,
    string Code,
    string Description,
    string Article);

public sealed record RichiestaGdprItem(
    int RichiestaGdprId,
    int? PersonaId,
    string NomeRichiedente,
    string CognomeRichiedente,
    string? EmailRichiedente,
    string? TelefonoRichiedente,
    int TipoDirittoInteressatoId,
    string Codice,
    DateTime DataRichiesta,
    string CanaleRichiesta,
    string? DescrizioneRichiesta,
    string? DocumentoIdentita,
    DateTime DataScadenzaRisposta,
    string Stato,
    int? ResponsabileGestioneId,
    DateTime? DataPresaInCarico,
    DateTime? DataRisposta,
    string? EsitoRichiesta,
    string? MotivoRifiuto,
    string? DescrizioneRisposta,
    string? ModalitaRisposta,
    string? RiferimentoDocumentoRisposta,
    string? Note,
    DateTime? DataCancellazione);

public sealed record CreateRichiestaGdprRequest(
    int? PersonaId,
    string NomeRichiedente,
    string CognomeRichiedente,
    string? EmailRichiedente,
    string? TelefonoRichiedente,
    int TipoDirittoInteressatoId,
    string Codice,
    DateTime DataRichiesta,
    string CanaleRichiesta,
    string? DescrizioneRichiesta,
    string? DocumentoIdentita,
    DateTime DataScadenzaRisposta,
    string Stato,
    int? ResponsabileGestioneId,
    DateTime? DataPresaInCarico,
    DateTime? DataRisposta,
    string? EsitoRichiesta,
    string? MotivoRifiuto,
    string? DescrizioneRisposta,
    string? ModalitaRisposta,
    string? RiferimentoDocumentoRisposta,
    string? Note);

public sealed record UpdateRichiestaGdprRequest(
    int? PersonaId,
    string NomeRichiedente,
    string CognomeRichiedente,
    string? EmailRichiedente,
    string? TelefonoRichiedente,
    int TipoDirittoInteressatoId,
    string Codice,
    DateTime DataRichiesta,
    string CanaleRichiesta,
    string? DescrizioneRichiesta,
    string? DocumentoIdentita,
    DateTime DataScadenzaRisposta,
    string Stato,
    int? ResponsabileGestioneId,
    DateTime? DataPresaInCarico,
    DateTime? DataRisposta,
    string? EsitoRichiesta,
    string? MotivoRifiuto,
    string? DescrizioneRisposta,
    string? ModalitaRisposta,
    string? RiferimentoDocumentoRisposta,
    string? Note);

public sealed record TipoFinalitaRegistroTrattamentiLookupItem(
    int Id,
    string Code,
    string Description,
    string Category);

public sealed record RegistroTrattamentiItem(
    int RegistroTrattamentiId,
    string Codice,
    string NomeTrattamento,
    string? Descrizione,
    int TipoFinalitaTrattamentoId,
    string BaseGiuridica,
    string CategorieDati,
    string CategorieInteressati,
    bool DatiParticolari,
    bool DatiGiudiziari,
    string? CategorieDestinatari,
    bool TrasferimentoExtraUE,
    string? PaesiExtraUE,
    string? GaranzieExtraUE,
    string TermineConservazione,
    int? TermineConservazioneGiorni,
    string? MisureSicurezza,
    int? ResponsabileTrattamentoId,
    int? ContitolareId,
    bool DPONotificato,
    string Stato,
    DateTime DataInizioTrattamento,
    DateTime? DataFineTrattamento,
    DateTime? DataCancellazione);

public sealed record CreateRegistroTrattamentiRequest(
    string Codice,
    string NomeTrattamento,
    string? Descrizione,
    int TipoFinalitaTrattamentoId,
    string BaseGiuridica,
    string CategorieDati,
    string CategorieInteressati,
    bool DatiParticolari,
    bool DatiGiudiziari,
    string? CategorieDestinatari,
    bool TrasferimentoExtraUE,
    string? PaesiExtraUE,
    string? GaranzieExtraUE,
    string TermineConservazione,
    int? TermineConservazioneGiorni,
    string? MisureSicurezza,
    int? ResponsabileTrattamentoId,
    int? ContitolareId,
    bool DPONotificato,
    string Stato,
    DateTime DataInizioTrattamento,
    DateTime? DataFineTrattamento);

public sealed record UpdateRegistroTrattamentiRequest(
    string Codice,
    string NomeTrattamento,
    string? Descrizione,
    int TipoFinalitaTrattamentoId,
    string BaseGiuridica,
    string CategorieDati,
    string CategorieInteressati,
    bool DatiParticolari,
    bool DatiGiudiziari,
    string? CategorieDestinatari,
    bool TrasferimentoExtraUE,
    string? PaesiExtraUE,
    string? GaranzieExtraUE,
    string TermineConservazione,
    int? TermineConservazioneGiorni,
    string? MisureSicurezza,
    int? ResponsabileTrattamentoId,
    int? ContitolareId,
    bool DPONotificato,
    string Stato,
    DateTime DataInizioTrattamento,
    DateTime? DataFineTrattamento);

public sealed record RichiestaEsercizioDirittiItem(
    int RichiestaEsercizioDirittiId,
    int? PersonaId,
    string NomeRichiedente,
    string EmailRichiedente,
    string? TelefonoRichiedente,
    string Codice,
    int TipoDirittoGdprId,
    DateTime DataRichiesta,
    string ModalitaRichiesta,
    string? TestoRichiesta,
    string? DocumentoRichiesta,
    bool IdentitaVerificata,
    DateTime? DataVerificaIdentita,
    string? ModalitaVerifica,
    DateTime DataScadenza,
    DateTime? DataProrogaRichiesta,
    string? MotivoProrogaRichiesta,
    string Stato,
    int? ResponsabileGestioneId,
    string? Note,
    DateTime? DataRisposta,
    string? EsitoRisposta,
    string? MotivoRifiuto,
    string? TestoRisposta,
    string? DocumentoRisposta,
    DateTime? DataEsecuzione,
    string? DatiCancellati,
    DateTime? DataCancellazione);

public sealed record CreateRichiestaEsercizioDirittiRequest(
    int? PersonaId,
    string NomeRichiedente,
    string EmailRichiedente,
    string? TelefonoRichiedente,
    string Codice,
    int TipoDirittoGdprId,
    DateTime DataRichiesta,
    string ModalitaRichiesta,
    string? TestoRichiesta,
    string? DocumentoRichiesta,
    bool IdentitaVerificata,
    DateTime? DataVerificaIdentita,
    string? ModalitaVerifica,
    DateTime DataScadenza,
    DateTime? DataProrogaRichiesta,
    string? MotivoProrogaRichiesta,
    string Stato,
    int? ResponsabileGestioneId,
    string? Note,
    DateTime? DataRisposta,
    string? EsitoRisposta,
    string? MotivoRifiuto,
    string? TestoRisposta,
    string? DocumentoRisposta,
    DateTime? DataEsecuzione,
    string? DatiCancellati);

public sealed record UpdateRichiestaEsercizioDirittiRequest(
    int? PersonaId,
    string NomeRichiedente,
    string EmailRichiedente,
    string? TelefonoRichiedente,
    string Codice,
    int TipoDirittoGdprId,
    DateTime DataRichiesta,
    string ModalitaRichiesta,
    string? TestoRichiesta,
    string? DocumentoRichiesta,
    bool IdentitaVerificata,
    DateTime? DataVerificaIdentita,
    string? ModalitaVerifica,
    DateTime DataScadenza,
    DateTime? DataProrogaRichiesta,
    string? MotivoProrogaRichiesta,
    string Stato,
    int? ResponsabileGestioneId,
    string? Note,
    DateTime? DataRisposta,
    string? EsitoRisposta,
    string? MotivoRifiuto,
    string? TestoRisposta,
    string? DocumentoRisposta,
    DateTime? DataEsecuzione,
    string? DatiCancellati);

public sealed record DataBreachItem(
    int DataBreachId,
    string Codice,
    string Titolo,
    string Descrizione,
    DateTime DataScoperta,
    DateTime? DataInizioViolazione,
    DateTime? DataFineViolazione,
    string TipoViolazione,
    string CausaViolazione,
    string CategorieDatiCoinvolti,
    bool DatiParticolariCoinvolti,
    int? NumeroInteressatiStimato,
    string CategorieInteressati,
    string RischioPerInteressati,
    string? DescrizioneRischio,
    bool NotificaGaranteRichiesta,
    DateTime? DataNotificaGarante,
    string? ProtocolloGarante,
    DateTime? TermineNotificaGarante,
    bool ComunicazioneInteressatiRichiesta,
    DateTime? DataComunicazioneInteressati,
    string? ModalitaComunicazione,
    string? MisureContenimento,
    string? MisurePrevenzione,
    int? ResponsabileGestioneId,
    bool DPOCoinvolto,
    string Stato,
    DateTime? DataChiusura,
    DateTime? DataCancellazione);

public sealed record CreateDataBreachRequest(
    string Codice,
    string Titolo,
    string Descrizione,
    DateTime DataScoperta,
    DateTime? DataInizioViolazione,
    DateTime? DataFineViolazione,
    string TipoViolazione,
    string CausaViolazione,
    string CategorieDatiCoinvolti,
    bool DatiParticolariCoinvolti,
    int? NumeroInteressatiStimato,
    string CategorieInteressati,
    string RischioPerInteressati,
    string? DescrizioneRischio,
    bool NotificaGaranteRichiesta,
    DateTime? DataNotificaGarante,
    string? ProtocolloGarante,
    DateTime? TermineNotificaGarante,
    bool ComunicazioneInteressatiRichiesta,
    DateTime? DataComunicazioneInteressati,
    string? ModalitaComunicazione,
    string? MisureContenimento,
    string? MisurePrevenzione,
    int? ResponsabileGestioneId,
    bool DPOCoinvolto,
    string Stato,
    DateTime? DataChiusura);

public sealed record UpdateDataBreachRequest(
    string Codice,
    string Titolo,
    string Descrizione,
    DateTime DataScoperta,
    DateTime? DataInizioViolazione,
    DateTime? DataFineViolazione,
    string TipoViolazione,
    string CausaViolazione,
    string CategorieDatiCoinvolti,
    bool DatiParticolariCoinvolti,
    int? NumeroInteressatiStimato,
    string CategorieInteressati,
    string RischioPerInteressati,
    string? DescrizioneRischio,
    bool NotificaGaranteRichiesta,
    DateTime? DataNotificaGarante,
    string? ProtocolloGarante,
    DateTime? TermineNotificaGarante,
    bool ComunicazioneInteressatiRichiesta,
    DateTime? DataComunicazioneInteressati,
    string? ModalitaComunicazione,
    string? MisureContenimento,
    string? MisurePrevenzione,
    int? ResponsabileGestioneId,
    bool DPOCoinvolto,
    string Stato,
    DateTime? DataChiusura);
