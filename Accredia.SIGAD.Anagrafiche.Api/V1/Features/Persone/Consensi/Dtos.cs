namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Consensi;

internal sealed record TipoFinalitaTrattamentoLookupItem(
    int Id,
    string Code,
    string Description,
    string Category,
    bool RequiresExplicitConsent,
    bool IsMandatory);

internal sealed record ConsensoPersonaDto(
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

