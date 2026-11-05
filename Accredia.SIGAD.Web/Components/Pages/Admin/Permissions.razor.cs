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

public partial class Permissions : ComponentBase
{
private bool _isLoading;
    private string? _error;
    private string _filter = string.Empty;
    private List<PermissionDto> _permissions = new();

    private IEnumerable<PermissionDto> Filtered
    {
        get
        {
            if (string.IsNullOrWhiteSpace(_filter))
            {
                return _permissions;
            }

            var term = _filter.Trim();
            return _permissions.Where(p =>
                p.Code.Contains(term, StringComparison.OrdinalIgnoreCase)
                || p.Module.Contains(term, StringComparison.OrdinalIgnoreCase)
                || p.Scope.Contains(term, StringComparison.OrdinalIgnoreCase)
                || (p.Description?.Contains(term, StringComparison.OrdinalIgnoreCase) ?? false));
        }
    }

    protected override async Task OnInitializedAsync()
        => await LoadAsync();

    private async Task LoadAsync()
    {
        _isLoading = true;
        _error = null;
        try
        {
            var result = await AdminClient.GetPermissionsAsync(CancellationToken.None);
            if (result.IsSuccess && result.Data is not null)
            {
                _permissions = result.Data
                    .OrderBy(p => p.Module)
                    .ThenBy(p => p.Code)
                    .ToList();
                return;
            }

            _error = result.Error ?? "Impossibile caricare i permessi.";
        }
        catch (Exception ex)
        {
            _error = ex.Message;
        }
        finally
        {
            _isLoading = false;
        }
    }
}