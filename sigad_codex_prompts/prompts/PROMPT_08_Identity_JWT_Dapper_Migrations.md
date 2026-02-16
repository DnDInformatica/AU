# PROMPT 8 — Identity: schema DB + JWT endpoints (VSA) + EF migrations (design-time)
Reasoning Level: MEDIUM

## Obiettivo
Implementare in `Accredia.SIGAD.Identity.Api`:
- Schema DB `Identity` (tabelle MVP)
- JWT login (refresh opzionale)
- Endpoint VSA:
  - POST /auth/register (DEV-only, opzionale)
  - POST /auth/login
  - GET  /me
- Swagger SOLO in Development
- Dapper runtime
- EF Core solo migrations (design-time)

## PRE-CHECK
Tabella:
| Voce | Stato | Dettagli | Azione |

Verificare:
- Swagger dev-only
- DbContext NON registrato a runtime
- Dapper factory presente
- Schema setting Identity
- Porte/launchSettings ok

## Data model MVP (Dapper)
Tabelle nello schema `Identity` (minimo):
- `Users` (UserId uniqueidentifier PK, UserName nvarchar(100), Email nvarchar(256), PasswordHash nvarchar(400), IsActive bit, CreatedUtc datetime2)
- `Roles` (RoleId uniqueidentifier PK, Name nvarchar(100))
- `UserRoles` (UserId, RoleId PK composita)

## Implementazione
1) Feature VSA `Database/EnsureTables`
- Endpoint: `POST /db/ensure-tables` (Development-only)
- Crea tabelle se non esistono (Dapper)

2) Feature VSA `Auth/Register` (DEV-only, se implementata)
- Hash password con `PasswordHasher<>`
- Inserisce utente

3) Feature VSA `Auth/Login`
- Verifica credenziali
- Emissione JWT (claims: sub, name, email, roles)
- Restituisce `{ accessToken, expiresUtc }`

4) Feature VSA `Me/GetCurrentUser`
- Richiede auth
- Legge claims e (opzionale) carica ruoli con Dapper

5) JWT options
- `Jwt:Issuer`, `Jwt:Audience`, `Jwt:SigningKey`, `Jwt:ExpiresMinutes`
- Configurare JwtBearer.

6) Swagger dev-only
- Abilitare swagger solo in Development.

## POST-CHECK
- Build OK
- Avvio Identity (7001)
- Smoke:
  - `POST /db/ensure-schema` e `POST /db/ensure-tables` (DEV-only)
  - login e chiamata `/me` con Authorization Bearer
