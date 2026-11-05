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

public partial class AccessDenied : ComponentBase
{
[Parameter] public string Title { get; set; } = "Accesso negato";
    [Parameter] public string Message { get; set; } = "Non hai i permessi necessari per accedere a questa pagina.";

    [Parameter] public bool ShowContactHint { get; set; }

    [Parameter] public string ReturnHref { get; set; } = "/";
    [Parameter] public string ReturnLabel { get; set; } = "Torna alla Home";

    [Parameter] public string? Class { get; set; }
}