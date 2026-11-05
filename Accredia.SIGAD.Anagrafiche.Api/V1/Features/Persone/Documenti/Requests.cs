using Microsoft.AspNetCore.Http;

namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Documenti;

internal sealed class UploadRequest
{
    public IFormFile? File { get; init; }
    public string? Note { get; init; }
}
