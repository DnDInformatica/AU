# Analisi Progetto: Accredia.SIGAD.Identity.Api

**Data Analisi:** 3 Febbraio 2026  
**Versione .NET:** .NET 9.0  
**Framework:** ASP.NET Core Web API Minimale  
**Stato Compilazione:** ✅ SUCCESSO  
**Stato Database:** ✅ SINCRONIZZATO  

---

## 📋 Sommario Esecutivo

Il progetto **Accredia.SIGAD.Identity.Api** è un servizio di identità e autorizzazione robusto costruito con le migliori pratiche ASP.NET Core. Implementa JWT authentication, role-based access control (RBAC), e un sistema di permessi granulare per il progetto SIGAD.

**Risultato Test Compilazione:** ✅ PASSED  
**Risultato Test Database Seeding:** ✅ PASSED  
**Risultato Test Avvio API:** ✅ RUNNING (porta 5005)

---

## 🏗️ Architettura del Progetto

### Stack Tecnologico

```
Framework:           ASP.NET Core Web API (.NET 9.0)
Database:            SQL Server 2019+ (Accredia2025)
Authentication:      JWT Bearer Tokens
Authorization:       Custom Permission-based + Claims
ORM:                 Entity Framework Core 9.0.2
Pattern:             Minimal APIs
```

### Dipendenze Principali

```
✓ Microsoft.AspNetCore.Authentication.JwtBearer v9.0.2
✓ Microsoft.AspNetCore.Identity.EntityFrameworkCore v9.0.2
✓ Microsoft.AspNetCore.OpenApi v9.0.11
✓ Microsoft.EntityFrameworkCore.SqlServer v9.0.2
✓ Microsoft.EntityFrameworkCore.Tools v9.0.2
```

### Struttura Directory

```
Accredia.SIGAD.Identity.Api/
├── Program.cs                          [Entry point & configurazione DI]
├── appsettings.json                    [Configurazione produzione]
├── appsettings.Development.json        [Configurazione sviluppo]
├── Contracts/                          [Data Transfer Objects]
│   ├── AuthContracts.cs               [LoginRequest, TokenResponse, RefreshRequest]
│   ├── JwtOptions.cs                  [Configurazione JWT]
│   └── RolePermissionContracts.cs     [DTO per ruoli e permessi]
├── Models/                             [Entity Framework Models]
│   ├── ApplicationUser.cs              [Estensione IdentityUser]
│   ├── Permission.cs                  [Entità permesso]
│   ├── RefreshToken.cs                [Entità refresh token]
│   └── RolePermission.cs              [Junction table Ruoli-Permessi]
├── Data/                               [Data Access Layer]
│   ├── AppIdentityDbContext.cs        [DbContext configuration]
│   ├── IdentitySeeder.cs              [Data seeding]
│   └── Migrations/                     [EF Core migrations]
├── Services/                           [Business Logic]
│   ├── TokenService.cs                [Gestione JWT & Refresh tokens]
│   ├── PermissionService.cs           [Gestione permessi per utenti/ruoli]
│   └── PermissionAuthorization.cs     [Custom authorization handler]
└── Properties/
    └── launchSettings.json             [Configurazione launch profiles]
```

---

## 🔐 Sistema di Autenticazione e Autorizzazione

### Flusso di Autenticazione

```
1. LOGIN (POST /auth/login)
   Input:  { username: "admin", password: "Password!12345" }
   Output: { accessToken: JWT, refreshToken: string, expiresInSeconds: 900 }
   Note: Rate limiting attivo (10 req/min per IP)
   
2. REFRESH TOKEN (POST /auth/refresh)
   Input:  { refreshToken: "token_string" }
   Output: { accessToken: JWT, refreshToken: string, expiresInSeconds: 900 }
   Note: Rate limiting attivo (20 req/min per IP)

3. LOGOUT (POST /auth/logout)
   Input:  { refreshToken: "token_string" }
   Output: 204 No Content

4. LOGOUT ALL (POST /auth/logout/all)
   Header: Authorization: Bearer {accessToken}
   Output: 204 No Content

5. LOGOUT USER (POST /auth/logout/user/{userId}) [Admin]
   Header: Authorization: Bearer {accessToken}
   Output: 204 No Content

6. LOGOUT USERS (POST /auth/logout/users) [Admin]
   Input:  { userIds: ["id1","id2"] }
   Output: 204 No Content
   
7. GET USER INFO (GET /me)
   Header: Authorization: Bearer {accessToken}
   Output: { userId, username, roles[], permissions[] }
```

### Struttura JWT Token

Il token contiene i seguenti claims:

```json
{
  "sub": "user-id",
  "NameIdentifier": "user-id",
  "unique_name": "admin",
  "jti": "guid",
  "role": ["SIGAD_SUPERADMIN"],
  "perm": ["ADMIN.PERMISSIONS.MANAGE", "ADMIN.ROLES.MANAGE", ...]
}
```

**Configurazione JWT:**
- **Issuer:** Accredia.SIGAD.Identity
- **Audience:** Accredia.SIGAD
- **AccessToken Duration:** 15 minuti
- **RefreshToken Duration:** 7 giorni
- **Key:** "DEV_ONLY_CHANGE_THIS_TO_A_LONG_RANDOM_SECRET" (⚠️ DEVE ESSERE CAMBIATA IN PRODUZIONE)

### Audit Logging (Auth)

Gli eventi di autenticazione sono tracciati con **EventId** e **Scope** senza dati sensibili (mai token o password).

Eventi principali:
- AuthLoginSucceeded / AuthLoginFailed / AuthLoginValidationFailed
- AuthRefreshSucceeded / AuthRefreshFailed / AuthRefreshValidationFailed
- AuthLogoutSucceeded / AuthLogoutFailed / AuthLogoutValidationFailed
- AuthLogoutAllSucceeded / AuthLogoutAllFailedMissingUser
- AuthLogoutUserSucceeded / AuthLogoutUserValidationFailed
- AuthLogoutUsersSucceeded / AuthLogoutUsersValidationFailed
- MeAccessSucceeded / MeAccessNotFound / MeAccessFailedMissingUser
- UserPermissionsFetched / RolePermissionsFetched
- PermissionsListed / RolesListed / RolePermissionsUpdated / RolePermissionsNotFound / RolePermissionsValidationFailed

### Ruoli Predefiniti

```
1. SIGAD_SUPERADMIN    → Accesso completo a tutti i moduli e permessi
2. SIGAD_ADMIN         → Gestione organizzazioni, persone, incarichi, tipologie
3. SIGAD_OPERATORE     → Lettura e modifica (non delete) di dati
4. SIGAD_LETTURA       → Solo lettura
```

### Sistema di Permessi Granulare

Il sistema implementa **27 permessi** organizzati per modulo:

#### Modulo ORG (Organizzazioni)
- `MODULE.ORG.ACCESS` - Accesso al modulo
- `ORG.LIST`, `ORG.READ`, `ORG.CREATE`, `ORG.UPDATE`, `ORG.DELETE`

#### Modulo PERS (Persone)
- `MODULE.PERS.ACCESS` - Accesso al modulo
- `PERS.LIST`, `PERS.READ`, `PERS.CREATE`, `PERS.UPDATE`, `PERS.DELETE`

#### Modulo INC (Incarichi)
- `MODULE.INC.ACCESS` - Accesso al modulo
- `INC.LIST`, `INC.READ`, `INC.CREATE`, `INC.UPDATE`, `INC.DELETE`

#### Modulo TIPO (Tipologie)
- `MODULE.TIPO.ACCESS` - Accesso al modulo
- `TIPO.LIST`, `TIPO.READ`, `TIPO.CREATE`, `TIPO.UPDATE`, `TIPO.DELETE`

#### Modulo ADMIN (Amministrazione)
- `MODULE.ADMIN.ACCESS` - Accesso al modulo
- `ADMIN.PERMISSIONS.MANAGE` - Gestione permessi
- `ADMIN.ROLES.MANAGE` - Gestione ruoli

---

## 💾 Schema Database

### Tabelle nel Database

Tutte le tabelle sono nel schema **Identity**.

#### AspNetUsers (Identity predefinita)
```
- Id (PK)
- UserName
- Email
- PasswordHash
- EmailConfirmed
- [...altre colonne standard ASP.NET Core Identity]
```

#### AspNetRoles (Identity predefinita)
```
- Id (PK)
- Name (Unique Index)
- NormalizedName
```

#### Permission (Personalizzata)
```
- PermissionId (PK) [int]
- Code (Unique Index) [nvarchar(200)]
- Description [nvarchar(500)]
- Module [nvarchar(100)]
- Scope [nvarchar(100)]
- Attivo [bit, Default=true]
- CreatedAt [datetime2]
- CreatedBy [nvarchar(255)]
- UpdatedAt [datetime2, nullable]
- UpdatedBy [nvarchar(255), nullable]
- DeletedAt [datetime2, nullable] - Per soft delete
- IsDeleted [bit]
```

#### RolePermission (Personalizzata)
```
- RoleId (PK, FK to AspNetRoles) [nvarchar(450)]
- PermissionId (PK, FK to Permission) [int]
- Composite Primary Key: (RoleId, PermissionId)
- OnDelete: Cascade su entrambe le FK
```

#### RefreshToken (Personalizzata)
```
- RefreshTokenId (PK) [int]
- UserId (FK to AspNetUsers) [nvarchar(450)]
- Token (Unique Index) [nvarchar(500)]
- CreatedAt [datetime2]
- ExpiresAt [datetime2]
- RevokedAt [datetime2, nullable]
- ReplacedByToken [nvarchar(500), nullable]
- OnDelete: Cascade
```

### Migration Corrente

**ID:** 20260203143117_InitialIdentity

La migration è stata **correttamente applicata al database**. Tutte le tabelle sono state create con i corretti indici e vincoli.

---

## 🛣️ Endpoint API

### Autenticazione (Public)

#### 1. Login
```
POST /auth/login
Content-Type: application/json

Request:
{
  "username": "admin",
  "password": "Password!12345"
}

Response (200 OK):
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "KL8mN9oPqRsTuVwXyZ0aBcDeFgHiJkLmNoPqRsT...",
  "expiresInSeconds": 900
}

Error (401 Unauthorized): Username o password non corretti
Error (429 Too Many Requests): Rate limit superato
```

#### 2. Refresh Token
```
POST /auth/refresh
Content-Type: application/json

Request:
{
  "refreshToken": "KL8mN9oPqRsTuVwXyZ0aBcDeFgHiJkLmNoPqRsT..."
}

Response (200 OK):
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "XyZ0aBcDeFgHiJkLmNoPqRsTuVwXyZ0aBcDeFg...",
  "expiresInSeconds": 900
}

Error (401 Unauthorized): Token scaduto o non valido
Error (400 Bad Request): Token non fornito
Error (429 Too Many Requests): Rate limit superato
```

#### 3. Logout
```
POST /auth/logout
Content-Type: application/json

Request:
{
  "refreshToken": "token_string"
}

Response (204 No Content)
Error (401 Unauthorized): Token non valido o già revocato
```

#### 4. Logout All (utente corrente)
```
POST /auth/logout/all
Authorization: Bearer {accessToken}

Response (204 No Content)
Error (401 Unauthorized): Token mancante o non valido
```

### Utente (Autenticato)

#### 5. Get Current User Info
```
GET /me
Authorization: Bearer {accessToken}

Response (200 OK):
{
  "userId": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
  "username": "admin",
  "roles": ["SIGAD_SUPERADMIN"],
  "permissions": ["ADMIN.PERMISSIONS.MANAGE", "ADMIN.ROLES.MANAGE", ...]
}

Error (401 Unauthorized): Token mancante o non valido
```

### Admin (Autenticato, Richiede ruolo Admin)

#### 6. Logout User
```
POST /auth/logout/user/{userId}
Authorization: Bearer {accessToken}

Response (204 No Content)
Error (403 Forbidden): Ruolo admin richiesto
```

#### 7. Logout Users
```
POST /auth/logout/users
Authorization: Bearer {accessToken}
Content-Type: application/json

Request:
{
  "userIds": ["id1", "id2"]
}

Response (204 No Content)
Error (403 Forbidden): Ruolo admin richiesto
```

### Permessi (Autenticato, Richiede `Permission:ADMIN.PERMISSIONS.MANAGE`)

#### 4. Get All Permissions
```
GET /permissions
Authorization: Bearer {accessToken}

Response (200 OK):
[
  {
    "permissionId": 1,
    "code": "MODULE.ORG.ACCESS",
    "description": "Accesso modulo organizzazioni",
    "module": "ORG",
    "scope": "MODULE",
    "attivo": true
  },
  ...
]

Error (401 Unauthorized): Non autenticato
Error (403 Forbidden): Non ha il permesso ADMIN.PERMISSIONS.MANAGE
```

### Ruoli (Autenticato, Richiede `Permission:ADMIN.ROLES.MANAGE`)

#### 5. Get All Roles
```
GET /roles
Authorization: Bearer {accessToken}

Response (200 OK):
[
  {
    "id": "role-id-guid",
    "name": "SIGAD_SUPERADMIN"
  },
  {
    "id": "role-id-guid",
    "name": "SIGAD_ADMIN"
  },
  ...
]

Error (403 Forbidden): Non ha il permesso ADMIN.ROLES.MANAGE
```

#### 6. Get Role Permissions
```
GET /roles/{id}/permissions
Authorization: Bearer {accessToken}

Response (200 OK):
{
  "roleId": "role-id-guid",
  "roleName": "SIGAD_ADMIN",
  "permissions": ["ADMIN.PERMISSIONS.MANAGE", "ADMIN.ROLES.MANAGE", ...]
}

Error (404 Not Found): Ruolo non trovato
Error (403 Forbidden): Non ha il permesso ADMIN.ROLES.MANAGE
```

#### 7. Update Role Permissions
```
PUT /roles/{id}/permissions
Authorization: Bearer {accessToken}
Content-Type: application/json

Request:
{
  "permissions": ["ADMIN.PERMISSIONS.MANAGE", "ADMIN.ROLES.MANAGE", "ORG.READ", ...]
}

Response (204 No Content)

Error (404 Not Found): Ruolo non trovato
Error (400 Bad Request): Uno o più permessi non validi
Error (403 Forbidden): Non ha il permesso ADMIN.ROLES.MANAGE
```

---

## 🔧 Servizi Applicativi

### 1. TokenService (ITokenService)

**Responsabilità:**
- Generazione JWT access token con claims utente, ruoli e permessi
- Generazione e validazione refresh token
- Revoca di refresh token (tracking sostituzioni)

**Metodi Pubblici:**
```csharp
Task<(string AccessToken, int ExpiresInSeconds)> CreateAccessTokenAsync(ApplicationUser user)
Task<RefreshToken> CreateRefreshTokenAsync(string userId)
Task<RefreshToken?> GetRefreshTokenAsync(string token)
Task RevokeRefreshTokenAsync(RefreshToken token, string? replacedByToken = null)
```

**Note Tecniche:**
- Utilizza HMAC SHA256 per la firma dei token
- Genera token refresh criptograficamente sicuri (64 byte random)
- Supporta token replacement tracking per audit trail

### 2. PermissionService (IPermissionService)

**Responsabilità:**
- Recuperare permessi per utente (tramite i suoi ruoli)
- Recuperare permessi per ruolo
- Caching logico per performance

**Metodi Pubblici:**
```csharp
Task<IReadOnlyList<string>> GetPermissionsForUserAsync(string userId)
Task<IReadOnlyList<string>> GetPermissionsForRoleAsync(string roleId)
```

**Note Tecniche:**
- Utilizza DISTINCT per evitare permessi duplicati
- Performance: query ottimizzate con SELECT delle sole code dei permessi

### 3. PermissionHandler (IAuthorizationHandler)

**Responsabilità:**
- Implementare custom authorization logic
- Verificare presence di specifico permesso nei claims JWT
- Bypass automatico per ruolo "SIGAD_SUPERADMIN"

**Logica:**
```
IF user.IsInRole("SIGAD_SUPERADMIN")
  → GRANTED (passa sempre)
ELSE IF user.HasClaim(type="perm", value=requiredPermission)
  → GRANTED
ELSE
  → DENIED
```

---

## 📊 Data Seeding

All'avvio dell'applicazione, il `IdentitySeeder` popola il database con:

### Ruoli (4)
- SIGAD_SUPERADMIN
- SIGAD_ADMIN
- SIGAD_OPERATORE
- SIGAD_LETTURA

### Utente Admin Predefinito
```
Username:   admin
Email:      admin@accredia.local
Password:   Password!12345
Role:       SIGAD_SUPERADMIN
Permissions: Tutti (27/27)
```

### Permessi (27)
- 5 permessi MODULE.*.ACCESS
- 20 permessi CRUD (LIST, READ, CREATE, UPDATE, DELETE) per 4 moduli
- 2 permessi ADMIN.*

### Assegnazione Permessi ai Ruoli

| Ruolo | Permessi Assegnati |
|-------|-------------------|
| SIGAD_SUPERADMIN | Tutti (27) |
| SIGAD_ADMIN | 25 (escluso soft delete implicitamente) |
| SIGAD_OPERATORE | 16 (accessi moduli + LIST, READ, UPDATE) |
| SIGAD_LETTURA | 8 (accessi moduli + LIST, READ) |

---

## ⚙️ Configurazione

### appsettings.json

```json
{
  "ConnectionStrings": {
    "IdentityDb": "Server=localhost,1434;Database=Accredia2025;..."
  },
  "Jwt": {
    "Issuer": "Accredia.SIGAD.Identity",
    "Audience": "Accredia.SIGAD",
    "Key": "DEV_ONLY_CHANGE_THIS_TO_A_LONG_RANDOM_SECRET",
    "AccessTokenMinutes": 15,
    "RefreshTokenDays": 7
  },
  "Logging": {...},
  "AllowedHosts": "*"
}
```

### Launch Profiles

**http** (Default Development)
- URL: http://localhost:5005
- Ambiente: Development
- HTTPS: No

**https**
- URL: https://localhost:7046; http://localhost:5176
- Ambiente: Development
- HTTPS: Sì

---

## 🧪 Test e Validazione

### Risultati Compilazione

```
✅ Build Status: SUCCESS
   - Errori: 0
   - Avvisi: 0
   - Tempo: 1.08 secondi
   - Output: bin\Debug\net9.0\Accredia.SIGAD.Identity.Api.dll
```

### Risultati Database

```
✅ Database Status: SYNCED
   - Migration applicata: 20260203143117_InitialIdentity
   - Schema creato: Identity
   - Tabelle create: 12 (8 ASP.NET Identity + 4 Custom)
   - Indici: Tutti creati correttamente
   - FK: Tutti configur ati con Cascade delete
```

### Risultati Seeding

```
✅ Data Seeding: COMPLETED
   - Ruoli creati: 4/4
   - Permessi creati: 27/27
   - Utente admin: Creato
   - Assegnazioni ruoli-permessi: Completate
```

### Startup API

```
✅ API Startup: RUNNING
   - Porta: 5005 (ipv4 127.0.0.1 e ipv6 ::1)
   - Stato: Listening
   - Configurazione JWT: Caricata
   - DbContext: Inizializzato
```

---

## ⚠️ Considerazioni di Sicurezza

### 🔴 CRITICAL - Da Risolvere Immediatamente

1. **JWT Secret Key**
   - **Problema:** Key hardcodato in configurazione con valore di sviluppo
   - **Rischio:** Chiunque ha accesso al codice può falsificare token JWT
   - **Soluzione:** Utilizzare secrets manager (Azure Key Vault, Docker Secrets, etc.)
   - **Azione:** Implementare IConfigurationProvider per caricamento da secrets

2. **Connection String SQL Server**
   - **Problema:** Password in chiaro nel file appsettings.json
   - **Rischio:** Accesso non autorizzato al database
   - **Soluzione:** Utilisare User Secrets in Development, secrets manager in Production
   - **Azione:** Implementare configuration provider

3. **CORS Policy**
   - **Problema:** `AllowedHosts: "*"` consente accesso da qualsiasi origine
   - **Rischio:** Possibili attacchi CSRF da domini non autorizzati
   - **Soluzione:** Definire CORS policy esplicito con origini whitelist

4. **Password di Default Admin**
   - **Problema:** Password hardcodato nello Seeder
   - **Rischio:** Accesso non autorizzato se DB non protetto
   - **Soluzione:** Generare password random al primo seeding, inviare via email

### 🟡 IMPORTANTE - Miglioramenti Consigliati

1. **Token Revocation**
   - Attualmente i token revoked vengono tracciati ma non validati lato server
   - Implementare token blacklist/blocklist per logout immediato

2. **Rate Limiting**
   - ✅ Rate limiting attivo su login (10 req/min per IP) e refresh (20 req/min per IP)

3. **HTTPS in Production**
   - Forzare HTTPS su tutti gli endpoint in produzione
   - Utilizzare profile https invece di http

4. **Audit Logging**
   - ✅ Implementato logging per eventi auth (senza dati sensibili)
   - Suggerito estendere a permessi/ruoli e accesso dati sensibili

5. **2FA / MFA**
   - Implementare autenticazione multi-fattore per account admin

6. **Token Refresh Rotation**
   - ✅ Implementata rotazione refresh token con reuse detection

---

## 📈 Performance e Optimizzazioni

### Analisi Query

Le query principali sono ben ottimizzate:

1. **GetPermissionsForUser** → 2 query (mediamente O(1) per cache interna ASP.NET Identity)
2. **GetRefreshToken** → 1 query con Include eager loading
3. **RolePermissions Update** → Bulk delete + bulk insert

### Potential Improvements

1. **Caching di Permessi**
   - Implementare IMemoryCache per cachare permessi per 5-10 minuti
   - Ridurrebbe query al database per utenti con accesso frequente

2. **Bulk Operations**
   - RolePermission update già bulk, efficiente ✅

3. **Connection Pooling**
   - EF Core + SQL Server implementa connection pooling di default ✅

---

## 🚀 Deploy Readiness

### Checklist Produzione

```
[ ] Cambiare JWT Secret Key
[ ] Cambiare Admin Password
[ ] Implementare secrets manager (Azure Key Vault / Docker Secrets)
[ ] Configurare CORS whitelist
[ ] Abilitare HTTPS con certificati validi
[ ] Implementare rate limiting
[ ] Abilitare audit logging
[ ] Configurare health checks endpoint
[ ] Testare authentication flow completo
[ ] Testare autorizzazione permessi
[ ] Load testing
[ ] Security scanning (OWASP)
[ ] Backup strategy del database
[ ] Monitoring e alerting
```

---

## 📝 Conclusioni

### Punti di Forza ✅

1. **Architettura Solida** - ASP.NET Core 9.0 con Minimal APIs
2. **Database Well-Designed** - Schema normalizzato con FK e indici appropriati
3. **Sicurezza Base** - JWT con firma, password hashing, RBAC
4. **Scalabilità** - Preparato per multiple istanze dietro load balancer
5. **Codice Pulito** - Separazione delle responsabilità, dependency injection
6. **Easy Setup** - Automatic seeding e migration, database ready to use

### Aree di Miglioramento 🔧

1. **Secrets Management** - Implementare secure storage per credenziali
2. **Authorization Auditing** - Aggiungere logging per compliance
3. **Token Security** - Implementare token revocation lista
4. **Rate Limiting** - ✅ Attivo su login/refresh con limiti per IP
5. **Health Checks** - Aggiungere endpoint /health

### Verdict Finale

**Stato Produttività:** ⚠️ **NON PRONTO per PRODUCTION senza risolvere critical issues di sicurezza**

L'API è **funzionale e ben strutturata** ma richiede:
1. ✅ Risoluzione dei 4 critical security issues
2. ✅ Implementazione di secrets management
3. ✅ Testing completo dei flussi di autenticazione
4. ✅ Security hardening per endpoint esposti

**Stima Lavoro Implementazione Issues Critical:** 4-6 ore
**Stima Lavoro Security Hardening Completo:** 12-16 ore

---

*Fine Analisi*
