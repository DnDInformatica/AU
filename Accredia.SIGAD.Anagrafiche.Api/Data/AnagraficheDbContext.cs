using Microsoft.EntityFrameworkCore;

namespace Accredia.SIGAD.Anagrafiche.Api.Data;

internal sealed class AnagraficheDbContext : DbContext
{
    public AnagraficheDbContext(DbContextOptions<AnagraficheDbContext> options)
        : base(options)
    {
    }

    public DbSet<Organizzazione> Organizzazioni => Set<Organizzazione>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema("Anagrafiche");

        modelBuilder.Entity<Organizzazione>(entity =>
        {
            entity.ToTable("Organizzazioni");
            entity.HasKey(e => e.OrganizzazioneId);

            entity.Property(e => e.Codice)
                .HasMaxLength(50)
                .IsRequired();

            entity.Property(e => e.Denominazione)
                .HasMaxLength(200)
                .IsRequired();

            entity.Property(e => e.IsActive)
                .HasDefaultValue(true);

            entity.Property(e => e.CreatedUtc)
                .HasDefaultValueSql("SYSUTCDATETIME()");

            entity.HasIndex(e => e.Codice)
                .IsUnique();
        });
    }
}
