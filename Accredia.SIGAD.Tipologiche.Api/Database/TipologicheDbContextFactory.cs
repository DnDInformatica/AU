using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace Accredia.SIGAD.Tipologiche.Api.Database;

internal sealed class TipologicheDbContextFactory : IDesignTimeDbContextFactory<TipologicheDbContext>
{
    public TipologicheDbContext CreateDbContext(string[] args)
    {
        var configuration = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json", optional: false)
            .AddJsonFile("appsettings.Development.json", optional: true)
            .AddEnvironmentVariables()
            .Build();

        var connectionString = configuration.GetConnectionString("TipologicheDb")
            ?? throw new InvalidOperationException("Missing connection string 'TipologicheDb'.");

        var options = new DbContextOptionsBuilder<TipologicheDbContext>()
            .UseSqlServer(connectionString)
            .Options;

        return new TipologicheDbContext(options);
    }
}
