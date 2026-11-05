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

public partial class BulkLogoutDialog : ComponentBase
{
[CascadingParameter] IMudDialogInstance MudDialog { get; set; } = null!;
    [Parameter] public List<UserListDto> Users { get; set; } = new();

    private string _reason = string.Empty;
    private bool _isExecuting;

    private async Task ExecuteBulkLogoutAsync()
    {
        _isExecuting = true;
        try
        {
            var userIds = Users.Select(u => u.UserId).ToList();
            var request = new LogoutUsersRequest(userIds);
            
            var result = await AdminClient.BulkLogoutAsync(request);

            if (result.IsSuccess)
            {
                Snackbar.Add($"{Users.Count} utenti disconnessi con successo", Severity.Success);
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
            _isExecuting = false;
        }
    }

    private void Cancel() => MudDialog.Cancel();

    private string GetUserInitials(string username)
    {
        if (string.IsNullOrWhiteSpace(username)) return "?";
        var parts = username.Split(' ', StringSplitOptions.RemoveEmptyEntries);
        if (parts.Length == 1)
            return parts[0][..Math.Min(2, parts[0].Length)].ToUpperInvariant();
        return string.Concat(parts[0][0], parts[^1][0]).ToUpperInvariant();
    }
}