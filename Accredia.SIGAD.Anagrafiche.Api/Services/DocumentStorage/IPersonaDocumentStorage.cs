namespace Accredia.SIGAD.Anagrafiche.Api.Services.DocumentStorage;

internal interface IPersonaDocumentStorage
{
    Task SaveAsync(string storageKey, byte[] content, CancellationToken cancellationToken);
    Task<byte[]?> TryReadAsync(string storageKey, CancellationToken cancellationToken);
    Task<(bool IsHealthy, string? Detail)> CheckAvailabilityAsync(CancellationToken cancellationToken);
}
