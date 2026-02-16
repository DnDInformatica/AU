namespace Accredia.SIGAD.Identity.Api.Contracts;

public record MeResponse(string UserId, string Username, IReadOnlyList<string> Roles, IReadOnlyList<string> Permissions);

public record PermissionDto(int PermissionId, string Code, string Description, string Module, string Scope, bool Attivo);

public record RoleDto(string RoleId, string Name);

public record RolePermissionsResponse(string RoleId, string RoleName, IReadOnlyList<string> Permissions);

public record UpdateRolePermissionsRequest(IReadOnlyList<string> Permissions);
