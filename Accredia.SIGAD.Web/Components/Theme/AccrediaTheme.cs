using MudBlazor;

// ==========================================================================
// Accredia Theme condivisa — v1.0 (05-10-2026)
// Fonte: manuale IO-01-01 rev.00 "Corporate Identity" (03-12-2024) +
// specifica ACCREDIA_WEB_DESIGN_SYSTEM_UNIFICATO.md (workspace AU).
//
// COPIA CONFORME in:
//   - Accredia.SIGAD.Web/Components/Theme/AccrediaTheme.cs
//   - Accredia.Portal.Web/Components/Layout/AccrediaTheme.cs
// Differisce solo il namespace: modificare sempre entrambe le copie.
//
// Regole chiave: l'ocra (#DE7E00) è accento, mai fondo di azioni primarie;
// il primario è la grafite #2B2B21; i semantici sono Blu Indaco / Verde
// Smeraldo / Rosso Cardinale / ocra scuro #8A5A00.
// HoverOpacity e ActionDefault preservano il guardrail di
// WORKPLAN_UX_REDESIGN.md (drawer scuro, validazione hover nav).
// ==========================================================================

namespace Accredia.SIGAD.Web.Components.Theme;

internal static class AccrediaTheme
{
    public static readonly MudTheme Default = new()
    {
        PaletteLight = new PaletteLight
        {
            // Azioni e selezioni: grafite IO-01-01. L'ocra resta Secondary/accento.
            Primary = "#2B2B21",
            PrimaryContrastText = "#FFFFFF",
            Secondary = "#DE7E00",
            SecondaryContrastText = "#2B2B21",
            Tertiary = "#004C97",
            Background = "#FFFFFF",
            Surface = "#FFFFFF",
            AppbarBackground = "#FFFFFF",
            AppbarText = "#2B2B21",
            DrawerBackground = "#2B2B21",
            DrawerText = "#FCF2E5",
            TextPrimary = "#2B2B21",
            TextSecondary = "#5F5E5A",
            TextDisabled = "#BDBDBD",
            Info = "#004C97",
            Success = "#008264",
            Warning = "#8A5A00",
            Error = "#BA0C2F",

            // ► GUARDRAIL hover nav (non alterare senza verifica visiva) ◄
            HoverOpacity = 0.08,
            ActionDefault = "rgba(255, 255, 255, 0.87)"
        },
        PaletteDark = new PaletteDark
        {
            // Su fondo grafite scuro l'accento caldo ad alto contrasto è l'ocra 50%.
            Primary = "#EEBE80",
            PrimaryContrastText = "#2B2B21",
            Secondary = "#DE7E00",
            SecondaryContrastText = "#1E1E1A",
            Tertiary = "#7EB1EB",
            Background = "#1E1E1A",
            Surface = "#26261F",
            AppbarBackground = "#26261F",
            AppbarText = "#F5F2EA",
            DrawerBackground = "#1E1E1A",
            DrawerText = "#F5F2EA",
            TextPrimary = "#F5F2EA",
            TextSecondary = "#D6D2C4",
            TextDisabled = "#6B6A5F",
            Info = "#7EB1EB",
            Success = "#5FAE82",
            Warning = "#D19A54",
            Error = "#D96D6D",
            HoverOpacity = 0.08,
            ActionDefault = "rgba(255, 255, 255, 0.87)"
        },
        LayoutProperties = new LayoutProperties
        {
            // Default gestionale (scala condivisa 4/8/12/16/24).
            DefaultBorderRadius = "8px"
        },
        Typography = new Typography
        {
            Default = new DefaultTypography
            {
                FontFamily = new[] { "Open Sans Accredia", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontSize = ".95rem",
                FontWeight = "400",
                LineHeight = "1.5"
            },
            H1 = new H1Typography
            {
                FontFamily = new[] { "Montserrat Accredia", "Open Sans Accredia", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontWeight = "800",
                LineHeight = "1.1"
            },
            H2 = new H2Typography
            {
                FontFamily = new[] { "Montserrat Accredia", "Open Sans Accredia", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontWeight = "800",
                LineHeight = "1.1"
            },
            H3 = new H3Typography
            {
                FontFamily = new[] { "Montserrat Accredia", "Open Sans Accredia", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontWeight = "800",
                LineHeight = "1.15"
            },
            H4 = new H4Typography
            {
                FontFamily = new[] { "Montserrat Accredia", "Open Sans Accredia", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontWeight = "800",
                LineHeight = "1.2"
            },
            H5 = new H5Typography
            {
                FontFamily = new[] { "Montserrat Accredia", "Open Sans Accredia", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontWeight = "800",
                LineHeight = "1.2"
            },
            H6 = new H6Typography
            {
                FontFamily = new[] { "Montserrat Accredia", "Open Sans Accredia", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontWeight = "800",
                LineHeight = "1.2"
            },
            Body1 = new Body1Typography
            {
                FontFamily = new[] { "Open Sans Accredia", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontWeight = "400",
                LineHeight = "1.45"
            },
            Body2 = new Body2Typography
            {
                FontFamily = new[] { "Open Sans Accredia", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontWeight = "400",
                LineHeight = "1.45"
            },
            Button = new ButtonTypography
            {
                FontFamily = new[] { "Open Sans Accredia", "system-ui", "Segoe UI", "Arial", "sans-serif" },
                FontWeight = "700",
                TextTransform = "none"
            }
        }
    };
}
