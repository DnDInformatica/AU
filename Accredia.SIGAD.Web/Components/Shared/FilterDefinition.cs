using Microsoft.AspNetCore.Components;

namespace Accredia.SIGAD.Web.Components.Shared;

/// <summary>
/// Definizione di un filtro per SigadFilterPanel
/// </summary>
public class FilterDefinition
{
    /// <summary>
    /// Contenuto del filtro (MudTextField, MudSelect, ecc.)
    /// </summary>
    public RenderFragment Content { get; set; } = null!;

    /// <summary>
    /// Dimensione grid (default: 4 = 1/3 su desktop)
    /// xs=12, sm=6, md=GridSize
    /// </summary>
    public int GridSize { get; set; } = 4;

    /// <summary>
    /// Identificativo univoco del filtro
    /// </summary>
    public string Id { get; set; } = string.Empty;

    public FilterDefinition(string id, RenderFragment content, int gridSize = 4)
    {
        Id = id;
        Content = content;
        GridSize = gridSize;
    }
}

/// <summary>
/// Rappresenta un chip filtro attivo
/// </summary>
public class FilterChip
{
    /// <summary>
    /// Identificativo univoco del filtro associato
    /// </summary>
    public string FilterId { get; set; } = string.Empty;

    /// <summary>
    /// Label da mostrare nel chip (es. "Stato: Attivo")
    /// </summary>
    public string Label { get; set; } = string.Empty;

    /// <summary>
    /// Valore del filtro (per gestione interna)
    /// </summary>
    public object? Value { get; set; }

    public FilterChip(string filterId, string label, object? value = null)
    {
        FilterId = filterId;
        Label = label;
        Value = value;
    }
}
