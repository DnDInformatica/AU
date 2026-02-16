using System.Net;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.Identity.Api.Tests;

public class RateLimitingTests : IClassFixture<TestWebApplicationFactory>
{
    private readonly TestWebApplicationFactory _factory;

    public RateLimitingTests(TestWebApplicationFactory factory)
    {
        _factory = factory;
    }

    [Fact]
    public async Task Login_RateLimit_Triggers_After_Threshold()
    {
        using var client = _factory.CreateClient();

        for (var i = 0; i < 10; i++)
        {
            var response = await client.PostAsJsonAsync("/v1/auth/login", new { username = "user", password = "pass" });
            Assert.NotEqual(HttpStatusCode.TooManyRequests, response.StatusCode);
        }

        var limited = await client.PostAsJsonAsync("/v1/auth/login", new { username = "user", password = "pass" });
        Assert.Equal(HttpStatusCode.TooManyRequests, limited.StatusCode);
    }

    [Fact]
    public async Task Refresh_RateLimit_Triggers_After_Threshold()
    {
        using var client = _factory.CreateClient();

        for (var i = 0; i < 20; i++)
        {
            var response = await client.PostAsJsonAsync("/v1/auth/refresh", new { refreshToken = "dummy" });
            Assert.NotEqual(HttpStatusCode.TooManyRequests, response.StatusCode);
        }

        var limited = await client.PostAsJsonAsync("/v1/auth/refresh", new { refreshToken = "dummy" });
        Assert.Equal(HttpStatusCode.TooManyRequests, limited.StatusCode);
    }
}
