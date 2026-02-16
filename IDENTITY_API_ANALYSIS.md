# ANALISI: Identity API - Funzionalità per il Web (Accredia.SIGAD.Web)

**Data Analisi**: 2026-02-06  
**Analista**: Claude  
**Scope**: Identificare tutte le funzionalità Identity API e mapping con componenti Web mancanti

---

## 📊 EXECUTIVE SUMMARY

L'**Identity API** espone 7 feature principali con **13 endpoint** dedicati all'autenticazione, autorizzazione e gestione utenti/ruoli/permessi.

**Situazione Attuale Web**: ❌ **INCOMPLETO**
- ✅ Login basic (presumibilmente)
- ❌ Mancano molte funzionalità critiche per la gestione amministrativa

**Gap Identificati**: 7 funzionalità critiche non descritte nel brief originale

---

## 🔐 ENDPOINT IDENTITY API (COMPLETO)

### Feature 1: AUTH ENDPOINTS (6 endpoint)

#### 1.1 Login
```
POST /auth/login
Payload: { username, password }
Response: { accessToken, refreshToken, expiresInSeconds }
Rate Limit: 10 richieste/minuto per IP
```
**Cosa serve in Web**:
- ✅ Login Form (probabilmente già existe)
- 📍 Token storage (localStorage/sessionStorage + secure cookie)
- 📍 Error handling: invalid credentials
- 📍 Loading state durante autenticazione

#### 1.2 Logout
```
POST /auth/logout
Authorization: Bearer token
```
**Cosa serve in Web**:
- 📍 Logout button in menu/header
- 📍 Clear token da storage
- 📍 Redirect a login page
- 📍 Clear cache/state

#### 1.3 LogoutAll
```
POST /auth/logout-all
Authorization: Bearer token
```
**Cosa serve in Web**:
- 📍 "Logout da tutti i dispositivi" nel profilo utente
- 📍 Confirmation dialog
- 📍 Session termination per tutti i browser

#### 1.4 LogoutUser  
```
POST /auth/logout-user/{userId}
Authorization: Bearer token (require Admin role)
```
**Cosa serve in Web**:
- 📍 Admin page per gestione utenti
- 📍 Pulsante "Logout utente" per ogni utente
- 📍 Confirmation dialog

#### 1.5 LogoutUsers
```
POST /auth/logout-users
Payload: { userIds: [id1, id2, ...] }
Authorization: Bearer token (require Admin role)
```
**Cosa serve in Web**:
- 📍 Bulk logout feature in admin panel
- 📍 Multi-select checkbox su lista utenti
- 📍 "Logout selected users" button

#### 1.6 RefreshToken
```
POST /auth/refresh
Payload: { refreshToken }
Response: { accessToken, refreshToken, expiresInSeconds }
Rate Limit: 20 richieste/minuto per IP
```
**Cosa serve in Web**:
- 📍 Auto-refresh token prima della scadenza (15 minuti)
- 📍 HttpInterceptor per intercettare 401 e refreshare token
- 📍 Queue di richieste durante refresh
- 📍 Logout se refresh fallisce

---

### Feature 2: ME ENDPOINT (1 endpoint)

#### 2.1 Get Current User
```
GET /me
Authorization: Bearer token
Response: {
  userId,
  username,
  roles: [role1, role2, ...],
  permissions: [perm1, perm2, ...]
}
```
**Cosa serve in Web**:
- 📍 Caricamento info utente al login
- 📍 Display username in header/profilo
- 📍 Storage di roles e permissions per authorization checks
- 📍 Componente profilo utente

---

### Feature 3: PERMISSIONS ENDPOINT (1 endpoint)

#### 3.1 Get All Permissions
```
GET /permissions
Authorization: Bearer token
Query Params: (opzionali) module, scope, active
Response: [
  {
    permissionId,
    code,
    description,
    module,
    scope,
    attivo
  },
  ...
]
Require: Permission:ADMIN.PERMISSIONS.MANAGE
```

**Permessi Disponibili per Modulo**:

| Modulo | Permessi |
|--------|----------|
| **ORG** | MODULE.ORG.ACCESS, ORG.LIST, ORG.READ, ORG.CREATE, ORG.UPDATE, ORG.DELETE |
| **PERS** | MODULE.PERS.ACCESS, PERS.LIST, PERS.READ, PERS.CREATE, PERS.UPDATE, PERS.DELETE |
| **INC** | MODULE.INC.ACCESS, INC.LIST, INC.READ, INC.CREATE, INC.UPDATE, INC.DELETE |
| **TIPO** | MODULE.TIPO.ACCESS, TIPO.LIST, TIPO.READ, TIPO.CREATE, TIPO.UPDATE, TIPO.DELETE |
| **ADMIN** | MODULE.ADMIN.ACCESS, ADMIN.PERMISSIONS.MANAGE, ADMIN.ROLES.MANAGE |

**Cosa serve in Web**:
- 📍 Admin page: "Gestione Permessi"
- 📍 Tabella permessi con filtri (module, scope)
- 📍 Dettagli permesso (code, description, attivo status)
- 📍 Pagination (possibile)
- 📍 Search/Filter funzionalità

---

### Feature 4: ROLES ENDPOINT (3 endpoint)

#### 4.1 Get All Roles
```
GET /roles
Authorization: Bearer token
Response: [
  { roleId, name },
  ...
]
Require: Permission:ADMIN.ROLES.MANAGE
```

**Ruoli Predefiniti**:
1. **SIGAD_SUPERADMIN** - 27/27 permessi (Accesso completo)
2. **SIGAD_ADMIN** - 25 permessi (Admin operativo)
3. **SIGAD_OPERATORE** - 16 permessi (Operatore con modifica)
4. **SIGAD_LETTURA** - 8 permessi (Solo lettura)

**Cosa serve in Web**:
- 📍 Admin page: "Gestione Ruoli"
- 📍 Tabella ruoli
- 📍 Pulsante "Dettagli" o "Modifica permessi"
- 📍 Opzione view-only per ruoli di sistema

#### 4.2 Get Role Permissions
```
GET /roles/{roleId}/permissions
Authorization: Bearer token
Response: {
  roleId,
  roleName,
  permissions: [perm1, perm2, ...]
}
Require: Permission:ADMIN.ROLES.MANAGE
```

**Cosa serve in Web**:
- 📍 Detail page per ruolo specifico
- 📍 Elenco permessi assegnati al ruolo
- 📍 Badge/highlight per permessi active vs inactive
- 📍 Pulsante "Modifica permessi"

#### 4.3 Update Role Permissions
```
PUT /roles/{roleId}/permissions
Authorization: Bearer token
Payload: {
  permissions: [
    "MODULE.ORG.ACCESS",
    "ORG.LIST",
    "ORG.READ",
    "ORG.CREATE",
    "ORG.UPDATE"
  ]
}
Response: { success }
Require: Permission:ADMIN.ROLES.MANAGE
```

**Cosa serve in Web**:
- 📍 Edit form con multi-select permessi
- 📍 Raggruppamento permessi per modulo
- 📍 Toggle Modulo (MODULE.XXX.ACCESS) per enable/disable todo il modulo
- 📍 Checkboxes per singoli permessi
- 📍 Preview modifiche prima di salvare
- 📍 Save e Cancel buttons
- 📍 Success/Error notifications

---

### Feature 5: USERS ENDPOINT (1 endpoint)

#### 5.1 Assign Roles
```
PUT /users/{userId}/roles
Authorization: Bearer token
Payload: {
  roles: ["SIGAD_ADMIN", "SIGAD_OPERATORE"]
}
Response: { success }
Require: Admin role (SIGAD_ADMIN, SIGAD_SUPERADMIN)
```

**Cosa serve in Web**:
- 📍 Admin page: "Gestione Utenti"
- 📍 Tabella utenti con colonna "Ruoli"
- 📍 Pulsante "Modifica ruoli" per ogni utente
- 📍 Modal/Dialog con multi-select ruoli disponibili
- 📍 Preview ruoli attuali
- 📍 Assign multiple roles feature
- 📍 Audit trail di chi ha fatto il cambio

---

## 🏛️ MODULI APPLICATIVI (Non Identity)

L'Identity API espone **permission codes** per 4 moduli principali che **richiedono pages web**:

### ORG - Organizzazioni
- **Module Access**: MODULE.ORG.ACCESS
- **Operazioni**: LIST, READ, CREATE, UPDATE, DELETE
- **Web Necessari**:
  - ✅ Lista organismi (da Anagrafiche API)
  - ✅ Dettagli organismo
  - ✅ Form creazione/modifica (da Anagrafiche API)
  - ✅ Eliminazione (soft delete) (da Anagrafiche API)

### PERS - Persone
- **Module Access**: MODULE.PERS.ACCESS
- **Operazioni**: LIST, READ, CREATE, UPDATE, DELETE
- **Web Necessari**:
  - ❓ Lista persone (da Anagrafiche API)
  - ❓ Dettagli persona
  - ❓ Form creazione/modifica
  - ❓ Eliminazione

### INC - Incarichi
- **Module Access**: MODULE.INC.ACCESS
- **Operazioni**: LIST, READ, CREATE, UPDATE, DELETE
- **Web Necessari**:
  - ❓ Lista incarichi
  - ❓ Dettagli incarico
  - ❓ Form creazione/modifica
  - ❓ Eliminazione

### TIPO - Tipologie
- **Module Access**: MODULE.TIPO.ACCESS
- **Operazioni**: LIST, READ, CREATE, UPDATE, DELETE
- **Web Necessari**:
  - ✅ Lista tipologie (da Tipologiche API)
  - ✅ Dettagli tipologia
  - ✅ Form creazione/modifica (da Tipologiche API)
  - ✅ Eliminazione (da Tipologiche API)

---

## 🔄 MODELLO AUTORIZZAZIONE

### Permission-Based Authorization

Ogni azione richiede un **permesso specifico**:

```csharp
// Esempio: per leggere organismi
Required Permission: ORG.READ

// Esempio: per creare organismi
Required Permission: ORG.CREATE

// Esempio: per gestire ruoli
Required Permission: ADMIN.ROLES.MANAGE
```

### Come implementare in Blazor Web

```csharp
// 1. Nel service layer
public class PermissionService
{
    private List<string> _userPermissions;
    
    public bool HasPermission(string permissionCode)
        => _userPermissions.Contains(permissionCode);
}

// 2. Nel componente
@if (permissionService.HasPermission("ORG.CREATE"))
{
    <MudButton>Crea Organismo</MudButton>
}

// 3. Nelle pagine protette
@attribute [Authorize(Roles = "SIGAD_ADMIN,SIGAD_SUPERADMIN")]
@attribute [AuthorizeCustomPermission("ADMIN.ROLES.MANAGE")]
```

---

## 📋 COMPONENTI WEB MANCANTI - LISTA COMPLETA

### TIER 1: CRITICO (Authentication/Authorization Core)

| # | Componente | Responsabilità | Priorità | Status |
|---|-----------|-----------------|----------|--------|
| 1 | **AuthService Enhanced** | Token storage, auto-refresh, logout all | 🔴 CRITICO | ❌ |
| 2 | **Auth HttpInterceptor** | Auto-refresh token, 401 handling | 🔴 CRITICO | ❌ |
| 3 | **PermissionService** | Check permessi, cache permessi | 🔴 CRITICO | ❌ |
| 4 | **Authorization Guard** | [Authorize] attribute customizzato | 🔴 CRITICO | ❌ |
| 5 | **PermissionDirective** | @if (HasPermission) utility | 🟡 IMPORTANTE | ❌ |

### TIER 2: AMMINISTRAZIONE (Admin Features)

| # | Componente | Responsabilità | Priorità | Status |
|---|-----------|-----------------|----------|--------|
| 6 | **User Management Page** | Lista, modifica ruoli, logout utenti | 🟡 IMPORTANTE | ❌ |
| 7 | **User Detail Component** | Form modifica ruoli, history | 🟡 IMPORTANTE | ❌ |
| 8 | **Role Management Page** | Lista ruoli, dettagli | 🟡 IMPORTANTE | ❌ |
| 9 | **Role Detail Component** | Modifica permessi, preview | 🟡 IMPORTANTE | ❌ |
| 10 | **Permission Management Page** | Lista permessi, filtri | 🟡 IMPORTANTE | ❌ |
| 11 | **Bulk Actions Dialog** | Multi-select logout, bulk role assign | 🟡 IMPORTANTE | ❌ |
| 12 | **Audit Trail Viewer** | Chi ha modificato cosa e quando | 🟡 IMPORTANTE | ❌ |

### TIER 3: USER EXPERIENCE

| # | Componente | Responsabilità | Priorità | Status |
|---|-----------|-----------------|----------|--------|
| 13 | **User Profile Card** | Display username, ruoli, logout | 🟢 STANDARD | ❌ |
| 14 | **Logout Confirmation** | Dialog con opzione "logout all devices" | 🟢 STANDARD | ❌ |
| 15 | **Permission Denied Page** | 403 Forbidden page customizzata | 🟢 STANDARD | ❌ |
| 16 | **Token Expiry Warning** | Avviso prima della scadenza token | 🟢 STANDARD | ❌ |

---

## 🏗️ ARCHITETTURA DI IMPLEMENTAZIONE

### Flusso Autenticazione Completo

```
┌─────────────────────────────────────────────────────────────┐
│ 1. LOGIN                                                     │
│ User enters username/password → LoginForm.razor              │
│ ↓                                                             │
│ AuthService.Login(username, password)                        │
│ → POST /auth/login                                           │
│ ← { accessToken, refreshToken }                             │
│ ↓                                                             │
│ TokenService.StoreTokens(accessToken, refreshToken)         │
│ ↓                                                             │
│ Redirect to Dashboard                                        │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 2. AUTO-REFRESH (ogni 14 minuti)                           │
│ ↓                                                             │
│ HttpInterceptor detects access token scadenza                │
│ ↓                                                             │
│ AuthService.RefreshToken()                                  │
│ → POST /auth/refresh { refreshToken }                       │
│ ← { newAccessToken, newRefreshToken }                       │
│ ↓                                                             │
│ TokenService.StoreTokens(newAccessToken, newRefreshToken)   │
│ ↓                                                             │
│ Replay original request                                     │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ 3. LOGOUT                                                    │
│ User clicks "Logout" button                                  │
│ ↓                                                             │
│ AuthService.Logout()                                        │
│ → POST /auth/logout { accessToken }                         │
│ ↓                                                             │
│ TokenService.ClearTokens()                                  │
│ ↓                                                             │
│ Redirect to Login page                                      │
└─────────────────────────────────────────────────────────────┘
```

### Flusso Autorizzazione Basato su Permessi

```
┌─────────────────────────────────────────────────────────────┐
│ ON LOGIN                                                     │
│ ↓                                                             │
│ AuthService.GetCurrentUser()                                │
│ → GET /me                                                    │
│ ← { userId, username, roles, permissions }                  │
│ ↓                                                             │
│ PermissionService.SetPermissions(permissions)               │
│ PermissionService.SetRoles(roles)                           │
└─────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────┐
│ QUANDO UTENTE ACCEDE UNA PAGINA/FEATURE                    │
│ ↓                                                             │
│ @attribute [Authorize]                  // Autenticato?     │
│ @attribute [AuthorizePermission("PERM")] // Ha permesso?   │
│ ↓                                                             │
│ SE TRUE: Mostra componente                                 │
│ SE FALSE: Mostra "Permission Denied" page                  │
│                                                              │
│ OPPURE:                                                     │
│ @if (permissionService.HasPermission("ORG.READ"))          │
│ {                                                           │
│     <button @onclick="LoadOrganismi">Load</button>          │
│ }                                                           │
└─────────────────────────────────────────────────────────────┘
```

---

## 🔧 SERVIZI NECESSARI

### 1. AuthService (Esteso)

```csharp
public class AuthService
{
    // Autenticazione
    public Task<bool> LoginAsync(string username, string password);
    public Task LogoutAsync();
    public Task LogoutAllDevicesAsync();
    public Task<bool> RefreshTokenAsync();
    
    // Stato
    public bool IsAuthenticated { get; }
    public string? CurrentUserId { get; }
    public string? CurrentUsername { get; }
    public List<string> CurrentRoles { get; }
    public List<string> CurrentPermissions { get; }
    
    // Admin
    public Task LogoutUserAsync(string userId);
    public Task LogoutUsersAsync(IEnumerable<string> userIds);
}
```

### 2. PermissionService

```csharp
public class PermissionService
{
    public bool HasPermission(string permissionCode);
    public bool HasAnyPermission(params string[] permissionCodes);
    public bool HasAllPermissions(params string[] permissionCodes);
    public bool CanAccess(string moduleCode);
    
    // Admin
    public Task<List<PermissionDto>> GetAllPermissionsAsync();
    public Task<List<PermissionDto>> GetPermissionsByModuleAsync(string module);
}
```

### 3. RoleService

```csharp
public class RoleService
{
    public Task<List<RoleDto>> GetAllRolesAsync();
    public Task<RolePermissionsDto> GetRolePermissionsAsync(string roleId);
    public Task UpdateRolePermissionsAsync(string roleId, List<string> permissionCodes);
}
```

### 4. UserService

```csharp
public class UserService
{
    public Task AssignRolesToUserAsync(string userId, List<string> roleIds);
    public Task<List<RoleDto>> GetUserRolesAsync(string userId);
    public Task RemoveRoleFromUserAsync(string userId, string roleId);
}
```

---

## 📄 STATO ATTUALE vs STATO DESIDERATO

### AUTENTICAZIONE

| Feature | Current | Desired |
|---------|---------|---------|
| Login form | ✅ Presumibilmente presente | ✅ |
| Token storage | ❓ Sconosciuto | ✅ Secure storage |
| Token refresh | ❌ MANCANTE | ✅ Auto-refresh |
| Logout | ❓ Incompleto | ✅ Clean logout |
| Logout all devices | ❌ MANCANTE | ✅ |
| Logout specific user | ❌ MANCANTE | ✅ Admin only |
| Bulk logout | ❌ MANCANTE | ✅ Admin only |

### AUTORIZZAZIONE

| Feature | Current | Desired |
|---------|---------|---------|
| Get current user | ❌ MANCANTE | ✅ |
| Role check | ❓ Incompleto | ✅ Full implementation |
| Permission check | ❌ MANCANTE | ✅ Granular control |
| Permission cache | ❌ MANCANTE | ✅ Performance |

### AMMINISTRAZIONE

| Feature | Current | Desired |
|---------|---------|---------|
| User management | ❌ MANCANTE | ✅ Full CRUD |
| Role management | ❌ MANCANTE | ✅ Full CRUD |
| Permission management | ❌ MANCANTE | ✅ View + Filter |
| Audit trail | ❌ MANCANTE | ✅ Complete history |

---

## 🎯 RACCOMANDAZIONI

### FASE 1: FONDAMENTI (Settimana 1-2)
1. ✅ Implementare AuthService completo
2. ✅ Implementare TokenService con secure storage
3. ✅ Implementare HttpInterceptor con auto-refresh
4. ✅ Implementare PermissionService
5. ✅ Aggiungere authorization guards

### FASE 2: ADMIN PANEL (Settimana 3-4)
6. ✅ User Management page
7. ✅ Role Management page
8. ✅ Permission Management page
9. ✅ Bulk actions

### FASE 3: UX IMPROVEMENTS (Settimana 5-6)
10. ✅ User profile component
11. ✅ Permission denied page
12. ✅ Token expiry warning
13. ✅ Audit trail viewer

---

## 📚 MODELLO DATI IDENTITIES (DA SAPERE)

```csharp
// ApplicationUser (estende IdentityUser)
- Id (string)
- UserName (string)
- Email (string)
- EmailConfirmed (bool)
- PasswordHash (string)
- SecurityStamp (string)
- ConcurrencyStamp (string)
- PhoneNumber (string)
- PhoneNumberConfirmed (bool)
- TwoFactorEnabled (bool)
- LockoutEnd (DateTimeOffset)
- LockoutEnabled (bool)
- AccessFailedCount (int)

// Permission
- PermissionId (int)
- Code (string) - es. "ORG.CREATE"
- Description (string)
- Module (string) - es. "ORG", "PERS", "ADMIN"
- Scope (string) - es. "INTERNAL", "PUBLIC"
- Attivo (bool)
- CreatedAt, CreatedBy, UpdatedAt, UpdatedBy, DeletedAt, DeletedBy, IsDeleted

// RefreshToken
- RefreshTokenId (int)
- UserId (string) - FK to ApplicationUser
- Token (string)
- CreatedAt (DateTime)
- ExpiresAt (DateTime)
- RevokedAt (DateTime?) - NULL se attivo
- ReplacedByToken (string?) - per token rotation
- IsActive => RevokedAt == null && DateTime.UtcNow < ExpiresAt

// RolePermission
- RoleId (string) - FK to IdentityRole
- PermissionId (int) - FK to Permission
```

---

## ✅ CONCLUSIONI

1. **Il brief originale è INCOMPLETO** rispetto alle funzionalità disponibili nell'Identity API
2. **7 feature critiche mancano** nella descrizione della web component
3. **16 componenti Blazor** andrebbero implementate per sfruttare appieno l'API
4. **L'autorizzazione granulare** basata su permessi è completamente assente dal brief
5. **Il TIER 1 (auth core)** deve essere implementato PRIMA di qualsiasi feature

**Impatto**: Senza questi componenti, il web non può sfruttare i 13 endpoint dell'Identity API

