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
#
# Built by hand instead of Compress-Archive: PowerShell 5.1 writes entry names
# with BACKSLASHES, which the ZIP spec forbids. Java reads such a name as one
# long filename rather than a path, so Minecraft never finds the lang files and
# the pack loads as if it were empty -- silently, with no error anywhere.
Add-Type -AssemblyName System.IO.Compression          # ZipArchive, ZipArchiveMode
Add-Type -AssemblyName System.IO.Compression.FileSystem  # ZipFile

if (Test-Path $zip) { Remove-Item $zip -Force }
$fs  = [System.IO.File]::Open($zip, [System.IO.FileMode]::CreateNew)
$arc = New-Object System.IO.Compression.ZipArchive($fs, [System.IO.Compression.ZipArchiveMode]::Create)
try {
    Get-ChildItem $pack -Recurse -File | Sort-Object FullName | ForEach-Object {
        $rel   = $_.FullName.Substring($pack.Length + 1).Replace('\', '/')
        $entry = $arc.CreateEntry($rel, [System.IO.Compression.CompressionLevel]::Optimal)
        $out   = $entry.Open()
        try {
            $bytes = [System.IO.File]::ReadAllBytes($_.FullName)
            $out.Write($bytes, 0, $bytes.Length)
        } finally { $out.Dispose() }
    }
} finally {
    $arc.Dispose()
    $fs.Dispose()
}

# --- verify the archive really came out with forward slashes ---------------
$check = [System.IO.Compression.ZipFile]::OpenRead($zip)
$wrong = @($check.Entries | Where-Object { $_.FullName -like '*\*' })
$names = @($check.Entries.FullName)
$check.Dispose()
if ($wrong.Count -gt 0) {
    Write-Host ''
    Write-Host 'ABORTED - zip contains backslash paths, Minecraft would ignore the pack:' -ForegroundColor Red
    $wrong | ForEach-Object { Write-Host "  $($_.FullName)" -ForegroundColor Red }
    return
}
if ($names -notcontains 'pack.mcmeta') {
    Write-Host ''
    Write-Host 'ABORTED - pack.mcmeta is not at the zip root.' -ForegroundColor Red
    return
}

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
