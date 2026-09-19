# SuperStation One - Complete Console Sync Utility
# Transfers games, BIOS, 8BitDo controller maps, box art, and favorites to console
param (
    [string]$ConsoleIP = "10.0.0.4",
    [switch]$SkipGames
)

$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { "O:\SuperStationOne\tools" }
$rootDir   = Split-Path -Parent $scriptDir
$rclone    = Join-Path $scriptDir "rclone.exe"
$remoteBase = ":sftp,host=$ConsoleIP,user=root,pass=6NrD4Z-zcI9ORRdxQ-Ie6qo:/media/fat"

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "  SuperStation One - Console Sync Tool ($ConsoleIP)" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

# Verify connection
Write-Host "`nTesting connection to console at $ConsoleIP..." -ForegroundColor Yellow
$ping = Test-Connection -ComputerName $ConsoleIP -Count 1 -Quiet -ErrorAction SilentlyContinue
if (-not $ping) {
    Write-Host "[!] Could not reach $ConsoleIP. Please verify your console is powered on." -ForegroundColor Red
    Write-Host "    If your console has a different IP address, run:" -ForegroundColor Gray
    Write-Host "    .\tools\transfer_all_to_mister.ps1 -ConsoleIP <New_IP>" -ForegroundColor White
    exit 1
}
Write-Host "[OK] Connected to SuperStation One!" -ForegroundColor Green

# 1. System Configs, Controllers, Favorites, and Media
Write-Host "`n[1/3] Syncing Controller Maps, Favorites, Box Art, and Media..." -ForegroundColor Cyan

$systemMappings = @(
    @{ Local = "$rootDir\config\inputs"; Remote = "$remoteBase/config/inputs"; Name = "8BitDo Controller Profiles" },
    @{ Local = "$rootDir\Favorites";     Remote = "$remoteBase/Favorites";     Name = "1-Click Favorites" },
    @{ Local = "$rootDir\media";         Remote = "$remoteBase/media";         Name = "High-Res Box Art & Flyers (Favorites)" },
    @{ Local = "$rootDir\media\images\images"; Remote = "$remoteBase/media/images"; Name = "Full Library Box Art (Console Mode)" },
    @{ Local = "$rootDir\ConsoleMode";   Remote = "$remoteBase/ConsoleMode";   Name = "ConsoleMode Launcher Config" },
    @{ Local = "$rootDir\Scripts";       Remote = "$remoteBase/Scripts";       Name = "Helper Scripts" }
)

foreach ($s in $systemMappings) {
    if (Test-Path $s.Local) {
        Write-Host "  -> Syncing $($s.Name)..." -ForegroundColor Yellow
        & $rclone copy $s.Local $s.Remote --transfers=4 --checkers=8 --sftp-set-modtime=false
    }
}

if (Test-Path "$rootDir\config\MiSTer.ini") {
    Write-Host "  -> Syncing Master MiSTer.ini..." -ForegroundColor Yellow
    & $rclone copyto "$rootDir\config\MiSTer.ini" "$remoteBase/MiSTer.ini" --sftp-set-modtime=false
}

# 2. BIOS & Boot ROMs
Write-Host "`n[2/3] Syncing Master BIOS & Boot ROMs..." -ForegroundColor Cyan
if (Test-Path "$rootDir\bootrom") {
    Write-Host "  -> Syncing /media/fat/bootrom..." -ForegroundColor Yellow
    & $rclone copy "$rootDir\bootrom" "$remoteBase/bootrom" --transfers=4 --checkers=8 --sftp-set-modtime=false
    
    # PSX BIOS
    Write-Host "  -> Syncing PSX BIOS to /media/fat/games/PSX..." -ForegroundColor Yellow
    & $rclone copy "$rootDir\bootrom" "$remoteBase/games/PSX" --include "boot*.rom" --include "scph*.bin" --include "sbi.zip" --transfers=4 --checkers=8 --sftp-set-modtime=false
    
    # GBA BIOS
    if (Test-Path "$rootDir\bootrom\GBA") {
        Write-Host "  -> Syncing GBA BIOS to /media/fat/games/GBA..." -ForegroundColor Yellow
        & $rclone copy "$rootDir\bootrom\GBA" "$remoteBase/games/GBA" --include "boot.rom" --include "gba_bios.bin" --transfers=4 --checkers=8 --sftp-set-modtime=false
    }
    
    # N64 Boot ROMs
    if (Test-Path "$rootDir\bootrom\N64") {
        Write-Host "  -> Syncing N64 Boot ROMs to /media/fat/games/N64..." -ForegroundColor Yellow
        & $rclone copy "$rootDir\bootrom\N64" "$remoteBase/games/N64" --include "boot*.rom" --transfers=4 --checkers=8 --sftp-set-modtime=false
    }
}

# 3. Game Libraries
if (-not $SkipGames) {
    Write-Host "`n[3/3] Syncing Game Libraries..." -ForegroundColor Cyan
    $gameMappings = @(
        # Home Consoles
        @{ Local = "$rootDir\games\SNES";         Remote = "$remoteBase/games/SNES";      Name = "Super Nintendo (SNES)" },
        @{ Local = "$rootDir\games\Genesis";      Remote = "$remoteBase/games/MegaDrive"; Name = "SEGA Genesis" },
        @{ Local = "$rootDir\games\NES";          Remote = "$remoteBase/games/NES";        Name = "Nintendo (NES)" },
        @{ Local = "$rootDir\games\mame";         Remote = "$remoteBase/games/mame";       Name = "Arcade (MAME)" },
        @{ Local = "$rootDir\games\PCEngine";     Remote = "$remoteBase/games/TGFX16";     Name = "TurboGrafx-16 / PC Engine" },
        @{ Local = "$rootDir\games\MasterSystem"; Remote = "$remoteBase/games/SMS";        Name = "Sega Master System" },
        @{ Local = "$rootDir\games\PSX";          Remote = "$remoteBase/games/PSX";        Name = "Sony PlayStation (PSX)" },
        @{ Local = "$rootDir\games\N64";          Remote = "$remoteBase/games/N64";        Name = "Nintendo 64 (N64)" },
        
        # Handhelds
        @{ Local = "$rootDir\games\GameBoy";      Remote = "$remoteBase/games/GAMEBOY";    Name = "Game Boy (GB)" },
        @{ Local = "$rootDir\games\GBC";          Remote = "$remoteBase/games/GBC";        Name = "Game Boy Color (GBC)" },
        @{ Local = "$rootDir\games\GBA";          Remote = "$remoteBase/games/GBA";        Name = "Game Boy Advance (GBA)" }
    )

    foreach ($g in $gameMappings) {
        if (Test-Path $g.Local) {
            Write-Host "  -> Syncing $($g.Name)..." -ForegroundColor Green
            & $rclone copy $g.Local $g.Remote --transfers=8 --checkers=16 --sftp-set-modtime=false --stats=15s
        }
    }
} else {
    Write-Host "`n[3/3] Skipping game libraries (-SkipGames specified)." -ForegroundColor Gray
}

Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host "  All systems successfully synced to SuperStation One!" -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Cyan


