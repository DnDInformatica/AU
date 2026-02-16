namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaAttivita;

internal sealed record CreateRequest(
    int UnitaOrganizzativaId,
    string CodiceAtecoRi,
    string? DescrizioneAttivita,
    string? Importanza,
    DateTime? DataInizioAttivita,
    DateTime? DataFineAttivita,
    string? FonteDato,
    string? Note);

internal sealed record UpdateRequest(
    int UnitaOrganizzativaId,
    string CodiceAtecoRi,
    string? DescrizioneAttivita,
    string? Importanza,
    DateTime? DataInizioAttivita,
    DateTime? DataFineAttivita,
    string? FonteDato,
    string? Note);
