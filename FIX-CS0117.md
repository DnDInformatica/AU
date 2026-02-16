# Fix CS0117: MudStack Row Attribute

## Problema
```
CS0117: 'Direction' non contiene una definizione per 'Row'
```

## Root Cause
**MudBlazor.Direction enum NON ha il valore `Row`!**

L'enum `MudBlazor.Direction` contiene solo:
```csharp
public enum Direction
{
    Bottom,
    Top,
    Left,
    Right,
    Start,
    End
}
```

## Soluzione
MudStack usa un **attributo booleano `Row`**, NON un enum Direction!

### Sintassi Corretta in .razor:
```razor
<MudStack Row="true" Spacing="2">
    <!-- content -->
</MudStack>
```

### Sintassi Corretta in .cs (RenderFragment Builder):
```csharp
builder.OpenComponent<MudStack>(0);
builder.AddAttribute(1, "Row", true);  // ✅ CORRETTO - Boolean
builder.AddAttribute(2, "Spacing", 1);
```

### Sintassi ERRATA:
```csharp
// ❌ ERRORE - Direction.Row non esiste!
builder.AddAttribute(1, "Direction", MudBlazor.Direction.Row);
```

## Codice Corretto - Organizzazioni.razor.cs (Righe 280-285)

```csharp
Actions: builder =>
{
    builder.OpenComponent<MudStack>(0);
    builder.AddAttribute(1, "Row", true);
    builder.AddAttribute(2, "Justify", MudBlazor.Justify.FlexEnd);
    builder.AddAttribute(3, "Spacing", 1);
    builder.AddAttribute(4, "ChildContent", (RenderFragment)(builder2 =>
    {
        // Bottoni...
    }));
    builder.CloseComponent();
}
```

## Build Verification
```powershell
dotnet build C:\Accredia\Sviluppo\AU\Accredia.SIGAD.Web\Accredia.SIGAD.Web.csproj --no-incremental
```

**Risultato:** ✅ Compilazione completata (0 errori, 88 warnings MUD0002 - solo analyzer)

## Lezione Appresa

| Component | Attributo | Tipo | Esempio |
|-----------|-----------|------|---------|
| MudStack in .razor | `Row="true"` | Boolean | `<MudStack Row="true">` |
| MudStack in .cs | `"Row", true` | Boolean | `builder.AddAttribute(1, "Row", true)` |
| **NON** | `Direction.Row` | ❌ Non esiste! | - |

**Regola Generale:**
- Per layout orizzontale: `Row="true"` o `Row={true}`
- Per layout verticale: Omettere `Row` (default è verticale)
