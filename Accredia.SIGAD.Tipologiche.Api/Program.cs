using Accredia.SIGAD.Tipologiche.Api;
using Accredia.SIGAD.Tipologiche.Api.Database;
using Accredia.SIGAD.Shared.Middleware;
using Accredia.SIGAD.Shared.Versioning;

AppContext.SetSwitch("Switch.Microsoft.Data.SqlClient.UseManagedNetworkingOnWindows", true);

var builder = WebApplication.CreateBuilder(args);

// Serilog: logging strutturato con CorrelationId
builder.Host.UseSigadSerilog("Tipologiche.Api");

// Database: Dapper connection factory
builder.Services.Configure<DatabaseOptions>(
    builder.Configuration.GetSection(DatabaseOptions.SectionName));
builder.Services.AddSingleton<ISqlConnectionFactory, SqlConnectionFactory>();
builder.Services.AddSingleton<Accredia.SIGAD.Tipologiche.Api.V1.Features.Lookups.ILookupMetadataProvider,
    Accredia.SIGAD.Tipologiche.Api.V1.Features.Lookups.LookupMetadataProvider>();

// API Versioning
builder.Services.AddSigadApiVersioning();

// Swagger (Development only)
if (builder.Environment.IsDevelopment())
{
    builder.Services.AddSigadVersionedSwagger(
        "Tipologiche.Api",
        "SIGAD Tipologiche API - Lookup data management");
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
