using Accredia.SIGAD.Web.Models.Anagrafiche;
using Accredia.SIGAD.Web.Services;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Forms;
using Microsoft.JSInterop;

namespace Accredia.SIGAD.Web.Components.Shared;

public partial class PersonaDocumentiPanel : ComponentBase
{
    private const long MaxUploadBytes = 25 * 1024 * 1024;

    [Parameter] public int? PersonaId { get; set; }
    [Parameter] public bool AllowPersonaSelection { get; set; } = true;
    [Parameter] public EventCallback<int> ItemsCountChanged { get; set; }

    [Inject] private GatewayClient GatewayClient { get; set; } = default!;
    [Inject] private UserContext UserContext { get; set; } = default!;
    [Inject] private IJSRuntime JS { get; set; } = default!;

    private bool CanRead =>
        UserContext.HasPermission("PERS.DOC.READ")
        || UserContext.HasPermission("PERS.LIST")
        || UserContext.HasPermission("PERS.READ");

    private bool CanCreate =>
        UserContext.HasPermission("PERS.DOC.CREATE")
        || UserContext.HasPermission("PERS.CREATE")
        || UserContext.HasPermission("PERS.UPDATE");

    private bool CanDelete =>
        UserContext.HasPermission("PERS.DOC.DELETE")
        || UserContext.HasPermission("PERS.DELETE");

    private bool _loading;
    private bool _uploading;
    private bool _includeDeleted;
    private int? _personaIdFilter;
    private int? _lastLoadedPersonaId;
    private string? _message;
    private bool _messageIsError;
    private IReadOnlyList<DocumentoItem> _items = Array.Empty<DocumentoItem>();

    private string _uploadNote = string.Empty;
    private string? _selectedFileName;
    private string? _selectedFileContentType;
    private byte[]? _selectedFileContent;
    private long _selectedFileSize;

    protected override async Task OnParametersSetAsync()
    {
        if (!AllowPersonaSelection)
        {
            _personaIdFilter = PersonaId;
        }
        else if (PersonaId.HasValue && PersonaId.Value > 0 && _personaIdFilter != PersonaId)
        {
            _personaIdFilter = PersonaId;
        }

        if (_personaIdFilter.HasValue && _personaIdFilter.Value > 0 && _lastLoadedPersonaId != _personaIdFilter)
        {
            await LoadAsync();
        }
    }

    private async Task LoadAsync()
    {
        if (!_personaIdFilter.HasValue || _personaIdFilter.Value <= 0)
        {
            _items = Array.Empty<DocumentoItem>();
            await NotifyItemsCountChangedAsync();
            return;
        }

        _loading = true;
        _message = null;
        await InvokeAsync(StateHasChanged);
        try
        {
            var personaId = _personaIdFilter.Value;
            var result = await GatewayClient.GetPersonaDocumentiAsync(personaId, _includeDeleted, CancellationToken.None);
            if (!result.IsSuccess || result.Data is null)
            {
                _items = Array.Empty<DocumentoItem>();
                _message = result.StatusCode == System.Net.HttpStatusCode.NotFound
                    ? "Endpoint documenti non disponibile sul backend corrente."
                    : result.Error ?? "Impossibile caricare i documenti.";
                _messageIsError = true;
                await NotifyItemsCountChangedAsync();
                return;
            }

            _items = result.Data;
            _lastLoadedPersonaId = personaId;
            _message = null;
            await NotifyItemsCountChangedAsync();
        }
        finally
        {
            _loading = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private async Task OnFileSelectedAsync(InputFileChangeEventArgs args)
    {
        _message = null;
        _messageIsError = false;
        var file = args.File;

        if (file is null)
        {
            return;
        }

        if (file.Size > MaxUploadBytes)
        {
            _selectedFileContent = null;
            _selectedFileName = null;
            _selectedFileSize = 0;
            _message = $"File troppo grande. Limite: {FormatBytes(MaxUploadBytes)}.";
            _messageIsError = true;
            await InvokeAsync(StateHasChanged);
            return;
        }

        await using var stream = file.OpenReadStream(MaxUploadBytes);
        using var memory = new MemoryStream();
        await stream.CopyToAsync(memory);

        _selectedFileName = file.Name;
        _selectedFileSize = file.Size;
        _selectedFileContentType = string.IsNullOrWhiteSpace(file.ContentType) ? "application/octet-stream" : file.ContentType;
        _selectedFileContent = memory.ToArray();
        await InvokeAsync(StateHasChanged);
    }

    private async Task UploadAsync()
    {
        if (!_personaIdFilter.HasValue || _personaIdFilter.Value <= 0)
        {
            _message = "Seleziona prima un PersonaId valido.";
            _messageIsError = true;
            return;
        }

        if (_selectedFileContent is null || string.IsNullOrWhiteSpace(_selectedFileName))
        {
            _message = "Seleziona un file prima dell'upload.";
            _messageIsError = true;
            return;
        }

        _uploading = true;
        _message = null;
        await InvokeAsync(StateHasChanged);
        try
        {
            var request = new CreatePersonaDocumentoRequest(
                _selectedFileName,
                _selectedFileContentType,
                _selectedFileContent,
                string.IsNullOrWhiteSpace(_uploadNote) ? null : _uploadNote.Trim());

            var result = await GatewayClient.UploadPersonaDocumentoAsync(_personaIdFilter.Value, request, CancellationToken.None);
            if (!result.IsSuccess)
            {
                _message = result.StatusCode == System.Net.HttpStatusCode.NotFound
                    ? "Endpoint upload documenti non disponibile sul backend corrente."
                    : result.Error ?? "Upload non riuscito.";
                _messageIsError = true;
                return;
            }

            _selectedFileName = null;
            _selectedFileSize = 0;
            _selectedFileContent = null;
            _uploadNote = string.Empty;
            _message = "Documento caricato correttamente.";
            _messageIsError = false;
            await LoadAsync();
        }
        finally
        {
            _uploading = false;
            await InvokeAsync(StateHasChanged);
        }
    }

    private async Task DownloadAsync(DocumentoItem item)
    {
        if (!_personaIdFilter.HasValue || _personaIdFilter.Value <= 0)
        {
            return;
        }

        var result = await GatewayClient.DownloadPersonaDocumentoAsync(_personaIdFilter.Value, item.DocumentoId, CancellationToken.None);
        if (!result.IsSuccess || result.Data is null)
        {
            _message = result.StatusCode == System.Net.HttpStatusCode.NotFound
                ? "Endpoint download documenti non disponibile sul backend corrente."
                : result.Error ?? "Download non riuscito.";
            _messageIsError = true;
            await InvokeAsync(StateHasChanged);
            return;
        }

        var base64 = Convert.ToBase64String(result.Data.Content);
        await JS.InvokeVoidAsync("sigadDownloadBase64File", result.Data.FileName, base64, result.Data.ContentType);
    }

    private async Task SoftDeleteAsync(int documentoId)
    {
        if (!_personaIdFilter.HasValue || _personaIdFilter.Value <= 0)
        {
            return;
        }

        var result = await GatewayClient.DeletePersonaDocumentoAsync(_personaIdFilter.Value, documentoId, CancellationToken.None);
        if (!result.IsSuccess)
        {
            _message = result.StatusCode == System.Net.HttpStatusCode.NotFound
                ? "Endpoint delete documenti non disponibile sul backend corrente."
                : result.Error ?? "Soft delete non riuscito.";
            _messageIsError = true;
            await InvokeAsync(StateHasChanged);
            return;
        }

        _message = "Documento eliminato (soft delete).";
        _messageIsError = false;
        await LoadAsync();
    }

    private static string FormatBytes(long bytes)
    {
        if (bytes < 1024) return $"{bytes} B";
        if (bytes < 1024 * 1024) return $"{bytes / 1024d:0.0} KB";
        return $"{bytes / (1024d * 1024d):0.0} MB";
    }

    private async Task NotifyItemsCountChangedAsync()
    {
        if (ItemsCountChanged.HasDelegate)
        {
            await ItemsCountChanged.InvokeAsync(_items.Count);
        }
    }
}
