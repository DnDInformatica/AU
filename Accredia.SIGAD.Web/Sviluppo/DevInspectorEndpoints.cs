#if DEBUG
using System.Text;
using System.Text.Json;

namespace Accredia.SIGAD.Web.Sviluppo;

/// <summary>
/// Endpoint del Dev Inspector (Ctrl+Alt+D): salvano richieste di modifica UI e
/// appunti in docs/ui/change-requests e docs/ui/inspector-notes del repository.
/// Solo sviluppo e collaudo (decisione del 2026-11-05): il file e' compilato
/// solo in Debug e gli endpoint esistono solo in ambiente Development; in
/// Release non c'e' nulla. Copia degli endpoint del Portale Accredia
/// (Accredia.Portal.Web/Program.cs), con le cartelle di destinazione di SIGAD.
/// </summary>
internal static class DevInspectorEndpoints
{
    public static void MapDevInspector(this WebApplication app)
    {
        if (!app.Environment.IsDevelopment())
            return;

        app.MapPost("/dev/ui-change-requests", async (
            HttpRequest request,
            IWebHostEnvironment environment,
            CancellationToken cancellationToken) =>
        {
            if (!request.HasFormContentType)
                return Results.BadRequest(new { error = "Atteso multipart/form-data con campo 'payload' (JSON) e file opzionale 'screenshot'." });

            var form = await request.ReadFormAsync(cancellationToken);
            var payloadJson = form["payload"].ToString();
            if (string.IsNullOrWhiteSpace(payloadJson))
                return Results.BadRequest(new { error = "Campo 'payload' obbligatorio." });

            UiChangeRequestPayload? payload;
            try
            {
                payload = JsonSerializer.Deserialize<UiChangeRequestPayload>(payloadJson,
                    new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            }
            catch (JsonException ex)
            {
                return Results.BadRequest(new { error = "Payload JSON non valido: " + ex.Message });
            }

            if (payload is null)
                return Results.BadRequest(new { error = "Payload JSON nullo." });

            if (string.IsNullOrWhiteSpace(payload.UserRequest))
                return Results.BadRequest(new { error = "La descrizione della modifica richiesta è obbligatoria." });

            if (string.IsNullOrWhiteSpace(payload.ChangeType))
                return Results.BadRequest(new { error = "Il tipo di modifica è obbligatorio." });

            var repositoryRoot = Path.GetFullPath(Path.Combine(environment.ContentRootPath, ".."));
            var outputDirectory = Path.Combine(repositoryRoot, "docs", "ui", "change-requests");
            Directory.CreateDirectory(outputDirectory);

            var slug = Slugify(payload.Title);
            if (string.IsNullOrWhiteSpace(slug))
                slug = "ui-change-request";

            var timestamp = DateTime.UtcNow;
            var baseName = $"{timestamp:yyyyMMdd-HHmmss}-{slug}";
            var fileName = $"{baseName}.md";
            var fullPath = Path.Combine(outputDirectory, fileName);
            var fattiDirectory = Path.Combine(outputDirectory, "fatti");
            var fattiPath = Path.Combine(fattiDirectory, fileName);

            string? screenshotRelativeForMarkdown = null;
            string? screenshotRelativeForResponse = null;
            var screenshot = form.Files.GetFile("screenshot");
            if (screenshot is { Length: > 0 })
            {
                var pngFileName = $"{baseName}.png";
                var pngFullPath = Path.Combine(outputDirectory, pngFileName);
                await using (var fs = File.Create(pngFullPath))
                {
                    await screenshot.CopyToAsync(fs, cancellationToken);
                }
                screenshotRelativeForMarkdown = "./" + pngFileName;
                screenshotRelativeForResponse = Path.Combine("docs", "ui", "change-requests", pngFileName).Replace('\\', '/');
            }

            var markdown = BuildChangeRequestMarkdown(payload, timestamp, fattiPath.Replace('\\', '/'), screenshotRelativeForMarkdown);
            await File.WriteAllTextAsync(fullPath, markdown, Encoding.UTF8, cancellationToken);

            var relativePath = Path.Combine("docs", "ui", "change-requests", fileName).Replace('\\', '/');
            return Results.Ok(new { fileName, relativePath, screenshot = screenshotRelativeForResponse });
        }).DisableAntiforgery();

        app.MapPost("/dev/inspector-notes", async (
            HttpRequest request,
            IWebHostEnvironment environment,
            CancellationToken cancellationToken) =>
        {
            if (!request.HasFormContentType)
                return Results.BadRequest(new { error = "Atteso multipart/form-data con campo 'payload' (JSON) e file opzionale 'screenshot'." });

            var form = await request.ReadFormAsync(cancellationToken);
            var payloadJson = form["payload"].ToString();
            if (string.IsNullOrWhiteSpace(payloadJson))
                return Results.BadRequest(new { error = "Campo 'payload' obbligatorio." });

            InspectorNotePayload? note;
            try
            {
                note = JsonSerializer.Deserialize<InspectorNotePayload>(payloadJson,
                    new JsonSerializerOptions { PropertyNameCaseInsensitive = true });
            }
            catch (JsonException ex)
            {
                return Results.BadRequest(new { error = "Payload JSON non valido: " + ex.Message });
            }

            if (note is null)
                return Results.BadRequest(new { error = "Payload JSON nullo." });

            var validTipi = new[] { "DECISIONE", "BUG_TODO", "DOMANDA", "KNOWLEDGE" };
            var validSeverity = new[] { "LOW", "MEDIUM", "HIGH", "CRITICAL" };
            var validStato = new[] { "APERTO", "CHIUSO", "IN_VALUTAZIONE" };

            if (string.IsNullOrWhiteSpace(note.Tipo) || !validTipi.Contains(note.Tipo))
                return Results.BadRequest(new { error = "Campo 'tipo' obbligatorio e deve essere uno di: " + string.Join(", ", validTipi) });

            if (string.IsNullOrWhiteSpace(note.Titolo))
                return Results.BadRequest(new { error = "Campo 'titolo' obbligatorio." });

            if (string.IsNullOrWhiteSpace(note.Contenuto))
                return Results.BadRequest(new { error = "Campo 'contenuto' obbligatorio." });

            if (note.Tipo == "BUG_TODO" && (string.IsNullOrWhiteSpace(note.Severity) || !validSeverity.Contains(note.Severity)))
                return Results.BadRequest(new { error = "Per tipo BUG_TODO, 'severity' è obbligatoria e deve essere una di: " + string.Join(", ", validSeverity) });

            if (!string.IsNullOrWhiteSpace(note.Severity) && !validSeverity.Contains(note.Severity))
                return Results.BadRequest(new { error = "Valore 'severity' non valido. Ammessi: " + string.Join(", ", validSeverity) });

            if (!string.IsNullOrWhiteSpace(note.Stato) && !validStato.Contains(note.Stato))
                return Results.BadRequest(new { error = "Valore 'stato' non valido. Ammessi: " + string.Join(", ", validStato) });

            var repositoryRoot = Path.GetFullPath(Path.Combine(environment.ContentRootPath, ".."));
            var outputDirectory = Path.Combine(repositoryRoot, "docs", "ui", "inspector-notes");
            Directory.CreateDirectory(outputDirectory);

            var slug = Slugify(note.Titolo);
            if (string.IsNullOrWhiteSpace(slug))
                slug = "note";

            var timestamp = DateTime.UtcNow;
            var tipoSlug = note.Tipo.ToLowerInvariant();
            var baseName = $"{timestamp:yyyyMMdd-HHmmss}-{tipoSlug}-{slug}";
            var fileName = $"{baseName}.md";
            var fullPath = Path.Combine(outputDirectory, fileName);

            string? screenshotRelativeForMarkdown = null;
            string? screenshotRelativeForResponse = null;
            var screenshot = form.Files.GetFile("screenshot");
            if (screenshot is { Length: > 0 })
            {
                var pngFileName = $"{baseName}.png";
                var pngFullPath = Path.Combine(outputDirectory, pngFileName);
                await using (var fs = File.Create(pngFullPath))
                {
                    await screenshot.CopyToAsync(fs, cancellationToken);
                }
                screenshotRelativeForMarkdown = "./" + pngFileName;
                screenshotRelativeForResponse = Path.Combine("docs", "ui", "inspector-notes", pngFileName).Replace('\\', '/');
            }

            var markdown = BuildNoteMarkdown(note, timestamp, screenshotRelativeForMarkdown);
            await File.WriteAllTextAsync(fullPath, markdown, Encoding.UTF8, cancellationToken);

            var relativePath = Path.Combine("docs", "ui", "inspector-notes", fileName).Replace('\\', '/');
            return Results.Ok(new { fileName, relativePath, screenshot = screenshotRelativeForResponse });
        }).DisableAntiforgery();
    }

    private static string BuildChangeRequestMarkdown(UiChangeRequestPayload payload, DateTime timestampUtc, string fattiPath, string? screenshotRelativePath)
    {
        var sb = new StringBuilder();
        var title = string.IsNullOrWhiteSpace(payload.Title)
            ? "Richiesta modifica UI"
            : payload.Title.Trim();

        // Intestazione
        sb.AppendLine($"# {title}");
        sb.AppendLine();

        // 1. Natura della modifica
        sb.AppendLine("## 1. Natura della modifica");
        sb.AppendLine();
        sb.AppendLine($"- **Categoria**: `{payload.ChangeType ?? "-"}`");
        sb.AppendLine($"- **Componente sorgente**: `{(string.IsNullOrWhiteSpace(payload.TargetComponent) ? DeriveTargetComponent(payload.ComponentChain) : payload.TargetComponent.Trim())}`");
        sb.AppendLine();

        // 2. Modifica richiesta
        sb.AppendLine("## 2. Modifica Richiesta");
        sb.AppendLine();
        sb.AppendLine(string.IsNullOrWhiteSpace(payload.UserRequest) ? "-" : payload.UserRequest.Trim());
        sb.AppendLine();

        // 3. Stato attuale
        sb.AppendLine("## 3. Stato Attuale");
        sb.AppendLine();
        sb.AppendLine(string.IsNullOrWhiteSpace(payload.CurrentState) ? "-" : payload.CurrentState.Trim());
        sb.AppendLine();

        // 4. Stato target
        sb.AppendLine("## 4. Stato Target");
        sb.AppendLine();
        sb.AppendLine(string.IsNullOrWhiteSpace(payload.TargetState) ? "-" : payload.TargetState.Trim());
        sb.AppendLine();

        // 5. Criteri di accettazione
        sb.AppendLine("## 5. Criteri di Accettazione");
        sb.AppendLine();
        var ac = payload.AcceptanceCriteria;
        var hasVisual   = ac is not null && !string.IsNullOrWhiteSpace(ac.Visual);
        var hasBehavior = ac is not null && !string.IsNullOrWhiteSpace(ac.Behavior);
        var hasReject   = ac is not null && !string.IsNullOrWhiteSpace(ac.Reject);

        if (!hasVisual && !hasBehavior && !hasReject)
        {
            sb.AppendLine("-");
        }
        else
        {
            if (hasVisual)
            {
                sb.AppendLine("### ✅ Stato visivo finale");
                sb.AppendLine(ac!.Visual!.Trim());
                sb.AppendLine();
            }
            if (hasBehavior)
            {
                sb.AppendLine("### ✅ Comportamento / interazione");
                sb.AppendLine(ac!.Behavior!.Trim());
                sb.AppendLine();
            }
            if (hasReject)
            {
                sb.AppendLine("### ❌ Condizioni di rifiuto");
                sb.AppendLine(ac!.Reject!.Trim());
                sb.AppendLine();
            }
        }

        // 6. Invarianti
        sb.AppendLine("## 6. Invarianti");
        sb.AppendLine();
        sb.AppendLine(string.IsNullOrWhiteSpace(payload.Invariants) ? "-" : payload.Invariants.Trim());
        sb.AppendLine();

        // 7. Vincoli tecnici
        sb.AppendLine("## 7. Vincoli Tecnici");
        sb.AppendLine();
        sb.AppendLine(string.IsNullOrWhiteSpace(payload.Constraints) ? "-" : payload.Constraints.Trim());
        sb.AppendLine();

        // 8. Riferimenti
        sb.AppendLine("## 8. Riferimenti");
        sb.AppendLine();
        sb.AppendLine(string.IsNullOrWhiteSpace(payload.References) ? "-" : payload.References.Trim());
        sb.AppendLine();

        // 9. Contesto tecnico (auto)
        sb.AppendLine("## 9. Contesto Tecnico");
        sb.AppendLine();
        sb.AppendLine($"- Timestamp UTC: `{timestampUtc:O}`");
        sb.AppendLine($"- Route: `{payload.Route ?? "-"}`");
        if (payload.Viewport is not null)
        {
            sb.AppendLine($"- Viewport: `{payload.Viewport.Width} x {payload.Viewport.Height}`");
            sb.AppendLine($"- Device Pixel Ratio: `{payload.Viewport.PixelRatio}`");
        }

        if (!string.IsNullOrWhiteSpace(screenshotRelativePath))
        {
            sb.AppendLine();
            sb.AppendLine("### Screenshot elemento");
            sb.AppendLine();
            sb.AppendLine($"![Screenshot dell'elemento selezionato]({screenshotRelativePath})");
        }
        sb.AppendLine();

        // 10. Elemento selezionato (auto)
        sb.AppendLine("## 10. Elemento Selezionato");
        sb.AppendLine();
        if (payload.Element is null)
        {
            sb.AppendLine("-");
        }
        else
        {
            sb.AppendLine($"- Tag: `{payload.Element.TagName ?? "-"}`");
            sb.AppendLine($"- Id: `{payload.Element.Id ?? "-"}`");
            sb.AppendLine($"- Classi: `{payload.Element.ClassName ?? "-"}`");
            sb.AppendLine($"- DOM Path: `{payload.Element.DomPath ?? "-"}`");
            sb.AppendLine($"- Testo (preview): `{payload.Element.TextPreview ?? "-"}`");
            if (payload.Element.Bounds is not null)
                sb.AppendLine($"- Bounds: `x={payload.Element.Bounds.X}, y={payload.Element.Bounds.Y}, w={payload.Element.Bounds.Width}, h={payload.Element.Bounds.Height}`");

            if (payload.Element.Attributes is { Count: > 0 })
            {
                sb.AppendLine();
                sb.AppendLine("### Attributi DOM");
                foreach (var attribute in payload.Element.Attributes)
                    sb.AppendLine($"- `{attribute.Name}` = `{attribute.Value}`");
            }
        }
        sb.AppendLine();

        // 11. Catena componenti (auto)
        sb.AppendLine("## 11. Catena Componenti");
        sb.AppendLine();
        if (payload.ComponentChain is { Count: > 0 })
            foreach (var component in payload.ComponentChain)
                sb.AppendLine($"- `{component.Name}` ({component.Source})");
        else
            sb.AppendLine("-");
        sb.AppendLine();

        // 12. CSS matchati (auto)
        sb.AppendLine("## 12. CSS Matchati");
        sb.AppendLine();
        if (payload.CssMatches is { Count: > 0 })
            foreach (var css in payload.CssMatches.Take(120))
                sb.AppendLine($"- `{css.Selector}` ({css.Source})");
        else
            sb.AppendLine("-");
        sb.AppendLine();

        // 13. Note operative per Claude Code (auto)
        sb.AppendLine("## 13. Note Operative Per Claude Code");
        sb.AppendLine();
        sb.AppendLine($"- Il componente sorgente prioritario è `{(string.IsNullOrWhiteSpace(payload.TargetComponent) ? DeriveTargetComponent(payload.ComponentChain) : payload.TargetComponent.Trim())}` — individuato dalla catena `data-dev-component`.");
        sb.AppendLine("- Applicare modifica mantenendo pattern MudBlazor esistenti. Nessun CSS inline se esiste classe MudBlazor equivalente.");
        sb.AppendLine("- Verificare regressioni su: responsive · stati loading/error/empty · interazioni keyboard.");
        sb.AppendLine("- Dopo l'esecuzione, spostare questo file in:");
        sb.AppendLine($"  `{fattiPath}`");
        sb.AppendLine("- Aggiornare la sezione **14. Eseguito** con data, esito e note.");
        sb.AppendLine();

        // 14. Sezione eseguito (da compilare dopo)
        sb.AppendLine("## 14. Eseguito");
        sb.AppendLine();
        sb.AppendLine("- **Data esecuzione**: -");
        sb.AppendLine("- **Esito**: `IN ATTESA` | `COMPLETATO` | `PARZIALE` | `BLOCCATO`");
        sb.AppendLine("- **File modificati**: -");
        sb.AppendLine("- **Note**: -");

        return sb.ToString();
    }

    private static string BuildNoteMarkdown(InspectorNotePayload note, DateTime timestampUtc, string? screenshotRelativePath)
    {
        var sb = new StringBuilder();

        var titolo = note.Titolo!.Trim();
        var componente = string.IsNullOrWhiteSpace(note.Componente)
            ? DeriveTargetComponent(note.ComponentChain)
            : note.Componente.Trim();

        var tagList = string.IsNullOrWhiteSpace(note.Tag)
            ? Array.Empty<string>()
            : note.Tag.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);

        var catenaList = note.ComponentChain is { Count: > 0 }
            ? note.ComponentChain.Select(c => c.Name).ToArray()
            : Array.Empty<string>();

        // YAML frontmatter
        sb.AppendLine("---");
        sb.AppendLine($"tipo: {note.Tipo}");
        sb.AppendLine($"titolo: {YamlEscape(titolo)}");
        sb.AppendLine($"tag: [{string.Join(", ", tagList.Select(YamlEscapeArrayItem))}]");
        if (!string.IsNullOrWhiteSpace(note.Severity))
            sb.AppendLine($"severity: {note.Severity}");
        if (!string.IsNullOrWhiteSpace(note.Stato))
            sb.AppendLine($"stato: {note.Stato}");
        sb.AppendLine($"componente: {YamlEscape(componente)}");
        sb.AppendLine($"route: {YamlEscape(note.Route ?? "-")}");
        sb.AppendLine($"timestamp: {timestampUtc:yyyy-MM-ddTHH:mm:ssZ}");
        if (note.Viewport is not null)
            sb.AppendLine($"viewport: {note.Viewport.Width}x{note.Viewport.Height}");
        if (catenaList.Length > 0)
            sb.AppendLine($"catena: [{string.Join(", ", catenaList.Select(YamlEscapeArrayItem))}]");
        sb.AppendLine("---");
        sb.AppendLine();

        // Body
        sb.AppendLine($"# {titolo}");
        sb.AppendLine();

        sb.AppendLine("## Contenuto");
        sb.AppendLine();
        sb.AppendLine(note.Contenuto!.Trim());
        sb.AppendLine();

        sb.AppendLine("## Riferimenti");
        sb.AppendLine();
        sb.AppendLine(string.IsNullOrWhiteSpace(note.Riferimenti) ? "-" : note.Riferimenti.Trim());
        sb.AppendLine();

        if (!string.IsNullOrWhiteSpace(screenshotRelativePath))
        {
            sb.AppendLine("## Contesto");
            sb.AppendLine();
            sb.AppendLine($"![Screenshot dell'elemento]({screenshotRelativePath})");
            sb.AppendLine();
        }

        return sb.ToString();
    }

    private static string YamlEscape(string value)
    {
        if (string.IsNullOrEmpty(value)) return "\"\"";
        if (value.Contains(':') || value.Contains('#') || value.Contains('"') || value.Contains('\n'))
            return "\"" + value.Replace("\\", "\\\\").Replace("\"", "\\\"") + "\"";
        return value;
    }

    private static string YamlEscapeArrayItem(string value)
    {
        if (string.IsNullOrEmpty(value)) return "\"\"";
        if (value.Contains(',') || value.Contains('[') || value.Contains(']') || value.Contains('"'))
            return "\"" + value.Replace("\\", "\\\\").Replace("\"", "\\\"") + "\"";
        return value;
    }

    private static string DeriveTargetComponent(List<ComponentPayload>? chain)
    {
        if (chain is null || chain.Count == 0) return "-";
        var first = chain.FirstOrDefault(c => !string.IsNullOrWhiteSpace(c.Source));
        return first?.Source ?? chain[0].Name;
    }

    private static string Slugify(string? value)
    {
        if (string.IsNullOrWhiteSpace(value))
            return string.Empty;

        var sb = new StringBuilder();
        foreach (var c in value.Trim().ToLowerInvariant())
        {
            if (char.IsLetterOrDigit(c))
            {
                sb.Append(c);
                continue;
            }

            if (c is ' ' or '-' or '_' or '.')
                sb.Append('-');
        }

        var normalized = sb.ToString();
        while (normalized.Contains("--", StringComparison.Ordinal))
            normalized = normalized.Replace("--", "-", StringComparison.Ordinal);

        return normalized.Trim('-');
    }

}

internal sealed record UiChangeRequestPayload(
    string? Title,
    string? ChangeType,
    string? TargetComponent,
    string? UserRequest,
    string? CurrentState,
    string? TargetState,
    string? Invariants,
    string? Constraints,
    string? References,
    AcceptanceCriteriaPayload? AcceptanceCriteria,
    string? Route,
    ViewportPayload? Viewport,
    ElementPayload? Element,
    List<ComponentPayload>? ComponentChain,
    List<CssMatchPayload>? CssMatches);

internal sealed record AcceptanceCriteriaPayload(string? Visual, string? Behavior, string? Reject);

internal sealed record InspectorNotePayload(
    string? Tipo,
    string? Titolo,
    string? Contenuto,
    string? Tag,
    string? Severity,
    string? Stato,
    string? Riferimenti,
    string? Componente,
    string? Route,
    ViewportPayload? Viewport,
    List<ComponentPayload>? ComponentChain);

internal sealed record ViewportPayload(int Width, int Height, double PixelRatio);

internal sealed record ElementPayload(
    string? TagName,
    string? Id,
    string? ClassName,
    string? TextPreview,
    string? DomPath,
    BoundsPayload? Bounds,
    List<ElementAttributePayload>? Attributes);

internal sealed record BoundsPayload(double X, double Y, double Width, double Height);

internal sealed record ElementAttributePayload(string Name, string Value);

internal sealed record ComponentPayload(string Name, string Source);

internal sealed record CssMatchPayload(string Selector, string Source);

#endif
