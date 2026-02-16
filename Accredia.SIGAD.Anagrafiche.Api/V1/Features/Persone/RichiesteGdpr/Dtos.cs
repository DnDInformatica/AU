namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.RichiesteGdpr;

internal sealed record TipoDirittoInteressatoLookupItem(
    int Id,
    string Code,
    string Description,
    string Article);

internal sealed record RichiestaGdprDto(
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

