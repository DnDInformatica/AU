namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediUnita;

internal sealed record CreateRequest(
    int SedeId,
    int UnitaOrganizzativaId,
    string? RuoloOperativo,
    string? DescrizioneRuolo,
    DateTime? DataInizio,
    DateTime? DataFine,
    bool Principale,
    bool IsTemporanea,
    decimal? PercentualeAttivita,
    string? Note);

internal sealed record UpdateRequest(
    int SedeId,
    int UnitaOrganizzativaId,
    string? RuoloOperativo,
    string? DescrizioneRuolo,
    DateTime? DataInizio,
    DateTime? DataFine,
    bool Principale,
    bool IsTemporanea,
    decimal? PercentualeAttivita,
    string? Note);
