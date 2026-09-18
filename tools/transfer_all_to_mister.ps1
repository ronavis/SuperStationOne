# Transfer all game libraries from Drive O: to SuperStation One console
param (
    [string]$ConsoleIP = "10.0.0.74"
)

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  Transfer Games to SuperStation One ($ConsoleIP)" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$rclone = "O:\SuperStationOne\tools\rclone.exe"
$source = "O:\SuperStationOne\games"

# Check ping
Write-Host "Checking connection to $ConsoleIP..." -ForegroundColor Yellow
$ping = Test-Connection -ComputerName $ConsoleIP -Count 1 -Quiet -ErrorAction SilentlyContinue
if (-not $ping) {
    Write-Host "Could not reach $ConsoleIP. Please verify your console is powered on." -ForegroundColor Red
    exit 1
}

$mappings = @(
    @{ Local = "$source\Genesis"; Remote = "mister:/media/fat/games/MegaDrive"; Name = "SEGA Genesis" },
    @{ Local = "$source\NES"; Remote = "mister:/media/fat/games/NES"; Name = "Nintendo (NES)" },
    @{ Local = "$source\PCEngine"; Remote = "mister:/media/fat/games/TGFX16"; Name = "TurboGrafx-16 / PC Engine" },
    @{ Local = "$source\MasterSystem"; Remote = "mister:/media/fat/games/SMS"; Name = "Sega Master System" }
)

foreach ($m in $mappings) {
    if (Test-Path $m.Local) {
        Write-Host "`nTransferring $($m.Name)..." -ForegroundColor Green
        & $rclone copy $m.Local $m.Remote --transfers=8 --checkers=16 --sftp-set-modtime=false --stats=10s
    }
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "  All systems transferred to SuperStation One!" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
