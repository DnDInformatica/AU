using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Design;

namespace Accredia.SIGAD.Identity.Api.Data;

public sealed class AppIdentityDbContextFactory : IDesignTimeDbContextFactory<AppIdentityDbContext>
{
    // Design-time (dotnet ef): stessa sorgente di configurazione del runtime
    // (appsettings.json + appsettings.{Environment}.json + variabili d'ambiente).
    // Modalità di autenticazione allineata al Portale: solo Active Directory Default
    // verso Azure SQL; nessun fallback a SQL auth locale.
    public AppIdentityDbContext CreateDbContext(string[] args)
    {
        var environment = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") ?? "Production";

        var configuration = new ConfigurationBuilder()
            .SetBasePath(Directory.GetCurrentDirectory())
            .AddJsonFile("appsettings.json", optional: false)
            .AddJsonFile($"appsettings.{environment}.json", optional: true)
            .AddEnvironmentVariables()
            .Build();

        var connectionString = configuration.GetConnectionString("IdentityDb")
            ?? throw new InvalidOperationException(
                "ConnectionStrings:IdentityDb non configurata. Impostarla negli appsettings (Active Directory Default verso Azure SQL) o via variabile d'ambiente ConnectionStrings__IdentityDb.");

        var optionsBuilder = new DbContextOptionsBuilder<AppIdentityDbContext>();
        optionsBuilder.UseSqlServer(connectionString);

        return new AppIdentityDbContext(optionsBuilder.Options);
    }
}
