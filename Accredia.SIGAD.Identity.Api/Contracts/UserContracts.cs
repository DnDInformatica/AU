namespace Accredia.SIGAD.Identity.Api.Contracts;

public record UserDto(
    string UserId,
    string? Username,
    string? Email,
    bool EmailConfirmed,
    bool LockoutEnabled,
    DateTimeOffset? LockoutEnd,
    int AccessFailedCount,
    IReadOnlyList<string> Roles);

public record UsersListResponse(
    IReadOnlyList<UserDto> Users,
    int TotalCount,
    int Page,
    int PageSize);

public record SetUserRolesRequest(IReadOnlyList<string> Roles);

public record SetUserRolesResponse(string UserId, int RemovedCount, int AddedCount);

