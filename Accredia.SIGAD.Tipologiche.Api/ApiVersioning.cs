using Asp.Versioning;
using Asp.Versioning.Builder;

namespace Accredia.SIGAD.Tipologiche.Api;

internal static class ApiVersioning
{
    public const string DefaultVersion = "v1";
    public static readonly ApiVersion Version1 = new(1, 0);

    private static ApiVersionSet CreateVersionSet(IEndpointRouteBuilder app) =>
        app.NewApiVersionSet()
            .HasApiVersion(Version1)
            .ReportApiVersions()
            .Build();

    public static void MapVersionedGet(
        IEndpointRouteBuilder app,
        string pattern,
        string name,
        Delegate handler,
        Action<RouteHandlerBuilder>? configure = null)
    {
        var normalized = NormalizePattern(pattern);
        var versionSet = CreateVersionSet(app);

        var v1 = app.MapGet($"/{DefaultVersion}{normalized}", handler)
            .WithName(name)
            .WithApiVersionSet(versionSet)
            .MapToApiVersion(Version1);

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
        var versionSet = CreateVersionSet(app);

        var v1 = app.MapPost($"/{DefaultVersion}{normalized}", handler)
            .WithName(name)
            .WithApiVersionSet(versionSet)
            .MapToApiVersion(Version1);

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
        var versionSet = CreateVersionSet(app);

        var v1 = app.MapPut($"/{DefaultVersion}{normalized}", handler)
            .WithName(name)
            .WithApiVersionSet(versionSet)
            .MapToApiVersion(Version1);

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
        var versionSet = CreateVersionSet(app);

        var v1 = app.MapDelete($"/{DefaultVersion}{normalized}", handler)
            .WithName(name)
            .WithApiVersionSet(versionSet)
            .MapToApiVersion(Version1);

        configure?.Invoke(v1);
    }

    public static void MapVersionedPatch(
        IEndpointRouteBuilder app,
        string pattern,
        string name,
        Delegate handler,
        Action<RouteHandlerBuilder>? configure = null)
    {
        var normalized = NormalizePattern(pattern);
        var versionSet = CreateVersionSet(app);

        var v1 = app.MapPatch($"/{DefaultVersion}{normalized}", handler)
            .WithName(name)
            .WithApiVersionSet(versionSet)
            .MapToApiVersion(Version1);

        configure?.Invoke(v1);
    }

    private static string NormalizePattern(string pattern) =>
        pattern.StartsWith('/') ? pattern : $"/{pattern}";
}
