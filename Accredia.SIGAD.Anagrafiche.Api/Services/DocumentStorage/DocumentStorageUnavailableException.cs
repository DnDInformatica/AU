namespace Accredia.SIGAD.Anagrafiche.Api.Services.DocumentStorage;

internal sealed class DocumentStorageUnavailableException : Exception
{
    public DocumentStorageUnavailableException(string message, int? statusCode = null, Exception? innerException = null)
        : base(message, innerException)
    {
        StatusCode = statusCode;
    }

    public int? StatusCode { get; }
}
