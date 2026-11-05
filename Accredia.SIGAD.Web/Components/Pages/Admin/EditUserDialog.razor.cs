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

public partial class EditUserDialog : ComponentBase
{
[CascadingParameter] IMudDialogInstance MudDialog { get; set; } = null!;
    [Parameter] public UserListDto User { get; set; } = null!;

    private List<RoleDto> _availableRoles = new();
    private Dictionary<string, bool> _selectedRoles = new();
    private bool _isLoadingRoles;
    private bool _isSaving;
    private string? _errorMessage;

    protected override async Task OnInitializedAsync()
    {
        await LoadRolesAsync();
        InitializeSelectedRoles();
    }

    private async Task LoadRolesAsync()
    {
        _isLoadingRoles = true;
        try
        {
            var result = await AdminClient.GetAllRolesAsync();
            if (result.IsSuccess && result.Data != null)
            {
                _availableRoles = result.Data;
            }
            else
            {
                _errorMessage = "Impossibile caricare i ruoli disponibili";
            }
        }
        catch (Exception ex)
        {
            _errorMessage = $"Errore: {ex.Message}";
        }
        finally
        {
            _isLoadingRoles = false;
        }
    }

    private void InitializeSelectedRoles()
    {
        foreach (var role in _availableRoles)
        {
            _selectedRoles[role.Name] = User.Roles.Contains(role.Name);
        }
    }

    private async Task SaveRolesAsync()
    {
        _isSaving = true;
        try
        {
            var selectedRoleNames = _selectedRoles
                .Where(x => x.Value)
                .Select(x => x.Key)
                .ToList();

            var request = new UpdateUserRolesRequest(User.UserId, selectedRoleNames);
            var result = await AdminClient.UpdateUserRolesAsync(request);

            if (result.IsSuccess)
            {
                Snackbar.Add("Ruoli aggiornati con successo", Severity.Success);
                MudDialog.Close(DialogResult.Ok(true));
            }
            else
            {
                Snackbar.Add($"Errore: {result.Error}", Severity.Error);
            }
        }
        catch (Exception ex)
        {
            Snackbar.Add($"Errore: {ex.Message}", Severity.Error);
        }
        finally
        {
            _isSaving = false;
        }
    }

    private void Cancel() => MudDialog.Cancel();

    private string GetUserInitials()
    {
        if (string.IsNullOrWhiteSpace(User.Username)) return "?";
        var parts = User.Username.Split(' ', StringSplitOptions.RemoveEmptyEntries);
        if (parts.Length == 1)
            return parts[0][..Math.Min(2, parts[0].Length)].ToUpperInvariant();
        return string.Concat(parts[0][0], parts[^1][0]).ToUpperInvariant();
    }
}