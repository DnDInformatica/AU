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

namespace Accredia.SIGAD.Web.Components.Pages;

public partial class Tipologiche : ComponentBase
{
private MudTable<TipologicaListItem>? _table;
    private IEnumerable<TipologicaListItem> _items = Array.Empty<TipologicaListItem>();
    private string? _query;
    private string? _errorMessage;

    private async Task<TableData<TipologicaListItem>> LoadTipologiche(TableState state, CancellationToken cancellationToken)
    {
        var page = state.Page + 1;
        var pageSize = state.PageSize;

        var result = await GatewayClient.GetTipologicheAsync(page, pageSize, _query, cancellationToken);
        if (!result.IsSuccess || result.Data is null)
        {
            _errorMessage = result.Error ?? "Impossibile caricare le tipologiche.";
            return new TableData<TipologicaListItem>
            {
                Items = Array.Empty<TipologicaListItem>(),
                TotalItems = 0
            };
        }

        _errorMessage = null;
        _items = result.Data.Items;

        return new TableData<TipologicaListItem>
        {
            Items = result.Data.Items,
            TotalItems = result.Data.TotalCount
        };
    }

    private async Task Reload()
    {
        if (_table is not null)
        {
            await _table.ReloadServerData();
        }
    }
}