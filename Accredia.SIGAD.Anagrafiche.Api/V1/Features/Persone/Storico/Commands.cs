namespace Accredia.SIGAD.Anagrafiche.Api.V1.Features.Persone.Storico;

internal sealed record PersonaCommand(int PersonaId);

internal sealed record RegistroTrattamentiCommand(int RegistroTrattamentiId);

internal sealed record RichiestaGdprCommand(int RichiestaGdprId);

internal sealed record RichiestaEsercizioDirittiCommand(int RichiestaEsercizioDirittiId);

internal sealed record DataBreachCommand(int DataBreachId);

