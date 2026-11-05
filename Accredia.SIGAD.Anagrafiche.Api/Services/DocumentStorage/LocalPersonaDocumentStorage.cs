using Microsoft.Extensions.Options;

namespace Accredia.SIGAD.Anagrafiche.Api.Services.DocumentStorage;

internal sealed class LocalPersonaDocumentStorage : IPersonaDocumentStorage
{
    private readonly string _rootPath;
    private readonly ILogger<LocalPersonaDocumentStorage> _logger;

    public LocalPersonaDocumentStorage(
        IOptions<PersonaDocumentStorageOptions> options,
        IHostEnvironment hostEnvironment,
        ILogger<LocalPersonaDocumentStorage> logger)
    {
        _logger = logger;

        var configured = options.Value.BasePath?.Trim();
        if (string.IsNullOrWhiteSpace(configured))
        {
            configured = "App_Data/PersonaDocumenti";
        }

        _rootPath = Path.IsPathRooted(configured)
            ? configured
            : Path.GetFullPath(Path.Combine(hostEnvironment.ContentRootPath, configured));

        Directory.CreateDirectory(_rootPath);
        _logger.LogInformation("Persona document storage initialized at {StorageRoot}", _rootPath);
    }

    public async Task SaveAsync(string storageKey, byte[] content, CancellationToken cancellationToken)
    {
        var path = ResolvePath(storageKey);
        var dir = Path.GetDirectoryName(path);
        if (!string.IsNullOrWhiteSpace(dir))
        {
            Directory.CreateDirectory(dir);
        }

        await File.WriteAllBytesAsync(path, content, cancellationToken);
    }

    public async Task<byte[]?> TryReadAsync(string storageKey, CancellationToken cancellationToken)
    {
        var path = ResolvePath(storageKey);
        if (!File.Exists(path))
        {
            return null;
        }

        return await File.ReadAllBytesAsync(path, cancellationToken);
    }

    public Task<(bool IsHealthy, string? Detail)> CheckAvailabilityAsync(CancellationToken cancellationToken)
    {
        if (!Directory.Exists(_rootPath))
        {
            return Task.FromResult<(bool, string?)>((false, $"Storage root non trovato: {_rootPath}"));
        }

        return Task.FromResult<(bool, string?)>((true, null));
    }

    private string ResolvePath(string storageKey)
    {
        var normalized = storageKey
            .Replace('\\', Path.DirectorySeparatorChar)
            .Replace('/', Path.DirectorySeparatorChar)
            .TrimStart(Path.DirectorySeparatorChar);

        var fullPath = Path.GetFullPath(Path.Combine(_rootPath, normalized));
        if (!fullPath.StartsWith(_rootPath, StringComparison.OrdinalIgnoreCase))
        {
            throw new InvalidOperationException("StorageKey non valido.");
        }

        return fullPath;
    }
}
