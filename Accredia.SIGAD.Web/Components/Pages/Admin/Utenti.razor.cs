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

public partial class Utenti : ComponentBase
{
private List<UserListDto> _users = new();
    private HashSet<UserListDto> _selectedUsers = new();
    private string _searchTerm = string.Empty;
    private bool _isLoading;
    private string? _error;
    private System.Timers.Timer? _searchDebounceTimer;

    private IEnumerable<UserListDto> FilteredUsers
    {
        get
        {
            if (string.IsNullOrWhiteSpace(_searchTerm))
                return _users;

            var term = _searchTerm.ToLowerInvariant();
            return _users.Where(u =>
                (u.Username?.Contains(term, StringComparison.OrdinalIgnoreCase) ?? false)
                || (u.Email?.Contains(term, StringComparison.OrdinalIgnoreCase) ?? false)
                || u.Roles.Any(r => r.Contains(term, StringComparison.OrdinalIgnoreCase)));
        }
    }

    protected override async Task OnInitializedAsync()
    {
        await LoadUsersAsync();
    }

    private void OnSearchChanged()
    {
        _searchDebounceTimer?.Stop();
        _searchDebounceTimer = new System.Timers.Timer(300);
        _searchDebounceTimer.Elapsed += async (sender, e) =>
        {
            _searchDebounceTimer.Stop();
            await InvokeAsync(StateHasChanged);
        };
        _searchDebounceTimer.Start();
    }

    private async Task LoadUsersAsync()
    {
        _isLoading = true;
        _error = null;
        try
        {
            var result = await AdminClient.GetAllUsersAsync();
            if (result.IsSuccess && result.Data != null)
            {
                _users = result.Data;
                _selectedUsers.Clear();
            }
            else
            {
                _error = result.Error ?? "Errore durante il caricamento degli utenti.";
                Snackbar.Add(_error, Severity.Error);
            }
        }
        catch (Exception ex)
        {
            _error = MessaggioErroreApi.Da(ex);
            Snackbar.Add(MessaggioErroreApi.Da(ex), Severity.Error);
        }
        finally
        {
            _isLoading = false;
        }
    }

    private async Task ShowEditRolesDialogAsync(UserListDto user)
    {
        var parameters = new DialogParameters<EditUserDialog>
        {
            { x => x.User, user }
        };

        var dialog = await DialogService.ShowAsync<EditUserDialog>("Modifica Ruoli Utente", parameters);
        var result = await dialog.Result;

        if (!result.Canceled)
        {
            await LoadUsersAsync();
            Snackbar.Add($"Ruoli di {user.Username} aggiornati con successo", Severity.Success);
        }
    }

    private async Task ShowBulkLogoutDialogAsync()
    {
        var parameters = new DialogParameters<BulkLogoutDialog>
        {
            { x => x.Users, _selectedUsers.ToList() }
        };

        var dialog = await DialogService.ShowAsync<BulkLogoutDialog>("Logout Multiplo", parameters);
        var result = await dialog.Result;

        if (!result.Canceled)
        {
            await LoadUsersAsync();
            Snackbar.Add($"{_selectedUsers.Count} utenti disconnessi con successo", Severity.Success);
        }
    }

    private async Task LogoutUserAsync(string userId)
    {
        var user = _users.FirstOrDefault(u => u.UserId == userId);
        if (user == null) return;

        var confirm = await DialogService.ShowMessageBox(
            "Conferma Logout",
            $"Sei sicuro di voler disconnettere {user.Username}?",
            yesText: "Conferma", cancelText: "Annulla");

        if (confirm != true) return;

        try
        {
            var result = await AdminClient.LogoutUserAsync(userId);
            if (result.IsSuccess)
            {
                Snackbar.Add($"{user.Username} disconnesso con successo", Severity.Success);
                await LoadUsersAsync();
            }
            else
            {
                Snackbar.Add($"Errore: {result.Error}", Severity.Error);
            }
        }
        catch (Exception ex)
        {
            Snackbar.Add(MessaggioErroreApi.Da(ex), Severity.Error);
        }
    }

    private static bool IsLocked(UserListDto user)
    {
        if (!user.LockoutEnabled)
        {
            return false;
        }

        return user.LockoutEnd.HasValue && user.LockoutEnd.Value > DateTimeOffset.UtcNow;
    }

    private string GetUserInitials(string username)
    {
        if (string.IsNullOrWhiteSpace(username)) return "?";
        var parts = username.Split(' ', StringSplitOptions.RemoveEmptyEntries);
        if (parts.Length == 1)
            return parts[0][..Math.Min(2, parts[0].Length)].ToUpperInvariant();
        return string.Concat(parts[0][0], parts[^1][0]).ToUpperInvariant();
    }

    private Color GetRoleColor(string role) => role switch
    {
        var r when r.Contains("SUPERADMIN") => Color.Error,
        var r when r.Contains("ADMIN") => Color.Warning,
        var r when r.Contains("OPERATORE") => Color.Info,
        _ => Color.Default
    };

    private string GetRoleIcon(string role) => role switch
    {
        var r when r.Contains("SUPERADMIN") => Icons.Material.Filled.SupervisedUserCircle,
        var r when r.Contains("ADMIN") => Icons.Material.Filled.AdminPanelSettings,
        var r when r.Contains("OPERATORE") => Icons.Material.Filled.Work,
        _ => Icons.Material.Filled.Person
    };

    public void Dispose()
    {
        _searchDebounceTimer?.Dispose();
    }
}