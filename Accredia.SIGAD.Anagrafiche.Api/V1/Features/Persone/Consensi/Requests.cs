namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Consensi;

internal sealed record CreateRequest(
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

internal sealed record UpdateRequest(
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

