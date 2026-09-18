# 🎮 SuperStation One

**Curated retro gaming setup for the Retro Remake SuperStation One (MiSTer FPGA).**

---

## ⚡ Quick Start (For You & Nick)

1. **Get the ROMs:**
   * Download the curated game libraries from your shared Google Drive folder (**`SuperStation One Hub`**), or run `tools/download_library.ps1`.
2. **Transfer to SuperStation One:**
   * Run `tools/transfer_all_to_mister.ps1` to copy games, favorites, and box art directly to your console over your home network.
3. **Turn On & Play:**
   * Power on your SuperStation One.
   * Open **Favorites** or **Console Mode** — all top games are ready to boot with high-res artwork!

---

## 📂 What's In This Repo

* 🕹️ **`Favorites/`** — 380 instant-launch shortcuts (`.mgl` & `.mra`) covering Arcade, SNES, Genesis, NES, and TurboGrafx-16.
* 🎨 **`media/`** — High-resolution box art covers and arcade flyers, neatly organized by platform (`Arcade/`, `Genesis/`, `NES/`, `SNES/`, `TGFX16/`).
* 📺 **`ConsoleMode/`** — Pre-configured `gamelist.ini` for the TV-friendly console launcher.
* ⚙️ **`config/`** — Optimized `MiSTer.ini` display and controller settings.
* 🛠️ **`tools/`** — Simple 1-click PowerShell & batch utilities:
  * `download_library.ps1` — Pulls ROMs from Google Drive.
  * `transfer_all_to_mister.ps1` — Syncs everything to your console.
  * `backup_to_cloud.ps1` — Backs up your saves and settings to Google Drive.
  * `sync_with_gdrive.bat` — Quick two-way Google Drive sync.
* 📝 **`games_wishlist.md`** — Co-op and multiplayer game tracker.

---

## ☁️ Cloud & Privacy

* **Copyright-Free Repository:** This GitHub repo only tracks configurations, scripts, shortcuts, and box art. 
* **ROM Storage:** All game ROMs and archives live in your private Google Drive shared folder (**`SuperStation One Hub`**).
* **Save Backups:** Run `tools/backup_to_cloud.ps1` anytime to safely protect your in-game saves.
