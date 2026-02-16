namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.Competenze;

internal sealed record CreateRequest(
    string CodiceCompetenza,
    string? DescrizioneCompetenza,
    bool Principale,
    bool Attivo,
    bool Verificato);

internal sealed record UpdateRequest(
    string CodiceCompetenza,
    string? DescrizioneCompetenza,
    bool Principale,
    bool Attivo,
    bool Verificato);
