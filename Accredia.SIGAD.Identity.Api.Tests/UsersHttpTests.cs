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

public class UsersHttpTests : IClassFixture<TestWebApplicationFactory>
{
    private readonly TestWebApplicationFactory _factory;

    public UsersHttpTests(TestWebApplicationFactory factory)
    {
        _factory = factory;
    }

    [Fact]
    public async Task Users_List_Returns_Paged_Response()
    {
        var settings = LoadSettings();

        await using var connection = new SqlConnection(settings.ConnectionString);
        await connection.OpenAsync();

        var userId = Guid.NewGuid().ToString("N");

        try
        {
            await connection.ExecuteAsync(@"
INSERT INTO [Identity].[AspNetUsers] (
    [Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail],
    [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp],
    [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled],
    [LockoutEnd], [LockoutEnabled], [AccessFailedCount]
)
VALUES (
    @Id, @UserName, @NormalizedUserName, @Email, @NormalizedEmail,
    0, NULL, NULL, @ConcurrencyStamp,
    NULL, 0, 0,
    NULL, 0, 0
);
", new
            {
                Id = userId,
                UserName = $"test.user.{userId}",
                NormalizedUserName = $"TEST.USER.{userId}".ToUpperInvariant(),
                Email = $"test.{userId}@example.local",
                NormalizedEmail = $"TEST.{userId}@EXAMPLE.LOCAL",
                ConcurrencyStamp = Guid.NewGuid().ToString()
            });

            using var client = _factory.CreateClient();

            var response = await client.GetFromJsonAsync<UsersListResponse>("/v1/users?page=1&pageSize=10");
            Assert.NotNull(response);
            Assert.True(response!.TotalCount >= 1);
            Assert.Equal(1, response.Page);
            Assert.Equal(10, response.PageSize);
            Assert.Contains(response.Users, u => u.UserId == userId);
        }
        finally
        {
            await connection.ExecuteAsync("DELETE FROM [Identity].[AspNetUserRoles] WHERE [UserId] = @UserId;", new { UserId = userId });
            await connection.ExecuteAsync("DELETE FROM [Identity].[AspNetUsers] WHERE [Id] = @UserId;", new { UserId = userId });
        }
    }

    [Fact]
    public async Task Users_SetRoles_Replaces_Assignments_Via_Http()
    {
        var settings = LoadSettings();

        await using var connection = new SqlConnection(settings.ConnectionString);
        await connection.OpenAsync();

        var userId = Guid.NewGuid().ToString("N");
        var roleA = $"TEST_ROLE_A_{Guid.NewGuid():N}";
        var roleB = $"TEST_ROLE_B_{Guid.NewGuid():N}";
        var roleAId = Guid.NewGuid().ToString("N");
        var roleBId = Guid.NewGuid().ToString("N");

        try
        {
            await connection.ExecuteAsync(@"
INSERT INTO [Identity].[AspNetUsers] (
    [Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail],
    [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp],
    [PhoneNumber], [PhoneNumberConfirmed], [TwoFactorEnabled],
    [LockoutEnd], [LockoutEnabled], [AccessFailedCount]
)
VALUES (
    @Id, @UserName, @NormalizedUserName, @Email, @NormalizedEmail,
    0, NULL, NULL, @ConcurrencyStamp,
    NULL, 0, 0,
    NULL, 0, 0
);
", new
            {
                Id = userId,
                UserName = $"test.user.{userId}",
                NormalizedUserName = $"TEST.USER.{userId}".ToUpperInvariant(),
                Email = $"test.{userId}@example.local",
                NormalizedEmail = $"TEST.{userId}@EXAMPLE.LOCAL",
                ConcurrencyStamp = Guid.NewGuid().ToString()
            });

            await connection.ExecuteAsync(@"
INSERT INTO [Identity].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp])
VALUES (@Id, @Name, @NormalizedName, @ConcurrencyStamp);
", new
            {
                Id = roleAId,
                Name = roleA,
                NormalizedName = roleA.ToUpperInvariant(),
                ConcurrencyStamp = Guid.NewGuid().ToString()
            });

            await connection.ExecuteAsync(@"
INSERT INTO [Identity].[AspNetRoles] ([Id], [Name], [NormalizedName], [ConcurrencyStamp])
VALUES (@Id, @Name, @NormalizedName, @ConcurrencyStamp);
", new
            {
                Id = roleBId,
                Name = roleB,
                NormalizedName = roleB.ToUpperInvariant(),
                ConcurrencyStamp = Guid.NewGuid().ToString()
            });

            using var client = _factory.CreateClient();

            var set = await client.PutAsJsonAsync($"/v1/users/{userId}/roles", new SetUserRolesRequest(new[] { roleA, roleB }));
            set.EnsureSuccessStatusCode();

            var dbRoles = (await connection.QueryAsync<string>(@"
SELECT r.[Name]
FROM [Identity].[AspNetUserRoles] ur
INNER JOIN [Identity].[AspNetRoles] r ON ur.[RoleId] = r.[Id]
WHERE ur.[UserId] = @UserId;
", new { UserId = userId })).ToList();

            Assert.Contains(roleA, dbRoles);
            Assert.Contains(roleB, dbRoles);

            // Replace with only roleA
            var replace = await client.PutAsJsonAsync($"/v1/users/{userId}/roles", new SetUserRolesRequest(new[] { roleA }));
            replace.EnsureSuccessStatusCode();

            var dbRoles2 = (await connection.QueryAsync<string>(@"
SELECT r.[Name]
FROM [Identity].[AspNetUserRoles] ur
INNER JOIN [Identity].[AspNetRoles] r ON ur.[RoleId] = r.[Id]
WHERE ur.[UserId] = @UserId;
", new { UserId = userId })).ToList();

            Assert.Contains(roleA, dbRoles2);
            Assert.DoesNotContain(roleB, dbRoles2);
        }
        finally
        {
            await connection.ExecuteAsync("DELETE FROM [Identity].[AspNetUserRoles] WHERE [UserId] = @UserId;", new { UserId = userId });
            await connection.ExecuteAsync("DELETE FROM [Identity].[AspNetUsers] WHERE [Id] = @UserId;", new { UserId = userId });
            await connection.ExecuteAsync("DELETE FROM [Identity].[AspNetRoles] WHERE [Id] IN (@A, @B);", new { A = roleAId, B = roleBId });
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

