using System.Diagnostics;
using System.Net.Http.Json;
using System.Threading.RateLimiting;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.Net.Http.Headers;
using OpenTelemetry.Trace;
using Serilog;
using Serilog.Context;
using Yarp.ReverseProxy.Transforms;

var builder = WebApplication.CreateBuilder(args);

builder.Host.UseSerilog((context, services, configuration) =>
    configuration
        .MinimumLevel.Information()
        .Enrich.FromLogContext()
        .Enrich.WithProperty("Application", builder.Environment.ApplicationName)
        .WriteTo.Console()
        .WriteTo.File("logs/log-.txt", rollingInterval: RollingInterval.Day, retainedFileCountLimit: 10, shared: true));

// In sandboxed/dev environments the user profile key ring may be unavailable.
// Persist keys inside the project folder to keep the gateway runnable.
if (builder.Environment.IsDevelopment())
{
    var keysPath = Path.Combine(builder.Environment.ContentRootPath, ".data-protection-keys");
    Directory.CreateDirectory(keysPath);
    builder.Services.AddDataProtection()
        .PersistKeysToFileSystem(new DirectoryInfo(keysPath));
}

builder.Services
    .AddReverseProxy()
    .LoadFromConfig(builder.Configuration.GetSection("ReverseProxy"))
    .AddTransforms(transformBuilderContext =>
    {
        transformBuilderContext.AddRequestTransform(context =>
        {
            const string correlationHeader = "X-Correlation-Id";
            if (context.HttpContext.Request.Headers.TryGetValue(correlationHeader, out var correlationId))
            {
                context.ProxyRequest.Headers.Remove(correlationHeader);
                context.ProxyRequest.Headers.TryAddWithoutValidation(correlationHeader, correlationId.ToArray());
            }

            if (context.HttpContext.Request.Headers.TryGetValue("Authorization", out var authorization))
            {
                context.ProxyRequest.Headers.Remove("Authorization");
                context.ProxyRequest.Headers.TryAddWithoutValidation("Authorization", authorization.ToArray());
            }

            return ValueTask.CompletedTask;
        });
    });
builder.Services.AddOpenTelemetry()
    .WithTracing(tracing =>
    {
        tracing
            .AddAspNetCoreInstrumentation()
            .AddHttpClientInstrumentation();
    });

var anagraficheAddress = builder.Configuration["ReverseProxy:Clusters:anagrafiche:Destinations:d1:Address"];
if (string.IsNullOrWhiteSpace(anagraficheAddress))
{
    throw new InvalidOperationException("ReverseProxy anagrafiche address is missing in Gateway configuration.");
}

// La ricerca globale interroga Anagrafiche per conto dell'utente: il token (e in
// sviluppo X-Dev-Oid) va propagato, altrimenti le chiamate risultano anonime.
builder.Services.AddHttpContextAccessor();
builder.Services.AddTransient<Accredia.SIGAD.Shared.Auth.PropagazioneIdentitaHandler>();
builder.Services.AddHttpClient("Anagrafiche", client =>
{
    client.BaseAddress = new Uri(anagraficheAddress, UriKind.Absolute);
})
.AddHttpMessageHandler<Accredia.SIGAD.Shared.Auth.PropagazioneIdentitaHandler>();

// Autenticazione e autorizzazione: nessuna nel Gateway (RF-059, decisione del
// 2026-11-05). Il Gateway instrada; ogni API valida il token Entra e
// autorizza per permesso IAM. Il vecchio token di Identity.Api non e' piu'
// validato qui: nessuna API lo accetta.

// Rate limiting (Gateway)
builder.Services.AddRateLimiter(options =>
{
    options.RejectionStatusCode = StatusCodes.Status429TooManyRequests;

    options.AddPolicy("AuthLogin", httpContext =>
        RateLimitPartition.GetFixedWindowLimiter(
            partitionKey: httpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown",
            factory: _ => new FixedWindowRateLimiterOptions
            {
                PermitLimit = 10,
                Window = TimeSpan.FromMinutes(1),
                QueueProcessingOrder = QueueProcessingOrder.OldestFirst,
                QueueLimit = 0
            }));

    options.AddPolicy("AuthRefresh", httpContext =>
        RateLimitPartition.GetFixedWindowLimiter(
            partitionKey: httpContext.Connection.RemoteIpAddress?.ToString() ?? "unknown",
            factory: _ => new FixedWindowRateLimiterOptions
            {
                PermitLimit = 20,
                Window = TimeSpan.FromMinutes(1),
                QueueProcessingOrder = QueueProcessingOrder.OldestFirst,
                QueueLimit = 0
            }));
});

var app = builder.Build();

app.Use(async (context, next) =>
{
    const string correlationHeader = "X-Correlation-Id";
    var correlationId = context.Request.Headers[correlationHeader].FirstOrDefault();
    if (string.IsNullOrWhiteSpace(correlationId))
    {
        correlationId = Guid.NewGuid().ToString("N");
    }

    context.Request.Headers[correlationHeader] = correlationId;
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

app.MapGet("/health", () => Results.Ok(new HealthResponse("ok")))
    .WithName("Health")
    .Produces<HealthResponse>(StatusCodes.Status200OK);

app.MapGet("/search/global", async (
        string query,
        int? page,
        int? pageSize,
        IHttpClientFactory httpClientFactory,
        CancellationToken cancellationToken) =>
    {
        if (string.IsNullOrWhiteSpace(query))
        {
            return Results.BadRequest(new { error = "Query di ricerca obbligatoria." });
        }

        // Aggrega la ricerca dai domini Anagrafiche (Organizzazioni, Persone, Incarichi).
        var pageValue = page ?? 1;
        var pageSizeValue = pageSize ?? 5;

        var client = httpClientFactory.CreateClient("Anagrafiche");
        var encodedQuery = Uri.EscapeDataString(query);

        var orgTask = FetchAsync<OrganizzazioneSearchItem>(
            client,
            $"/v1/organizzazioni/search?q={encodedQuery}&page={pageValue}&pageSize={pageSizeValue}",
            pageValue,
            pageSizeValue,
            cancellationToken);
        var personeTask = FetchAsync<PersonaSearchItem>(
            client,
            $"/v1/persone/search?q={encodedQuery}&page={pageValue}&pageSize={pageSizeValue}",
            pageValue,
            pageSizeValue,
            cancellationToken);
        var incarichiTask = FetchAsync<IncaricoSearchItem>(
            client,
            $"/v1/incarichi/search?q={encodedQuery}&page={pageValue}&pageSize={pageSizeValue}",
            pageValue,
            pageSizeValue,
            cancellationToken);

        await Task.WhenAll(orgTask, personeTask, incarichiTask);

        var org = orgTask.Result;
        var persone = personeTask.Result;
        var incarichi = incarichiTask.Result;

        var response = new GlobalSearchResponse(
            query,
            new SearchGroup<GlobalSearchItem>(
                org.Items.Select(item => new GlobalSearchItem(
                    item.OrganizzazioneId.ToString(),
                    item.Denominazione,
                    item.RagioneSociale,
                    item.CodiceFiscale,
                    item.PartitaIVA,
                    item.StatoAttivitaId?.ToString()))
                .ToList(),
                org.TotalCount),
            new SearchGroup<GlobalSearchItem>(
                persone.Items.Select(item => new GlobalSearchItem(
                    item.PersonaId.ToString(),
                    $"{item.Cognome} {item.Nome}",
                    item.DataNascita.ToString("dd/MM/yyyy"),
                    item.CodiceFiscale,
                    null,
                    null))
                .ToList(),
                persone.TotalCount),
            new SearchGroup<GlobalSearchItem>(
                incarichi.Items.Select(item => new GlobalSearchItem(
                    item.IncaricoId.ToString(),
                    $"{item.PersonaCognome} {item.PersonaNome} · {item.Ruolo}",
                    item.OrganizzazioneDenominazione,
                    null,
                    null,
                    item.StatoIncarico))
                .ToList(),
                incarichi.TotalCount));

        return Results.Ok(response);
    })
    .Produces<GlobalSearchResponse>(StatusCodes.Status200OK);

app.UseRateLimiter();

static async Task<PagedResponse<T>> FetchAsync<T>(
    HttpClient client,
    string url,
    int page,
    int pageSize,
    CancellationToken cancellationToken)
{
    var response = await client.GetAsync(url, cancellationToken);
    if (!response.IsSuccessStatusCode)
    {
        return new PagedResponse<T>(Array.Empty<T>(), page, pageSize, 0);
    }

    var data = await response.Content.ReadFromJsonAsync<PagedResponse<T>>(cancellationToken);
    return data ?? new PagedResponse<T>(Array.Empty<T>(), page, pageSize, 0);
}

app.MapReverseProxy();

app.Run();

internal sealed record HealthResponse(string Status);

public partial class Program { }

internal sealed record GlobalSearchResponse(
    string Query,
    SearchGroup<GlobalSearchItem> Organizzazioni,
    SearchGroup<GlobalSearchItem> Persone,
    SearchGroup<GlobalSearchItem> Incarichi);

internal sealed record SearchGroup<T>(IReadOnlyList<T> Items, int TotalCount);

internal sealed record GlobalSearchItem(
    string Id,
    string Title,
    string? Subtitle,
    string? CodiceFiscale,
    string? PartitaIVA,
    string? Status);

internal sealed record PagedResponse<T>(
    IReadOnlyCollection<T> Items,
    int Page,
    int PageSize,
    int TotalCount);

internal sealed record OrganizzazioneSearchItem(
    int OrganizzazioneId,
    string Denominazione,
    string RagioneSociale,
    string? CodiceFiscale,
    string? PartitaIVA,
    byte? StatoAttivitaId);

internal sealed record PersonaSearchItem(
    int PersonaId,
    string Cognome,
    string Nome,
    string? CodiceFiscale,
    DateTime DataNascita);

internal sealed record IncaricoSearchItem(
    int IncaricoId,
    int PersonaId,
    string PersonaCognome,
    string PersonaNome,
    int? OrganizzazioneId,
    string? OrganizzazioneDenominazione,
    string Ruolo,
    string StatoIncarico,
    DateTime DataInizio,
    DateTime? DataFine);
