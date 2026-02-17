using MudBlazor;

namespace Accredia.SIGAD.Web.Components.Theme;

internal static class SigadTheme
{
    public static readonly MudTheme Default = new()
    {
        PaletteLight = new PaletteLight
        {
            // Mockup tokens: ocra as primary action, grafite as text/secondary.
            Primary = "#d4a574",
            PrimaryContrastText = "#1a1a2e",
            Secondary = "#1a1a2e",
            SecondaryContrastText = "#ffffff",
            Background = "#f8f7f5",
            Surface = "#ffffff",
            AppbarBackground = "#f8f7f5",
            AppbarText = "#1a1a2e",
            DrawerBackground = "#1a1a2e",
            DrawerText = "#ffffffde",  // rgba(255,255,255,0.87)
            TextPrimary = "#1a1a2e",
            TextSecondary = "#666666",
            TextDisabled = "#bdbdbd",
            Info = "#0277bd",
            Success = "#2e7d32",
            Warning = "#f57c00",
            Error = "#c62828"
        },
        LayoutProperties = new LayoutProperties
        {
            DefaultBorderRadius = "16px"
        },
        Typography = new Typography
        {
            Default = new DefaultTypography
            {
                FontFamily = new[] { "Open Sans", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontSize = ".95rem",
                FontWeight = "400",
                LineHeight = "1.5"
            },
            H1 = new H1Typography
            {
                FontFamily = new[] { "Montserrat", "Open Sans", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontWeight = "800",
                LineHeight = "1.1"
            },
            H2 = new H2Typography
            {
                FontFamily = new[] { "Montserrat", "Open Sans", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontWeight = "800",
                LineHeight = "1.1"
            },
            H3 = new H3Typography
            {
                FontFamily = new[] { "Montserrat", "Open Sans", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontWeight = "800",
                LineHeight = "1.15"
            },
            H4 = new H4Typography
            {
                FontFamily = new[] { "Montserrat", "Open Sans", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontWeight = "800",
                LineHeight = "1.2"
            },
            H5 = new H5Typography
            {
                FontFamily = new[] { "Montserrat", "Open Sans", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontWeight = "800",
                LineHeight = "1.2"
            },
            H6 = new H6Typography
            {
                FontFamily = new[] { "Montserrat", "Open Sans", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontWeight = "800",
                LineHeight = "1.2"
            },
            Body1 = new Body1Typography
            {
                FontFamily = new[] { "Open Sans", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontWeight = "400",
                LineHeight = "1.45"
            },
            Body2 = new Body2Typography
            {
                FontFamily = new[] { "Open Sans", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontWeight = "400",
                LineHeight = "1.45"
            },
            Button = new ButtonTypography
            {
                FontFamily = new[] { "Open Sans", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontWeight = "700",
                TextTransform = "none"
            }
        }
    };
}
