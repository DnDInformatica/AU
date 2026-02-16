using System;
using Xunit;
using LoginFeature = Accredia.SIGAD.Identity.Api.V1.Features.Auth.Login;
using RefreshFeature = Accredia.SIGAD.Identity.Api.V1.Features.Auth.RefreshToken;
using LogoutFeature = Accredia.SIGAD.Identity.Api.V1.Features.Auth.Logout;
using LogoutUsersFeature = Accredia.SIGAD.Identity.Api.V1.Features.Auth.LogoutUsers;

namespace Accredia.SIGAD.Identity.Api.Tests;

public class AuthValidatorTests
{
    [Fact]
    public void LoginValidator_Throws_WhenUsernameMissing()
    {
        var ex = Assert.Throws<ArgumentException>(() => LoginFeature.Validator.Validate(new LoginFeature.Command("", "password")));
        Assert.Contains("UserName", ex.Message, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void LoginValidator_Throws_WhenPasswordMissing()
    {
        var ex = Assert.Throws<ArgumentException>(() => LoginFeature.Validator.Validate(new LoginFeature.Command("user", "")));
        Assert.Contains("Password", ex.Message, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void RefreshTokenValidator_Throws_WhenTokenMissing()
    {
        var ex = Assert.Throws<ArgumentException>(() => RefreshFeature.Validator.Validate(new RefreshFeature.Command("")));
        Assert.Contains("RefreshToken", ex.Message, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void LogoutValidator_Throws_WhenTokenMissing()
    {
        var ex = Assert.Throws<ArgumentException>(() => LogoutFeature.Validator.Validate(new LogoutFeature.Command("")));
        Assert.Contains("RefreshToken", ex.Message, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void LogoutUsersValidator_Throws_WhenListEmpty()
    {
        var ex = Assert.Throws<ArgumentException>(() => LogoutUsersFeature.Validator.Validate(new LogoutUsersFeature.Command(Array.Empty<string>())));
        Assert.Contains("UserIds", ex.Message, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void LogoutUsersValidator_Throws_WhenListContainsEmpty()
    {
        var ex = Assert.Throws<ArgumentException>(() => LogoutUsersFeature.Validator.Validate(new LogoutUsersFeature.Command(new[] { " " })));
        Assert.Contains("UserIds", ex.Message, StringComparison.OrdinalIgnoreCase);
    }

    [Fact]
    public void LogoutUsersValidator_Allows_ValidList()
    {
        LogoutUsersFeature.Validator.Validate(new LogoutUsersFeature.Command(new[] { "user-1", "user-2" }));
    }
}
