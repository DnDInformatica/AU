namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Qualifiche;

internal sealed record CreateRequest(
    int TipoQualificaId,
    int? EnteRilascioQualificaId,
    string? CodiceAttestato,
    DateTime? DataRilascio,
    DateTime? DataScadenza,
    bool Valida,
    string? Note);

internal sealed record UpdateRequest(
    int TipoQualificaId,
    int? EnteRilascioQualificaId,
    string? CodiceAttestato,
    DateTime? DataRilascio,
    DateTime? DataScadenza,
    bool Valida,
    string? Note);

