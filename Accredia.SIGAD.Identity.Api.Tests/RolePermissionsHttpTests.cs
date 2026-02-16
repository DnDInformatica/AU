using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Json;
using System.Threading.Tasks;
using Dapper;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using Xunit;
using Accredia.SIGAD.Identity.Api.Contracts;

namespace Accredia.SIGAD.Identity.Api.Tests;

public class RolePermissionsHttpTests : IClassFixture<TestWebApplicationFactory>
{
    private readonly TestWebApplicationFactory _factory;

    public RolePermissionsHttpTests(TestWebApplicationFactory factory)
    {
        _factory = factory;
    }

    [Fact]
    public async Task UpdateRolePermissions_Updates_Assignments_Via_Http()
    {
        var settings = LoadSettings();

        await using var connection = new SqlConnection(settings.ConnectionString);
        await connection.OpenAsync();

        string roleId = null!;
        string roleName = null!;
        int permissionA = 0;
        int permissionB = 0;
        string codeA = null!;
        string codeB = null!;

        try
        {
            roleName = $"TEST_ROLE_{Guid.NewGuid():N}";
            roleId = Guid.NewGuid().ToString();

            await connection.ExecuteAsync(@"
INSERT INTO [Identity].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp])
VALUES (@Id, @Name, @NormalizedName, @ConcurrencyStamp);
", new
            {
                Id = roleId,
                Name = roleName,
                NormalizedName = roleName.ToUpperInvariant(),
                ConcurrencyStamp = Guid.NewGuid().ToString()
            });

            codeA = $"TEST.PERM.A.{Guid.NewGuid():N}";
            codeB = $"TEST.PERM.B.{Guid.NewGuid():N}";

            permissionA = await connection.QuerySingleAsync<int>(@"
INSERT INTO [Identity].[Permission] ([Code], [Description], [Module], [Scope], [Attivo], [CreatedAt], [CreatedBy], [IsDeleted])
VALUES (@Code, @Description, @Module, @Scope, 1, @CreatedAt, @CreatedBy, 0);
SELECT CAST(SCOPE_IDENTITY() AS INT);
", new { Code = codeA, Description = "Test A", Module = "TEST", Scope = "ACTION", CreatedAt = DateTime.UtcNow, CreatedBy = "test" });

            permissionB = await connection.QuerySingleAsync<int>(@"
INSERT INTO [Identity].[Permission] ([Code], [Description], [Module], [Scope], [Attivo], [CreatedAt], [CreatedBy], [IsDeleted])
VALUES (@Code, @Description, @Module, @Scope, 1, @CreatedAt, @CreatedBy, 0);
SELECT CAST(SCOPE_IDENTITY() AS INT);
", new { Code = codeB, Description = "Test B", Module = "TEST", Scope = "ACTION", CreatedAt = DateTime.UtcNow, CreatedBy = "test" });

            using var client = _factory.CreateClient();

            var update = await client.PutAsJsonAsync($"/v1/roles/{roleId}/permissions", new UpdateRolePermissionsRequest(new[] { codeA, codeB }));
            update.EnsureSuccessStatusCode();

            var codes = (await connection.QueryAsync<string>(@"
SELECT p.[Code]
FROM [Identity].[RolePermission] rp
INNER JOIN [Identity].[Permission] p ON rp.[PermissionId] = p.[PermissionId]
WHERE rp.[RoleId] = @RoleId;
", new { RoleId = roleId })).ToList();

            Assert.Contains(codeA, codes);
            Assert.Contains(codeB, codes);
        }
        finally
        {
            if (!string.IsNullOrWhiteSpace(roleId))
            {
                await connection.ExecuteAsync("DELETE FROM [Identity].[RolePermission] WHERE [RoleId] = @RoleId;", new { RoleId = roleId });
                await connection.ExecuteAsync("DELETE FROM [Identity].[AspNetRoles] WHERE [Id] = @RoleId;", new { RoleId = roleId });
            }

            if (permissionA != 0 || permissionB != 0)
            {
                await connection.ExecuteAsync("DELETE FROM [Identity].[Permission] WHERE [PermissionId] IN (@A,@B);", new { A = permissionA, B = permissionB });
            }
        }
    }

    private static TestSettings LoadSettings()
    {
        var config = new ConfigurationBuilder()
            .SetBasePath(AppContext.BaseDirectory)
            .AddJsonFile("appsettings.Test.json", optional: false)
            .AddEnvironmentVariables()
            .Build();

        var connectionString = config.GetConnectionString("IdentityDb")
            ?? throw new InvalidOperationException("Missing IdentityDb connection string.");

        return new TestSettings(connectionString);
    }

    private sealed record TestSettings(string ConnectionString);
}
