# SuperStation One - One-Click Cloud & Local Backup Utility
param (
    [string]$DestinationPath = ""
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  SuperStation One - One-Click Backup" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$source = "O:\SuperStationOne"
$rclone = "$source\tools\rclone.exe"
$localBackup = if ($DestinationPath) { $DestinationPath } else { "$source\Backups" }

# 1. Cloud Backup to Google Drive via Rclone
if (Test-Path $rclone) {
    Write-Host "`n[1/2] Backing up to Google Drive (SuperStation One Hub)..." -ForegroundColor Yellow
    
    Write-Host "  -> Syncing Saves..." -ForegroundColor Gray
    & $rclone copy "$source\saves" "gdrive:SuperStation One Hub/Saves" --transfers=2 --tpslimit=2
    
    Write-Host "  -> Syncing Configs..." -ForegroundColor Gray
    & $rclone copy "$source\config" "gdrive:SuperStation One Hub/Config" --transfers=2 --tpslimit=2
    
    Write-Host "  -> Syncing Scripts..." -ForegroundColor Gray
    & $rclone copy "$source\Scripts" "gdrive:SuperStation One Hub/Scripts" --transfers=2 --tpslimit=2
    
    Write-Host "  -> Syncing BIOS files..." -ForegroundColor Gray
    & $rclone copy "$source\bootrom" "gdrive:SuperStation One Hub/BIOS" --transfers=2 --tpslimit=2
    
    Write-Host "  [OK] Cloud backup to Google Drive complete!" -ForegroundColor Green
} else {
    Write-Host "Rclone not found at $rclone - skipping cloud sync." -ForegroundColor Red
}

# 2. Local Backup to O:\SuperStationOne\Backups
Write-Host "`n[2/2] Backing up locally to: $localBackup" -ForegroundColor Yellow
if (-not (Test-Path $localBackup)) {
    New-Item -ItemType Directory -Path $localBackup -Force | Out-Null
}

robocopy "$source\saves" "$localBackup\saves" /E /XO /NP /NFL /NDL | Out-Null
robocopy "$source\config" "$localBackup\config" /E /XO /NP /NFL /NDL | Out-Null
robocopy "$source\Scripts" "$localBackup\Scripts" /E /XO /NP /NFL /NDL | Out-Null
robocopy "$source\bootrom" "$localBackup\bootrom" /E /XO /NP /NFL /NDL | Out-Null

Write-Host "  [OK] Local backup complete!" -ForegroundColor Green

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "  All backups completed successfully!" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
