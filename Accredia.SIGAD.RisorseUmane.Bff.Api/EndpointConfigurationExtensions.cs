using System.Reflection;

namespace Accredia.SIGAD.RisorseUmane.Bff.Api;

internal interface IEndpointConfiguration
{
    void MapEndpoints(IEndpointRouteBuilder app);
}

internal static class EndpointConfigurationExtensions
{
    public static IServiceCollection AddEndpointConfigurations(this IServiceCollection services)
    {
        services.AddSingleton<IEnumerable<IEndpointConfiguration>>(_ =>
        {
            var endpointConfigs = Assembly.GetExecutingAssembly()
                .GetTypes()
                .Where(t => !t.IsAbstract && typeof(IEndpointConfiguration).IsAssignableFrom(t))
                .Select(t => (IEndpointConfiguration)Activator.CreateInstance(t)!)
                .ToArray();

            return endpointConfigs;
        });

        return services;
    }

    public static void MapEndpointConfigurations(this IEndpointRouteBuilder app)
    {
        var endpointConfigurations = app.ServiceProvider.GetRequiredService<IEnumerable<IEndpointConfiguration>>();
        foreach (var config in endpointConfigurations)
        {
            config.MapEndpoints(app);
        }
    }
}

