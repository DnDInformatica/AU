using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;

namespace Accredia.SIGAD.Shared.Endpoints;

/// <summary>
/// Marker interface per l'implementazione di endpoint configuration
/// Segue Vertical Slice Architecture: ogni feature implementa questa interfaccia
/// </summary>
public interface IEndpointConfiguration
{
    /// <summary>
    /// Registra i servizi necessari per gli endpoint della feature
    /// </summary>
    void AddServices(IServiceCollection services);

    /// <summary>
    /// Mappa gli endpoint della feature
    /// </summary>
    void MapEndpoints(WebApplication app);
}
