using Accredia.SIGAD.Identity.Api.Models;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;

namespace Accredia.SIGAD.Identity.Api.Data;

public static class IdentitySeeder
{
    public static async Task SeedAsync(IServiceProvider services)
    {
        using var scope = services.CreateScope();
        var db = scope.ServiceProvider.GetRequiredService<AppIdentityDbContext>();
        var roleManager = scope.ServiceProvider.GetRequiredService<RoleManager<IdentityRole>>();
        var userManager = scope.ServiceProvider.GetRequiredService<UserManager<ApplicationUser>>();

        await db.Database.MigrateAsync();

        var roles = new[]
        {
            "SIGAD_SUPERADMIN",
            "SIGAD_ADMIN",
            "SIGAD_OPERATORE",
            "SIGAD_LETTURA"
        };

        foreach (var role in roles)
        {
            if (!await roleManager.RoleExistsAsync(role))
            {
                await roleManager.CreateAsync(new IdentityRole(role));
            }
        }

        var permissions = BuildPermissions();
        if (!await db.Permissions.AnyAsync())
        {
            db.Permissions.AddRange(permissions);
            await db.SaveChangesAsync();
        }
        else
        {
            foreach (var perm in permissions)
            {
                var exists = await db.Permissions.AnyAsync(p => p.Code == perm.Code);
                if (!exists)
                {
                    db.Permissions.Add(perm);
                }
            }
            await db.SaveChangesAsync();
        }

        var superAdmin = await roleManager.FindByNameAsync("SIGAD_SUPERADMIN");
        if (superAdmin != null)
        {
            var superAdminPerms = await db.Permissions.Select(p => p.PermissionId).ToListAsync();
            var existing = await db.RolePermissions.Where(rp => rp.RoleId == superAdmin.Id).Select(rp => rp.PermissionId).ToListAsync();
            var missing = superAdminPerms.Except(existing).ToList();
            if (missing.Count > 0)
            {
                db.RolePermissions.AddRange(missing.Select(pid => new RolePermission { RoleId = superAdmin.Id, PermissionId = pid }));
                await db.SaveChangesAsync();
            }
        }

        await SeedOtherRolesAsync(roleManager, db);

        var adminUser = await userManager.FindByNameAsync("admin");
        if (adminUser == null)
        {
            adminUser = new ApplicationUser
            {
                UserName = "admin",
                Email = "admin@accredia.local",
                EmailConfirmed = true
            };

            var result = await userManager.CreateAsync(adminUser, "Password!12345");
            if (result.Succeeded)
            {
                await userManager.AddToRoleAsync(adminUser, "SIGAD_SUPERADMIN");
            }
        }
        else
        {
            if (!await userManager.IsInRoleAsync(adminUser, "SIGAD_SUPERADMIN"))
            {
                await userManager.AddToRoleAsync(adminUser, "SIGAD_SUPERADMIN");
            }
        }
    }

    private static List<Permission> BuildPermissions()
    {
        var now = DateTime.UtcNow;
        return new List<Permission>
        {
            NewPerm("MODULE.ORG.ACCESS", "Accesso modulo organizzazioni", "ORG", "MODULE", now),
            NewPerm("MODULE.PERS.ACCESS", "Accesso modulo persone", "PERS", "MODULE", now),
            NewPerm("MODULE.INC.ACCESS", "Accesso modulo incarichi", "INC", "MODULE", now),
            NewPerm("MODULE.TIPO.ACCESS", "Accesso modulo tipologie", "TIPO", "MODULE", now),
            NewPerm("MODULE.ADMIN.ACCESS", "Accesso modulo amministrazione", "ADMIN", "MODULE", now),

            NewPerm("ORG.LIST", "Elenco organizzazioni", "ORG", "ACTION", now),
            NewPerm("ORG.READ", "Lettura organizzazioni", "ORG", "ACTION", now),
            NewPerm("ORG.CREATE", "Creazione organizzazioni", "ORG", "ACTION", now),
            NewPerm("ORG.UPDATE", "Aggiornamento organizzazioni", "ORG", "ACTION", now),
            NewPerm("ORG.DELETE", "Cancellazione organizzazioni", "ORG", "ACTION", now),

            NewPerm("PERS.LIST", "Elenco persone", "PERS", "ACTION", now),
            NewPerm("PERS.READ", "Lettura persone", "PERS", "ACTION", now),
            NewPerm("PERS.CREATE", "Creazione persone", "PERS", "ACTION", now),
            NewPerm("PERS.UPDATE", "Aggiornamento persone", "PERS", "ACTION", now),
            NewPerm("PERS.DELETE", "Cancellazione persone", "PERS", "ACTION", now),

            NewPerm("INC.LIST", "Elenco incarichi", "INC", "ACTION", now),
            NewPerm("INC.READ", "Lettura incarichi", "INC", "ACTION", now),
            NewPerm("INC.CREATE", "Creazione incarichi", "INC", "ACTION", now),
            NewPerm("INC.UPDATE", "Aggiornamento incarichi", "INC", "ACTION", now),
            NewPerm("INC.DELETE", "Cancellazione incarichi", "INC", "ACTION", now),

            NewPerm("TIPO.LIST", "Elenco tipologie", "TIPO", "ACTION", now),
            NewPerm("TIPO.READ", "Lettura tipologie", "TIPO", "ACTION", now),
            NewPerm("TIPO.CREATE", "Creazione tipologie", "TIPO", "ACTION", now),
            NewPerm("TIPO.UPDATE", "Aggiornamento tipologie", "TIPO", "ACTION", now),
            NewPerm("TIPO.DELETE", "Cancellazione tipologie", "TIPO", "ACTION", now),

            NewPerm("ADMIN.USERS.MANAGE", "Gestione utenti", "ADMIN", "ACTION", now),
            NewPerm("ADMIN.PERMISSIONS.MANAGE", "Gestione permessi", "ADMIN", "ACTION", now),
            NewPerm("ADMIN.ROLES.MANAGE", "Gestione ruoli", "ADMIN", "ACTION", now)
        };
    }

    private static Permission NewPerm(string code, string description, string module, string scope, DateTime now)
    {
        return new Permission
        {
            Code = code,
            Description = description,
            Module = module,
            Scope = scope,
            Attivo = true,
            CreatedAt = now,
            CreatedBy = "seed",
            IsDeleted = false
        };
    }

    private static async Task SeedOtherRolesAsync(RoleManager<IdentityRole> roleManager, AppIdentityDbContext db)
    {
        var adminRole = await roleManager.FindByNameAsync("SIGAD_ADMIN");
        var operRole = await roleManager.FindByNameAsync("SIGAD_OPERATORE");
        var readRole = await roleManager.FindByNameAsync("SIGAD_LETTURA");

        if (adminRole != null)
        {
            await AssignPermissionsByCodesAsync(db, adminRole.Id, new[]
            {
                "MODULE.ORG.ACCESS", "MODULE.PERS.ACCESS", "MODULE.INC.ACCESS", "MODULE.TIPO.ACCESS", "MODULE.ADMIN.ACCESS",
                "ORG.LIST", "ORG.READ", "ORG.CREATE", "ORG.UPDATE", "ORG.DELETE",
                "PERS.LIST", "PERS.READ", "PERS.CREATE", "PERS.UPDATE", "PERS.DELETE",
                "INC.LIST", "INC.READ", "INC.CREATE", "INC.UPDATE", "INC.DELETE",
                "TIPO.LIST", "TIPO.READ", "TIPO.CREATE", "TIPO.UPDATE", "TIPO.DELETE",
                "ADMIN.USERS.MANAGE", "ADMIN.ROLES.MANAGE", "ADMIN.PERMISSIONS.MANAGE"
            });
        }

        if (operRole != null)
        {
            await AssignPermissionsByCodesAsync(db, operRole.Id, new[]
            {
                "MODULE.ORG.ACCESS", "MODULE.PERS.ACCESS", "MODULE.INC.ACCESS", "MODULE.TIPO.ACCESS",
                "ORG.LIST", "ORG.READ", "ORG.UPDATE",
                "PERS.LIST", "PERS.READ", "PERS.UPDATE",
                "INC.LIST", "INC.READ", "INC.UPDATE",
                "TIPO.LIST", "TIPO.READ", "TIPO.UPDATE"
            });
        }

        if (readRole != null)
        {
            await AssignPermissionsByCodesAsync(db, readRole.Id, new[]
            {
                "MODULE.ORG.ACCESS", "MODULE.PERS.ACCESS", "MODULE.INC.ACCESS", "MODULE.TIPO.ACCESS",
                "ORG.LIST", "ORG.READ",
                "PERS.LIST", "PERS.READ",
                "INC.LIST", "INC.READ",
                "TIPO.LIST", "TIPO.READ"
            });
        }
    }

    private static async Task AssignPermissionsByCodesAsync(AppIdentityDbContext db, string roleId, IEnumerable<string> codes)
    {
        var permissionIds = await db.Permissions
            .Where(p => codes.Contains(p.Code))
            .Select(p => p.PermissionId)
            .ToListAsync();

        var existing = await db.RolePermissions
            .Where(rp => rp.RoleId == roleId)
            .Select(rp => rp.PermissionId)
            .ToListAsync();

        var missing = permissionIds.Except(existing).ToList();
        if (missing.Count > 0)
        {
            db.RolePermissions.AddRange(missing.Select(pid => new RolePermission { RoleId = roleId, PermissionId = pid }));
            await db.SaveChangesAsync();
        }
    }
}
