# SIGAD - Project Brief per Claude
## Sistema Informativo Gestione Accreditamenti Digitali

---

## 🎯 SCOPE DEL PROGETTO CLAUDE

**Questo Claude Project si occupa di**: **Accredia.SIGAD.Web**

### Responsabilità Specifiche
- ✅ Sviluppo frontend Blazor Server
- ✅ Componenti UI con MudBlazor
- ✅ Layouts, pages, components
- ✅ Integrazione APIs (tramite Gateway YARP)
- ✅ User authentication/authorization
- ✅ State management e caching
- ✅ Error handling e validazione
- ✅ Logging e diagnostics
- ✅ Performance optimization
- ✅ Responsive design

### Cosa NON rientra in questo scope
- ❌ API backend (altri progetti)
- ❌ Database design (condiviso)
- ❌ Infrastructure/DevOps
- ❌ SQL Server management

### Interazione con altri servizi
```
Accredia.SIGAD.Web (7000)
    ├─→ Gateway YARP (7100)
    │   ├─→ Identity API (7001)  [AUTH, ROLES, PERMISSIONS, USERS]
    │   ├─→ Tipologiche API (7002) [Reference Data]
    │   └─→ Anagrafiche API (7003) [Master Data]
    └─→ SQL Server (lettura via APIs)
```

**Il Web comunica con le API esclusivamente tramite HTTP REST tramite YARP Gateway.**

---

## ⚠️ FUNZIONALITÀ CRITICHE MANCANTI NEL BRIEF

### 🔴 CRITICO #1: Token Auto-Refresh (15 minuti)
**Identity API**: JWT access token scade ogni 15 minuti
**Cosa serve in Web**:
- ✅ HttpInterceptor che monitora token expiry
- ✅ Auto-refresh ogni 14 minuti
- ✅ Queue di richieste durante refresh
- ✅ Logout se refresh fallisce (401)

**Senza questo**: Utenti vengono loggati out ogni 15 minuti ❌

### 🔴 CRITICO #2: Permission-Based Authorization (Completamente mancante)
**Identity API espone**: 
- `GET /me` → { userId, username, roles[], permissions[] }
- `GET /permissions` → Lista di 27 permessi per modulo
- Permessi per: ORG, PERS, INC, TIPO, ADMIN

**Cosa serve in Web**:
- ✅ PermissionService
- ✅ Authorization Guards customizzati
- ✅ UI visibility based on permissions
- ✅ Ogni azione richiede permesso specifico

**Senza questo**: Non si può controllare chi fa cosa ❌

### 🔴 CRITICO #3: Admin Panel (Non esiste)
**Identity API espone endpoint admin**:
- `PUT /users/{id}/roles` - Assegnare ruoli a utenti
- `GET/PUT /roles/{id}/permissions` - Gestire permessi ruoli
- `GET /permissions` - Visualizzare tutti i permessi
- `POST /auth/logout-users` - Bulk logout

**Cosa serve in Web**:
- ✅ User Management Page
- ✅ Role Management Page
- ✅ Permission Management Page
- ✅ Bulk Actions

**Senza questo**: Nessuno può amministrare il sistema ❌

### 🟡 IMPORTANTE: Logout Avanzato
**Identity API**: 6 endpoint Auth (non solo login/logout basic)
- `POST /auth/logout` - Logout standard
- `POST /auth/logout-all` - Logout da tutti i dispositivi
- `POST /auth/logout-user/{id}` - Admin logout utente
- `POST /auth/logout-users` - Admin bulk logout

**Attualmente nel brief**: Solo login/logout basic → INCOMPLETO

---

## 📋 MAPPATURA PERMESSI → PAGINE WEB

Ogni pagina deve controllare il permesso corrispondente:

| Pagina/Feature | Permesso Richiesto | Azione |
|---|---|---|
| **Visualizza Organismi** | `ORG.LIST` | Read-only list |
| **Leggi Dettagli Organismo** | `ORG.READ` | View details |
| **Crea Organismo** | `ORG.CREATE` | Show "New" button |
| **Modifica Organismo** | `ORG.UPDATE` | Show "Edit" button |
| **Elimina Organismo** | `ORG.DELETE` | Show "Delete" button |
| ... (stesso per PERS, INC, TIPO) |
| **Gestione Utenti (Admin)** | `ADMIN.ROLES.MANAGE` | Show admin menu |
| **Gestione Ruoli (Admin)** | `ADMIN.ROLES.MANAGE` | Show admin menu |
| **Gestione Permessi (Admin)** | `ADMIN.PERMISSIONS.MANAGE` | Show admin menu |

---

## 🔐 RUOLI STANDARD (4)

```
1. SIGAD_SUPERADMIN   [27/27 permessi]
   └─ Accesso completo a tutto

2. SIGAD_ADMIN        [25 permessi]
   └─ Admin operativo, no permessi super-admin

3. SIGAD_OPERATORE    [16 permessi]
   └─ Operatore: LIST, READ, CREATE, UPDATE (no DELETE per alcuni)

4. SIGAD_LETTURA      [8 permessi]
   └─ Solo lettura di base (LIST, READ solo per moduli pubblici)
```

Questi devono essere visualizzati correttamente nel Web UI quando si assegnano ruoli a utenti.

---

## 📊 COMPONENTI BLAZOR MANCANTI

Vedere file dettagliato: **`IDENTITY_API_ANALYSIS.md`**

### TIER 1: CRITICO ⏰ Settimana 1-2
- [ ] AuthService Extended (token management)
- [ ] TokenService (secure storage)
- [ ] HttpInterceptor (auto-refresh)
- [ ] PermissionService (permission checks)
- [ ] AuthorizationGuards (custom attributes)

### TIER 2: AMMINISTRAZIONE ⏰ Settimana 3-4
- [ ] User Management Page
- [ ] User Detail Component
- [ ] Role Management Page
- [ ] Role Detail Component
- [ ] Permission Management Page
- [ ] Bulk Actions Dialog

### TIER 3: UX ⏰ Settimana 5-6
- [ ] User Profile Card
- [ ] Logout Confirmation Dialog
- [ ] Permission Denied Page (403)
- [ ] Token Expiry Warning

---

## 🏢 ORGANIZZAZIONE

**Cliente**: ACCREDIA (L'Ente Italiano di Accreditamento)
**Team**: Danilo (Lead) + 4 sviluppatori
**Ruolo Danilo**: IT Direction, Lead Architect, 30 anni .NET expertise

---

## 🎯 COSA FA (SIGAD Complessivo)

Sistema digitale per gestire l'accreditamento di organismi di certificazione, ispezione e prova in Italia.

**Funzionalità Principali**:
- Gestione anagrafi accreditamenti
- Gestione territoriale (comuni, province, regioni)
- Workflow di certificazione e approvazione
- Integrazione dati da ISTAT (API governative italiane)
- Dashboard inspector per disponibilità
- Gestione documenti e certificati

---

## 🖥️ PROJECT SCOPE - Accredia.SIGAD.Web

### Focus di Questo Progetto Claude
Questo progetto **si concentra esclusivamente** sul **frontend web** (Accredia.SIGAD.Web):

| Aspetto | Responsabilità |
|---------|-----------------|
| **Componenti Blazor** | Pagine, layout, componenti riutilizzabili |
| **UI/UX** | Design con MudBlazor, responsive design |
| **Autenticazione** | Form login, redirect autorizzazione |
| **State Management** | Gestione stato componenti, services |
| **Routing** | Navigazione tra pagine, menu |
| **Forms** | Binding dati, validazione client |
| **API Integration** | Chiamate HTTP alle 3 API backend |
| **Styling** | CSS custom, tema MudBlazor |

### Cosa NON fa questo progetto
- ❌ Backend APIs (sviluppate separatamente)
- ❌ Database queries (solo via API)
- ❌ Business logic complessa (nel backend)
- ❌ Autenticazione server-side (JWT dal backend)

### Dipendenze Esterne
Questo progetto **dipende da**:
- ✅ **Identity API** (7001) - Token JWT, login
- ✅ **Tipologiche API** (7002) - Dati riferimento
- ✅ **Anagrafiche API** (7003) - Dati anagrafici
- ✅ **Gateway YARP** (7100) - Routing alle API

### Principali Componenti Blazor

| Componente | Percorso | Responsabilità |
|-----------|----------|-----------------|
| `MainLayout` | `/Components/Layout/` | Layout principale, nav |
| `NavMenu` | `/Components/Layout/` | Menu navigazione laterale |
| Dashboard | `/Components/Pages/` | Home page principale |
| Accreditamenti | `/Components/Pages/` | Gestione accreditamenti |
| Organismi | `/Components/Pages/` | Elenco e dettagli organismi |
| Certificati | `/Components/Pages/` | Gestione certificati |
| Impostazioni | `/Components/Pages/` | Profilo utente, preferenze |

### Tecnologie Frontend

| Tecnologia | Utilizzo |
|-----------|----------|
| **Blazor Server** | Rendering componenti lato server |
| **MudBlazor** | UI components (Button, Table, Form, Dialog) |
| **Serilog** | Logging strutturato (client-side) |
| **OpenTelemetry** | Tracing HTTP calls |
| **CSS/SCSS** | Styling custom |
| **JavaScript Interop** | Integrazioni browser quando necessario |

### Servizi Applicativi (da implementare)

| Servizio | Responsabilità |
|----------|-----------------|
| **AuthService** | Login, logout, token management, logout all devices |
| **TokenService** | Token storage, retrieval, expiry check |
| **PermissionService** | Permission checks, permission cache |
| **RoleService** | Get roles, get role permissions, update permissions (admin) |
| **UserService** | Assign roles, get user roles, bulk logout (admin) |
| **HttpInterceptor** | Auto-refresh token su 401, queue requests |

### Flusso di Comunicazione

```
┌─────────────────────────────────────────────────┐
│         Accredia.SIGAD.Web                      │
│  (Blazor Server - Questo Progetto)              │
│                                                 │
│  - Componenti Blazor                            │
│  - MudBlazor UI                                 │
│  - Routing e State                              │
│  - Http Client                                  │
└─────────────┬───────────────────────────────────┘
              │
              ├──> Gateway YARP (7100)
              │        │
              ├────────┼──> Identity API (7001)
              ├────────┼──> Tipologiche API (7002)
              └────────┼──> Anagrafiche API (7003)
                       │
                       └──> SQL Server 2025
```

### Development Focus

**Quando lavori su questo progetto, concentrati su**:
1. ✅ Nuove pagine Blazor
2. ✅ Componenti MudBlazor
3. ✅ Form binding e validazione
4. ✅ Navigazione e routing
5. ✅ Integrazione API calls
6. ✅ Error handling UI
7. ✅ Responsive design
8. ✅ Accessibility (a11y)

**NON ti occupi di**:
- ❌ SQL queries
- ❌ Business logic backend
- ❌ Database schema
- ❌ API endpoints (già sviluppati)

---

## 🏗️ ARCHITETTURA

### Stack Tecnologico
- **Framework**: .NET 9.0
- **Database**: SQL Server 2025 + PostgreSQL (per alcune API)
- **Web Frontend**: Blazor Server + MudBlazor
- **API Gateway**: YARP (Yet Another Reverse Proxy)
- **Logging**: Serilog (Console, File, Structured)
- **Monitoring**: OpenTelemetry
- **UI Components**: MudBlazor 8.14.0

### Pattern Architetturale
- **Microservizi**: 5 servizi indipendenti
- **Vertical Slice Architecture**: Features organizzate verticalmente
- **Clean Architecture**: Layers ben separati
- **CQRS**: Separazione read/write dove appropriato

### Servizi Microservizi

| Servizio | Porta | Responsabilità |
|----------|-------|-----------------|
| **Web UI** | 7000 | Frontend Blazor Server |
| **Identity API** | 7001 | Autenticazione, autorizzazione, utenti |
| **Tipologiche API** | 7002 | Dati di riferimento, tipologie, configurazioni |
| **Anagrafiche API** | 7003 | Dati anagrafiche, organismi, strutture territoriali |
| **Gateway YARP** | 7100 | Router API, load balancing, reverse proxy |

---

## 💾 STRUTTURA DATABASE

### Dati Italiani Implementati
- **Regioni** (20)
- **Province** (110)
- **Comuni** (~8000)
- **Unità Territoriali**: Struttura ISTAT gerarchica
- **Organismi**: Enti accreditati
- **Accreditamenti**: Relazioni tra organismi e tipologie
- **Certificati**: Emessi, revocati, in scadenza

### Tabelle Temporali
- Tutte le principali tabelle hanno versioning temporale (SQL Server Temporal Tables)
- Audit trail completo per conformità normativa italiana

### Integrazione ISTAT
- Import da API ISTAT per dati territoriali
- Stored procedures per sincronizzazione
- Normalizzazione dati governativi

---

## 📦 PACKAGES ATTUALI

```
✅ MudBlazor 8.14.0           // UI Components
✅ OpenTelemetry 1.9.0        // Distributed Tracing
✅ Serilog 6.0.0-8.0.2        // Structured Logging
✅ Entity Framework Core       // ORM (nelle API)
✅ Dapper                      // Micro-ORM (dove necessario)
✅ Asp.Versioning             // API Versioning
```

---

## 🔧 PROGETTI RECENTI COMPLETATI

1. **Database Optimization**: Normalizzazione schema, indici, temporal tables
2. **Vertical Slice Architecture**: Refactoring progetti per VSA pattern
3. **Data Migration**: Import from legacy systems con validazione
4. **API Gateway Setup**: YARP configuration con routing intelligente
5. **Documentation System**: Comprehensive markdown docs con Docling
6. **MCP Server Integration**: Database connectivity via MCP servers

---

## 📁 STRUTTURA SOLUTION COMPLETA

```
C:\Accredia\Sviluppo\AU\
├── Accredia.SIGAD.Shared/          // Librerie condivise
├── Accredia.SIGAD.Web/             // ⭐ QUESTO PROGETTO (Blazor Server - 7000)
├── Accredia.SIGAD.Identity.Api/    // Identity Service (7001) - BACKEND
├── Accredia.SIGAD.Identity.Api.Tests/
├── Accredia.SIGAD.Tipologiche.Api/ // Reference Data (7002) - BACKEND
├── Accredia.SIGAD.Anagrafiche.Api/ // Master Data (7003) - BACKEND
├── Accredia.SIGAD.Gateway/         // YARP Gateway (7100) - BACKEND
├── Accredia.SIGAD.sln              // Main Solution
├── start_sigad.bat                 // Script avvio servizi
└── stop_sigad.bat                  // Script arresto servizi
```

---

## 📂 STRUTTURA DEL PROGETTO WEB (Accredia.SIGAD.Web)

```
Accredia.SIGAD.Web/
├── bin/                            // Output build
├── obj/                            // Artefatti build
├── Properties/
│   └── launchSettings.json         // Config localhost:7000
├── Components/
│   ├── Layout/
│   │   ├── MainLayout.razor        // Layout principale
│   │   ├── NavMenu.razor           // Menu navigazione
│   │   └── MainLayout.razor.css    // Styling layout
│   ├── Pages/
│   │   ├── Home.razor              // Dashboard
│   │   ├── Accreditamenti.razor    // Gestione accreditamenti
│   │   ├── Organismi.razor         // Elenco organismi
│   │   ├── Certificati.razor       // Gestione certificati
│   │   ├── Impostazioni.razor      // Profilo utente
│   │   └── [Altre pages...]
│   ├── Account/                    // Autenticazione
│   │   ├── Login.razor
│   │   ├── Logout.razor
│   │   └── Profile.razor
│   └── Shared/
│       └── [Componenti riutilizzabili]
├── Services/
│   ├── ApiClient.cs                // Client HTTP verso APIs
│   ├── AuthService.cs              // Gestione auth
│   ├── CacheService.cs             // Caching dati
│   └── [Altre services]
├── Models/
│   ├── ViewModels/                 // Modelli per UI
│   └── DTOs/                       // Data Transfer Objects
├── wwwroot/
│   ├── css/
│   │   └── app.css                 // Styling custom
│   ├── js/
│   │   └── [JavaScript interop]
│   └── images/
├── appsettings.json                // Configurazione
├── appsettings.Development.json    // Config locale
├── Program.cs                      // Configurazione Blazor Server
├── App.razor                       // Root component
├── Routes.razor                    // Routing configuration
├── Accredia.SIGAD.Web.csproj       // Project file
└── README.md                       // Documentazione progetto
```

### File Chiave nel Web Project

| File | Responsabilità |
|------|-----------------|
| `Program.cs` | Startup, DI, middleware |
| `App.razor` | Root component |
| `Routes.razor` | Configurazione routing |
| `appsettings.json` | URLs API, logging |
| `MainLayout.razor` | Layout principale |
| `ApiClient.cs` | HTTP calls alle APIs |
| `AuthService.cs` | JWT tokens, login/logout |
| `.csproj` | NuGet packages, target framework |

---

## 🚀 COME AVVIARE

```bash
# Build completo
dotnet build Accredia.SIGAD.sln

# Run tutti i servizi
.\start_sigad.bat

# Accedere
http://localhost:7000  // Web UI (richiede autenticazione)

# API Gateway
http://localhost:7100  // Routing alle API
```

---

## 🔐 SICUREZZA & COMPLIANCE

- ✅ Autenticazione JWT
- ✅ Role-Based Access Control (RBAC)
- ✅ Permission-Based Access Control (PBAC) - Granulare
- ✅ Audit trail completo (Temporal Tables)
- ✅ Conformità GDPR
- ✅ Conformità normative italiane (accreditamento)
- ✅ Logging strutturato Serilog
- ✅ Data encryption (SQL Server, in-flight HTTPS)

### JWT Token Management (CRITICO)

**Access Token**:
- ⏱️ Expiry: 15 minuti
- 🔄 **DEVE essere auto-refreshato** ogni 14 minuti
- 📍 **Implementare HttpInterceptor** che monitora expiry

**Refresh Token**:
- ⏱️ Expiry: 7 giorni
- 🔄 Usato per ottenere nuovo access token
- 🔒 Memorizzato in secure storage

**Configurazione JWT** (appsettings.json):
```json
{
  "Jwt": {
    "Issuer": "Accredia.SIGAD.Identity",
    "Audience": "Accredia.SIGAD",
    "Key": "[SECRET_KEY]",
    "AccessTokenMinutes": 15,
    "RefreshTokenDays": 7
  }
}
```

### Rate Limiting (Identity API)

```
POST /auth/login:       10 richieste/minuto per IP
POST /auth/refresh:     20 richieste/minuto per IP
```

Il Web DEVE rispettare questi limiti per evitare blocchi.

---

## 📊 STATO ATTUALE (2026-02-06)

| Elemento | Status |
|----------|--------|
| **Build** | ✅ Passato |
| **Microservizi** | ✅ 5/5 Online |
| **Database** | ✅ SQL Server 2025 |
| **Frontend** | ✅ Blazor Server online |
| **Logging** | ✅ Serilog operativo |
| **Monitoring** | ✅ OpenTelemetry configurato |

---

## 🎓 CONTESTO DOMINIO

**ACCREDIA** è l'ente che accredia (autorizza) organismi di:
- Certificazione prodotti/sistemi
- Ispezione
- Prova (laboratori)

SIGAD gestisce l'intero ciclo di vita di questi accreditamenti in modo digitale.

---

## 📞 CONTATTI PROGETTO

- **Lead**: Danilo (IT Direction ACCREDIA)
- **Linguaggi**: Italiano (contesto ACCREDIA), English (technical)
- **Timezone**: Europe/Rome
- **Repository**: C:\Accredia\Sviluppo\AU\

---

## 🎯 PROSSIMI TASK TIPICI

- Feature development per dashboard
- Database optimization
- API enhancement
- Testing (unit, integration, E2E)
- Documentation
- Performance tuning
- Migrations da sistemi legacy

---

## 📚 DOCUMENTI DI RIFERIMENTO

### Analisi Dettagliata - Identity API Integration

**File**: `IDENTITY_API_ANALYSIS.md`  
**Contenuti**:
- ✅ Tutti i 13 endpoint Identity API documentati
- ✅ 7 funzionalità critiche per il Web
- ✅ 16 componenti Blazor da implementare
- ✅ Mappatura permessi → pagine Web
- ✅ Roadmap implementazione (3 fasi)
- ✅ Modello dati completo
- ✅ Architettura authorization flows

**Quando leggere**: PRIMA di iniziare lo sviluppo del Web

### File Principale Brief

**File**: `CLAUDE_PROJECT_BRIEF.md` (questo file)  
**Uso**: Onboarding Claude Projects, overview generale

---

## 🚀 COME INIZIARE

1. ✅ Leggi questo brief per il contesto generale
2. ✅ Leggi `IDENTITY_API_ANALYSIS.md` per i dettagli Identity API
3. ✅ Crea un Claude Project
4. ✅ Inizia con FASE 1 (Token Management + PermissionService)
5. ✅ Procedi con FASE 2 (Admin Panel)
6. ✅ Completa FASE 3 (UX Polish)

---

**Ready for: Development | Testing | Optimization | Documentation**

✅ Progetto stabile e in produzione
