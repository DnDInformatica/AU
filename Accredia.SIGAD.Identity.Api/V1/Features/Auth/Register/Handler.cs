using Dapper;
using Accredia.SIGAD.Identity.Api.Database;
using Microsoft.AspNetCore.Identity;

namespace Accredia.SIGAD.Identity.Api.V1.Features.Auth.Register;

internal static class Handler
{
    // Dummy user class for password hashing
    private sealed class DummyUser { }

    public static async Task<RegisterResponse?> Handle(
        Command command,
        ISqlConnectionFactory connectionFactory,
        CancellationToken cancellationToken)
    {
        ArgumentNullException.ThrowIfNull(command);
        ArgumentNullException.ThrowIfNull(connectionFactory);

        // Hash password using ASP.NET Core Identity's PasswordHasher
        var hasher = new PasswordHasher<DummyUser>();
        var passwordHash = hasher.HashPassword(new DummyUser(), command.Password);

        // ASP.NET Identity usa GUID come stringa per Id
        var userId = Guid.NewGuid().ToString();
        var normalizedUserName = command.UserName.ToUpperInvariant();
        var normalizedEmail = command.Email.ToUpperInvariant();
        var securityStamp = Guid.NewGuid().ToString();
        var concurrencyStamp = Guid.NewGuid().ToString();

        const string sql = @"
-- Check if user already exists
IF EXISTS (SELECT 1 FROM [Identity].[AspNetUsers] WHERE [NormalizedUserName] = @NormalizedUserName OR [NormalizedEmail] = @NormalizedEmail)
BEGIN
    SELECT NULL AS UserId, NULL AS UserName, NULL AS Email;
    RETURN;
END

-- Insert new user into AspNetUsers
INSERT INTO [Identity].[AspNetUsers] (
    [Id], [UserName], [NormalizedUserName], [Email], [NormalizedEmail],
    [EmailConfirmed], [PasswordHash], [SecurityStamp], [ConcurrencyStamp],
    [PhoneNumberConfirmed], [TwoFactorEnabled], [LockoutEnabled], [AccessFailedCount]
)
VALUES (
    @UserId, @UserName, @NormalizedUserName, @Email, @NormalizedEmail,
    0, @PasswordHash, @SecurityStamp, @ConcurrencyStamp,
    0, 0, 1, 0
);

-- Assign default 'User' role if exists
DECLARE @RoleId NVARCHAR(450) = (SELECT [Id] FROM [Identity].[AspNetRoles] WHERE [NormalizedName] = 'USER');
IF @RoleId IS NOT NULL
BEGIN
    INSERT INTO [Identity].[AspNetUserRoles] ([UserId], [RoleId]) VALUES (@UserId, @RoleId);
END

SELECT @UserId AS UserId, @UserName AS UserName, @Email AS Email;
";

        await using var connection = await connectionFactory.CreateOpenConnectionAsync(cancellationToken);
        var result = await connection.QuerySingleOrDefaultAsync<RegisterResponse>(
            new CommandDefinition(sql, new
            {
                UserId = userId,
                command.UserName,
                NormalizedUserName = normalizedUserName,
                command.Email,
                NormalizedEmail = normalizedEmail,
                PasswordHash = passwordHash,
                SecurityStamp = securityStamp,
                ConcurrencyStamp = concurrencyStamp
            }, cancellationToken: cancellationToken));

        return result?.UserId != null ? result : null;
    }
}
