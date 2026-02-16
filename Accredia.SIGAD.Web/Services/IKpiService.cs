namespace Accredia.SIGAD.Web.Services;

/// <summary>
/// Servizio per recuperare KPI dashboard
/// </summary>
public interface IKpiService
{
    Task<DashboardKpiDto> GetDashboardKpiAsync(CancellationToken ct = default);
}

public record DashboardKpiDto(
    int OrganizzazioniAttive,
    int PersoneCensente,
    int IncarichiAttivi,
    int SegnalazioniRecenti);
