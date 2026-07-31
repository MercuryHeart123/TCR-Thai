# Zips the pack for distribution and prints the exact server.properties lines.
#
# You do NOT hand this file to your friends. Upload the .zip somewhere with a
# DIRECT download link, paste the two lines below into server.properties, and
# every player downloads it automatically when they join.

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$pack = Join-Path $root 'TCR-Thai'
$zip  = Join-Path $root 'TCR-Thai.zip'

# --- sanity: every JSON must still parse, or players silently get English ---
$bad = @()
Get-ChildItem $pack -Recurse -Filter *.json | ForEach-Object {
    try { $null = Get-Content $_.FullName -Raw -Encoding UTF8 | ConvertFrom-Json }
    catch { $bad += "$($_.Name): $($_.Exception.Message)" }
}
if ($bad) {
    Write-Host ''
    Write-Host 'ABORTED - invalid JSON:' -ForegroundColor Red
    $bad | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
    return
}

# --- zip the CONTENTS, so pack.mcmeta sits at the zip root (required) ------
if (Test-Path $zip) { Remove-Item $zip -Force }
Compress-Archive -Path (Join-Path $pack '*') -DestinationPath $zip -CompressionLevel Optimal

$sha1 = (Get-FileHash $zip -Algorithm SHA1).Hash.ToLower()
$size = (Get-Item $zip).Length

Write-Host ''
Write-Host ('=' * 74)
Write-Host '  PACK READY' -ForegroundColor Green
Write-Host ('=' * 74)
Write-Host ("  file : {0}" -f $zip)
Write-Host ("  size : {0:N0} bytes ({1:N1} KB)" -f $size, ($size/1KB))
Write-Host ("  sha1 : {0}" -f $sha1)
Write-Host ''
Write-Host '  1. Upload TCR-Thai.zip somewhere with a DIRECT download link.'
Write-Host '     GitHub Releases works well and is free.'
Write-Host '     (Google Drive share links do NOT work - not a direct link.)'
Write-Host ''
Write-Host '  2. Put these lines in server.properties:'
Write-Host ''
Write-Host '     resource-pack=<PASTE-THE-DIRECT-URL-HERE>' -ForegroundColor White
Write-Host ("     resource-pack-sha1={0}" -f $sha1)              -ForegroundColor White
Write-Host '     require-resource-pack=false'                    -ForegroundColor White
Write-Host ''
Write-Host '  3. Restart the server. Players get it automatically on join.'
Write-Host ''
Write-Host '  NOTE: re-run this script after every edit - the sha1 changes, and a'
Write-Host '        stale sha1 makes clients reject the download.'
Write-Host ('=' * 74)
Write-Host ''
