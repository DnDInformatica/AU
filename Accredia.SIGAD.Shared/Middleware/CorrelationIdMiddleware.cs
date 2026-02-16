using System.Diagnostics;
using Microsoft.AspNetCore.Http;
using Serilog.Context;

namespace Accredia.SIGAD.Shared.Middleware;

/// <summary>
/// Middleware per la gestione del CorrelationId e TraceId.
/// Propaga il CorrelationId dal header X-Correlation-Id o ne genera uno nuovo.
/// Arricchisce il LogContext di Serilog con CorrelationId e TraceId.
/// </summary>
public sealed class CorrelationIdMiddleware
{
    public const string CorrelationIdHeader = "X-Correlation-Id";
    private readonly RequestDelegate _next;

    public CorrelationIdMiddleware(RequestDelegate next)
    {
        _next = next;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        var correlationId = context.Request.Headers[CorrelationIdHeader].FirstOrDefault();
        if (string.IsNullOrWhiteSpace(correlationId))
        {
            correlationId = Guid.NewGuid().ToString("N");
        }

        context.Request.Headers[CorrelationIdHeader] = correlationId;
        var traceId = Activity.Current?.TraceId.ToString() ?? context.TraceIdentifier;
        context.Response.Headers[CorrelationIdHeader] = correlationId;

        context.Items["CorrelationId"] = correlationId;
        context.Items["TraceId"] = traceId;

        using (LogContext.PushProperty("CorrelationId", correlationId))
        using (LogContext.PushProperty("TraceId", traceId))
        {
            await _next(context);
        }
    }
}
