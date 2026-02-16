namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.UnitaContatti;

internal sealed record CreateRequest(
    int UnitaOrganizzativaId,
    int TipoContattoId,
    string Valore,
    string? ValoreSecondario,
    string? Descrizione,
    string? Note,
    DateTime? DataInizio,
    DateTime? DataFine,
    bool Principale,
    int? OrdinePriorita,
    bool IsVerificato,
    DateTime? DataVerifica,
    bool IsPubblico);

internal sealed record UpdateRequest(
    int UnitaOrganizzativaId,
    int TipoContattoId,
    string Valore,
    string? ValoreSecondario,
    string? Descrizione,
    string? Note,
    DateTime? DataInizio,
    DateTime? DataFine,
    bool Principale,
    int? OrdinePriorita,
    bool IsVerificato,
    DateTime? DataVerifica,
    bool IsPubblico);
