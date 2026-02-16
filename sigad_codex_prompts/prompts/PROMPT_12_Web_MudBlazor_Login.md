# PROMPT 12 — Web (Blazor Server + MudBlazor): login + chiamate via Gateway
Reasoning Level: MEDIUM

## Obiettivo
Nel progetto `Accredia.SIGAD.Web`:
- MudBlazor MVP UI
- Login (chiama `POST /identity/auth/login` via gateway)
- Token in ProtectedSessionStorage
- Pagine lista:
  - Tipologiche
  - Organizzazioni

## Regole HARD
- Web chiama SOLO Gateway (7100).

## Implementazione
1) HttpClient `GatewayClient` BaseAddress `http://localhost:7100/`
2) DelegatingHandler: Authorization + CorrelationId
3) AuthStateProvider custom
4) Pages MudBlazor: /login, /tipologiche, /organizzazioni

## POST-CHECK
- Build OK
- Smoke manuale UI
