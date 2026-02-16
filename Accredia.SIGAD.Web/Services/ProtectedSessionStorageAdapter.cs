using Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage;

namespace Accredia.SIGAD.Web.Services;

/// <summary>
/// Adapter per ProtectedSessionStorage che implementa IProtectedStorage.
/// 
/// RESPONSABILITÀ:
/// ===============
/// - Wrappa ProtectedSessionStorage dietro l'interfaccia comune IProtectedStorage
/// - Converte ValueTask in Task per uniformità con l'interfaccia
/// - Permette codice generico che funziona sia con Session che Local storage
/// 
/// PATTERN: Adapter (GoF)
/// THREAD SAFETY: Thread-safe (ProtectedSessionStorage è thread-safe)
/// </summary>
internal sealed class ProtectedSessionStorageAdapter : IProtectedStorage
{
    private readonly ProtectedSessionStorage _storage;

    public ProtectedSessionStorageAdapter(ProtectedSessionStorage storage)
    {
        _storage = storage ?? throw new ArgumentNullException(nameof(storage));
    }

    public Task<ProtectedBrowserStorageResult<T>> GetAsync<T>(string key)
        => _storage.GetAsync<T>(key).AsTask();

    public Task SetAsync(string key, object value)
        => _storage.SetAsync(key, value).AsTask();

    public Task DeleteAsync(string key)
        => _storage.DeleteAsync(key).AsTask();
}
