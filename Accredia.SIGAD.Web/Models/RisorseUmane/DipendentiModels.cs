namespace Accredia.SIGAD.Web.Models.RisorseUmane;

public sealed record DipendenteDto(
    int DipendenteId,
    int PersonaId,
    string Matricola,
    string? EmailAziendale,
    string? TelefonoInterno,
    int? UnitaOrganizzativaId,
    int? ResponsabileDirettoId,
    DateOnly DataAssunzione,
    DateOnly? DataCessazione,
    int StatoDipendenteId,
    bool AbilitatoAttivitaIspettiva,
    string? Note,
    DateTime DataCreazione,
    DateTime? DataModifica,
    DateTime? DataCancellazione);

public sealed record PersonaDetailDto(
    int PersonaId,
    string Cognome,
    string Nome,
    string? CodiceFiscale,
    DateTime DataNascita,
    DateTime? DataCancellazione);

public sealed record PersonaCompletaDto(
    PersonaDetailDto Dettaglio,
    IReadOnlyList<Accredia.SIGAD.Web.Models.Anagrafiche.PersonaEmailItem> Email,
    IReadOnlyList<Accredia.SIGAD.Web.Models.Anagrafiche.PersonaTelefonoItem> Telefoni,
    IReadOnlyList<Accredia.SIGAD.Web.Models.Anagrafiche.PersonaIndirizzoItem> Indirizzi,
    IReadOnlyList<Accredia.SIGAD.Web.Models.Anagrafiche.PersonaQualificaItem> Qualifiche,
    IReadOnlyList<Accredia.SIGAD.Web.Models.Anagrafiche.PersonaRelazionePersonaleItem> RelazioniPersonali,
    IReadOnlyList<Accredia.SIGAD.Web.Models.Anagrafiche.ConsensoPersonaItem> Consensi,
    IReadOnlyList<Accredia.SIGAD.Web.Models.Anagrafiche.RichiestaGdprItem> RichiesteGdpr,
    IReadOnlyList<Accredia.SIGAD.Web.Models.Anagrafiche.RichiestaEsercizioDirittiItem> RichiesteEsercizioDiritti);

public sealed record DipendenteDettaglioCompletoDto(
    DipendenteDto Dipendente,
    PersonaCompletaDto Persona);

public sealed record DipendenteDettaglioCompletoListItem(
    DipendenteDto Dipendente,
    PersonaCompletaDto Persona);

public sealed record PersonaLookupItem(
    int PersonaId,
    string Cognome,
    string Nome,
    string? CodiceFiscale,
    DateTime DataNascita);

public sealed record CreateDipendenteRequest(
    int PersonaId,
    string Matricola,
    string? EmailAziendale,
    string? TelefonoInterno,
    int? UnitaOrganizzativaId,
    int? ResponsabileDirettoId,
    DateOnly DataAssunzione,
    DateOnly? DataCessazione,
    int StatoDipendenteId,
    bool? AbilitatoAttivitaIspettiva,
    string? Note);

public sealed record CreateDipendenteResponse(int DipendenteId);

public sealed record UpdateDipendenteRequest(
    int PersonaId,
    string Matricola,
    string? EmailAziendale,
    string? TelefonoInterno,
    int? UnitaOrganizzativaId,
    int? ResponsabileDirettoId,
    DateOnly DataAssunzione,
    DateOnly? DataCessazione,
    int StatoDipendenteId,
    bool? AbilitatoAttivitaIspettiva,
    string? Note);

public sealed record DipendenteStoricoDto(
    int DipendenteId,
    int PersonaId,
    string Matricola,
    string? EmailAziendale,
    string? TelefonoInterno,
    int? UnitaOrganizzativaId,
    int? ResponsabileDirettoId,
    DateOnly DataAssunzione,
    DateOnly? DataCessazione,
    int StatoDipendenteId,
    bool AbilitatoAttivitaIspettiva,
    string? Note,
    DateTime DataCreazione,
    DateTime? DataModifica,
    DateTime? DataCancellazione,
    DateTime DataInizioValidita,
    DateTime DataFineValidita);

public sealed record ContrattoDto(
    int ContrattoId,
    int DipendenteId,
    int TipoContrattoId,
    DateOnly DataInizio,
    DateOnly? DataFine,
    string? LivelloInquadramento,
    string? CCNLApplicato,
    decimal? RAL,
    decimal? PercentualePartTime,
    decimal? OreLavoroSettimanali,
    bool IsContrattoCorrente,
    string? Note,
    DateTime DataCreazione,
    DateTime? DataModifica,
    DateTime? DataCancellazione);

public sealed record CreateContrattoRequest(
    int TipoContrattoId,
    DateOnly DataInizio,
    DateOnly? DataFine,
    string? LivelloInquadramento,
    string? CCNLApplicato,
    decimal? RAL,
    decimal? PercentualePartTime,
    decimal? OreLavoroSettimanali,
    bool? IsContrattoCorrente,
    string? Note);

public sealed record UpdateContrattoRequest(
    int TipoContrattoId,
    DateOnly DataInizio,
    DateOnly? DataFine,
    string? LivelloInquadramento,
    string? CCNLApplicato,
    decimal? RAL,
    decimal? PercentualePartTime,
    decimal? OreLavoroSettimanali,
    bool? IsContrattoCorrente,
    string? Note);

public sealed record CreateContrattoResponse(int ContrattoId);

public sealed record ContrattoStoricoDto(
    int ContrattoId,
    int DipendenteId,
    int TipoContrattoId,
    DateOnly DataInizio,
    DateOnly? DataFine,
    string? LivelloInquadramento,
    string? CCNLApplicato,
    decimal? RAL,
    decimal? PercentualePartTime,
    decimal? OreLavoroSettimanali,
    bool IsContrattoCorrente,
    string? Note,
    DateTime DataCreazione,
    DateTime? DataModifica,
    DateTime? DataCancellazione,
    DateTime DataInizioValidita,
    DateTime DataFineValidita);

public sealed record DotazioneDto(
    int DotazioneId,
    int DipendenteId,
    int TipoDotazioneId,
    string Descrizione,
    string? NumeroInventario,
    string? NumeroSerie,
    DateOnly DataAssegnazione,
    DateOnly? DataRestituzione,
    bool IsRestituito,
    string? Note,
    DateTime DataCreazione,
    DateTime? DataModifica,
    DateTime? DataCancellazione);

public sealed record CreateDotazioneRequest(
    int TipoDotazioneId,
    string Descrizione,
    string? NumeroInventario,
    string? NumeroSerie,
    DateOnly DataAssegnazione,
    DateOnly? DataRestituzione,
    bool? IsRestituito,
    string? Note);

public sealed record UpdateDotazioneRequest(
    int TipoDotazioneId,
    string Descrizione,
    string? NumeroInventario,
    string? NumeroSerie,
    DateOnly DataAssegnazione,
    DateOnly? DataRestituzione,
    bool? IsRestituito,
    string? Note);

public sealed record CreateDotazioneResponse(int DotazioneId);

public sealed record FormazioneObbligatoriaDto(
    int FormazioneObbligatoriaId,
    int DipendenteId,
    int TipoFormazioneObbligatoriaId,
    DateOnly DataCompletamento,
    DateOnly? DataScadenza,
    string? EstremiAttestato,
    string? EnteFormatore,
    int? DurataOreCorso,
    string? Note,
    DateTime DataCreazione,
    DateTime? DataModifica,
    DateTime? DataCancellazione);

public sealed record CreateFormazioneObbligatoriaRequest(
    int TipoFormazioneObbligatoriaId,
    DateOnly DataCompletamento,
    DateOnly? DataScadenza,
    string? EstremiAttestato,
    string? EnteFormatore,
    int? DurataOreCorso,
    string? Note);

public sealed record UpdateFormazioneObbligatoriaRequest(
    int TipoFormazioneObbligatoriaId,
    DateOnly DataCompletamento,
    DateOnly? DataScadenza,
    string? EstremiAttestato,
    string? EnteFormatore,
    int? DurataOreCorso,
    string? Note);

public sealed record CreateFormazioneObbligatoriaResponse(int FormazioneObbligatoriaId);
