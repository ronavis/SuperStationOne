# SuperStation One - Pull Box Art from Console
# =============================================
# Pulls ALL scraped box art from the console back to your PC.
# Run this ONCE after you've scraped art on the console.
# After this, transfer_all_to_mister.ps1 will push it automatically
# so Nick and future users never need to scrape anything!
#
# Usage:
#   .\tools\pull_artwork_from_mister.ps1              # Pull all art (default IP)
#   .\tools\pull_artwork_from_mister.ps1 -ConsoleIP 10.0.0.5

param (
    [string]$ConsoleIP = "10.0.0.4"
)

$scriptDir  = if ($PSScriptRoot) { $PSScriptRoot } else { "O:\SuperStationOne\tools" }
$rootDir    = Split-Path -Parent $scriptDir
$rclone     = Join-Path $scriptDir "rclone.exe"
$localMedia = "$rootDir\media\images"
$remoteMedia = ":sftp,host=$ConsoleIP,user=root,pass=6NrD4Z-zcI9ORRdxQ-Ie6qo:/media/fat/media"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  SuperStation One - Pull Box Art from Console" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# Verify connection
Write-Host "`nTesting connection to console at $ConsoleIP..." -ForegroundColor Yellow
$ping = Test-Connection -ComputerName $ConsoleIP -Count 1 -Quiet -ErrorAction SilentlyContinue
if (-not $ping) {
    Write-Host "[!] Could not reach $ConsoleIP. Is the console powered on?" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] Connected!" -ForegroundColor Green

# Create local output directory
New-Item -ItemType Directory -Force -Path $localMedia | Out-Null
Write-Host "`nPulling all box art from console to: $localMedia" -ForegroundColor Cyan
Write-Host "(This pulls ~4,800 images — may take a few minutes on Wi-Fi)" -ForegroundColor Gray

# Count before
$before = (Get-ChildItem $localMedia -Filter "*.png" -ErrorAction SilentlyContinue).Count

& $rclone copy $remoteMedia $localMedia `
    --include "*.png" `
    --transfers=8 `
    --checkers=16 `
    --sftp-set-modtime=false `
    --stats=20s `
    --progress

$after = (Get-ChildItem $localMedia -Filter "*.png" -ErrorAction SilentlyContinue).Count
$new   = $after - $before

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "  Pull complete!" -ForegroundColor Green
Write-Host "  Images before : $before" -ForegroundColor Gray
Write-Host "  Images after  : $after" -ForegroundColor White
Write-Host "  New images    : $new" -ForegroundColor Green
Write-Host "  Location      : $localMedia" -ForegroundColor Gray
Write-Host "`n  Nick / future users: just run transfer_all_to_mister.ps1" -ForegroundColor Yellow
Write-Host "  No scraping needed!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
