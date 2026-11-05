using System.Net;
using System.Net.Http.Headers;
using System.Text;
using Microsoft.Extensions.Options;

namespace Accredia.SIGAD.Anagrafiche.Api.Services.DocumentStorage;

internal sealed class WebDavPersonaDocumentStorage : IPersonaDocumentStorage
{
    private static readonly HttpMethod MkColMethod = new("MKCOL");

    private readonly HttpClient _httpClient;
    private readonly ILogger<WebDavPersonaDocumentStorage> _logger;
    private readonly Uri _baseUri;
    private readonly string _rootPath;

    public WebDavPersonaDocumentStorage(
        HttpClient httpClient,
        IOptions<PersonaDocumentStorageOptions> options,
        ILogger<WebDavPersonaDocumentStorage> logger)
    {
        _httpClient = httpClient;
        _logger = logger;

        var webDav = options.Value.WebDav;
        if (string.IsNullOrWhiteSpace(webDav.BaseUrl))
        {
            throw new InvalidOperationException("DocumentStorage.WebDav.BaseUrl non configurato.");
        }

        _baseUri = new Uri(EnsureTrailingSlash(webDav.BaseUrl.Trim()), UriKind.Absolute);
        _rootPath = NormalizePathSegment(webDav.RootPath);

        if (string.IsNullOrWhiteSpace(webDav.Username))
        {
            throw new InvalidOperationException("DocumentStorage.WebDav.Username non configurato.");
        }

        var password = ResolvePassword(webDav);
        if (string.IsNullOrWhiteSpace(password))
        {
            throw new InvalidOperationException(
                $"Password WebDav non configurata. Imposta DocumentStorage.WebDav.Password o variabile ambiente {webDav.PasswordEnvVar}.");
        }

        var raw = Encoding.UTF8.GetBytes($"{webDav.Username}:{password}");
        _httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue(
            "Basic",
            Convert.ToBase64String(raw));

        _logger.LogInformation(
            "Persona document storage initialized with WebDav at {WebDavBaseUrl} root {WebDavRootPath} user {WebDavUser}",
            _baseUri,
            _rootPath,
            webDav.Username);
    }

    public async Task SaveAsync(string storageKey, byte[] content, CancellationToken cancellationToken)
    {
        var normalizedKey = NormalizeStorageKey(storageKey);
        var fullPath = CombineRemotePath(_rootPath, normalizedKey);

        await EnsureRemoteDirectoriesAsync(fullPath, cancellationToken);

        try
        {
            using var request = new HttpRequestMessage(HttpMethod.Put, BuildUri(fullPath))
            {
                Content = new ByteArrayContent(content)
            };

            using var response = await _httpClient.SendAsync(request, cancellationToken);
            if (!response.IsSuccessStatusCode)
            {
                var preview = await ReadResponsePreviewAsync(response, cancellationToken);
                _logger.LogWarning(
                    "WebDav PUT failed. Path={WebDavPath} Status={StatusCode} ResponsePreview={ResponsePreview}",
                    fullPath,
                    (int)response.StatusCode,
                    preview);

                throw new DocumentStorageUnavailableException(
                    $"Salvataggio documento WebDav fallito ({(int)response.StatusCode}) su {fullPath}.",
                    (int)response.StatusCode);
            }
        }
        catch (HttpRequestException ex)
        {
            _logger.LogError(ex, "WebDav PUT connection error. Path={WebDavPath}", fullPath);
            throw new DocumentStorageUnavailableException(
                $"Connessione a storage WebDav fallita durante upload su {fullPath}.",
                innerException: ex);
        }
    }

    public async Task<byte[]?> TryReadAsync(string storageKey, CancellationToken cancellationToken)
    {
        var normalizedKey = NormalizeStorageKey(storageKey);
        var fullPath = CombineRemotePath(_rootPath, normalizedKey);

        try
        {
            using var response = await _httpClient.GetAsync(BuildUri(fullPath), cancellationToken);
            if (response.StatusCode == HttpStatusCode.NotFound)
            {
                return null;
            }

            if (!response.IsSuccessStatusCode)
            {
                var preview = await ReadResponsePreviewAsync(response, cancellationToken);
                _logger.LogWarning(
                    "WebDav GET failed. Path={WebDavPath} Status={StatusCode} ResponsePreview={ResponsePreview}",
                    fullPath,
                    (int)response.StatusCode,
                    preview);

                throw new DocumentStorageUnavailableException(
                    $"Lettura documento WebDav fallita ({(int)response.StatusCode}) su {fullPath}.",
                    (int)response.StatusCode);
            }

            return await response.Content.ReadAsByteArrayAsync(cancellationToken);
        }
        catch (HttpRequestException ex)
        {
            _logger.LogError(ex, "WebDav GET connection error. Path={WebDavPath}", fullPath);
            throw new DocumentStorageUnavailableException(
                $"Connessione a storage WebDav fallita durante download da {fullPath}.",
                innerException: ex);
        }
    }

    public async Task<(bool IsHealthy, string? Detail)> CheckAvailabilityAsync(CancellationToken cancellationToken)
    {
        try
        {
            using var request = new HttpRequestMessage(HttpMethod.Options, _baseUri);
            using var response = await _httpClient.SendAsync(request, cancellationToken);

            if (response.IsSuccessStatusCode)
            {
                return (true, null);
            }

            if (response.StatusCode == HttpStatusCode.Unauthorized ||
                response.StatusCode == HttpStatusCode.Forbidden)
            {
                return (false, $"WebDav auth fallita ({(int)response.StatusCode}).");
            }

            if ((int)response.StatusCode >= 500)
            {
                return (false, $"WebDav non disponibile ({(int)response.StatusCode}).");
            }

            return (true, $"WebDav raggiungibile con status {(int)response.StatusCode}.");
        }
        catch (HttpRequestException ex)
        {
            _logger.LogWarning(ex, "WebDav availability check failed");
            return (false, "Connessione WebDav fallita.");
        }
    }

    private async Task EnsureRemoteDirectoriesAsync(string fullFilePath, CancellationToken cancellationToken)
    {
        var slashIndex = fullFilePath.LastIndexOf('/');
        if (slashIndex <= 0)
        {
            return;
        }

        var directoryPath = fullFilePath[..slashIndex];
        var segments = directoryPath.Split('/', StringSplitOptions.RemoveEmptyEntries);
        var currentPath = string.Empty;

        foreach (var segment in segments)
        {
            currentPath = string.IsNullOrEmpty(currentPath) ? segment : $"{currentPath}/{segment}";
            try
            {
                using var request = new HttpRequestMessage(MkColMethod, BuildUri(currentPath));
                using var response = await _httpClient.SendAsync(request, cancellationToken);

                if (response.IsSuccessStatusCode ||
                    response.StatusCode == HttpStatusCode.MethodNotAllowed ||
                    response.StatusCode == HttpStatusCode.Conflict)
                {
                    continue;
                }

                var preview = await ReadResponsePreviewAsync(response, cancellationToken);
                _logger.LogWarning(
                    "WebDav MKCOL failed. Path={WebDavPath} Status={StatusCode} ResponsePreview={ResponsePreview}",
                    currentPath,
                    (int)response.StatusCode,
                    preview);

                throw new DocumentStorageUnavailableException(
                    $"Creazione directory WebDav fallita ({(int)response.StatusCode}) su {currentPath}.",
                    (int)response.StatusCode);
            }
            catch (HttpRequestException ex)
            {
                _logger.LogError(ex, "WebDav MKCOL connection error. Path={WebDavPath}", currentPath);
                throw new DocumentStorageUnavailableException(
                    $"Connessione a storage WebDav fallita durante creazione directory {currentPath}.",
                    innerException: ex);
            }
        }
    }

    private Uri BuildUri(string relativePath)
    {
        return new Uri(_baseUri, relativePath);
    }

    private static string NormalizeStorageKey(string storageKey)
    {
        var normalized = storageKey
            .Replace('\\', '/')
            .Trim('/');

        if (string.IsNullOrWhiteSpace(normalized) ||
            normalized.Contains("..", StringComparison.Ordinal))
        {
            throw new InvalidOperationException("StorageKey non valido.");
        }

        return normalized;
    }

    private static string NormalizePathSegment(string value)
    {
        var normalized = value
            .Replace('\\', '/')
            .Trim('/');

        return string.IsNullOrWhiteSpace(normalized) ? "PersonaDocumenti" : normalized;
    }

    private static string CombineRemotePath(string left, string right)
    {
        if (string.IsNullOrWhiteSpace(left))
        {
            return right.Trim('/');
        }

        return $"{left.TrimEnd('/')}/{right.TrimStart('/')}";
    }

    private static string EnsureTrailingSlash(string url)
    {
        return url.EndsWith("/", StringComparison.Ordinal) ? url : $"{url}/";
    }

    private static async Task<string> ReadResponsePreviewAsync(HttpResponseMessage response, CancellationToken cancellationToken)
    {
        if (response.Content is null)
        {
            return string.Empty;
        }

        var text = await response.Content.ReadAsStringAsync(cancellationToken);
        if (string.IsNullOrWhiteSpace(text))
        {
            return string.Empty;
        }

        const int maxLen = 250;
        var normalized = text.Replace('\r', ' ').Replace('\n', ' ').Trim();
        return normalized.Length <= maxLen ? normalized : normalized[..maxLen];
    }

    private static string? ResolvePassword(PersonaDocumentStorageOptions.WebDavOptions webDav)
    {
        if (!string.IsNullOrWhiteSpace(webDav.Password))
        {
            return webDav.Password.Trim();
        }

        if (!string.IsNullOrWhiteSpace(webDav.PasswordEnvVar))
        {
            return Environment.GetEnvironmentVariable(webDav.PasswordEnvVar.Trim());
        }

        return null;
    }
}
