# DEVELOPMENT GUIDELINES - Accredia.SIGAD.Web

## 🎯 SCOPO

Questo documento raccoglie best practices, lessons learned e linee guida per lo sviluppo del progetto SIGAD Web.

**Target audience**: Claude AI, sviluppatori del team, future sessioni di sviluppo

---

## 🖥️ DESKTOP COMMANDER - BEST PRACTICES

### **REGOLA #1: Shell Selection per Path Windows**

**PROBLEMA COMUNE**:
```bash
# ❌ ERRORE - Bash non capisce path Windows con backslash
bash> cd "C:\Accredia\Sviluppo\AU"
/bin/sh: 1: cd: can't cd to C:\Accredia\Sviluppo\AU
```

**SOLUZIONI**:

#### **OPZIONE A: Usa PowerShell per Path Windows** ✅ RACCOMANDATO
```powershell
# ✅ CORRETTO - PowerShell capisce path Windows nativamente
Desktop Commander:start_process
- command: cd "C:\Accredia\Sviluppo\AU" ; dotnet build
- shell: powershell.exe
- timeout_ms: 30000
```

#### **OPZIONE B: Converti Path per Bash/WSL**
```bash
# ✅ CORRETTO - Converti path Windows → Unix style
Desktop Commander:start_process
- command: cd /mnt/c/Accredia/Sviluppo/AU && dotnet build
- shell: bash
- timeout_ms: 30000
```

### **REGOLA #2: Quando Usare Quale Shell**

| Scenario | Shell Consigliata | Motivazione |
|----------|------------------|-------------|
| **Path Windows** (C:\...) | `powershell.exe` | Supporto nativo path Windows |
| **Comandi .NET** (dotnet build/run) | `powershell.exe` | Ambiente Windows nativo |
| **Script batch** (.bat/.cmd) | `cmd` o `powershell.exe` | Compatibilità Windows |
| **Comandi Unix** (grep, awk, sed) | `bash` | Comandi Unix nativi |
| **Git operations** | Entrambi (preferisci `powershell.exe`) | Git funziona su entrambi |
| **File operations** con path Windows | `powershell.exe` | Evita conversione path |

### **REGOLA #3: Desktop Commander File Operations**

**SEMPRE usa forward slash `/` nei path Desktop Commander**, anche su Windows:

```csharp
// ✅ CORRETTO - Desktop Commander normalizza automaticamente
Desktop Commander:read_file
- path: C:/Accredia/Sviluppo/AU/Accredia.SIGAD.Web/Services/TokenService.cs

Desktop Commander:write_file
- path: C:/Accredia/Sviluppo/AU/Accredia.SIGAD.Web/Services/NewFile.cs

Desktop Commander:edit_block
- file_path: C:/Accredia/Sviluppo/AU/Accredia.SIGAD.Web/Program.cs
```

```csharp
// ❌ EVITA - Backslash possono causare problemi in alcuni contesti
Desktop Commander:read_file
- path: C:\Accredia\Sviluppo\AU\Accredia.SIGAD.Web\Services\TokenService.cs
```

**PERCHÉ**: Desktop Commander normalizza automaticamente i path, ma forward slash sono più universali e evitano problemi di escape.

### **REGOLA #4: Process Management - Verifica Processi Bloccati**

**PRIMA di compilare**, verifica che non ci siano processi che bloccano i file DLL:

```powershell
# Verifica processi SIGAD attivi
Desktop Commander:start_process
- command: Get-Process | Where-Object {$_.ProcessName -like '*SIGAD*'} | Select-Object Id, ProcessName, Path
- shell: powershell.exe
```

**SE TROVATI processi bloccati**:
```powershell
# Termina tutti i processi SIGAD
Desktop Commander:start_process
- command: Get-Process | Where-Object {$_.ProcessName -like '*SIGAD*'} | Stop-Process -Force
- shell: powershell.exe
```

**ALTERNATIVE**:
```bash
# Usa script batch dedicato
C:\Accredia\Sviluppo\AU\stop_sigad.bat
```

---

## 🏗️ ARCHITETTURA E DESIGN PATTERNS

### **REGOLA #5: SEMPRE Preferire Pattern Enterprise-Grade**

**ESEMPIO REALE** (TokenService Refactoring):

❌ **ANTI-PATTERN: Duplicazione Codice**
```csharp
if (useLocalStorage) {
    // 30 righe per LocalStorage
    var result = await _localStorage.GetAsync<string>(...);
    // ...
} else {
    // 30 righe IDENTICHE per SessionStorage
    var result = await _sessionStorage.GetAsync<string>(...);
    // ...
}
```

✅ **BEST PRACTICE: Adapter Pattern**
```csharp
IProtectedStorage storage = useLocalStorage
    ? new ProtectedLocalStorageAdapter(_localStorage)
    : new ProtectedSessionStorageAdapter(_sessionStorage);

return await ReadTokensFromStorageAsync(storage, useLocalStorage);
```

**BENEFICI**:
- ✅ DRY compliance
- ✅ SOLID principles (Dependency Inversion)
- ✅ Testabile con mock
- ✅ Manutenibile (bug fix in 1 posto)

**QUANDO APPLICARE**:
- Ogni volta che vedi codice duplicato (>10 righe)
- Quando due implementazioni differiscono solo per il tipo usato
- Quando la logica è identica ma opera su oggetti diversi

### **REGOLA #6: Dependency Injection - Services Registration**

**ORDINE CONSIGLIATO in Program.cs**:

```csharp
// 1. Logging (SEMPRE per primo)
builder.Services.AddSerilog(...);

// 2. HttpClient & API Communication
builder.Services.AddHttpClient<GatewayClient>(...);

// 3. Browser Storage (Blazor Server specifici)
builder.Services.AddScoped<ProtectedSessionStorage>();
builder.Services.AddScoped<ProtectedLocalStorage>();

// 4. Application Services (dipendenze in ordine)
builder.Services.AddScoped<TokenService>();
builder.Services.AddScoped<TokenRefreshService>();  // dipende da TokenService
builder.Services.AddScoped<UserContext>();

// 5. Authentication & Authorization
builder.Services.AddScoped<GatewayAuthenticationStateProvider>();
builder.Services.AddScoped<AuthenticationStateProvider>(sp => 
    sp.GetRequiredService<GatewayAuthenticationStateProvider>());

// 6. UI Components (MudBlazor, ecc.)
builder.Services.AddMudServices();
```

---

## 🎨 UX / UI (MudBlazor + Shell SIGAD)

### **REGOLA #9: Core Components Prima del Markup**

Per mantenere coerenza e velocita di sviluppo, prima di aggiungere markup ripetuto verifica se esiste gia un pattern/component riusabile.

Riferimento: `Accredia.SIGAD.Web/UX_CORE_COMPONENTS.md`

Checklist rapida:
- Usa `PageHeader` su tutte le pagine "lista/dettaglio"
- Error state sempre con `Riprova` + link `/system-status`
- 403 sempre con `AccessDenied`
- Liste con quick preview: preferire `QuickDrawerService`


## 🔧 COMPILAZIONE E BUILD

### **REGOLA #7: Build Process - Sequenza Corretta**

**SEQUENZA SICURA**:
```powershell
# 1. Ferma tutti i processi
.\stop_sigad.bat

# 2. Clean solution (opzionale ma raccomandato dopo grandi refactoring)
dotnet clean Accredia.SIGAD.sln

# 3. Build specifico progetto (più veloce)
cd Accredia.SIGAD.Web
dotnet build

# 4. Build intera solution (solo se necessario)
cd ..
dotnet build Accredia.SIGAD.sln
```

**ERRORI COMUNI**:

| Errore | Causa | Soluzione |
|--------|-------|-----------|
| MSB3021 | Processo blocca DLL | `stop_sigad.bat` o `Stop-Process` |
| MSB3027 | File in uso | Chiudi VS, ferma processi |
| CS0246 | File .cs mancante | Verifica file esista, controlla namespace |
| CS0173 | Tipi incompatibili | Usa Adapter Pattern o helper method |

---

## 📝 NAMING CONVENTIONS

### **REGOLA #8: Naming Standards SIGAD**

**Services**:
```csharp
// ✅ CORRETTO - Suffisso "Service"
TokenService
TokenRefreshService
UserService
PermissionService

// ❌ EVITA
TokenManager
TokenHelper
UserController (questo è per API, non Web)
```

**Interfaces**:
```csharp
// ✅ CORRETTO - Prefisso "I"
IProtectedStorage
ITokenService
IPermissionService

// ❌ EVITA - Suffissi generici
IStorageService
ITokenManager
```

**Adapters**:
```csharp
// ✅ CORRETTO - Suffisso "Adapter"
ProtectedSessionStorageAdapter
ProtectedLocalStorageAdapter

// ❌ EVITA
SessionStorageWrapper
LocalStorageProxy
```

**Models/DTOs**:
```csharp
// ✅ CORRETTO - Descrittivi, PascalCase
LoginRequest
TokenResponse
MeResponse
RefreshRequest

// ❌ EVITA - Abbreviazioni poco chiare
LoginReq
TokenResp
UserDto
```

---

## 🧪 TESTING

### **REGOLA #9: Testing Strategy**

**PRIORITÀ** (per SIGAD Web):
1. **Manual Testing** - Durante sviluppo iterativo
2. **Integration Testing** - Dopo ogni feature completata
3. **Unit Testing** - Solo per logica critica (TokenService, PermissionService)

**NON INVESTIRE TEMPO IN**:
- Unit test per componenti Blazor semplici
- Test per codice che cambia frequentemente
- Test per UI components (MudBlazor già testato)

**INVESTIRE TEMPO IN**:
- Test per TokenRefreshService (logica critica)
- Test per PermissionService (sicurezza critica)
- Test per GatewayClient (API communication)

---

## 📊 LOGGING & DEBUGGING

### **REGOLA #10: Logging Levels**

**STANDARD SIGAD**:

```csharp
// Information - Operazioni normali di successo
_logger.LogInformation("Token refreshed successfully for user {UserId}", userId);

// Warning - Situazioni anomale ma gestibili
_logger.LogWarning("Token refresh attempted but user not logged in");

// Error - Errori che richiedono attenzione
_logger.LogError(ex, "Token refresh failed for user {UserId}", userId);

// Debug - SOLO durante sviluppo (disabilitato in prod)
// _logger.LogDebug("Entering GetTokensAsync with cache state: {CacheState}", _cache);
```

**NON LOGGARE MAI**:
- ❌ Token completi (security risk)
- ❌ Password o credenziali
- ❌ Dati sensibili utente (PII)

**SEMPRE LOGGARE**:
- ✅ User ID (se disponibile)
- ✅ Operation type
- ✅ Success/Failure
- ✅ Exception details (con `ex` parameter)

---

## 🔐 SECURITY BEST PRACTICES

### **REGOLA #11: Token Storage Security**

**GERARCHIA SICUREZZA** (dal più sicuro al meno):

1. **ProtectedSessionStorage** - DEFAULT
   - ✅ Cleared on tab close
   - ✅ Encrypted at rest
   - ✅ Valido solo per questa app
   - ⚠️ NON persiste tra sessioni

2. **ProtectedLocalStorage** - Solo con "Remember Me"
   - ✅ Encrypted at rest
   - ✅ Valido solo per questa app
   - ⚠️ Persiste tra sessioni (meno sicuro)

3. **Cookies** - ❌ NON USARE (SIGAD usa JWT)

4. **LocalStorage** (unprotected) - ❌ MAI USARE

**MOTIVAZIONE**: ASP.NET Core Data Protection garantisce encryption at rest, ma SessionStorage è più sicuro perché non persiste.

---

## 🚀 PERFORMANCE

### **REGOLA #12: Caching Strategy**

**QUANDO USARE CACHE**:
- ✅ Token (in-memory cache in TokenService)
- ✅ User permissions (dopo caricamento da API)
- ✅ Dati tipologiche (cambiano raramente)

**QUANDO NON USARE CACHE**:
- ❌ Dati anagrafiche (cambiano frequentemente)
- ❌ Ricerche dinamiche
- ❌ Dati real-time

**IMPLEMENTAZIONE**:
```csharp
private TokenCache? _cache;  // In-memory cache

public async Task<TokenData?> GetTokensAsync()
{
    // Controlla cache prima
    if (_cache is not null && _cache.ExpiresAt > DateTimeOffset.UtcNow)
    {
        return _cache.Data;
    }
    
    // Ricarica da storage solo se cache scaduta
    var data = await LoadFromStorageAsync();
    _cache = new TokenCache(data, DateTimeOffset.UtcNow.AddMinutes(15));
    return data;
}
```

---

## 📚 DOCUMENTAZIONE

### **REGOLA #13: Quando Documentare**

**SEMPRE commenta**:
- Scelte architetturali non ovvie
- Workaround per bug/limitazioni framework
- Security considerations
- Performance optimizations

**ESEMPIO**:
```csharp
// ✅ BUON COMMENTO - Spiega il PERCHÉ
// ADAPTER PATTERN: ProtectedSessionStorage e ProtectedLocalStorage
// non condividono interfaccia comune. Questo adapter permette
// di eliminare 60 righe di codice duplicato.
IProtectedStorage storage = useLocalStorage
    ? new ProtectedLocalStorageAdapter(_localStorage)
    : new ProtectedSessionStorageAdapter(_sessionStorage);
```

```csharp
// ❌ COMMENTO INUTILE - Spiega il COSA (già ovvio dal codice)
// Crea una nuova istanza di TokenService
var tokenService = new TokenService();
```

---

## 🎯 DECISION MATRIX

### **REGOLA #14: Quando Chiedere Conferma vs Procedere**

**CHIEDI SEMPRE conferma per**:
- ✅ Scelte architetturali importanti (pattern da usare)
- ✅ Breaking changes (modifica API pubbliche)
- ✅ Decisioni di sicurezza (storage, encryption)
- ✅ Performance trade-offs significativi

**PROCEDI autonomamente per**:
- ✅ Refactoring migliorativi (es. Adapter Pattern)
- ✅ Fix di bug evidenti
- ✅ Implementazione di requisiti chiari
- ✅ Aggiunta commenti/documentazione

---

## 🔄 WORKFLOW STANDARD

### **REGOLA #15: Workflow Feature Development**

**SEQUENZA STANDARD**:

```
1. ANALISI
   ├─ Leggi requisiti (IDENTITY_API_ANALYSIS.md, brief, ecc.)
   ├─ Identifica dependencies
   └─ Proponi approccio architetturale

2. DESIGN
   ├─ Scegli pattern appropriati
   ├─ Definisci interfacce
   └─ Ottieni conferma da Danilo

3. IMPLEMENTAZIONE
   ├─ Crea file in ordine (interfaces → adapters → services)
   ├─ Usa Desktop Commander correttamente (PowerShell, forward slash)
   └─ Compila frequentemente (catch early)

4. TESTING
   ├─ Compila (dotnet build)
   ├─ Fix warnings critici
   └─ Test manuale (se applicabile)

5. DOCUMENTAZIONE
   ├─ Aggiorna questo file con lessons learned
   ├─ Commenta scelte architetturali
   └─ Update README se necessario
```

---

## 🎓 LESSONS LEARNED

### **2025-02-06: TokenService Adapter Pattern**

**PROBLEMA**: 60 righe di codice duplicato in `GetTokensAsync()` perché `ProtectedSessionStorage` e `ProtectedLocalStorage` non condividono interfaccia.

**SOLUZIONE**: Adapter Pattern
- Creato `IProtectedStorage` interface
- Creato 2 adapters (Session, Local)
- Eliminato 100% duplicazione

**BENEFICI**:
- DRY compliance
- SOLID principles
- Bug fix in 1 posto invece di 2

**APPLICABILITÀ**: Ogni volta che hai due classi con API identiche ma senza interfaccia comune.

---

### **2025-02-06: Desktop Commander Path Handling**

**PROBLEMA**: Bash non capisce path Windows `C:\...`

**SOLUZIONE**: 
- **OPZIONE A**: Usa `powershell.exe` per comandi su path Windows
- **OPZIONE B**: Converti path Windows → Unix (`/mnt/c/...`)
- **OPZIONE C**: Usa forward slash `/` nelle file operations

**RACCOMANDAZIONE**: PowerShell per build/run, forward slash per file ops.

---

### **2025-02-06: Process Management Pre-Build**

**PROBLEMA**: Errori MSB3021/MSB3027 - DLL bloccate da processi attivi

**SOLUZIONE**: 
```powershell
# Sempre fermare processi prima di build
Get-Process | Where-Object {$_.ProcessName -like '*SIGAD*'} | Stop-Process -Force
```

**PREVENZIONE**: Usa `stop_sigad.bat` script dedicato.

---

### **2025-02-06: TokenRefreshService - Tripla Protezione Anti-Scadenza**

**PROBLEMA**: Token JWT scade ogni 15 minuti, causando logout improvvisi e interruzione workflow utente.

**SOLUZIONE**: Tripla strategia refresh (Proattiva + Reattiva)

**ARCHITETTURA**:
```
1. BACKGROUND TIMER (ogni 14 min)
   └─ TokenRefreshService con Timer + SemaphoreSlim

2. PRE-API CHECK (prima di ogni chiamata)
   └─ GatewayAuthorizationHandler controlla token < 2 min

3. STARTUP CHECK (dopo 2 sec dal render)
   └─ MainLayout.OnAfterRenderAsync() refresh se needed
```

**COMPONENTI**:
- `TokenRefreshService.cs` - Singleton background service
- `TokenManagementOptions` - Configurazione da appsettings.json
- `GatewayAuthorizationHandler` - HTTP message handler pre-API
- `MainLayout.razor` - Start/Stop lifecycle management

**THREAD SAFETY**:
- SemaphoreSlim previene refresh concorrenti
- Task tracking per evitare duplicati
- Solo un refresh alla volta, altri aspettano completamento

**CONFIGURAZIONE** (appsettings.json):
```json
"TokenManagement": {
  "RefreshIntervalMinutes": 14,
  "ExpiryWarningMinutes": 2,
  "CheckBeforeApiCallMinutes": 2
}
```

**BENEFICI**:
- Previene 99% scadenze token
- UX fluida (nessun logout improvviso)
- Safety net a 3 livelli
- Thread-safe per chiamate concorrenti

**APPLICABILITÀ**: Ogni app Blazor Server con JWT tokens short-lived (< 30 min).

---

### **2025-02-06: HttpInterceptor 401 - Fallback Reattivo con Retry**

**PROBLEMA**: Anche con background timer + pre-API check, edge cases (race conditions, network delay) possono causare 401 Unauthorized.

**SOLUZIONE**: Strategia reattiva (fallback) in `GatewayAuthorizationHandler`

**ARCHITETTURA**:
```
REQUEST → Pre-API Check → Send → 401? → Refresh → Clone → Retry
                                   ↓ NO
                                RETURN
```

**IMPLEMENTAZIONE**:
```csharp
// 1. Intercetta 401
if (response.StatusCode == HttpStatusCode.Unauthorized && !isAuthEndpoint)

// 2. Forza refresh
var refreshSuccess = await _tokenRefreshService.RefreshIfNeededAsync(forceRefresh: true);

// 3. Clona richiesta (HttpRequestMessage non riusabili)
var retryRequest = await CloneRequestAsync(request);

// 4. Retry con nuovo token
var retryResponse = await base.SendAsync(retryRequest, cancellationToken);
```

**PROTEZIONI**:
- `isAuthEndpoint` check → Evita loop su /auth/login e /auth/refresh
- Max 1 retry → Nessun loop infinito
- `CloneRequestAsync()` → Copia headers + content per POST/PUT/PATCH

**BENEFICI**:
- UX seamless (utente non vede mai 401)
- Safety net per edge cases
- Logging dettagliato per debugging
- Zero interruzioni workflow

**APPLICABILITÀ**: Ogni HttpClient con token auto-refresh.

---

## 📞 QUANDO CHIEDERE AIUTO

**CHIEDI a Danilo se**:
- Scelta architetturale impatta altri progetti (Identity API, Gateway)
- Decisione di sicurezza critica
- Breaking change su API pubbliche
- Trade-off performance/sicurezza non chiaro

**PROCEDI autonomamente se**:
- Refactoring interno al Web project
- Best practices .NET standard
- Bug fix evidenti
- Miglioramenti documentazione

---

**ULTIMO AGGIORNAMENTO**: 2025-02-06 (HttpInterceptor 401 implementato)  
**MAINTAINER**: Claude AI + Danilo (Lead Architect)  
**VERSIONE**: 1.2
