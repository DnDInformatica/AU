using System.Net.Http.Headers;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.RisorseUmane.Api.Tests;

public sealed class RisorseUmaneSmokeHttpIntegrationTests
{
    [Fact]
    public async Task Health_And_Swagger_Are_Reachable_Via_Gateway()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();

        var health = await client.GetAsync("/risorseumane/health");
        health.EnsureSuccessStatusCode();

        var swaggerJson = await client.GetAsync("/risorseumane/swagger/v1/swagger.json");
        swaggerJson.EnsureSuccessStatusCode();
    }

    [Fact]
    public async Task Protected_Endpoints_Require_Auth()
    {
        if (!IntegrationTestSupport.ShouldRun())
        {
            return;
        }

        using var client = IntegrationTestSupport.CreateClient();

        var response = await client.GetAsync("/risorseumane/v1/dipendenti/1");
        Assert.Equal(System.Net.HttpStatusCode.Unauthorized, response.StatusCode);

        var token = await IntegrationTestSupport.LoginAndGetTokenAsync(client);
        client.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", token);

        // After auth, a non-existent resource is either 404 or 200 depending on seed data.
        // We assert only that it is not 401/403.
        response = await client.GetAsync("/risorseumane/v1/dipendenti/1");
        Assert.NotEqual(System.Net.HttpStatusCode.Unauthorized, response.StatusCode);
        Assert.NotEqual(System.Net.HttpStatusCode.Forbidden, response.StatusCode);
    }
}
