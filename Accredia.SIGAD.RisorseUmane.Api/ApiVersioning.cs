using Asp.Versioning;
using Asp.Versioning.Builder;

namespace Accredia.SIGAD.RisorseUmane.Api;

internal static class ApiVersioning
{
    public const string DefaultVersion = "v1";
    public static readonly ApiVersion Version1 = new(1, 0);

    public static void MapVersionedGet(
        IEndpointRouteBuilder app,
        string pattern,
        string name,
        Delegate handler,
        Action<RouteHandlerBuilder>? configure = null)
    {
        var normalized = NormalizePattern(pattern);

        // Asp.Versioning.Http requires endpoints to be associated with a version set.
        // NewVersionedApi creates a versioned route builder that satisfies that requirement.
        var v1 = app.NewVersionedApi().MapGet($"/{DefaultVersion}{normalized}", handler)
            .WithName(name)
            .HasApiVersion(Version1);

        configure?.Invoke(v1);
    }

    public static void MapVersionedPost(
        IEndpointRouteBuilder app,
        string pattern,
        string name,
        Delegate handler,
        Action<RouteHandlerBuilder>? configure = null)
    {
        var normalized = NormalizePattern(pattern);

        var v1 = app.NewVersionedApi().MapPost($"/{DefaultVersion}{normalized}", handler)
            .WithName(name)
            .HasApiVersion(Version1);

        configure?.Invoke(v1);
    }

    public static void MapVersionedPut(
        IEndpointRouteBuilder app,
        string pattern,
        string name,
        Delegate handler,
        Action<RouteHandlerBuilder>? configure = null)
    {
        var normalized = NormalizePattern(pattern);

        var v1 = app.NewVersionedApi().MapPut($"/{DefaultVersion}{normalized}", handler)
            .WithName(name)
            .HasApiVersion(Version1);

        configure?.Invoke(v1);
    }

    public static void MapVersionedDelete(
        IEndpointRouteBuilder app,
        string pattern,
        string name,
        Delegate handler,
        Action<RouteHandlerBuilder>? configure = null)
    {
        var normalized = NormalizePattern(pattern);

        var v1 = app.NewVersionedApi().MapDelete($"/{DefaultVersion}{normalized}", handler)
            .WithName(name)
            .HasApiVersion(Version1);

        configure?.Invoke(v1);
    }

    private static string NormalizePattern(string pattern) =>
        pattern.StartsWith('/') ? pattern : $"/{pattern}";
}

