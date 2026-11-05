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
using Accredia.SIGAD.Shared.Permessi;

namespace Accredia.SIGAD.Web.Components.Layout;

public partial class NavMenu : ComponentBase
{
[Parameter] public bool IsCollapsed { get; set; }
    [Parameter] public EventCallback OnToggleDrawer { get; set; }

    private bool _anagraficheExpanded = true;
    private bool _configurazioneExpanded = true;
    private bool _amministrazioneExpanded = true;

    private bool _isCollapsed => IsCollapsed;

    private bool _hasAnagraficheAccess =>
        UserContext.HasPermission(PermessiSigad.Organizzazioni.Accesso)
        || UserContext.HasPermission(PermessiSigad.Persone.Accesso)
        || UserContext.HasPermission(PermessiSigad.Incarichi.Accesso)
        || UserContext.HasPermission(PermessiSigad.Certificazioni.Accesso);

    private bool _hasRuAccess =>
        UserContext.HasPermission(PermessiSigad.RisorseUmane.Dipendenti.Elenco)
        || UserContext.HasPermission(PermessiSigad.RisorseUmane.Dipendenti.Lettura)
        || UserContext.HasPermission(PermessiSigad.RisorseUmane.Dipendenti.Creazione)
        || UserContext.HasPermission(PermessiSigad.RisorseUmane.Dipendenti.Modifica)
        || UserContext.HasPermission(PermessiSigad.RisorseUmane.Dipendenti.Cancellazione);

    // Le capacità vengono dai permessi IAM, mai dal nome del ruolo.
    private bool _hasAdminAccess => UserContext.HasPermission(PermessiIam.AccessoConsole);

    private RenderFragment NavLink(string label, string icon, string href, NavLinkMatch match = NavLinkMatch.Prefix)
        => builder =>
        {
            if (IsCollapsed)
            {
                builder.OpenComponent<MudTooltip>(0);
                builder.AddAttribute(1, "Text", label);
                builder.AddAttribute(2, "Placement", Placement.Right);
                builder.AddAttribute(3, "Class", "sigad-nav-tooltip");
                builder.AddAttribute(4, "ChildContent", (RenderFragment)(tooltipBuilder =>
                {
                    tooltipBuilder.OpenComponent<MudNavLink>(10);
                    tooltipBuilder.AddAttribute(11, "Href", href);
                    tooltipBuilder.AddAttribute(12, "Icon", icon);
                    tooltipBuilder.AddAttribute(13, "IconColor", Color.Inherit);
                    tooltipBuilder.AddAttribute(14, "Match", match);
                    tooltipBuilder.AddAttribute(15, "ActiveClass", "active");
                    tooltipBuilder.AddAttribute(16, "Class", "sigad-nav-link");
                    tooltipBuilder.AddAttribute(17, "ChildContent", (RenderFragment)(childBuilder =>
                    {
                        // Collapsed (mini) menu: icon-only. Tooltip already contains the label.
                    }));
                    tooltipBuilder.CloseComponent();
                }));
                builder.CloseComponent();
                return;
            }

            builder.OpenComponent<MudNavLink>(30);
            builder.AddAttribute(31, "Href", href);
            builder.AddAttribute(32, "Icon", icon);
            builder.AddAttribute(33, "IconColor", Color.Inherit);
            builder.AddAttribute(34, "Match", match);
            builder.AddAttribute(35, "ActiveClass", "active");
            builder.AddAttribute(36, "Class", "sigad-nav-link");
            builder.AddAttribute(37, "ChildContent", (RenderFragment)(childBuilder =>
            {
                childBuilder.AddContent(40, label);
            }));
            builder.CloseComponent();
        };
}
