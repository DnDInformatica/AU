using Microsoft.Extensions.Logging;

namespace Accredia.SIGAD.Identity.Api.Services;

internal static class AuthAudit
{
    internal static class Events
    {
        public static readonly EventId LoginValidationFailed = new(1000, "AuthLoginValidationFailed");
        public static readonly EventId LoginFailed = new(1001, "AuthLoginFailed");
        public static readonly EventId LoginSucceeded = new(1002, "AuthLoginSucceeded");

        public static readonly EventId RefreshValidationFailed = new(1100, "AuthRefreshValidationFailed");
        public static readonly EventId RefreshFailed = new(1101, "AuthRefreshFailed");
        public static readonly EventId RefreshSucceeded = new(1102, "AuthRefreshSucceeded");

        public static readonly EventId LogoutValidationFailed = new(1200, "AuthLogoutValidationFailed");
        public static readonly EventId LogoutFailed = new(1201, "AuthLogoutFailed");
        public static readonly EventId LogoutSucceeded = new(1202, "AuthLogoutSucceeded");

        public static readonly EventId LogoutAllFailedMissingUser = new(1300, "AuthLogoutAllFailedMissingUser");
        public static readonly EventId LogoutAllSucceeded = new(1301, "AuthLogoutAllSucceeded");

        public static readonly EventId LogoutUserValidationFailed = new(1400, "AuthLogoutUserValidationFailed");
        public static readonly EventId LogoutUserSucceeded = new(1401, "AuthLogoutUserSucceeded");

        public static readonly EventId LogoutUsersValidationFailed = new(1500, "AuthLogoutUsersValidationFailed");
        public static readonly EventId LogoutUsersSucceeded = new(1501, "AuthLogoutUsersSucceeded");

        public static readonly EventId MeAccessFailedMissingUser = new(1600, "MeAccessFailedMissingUser");
        public static readonly EventId MeAccessNotFound = new(1601, "MeAccessNotFound");
        public static readonly EventId MeAccessSucceeded = new(1602, "MeAccessSucceeded");

        public static readonly EventId UserPermissionsFetched = new(2000, "UserPermissionsFetched");
        public static readonly EventId RolePermissionsFetched = new(2001, "RolePermissionsFetched");
        public static readonly EventId PermissionsListed = new(2100, "PermissionsListed");
        public static readonly EventId RolesListed = new(2101, "RolesListed");
        public static readonly EventId RolePermissionsNotFound = new(2102, "RolePermissionsNotFound");
        public static readonly EventId RolePermissionsValidationFailed = new(2103, "RolePermissionsValidationFailed");
        public static readonly EventId RolePermissionsUpdated = new(2104, "RolePermissionsUpdated");

        public static readonly EventId AssignRolesValidationFailed = new(2200, "AssignRolesValidationFailed");
        public static readonly EventId AssignRolesSucceeded = new(2201, "AssignRolesSucceeded");
    }

    public static IDisposable BeginScope(
        ILogger logger,
        string action,
        string? userId = null,
        string? userName = null,
        int? userCount = null,
        string? roleId = null)
    {
        var scope = new Dictionary<string, object>(StringComparer.Ordinal)
        {
            ["AuthAction"] = action
        };

        if (!string.IsNullOrWhiteSpace(userId))
        {
            scope["UserId"] = userId;
        }

        if (!string.IsNullOrWhiteSpace(userName))
        {
            scope["UserName"] = userName;
        }

        if (userCount.HasValue)
        {
            scope["UserCount"] = userCount.Value;
        }

        if (!string.IsNullOrWhiteSpace(roleId))
        {
            scope["RoleId"] = roleId;
        }

        return logger.BeginScope(scope) ?? NullScope.Instance;
    }

    private sealed class NullScope : IDisposable
    {
        public static readonly NullScope Instance = new();
        public void Dispose() { }
    }
}
