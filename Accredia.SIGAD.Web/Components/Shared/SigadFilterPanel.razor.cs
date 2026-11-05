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

namespace Accredia.SIGAD.Web.Components.Shared;

public partial class SigadFilterPanel : ComponentBase
{
[Parameter] public string Title { get; set; } = "Filtri";
    [Parameter] public string? TitleIcon { get; set; }
    [Parameter] public bool WrapTitleTemplate { get; set; } = true;

    [Parameter] public RenderFragment? TitleTemplate { get; set; }
    [Parameter] public RenderFragment? HeaderActions { get; set; }
    [Parameter] public RenderFragment? ActionContent { get; set; }
    [Parameter] public RenderFragment? ChildContent { get; set; }
    [Parameter] public RenderFragment? ActiveChips { get; set; }
    [Parameter] public RenderFragment? ChipContent { get; set; }
    [Parameter] public List<FilterDefinition>? Filters { get; set; }
    [Parameter] public List<FilterChip>? ActiveFilterChips { get; set; }
    [Parameter] public EventCallback OnApply { get; set; }
    [Parameter] public EventCallback OnReset { get; set; }
    [Parameter] public EventCallback<FilterChip> OnChipRemove { get; set; }
    [Parameter] public bool Expanded { get; set; }
    [Parameter] public EventCallback<bool> ExpandedChanged { get; set; }
    [Parameter] public int ActiveCount { get; set; }
    [Parameter(CaptureUnmatchedValues = true)] public IReadOnlyDictionary<string, object>? AdditionalAttributes { get; set; }

    private string PanelTitle => ActiveCount <= 0 ? Title : $"{Title} ({ActiveCount})";
    private bool HasActiveFilters => ActiveCount > 0 || (ActiveFilterChips?.Count > 0) || ActiveChips is not null || ChipContent is not null;

    private string PaperClass
    {
        get
        {
            var extra = string.Empty;
            if (AdditionalAttributes is not null && AdditionalAttributes.TryGetValue("class", out var cls) && cls is not null)
            {
                extra = " " + cls.ToString();
            }
            return "mb-4 sigad-card sigad-filterbar" + extra;
        }
    }

    private async Task OnExpandedChanged(bool value)
    {
        Expanded = value;
        if (ExpandedChanged.HasDelegate)
        {
            await ExpandedChanged.InvokeAsync(value);
        }
    }

    private async Task OnApplyClicked()
    {
        Expanded = false;
        if (ExpandedChanged.HasDelegate)
        {
            await ExpandedChanged.InvokeAsync(false);
        }
        if (OnApply.HasDelegate)
        {
            await OnApply.InvokeAsync();
        }
    }

    private async Task OnResetClicked()
    {
        if (OnReset.HasDelegate)
        {
            await OnReset.InvokeAsync();
        }
    }

    private async Task OnChipRemoved(FilterChip chip)
    {
        if (OnChipRemove.HasDelegate)
        {
            await OnChipRemove.InvokeAsync(chip);
        }
    }
}