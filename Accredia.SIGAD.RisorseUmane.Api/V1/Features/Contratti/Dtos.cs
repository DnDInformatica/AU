namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.Contratti;

internal sealed record ContrattoDto(
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

internal sealed record ContrattoCreateRequest(
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

internal sealed record ContrattoUpdateRequest(
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

internal sealed record ContrattoCreateResponse(int ContrattoId);

internal sealed record ContrattoStoricoDto(
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

