using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Hosting;
using Serilog;

namespace Accredia.SIGAD.Shared.Middleware;

/// <summary>
/// Extension methods per configurare Serilog e il middleware CorrelationId.
/// </summary>
public static class SerilogExtensions
{
    /// <summary>
    /// Configura Serilog con output su Console e File, arricchito con il nome applicazione.
    /// </summary>
    public static IHostBuilder UseSigadSerilog(this IHostBuilder hostBuilder, string applicationName)
    {
        return hostBuilder.UseSerilog((context, services, configuration) =>
            configuration
                .MinimumLevel.Information()
                .MinimumLevel.Override("Microsoft.AspNetCore", Serilog.Events.LogEventLevel.Warning)
                .Enrich.FromLogContext()
                .Enrich.WithProperty("Application", applicationName)
                .WriteTo.Console(outputTemplate: "[{Timestamp:HH:mm:ss} {Level:u3}] [{Application}] [{CorrelationId}] {Message:lj}{NewLine}{Exception}")
                .WriteTo.File($"logs/{applicationName}-.txt",
                    rollingInterval: RollingInterval.Day,
                    retainedFileCountLimit: 10,
                    shared: true,
                    outputTemplate: "{Timestamp:yyyy-MM-dd HH:mm:ss.fff zzz} [{Level:u3}] [{Application}] [{CorrelationId}] [{TraceId}] {Message:lj}{NewLine}{Exception}"));
    }

    /// <summary>
    /// Aggiunge il middleware CorrelationId e Serilog request logging.
    /// </summary>
    public static WebApplication UseSigadRequestLogging(this WebApplication app)
    {
        app.UseMiddleware<CorrelationIdMiddleware>();

        app.UseSerilogRequestLogging(options =>
        {
            options.EnrichDiagnosticContext = (diagnosticContext, httpContext) =>
            {
                if (httpContext.Items.TryGetValue("CorrelationId", out var correlationId))
                {
                    diagnosticContext.Set("CorrelationId", correlationId);
                }

                if (httpContext.Items.TryGetValue("TraceId", out var traceId))
                {
                    diagnosticContext.Set("TraceId", traceId);
                }
            };
        });

        return app;
    }
}
