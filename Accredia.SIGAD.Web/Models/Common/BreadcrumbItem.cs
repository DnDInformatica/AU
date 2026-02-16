namespace Accredia.SIGAD.Web.Models.Common;

/// <summary>
/// Represents a single breadcrumb segment used by <see cref="Shared.PageHeader"/>.
/// When <see cref="Href"/> is <c>null</c> the item is rendered as non-clickable text
/// (typically the last / current item in the chain).
/// </summary>
public sealed record BreadcrumbItem(string Label, string? Href = null);
