using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Routing;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.JSInterop;
using MudBlazor;
using Accredia.SIGAD.Web.Auth;
using Accredia.SIGAD.Web.Models.Admin;
using Accredia.SIGAD.Web.Models.Anagrafiche;
using Accredia.SIGAD.Web.Models.Auth;
using Accredia.SIGAD.Web.Models.Common;
using Accredia.SIGAD.Web.Models.RisorseUmane;
using Accredia.SIGAD.Web.Models.Search;
using Accredia.SIGAD.Web.Models.Tipologiche;
using Accredia.SIGAD.Web.Services;
using BreadcrumbItem = Accredia.SIGAD.Web.Models.Common.BreadcrumbItem;

namespace Accredia.SIGAD.Web.Components.Pages.Admin;

public partial class Roles : ComponentBase
{
private bool _isLoading;
    private bool _isSaving;

    private bool _rolesLoading;
    private string? _rolesError;
    private List<RoleDto> _roles = new();
    private string _roleFilter = string.Empty;
    private RoleDto? _selectedRole;

    private bool _permissionsLoading;
    private string? _permissionsError;
    private List<PermissionDto> _allPermissions = new();
    private string _permissionFilter = string.Empty;
    private HashSet<string> _selectedPermissions = new(StringComparer.OrdinalIgnoreCase);

    private bool CanEditPermissions => UserContext.HasPermission("IAM.PERMISSIONS.MANAGE");

    private IEnumerable<RoleDto> FilteredRoles =>
        string.IsNullOrWhiteSpace(_roleFilter)
            ? _roles
            : _roles.Where(r => r.Name.Contains(_roleFilter, StringComparison.OrdinalIgnoreCase));

    private IReadOnlyDictionary<string, List<PermissionDto>> GroupedPermissions
    {
        get
        {
            IEnumerable<PermissionDto> source = _allPermissions;

            if (!string.IsNullOrWhiteSpace(_permissionFilter))
            {
                var term = _permissionFilter.Trim();
                source = source.Where(p =>
                    p.Code.Contains(term, StringComparison.OrdinalIgnoreCase)
                    || p.Module.Contains(term, StringComparison.OrdinalIgnoreCase)
                    || (p.Description?.Contains(term, StringComparison.OrdinalIgnoreCase) ?? false));
            }

            return source
                .GroupBy(p => string.IsNullOrWhiteSpace(p.Module) ? "ALTRO" : p.Module.ToUpperInvariant())
                .OrderBy(g => g.Key)
                .ToDictionary(g => g.Key, g => g.OrderBy(p => p.Code).ToList());
        }
    }

    protected override async Task OnInitializedAsync()
        => await ReloadAsync();

    private async Task ReloadAsync()
    {
        _isLoading = true;
        try
        {
            await LoadRolesAsync();
            await LoadAllPermissionsAsync();

            // Keep selection consistent if role still exists.
            if (_selectedRole is not null)
            {
                var stillExists = _roles.FirstOrDefault(r => string.Equals(r.RoleId, _selectedRole.RoleId, StringComparison.OrdinalIgnoreCase));
                if (stillExists is null)
                {
                    ClearSelection();
                }
                else
                {
                    _selectedRole = stillExists;
                    await LoadSelectedRolePermissionsAsync(_selectedRole);
                }
            }
        }
        finally
        {
            _isLoading = false;
        }
    }

    private async Task LoadRolesAsync()
    {
        _rolesLoading = true;
        _rolesError = null;
        try
        {
            var result = await AdminClient.GetRolesAsync(CancellationToken.None);
            if (result.IsSuccess && result.Data is not null)
            {
                _roles = result.Data.OrderBy(r => r.Name).ToList();
            }
            else
            {
                _rolesError = result.Error ?? "Impossibile caricare i ruoli.";
            }
        }
        catch (Exception ex)
        {
            _rolesError = ex.Message;
        }
        finally
        {
            _rolesLoading = false;
        }
    }

    private async Task LoadAllPermissionsAsync()
    {
        var result = await AdminClient.GetPermissionsAsync(CancellationToken.None);
        if (result.IsSuccess && result.Data is not null)
        {
            _allPermissions = result.Data.OrderBy(p => p.Module).ThenBy(p => p.Code).ToList();
            return;
        }

        // Keep the page usable even if permissions list fails; the role permissions call will show assigned codes anyway.
        _allPermissions = new List<PermissionDto>();
        Snackbar.Add(result.Error ?? "Impossibile caricare l'elenco permessi.", Severity.Warning);
    }

    private async Task SelectRoleAsync(RoleDto role)
    {
        _selectedRole = role;
        await LoadSelectedRolePermissionsAsync(role);
    }

    private async Task LoadSelectedRolePermissionsAsync(RoleDto role)
    {
        _permissionsLoading = true;
        _permissionsError = null;
        _selectedPermissions.Clear();

        try
        {
            var result = await AdminClient.GetRolePermissionsAsync(role.RoleId, CancellationToken.None);
            if (result.IsSuccess && result.Data is not null)
            {
                foreach (var p in result.Data.Permissions)
                {
                    if (!string.IsNullOrWhiteSpace(p))
                    {
                        _selectedPermissions.Add(p);
                    }
                }
            }
            else
            {
                _permissionsError = result.Error ?? "Impossibile caricare i permessi del ruolo.";
            }
        }
        catch (Exception ex)
        {
            _permissionsError = ex.Message;
        }
        finally
        {
            _permissionsLoading = false;
        }
    }

    private void ClearSelection()
    {
        _selectedRole = null;
        _selectedPermissions.Clear();
        _permissionFilter = string.Empty;
    }

    private void OnPermissionToggled(string code, bool isChecked)
    {
        if (string.IsNullOrWhiteSpace(code))
        {
            return;
        }

        if (isChecked)
        {
            _selectedPermissions.Add(code);
        }
        else
        {
            _selectedPermissions.Remove(code);
        }
    }

    private async Task SaveAsync()
    {
        if (_selectedRole is null)
        {
            return;
        }

        if (!CanEditPermissions)
        {
            Snackbar.Add("Accesso negato: manca il permesso ADMIN.PERMISSIONS.MANAGE.", Severity.Error);
            return;
        }

        _isSaving = true;
        try
        {
            var payload = _selectedPermissions.OrderBy(x => x).ToList();
            var result = await AdminClient.UpdateRolePermissionsAsync(_selectedRole.RoleId, payload, CancellationToken.None);
            if (result.IsSuccess)
            {
                Snackbar.Add("Permessi aggiornati.", Severity.Success);
            }
            else
            {
                Snackbar.Add(result.Error ?? "Errore durante il salvataggio.", Severity.Error);
            }
        }
        catch (Exception ex)
        {
            Snackbar.Add(ex.Message, Severity.Error);
        }
        finally
        {
            _isSaving = false;
        }
    }
}