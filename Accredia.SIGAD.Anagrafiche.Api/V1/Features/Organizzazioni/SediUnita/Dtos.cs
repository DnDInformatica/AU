namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediUnita;

internal sealed record SedeUnitaDto(
    int SedeUnitaOrganizzativaId,
    int SedeId,
    int UnitaOrganizzativaId,
    string? RuoloOperativo,
    string? DescrizioneRuolo,
    DateTime DataInizio,
    DateTime? DataFine,
    bool Principale,
    bool IsTemporanea,
    decimal? PercentualeAttivita,
    string? Note);
