using Accredia.SIGAD.RisorseUmane.Api;
using Accredia.SIGAD.RisorseUmane.Api.Database;
using Accredia.SIGAD.RisorseUmane.Api.Services;
using Accredia.SIGAD.Shared.Middleware;
using Accredia.SIGAD.Shared.Versioning;

AppContext.SetSwitch("Switch.Microsoft.Data.SqlClient.UseManagedNetworkingOnWindows", true);

var builder = WebApplication.CreateBuilder(args);

// Serilog: logging strutturato con CorrelationId
builder.Host.UseSigadSerilog("RisorseUmane.Api");

// Database: Dapper connection factory
builder.Services.Configure<DatabaseOptions>(
    builder.Configuration.GetSection(DatabaseOptions.SectionName));
builder.Services.AddSingleton<ISqlConnectionFactory, SqlConnectionFactory>();

// Service-to-service clients
var anagraficheBaseUrl = builder.Configuration["Services:Anagrafiche:BaseUrl"];
if (string.IsNullOrWhiteSpace(anagraficheBaseUrl))
{
    throw new InvalidOperationException("Missing Services:Anagrafiche:BaseUrl.");
}

builder.Services.AddHttpClient("Anagrafiche", client =>
{
    client.BaseAddress = new Uri(anagraficheBaseUrl, UriKind.Absolute);
});

builder.Services.AddSingleton<IPersonaClient, PersonaClient>();

// API Versioning
builder.Services.AddSigadApiVersioning();

// Swagger (Development only)
if (builder.Environment.IsDevelopment())
{
    builder.Services.AddSigadVersionedSwagger(
        "RisorseUmane.Api",
        "SIGAD Risorse Umane API - HR data management");
}

// VSA: Registra automaticamente tutti gli endpoint configurations
builder.Services.AddEndpointConfigurations();

var app = builder.Build();

// Middleware: CorrelationId + Serilog request logging
app.UseSigadRequestLogging();

// Swagger UI (Development only)
if (app.Environment.IsDevelopment())
{
    app.UseSigadVersionedSwagger();
}

// Health (unversioned)
app.MapGet("/health", () => Results.Ok(new HealthResponse("ok")))
    .Produces<HealthResponse>(StatusCodes.Status200OK);

// VSA: Mappa automaticamente tutti gli endpoint
app.MapEndpointConfigurations();

app.Run();

internal sealed record HealthResponse(string Status);

public partial class Program { }
