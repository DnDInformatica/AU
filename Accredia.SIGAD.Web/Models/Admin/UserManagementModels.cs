using System.Text.Json.Serialization;

namespace Accredia.SIGAD.Web.Models.Admin;

/// <summary>
/// Rappresenta un utente nella lista (Admin).
/// Allineato ai contratti esposti da Identity API.
/// </summary>
public sealed class UserListDto
{
    [JsonPropertyName("userId")]
    public required string UserId { get; init; }

    [JsonPropertyName("username")]
    public string? Username { get; init; }

    [JsonPropertyName("email")]
    public string? Email { get; init; }

    [JsonPropertyName("emailConfirmed")]
    public bool EmailConfirmed { get; init; }

    [JsonPropertyName("lockoutEnabled")]
    public bool LockoutEnabled { get; init; }

    [JsonPropertyName("lockoutEnd")]
    public DateTimeOffset? LockoutEnd { get; init; }

    [JsonPropertyName("accessFailedCount")]
    public int AccessFailedCount { get; init; }

    [JsonPropertyName("roles")]
    public List<string> Roles { get; init; } = new();
}

/// <summary>
/// Lista paginata di utenti.
/// </summary>
public sealed class UsersListResponse
{
    [JsonPropertyName("users")]
    public required List<UserListDto> Users { get; init; }

    [JsonPropertyName("totalCount")]
    public int TotalCount { get; init; }

    [JsonPropertyName("page")]
    public int Page { get; init; }

    [JsonPropertyName("pageSize")]
    public int PageSize { get; init; }
}

/// <summary>
/// Request per aggiornare i ruoli di un utente (by role names)
/// </summary>
public sealed class UpdateUserRolesRequest
{
    public UpdateUserRolesRequest(string userId, List<string> roleNames)
    {
        UserId = userId;
        RoleNames = roleNames;
    }

    [JsonPropertyName("userId")]
    public string UserId { get; init; }

    [JsonPropertyName("roleNames")]
    public List<string> RoleNames { get; init; }
}

/// <summary>
/// Request per assegnare ruoli a un utente (Identity API contract).
/// </summary>
public sealed class SetUserRolesRequest
{
    [JsonPropertyName("roles")]
    public required List<string> Roles { get; init; }
}

/// <summary>
/// Request per logout bulk di utenti (Identity API contract).
/// </summary>
public sealed class LogoutUsersRequest
{
    public LogoutUsersRequest(List<string> userIds)
    {
        UserIds = userIds;
    }

    [JsonPropertyName("userIds")]
    public List<string> UserIds { get; init; }
}

/// <summary>
/// Rappresenta un ruolo nel sistema (Identity API contract).
/// </summary>
public sealed class RoleDto
{
    [JsonPropertyName("roleId")]
    public required string RoleId { get; init; }

    [JsonPropertyName("name")]
    public required string Name { get; init; }
}

/// <summary>
/// Response: permessi assegnati a un ruolo (Identity API contract).
/// </summary>
public sealed class RolePermissionsResponse
{
    [JsonPropertyName("roleId")]
    public required string RoleId { get; init; }

    [JsonPropertyName("roleName")]
    public required string RoleName { get; init; }

    [JsonPropertyName("permissions")]
    public required List<string> Permissions { get; init; }
}

/// <summary>
/// Request per aggiornare i permessi di un ruolo
/// </summary>
public sealed class UpdateRolePermissionsRequest
{
    [JsonPropertyName("permissions")]
    public required List<string> Permissions { get; init; }
}

/// <summary>
/// Rappresenta un permesso nel sistema (Identity API contract).
/// </summary>
public sealed class PermissionDto
{
    [JsonPropertyName("permissionId")]
    public int PermissionId { get; init; }

    [JsonPropertyName("code")]
    public required string Code { get; init; }

    [JsonPropertyName("module")]
    public required string Module { get; init; }

    [JsonPropertyName("scope")]
    public required string Scope { get; init; }

    [JsonPropertyName("description")]
    public string? Description { get; init; }

    [JsonPropertyName("attivo")]
    public bool Attivo { get; init; }
}
