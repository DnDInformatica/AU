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

namespace Accredia.SIGAD.Web.Components.Pages.Incarichi;

public partial class IncarichiFilters : ComponentBase
{
[Parameter] public string? Query { get; set; }
    [Parameter] public EventCallback<string?> QueryChanged { get; set; }

    [Parameter] public int ActiveFiltersCount { get; set; }

    [Parameter] public bool Expanded { get; set; }
    [Parameter] public EventCallback<bool> ExpandedChanged { get; set; }

    [Parameter] public EventCallback OnApply { get; set; }
    [Parameter] public EventCallback OnReset { get; set; }

    [Parameter] public EventCallback<MudTextField<string>?> QueryFieldRefChanged { get; set; }
    private MudTextField<string>? _queryField;

    private string? _localQuery;
    private bool _hasPendingChanges;

    protected override Task OnAfterRenderAsync(bool firstRender)
        => firstRender ? QueryFieldRefChanged.InvokeAsync(_queryField) : Task.CompletedTask;

    protected override void OnParametersSet()
    {
        if (_hasPendingChanges)
        {
            return;
        }

        _localQuery = Query;
    }

    private Task OnLocalQueryChanged(string? value)
    {
        _localQuery = value;
        _hasPendingChanges = true;
        return InvokeAsync(StateHasChanged);
    }

    private void ClearLocalQuery()
    {
        _localQuery = null;
        _hasPendingChanges = true;
        _ = HandleLocalClearedAsync();
    }

    private bool HasLocalFilters()
        => !string.IsNullOrWhiteSpace(_localQuery);

    private async Task HandleLocalClearedAsync()
    {
        if (!HasLocalFilters())
        {
            await ResetLocalAsync();
            return;
        }

        await InvokeAsync(StateHasChanged);
    }

    private async Task ApplyLocalAsync()
    {
        _hasPendingChanges = false;
        await QueryChanged.InvokeAsync(_localQuery);

        if (OnApply.HasDelegate)
        {
            await OnApply.InvokeAsync();
        }
    }

    private async Task ResetLocalAsync()
    {
        _localQuery = null;
        _hasPendingChanges = false;

        await QueryChanged.InvokeAsync(null);

        if (OnReset.HasDelegate)
        {
            await OnReset.InvokeAsync();
        }
    }

    private Task OnSearchKeyDown(KeyboardEventArgs args)
        => args.Key == "Enter" ? ApplyLocalAsync() : Task.CompletedTask;

    private static string BuildShortQueryLabel(string? value)
    {
        var v = (value ?? string.Empty).Trim();
        return v.Length <= 24 ? v : v[..21] + "...";
    }
}