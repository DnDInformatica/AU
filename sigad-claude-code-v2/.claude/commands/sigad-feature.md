---
name: sigad:feature
description: Genera una feature VSA completa per un servizio SIGAD
args:
  - name: service
    description: "Servizio target (identity, tipologiche, anagrafiche)"
    required: true
  - name: domain
    description: "Nome del domain (es. Users, Organizzazioni)"
    required: true
  - name: action
    description: "Azione (list, getbyid, create, update, delete, crud)"
    required: true
---

# Genera Feature VSA

Genera una feature VSA completa per il servizio specificato.

## Input
- **Servizio:** $ARGS.service
- **Domain:** $ARGS.domain
- **Azione:** $ARGS.action

## Processo

### 1. Validazione Input
Verifica che:
- Servizio sia valido (identity, tipologiche, anagrafiche)
- Domain sia in PascalCase
- Azione sia supportata

### 2. Delega a Subagent
Invoca `sigad-vsa` subagent per generare:
- Command.cs
- Handler.cs (con Dapper)
- Response.cs (se necessario)
- Validator.cs (se create/update)
- Endpoint.cs

### 3. Post-Generation
- Aggiorna Program.cs con DI e endpoint registration
- Esegui build
- Verifica endpoint

## Esempio Uso

```
/sigad:feature identity users crud
/sigad:feature tipologiche voci list
/sigad:feature anagrafiche organizzazioni create
```

## Output Atteso

```
📁 Feature generata: Accredia.SIGAD.Identity.Api/Features/Users/Create/
├── CreateCommand.cs
├── CreateHandler.cs
├── CreateValidator.cs
└── CreateEndpoint.cs

📝 Program.cs aggiornato
✅ Build OK
🌐 Endpoint: POST /v1/users
```
