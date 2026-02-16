using System.Net;

namespace Accredia.SIGAD.Web.Services;

internal sealed record ApiResult(bool IsSuccess, string? Error, HttpStatusCode? StatusCode)
{
    public static ApiResult Success(HttpStatusCode statusCode) => new(true, null, statusCode);

    public static ApiResult Failure(string? error, HttpStatusCode? statusCode) => new(false, error, statusCode);
}

internal sealed record ApiResult<T>(bool IsSuccess, T? Data, string? Error, HttpStatusCode? StatusCode)
{
    public static ApiResult<T> Success(T data, HttpStatusCode statusCode) => new(true, data, null, statusCode);

    public static ApiResult<T> Failure(string? error, HttpStatusCode? statusCode) => new(false, default, error, statusCode);
}
