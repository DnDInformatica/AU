using Microsoft.AspNetCore.Components;
using Accredia.SIGAD.Web.Models.Common;

namespace Accredia.SIGAD.Web.Components.Shared;

public partial class PageHeader
{
    [Parameter, EditorRequired]
    public string Title { get; set; } = string.Empty;

    [Parameter]
    public string? Subtitle { get; set; }

    /// <summary>
    /// Legacy plain-text breadcrumbs (backward compat).
    /// Ignored when <see cref="BreadcrumbItems"/> is provided.
    /// </summary>
    [Parameter]
    public string? Breadcrumbs { get; set; }

    /// <summary>
    /// Structured, clickable breadcrumb chain.
    /// Items with a non-null <see cref="BreadcrumbItem.Href"/> are rendered as links.
    /// </summary>
    [Parameter]
    public IReadOnlyList<BreadcrumbItem>? BreadcrumbItems { get; set; }

    [Parameter]
    public string? PrimaryActionLabel { get; set; }

    [Parameter]
    public string? PrimaryActionIcon { get; set; }

    [Parameter]
    public bool PrimaryActionDisabled { get; set; }

    [Parameter]
    public EventCallback OnPrimaryAction { get; set; }

    [Parameter]
    public string? SecondaryActionLabel { get; set; }

    [Parameter]
    public string? SecondaryActionIcon { get; set; }

    [Parameter]
    public bool SecondaryActionDisabled { get; set; }

    [Parameter]
    public EventCallback OnSecondaryAction { get; set; }

    /// <summary>
    /// Label for the back / return navigation button (e.g. "Torna a Organizzazioni").
    /// When set, a text button with an ArrowBack icon is rendered to the left of other actions.
    /// </summary>
    [Parameter]
    public string? BackLabel { get; set; }

    /// <summary>
    /// Href for the back button. When <c>null</c>, the back button is hidden
    /// even if <see cref="BackLabel"/> is set.
    /// </summary>
    [Parameter]
    public string? BackHref { get; set; }

    private bool HasStructuredBreadcrumbs => BreadcrumbItems is { Count: > 0 };
    private bool HasLegacyBreadcrumbs => !HasStructuredBreadcrumbs && !string.IsNullOrWhiteSpace(Breadcrumbs);
    private bool HasBackButton => !string.IsNullOrWhiteSpace(BackLabel) && !string.IsNullOrWhiteSpace(BackHref);

    /// <summary>Action buttons (primary/secondary) in the right area.</summary>
    private bool HasActionButtons =>
        !string.IsNullOrWhiteSpace(PrimaryActionLabel)
        || !string.IsNullOrWhiteSpace(SecondaryActionLabel);
}
