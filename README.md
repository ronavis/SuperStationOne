# 🎮 SuperStation One

**Curated plug-and-play retro gaming environment for the Retro Remake SuperStation One (MiSTer FPGA).**

---

## ⚡ Quick Start (For You & Nick)

1. **Get the Games & BIOS:**
   * Download the clean game libraries and BIOS pack from your shared Google Drive folder (**`SuperStation One Hub`**), or run `tools/download_library.ps1`.
2. **Transfer to Your Console:**
   * Run `tools/transfer_all_to_mister.ps1` to send games, favorites, box art, and configurations directly to your SuperStation One over your local network.
3. **Turn On & Play:**
   * Power on your SuperStation One.
   * Open **Favorites** or **Console Mode** — your top curated games are ready to boot with high-resolution artwork!

---

## 🎮 8BitDo Controllers: Plug & Play
This repository includes pre-built controller mapping profiles for popular 8BitDo gamepads (NES30 Pro, SN30, SN30 Pro, Pro 2, M30, etc.) in `config/inputs/`:
* **Startup Mode:** Power on your 8BitDo controller by holding **`Start + B`** (D-Input / Android mode) for 2 seconds.
* **Auto-Mapped:** The console automatically recognizes the controller and applies the profile. It works immediately across **SNES, NES, Game Boy, Genesis, and Arcade** without needing to map buttons!
* **In-Game Menu Combo:** Press **`Down + Select`** (or `L1 + R1 + Down`) while in any game to bring up the MiSTer menu to save states or return to favorites.

---

## 📂 Repository Contents

* 🕹️ **`Favorites/`** — 380 instant-launch shortcuts (`.mgl` & `.mra`) covering Arcade, SNES, Genesis, NES, and TurboGrafx-16.
* 🎨 **`media/`** — High-resolution box art and arcade flyers, organized by platform:
  * `media/Arcade/` (147 flyers & marquees)
  * `media/NES/` (100 box arts)
  * `media/SNES/` (55 box arts)
  * `media/Genesis/` (52 box arts)
  * `media/TGFX16/` (23 box arts)
* 📺 **`ConsoleMode/`** — Pre-configured `gamelist.ini` for the TV-friendly front-end launcher.
* ⚙️ **`config/`** — Optimized `MiSTer.ini` settings and `inputs/` folder with universal 8BitDo controller maps.
* 💾 **`bootrom/`** — Master PS1 BIOS files (`boot.rom`, `scph5501.bin`, `sbi.zip`, etc.).
* 🛠️ **`tools/`** — 1-click utility scripts:
  * `download_library.ps1` — Pulls clean ROMs from Google Drive.
  * `transfer_all_to_mister.ps1` — Syncs games, art, and configs to your console over Wi-Fi.
  * `pull_bios_from_mister.ps1` — Copies BIOS and save files from your console to your PC and Google Drive.
  * `backup_to_cloud.ps1` — Backs up your in-game saves and settings to Google Drive and local storage.
  * `sync_with_gdrive.bat` — Quick interactive Google Drive sync.
* 📝 **`games_wishlist.md`** — Co-op and multiplayer game tracker.

---

## ☁️ Shared Google Drive Hub (`SuperStation One Hub`)

To keep this GitHub repository lightweight and copyright-free, all game ROMs and disc archives are hosted in the private Google Drive shared folder:

| System | Library Details |
| :--- | :--- |
| 👾 **Arcade (MAME)** | Complete Top 147 Arcade collection (148 archives, ~827 MB) |
| 🔴 **Nintendo (NES)** | 2,124 clean, deduplicated 1G1R titles (~225 MB) |
| 🟣 **Super Nintendo (SNES)** | 955 clean, deduplicated 1G1R titles (~867 MB) |
| 🔵 **Sega Genesis** | 880 clean, deduplicated 1G1R titles (~609 MB) |
| 🟡 **Sega Master System** | 431 clean, deduplicated 1G1R titles (~51 MB) |
| 🟠 **TurboGrafx-16 / PC Engine** | 349 clean, deduplicated 1G1R titles (~88 MB) |
| 💿 **Sony PlayStation (PSX)** | Curated PSX games + Complete 24-file Sony BIOS archive |
