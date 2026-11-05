using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Components.Authorization;
using Microsoft.AspNetCore.Components.Routing;
using Microsoft.AspNetCore.Components.Web;
using Microsoft.JSInterop;
using MudBlazor;
using Accredia.SIGAD.Web.Auth;
using Accredia.SIGAD.Web.Models.Admin;
using Accredia.SIGAD.Web.Models.Anagrafiche;
using Accredia.SIGAD.Web.Models.Auth;
using Accredia.SIGAD.Web.Models.Common;
using Accredia.SIGAD.Web.Models.RisorseUmane;
using Accredia.SIGAD.Web.Models.Search;
using Accredia.SIGAD.Web.Models.Tipologiche;
using Accredia.SIGAD.Web.Services;
using BreadcrumbItem = Accredia.SIGAD.Web.Models.Common.BreadcrumbItem;

namespace Accredia.SIGAD.Web.Components;

public partial class Routes : ComponentBase
{
private bool _authInitialized;

    private static bool IsAllowAnonymous(Type pageType)
        => Attribute.IsDefined(pageType, typeof(AllowAnonymousAttribute), inherit: true);

    protected override async Task OnAfterRenderAsync(bool firstRender)
    {
        // AuthProvider uses ProtectedSessionStorage which needs JS. Initialize as soon as the app renders.
        if (firstRender && !_authInitialized)
        {
            _authInitialized = true;
            TokenService.MarkJsAvailable();
            await AuthProvider.InitializeAsync();
        }
    }
}