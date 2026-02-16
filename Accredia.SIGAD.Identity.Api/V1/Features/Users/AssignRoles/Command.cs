namespace Accredia.SIGAD.Identity.Api.V1.Features.Users.AssignRoles;

internal sealed record Command(string UserId, IReadOnlyList<string> Roles);

internal sealed record AssignRolesRequest(IReadOnlyList<string> Roles);

internal sealed record AssignRolesResponse(string UserId, int AddedCount);
