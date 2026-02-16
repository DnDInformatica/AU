# PROMPT 9 — Tipologiche: MVP (VSA + Dapper) + migrations design-time
Reasoning Level: MEDIUM

## Obiettivo
In `Accredia.SIGAD.Tipologiche.Api` (schema `Tipologiche`) implementare MVP:
- Entity: `TipoVoceTipologica` (Code, Description, IsActive, Ordine)
- Endpoint VSA:
  - GET /v1/tipologiche (lista, paging)
  - GET /v1/tipologiche/{id}
  - POST /v1/tipologiche (DEV-only)
  - PUT /v1/tipologiche/{id} (DEV-only)
- Swagger dev-only
- Dapper runtime, EF migrations design-time

## PRE-CHECK
| Voce | Stato | Azione |

## Implementazione
1) Feature `Database/EnsureTables` (DEV-only): crea tabella `Tipologiche.TipoVoceTipologica`
2) Feature `Tipologiche/List` (paging + filtro q)
3) Feature `Tipologiche/GetById`
4) Feature `Tipologiche/Create` (DEV-only)
5) Feature `Tipologiche/Update` (DEV-only)

## POST-CHECK
- Build OK
- Avvio (7002)
- Ensure schema + tables
- Smoke GET list
