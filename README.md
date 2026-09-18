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
* **Auto-Mapped:** The console automatically recognizes the controller and applies the profile. It works immediately across **SNES, NES, Game Boy, GBC, GBA, N64, Genesis, PSX, and Arcade** without needing to map buttons!
* **In-Game Menu Combo:** Press **`Down + Select`** (or `Home / Guide` or `L1 + R1 + Down`) while in any game to bring up the MiSTer menu to save states or adjust video options.

---

## 📺 4K TV & Video Optimization Guide

Your SuperStation One is configured with an optimized HDMI profile (`MiSTer.ini`) engineered specifically for modern 4K/1080p displays:

* **Integer Scaling (`vscale_mode=1`):** Renders sharp square pixels with zero shimmering or distortion during high-speed horizontal scrolling.
* **Sharp Interpolation Filter:** Eliminates the blurry bilinear smoothing common to default HDMI scalers.
* **Sony Trinitron Aperture Grille (`Sony Trinitron (1968)`):** Hardware-accelerated phosphor simulation and scanlines that deliver the warmth, depth, and contrast of a high-end Sony PVM broadcast monitor.
* **PSX Dithering Fix:**
  * Original PlayStation hardware used 15-bit color with checkerboard dithering. On a 4K TV, this looks like a grainy screen door mesh.
  * In-Game (e.g. *Castlevania: Symphony of the Night*), open the OSD menu and set **`Dithering: Off`** or **`De-dither`** for clean, vibrant 24-bit arcade-grade pixel art!
* **Accessing Live Video Options:** While playing any game, open the OSD menu and press **Left or Right** to access the **Video Processing & Scaler** page to toggle filters, shadow masks, and scanlines in real time.

---

## 📂 Repository Contents

* 🕹️ **`Favorites/`** — 507 instant-launch shortcuts (`.mgl` & `.mra`) organized across 9 platforms:
  * `_01. Super Nintendo (SNES)` (55 favorites)
  * `_02. Sega Genesis` (52 favorites)
  * `_03. Nintendo (NES)` (100 favorites)
  * `_04. TurboGrafx-16` (23 favorites)
  * `_05. Arcade` (150 favorites)
  * `_06. Game Boy` (33 favorites)
  * `_07. Game Boy Color` (30 favorites)
  * `_08. Game Boy Advance` (30 favorites)
  * `_09. Nintendo 64` (34 favorites)
* 🎨 **`media/`** — High-resolution box art and arcade flyers:
  * `media/Arcade/` (147 flyers & marquees)
  * `media/NES/` (100 box arts)
  * `media/SNES/` (55 box arts)
  * `media/Genesis/` (52 box arts)
  * `media/TGFX16/` (23 box arts)
  * `media/GAMEBOY/` (33 box arts)
  * `media/GBC/` (29 box arts)
  * `media/GBA/` (28 box arts)
  * `media/N64/` (23 box arts)
* 📺 **`ConsoleMode/`** — Pre-configured `gamelist.ini` featuring 509 titles for the TV-friendly front-end launcher.

---

## 🖼️ Console Mode Interface & Visual Layout Guide

Retro Remake's **Console Mode** is the official graphical frontend built specifically for the SuperStation One (derived from SimpleMenu). It provides a clean, two-pane console experience:

* **Top-Level Home Menu:** When Console Mode boots, you will see the root navigation:
  * `Load Game` — Opens the console carousel to browse games by system.
  * `Favorites` — 1-click access to curated favorites across all platforms.
  * `Homebrew` — Pre-loaded homebrew library.
  * `History` — The last 20 games/cores launched.
  * `Settings` — Frontend configuration and options.
* **Game & Favorites Screen Layout (What it looks like):**
  * **Left Side:** A vertical list of clean game titles.
  * **Right Side:** High-resolution box art cover/flyer for whichever game is currently highlighted.
  * **Top Bar:** Wordmark logo of the active system (e.g. *Super Nintendo Entertainment System*, *Sega Genesis*, *PlayStation*).
  * **Bottom Bar:** Quick controller shortcuts (`A` Launch, `B` Back, `Select` Game Options, `+` Favorite).
* **Official Visual Screenshots & Guides:**
  * 📸 [Home Menu Screenshot](https://raw.githubusercontent.com/Takiiiiiiii/SuperStation-Documentation/refs/heads/main/CONSOLE_MODE/001.png)
  * 📸 [Console Selection Screenshot](https://raw.githubusercontent.com/Takiiiiiiii/SuperStation-Documentation/refs/heads/main/CONSOLE_MODE/002.png)
  * 📸 [Game Browser with Box Art (SNES) Screenshot](https://raw.githubusercontent.com/Takiiiiiiii/SuperStation-Documentation/refs/heads/main/CONSOLE_MODE/003.png)
  * 📸 [Favorites Menu Screenshot](https://raw.githubusercontent.com/Takiiiiiiii/SuperStation-Documentation/refs/heads/main/CONSOLE_MODE/016.png)
  * 📸 [Settings Menu Screenshot](https://raw.githubusercontent.com/Takiiiiiiii/SuperStation-Documentation/refs/heads/main/CONSOLE_MODE/020.png)
  * 📺 [Official Video Walkthrough](https://www.youtube.com/watch?v=1sfifOftuFE)
* ⚙️ **`config/`** — Master `MiSTer.ini` with custom 4K TV video profiles and universal 8BitDo controller maps.
* 💾 **`bootrom/`** — Official authentic BIOS and boot ROM collection:
  * PSX: Full 24-file Sony BIOS archive (`boot.rom`, `scph5501.bin`, `sbi.zip`, etc.)
  * GBA: Official 16,384-byte boot ROM (`boot.rom`, `gba_bios.bin`)
  * N64: Hardware IPL boot ROMs (`boot.rom`, `boot1.rom`, `N64-database.txt`)
* 🛠️ **`tools/`** — Turnkey utility scripts:
  * `download_library.ps1` — Downloads all clean 1G1R game sets and BIOS from Google Drive with rate-limit protection.
  * `transfer_all_to_mister.ps1` — 1-click complete sync of games, BIOS, shortcuts, media, and configs to the console over Wi-Fi/Ethernet.
  * `pull_bios_from_mister.ps1` — Pulls BIOS and save files from your console to your PC and Google Drive.
  * `backup_to_cloud.ps1` — Backs up in-game saves and savestates to cloud and local storage.
  * `sync_with_gdrive.bat` — Interactive Google Drive sync utility.

---

## ☁️ Shared Google Drive Hub (`SuperStation One Hub`)

To keep this Git repository lightweight and copyright-free, all complete 1G1R game libraries and firmware archives are hosted in the private Google Drive shared folder:

| System | Library Details | 1-Click Favorites |
| :--- | :--- | :---: |
| 👾 **Arcade (MAME)** | Complete Top 147 Arcade collection (148 archives, ~827 MB) | 150 `.mra` |
| 🔴 **Nintendo (NES)** | 2,124 clean, deduplicated 1G1R titles (~225 MB) | 100 `.mgl` |
| 🟣 **Super Nintendo (SNES)** | 955 clean, deduplicated 1G1R titles (~867 MB) | 55 `.mgl` |
| 🔵 **Sega Genesis** | 880 clean, deduplicated 1G1R titles (~609 MB) | 52 `.mgl` |
| 🟡 **Sega Master System** | 431 clean, deduplicated 1G1R titles (~51 MB) | Built-in |
| 🟠 **TurboGrafx-16 / PC Engine** | 349 clean, deduplicated 1G1R titles (~88 MB) | 23 `.mgl` |
| 🟢 **Game Boy (GB)** | 852 clean, deduplicated 1G1R titles (~81.5 MB) | 33 `.mgl` |
| 🟢 **Game Boy Color (GBC)** | 1,038 clean, deduplicated 1G1R titles (~308.1 MB) | 30 `.mgl` |
| 🟣 **Game Boy Advance (GBA)** | 1,346 clean, deduplicated 1G1R titles (~4.87 GB) | 30 `.mgl` |
| 🔴 **Nintendo 64 (N64)** | 403 clean, deduplicated 1G1R BigEndian `.z64` titles (~4.14 GB) | 34 `.mgl` |
| 💿 **Sony PlayStation (PSX)** | Curated PSX games + Complete 24-file Sony BIOS archive | 1-Click OSD |
| 💾 **Master BIOS Collection** | Complete BIOS pack for PSX, GBA, and N64 | Plug & Play |
