using Accredia.SIGAD.Anagrafiche.Api;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Anagrafiche.Api.Services.Auth;
using Accredia.SIGAD.Shared.Auth;
using Accredia.SIGAD.Anagrafiche.Api.Services.DocumentStorage;
using Accredia.SIGAD.Anagrafiche.Api.Services.Monitoring;
using Accredia.SIGAD.Shared.Middleware;
using Accredia.SIGAD.Shared.Versioning;

var builder = WebApplication.CreateBuilder(args);

// Serilog: logging strutturato con CorrelationId
builder.Host.UseSigadSerilog("Anagrafiche.Api");

// Database: Dapper connection factory
builder.Services.Configure<DatabaseOptions>(
    builder.Configuration.GetSection(DatabaseOptions.SectionName));
builder.Services.AddSingleton<IDbConnectionFactory, SqlConnectionFactory>();
builder.Services.AddOptions<PersonaDocumentStorageOptions>()
    .Bind(builder.Configuration.GetSection(PersonaDocumentStorageOptions.SectionName))
    .Validate(ValidateDocumentStorageOptions, "Configurazione DocumentStorage non valida.")
    .ValidateOnStart();
builder.Services.AddOptions<DocumentStorageMonitoringOptions>()
    .Bind(builder.Configuration.GetSection(DocumentStorageMonitoringOptions.SectionName))
    .Validate(
        o => o.ProbeIntervalSeconds > 0 && o.FailureThreshold > 0,
        "Configurazione DocumentStorage.Monitoring non valida.");
builder.Services.AddSingleton<LocalPersonaDocumentStorage>();
builder.Services.AddHttpClient<WebDavPersonaDocumentStorage>();
builder.Services.AddTransient<IPersonaDocumentStorage>(serviceProvider =>
{
    var options = serviceProvider.GetRequiredService<
        Microsoft.Extensions.Options.IOptions<PersonaDocumentStorageOptions>>().Value;
    if (string.Equals(options.Provider, "WebDav", StringComparison.OrdinalIgnoreCase))
    {
        return serviceProvider.GetRequiredService<WebDavPersonaDocumentStorage>();
    }

    return serviceProvider.GetRequiredService<LocalPersonaDocumentStorage>();
});
builder.Services.AddHostedService<DocumentStorageHealthMonitor>();

// RF-059: ogni API valida autonomamente il token. Il gateway instrada, non autentica.
builder.Services.AddSigadAuthentication(builder.Configuration, builder.Environment);
builder.Services.AddScoped<IUserScopeResolver, IamUserScopeResolver>();

// API Versioning
builder.Services.AddSigadApiVersioning();

// Swagger (Development only)
if (builder.Environment.IsDevelopment())
{
    builder.Services.AddSigadVersionedSwagger(
        "Anagrafiche.Api",
        "SIGAD Anagrafiche API - Registry data management");
}

// VSA: Registra automaticamente tutti gli endpoint configurations
builder.Services.AddEndpointConfigurations();

var app = builder.Build();

// Middleware: CorrelationId + Serilog request logging
app.UseSigadRequestLogging();

// Autenticazione, risoluzione su IAM, autorizzazione. L'ordine e' vincolante.
app.UseAuthentication();
app.UseSigadUserResolution();
app.UseAuthorization();

// Swagger UI (Development only)
if (app.Environment.IsDevelopment())
{
    app.UseSigadVersionedSwagger();
}

// Health (unversioned)
app.MapGet("/health", () => Results.Ok(new HealthResponse("ok")))
    .Produces<HealthResponse>(StatusCodes.Status200OK);

app.MapGet(
        "/health/document-storage",
        async (
            IPersonaDocumentStorage storage,
            Microsoft.Extensions.Options.IOptions<PersonaDocumentStorageOptions> options,
            CancellationToken cancellationToken) =>
        {
            var (isHealthy, detail) = await storage.CheckAvailabilityAsync(cancellationToken);
            var response = new DocumentStorageHealthResponse(
                isHealthy ? "ok" : "degraded",
                options.Value.Provider,
                detail);

            return isHealthy
                ? Results.Ok(response)
                : Results.Problem(
                    title: "Document storage unavailable",
                    detail: detail ?? "Document storage provider not reachable.",
                    statusCode: StatusCodes.Status503ServiceUnavailable,
                    extensions: new Dictionary<string, object?>
                    {
                        ["provider"] = options.Value.Provider
                    });
        })
    .Produces<DocumentStorageHealthResponse>(StatusCodes.Status200OK)
    .ProducesProblem(StatusCodes.Status503ServiceUnavailable);

// VSA: Mappa automaticamente tutti gli endpoint
app.MapEndpointConfigurations();

app.Run();

static bool ValidateDocumentStorageOptions(PersonaDocumentStorageOptions options)
{
    if (options is null)
    {
        return false;
    }

    if (!string.Equals(options.Provider, "Local", StringComparison.OrdinalIgnoreCase) &&
        !string.Equals(options.Provider, "WebDav", StringComparison.OrdinalIgnoreCase))
    {
        return false;
    }

    if (string.Equals(options.Provider, "Local", StringComparison.OrdinalIgnoreCase))
    {
        return !string.IsNullOrWhiteSpace(options.BasePath);
    }

    var webDav = options.WebDav;
    if (webDav is null ||
        string.IsNullOrWhiteSpace(webDav.BaseUrl) ||
        string.IsNullOrWhiteSpace(webDav.Username))
    {
        return false;
    }

    if (!string.IsNullOrWhiteSpace(webDav.Password))
    {
        return true;
    }

    if (string.IsNullOrWhiteSpace(webDav.PasswordEnvVar))
    {
        return false;
    }

    return !string.IsNullOrWhiteSpace(Environment.GetEnvironmentVariable(webDav.PasswordEnvVar.Trim()));
}

internal sealed record HealthResponse(string Status);
internal sealed record DocumentStorageHealthResponse(string Status, string Provider, string? Detail);
