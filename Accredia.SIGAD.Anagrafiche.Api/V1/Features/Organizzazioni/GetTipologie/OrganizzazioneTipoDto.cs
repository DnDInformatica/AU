namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetTipologie;

// Keep aligned with Accredia.SIGAD.Web.Models.Anagrafiche.OrganizzazioneTipoItem (subset may be null).
internal sealed record OrganizzazioneTipoDto(
    int TipoOrganizzazioneId,
    string Codice,
    string Descrizione,
    string? CodiceSchemaAccreditamento,
    string? NormaRiferimento,
    bool Principale,
    DateTime? DataAssegnazione,
    DateTime? DataRevoca,
    string? MotivoRevoca);

