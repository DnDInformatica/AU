using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;
using Microsoft.Extensions.Configuration;

namespace Accredia.SIGAD.Anagrafiche.Api.Data;

internal sealed class AnagraficheDesignTimeDbContextFactory : IDesignTimeDbContextFactory<AnagraficheDbContext>
{
    public AnagraficheDbContext CreateDbContext(string[] args)
    {
        var environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Development";

        var configuration = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json", optional: false)
            .AddJsonFile($"appsettings.{environment}.json", optional: true)
            .AddEnvironmentVariables()
            .Build();

        var connectionString = configuration.GetConnectionString("AnagraficheDb")
            ?? throw new InvalidOperationException("Missing connection string 'AnagraficheDb'.");

        var optionsBuilder = new DbContextOptionsBuilder<AnagraficheDbContext>();
        optionsBuilder.UseSqlServer(connectionString);

        return new AnagraficheDbContext(optionsBuilder.Options);
    }
}
