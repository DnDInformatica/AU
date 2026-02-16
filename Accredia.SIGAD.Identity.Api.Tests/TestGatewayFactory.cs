using System;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Configuration;

namespace Accredia.SIGAD.Identity.Api.Tests;

public class TestGatewayFactory : WebApplicationFactory<Accredia.SIGAD.Gateway.GatewayHostMarker>
{
    protected override void ConfigureWebHost(IWebHostBuilder builder)
    {
        builder.ConfigureAppConfiguration((_, config) =>
        {
            config.SetBasePath(AppContext.BaseDirectory);
            config.AddJsonFile("gateway.appsettings.json", optional: false);
        });
    }
}
