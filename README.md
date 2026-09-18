# Retro Remake SuperStation One - Master Directory & Sync Guide

Welcome to your SuperStation One root storage directory!

The **SuperStation One** by Retro Remake is an FPGA gaming console running the **MiSTer FPGA** framework. This directory is structured to hold your complete ROM library, BIOS files, custom configurations, and shared synchronization folders for you and your friends.

---

## Directory Overview

| Folder | Purpose | Supported File Types |
| :--- | :--- | :--- |
| `games/PSX/` | Sony PlayStation 1 games | `.chd` (recommended), `.cue` + `.bin`, `.pbp` |
| `games/SNES/` | Super Nintendo / Super Famicom | `.sfc`, `.smc`, `.zip` |
| `games/Genesis/` | Sega Genesis / Mega Drive | `.md`, `.bin`, `.gen`, `.zip` |
| `games/NES/` | Nintendo Entertainment System | `.nes`, `.zip` |
| `games/GBA/` | Game Boy Advance | `.gba`, `.zip` |
| `games/NeoGeo/` | Neo Geo MVS / AES arcade | `.neo`, `.zip` |
| `games/Arcade/` | MiSTer Arcade Cores & ROMs | `.mra`, `.zip` |
| `games/N64/` | Nintendo 64 | `.z64`, `.n64` |
| `games/PCEngine/` | PC Engine / TurboGrafx-16 | `.pce`, `.chd`, `.cue` |
| `games/Saturn/` | Sega Saturn | `.chd`, `.cue` + `.bin` |
| `bootrom/` | System BIOS files | `boot.rom`, `gba_bios.bin`, etc. |
| `config/` | System & core settings | `MiSTer.ini`, controller mappings |
| `saves/` | Memory cards and battery saves | `.mcd` (PS1 memory cards), `.sav` |
| `Scripts/` | MiSTer maintenance scripts | `update_all.sh`, Wi-Fi setup scripts |
| `tools/` | PC-side conversion & sync utilities | `convert_to_chd.bat`, etc. |
| `shared-repo/` | Shared Git repository for friends | `.ini`, controller maps, checklists |

---

## Critical Best Practices

### 1. PS1 Games: Always Use `.chd` Format
- **Do not store multi-track `.bin` / `.cue` files whenever possible.**
- `.chd` (Compressed Hunks of Data) is completely **lossless**, preserves all CD audio tracks, and compresses game files by **40%–60%**.
- A conversion script is provided in `tools/convert_to_chd.bat`.

### 2. PS1 BIOS Placement
- Place your PS1 BIOS file in either:
  - `games/PSX/boot.rom` (Rename your `scph5501.bin` or `scph7001.bin` to `boot.rom`)
  - Or inside `bootrom/`

### 3. Syncing with Friends (Nick)
Because ROM files are copyright-protected and typically tens or hundreds of gigabytes:
- **Configs, Cheats, Controller Profiles & Docs:** Stored in `shared-repo/` which is linked to a private Git repository (e.g. GitHub private repo).
- **ROMs & ISOs:** Synchronized peer-to-peer using **Syncthing** (see guide in `tools/syncthing_setup_guide.md`).
