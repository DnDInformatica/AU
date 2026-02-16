namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GruppiIva;

internal sealed record GruppoIvaDto(
    int GruppoIvaId,
    string PartitaIvaGruppo,
    string Denominazione,
    string? CodiceGruppo,
    DateTime DataCostituzione,
    DateTime? DataApprovazione,
    string? ProtocolloAgenziaEntrate,
    string? NumeroProvvedimento,
    string StatoGruppo,
    DateTime? DataCessazione,
    string? MotivoCessazione,
    int? OrganizzazioneCapogruppoId,
    string? Note,
    string? DocumentazioneRiferimento);
