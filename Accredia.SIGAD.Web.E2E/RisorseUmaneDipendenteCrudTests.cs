using Microsoft.Playwright;
using Microsoft.Playwright.NUnit;
using System.Text.RegularExpressions;

namespace Accredia.SIGAD.Web.E2E;

public class RisorseUmaneDipendenteCrudTests : PageTest
{
    private static string BaseUrl =>
        Environment.GetEnvironmentVariable("SIGAD_WEB_BASE_URL")?.TrimEnd('/')
        ?? "http://localhost:7000";

    [Test]
    public async Task DipendenteDettaglio_ShowsSections_And_AllowsCreateInEachRuArea()
    {
        await LoginAsAdminAsync();

        await Page.GotoAsync($"{BaseUrl}/risorse-umane/dipendenti/1", new() { WaitUntil = WaitUntilState.NetworkIdle });

        await Expect(Page.GetByText("Contratti")).ToBeVisibleAsync();
        await Expect(Page.GetByText("Dotazioni")).ToBeVisibleAsync();
        await Expect(Page.GetByText("Formazione obbligatoria")).ToBeVisibleAsync();

        await Page.GetByRole(AriaRole.Button, new() { Name = "Nuovo contratto" }).ClickAsync();
        await Expect(Page.GetByText("Nuovo contratto")).ToBeVisibleAsync();
        await Page.GetByRole(AriaRole.Button, new() { Name = "Salva contratto" }).ClickAsync();
        await Expect(Page.GetByText("Contratto creato.")).ToBeVisibleAsync();

        await Page.GetByRole(AriaRole.Button, new() { Name = "Nuova dotazione" }).ClickAsync();
        await Expect(Page.GetByText("Nuova dotazione")).ToBeVisibleAsync();
        await Page.GetByLabel("Descrizione").FillAsync($"Notebook UI {DateTimeOffset.UtcNow.ToUnixTimeSeconds()}");
        await Page.GetByRole(AriaRole.Button, new() { Name = "Salva dotazione" }).ClickAsync();
        await Expect(Page.GetByText("Dotazione creata.")).ToBeVisibleAsync();

        await Page.GetByRole(AriaRole.Button, new() { Name = "Nuova formazione" }).ClickAsync();
        await Expect(Page.GetByText("Nuova formazione")).ToBeVisibleAsync();
        await Page.GetByRole(AriaRole.Button, new() { Name = "Salva formazione" }).ClickAsync();
        await Expect(Page.GetByText("Formazione creata.")).ToBeVisibleAsync();
    }

    private async Task LoginAsAdminAsync()
    {
        await Page.GotoAsync($"{BaseUrl}/login", new() { WaitUntil = WaitUntilState.NetworkIdle });

        await Page.GetByLabel("Username").FillAsync("admin");
        await Page.GetByLabel("Password").FillAsync("Password!12345");

        var loginButton = Page.GetByRole(AriaRole.Button, new() { Name = "Login" });
        await Expect(loginButton).ToBeEnabledAsync();
        await loginButton.ClickAsync();

        await Expect(Page).ToHaveURLAsync(new Regex(@"^(?!.*\/login).*$"));
    }
}
