$rclone = "O:\SuperStationOne\tools\rclone.exe"

$mappings = @(
    @{ Remote = "gdrive:ROMs/Super Nintendo Entertainment System"; Local = "O:\SuperStationOne\games\SNES" },
    @{ Remote = "gdrive:ROMs/SEGA Genesis"; Local = "O:\SuperStationOne\games\Genesis" },
    @{ Remote = "gdrive:ROMs/Nintendo Entertainment System"; Local = "O:\SuperStationOne\games\NES" },
    @{ Remote = "gdrive:ROMs/Arcade"; Local = "O:\SuperStationOne\games\mame" },
    @{ Remote = "gdrive:ROMs/Nintendo 64"; Local = "O:\SuperStationOne\games\N64" },
    @{ Remote = "gdrive:ROMs/Game Boy"; Local = "O:\SuperStationOne\games\GameBoy" },
    @{ Remote = "gdrive:ROMs/SEGA CD"; Local = "O:\SuperStationOne\games\MegaCD" },
    @{ Remote = "gdrive:ROMs/Turbo Grafx 16"; Local = "O:\SuperStationOne\games\PCEngine" },
    @{ Remote = "gdrive:ROMs/Sega - Master System - Mark III"; Local = "O:\SuperStationOne\games\MasterSystem" }
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Downloading ROMs from Google Drive to O:\SuperStationOne" -ForegroundColor Cyan
Write-Host " (With Rate-Limit / Bot-Detection Protection)" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

foreach ($m in $mappings) {
    Write-Host "`nSyncing $($m.Remote) -> $($m.Local)..." -ForegroundColor Yellow
    if (-not (Test-Path $m.Local)) {
        New-Item -ItemType Directory -Path $m.Local -Force | Out-Null
    }
    # Rate limit to 2 transactions per second to satisfy Google Drive API rules
    & $rclone copy $m.Remote $m.Local --transfers=2 --checkers=4 --tpslimit=2 --tpslimit-burst=1 --drive-pacer-min-sleep=100ms --stats=15s
    Start-Sleep -Seconds 3
}

Write-Host "`nAll systems downloaded successfully!" -ForegroundColor Green
