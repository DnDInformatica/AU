using System;
using System.IO;
using System.Text.RegularExpressions;
using Xunit;

namespace Accredia.SIGAD.Anagrafiche.Api.Tests;

public sealed class IncarichiSqlRegressionTests
{
    [Fact]
    public void CreateInt_UsesExclusiveOrganizationPersistenceWhenUoIsSet()
    {
        var source = ReadSource("Accredia.SIGAD.Anagrafiche.Api", "V1", "Features", "Incarichi", "CreateInt", "Handler.cs");

        Assert.Contains("int? organizzazioneIdForPersistence = command.Request.UnitaOrganizzativaId.HasValue", source);
        Assert.Contains("Add(\"OrganizzazioneId\", \"@OrganizzazioneId\", organizzazioneIdForPersistence);", source);
    }

    [Fact]
    public void UpdateInt_UsesExclusiveOrganizationPersistenceWhenUoIsSet()
    {
        var source = ReadSource("Accredia.SIGAD.Anagrafiche.Api", "V1", "Features", "Incarichi", "UpdateInt", "Handler.cs");

        Assert.Contains("int? organizzazioneIdForPersistence = command.Request.UnitaOrganizzativaId.HasValue", source);
        Assert.Contains("Set(\"OrganizzazioneId\", \"[OrganizzazioneId] = @OrganizzazioneId\", organizzazioneIdForPersistence);", source);
    }

    [Fact]
    public void GetByIdInt_UsesCoalesceToResolveOrganizationContext()
    {
        var source = ReadSource("Accredia.SIGAD.Anagrafiche.Api", "V1", "Features", "Incarichi", "GetByIdInt", "Handler.cs");

        Assert.Contains("COALESCE(i.OrganizzazioneId, u.OrganizzazioneId) AS OrganizzazioneId", source);
        Assert.Contains("COALESCE(o.Denominazione, ou.Denominazione) AS OrganizzazioneDenominazione", source);
    }

    [Fact]
    public void Search_UsesCoalesceAndOrganizationFallbackInPivaFilter()
    {
        var source = ReadSource("Accredia.SIGAD.Anagrafiche.Api", "V1", "Features", "Incarichi", "Search", "Handler.cs");

        Assert.Contains("o.PartitaIVA = @Query OR ou.PartitaIVA = @Query", source);
        Assert.Contains("COALESCE(i.OrganizzazioneId, u.OrganizzazioneId) AS OrganizzazioneId", source);
        Assert.Contains("COALESCE(o.Denominazione, ou.Denominazione) AS OrganizzazioneDenominazione", source);
    }

    [Fact]
    public void OrganizzazioniGetIncarichi_IncludesAssignmentsFromUnits()
    {
        var source = ReadSource("Accredia.SIGAD.Anagrafiche.Api", "V1", "Features", "Organizzazioni", "GetIncarichi", "Handler.cs");
        var normalized = NormalizeWhitespace(source);

        Assert.Contains("(i.OrganizzazioneId = @OrganizzazioneId OR u.OrganizzazioneId = @OrganizzazioneId)", normalized);
    }

    [Fact]
    public void CreateValidator_RequiresTipoRuoloId()
    {
        var source = ReadSource("Accredia.SIGAD.Anagrafiche.Api", "V1", "Features", "Incarichi", "CreateInt", "Validator.cs");

        Assert.Contains("if (!command.Request.TipoRuoloId.HasValue)", source);
        Assert.Contains("Tipo ruolo obbligatorio.", source);
    }

    [Fact]
    public void UpdateValidator_RequiresTipoRuoloId()
    {
        var source = ReadSource("Accredia.SIGAD.Anagrafiche.Api", "V1", "Features", "Incarichi", "UpdateInt", "Validator.cs");

        Assert.Contains("if (!command.Request.TipoRuoloId.HasValue)", source);
        Assert.Contains("Tipo ruolo obbligatorio.", source);
    }

    private static string ReadSource(params string[] relativePath)
    {
        var root = FindRepositoryRoot();
        var path = Path.Combine(root, Path.Combine(relativePath));
        return File.ReadAllText(path);
    }

    private static string FindRepositoryRoot()
    {
        var dir = new DirectoryInfo(AppContext.BaseDirectory);
        while (dir is not null)
        {
            if (File.Exists(Path.Combine(dir.FullName, "Accredia.SIGAD.sln")))
            {
                return dir.FullName;
            }

            dir = dir.Parent;
        }

        throw new InvalidOperationException("Repository root not found.");
    }

    private static string NormalizeWhitespace(string input)
        => Regex.Replace(input, @"\s+", " ");
}
