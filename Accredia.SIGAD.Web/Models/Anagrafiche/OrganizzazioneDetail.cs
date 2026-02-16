namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record OrganizzazioneDetail(
    int OrganizzazioneId,
    string Denominazione,
    string RagioneSociale,
    string? PartitaIVA,
    string? CodiceFiscale,
    string? NRegistroImprese,
    int? TipoCodiceNaturaGiuridicaId,
    string? NaturaGiuridicaDescrizione,
    byte? StatoAttivitaId,
    string? OggettoSociale,
    DateTime? DataIscrizioneIscrizioneRI,
    DateTime? DataCostituzione,
    DateTime? DataCancellazione,
    Guid? UniqueRowId,
    DateTime? DataCreazione,
    string? CreatoDa,
    DateTime? DataModifica,
    string? ModificatoDa,
    DateTime? DataInizioValidita,
    DateTime? DataFineValidita);

public sealed record OrganizzazioneTipoItem(
    int TipoOrganizzazioneId,
    string Codice,
    string Descrizione,
    string? CodiceSchemaAccreditamento,
    string? NormaRiferimento,
    bool Principale,
    DateTime? DataAssegnazione,
    DateTime? DataRevoca,
    string? MotivoRevoca);

public sealed record OrganizzazioneIdentificativoFiscaleItem(
    int Id,
    string PaeseISO2,
    string TipoIdentificativo,
    string Valore,
    bool Principale,
    string? Note);

public sealed record SedeItem(
    int SedeId,
    string? Denominazione,
    string? Indirizzo,
    string? NumeroCivico,
    string? CAP,
    string? Localita,
    string? Provincia,
    string? Nazione,
    string? StatoSede,
    bool IsSedePrincipale,
    bool IsSedeOperativa,
    DateTime? DataApertura,
    DateTime? DataCessazione,
    int? TipoSedeId);

public sealed record UnitaOrganizzativaItem(
    int UnitaOrganizzativaId,
    string Nome,
    string? Codice,
    bool Principale,
    int TipoUnitaOrganizzativaId,
    int? TipoSedeId);

public sealed record IncaricoItem(
    int IncaricoId,
    int PersonaId,
    string? PersonaCognome,
    string? PersonaNome,
    string? PersonaCodiceFiscale,
    string Ruolo,
    DateTime DataInizio,
    DateTime? DataFine,
    string StatoIncarico,
    int? UnitaOrganizzativaId,
    DateTime? DataCancellazione);
