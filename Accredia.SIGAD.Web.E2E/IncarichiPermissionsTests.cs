using System.Net.Http.Json;
using System.Text.RegularExpressions;
using Microsoft.Playwright;
using Microsoft.Playwright.NUnit;

namespace Accredia.SIGAD.Web.E2E;

public class IncarichiPermissionsTests : PageTest
{
    private static string BaseUrl =>
        Environment.GetEnvironmentVariable("SIGAD_WEB_BASE_URL")?.TrimEnd('/')
        ?? "http://localhost:7000";

    private const string NoPermUser = "inc_no_perm_e2e";
    private const string NoPermPassword = "Password!12345";

    [Test]
    public async Task IncarichiRoutes_ShowAccessDenied_ForUserWithoutIncPermissions()
    {
        await EnsureNoPermUserAsync();
        await LoginAsync(NoPermUser, NoPermPassword);

        var restrictedRoutes = new[]
        {
            "/incarichi",
            "/incarichi/nuovo",
            "/incarichi/1",
            "/incarichi/1/modifica"
        };

        foreach (var route in restrictedRoutes)
        {
            await Page.GotoAsync($"{BaseUrl}{route}", new() { WaitUntil = WaitUntilState.NetworkIdle });
            await Expect(Page).ToHaveURLAsync(new Regex(Regex.Escape(route)));
            await Expect(Page.GetByText("Non hai i permessi necessari per accedere a questa pagina.")).ToBeVisibleAsync();
        }
    }

    [Test]
    public async Task IncarichiListRoute_IsAccessible_ForAdminUser()
    {
        await LoginAsync("admin", "Password!12345");

        await Page.GotoAsync($"{BaseUrl}/incarichi", new() { WaitUntil = WaitUntilState.NetworkIdle });
        await Expect(Page.GetByText("Incarichi")).ToBeVisibleAsync();
    }

    private static async Task EnsureNoPermUserAsync()
    {
        using var http = new HttpClient();
        var registerPayload = new
        {
            userName = NoPermUser,
            email = $"{NoPermUser}@accredia.local",
            password = NoPermPassword
        };

        var response = await http.PostAsJsonAsync("http://127.0.0.1:7001/v1/auth/register", registerPayload);
        if (response.IsSuccessStatusCode)
        {
            return;
        }

        // User already exists -> acceptable for repeated test runs.
        if (response.StatusCode == System.Net.HttpStatusCode.Conflict)
        {
            return;
        }

        var error = await response.Content.ReadAsStringAsync();
        throw new InvalidOperationException(
            $"Unable to ensure no-perm user '{NoPermUser}'. Status={(int)response.StatusCode}. Body={error}");
    }

    private async Task LoginAsync(string username, string password)
    {
        await Page.GotoAsync($"{BaseUrl}/login", new() { WaitUntil = WaitUntilState.NetworkIdle });

        await Page.GetByLabel("Username").FillAsync(username);
        await Page.GetByLabel("Password").FillAsync(password);

        var loginButton = Page.GetByRole(AriaRole.Button, new() { Name = "Login" });
        await Expect(loginButton).ToBeEnabledAsync();
        await loginButton.ClickAsync();

        await Expect(Page).ToHaveURLAsync(new Regex(@"^(?!.*\/login).*$"));
    }
}
