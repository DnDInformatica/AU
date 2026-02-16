using Microsoft.Playwright;
using Microsoft.Playwright.NUnit;

namespace Accredia.SIGAD.Web.E2E;

public class GlobalSearchTests : PageTest
{
    private static string BaseUrl =>
        Environment.GetEnvironmentVariable("SIGAD_WEB_BASE_URL")?.TrimEnd('/')
        ?? "http://localhost:5000";

    [Test]
    public async Task Home_ShowsTopbarAndSearch()
    {
        await Page.GotoAsync($"{BaseUrl}/", new() { WaitUntil = WaitUntilState.NetworkIdle });

        await Expect(Page.Locator(".sigad-app-title")).ToBeVisibleAsync();
        await Expect(Page.Locator(".sigad-app-subtitle")).ToBeVisibleAsync();
        await Expect(Page.GetByPlaceholder("Cerca organizzazioni, persone, incarichi…")).ToBeVisibleAsync();
    }

    [Test]
    public async Task LoginPage_Loads()
    {
        await Page.GotoAsync($"{BaseUrl}/login", new() { WaitUntil = WaitUntilState.NetworkIdle });

        await Expect(Page.GetByText("Accedi")).ToBeVisibleAsync();
        await Expect(Page.GetByLabel("Username")).ToBeVisibleAsync();
        await Expect(Page.GetByLabel("Password")).ToBeVisibleAsync();
    }

    [Test]
    public async Task GlobalSearch_ShowsEmptyState_WhenNoResults()
    {
        await Page.GotoAsync($"{BaseUrl}/", new() { WaitUntil = WaitUntilState.NetworkIdle });

        var input = Page.GetByPlaceholder("Cerca organizzazioni, persone, incarichi…");
        await input.FillAsync("test");

        await Expect(Page.GetByText("Nessun risultato")).ToBeVisibleAsync();
        await Expect(Page.GetByText("Prova con un CF, una P.IVA o una parola chiave.")).ToBeVisibleAsync();
        await Expect(Page.Locator(".sigad-search-results")).ToBeVisibleAsync();
    }

    [Test]
    public async Task Sidebar_ShowsActiveLink()
    {
        await Page.GotoAsync($"{BaseUrl}/", new() { WaitUntil = WaitUntilState.NetworkIdle });

        var activeLinks = Page.Locator(".sigad-nav-active");
        await Expect(activeLinks).ToHaveCountAsync(1);
    }
}
