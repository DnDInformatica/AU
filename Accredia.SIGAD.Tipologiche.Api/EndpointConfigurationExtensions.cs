namespace Accredia.SIGAD.Tipologiche.Api;

internal interface IEndpointConfiguration
{
    void MapEndpoints(IEndpointRouteBuilder app);
}

internal static class EndpointConfigurationExtensions
{
    public static IServiceCollection AddEndpointConfigurations(this IServiceCollection services)
    {
        var assembly = typeof(EndpointConfigurationExtensions).Assembly;
        var configTypes = assembly.GetTypes()
            .Where(type => type is { IsAbstract: false, IsInterface: false }
                && typeof(IEndpointConfiguration).IsAssignableFrom(type));

        foreach (var type in configTypes)
        {
            services.AddSingleton(typeof(IEndpointConfiguration), type);
        }

        return services;
    }

    public static WebApplication MapEndpointConfigurations(this WebApplication app)
    {
        var configurations = app.Services.GetServices<IEndpointConfiguration>();

        foreach (var configuration in configurations)
        {
            configuration.MapEndpoints(app);
        }

        return app;
    }
}
