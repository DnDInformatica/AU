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

public partial class SystemStatus : ComponentBase
{
    private bool _loading;
    private List<ServiceStatusRow> _results = new();
    private CancellationTokenSource? _reloadCts;

    protected override async Task OnInitializedAsync()
        => await ReloadAsync();

    private async Task ReloadAsync()
    {
        _reloadCts?.Cancel();
        _reloadCts?.Dispose();
        _reloadCts = new CancellationTokenSource();
        var token = _reloadCts.Token;

        _loading = true;
        try
        {
            var checks = new[]
            {
                CheckAsync("Gateway", GetGatewayBaseUrl().TrimEnd('/') + "/health", token),
                CheckAsync("Identity API", GetServiceBaseUrl("Services:IdentityBaseUrl", "http://localhost:7001").TrimEnd('/') + "/health", token),
                CheckAsync("Tipologiche API", GetServiceBaseUrl("Services:TipologicheBaseUrl", "http://localhost:7002").TrimEnd('/') + "/health", token),
                CheckAsync("Anagrafiche API", GetServiceBaseUrl("Services:AnagraficheBaseUrl", "http://localhost:7003").TrimEnd('/') + "/health", token),
                CheckAsync("Storage documenti", GetGatewayBaseUrl().TrimEnd('/') + "/anagrafiche/health/document-storage", token)
            };

            _results = (await Task.WhenAll(checks)).ToList();
        }
        catch (TaskCanceledException)
        {
            return;
        }
        finally
        {
            _loading = false;
        }
    }

    private string GetGatewayBaseUrl()
        => Configuration.GetValue<string>("Gateway:BaseUrl") ?? "http://localhost:7100/";

    private string GetServiceBaseUrl(string key, string fallback)
        => Configuration.GetValue<string>(key) ?? fallback;

    private async Task<ServiceStatusRow> CheckAsync(string name, string url, CancellationToken cancellationToken)
    {
        try
        {
            using var client = HttpClientFactory.CreateClient();
            using var timeoutCts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
            timeoutCts.CancelAfter(TimeSpan.FromSeconds(2));

            using var response = await client.GetAsync(url, timeoutCts.Token);
            return new ServiceStatusRow(name, url, response.IsSuccessStatusCode, $"HTTP {(int)response.StatusCode}");
        }
        catch (TaskCanceledException)
        {
            if (cancellationToken.IsCancellationRequested)
            {
                throw;
            }

            return new ServiceStatusRow(name, url, false, "Timeout");
        }
        catch (HttpRequestException ex)
        {
            return new ServiceStatusRow(name, url, false, ex.Message);
        }
        catch (Exception ex)
        {
            return new ServiceStatusRow(name, url, false, ex.Message);
        }
    }

    public void Dispose()
    {
        _reloadCts?.Cancel();
        _reloadCts?.Dispose();
    }

    private sealed record ServiceStatusRow(string Name, string Url, bool Ok, string Detail);
}
