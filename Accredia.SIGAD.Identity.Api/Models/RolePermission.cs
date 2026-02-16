using Microsoft.AspNetCore.Identity;

namespace Accredia.SIGAD.Identity.Api.Models;

public class RolePermission
{
    public string RoleId { get; set; } = string.Empty;
    public int PermissionId { get; set; }

    public IdentityRole? Role { get; set; }
    public Permission? Permission { get; set; }
}
