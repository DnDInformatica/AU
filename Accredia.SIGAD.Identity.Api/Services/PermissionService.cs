using Accredia.SIGAD.Identity.Api.Data;
using Microsoft.Extensions.Logging;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace Accredia.SIGAD.Identity.Api.Services;

public interface IPermissionService
{
    Task<IReadOnlyList<string>> GetPermissionsForUserAsync(string userId);
    Task<IReadOnlyList<string>> GetPermissionsForRoleAsync(string roleId);
}

public class PermissionService : IPermissionService
{
    private readonly AppIdentityDbContext _db;
    private readonly UserManager<Models.ApplicationUser> _userManager;
    private readonly RoleManager<IdentityRole> _roleManager;
    private readonly ILogger<PermissionService> _logger;

    public PermissionService(
        AppIdentityDbContext db,
        UserManager<Models.ApplicationUser> userManager,
        RoleManager<IdentityRole> roleManager,
        ILogger<PermissionService> logger)
    {
        _db = db;
        _userManager = userManager;
        _roleManager = roleManager;
        _logger = logger;
    }

    public async Task<IReadOnlyList<string>> GetPermissionsForUserAsync(string userId)
    {
        using var scope = AuthAudit.BeginScope(_logger, "UserPermissions", userId: userId);
        var user = await _userManager.FindByIdAsync(userId);
        if (user == null)
        {
            return Array.Empty<string>();
        }

        var roles = await _userManager.GetRolesAsync(user);
        if (roles.Count == 0)
        {
            return Array.Empty<string>();
        }

        var roleIds = await _roleManager.Roles
            .Where(r => roles.Contains(r.Name!))
            .Select(r => r.Id)
            .ToListAsync();

        if (roleIds.Count == 0)
        {
            return Array.Empty<string>();
        }

        var permissions = await _db.RolePermissions
            .Where(rp => roleIds.Contains(rp.RoleId))
            .Select(rp => rp.Permission!.Code)
            .Distinct()
            .ToListAsync();

        _logger.LogInformation(AuthAudit.Events.UserPermissionsFetched, "UserPermissionsFetched count={Count}", permissions.Count);
        return permissions;
    }

    public async Task<IReadOnlyList<string>> GetPermissionsForRoleAsync(string roleId)
    {
        using var scope = AuthAudit.BeginScope(_logger, "RolePermissions", roleId: roleId);
        var permissions = await _db.RolePermissions
            .Where(rp => rp.RoleId == roleId)
            .Select(rp => rp.Permission!.Code)
            .Distinct()
            .ToListAsync();

        _logger.LogInformation(AuthAudit.Events.RolePermissionsFetched, "RolePermissionsFetched count={Count}", permissions.Count);
        return permissions;
    }
}
