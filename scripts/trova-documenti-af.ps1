$ErrorActionPreference = 'SilentlyContinue'
$radici = @($env:USERPROFILE, 'C:\Accredia')
$trovati = foreach ($r in $radici) {
    Get-ChildItem -Path $r -Recurse -Include 'AF-*.docx','AF-*.md' -File -ErrorAction SilentlyContinue
}
$trovati | Sort-Object LastWriteTime -Descending |
    Select-Object -First 30 @{N='Data';E={$_.LastWriteTime.ToString('dd-MM-yyyy HH:mm')}}, @{N='KB';E={[int]($_.Length/1KB)}}, FullName |
    Format-Table -AutoSize -Wrap
