$ErrorActionPreference = 'SilentlyContinue'
Get-Process -Name 'dotnet','MSBuild','VBCSCompiler','Accredia.SIGAD*' -ErrorAction SilentlyContinue |
    Select-Object Id, ProcessName |
    Format-Table -AutoSize
