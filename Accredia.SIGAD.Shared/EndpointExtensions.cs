using Microsoft.AspNetCore.Builder;
using Microsoft.Extensions.DependencyInjection;
using System.Reflection;
using Accredia.SIGAD.Shared.Endpoints;

namespace Accredia.SIGAD.Shared;

/// <summary>
/// Extension methods per la registrazione automatica degli endpoint VSA
/// Utilizza reflection per scoprire tutte le implementazioni di IEndpointConfiguration
/// </summary>
public static class EndpointExtensions
{
    /// <summary>
    /// Registra automaticamente tutti i servizi da implementazioni di IEndpointConfiguration
    /// nell'assembly del chiamante
    /// </summary>
    public static IServiceCollection AddEndpointConfigurations(
        this IServiceCollection services, 
        Assembly? assembly = null)
    {
        assembly ??= Assembly.GetCallingAssembly();

        var endpointConfigurationType = typeof(IEndpointConfiguration);
        var configurations = assembly.GetTypes()
            .Where(t => !t.IsAbstract && endpointConfigurationType.IsAssignableFrom(t))
            .Select(Activator.CreateInstance)
            .Cast<IEndpointConfiguration>();

        foreach (var config in configurations)
        {
            config.AddServices(services);
        }

        return services;
    }

    /// <summary>
    /// Mappa automaticamente tutti gli endpoint da implementazioni di IEndpointConfiguration
    /// nell'assembly del chiamante
    /// </summary>
    public static WebApplication MapEndpointConfigurations(
        this WebApplication app,
        Assembly? assembly = null)
    {
        assembly ??= Assembly.GetCallingAssembly();

        var endpointConfigurationType = typeof(IEndpointConfiguration);
        var configurations = assembly.GetTypes()
            .Where(t => !t.IsAbstract && endpointConfigurationType.IsAssignableFrom(t))
            .Select(Activator.CreateInstance)
            .Cast<IEndpointConfiguration>();

        foreach (var config in configurations)
        {
            config.MapEndpoints(app);
        }

        return app;
    }
}
