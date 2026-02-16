using System.Security.Claims;
using Microsoft.AspNetCore.Authorization;

namespace Accredia.SIGAD.Identity.Api.Services;

public class PermissionRequirement : IAuthorizationRequirement
{
    public PermissionRequirement(string permission)
    {
        Permission = permission;
    }

    public string Permission { get; }
}

public class PermissionHandler : AuthorizationHandler<PermissionRequirement>
{
    protected override Task HandleRequirementAsync(AuthorizationHandlerContext context, PermissionRequirement requirement)
    {
        if (context.User.IsInRole("SIGAD_SUPERADMIN"))
        {
            context.Succeed(requirement);
            return Task.CompletedTask;
        }

        var hasPerm = context.User.Claims.Any(c => c.Type == "perm" && c.Value == requirement.Permission);
        if (hasPerm)
        {
            context.Succeed(requirement);
        }

        return Task.CompletedTask;
    }
}
