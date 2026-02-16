using Accredia.SIGAD.RisorseUmane.Bff.Api;
using Accredia.SIGAD.RisorseUmane.Bff.Api.Services;
using Accredia.SIGAD.Shared.Middleware;
using Accredia.SIGAD.Shared.Versioning;

var builder = WebApplication.CreateBuilder(args);

builder.Host.UseSigadSerilog("RisorseUmane.Bff.Api");

// Downstream services
var risorseUmaneBaseUrl = builder.Configuration["Services:RisorseUmane:BaseUrl"];
if (string.IsNullOrWhiteSpace(risorseUmaneBaseUrl))
{
    throw new InvalidOperationException("Missing Services:RisorseUmane:BaseUrl.");
}

var anagraficheBaseUrl = builder.Configuration["Services:Anagrafiche:BaseUrl"];
if (string.IsNullOrWhiteSpace(anagraficheBaseUrl))
{
    throw new InvalidOperationException("Missing Services:Anagrafiche:BaseUrl.");
}

builder.Services.AddHttpClient("RisorseUmane", client =>
{
    client.BaseAddress = new Uri(risorseUmaneBaseUrl, UriKind.Absolute);
});

builder.Services.AddHttpClient("Anagrafiche", client =>
{
    client.BaseAddress = new Uri(anagraficheBaseUrl, UriKind.Absolute);
});

builder.Services.AddSingleton<IRisorseUmaneClient, RisorseUmaneClient>();
builder.Services.AddSingleton<IAnagraficheClient, AnagraficheClient>();

// API Versioning
builder.Services.AddSigadApiVersioning();

// Swagger (Development only)
if (builder.Environment.IsDevelopment())
{
    builder.Services.AddSigadVersionedSwagger(
        "RisorseUmane.Bff.Api",
        "SIGAD Risorse Umane BFF - composition layer");
}

// VSA: endpoint discovery
builder.Services.AddEndpointConfigurations();

var app = builder.Build();

app.UseSigadRequestLogging();

if (app.Environment.IsDevelopment())
{
    app.UseSigadVersionedSwagger();
}

// Health (unversioned)
app.MapGet("/health", () => Results.Ok(new HealthResponse("ok")))
    .Produces<HealthResponse>(StatusCodes.Status200OK);

app.MapEndpointConfigurations();

app.Run();

internal sealed record HealthResponse(string Status);

public partial class Program { }

