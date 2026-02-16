using Asp.Versioning;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using Microsoft.OpenApi.Models;
using Swashbuckle.AspNetCore.SwaggerGen;

namespace Accredia.SIGAD.Shared.Versioning;

/// <summary>
/// Extension methods for API versioning configuration.
/// </summary>
public static class VersioningExtensions
{
    /// <summary>
    /// Adds SIGAD API versioning services.
    /// </summary>
    public static IServiceCollection AddSigadApiVersioning(this IServiceCollection services)
    {
        services.AddApiVersioning(options =>
        {
            options.DefaultApiVersion = new ApiVersion(1, 0);
            options.AssumeDefaultVersionWhenUnspecified = true;
            options.ReportApiVersions = true;
            options.ApiVersionReader = ApiVersionReader.Combine(
                new UrlSegmentApiVersionReader(),
                new HeaderApiVersionReader("X-Api-Version"));
        })
        .AddApiExplorer(options =>
        {
            options.GroupNameFormat = "'v'VVV";
            options.SubstituteApiVersionInUrl = true;
        });

        return services;
    }

    /// <summary>
    /// Configures Swagger for versioned API documentation.
    /// </summary>
    public static IServiceCollection AddSigadVersionedSwagger(
        this IServiceCollection services,
        string title,
        string description)
    {
        services.AddEndpointsApiExplorer();
        services.AddSwaggerGen(options =>
        {
            // Avoid schemaId collisions across vertical slices that share DTO names (e.g. CreateRequest, UpdateRequest).
            options.CustomSchemaIds(type => type.FullName?.Replace('+', '.') ?? type.Name);

            // Some APIs may intentionally expose multiple endpoints with the same method+path template
            // differentiated only by route constraints (e.g. {id:int} vs {id:guid}). OpenAPI cannot
            // represent these as distinct paths; pick the first one to keep Swagger JSON generation working.
            options.ResolveConflictingActions(apiDescriptions => apiDescriptions.First());

            options.SwaggerDoc("v1", new OpenApiInfo
            {
                Title = $"{title} v1",
                Version = "v1",
                Description = description
            });
        });

        return services;
    }

    /// <summary>
    /// Configures Swagger for versioned API with JWT Bearer authentication.
    /// </summary>
    public static IServiceCollection AddSigadVersionedSwaggerWithAuth(
        this IServiceCollection services,
        string title,
        string description)
    {
        services.AddEndpointsApiExplorer();
        services.AddSwaggerGen(options =>
        {
            // Avoid schemaId collisions across vertical slices that share DTO names (e.g. CreateRequest, UpdateRequest).
            options.CustomSchemaIds(type => type.FullName?.Replace('+', '.') ?? type.Name);

            // Some APIs may intentionally expose multiple endpoints with the same method+path template
            // differentiated only by route constraints (e.g. {id:int} vs {id:guid}). OpenAPI cannot
            // represent these as distinct paths; pick the first one to keep Swagger JSON generation working.
            options.ResolveConflictingActions(apiDescriptions => apiDescriptions.First());

            options.SwaggerDoc("v1", new OpenApiInfo
            {
                Title = $"{title} v1",
                Version = "v1",
                Description = description
            });

            options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
            {
                Description = "JWT Authorization header. Example: \"Bearer {token}\"",
                Name = "Authorization",
                In = ParameterLocation.Header,
                Type = SecuritySchemeType.ApiKey,
                Scheme = "Bearer"
            });

            options.AddSecurityRequirement(new OpenApiSecurityRequirement
            {
                {
                    new OpenApiSecurityScheme
                    {
                        Reference = new OpenApiReference
                        {
                            Type = ReferenceType.SecurityScheme,
                            Id = "Bearer"
                        }
                    },
                    Array.Empty<string>()
                }
            });
        });

        return services;
    }

    /// <summary>
    /// Uses versioned Swagger UI.
    /// </summary>
    public static WebApplication UseSigadVersionedSwagger(this WebApplication app)
    {
        app.UseSwagger();
        app.UseSwaggerUI(options =>
        {
            // Use a relative endpoint so Swagger UI works both directly (/swagger)
            // and behind a gateway with a path prefix (e.g. /anagrafiche/swagger).
            options.SwaggerEndpoint("v1/swagger.json", "API v1");
            options.RoutePrefix = "swagger";
        });

        return app;
    }
}

/// <summary>
/// Helper for creating versioned endpoints.
/// </summary>
public static class VersionedEndpointHelper
{
    public const int MajorVersion = 1;
    public const int MinorVersion = 0;
    public static readonly ApiVersion Version1 = new(MajorVersion, MinorVersion);
    public const string VersionPrefix = "v1";

    /// <summary>
    /// Creates a versioned API group.
    /// </summary>
    public static RouteGroupBuilder MapVersionedApiGroup(
        this IEndpointRouteBuilder app,
        string prefix = "")
    {
        var normalizedPrefix = string.IsNullOrEmpty(prefix)
            ? $"/{VersionPrefix}"
            : $"/{VersionPrefix}/{prefix.TrimStart('/')}";

        return app.MapGroup(normalizedPrefix)
            .HasApiVersion(Version1);
    }

    /// <summary>
    /// Creates a non-versioned API group (for health endpoints, etc.).
    /// </summary>
    public static RouteGroupBuilder MapUnversionedApiGroup(
        this IEndpointRouteBuilder app,
        string prefix = "")
    {
        var normalizedPrefix = string.IsNullOrEmpty(prefix)
            ? ""
            : $"/{prefix.TrimStart('/')}";

        return app.MapGroup(normalizedPrefix);
    }
}
