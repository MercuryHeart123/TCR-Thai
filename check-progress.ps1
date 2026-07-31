# Reports how much of the Thai translation is done.
# A key counts as "translated" once its value differs from the English source.
# Also validates the JSON still parses -- catches a stray comma before you
# find out from a silently missing language in-game.

$ErrorActionPreference = 'Stop'
$root = $PSScriptRoot
$pack = Join-Path $root 'TCR-Thai'
$ref  = Join-Path $root '_source_en'

$langPairs = @(
    @{ name = 'tcrcore (main mod)'   ; en = 'tcrcore.en_us.json'                ; th = 'assets\tcrcore\lang\th_th.json' }
    @{ name = 'FTB Quests'           ; en = 'ftb_translations.en_us.json'       ; th = 'assets\ftb_translations\lang\th_th.json' }
    # เทียบกับ zh_cn เพราะไฟล์อังกฤษแปลไว้แค่ 30 จาก 411 key (ต้นฉบับจริงคือจีน)
    @{ name = 'Structure names'      ; en = 'structure_translations.zh_cn.json' ; th = 'assets\structure_translations\lang\th_th.json' }
)

$textPairs = @(
    @{ name = 'End screen credits'   ; en = 'credits_en_us.json'     ; th = 'assets\tcrcore\texts\credits_th_th.json' }
    @{ name = 'End screen text'      ; en = 'end_en_us.txt'          ; th = 'assets\tcrcore\texts\end_th_th.txt' }
    @{ name = 'Post-credits'         ; en = 'postcredits_en_us.txt'  ; th = 'assets\tcrcore\texts\postcredits_th_th.txt' }
)

function Read-Json($path) {
    try {
        $raw = Get-Content -LiteralPath $path -Raw -Encoding UTF8
        return @{ ok = $true; data = ($raw | ConvertFrom-Json) }
    } catch {
        return @{ ok = $false; err = $_.Exception.Message }
    }
}

function To-Map($obj) {
    $m = @{}
    $obj.PSObject.Properties | ForEach-Object { $m[$_.Name] = [string]$_.Value }
    return $m
}

Write-Host ''
Write-Host ('=' * 74)
Write-Host '  THE CASKET OF REVERIES - THAI TRANSLATION PROGRESS'
Write-Host ('=' * 74)
Write-Host ''

$grandTotal = 0
$grandDone  = 0
$broken     = @()

foreach ($p in $langPairs) {
    $enPath = Join-Path $ref  $p.en
    $thPath = Join-Path $pack $p.th

    $enR = Read-Json $enPath
    $thR = Read-Json $thPath

    if (-not $thR.ok) {
        Write-Host ("  {0,-22} JSON IS BROKEN" -f $p.name) -ForegroundColor Red
        Write-Host ("  {0,-22}   {1}" -f '', $thR.err) -ForegroundColor Red
        $broken += $p.name
        continue
    }

    $en = To-Map $enR.data
    $th = To-Map $thR.data

    $total   = $en.Count
    $done    = 0
    $missing = 0
    foreach ($k in $en.Keys) {
        if (-not $th.ContainsKey($k)) { $missing++; continue }
        if ($th[$k] -ne $en[$k]) { $done++ }
    }
    $extra = ($th.Keys | Where-Object { -not $en.ContainsKey($_) }).Count

    $grandTotal += $total
    $grandDone  += $done
    $pct = if ($total) { [math]::Round($done * 100.0 / $total, 1) } else { 0 }

    $bar = ('#' * [int]($pct / 4)).PadRight(25, '.')
    $col = if ($pct -ge 99) { 'Green' } elseif ($pct -gt 0) { 'Yellow' } else { 'DarkGray' }
    Write-Host ("  {0,-22} [{1}] {2,5}%  {3}/{4}" -f $p.name, $bar, $pct, $done, $total) -ForegroundColor $col
    if ($missing) { Write-Host ("  {0,-22}   !! {1} key(s) deleted from th_th - add them back" -f '', $missing) -ForegroundColor Red }
    if ($extra)   { Write-Host ("  {0,-22}   ?  {1} key(s) not in English source" -f '', $extra) -ForegroundColor DarkYellow }
}

Write-Host ''
foreach ($p in $textPairs) {
    $enPath = Join-Path $ref  $p.en
    $thPath = Join-Path $pack $p.th
    if (-not (Test-Path $thPath)) { Write-Host ("  {0,-22} MISSING FILE" -f $p.name) -ForegroundColor Red; continue }

    $same = (Get-FileHash $enPath -Algorithm MD5).Hash -eq (Get-FileHash $thPath -Algorithm MD5).Hash
    if ($same) { Write-Host ("  {0,-22} still identical to English" -f $p.name) -ForegroundColor DarkGray }
    else       { Write-Host ("  {0,-22} edited" -f $p.name) -ForegroundColor Green }
}

$gp = if ($grandTotal) { [math]::Round($grandDone * 100.0 / $grandTotal, 1) } else { 0 }
Write-Host ''
Write-Host ('-' * 74)
Write-Host ("  TOTAL LANG KEYS : {0}/{1}  ({2}%)" -f $grandDone, $grandTotal, $gp) -ForegroundColor Cyan
if ($broken) { Write-Host ("  BROKEN JSON     : {0}" -f ($broken -join ', ')) -ForegroundColor Red }
Write-Host ('-' * 74)
Write-Host ''
