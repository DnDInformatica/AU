namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaIndirizzi;

internal sealed record CreateRequest(
    int UnitaOrganizzativaId,
    int TipoIndirizzoId,
    int? ComuneId,
    string Indirizzo,
    string? NumeroCivico,
    string? CAP,
    string? Localita,
    string? Presso,
    decimal? Latitudine,
    decimal? Longitudine,
    string? Piano,
    string? Interno,
    string? Edificio,
    string? ZonaIndustriale,
    DateTime? DataInizio,
    DateTime? DataFine,
    bool Principale);

internal sealed record UpdateRequest(
    int UnitaOrganizzativaId,
    int TipoIndirizzoId,
    int? ComuneId,
    string Indirizzo,
    string? NumeroCivico,
    string? CAP,
    string? Localita,
    string? Presso,
    decimal? Latitudine,
    decimal? Longitudine,
    string? Piano,
    string? Interno,
    string? Edificio,
    string? ZonaIndustriale,
    DateTime? DataInizio,
    DateTime? DataFine,
    bool Principale);
