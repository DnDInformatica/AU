namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Competenze;

internal sealed record CompetenzaDto(
    int CompetenzaId,
    string CodiceCompetenza,
    string? DescrizioneCompetenza,
    bool Principale,
    bool Attivo,
    bool Verificato);
