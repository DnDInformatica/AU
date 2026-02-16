namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.RichiesteEsercizioDiritti;

internal sealed record TipoDirittoGdprLookupItem(
    int Id,
    string Code,
    string Description,
    string Article);

internal sealed record RichiestaEsercizioDirittiDto(
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

