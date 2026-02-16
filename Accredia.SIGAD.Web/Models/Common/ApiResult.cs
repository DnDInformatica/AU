using System.Net;

namespace Accredia.SIGAD.Web.Models.Common;

/// <summary>
/// Rappresenta il risultato di una chiamata API
/// </summary>
public sealed class ApiResult
{
    public bool IsSuccess { get; init; }
    public string? Error { get; init; }
    public HttpStatusCode? StatusCode { get; init; }

    private ApiResult(bool isSuccess, string? error, HttpStatusCode? statusCode)
    {
        IsSuccess = isSuccess;
        Error = error;
        StatusCode = statusCode;
    }

    public static ApiResult Success(HttpStatusCode? statusCode = null)
        => new(true, null, statusCode);

    public static ApiResult Failure(string error, HttpStatusCode? statusCode = null)
        => new(false, error, statusCode);
}

/// <summary>
/// Rappresenta il risultato di una chiamata API con dati
/// </summary>
public sealed class ApiResult<T>
{
    public bool IsSuccess { get; init; }
    public T? Data { get; init; }
    public string? Error { get; init; }
    public HttpStatusCode? StatusCode { get; init; }

    private ApiResult(bool isSuccess, T? data, string? error, HttpStatusCode? statusCode)
    {
        IsSuccess = isSuccess;
        Data = data;
        Error = error;
        StatusCode = statusCode;
    }

    public static ApiResult<T> Success(T data, HttpStatusCode? statusCode = null)
        => new(true, data, null, statusCode);

    public static ApiResult<T> Failure(string error, HttpStatusCode? statusCode = null)
        => new(false, default, error, statusCode);
}
