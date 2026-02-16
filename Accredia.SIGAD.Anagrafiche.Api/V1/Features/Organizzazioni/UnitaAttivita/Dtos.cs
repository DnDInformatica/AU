namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaAttivita;

internal sealed record UnitaAttivitaDto(
    int UnitaAttivitaId,
    int UnitaOrganizzativaId,
    string CodiceAtecoRi,
    string? DescrizioneAttivita,
    string Importanza,
    DateTime? DataInizioAttivita,
    DateTime? DataFineAttivita,
    string? FonteDato,
    string? Note);
