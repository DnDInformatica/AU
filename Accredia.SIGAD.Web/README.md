# Accredia.SIGAD.Web

Sistema web Blazor Server per la gestione digitale degli accreditamenti ACCREDIA.

---

## 🚀 Quick Start

```powershell
# 1. Ferma processi esistenti
.\stop_sigad.bat

# 2. Compila il progetto
cd Accredia.SIGAD.Web
dotnet build

# 3. Esegui il progetto
dotnet run
```

**URL**: http://localhost:7000

---

## 📚 Documentazione

| Documento | Descrizione |
|-----------|-------------|
| **[DEVELOPMENT_GUIDELINES.md](DEVELOPMENT_GUIDELINES.md)** | ⭐ Best practices, lessons learned, Desktop Commander usage |
| **[CLAUDE_PROJECT_BRIEF.md](../CLAUDE_PROJECT_BRIEF.md)** | Overview progetto, scope, architettura |
| **[IDENTITY_API_ANALYSIS.md](../IDENTITY_API_ANALYSIS.md)** | Analisi dettagliata Identity API integration |

---

## 🏗️ Architettura

**Framework**: .NET 9.0 + Blazor Server  
**UI Library**: MudBlazor 8.14.0  
**Logging**: Serilog  
**Monitoring**: OpenTelemetry  

**Comunicazione**:
```
Web (7000) → Gateway YARP (7100)
    ├─→ Identity API (7001)
    ├─→ Tipologiche API (7002)
    └─→ Anagrafiche API (7003)
```

---

## 📁 Struttura Progetto

```
Accredia.SIGAD.Web/
├── Components/
│   ├── Layout/          # Layout principale, NavMenu
│   ├── Pages/           # Pagine Blazor
│   └── Shared/          # Componenti riutilizzabili
├── Services/            # Application services
│   ├── TokenService.cs
│   ├── GatewayClient.cs
│   └── UserContext.cs
├── Auth/                # Autenticazione
├── Models/              # ViewModels, DTOs
├── wwwroot/             # Static files (CSS, JS, images)
└── Program.cs           # Startup configuration
```

---

## 🔧 Development

### Prerequisiti
- .NET 9.0 SDK
- Visual Studio 2022 / VS Code / Rider
- SQL Server 2025 (per le API backend)

### Compilazione
```powershell
# Build
dotnet build

# Run
dotnet run

# Watch (hot reload)
dotnet watch run
```

### Common Issues

**Problema**: Errori MSB3021/MSB3027 (DLL bloccate)  
**Soluzione**: `.\stop_sigad.bat` prima di compilare

**Problema**: Token scade ogni 15 minuti  
**Soluzione**: FASE 1 in corso - TokenRefreshService

Vedi [DEVELOPMENT_GUIDELINES.md](DEVELOPMENT_GUIDELINES.md) per troubleshooting completo.

---

## 🎯 Roadmap

### ✅ COMPLETATO
- [x] Autenticazione base JWT
- [x] Layout MudBlazor
- [x] Integrazione Gateway YARP
- [x] TokenService con Adapter Pattern
- [x] UserContext con permission checks

### 🚧 IN CORSO - FASE 1 (Token Management)
- [ ] TokenRefreshService (background timer)
- [ ] HttpInterceptor (auto-refresh su 401)
- [ ] Estensione GatewayClient (RefreshTokenAsync)

### 📋 TODO - FASE 2 (Admin Panel)
- [ ] User Management Page
- [ ] Role Management Page
- [ ] Permission Matrix

### 📋 TODO - FASE 3 (UX Polish)
- [ ] Token Expiry Warning
- [ ] Logout Confirmation
- [ ] Permission Denied Page (403)

---

## 🔐 Security

- **JWT Tokens**: Access token (15min) + Refresh token (7 days)
- **Storage**: ProtectedSessionStorage (default) / ProtectedLocalStorage ("Remember Me")
- **Encryption**: ASP.NET Core Data Protection
- **Authorization**: Permission-based (27 permessi granulari)

---

## 👥 Team

**Lead**: Danilo (IT Direction, Lead Architect)  
**Claude AI**: Development Assistant  
**Developers**: 4 sviluppatori team ACCREDIA  

---

## 📞 Support

**Issues**: Contatta Danilo  
**Documentation**: Vedi [DEVELOPMENT_GUIDELINES.md](DEVELOPMENT_GUIDELINES.md)  
**Architecture**: Vedi [CLAUDE_PROJECT_BRIEF.md](../CLAUDE_PROJECT_BRIEF.md)  

---

**Versione**: 1.0  
**Ultimo aggiornamento**: 2025-02-06
