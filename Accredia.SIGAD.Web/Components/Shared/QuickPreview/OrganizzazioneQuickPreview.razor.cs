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

public partial class OrganizzazioneQuickPreview : ComponentBase
{
[Parameter, EditorRequired] public OrganizzazioneListItem Item { get; set; } = default!;

    private static string ValueOrDash(string? value)
        => string.IsNullOrWhiteSpace(value) ? "—" : value;

    private static string GetStatoLabel(byte? statoAttivitaId)
        => statoAttivitaId switch
        {
            1 => "Attiva",
            2 => "Sospesa",
            3 => "Cessata",
            null => "N/D",
            _ => $"Stato {statoAttivitaId}"
        };

    private static Color GetStatoColor(byte? statoAttivitaId)
        => statoAttivitaId switch
        {
            1 => Color.Success,
            2 => Color.Warning,
            3 => Color.Error,
            _ => Color.Info
        };
}