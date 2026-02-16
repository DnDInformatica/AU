using Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage;

namespace Accredia.SIGAD.Web.Services;

/// <summary>
/// Adapter per ProtectedLocalStorage che implementa IProtectedStorage.
/// 
/// RESPONSABILITÀ:
/// ===============
/// - Wrappa ProtectedLocalStorage dietro l'interfaccia comune IProtectedStorage
/// - Converte ValueTask in Task per uniformità con l'interfaccia
/// - Permette codice generico che funziona sia con Local che Session storage
/// 
/// DIFFERENZA CON SESSION STORAGE:
/// ================================
/// LocalStorage persiste anche dopo chiusura del browser/tab.
/// Usato SOLO se utente seleziona "Ricordami" al login.
/// 
/// PATTERN: Adapter (GoF)
/// THREAD SAFETY: Thread-safe (ProtectedLocalStorage è thread-safe)
/// </summary>
internal sealed class ProtectedLocalStorageAdapter : IProtectedStorage
{
    private readonly ProtectedLocalStorage _storage;

    public ProtectedLocalStorageAdapter(ProtectedLocalStorage storage)
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
