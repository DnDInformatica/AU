# LOGIN
$login = Invoke-RestMethod `
  -Uri "http://localhost:5005/auth/login" `
  -Method Post `
  -ContentType "application/json" `
  -Body '{"username":"admin","password":"Password!12345"}'

$token = $login.accessToken
if ([string]::IsNullOrWhiteSpace($token)) {
  throw "accessToken non trovato nella risposta login. Risposta: $($login | ConvertTo-Json -Depth 10)"
}

Write-Host "TOKEN OK"

# HEADER
$headers = @{
  Authorization = "Bearer $token"
}

# TEST ENDPOINTS
Write-Host "`nGET /me"
curl.exe -i "http://localhost:5005/me" -H "Authorization: Bearer $token"

Write-Host "`nGET /permissions"
curl.exe -i "http://localhost:5005/permissions" -H "Authorization: Bearer $token"

Write-Host "`nGET /roles"
curl.exe -i "http://localhost:5005/roles" -H "Authorization: Bearer $token"
