# SuperStation One - Pull BIOS and PSX files from Console to Drive O: and Google Drive
param (
    [string]$MisterIP = "10.0.0.4"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  SuperStation One - BIOS & PSX Sync Tool" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$rclone = "O:\SuperStationOne\tools\rclone.exe"
$localRoot = "O:\SuperStationOne"

Write-Host "`nTesting connection to SuperStation One ($MisterIP)..." -ForegroundColor Yellow
$ping = Test-Connection -ComputerName $MisterIP -Count 1 -Quiet -ErrorAction SilentlyContinue

if (-not $ping) {
    Write-Host "[!] SuperStation One at $MisterIP is not reachable over the network." -ForegroundColor Red
    Write-Host "    Make sure the console is powered on and connected to Wi-Fi/Ethernet." -ForegroundColor Gray
    Write-Host "    If your console has a different IP address, run:" -ForegroundColor Gray
    Write-Host "    .\tools\pull_bios_from_mister.ps1 -MisterIP <New_IP>" -ForegroundColor White
    exit 1
}

Write-Host "[OK] Connected to SuperStation One at $MisterIP!" -ForegroundColor Green

# 1. Check and copy /media/fat/bootrom
Write-Host "`n[1/3] Checking /media/fat/bootrom on console..." -ForegroundColor Yellow
& $rclone copy ":sftp,host=$MisterIP,user=root,pass=6NrD4Z-zcI9ORRdxQ-Ie6qo:/media/fat/bootrom" "$localRoot\bootrom" --verbose

# 2. Check and copy /media/fat/games/PSX/boot.rom if present
Write-Host "`n[2/3] Checking /media/fat/games/PSX on console..." -ForegroundColor Yellow
& $rclone copy ":sftp,host=$MisterIP,user=root,pass=6NrD4Z-zcI9ORRdxQ-Ie6qo:/media/fat/games/PSX" "$localRoot\games\PSX" --include "boot.rom" --include "*.bin" --include "*.chd" --verbose

# 3. Upload any found BIOS files to Google Drive (SuperStation One Hub)
Write-Host "`n[3/3] Syncing acquired BIOS files to Google Drive (SuperStation One Hub/BIOS)..." -ForegroundColor Yellow
& $rclone copy "$localRoot\bootrom" "gdrive:SuperStation One Hub/BIOS" --verbose
& $rclone copy "$localRoot\games\PSX" "gdrive:SuperStation One Hub/PSX" --include "boot.rom" --verbose

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "  BIOS Sync Complete!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
