using System.Diagnostics;
using System.Net.Http.Json;
using System.Text;
using System.Threading.RateLimiting;
using Microsoft.AspNetCore.DataProtection;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
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

builder.Services.AddHttpClient("Anagrafiche", client =>
{
    client.BaseAddress = new Uri(anagraficheAddress, UriKind.Absolute);
});

// Authentication & Authorization (Gateway)
var jwtSection = builder.Configuration.GetSection("Jwt");
var jwtIssuer = jwtSection["Issuer"];
var jwtAudience = jwtSection["Audience"];
var jwtKey = jwtSection["Key"];

if (string.IsNullOrWhiteSpace(jwtIssuer) || string.IsNullOrWhiteSpace(jwtAudience) || string.IsNullOrWhiteSpace(jwtKey))
{
    throw new InvalidOperationException("JWT configuration is missing in Gateway.");
}

builder.Services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = jwtIssuer,
            ValidAudience = jwtAudience,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtKey)),
            ClockSkew = TimeSpan.Zero
        };

        // Safe diagnostics: never log the token value. Useful to understand persistent 401s.
        options.Events = new JwtBearerEvents
        {
            OnMessageReceived = context =>
            {
                // Log only presence/shape of Authorization header.
                var loggerFactory = context.HttpContext.RequestServices.GetRequiredService<ILoggerFactory>();
                var logger = loggerFactory.CreateLogger("Gateway.Jwt");

                var hasAuthHeader = context.Request.Headers.TryGetValue(HeaderNames.Authorization, out var authHeader);
                var authHeaderValue = hasAuthHeader ? authHeader.ToString() : string.Empty;
                var hasBearer = authHeaderValue.StartsWith("Bearer ", StringComparison.OrdinalIgnoreCase);
                var tokenLength = hasBearer ? Math.Max(0, authHeaderValue.Length - "Bearer ".Length) : 0;

                logger.LogDebug(
                    "JWT MessageReceived. Path={Path}, HasAuthorization={HasAuthorization}, HasBearer={HasBearer}, TokenLength={TokenLength}",
                    context.HttpContext.Request.Path,
                    hasAuthHeader,
                    hasBearer,
                    tokenLength);

                return Task.CompletedTask;
            },
            OnAuthenticationFailed = context =>
            {
                var loggerFactory = context.HttpContext.RequestServices.GetRequiredService<ILoggerFactory>();
                var logger = loggerFactory.CreateLogger("Gateway.Jwt");

                logger.LogWarning(
                    context.Exception,
                    "JWT AuthenticationFailed. Path={Path}, ErrorType={ErrorType}, Message={Message}",
                    context.HttpContext.Request.Path,
                    context.Exception.GetType().Name,
                    context.Exception.Message);

                return Task.CompletedTask;
            },
            OnChallenge = context =>
            {
                // This fires when a 401 challenge is returned.
                var loggerFactory = context.HttpContext.RequestServices.GetRequiredService<ILoggerFactory>();
                var logger = loggerFactory.CreateLogger("Gateway.Jwt");

                logger.LogInformation(
                    "JWT Challenge. Path={Path}, Error={Error}, Description={Description}",
                    context.HttpContext.Request.Path,
                    context.Error,
                    context.ErrorDescription);

                return Task.CompletedTask;
            },
            OnForbidden = context =>
            {
                var loggerFactory = context.HttpContext.RequestServices.GetRequiredService<ILoggerFactory>();
                var logger = loggerFactory.CreateLogger("Gateway.Jwt");

                logger.LogInformation(
                    "JWT Forbidden. Path={Path}, UserAuthenticated={Authenticated}",
                    context.HttpContext.Request.Path,
                    context.HttpContext.User?.Identity?.IsAuthenticated == true);

                return Task.CompletedTask;
            }
        };
    });

builder.Services.AddAuthorization(options =>
{
    options.AddPolicy("Authenticated", policy => policy.RequireAuthenticatedUser());
    options.AddPolicy("Admin", policy => policy.RequireRole("SIGAD_ADMIN", "SIGAD_SUPERADMIN"));
    options.AddPolicy(
        "PersRead",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireAssertion(context =>
                context.User.HasClaim("perm", "PERS.LIST")
                || context.User.HasClaim("perm", "PERS.READ")));
    options.AddPolicy(
        "PersCreate",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireClaim("perm", "PERS.CREATE"));
    options.AddPolicy(
        "PersUpdate",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireClaim("perm", "PERS.UPDATE"));
    options.AddPolicy(
        "PersDelete",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireClaim("perm", "PERS.DELETE"));
    options.AddPolicy(
        "HrPersonaRead",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireClaim("perm", "HR.PERSONA.READ"));
    options.AddPolicy(
        "HrDipRead",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireAssertion(context =>
                context.User.HasClaim("perm", "HR.DIP.LIST")
                || context.User.HasClaim("perm", "HR.DIP.READ")));
    options.AddPolicy(
        "HrDipCreate",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireClaim("perm", "HR.DIP.CREATE"));
    options.AddPolicy(
        "HrDipUpdate",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireClaim("perm", "HR.DIP.UPDATE"));
    options.AddPolicy(
        "HrDipDelete",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireClaim("perm", "HR.DIP.DELETE"));
    options.AddPolicy(
        "HrContrattiRead",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireAssertion(context =>
                context.User.HasClaim("perm", "HR.CONTRATTI.LIST")
                || context.User.HasClaim("perm", "HR.CONTRATTI.READ")));
    options.AddPolicy(
        "HrContrattiCreate",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireClaim("perm", "HR.CONTRATTI.CREATE"));
    options.AddPolicy(
        "HrContrattiUpdate",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireClaim("perm", "HR.CONTRATTI.UPDATE"));
    options.AddPolicy(
        "HrContrattiDelete",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireClaim("perm", "HR.CONTRATTI.DELETE"));
    options.AddPolicy(
        "HrDotazioniRead",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireAssertion(context =>
                context.User.HasClaim("perm", "HR.DOTAZIONI.LIST")
                || context.User.HasClaim("perm", "HR.DOTAZIONI.READ")));
    options.AddPolicy(
        "HrDotazioniCreate",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireClaim("perm", "HR.DOTAZIONI.CREATE"));
    options.AddPolicy(
        "HrDotazioniUpdate",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireClaim("perm", "HR.DOTAZIONI.UPDATE"));
    options.AddPolicy(
        "HrDotazioniDelete",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireClaim("perm", "HR.DOTAZIONI.DELETE"));
    options.AddPolicy(
        "HrFormRead",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireAssertion(context =>
                context.User.HasClaim("perm", "HR.FORM.LIST")
                || context.User.HasClaim("perm", "HR.FORM.READ")));
    options.AddPolicy(
        "HrFormCreate",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireClaim("perm", "HR.FORM.CREATE"));
    options.AddPolicy(
        "HrFormUpdate",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireClaim("perm", "HR.FORM.UPDATE"));
    options.AddPolicy(
        "HrFormDelete",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireClaim("perm", "HR.FORM.DELETE"));
    options.AddPolicy(
        "HrDipReadPersona",
        policy => policy
            .RequireAuthenticatedUser()
            .RequireAssertion(context =>
                (context.User.HasClaim("perm", "HR.DIP.LIST")
                 || context.User.HasClaim("perm", "HR.DIP.READ"))
                && context.User.HasClaim("perm", "HR.PERSONA.READ")));
});

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
    .RequireAuthorization("Authenticated")
    .Produces<GlobalSearchResponse>(StatusCodes.Status200OK);

app.UseRateLimiter();
app.UseAuthentication();
app.UseAuthorization();

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
