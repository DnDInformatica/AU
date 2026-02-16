namespace Accredia.SIGAD.Web.Models.Anagrafiche;

public sealed record CreateSedeRequest(
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

public sealed record UpdateSedeRequest(
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

