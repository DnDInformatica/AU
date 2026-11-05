using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Routing;
using Microsoft.JSInterop;
using MudBlazor;
using Accredia.SIGAD.Web.Models.Anagrafiche;
using Accredia.SIGAD.Web.Models.Common;
using Accredia.SIGAD.Web.Models.Search;
using Accredia.SIGAD.Web.Models.Tipologiche;
using Accredia.SIGAD.Web.Services;
using BreadcrumbItem = Accredia.SIGAD.Web.Models.Common.BreadcrumbItem;

namespace Accredia.SIGAD.Web.Components.Layout;

public partial class QuickDrawerHost : ComponentBase
{
protected override void OnInitialized()
    {
        DrawerService.Changed += OnChanged;
    }

    private void OnChanged()
        => InvokeAsync(StateHasChanged);

    private void Close()
        => DrawerService.Close();

    private void OnOpenChanged(bool open)
    {
        if (!open)
        {
            DrawerService.Close();
        }
    }

    public void Dispose()
    {
        DrawerService.Changed -= OnChanged;
    }
}