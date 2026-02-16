using Accredia.SIGAD.Anagrafiche.Api;
using Accredia.SIGAD.Anagrafiche.Api.Database;
using Accredia.SIGAD.Shared.Middleware;
using Accredia.SIGAD.Shared.Versioning;

AppContext.SetSwitch("Switch.Microsoft.Data.SqlClient.UseManagedNetworkingOnWindows", true);

var builder = WebApplication.CreateBuilder(args);

// Serilog: logging strutturato con CorrelationId
builder.Host.UseSigadSerilog("Anagrafiche.Api");

// Database: Dapper connection factory
builder.Services.Configure<DatabaseOptions>(
    builder.Configuration.GetSection(DatabaseOptions.SectionName));
builder.Services.AddSingleton<IDbConnectionFactory, SqlConnectionFactory>();

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
