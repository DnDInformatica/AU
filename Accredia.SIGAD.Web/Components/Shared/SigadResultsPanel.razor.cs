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

public partial class SigadResultsPanel : ComponentBase
{
[Parameter] public string Title { get; set; } = "Risultati";
    [Parameter] public string? TitleIcon { get; set; }

    [Parameter] public RenderFragment? HeaderContent { get; set; }   // es: loading + chip conteggio
    [Parameter] public RenderFragment? HeaderActions { get; set; }   // es: export, refresh, ecc.
    [Parameter] public RenderFragment ChildContent { get; set; } = default!;

    [Parameter] public string BodyPaddingClass { get; set; } = "pa-0";
    [Parameter(CaptureUnmatchedValues = true)] public IReadOnlyDictionary<string, object>? AdditionalAttributes { get; set; }

    private string PaperClass
    {
        get
        {
            var extra = string.Empty;
            if (AdditionalAttributes is not null &&
                AdditionalAttributes.TryGetValue("class", out var cls) &&
                cls is not null)
            {
                extra = " " + cls.ToString();
            }

            // usa lo stesso stile “card/table” che già hai
            return "mb-4 sigad-table-wrap" + extra;
        }
    }

    private string BodyClass => BodyPaddingClass;
}