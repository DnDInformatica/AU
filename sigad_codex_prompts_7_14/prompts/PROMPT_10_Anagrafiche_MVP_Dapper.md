# PROMPT 10 — Anagrafiche: MVP (VSA + Dapper) + migrations design-time
Reasoning Level: MEDIUM

## Obiettivo
In `Accredia.SIGAD.Anagrafiche.Api` (schema `Anagrafiche`) implementare MVP:
- Entity: `Organizzazione` (OrganizzazioneId, Codice, Denominazione, IsActive, CreatedUtc)
- Endpoint VSA:
  - GET /v1/organizzazioni (lista + paging)
  - GET /v1/organizzazioni/{id}
  - POST /v1/organizzazioni (DEV-only)
  - PUT /v1/organizzazioni/{id} (DEV-only)
- Swagger dev-only
- Dapper runtime, EF migrations design-time

## Implementazione
1) `Database/EnsureTables` (DEV-only)
2) `Organizzazioni/List`
3) `Organizzazioni/GetById`
4) `Organizzazioni/Create` (DEV-only)
5) `Organizzazioni/Update` (DEV-only)

## POST-CHECK
- Build OK
- Avvio (7003)
- Smoke CRUD
