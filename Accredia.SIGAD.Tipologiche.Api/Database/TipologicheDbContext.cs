using Microsoft.EntityFrameworkCore;

namespace Accredia.SIGAD.Tipologiche.Api.Database;

internal sealed class TipologicheDbContext(DbContextOptions<TipologicheDbContext> options) : DbContext(options)
{
    public DbSet<TipoVoceTipologica> Tipologiche => Set<TipoVoceTipologica>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.HasDefaultSchema("Tipologiche");

        modelBuilder.Entity<TipoVoceTipologica>(entity =>
        {
            entity.ToTable("TipoVoceTipologica");
            entity.HasKey(x => x.Id);
            entity.Property(x => x.Code).HasMaxLength(50).IsRequired();
            entity.Property(x => x.Description).HasMaxLength(250).IsRequired();
            entity.Property(x => x.IsActive).HasDefaultValue(true).IsRequired();
            entity.Property(x => x.Ordine).HasDefaultValue(0).IsRequired();
            entity.HasIndex(x => x.Code).IsUnique();
        });
    }
}
