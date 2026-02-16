using System;
using System.Net;
using System.Net.Http.Json;
using System.Linq;
using System.Threading.Tasks;
using Xunit;

namespace Accredia.SIGAD.Identity.Api.Tests;

public class GatewayRateLimitingTests : IClassFixture<TestGatewayFactory>
{
    private readonly TestGatewayFactory _factory;

    public GatewayRateLimitingTests(TestGatewayFactory factory)
    {
        _factory = factory;
    }

    [Fact]
    public async Task Gateway_Login_RateLimit_Triggers_After_Threshold()
    {
        using var client = _factory.CreateClient();
        client.Timeout = TimeSpan.FromSeconds(5);

        var tasks = Enumerable.Range(0, 25)
            .Select(_ => client.PostAsJsonAsync("/identity/v1/auth/login", new { username = "user", password = "pass" }))
            .ToArray();

        var responses = await Task.WhenAll(tasks);
        Assert.Contains(responses, r => r.StatusCode == HttpStatusCode.TooManyRequests);
    }

    [Fact]
    public async Task Gateway_Refresh_RateLimit_Triggers_After_Threshold()
    {
        using var client = _factory.CreateClient();
        client.Timeout = TimeSpan.FromSeconds(5);

        var tasks = Enumerable.Range(0, 40)
            .Select(_ => client.PostAsJsonAsync("/identity/v1/auth/refresh", new { refreshToken = "dummy" }))
            .ToArray();

        var responses = await Task.WhenAll(tasks);
        Assert.Contains(responses, r => r.StatusCode == HttpStatusCode.TooManyRequests);
    }
}
