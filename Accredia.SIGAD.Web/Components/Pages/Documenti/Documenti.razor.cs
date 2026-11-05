using Microsoft.AspNetCore.Components;
using BreadcrumbItem = Accredia.SIGAD.Web.Models.Common.BreadcrumbItem;

namespace Accredia.SIGAD.Web.Components.Pages.Documenti;

public partial class Documenti
{
    [SupplyParameterFromQuery(Name = "personaId")]
    public int? PersonaId { get; set; }

    private readonly IReadOnlyList<BreadcrumbItem> _breadcrumbs =
    [
        new BreadcrumbItem("Home", "/"),
        new BreadcrumbItem("Documenti")
    ];
}
