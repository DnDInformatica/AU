using Accredia.SIGAD.Web.Models.Search;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Web;

namespace Accredia.SIGAD.Web.Components.Layout;

public partial class GlobalSearch : IDisposable
{
    private const int DefaultPageSize = 5;
    private string _query = string.Empty;
    private bool _isOpen;
    private bool _isLoading;
    private bool _resultsIsEmpty;
    private GlobalSearchResponse? _results;
    private CancellationTokenSource? _cts;
    private int _queryVersion;
    private string? _lastError;
    private CancellationTokenSource? _blurCts;

    private async Task OnQueryChanged()
    {
        // Cancel only the debounce delay. We intentionally avoid cancelling the HTTP request to prevent
        // TaskCanceledException noise during fast typing (VS may break on thrown exceptions even if caught).
        _cts?.Cancel();
        _cts?.Dispose();
        _cts = new CancellationTokenSource();
        var token = _cts.Token;
        var version = ++_queryVersion;

        var trimmed = _query.Trim();
        if (trimmed.Length < 2)
        {
            _isOpen = false;
            _results = null;
            _resultsIsEmpty = false;
            _lastError = null;
            StateHasChanged();
            return;
        }

        _isOpen = true;
        _isLoading = true;
        _resultsIsEmpty = false;
        _lastError = null;
        StateHasChanged();

        try
        {
            // Debounce per ridurre chiamate al Gateway durante la digitazione.
            await Task.Delay(350, token);

            // If a newer query arrived while we were waiting, ignore this one.
            if (version != _queryVersion)
            {
                return;
            }

            using var timeoutCts = new CancellationTokenSource(TimeSpan.FromSeconds(6));
            var result = await GatewayClient.SearchGlobalAsync(trimmed, 1, DefaultPageSize, timeoutCts.Token);
            if (version != _queryVersion)
            {
                return;
            }

            if (result.IsSuccess && result.Data is not null)
            {
                _results = result.Data;
                _resultsIsEmpty = (_results.Organizzazioni.Items.Count
                                   + _results.Persone.Items.Count
                                   + _results.Incarichi.Items.Count) == 0;
            }
            else
            {
                _results = null;
                _resultsIsEmpty = true;
                _lastError = string.IsNullOrWhiteSpace(result.Error) ? null : result.Error;
            }
        }
        catch (TaskCanceledException)
        {
            // Debounce cancelled or request timeout.
            if (version == _queryVersion)
            {
                _results = null;
                _resultsIsEmpty = true;
                _lastError = "Ricerca non disponibile (timeout).";
            }

            return;
        }
        catch (HttpRequestException)
        {
            // Gateway unavailable: treat as empty and keep UX stable.
            _results = null;
            _resultsIsEmpty = true;
            _lastError = "Ricerca non disponibile (Gateway non raggiungibile).";
        }
        finally
        {
            _isLoading = false;
            StateHasChanged();
        }
    }

    private Task Retry()
        => OnQueryChanged();

    private void HandleFocus()
    {
        _blurCts?.Cancel();
        if (_results is not null)
        {
            _isOpen = true;
        }
    }

    private async Task HandleBlur(FocusEventArgs args)
    {
        _blurCts?.Cancel();
        _blurCts?.Dispose();
        _blurCts = new CancellationTokenSource();
        var token = _blurCts.Token;

        try
        {
            // Small delay so clicks inside the popover can register.
            await Task.Delay(200, token);
            _isOpen = false;
            await InvokeAsync(StateHasChanged);
        }
        catch (TaskCanceledException)
        {
            // ignore
        }
    }

    private void HandleKeyDown(KeyboardEventArgs args)
    {
        if (args.Key == "Escape")
        {
            _isOpen = false;
        }
    }

    private Task OnNavigate((string RouteBase, SearchItem Item) args)
    {
        NavigateTo(args.RouteBase, args.Item);
        return Task.CompletedTask;
    }

    private void NavigateTo(string routeBase, SearchItem item)
    {
        var target = routeBase switch
        {
            "organizzazioni" => $"/organizzazioni/{item.Id}",
            "persone" => $"/persone?q={Uri.EscapeDataString(BuildListQuery(item))}",
            "incarichi" => $"/incarichi?q={Uri.EscapeDataString(BuildListQuery(item))}",
            _ => "/"
        };

        _isOpen = false;
        Navigation.NavigateTo(target);
    }

    private static string BuildListQuery(SearchItem item)
    {
        if (!string.IsNullOrWhiteSpace(item.CodiceFiscale))
        {
            return item.CodiceFiscale;
        }

        if (!string.IsNullOrWhiteSpace(item.PartitaIVA))
        {
            return item.PartitaIVA;
        }

        return item.Title;
    }

    private void ClosePopover(MouseEventArgs _)
        => _isOpen = false;

    public void Dispose()
    {
        _cts?.Cancel();
        _cts?.Dispose();
        _blurCts?.Cancel();
        _blurCts?.Dispose();
    }
}
