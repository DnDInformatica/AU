namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Organizzazioni.SediUpdate;

internal sealed record UpdateSedeRequest(
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

