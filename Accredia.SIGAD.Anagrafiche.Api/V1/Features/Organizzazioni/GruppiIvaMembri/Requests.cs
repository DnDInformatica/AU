namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GruppiIvaMembri;

internal sealed record CreateRequest(
    int OrganizzazioneId,
    DateTime? DataAdesione,
    DateTime? DataUscita,
    string? MotivoUscita,
    string? ProtocolloUscita,
    bool IsCapogruppo,
    string? RuoloNelGruppo,
    decimal? PercentualePartecipazione,
    string? StatoMembro,
    string? Note);

internal sealed record UpdateRequest(
    int OrganizzazioneId,
    DateTime? DataAdesione,
    DateTime? DataUscita,
    string? MotivoUscita,
    string? ProtocolloUscita,
    bool IsCapogruppo,
    string? RuoloNelGruppo,
    decimal? PercentualePartecipazione,
    string? StatoMembro,
    string? Note);
