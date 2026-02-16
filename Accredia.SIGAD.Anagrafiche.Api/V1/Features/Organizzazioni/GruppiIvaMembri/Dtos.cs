namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GruppiIvaMembri;

internal sealed record GruppoIvaMembroDto(
    int GruppoIvaMembroId,
    int GruppoIvaId,
    int OrganizzazioneId,
    DateTime DataAdesione,
    DateTime? DataUscita,
    string? MotivoUscita,
    string? ProtocolloUscita,
    bool IsCapogruppo,
    string? RuoloNelGruppo,
    decimal? PercentualePartecipazione,
    string StatoMembro,
    string? Note);
