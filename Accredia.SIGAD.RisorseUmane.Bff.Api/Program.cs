using Accredia.SIGAD.RisorseUmane.Bff.Api;
using Accredia.SIGAD.RisorseUmane.Bff.Api.Services;
using Accredia.SIGAD.Shared.Auth;
using Accredia.SIGAD.Shared.Middleware;
using Accredia.SIGAD.Shared.Versioning;

var builder = WebApplication.CreateBuilder(args);

builder.Host.UseSigadSerilog("RisorseUmane.Bff.Api");

// RF-059: anche il livello di composizione valida il token; non essendo
// titolare di dati non risolve l'identita' su IAM, ma propaga la credenziale
// del chiamante ai servizi a valle, dove la risoluzione avviene nel punto in
// cui il dato risiede (RF-060). Un token valido di soggetto non censito viene
// quindi respinto a valle, non qui.
builder.Services.AddSigadAuthentication(
    builder.Configuration, builder.Environment, risolveIdentitaSuIam: false);

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
})
.AddHttpMessageHandler<PropagazioneIdentitaHandler>();

builder.Services.AddHttpClient("Anagrafiche", client =>
{
    client.BaseAddress = new Uri(anagraficheBaseUrl, UriKind.Absolute);
})
.AddHttpMessageHandler<PropagazioneIdentitaHandler>();

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

// Nessuna UseSigadUserResolution: la risoluzione su IAM avviene a valle.
app.UseAuthentication();
app.UseAuthorization();

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

