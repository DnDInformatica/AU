namespace Accredia.SIGAD.RisorseUmane.Api.V1.Features.Dipendenti;

internal sealed record DipendenteDto(
    int DipendenteId,
    int PersonaId,
    string Matricola,
    string? EmailAziendale,
    string? TelefonoInterno,
    int? UnitaOrganizzativaId,
    int? ResponsabileDirettoId,
    DateOnly DataAssunzione,
    DateOnly? DataCessazione,
    int StatoDipendenteId,
    bool AbilitatoAttivitaIspettiva,
    string? Note,
    DateTime DataCreazione,
    DateTime? DataModifica,
    DateTime? DataCancellazione);

internal sealed record DipendenteCreateRequest(
    int PersonaId,
    string Matricola,
    string? EmailAziendale,
    string? TelefonoInterno,
    int? UnitaOrganizzativaId,
    int? ResponsabileDirettoId,
    DateOnly DataAssunzione,
    DateOnly? DataCessazione,
    int StatoDipendenteId,
    bool? AbilitatoAttivitaIspettiva,
    string? Note);

internal sealed record DipendenteUpdateRequest(
    int PersonaId,
    string Matricola,
    string? EmailAziendale,
    string? TelefonoInterno,
    int? UnitaOrganizzativaId,
    int? ResponsabileDirettoId,
    DateOnly DataAssunzione,
    DateOnly? DataCessazione,
    int StatoDipendenteId,
    bool? AbilitatoAttivitaIspettiva,
    string? Note);

internal sealed record DipendenteCreateResponse(int DipendenteId);

internal sealed record DipendenteStoricoDto(
    int DipendenteId,
    int PersonaId,
    string Matricola,
    string? EmailAziendale,
    string? TelefonoInterno,
    int? UnitaOrganizzativaId,
    int? ResponsabileDirettoId,
    DateOnly DataAssunzione,
    DateOnly? DataCessazione,
    int StatoDipendenteId,
    bool AbilitatoAttivitaIspettiva,
    string? Note,
    DateTime DataCreazione,
    DateTime? DataModifica,
    DateTime? DataCancellazione,
    DateTime DataInizioValidita,
    DateTime DataFineValidita);

