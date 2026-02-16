# Identity + JWT Authentication

Implementa Identity.Api con JWT authentication in VSA.

## OBIETTIVO
- Schema DB `Identity` (tabelle MVP)
- JWT login con access token
- Endpoints VSA

## DATA MODEL (schema Identity)
```sql
CREATE TABLE Identity.Users (
    UserId UNIQUEIDENTIFIER PRIMARY KEY,
    UserName NVARCHAR(100),
    Email NVARCHAR(256),
    PasswordHash NVARCHAR(400),
    IsActive BIT,
    CreatedUtc DATETIME2
);

CREATE TABLE Identity.Roles (
    RoleId UNIQUEIDENTIFIER PRIMARY KEY,
    Name NVARCHAR(100)
);

CREATE TABLE Identity.UserRoles (
    UserId UNIQUEIDENTIFIER,
    RoleId UNIQUEIDENTIFIER,
    PRIMARY KEY (UserId, RoleId)
);
```

## ENDPOINTS VSA
- `POST /auth/register` (DEV-only)
- `POST /auth/login` → { accessToken, expiresUtc }
- `GET /me` (requires auth)

## JWT CONFIG
```json
{
  "Jwt": {
    "Issuer": "Accredia.SIGAD",
    "Audience": "Accredia.SIGAD.Clients",
    "SigningKey": "...",
    "ExpiresMinutes": 60
  }
}
```

## REGOLE
- Dapper per accesso dati
- Swagger SOLO in Development
- DbContext NON registrato a runtime
- Password hash con PasswordHasher<>

## FEATURES VSA
```
Features/
├── Database/
│   ├── EnsureSchema/
│   └── EnsureTables/
├── Auth/
│   ├── Register/
│   └── Login/
└── Me/
    └── GetCurrentUser/
```

## POST-CHECK
- dotnet build
- Test login + /me con Bearer token
