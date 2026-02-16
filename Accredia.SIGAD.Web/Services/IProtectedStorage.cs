using Microsoft.AspNetCore.Components.Server.ProtectedBrowserStorage;

namespace Accredia.SIGAD.Web.Services;

/// <summary>
/// Interfaccia comune per ProtectedSessionStorage e ProtectedLocalStorage.
/// 
/// MOTIVAZIONE (Adapter Pattern):
/// ================================
/// ProtectedSessionStorage e ProtectedLocalStorage non condividono un'interfaccia comune,
/// rendendo impossibile scrivere codice generico per entrambi.
/// 
/// Questa interfaccia risolve il problema creando un'astrazione unificata che:
/// - Elimina duplicazione di codice (DRY principle)
/// - Permette polimorfismo per scegliere lo storage a runtime
/// - Facilita testing con mock dell'interfaccia
/// - Segue SOLID principles (Dependency Inversion Principle)
/// </summary>
internal interface IProtectedStorage
{
    /// <summary>
    /// Recupera un valore dallo storage protetto
    /// </summary>
    Task<ProtectedBrowserStorageResult<T>> GetAsync<T>(string key);
    
    /// <summary>
    /// Salva un valore nello storage protetto
    /// </summary>
    Task SetAsync(string key, object value);
    
    /// <summary>
    /// Rimuove un valore dallo storage protetto
    /// </summary>
    Task DeleteAsync(string key);
}
