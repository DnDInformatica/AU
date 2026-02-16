namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.GetSedi;

// Keep aligned with Accredia.SIGAD.Web.Models.Anagrafiche.SedeItem (int-based model).
internal sealed record SedeDto(
    int SedeId,
    string? Denominazione,
    string? Indirizzo,
    string? NumeroCivico,
    string? CAP,
    string? Localita,
    string? Provincia,
    string? Nazione,
    string? StatoSede,
    bool IsSedePrincipale,
    bool IsSedeOperativa,
    DateTime? DataApertura,
    DateTime? DataCessazione,
    int? TipoSedeId);

