using System.Diagnostics;
using System.IO;
using OpenTelemetry.Trace;
using Accredia.SIGAD.Web.Components;
using MudBlazor.Services;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage;
using Accredia.SIGAD.Web.Auth;
using Accredia.SIGAD.Web.Services;
using Serilog;
using Serilog.Context;

var builder = WebApplication.CreateBuilder(args);

builder.Host.UseSerilog((context, services, configuration) =>
    configuration
        .MinimumLevel.Information()
        .Enrich.FromLogContext()
        .Enrich.WithProperty("Application", builder.Environment.ApplicationName)
        .WriteTo.Console()
        .WriteTo.File("logs/log-.txt", rollingInterval: RollingInterval.Day, retainedFileCountLimit: 10, shared: true));

// Add services to the container.
builder.Services.AddRazorComponents()
    .AddInteractiveServerComponents();

builder.Services.AddMudServices();
builder.Services.AddAuthorizationCore();
builder.Services.AddCascadingAuthenticationState();
builder.Services.AddScoped<ProtectedSessionStorage>();
builder.Services.AddScoped<ProtectedLocalStorage>(); // <-- Aggiunto per LocalStorage (RememberMe)
builder.Services.AddHttpContextAccessor();

// In Development persist DataProtection keys in workspace to avoid DPAPI/profile permission issues.
if (builder.Environment.IsDevelopment())
{
    var keysPath = Path.Combine(builder.Environment.ContentRootPath, ".keys");
    Directory.CreateDirectory(keysPath);
    builder.Services.AddDataProtection()
        .PersistKeysToFileSystem(new DirectoryInfo(keysPath));
}

// =====================================================
// FASE 1: TOKEN MANAGEMENT & SECURITY SERVICES
// =====================================================

// Configurazione Token Management da appsettings.json
builder.Services.Configure<TokenManagementOptions>(
    builder.Configuration.GetSection(TokenManagementOptions.SectionName));

// TokenService: Gestisce storage sicuro token (Session + LocalStorage hybrid)
builder.Services.AddScoped<TokenService>();

// TokenRefreshService: Background timer per auto-refresh token
// SCOPED per ciclo di vita del circuito Blazor (utente)
builder.Services.AddScoped<TokenRefreshService>();

// Auth Services (esistenti, aggiornati per usare TokenService)
builder.Services.AddScoped<GatewayAuthenticationStateProvider>();
builder.Services.AddScoped<AuthenticationStateProvider>(sp => sp.GetRequiredService<GatewayAuthenticationStateProvider>());
builder.Services.AddScoped<UserContext>();

// QuickDrawerService: stato UI per drawer di dettaglio rapido (pattern mockup).
builder.Services.AddScoped<QuickDrawerService>();

// NOTE ARCHITETTURALE (Blazor Server):
// Non usiamo HttpClientFactory + DelegatingHandler per iniettare token, perché l'HttpClientFactory
// crea un "handler scope" separato dal circuito Blazor: i servizi scoped (TokenService, ProtectedSessionStorage)
// non sono quelli del circuito e quindi l'Authorization header risulta assente -> 401 su /me.
// Creiamo invece HttpClient scoped per circuito, costruendo il GatewayAuthorizationHandler nello stesso scope.
builder.Services.AddScoped<GatewayClient>(sp =>
{
    var config = sp.GetRequiredService<IConfiguration>();
    var baseUrl = config.GetValue<string>("Gateway:BaseUrl");
    if (string.IsNullOrWhiteSpace(baseUrl))
    {
        throw new InvalidOperationException("Gateway:BaseUrl non configurato.");
    }

    var handler = ActivatorUtilities.CreateInstance<GatewayAuthorizationHandler>(sp);
    handler.InnerHandler = new HttpClientHandler();

    var httpClient = new HttpClient(handler)
    {
        BaseAddress = new Uri(baseUrl, UriKind.Absolute)
    };

    return new GatewayClient(httpClient);
});

// HttpClient senza handler per refresh token (evita dipendenza circolare)
builder.Services.AddHttpClient("GatewayRefresh", client =>
    {
        var baseUrl = builder.Configuration.GetValue<string>("Gateway:BaseUrl");
        if (string.IsNullOrWhiteSpace(baseUrl))
        {
            throw new InvalidOperationException("Gateway:BaseUrl non configurato.");
        }

        client.BaseAddress = new Uri(baseUrl, UriKind.Absolute);
    });

// =====================================================
// FASE 2: ADMIN PANEL SERVICES
// =====================================================

// AdminClient: stesso pattern di GatewayClient (HttpClient scoped per circuito con handler nello stesso scope).
builder.Services.AddScoped<AdminClient>(sp =>
{
    var config = sp.GetRequiredService<IConfiguration>();
    var baseUrl = config.GetValue<string>("Gateway:BaseUrl");
    if (string.IsNullOrWhiteSpace(baseUrl))
    {
        throw new InvalidOperationException("Gateway:BaseUrl non configurato.");
    }

    var handler = ActivatorUtilities.CreateInstance<GatewayAuthorizationHandler>(sp);
    handler.InnerHandler = new HttpClientHandler();

    var httpClient = new HttpClient(handler)
    {
        BaseAddress = new Uri(baseUrl, UriKind.Absolute)
    };

    return new AdminClient(httpClient);
});

// =====================================================
// TELEMETRY & MONITORING
// =====================================================

builder.Services.AddOpenTelemetry()
    .WithTracing(tracing =>
    {
        tracing
            .AddAspNetCoreInstrumentation()
            .AddHttpClientInstrumentation();
    });

var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Error", createScopeForErrors: true);
}

// Correlation-Id middleware per distributed tracing
app.Use(async (context, next) =>
{
    const string correlationHeader = "X-Correlation-Id";
    var correlationId = context.Request.Headers[correlationHeader].FirstOrDefault();
    if (string.IsNullOrWhiteSpace(correlationId))
    {
        correlationId = Guid.NewGuid().ToString("N");
        context.Request.Headers[correlationHeader] = correlationId;
    }

    var traceId = Activity.Current?.TraceId.ToString() ?? context.TraceIdentifier;
    context.Response.Headers[correlationHeader] = correlationId;

    context.Items["CorrelationId"] = correlationId;
    context.Items["TraceId"] = traceId;

    using (LogContext.PushProperty("CorrelationId", correlationId))
    using (LogContext.PushProperty("TraceId", traceId))
    {
        await next();
    }
});

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

app.UseAntiforgery();

app.MapStaticAssets();
app.MapRazorComponents<App>()
    .AddInteractiveServerRenderMode();

app.Run();
