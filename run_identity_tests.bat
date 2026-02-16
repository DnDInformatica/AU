@echo off
setlocal

set TEST_PROJECT=Accredia.SIGAD.Identity.Api.Tests\Accredia.SIGAD.Identity.Api.Tests.csproj

if not exist "%TEST_PROJECT%" (
  echo Test project not found: %TEST_PROJECT%
  exit /b 1
)

dotnet test "%TEST_PROJECT%" -c Release

endlocal
