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
using Accredia.SIGAD.Shared.Permessi;

namespace Accredia.SIGAD.Web.Components.Pages.Incarichi;

public partial class Dettaglio : ComponentBase
{
    private bool CanRead => UserContext.HasPermission(PermessiSigad.Incarichi.Elenco) || UserContext.HasPermission(PermessiSigad.Incarichi.Lettura);
    private bool CanUpdate => UserContext.HasPermission(PermessiSigad.Incarichi.Modifica);
    private bool CanDelete => UserContext.HasPermission(PermessiSigad.Incarichi.Cancellazione);

    [Parameter] public int Id { get; set; }

    private IReadOnlyList<BreadcrumbItem> _breadcrumbs => new BreadcrumbItem[]
    {
        new("Home", "/"),
        new("Incarichi", "/incarichi"),
        new($"#{Id}")
    };

    private bool _isLoading = true;
    private string? _errorMessage;
    private IncaricoDetail? _detail;

    protected override async Task OnParametersSetAsync()
    {
        if (!CanRead)
        {
            _isLoading = false;
            _errorMessage = null;
            return;
        }

        await ReloadAsync();
    }

    private async Task ReloadAsync()
    {
        _isLoading = true;
        _errorMessage = null;
        _detail = null;

        try
        {
            var result = await GatewayClient.GetIncaricoDetailAsync(Id, CancellationToken.None);
            if (!result.IsSuccess || result.Data is null)
            {
                _errorMessage = result.Error ?? "Impossibile caricare il dettaglio incarico.";
                return;
            }

            _detail = result.Data;
        }
        catch (Exception ex)
        {
            _errorMessage = MessaggioErroreApi.Da(ex);
        }
        finally
        {
            _isLoading = false;
        }
    }

    private void GoToEdit()
    {
        if (!CanUpdate)
        {
            _errorMessage = "Il tuo profilo non consente di modificare gli incarichi.";
            return;
        }

        Navigation.NavigateTo($"/incarichi/{Id}/modifica");
    }

    private async Task SoftDeleteAsync()
    {
        if (!CanDelete)
        {
            _errorMessage = "Il tuo profilo non consente di eliminare gli incarichi.";
            return;
        }

        if (_detail is null || _detail.DataCancellazione.HasValue)
        {
            return;
        }

        var confirm = await DialogService.ShowMessageBox(
            "Conferma eliminazione",
            "Vuoi eliminare questo incarico? Resterà nello storico.",
            yesText: "Elimina",
            cancelText: "Annulla");

        if (confirm != true)
        {
            return;
        }

        var result = await GatewayClient.SoftDeleteIncaricoAsync(Id, CancellationToken.None);
        if (result.IsSuccess)
        {
            Snackbar.Add("Incarico eliminato.", Severity.Success);
            Navigation.NavigateTo("/incarichi");
            return;
        }

        _errorMessage = result.Error ?? "Eliminazione incarico non riuscita.";
    }

    private static string FormatDate(DateTime? value)
        => value is null ? "—" : value.Value.ToString("dd/MM/yyyy");
}
