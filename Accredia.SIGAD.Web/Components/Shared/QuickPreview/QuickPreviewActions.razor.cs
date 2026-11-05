using Microsoft.AspNetCore.Components;

namespace Accredia.SIGAD.Web.Components.Shared;

public partial class QuickPreviewActions
{
    [Parameter] public EventCallback OnClose { get; set; }
    [Parameter] public EventCallback OnOpenDetail { get; set; }
    [Parameter] public string OpenDetailLabel { get; set; } = "Apri scheda";
}
