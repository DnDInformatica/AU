namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Storico;

internal sealed record OrganizzazioneStoricoDto(
    int OrganizzazioneId,
    string RagioneSociale,
    string Denominazione,
    string? PartitaIva,
    string? CodiceFiscale,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record UnitaOrganizzativaStoricoDto(
    int UnitaOrganizzativaId,
    int OrganizzazioneId,
    string Nome,
    bool Principale,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record SedeStoricoDto(
    int SedeId,
    int OrganizzazioneId,
    string Indirizzo,
    string? Localita,
    string StatoSede,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record IncaricoStoricoDto(
    int IncaricoId,
    int PersonaId,
    int TipoRuoloId,
    int? OrganizzazioneId,
    int? UnitaOrganizzativaId,
    DateTime DataInizio,
    DateTime? DataFine,
    string StatoIncarico,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record OrganizzazioneSedeStoricoDto(
    int OrganizzazioneSedeId,
    int OrganizzazioneId,
    byte TipoOrganizzazioneSedeId,
    DateTime? DataApertura,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record OrganizzazioneTipoOrganizzazioneStoricoDto(
    int OrganizzazioneTipoOrganizzazioneId,
    int OrganizzazioneId,
    int TipoOrganizzazioneId,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record OrganizzazioneIdentificativoFiscaleStoricoDto(
    int OrganizzazioneIdentificativoFiscaleId,
    int OrganizzazioneId,
    string? PaeseISO2,
    string? TipoIdentificativo,
    string Valore,
    bool Principale,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record UnitaRelazioneStoricoDto(
    int UnitaRelazioneId,
    int UnitaPadreId,
    int UnitaFigliaId,
    int TipoRelazioneId,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record UnitaFunzioneStoricoDto(
    int UnitaOrganizzativaFunzioneId,
    int UnitaOrganizzativaId,
    int TipoFunzioneUnitaLocaleId,
    bool Principale,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record ContattoUnitaStoricoDto(
    int ContattoId,
    int UnitaOrganizzativaId,
    int TipoContattoId,
    string Valore,
    bool Principale,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record IndirizzoUnitaStoricoDto(
    int IndirizzoId,
    int UnitaOrganizzativaId,
    int TipoIndirizzoId,
    string Indirizzo,
    bool Principale,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record SedeUnitaStoricoDto(
    int SedeUnitaOrganizzativaId,
    int SedeId,
    int UnitaOrganizzativaId,
    bool Principale,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record CompetenzaStoricoDto(
    int CompetenzaId,
    string CodiceCompetenza,
    bool Principale,
    bool Attivo,
    bool Verificato,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record PotereStoricoDto(
    int PotereId,
    int IncaricoId,
    int TipoPotereId,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record GruppoIvaStoricoDto(
    int GruppoIvaId,
    string PartitaIvaGruppo,
    string Denominazione,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record GruppoIvaMembroStoricoDto(
    int GruppoIvaMembroId,
    int GruppoIvaId,
    int OrganizzazioneId,
    bool IsCapogruppo,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);

internal sealed record UnitaAttivitaStoricoDto(
    int UnitaAttivitaId,
    int UnitaOrganizzativaId,
    string CodiceAtecoRi,
    string Importanza,
    DateTime DataInizioValidita,
    DateTime DataFineValidita,
    DateTime? DataCancellazione);
