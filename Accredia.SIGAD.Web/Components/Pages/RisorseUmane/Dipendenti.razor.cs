using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Routing;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.JSInterop;
using MudBlazor;
using Accredia.SIGAD.Web.Auth;
using Accredia.SIGAD.Web.Models.Admin;
using Accredia.SIGAD.Web.Models.Anagrafiche;
using Accredia.SIGAD.Web.Models.Auth;
using Accredia.SIGAD.Web.Models.Common;
using Accredia.SIGAD.Web.Models.RisorseUmane;
using Accredia.SIGAD.Web.Models.Search;
using Accredia.SIGAD.Web.Models.Tipologiche;
using Accredia.SIGAD.Web.Services;
using BreadcrumbItem = Accredia.SIGAD.Web.Models.Common.BreadcrumbItem;

namespace Accredia.SIGAD.Web.Components.Pages.RisorseUmane;

public partial class Dipendenti : ComponentBase
{
private bool CanRead =>
        (UserContext.HasPermission("SIDAC.HR.DIP.LIST") || UserContext.HasPermission("SIDAC.HR.DIP.READ"))
        && UserContext.HasPermission("SIDAC.HR.PERSONA.READ");

    private bool CanCreate => UserContext.HasPermission("SIDAC.HR.DIP.CREATE");

    private readonly IReadOnlyList<BreadcrumbItem> _breadcrumbs = new[]
    {
        new BreadcrumbItem("Home", "/"),
        new BreadcrumbItem("Risorse Umane"),
        new BreadcrumbItem("Dipendenti")
    };

    private MudTable<DipendenteDettaglioCompletoListItem>? _table;
    private string? _errorMessage;

    private string? _query;
    private string? _matricola;
    private int? _statoDipendenteId;
    private PersonaLookupItem? _persona;

    private Task OnPersonaChanged(PersonaLookupItem? value)
    {
        _persona = value;
        return Task.CompletedTask;
    }

    private async Task<IEnumerable<PersonaLookupItem>> SearchPersoneAsync(string text, CancellationToken cancellationToken)
    {
        if (string.IsNullOrWhiteSpace(text) || text.Trim().Length < 2)
        {
            _errorMessage = null;
            return Array.Empty<PersonaLookupItem>();
        }

        var query = text.Trim();
        var result = await GatewayClient.SearchPersoneRuLookupAsync(query, 1, 10, cancellationToken);
        if (result.IsSuccess && result.Data is not null)
        {
            _errorMessage = null;
            return result.Data.Items;
        }

        // Fallback: in caso di indisponibilita lookup RU, usa la ricerca Anagrafiche diretta.
        var fallback = await GatewayClient.SearchPersoneAsync(query, 1, 10, cancellationToken);
        if (fallback.IsSuccess && fallback.Data is not null)
        {
            _errorMessage = null;
            return fallback.Data.Items.Select(p => new PersonaLookupItem(
                p.PersonaId,
                p.Cognome,
                p.Nome,
                p.CodiceFiscale,
                p.DataNascita));
        }

        _errorMessage = "Ricerca persona temporaneamente non disponibile. Verifica Gateway/BFF/Anagrafiche.";
        return Array.Empty<PersonaLookupItem>();
    }

    private Task ApplyFilters()
    {
        _errorMessage = null;
        _table?.ReloadServerData();
        return Task.CompletedTask;
    }

    private Task ResetFilters()
    {
        _query = null;
        _matricola = null;
        _statoDipendenteId = null;
        _persona = null;
        _errorMessage = null;
        _table?.ReloadServerData();
        return Task.CompletedTask;
    }

    private async Task<TableData<DipendenteDettaglioCompletoListItem>> LoadDipendenti(TableState state, CancellationToken cancellationToken)
    {
        var page = state.Page + 1;
        var pageSize = state.PageSize;

        var result = await GatewayClient.GetDipendentiDettaglioCompletoAsync(
            _query,
            _matricola,
            _statoDipendenteId,
            _persona?.PersonaId,
            page,
            pageSize,
            cancellationToken);

        if (!result.IsSuccess || result.Data is null)
        {
            _errorMessage = result.Error ?? "Impossibile caricare i dipendenti.";
            return new TableData<DipendenteDettaglioCompletoListItem>
            {
                Items = Array.Empty<DipendenteDettaglioCompletoListItem>(),
                TotalItems = 0
            };
        }

        _errorMessage = null;
        return new TableData<DipendenteDettaglioCompletoListItem>
        {
            Items = result.Data.Items,
            TotalItems = result.Data.TotalCount
        };
    }

    private void OnRowClick(TableRowClickEventArgs<DipendenteDettaglioCompletoListItem> args)
        => Navigation.NavigateTo($"/risorse-umane/dipendenti/{args.Item.Dipendente.DipendenteId}");

    private void CreateNew()
    {
        if (!CanCreate)
        {
            _errorMessage = "Accesso negato: permesso HR.DIP.CREATE mancante.";
            return;
        }

        Navigation.NavigateTo("/risorse-umane/dipendenti/nuovo");
    }
}