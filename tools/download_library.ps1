# SuperStation One - Download Game Libraries & BIOS from Google Drive
param (
    [string]$RemoteHub = "gdrive:SuperStation One Hub"
)

$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { "O:\SuperStationOne\tools" }
$rootDir   = Split-Path -Parent $scriptDir
$rclone    = Join-Path $scriptDir "rclone.exe"

if (-not (Test-Path $rclone)) {
    Write-Host "Error: rclone.exe not found at $rclone" -ForegroundColor Red
    exit 1
}

$mappings = @(
    @{ Remote = "$RemoteHub/SNES";         Local = "$rootDir\games\SNES";         Name = "Super Nintendo (SNES)" },
    @{ Remote = "$RemoteHub/Genesis";      Local = "$rootDir\games\Genesis";      Name = "SEGA Genesis" },
    @{ Remote = "$RemoteHub/NES";          Local = "$rootDir\games\NES";          Name = "Nintendo (NES)" },
    @{ Remote = "$RemoteHub/Arcade";       Local = "$rootDir\games\mame";         Name = "Arcade (MAME)" },
    @{ Remote = "$RemoteHub/PCEngine";     Local = "$rootDir\games\PCEngine";     Name = "TurboGrafx-16 / PC Engine" },
    @{ Remote = "$RemoteHub/MasterSystem"; Local = "$rootDir\games\MasterSystem"; Name = "Sega Master System" },
    @{ Remote = "$RemoteHub/PSX";          Local = "$rootDir\games\PSX";          Name = "Sony PlayStation (PSX)" },
    @{ Remote = "$RemoteHub/BIOS";         Local = "$rootDir\bootrom";            Name = "Master BIOS Collection" }
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " Downloading ROMs & BIOS from Google Drive ($RemoteHub)" -ForegroundColor Cyan
Write-Host " (With Rate-Limit / Bot-Detection Protection)" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

foreach ($m in $mappings) {
    Write-Host "`nSyncing $($m.Name)..." -ForegroundColor Yellow
    Write-Host "  $($m.Remote) -> $($m.Local)" -ForegroundColor Gray
    if (-not (Test-Path $m.Local)) {
        New-Item -ItemType Directory -Path $m.Local -Force | Out-Null
    }
    # Rate limit to 2 transactions per second to satisfy Google Drive API rules
    & $rclone copy $m.Remote $m.Local --transfers=2 --checkers=4 --tpslimit=2 --tpslimit-burst=1 --drive-pacer-min-sleep=100ms --stats=15s
    Start-Sleep -Seconds 2
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "  All game systems & BIOS downloaded successfully!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan
