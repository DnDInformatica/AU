using Microsoft.AspNetCore.Components;

namespace Accredia.SIGAD.Web.Services;

internal sealed record QuickDrawerRequest(
    string Title,
    string? Subtitle,
    RenderFragment Body,
    RenderFragment? Actions = null);

internal sealed class QuickDrawerService
{
    public event Action? Changed;

    public bool IsOpen { get; private set; }

    public QuickDrawerRequest? Current { get; private set; }

    public void Open(QuickDrawerRequest request)
    {
        Current = request;
        IsOpen = true;
        Changed?.Invoke();
    }

    public void Close()
    {
        IsOpen = false;
        Changed?.Invoke();
    }
}

