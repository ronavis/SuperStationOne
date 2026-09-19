#!/usr/bin/env python3
"""
SuperStation One - PC-Side Box Art Fetcher (Fallback)
======================================================
Downloads box art from the Libretro thumbnail repository for games that
are missing artwork. Useful for filling gaps after the main artwork pull.

Primary workflow:
  1. Scrape on console (done overnight)
  2. Pull to PC:  .\tools\pull_artwork_from_mister.ps1
  3. Push to Nick: .\tools\transfer_all_to_mister.ps1

This script is for filling gaps — games added later or missing from scrape.

Usage:
  python tools\fetch_boxart.py             # All systems
  python tools\fetch_boxart.py SNES        # One system
  python tools\fetch_boxart.py NES SNES    # Multiple systems
  python tools\fetch_boxart.py --force     # Re-download existing

Systems: SNES, NES, Genesis, GameBoy, GBC, GBA, N64, PCEngine, MasterSystem
"""

import os, sys, time, urllib.request, urllib.parse, urllib.error, threading
from concurrent.futures import ThreadPoolExecutor, as_completed
from difflib import get_close_matches

BASE_DIR  = r"O:\SuperStationOne"
MEDIA_DIR = os.path.join(BASE_DIR, "media", "images")

# Libretro thumbnail system names
SYSTEMS = {
    "SNES":        {"folder": "SNES",         "libretro": "Nintendo - Super Nintendo Entertainment System"},
    "NES":         {"folder": "NES",           "libretro": "Nintendo - Nintendo Entertainment System"},
    "Genesis":     {"folder": "Genesis",       "libretro": "Sega - Mega Drive - Genesis"},
    "GameBoy":     {"folder": "GameBoy",       "libretro": "Nintendo - Game Boy"},
    "GBC":         {"folder": "GBC",           "libretro": "Nintendo - Game Boy Color"},
    "GBA":         {"folder": "GBA",           "libretro": "Nintendo - Game Boy Advance"},
    "N64":         {"folder": "N64",           "libretro": "Nintendo - Nintendo 64"},
    "PCEngine":    {"folder": "PCEngine",      "libretro": "NEC - PC Engine - TurboGrafx 16"},
    "MasterSystem":{"folder": "MasterSystem",  "libretro": "Sega - Master System - Mark III"},
}

THUMB_BASE = "https://thumbnails.libretro.com"
LIBRETRO_UNSAFE = ['&','*',':','`','/','<','>','?','\\','|','#','%','+']
MAX_THREADS = 4
DELAY = 0.15

# Cache of available thumbnails per system (lazily populated)
_sys_index_cache = {}
_index_lock = threading.Lock()


def clean_libretro(name):
    """Replace characters that libretro replaces with underscores."""
    for ch in LIBRETRO_UNSAFE:
        name = name.replace(ch, '_')
    return name


def strip_goodtools(name):
    """
    Strip GoodTools suffixes like (U), [!], (J), (E), (W), (V1.1) etc.
    to get a cleaner base name for fuzzy matching.
    """
    import re
    # Remove parenthetical and bracketed codes
    name = re.sub(r'\s*\([^)]*\)', '', name)
    name = re.sub(r'\s*\[[^\]]*\]', '', name)
    return name.strip()


def get_system_index(libretro_sys):
    """
    Fetch the list of available thumbnail filenames for a system.
    Uses GitHub raw API to list files in the Named_Boxarts directory.
    Returns a list of base names (without .png).
    """
    with _index_lock:
        if libretro_sys in _sys_index_cache:
            return _sys_index_cache[libretro_sys]

    # GitHub API to list files
    sys_path = libretro_sys.replace(' ', '%20').replace('-', '-')
    api_url = f"https://api.github.com/repos/libretro-thumbnails/{urllib.parse.quote(libretro_sys, safe='')}/contents/Named_Boxarts?per_page=1000"
    
    names = []
    try:
        req = urllib.request.Request(api_url, headers={
            "User-Agent": "SuperStationOne/1.0",
            "Accept": "application/vnd.github.v3+json"
        })
        with urllib.request.urlopen(req, timeout=20) as r:
            import json
            data = json.loads(r.read())
            if isinstance(data, list):
                names = [os.path.splitext(item["name"])[0] for item in data if item["name"].endswith(".png")]
    except Exception:
        pass  # Index unavailable, will fall back to direct URL attempts

    with _index_lock:
        _sys_index_cache[libretro_sys] = names
    return names


def find_best_thumbnail_name(rom_base, libretro_sys):
    """
    Find the best matching thumbnail name for a ROM base name.
    Strategy:
      1. Try exact rom_base name
      2. Try cleaned name (libretro unsafe chars -> _)
      3. Try fuzzy match against known index (if available)
    Returns the thumbnail base name to use, or None.
    """
    # Strategy 1+2: direct names
    candidates = sorted(set([
        rom_base,
        clean_libretro(rom_base),
        strip_goodtools(rom_base),
        clean_libretro(strip_goodtools(rom_base)),
    ]))
    
    # Strategy 3: fuzzy match via index
    index = get_system_index(libretro_sys)
    if index:
        stripped = strip_goodtools(rom_base).lower()
        matches = get_close_matches(stripped, [n.lower() for n in index], n=1, cutoff=0.75)
        if matches:
            # Get original case
            idx = [n.lower() for n in index].index(matches[0])
            candidates.insert(0, index[idx])
    
    return candidates  # Return all candidates to try


def make_url(libretro_sys, thumb_name):
    sys_enc  = urllib.parse.quote(libretro_sys, safe='')
    name_enc = urllib.parse.quote(thumb_name, safe=" ()[]!,.-_'")
    return f"{THUMB_BASE}/{sys_enc}/Named_Boxarts/{name_enc}.png"


def download_image(url, dest):
    try:
        req = urllib.request.Request(url, headers={"User-Agent": "SuperStationOne/1.0"})
        with urllib.request.urlopen(req, timeout=15) as resp:
            data = resp.read()
        if len(data) < 8 or data[:4] != b'\x89PNG':
            return False
        with open(dest, 'wb') as f:
            f.write(data)
        return True
    except Exception:
        return False


_lock = threading.Lock()
def tprint(*a, **kw):
    with _lock:
        print(*a, **kw)


def process_rom(rom_file, libretro_sys, force):
    rom_base  = os.path.splitext(rom_file)[0]
    dest_path = os.path.join(MEDIA_DIR, f"{rom_base}.png")

    if not force and os.path.exists(dest_path):
        return {"status": "exists", "name": rom_base}

    time.sleep(DELAY)
    
    # Try each candidate name
    for thumb_name in find_best_thumbnail_name(rom_base, libretro_sys):
        url = make_url(libretro_sys, thumb_name)
        if download_image(url, dest_path):
            return {"status": "downloaded", "name": rom_base, "match": thumb_name}

    return {"status": "not_found", "name": rom_base}


def fetch_system(sys_key, force=False):
    cfg       = SYSTEMS[sys_key]
    games_dir = os.path.join(BASE_DIR, "games", cfg["folder"])

    if not os.path.isdir(games_dir):
        print(f"[{sys_key}] Game folder not found: {games_dir} — skipping.")
        return

    exts = {'.zip', '.sfc', '.smc', '.nes', '.gba', '.gb', '.gbc',
            '.z64', '.n64', '.v64', '.md', '.bin', '.gen', '.pce',
            '.sms', '.gg', '.neo', '.chd'}
    rom_files = [f for f in os.listdir(games_dir) if os.path.splitext(f.lower())[1] in exts]

    if not rom_files:
        print(f"[{sys_key}] No ROM files found — skipping.")
        return

    print(f"\n[{sys_key}] Found {len(rom_files)} ROMs — fetching missing box art...")
    results = {"downloaded": 0, "exists": 0, "not_found": 0}
    not_found = []

    with ThreadPoolExecutor(max_workers=MAX_THREADS) as pool:
        futures = {pool.submit(process_rom, rom, cfg["libretro"], force): rom for rom in rom_files}
        done = 0
        for future in as_completed(futures):
            r = future.result()
            results[r["status"]] += 1
            done += 1
            if r["status"] == "downloaded":
                match_info = f" (matched: {r.get('match','?')[:40]})" if r.get("match") != r["name"] else ""
                tprint(f"  OK [{done}/{len(rom_files)}] {r['name'][:55]}{match_info}")
            elif r["status"] == "not_found":
                not_found.append(r["name"])

    print(f"\n[{sys_key}] Downloaded: {results['downloaded']}  |  Existed: {results['exists']}  |  Not found: {results['not_found']}")

    if not_found:
        log = os.path.join(BASE_DIR, "tools", f"missing_boxart_{sys_key}.txt")
        with open(log, 'w', encoding='utf-8') as f:
            f.write(f"# Missing box art for {sys_key} ({len(not_found)} titles)\n\n")
            f.write("\n".join(not_found))
        print(f"[{sys_key}] Missing titles logged: {log}")


def main():
    os.makedirs(MEDIA_DIR, exist_ok=True)
    args  = [a for a in sys.argv[1:] if not a.startswith("--")]
    force = "--force" in sys.argv

    if force:
        print("Force mode ON — re-downloading all images.")

    if not args:
        targets = list(SYSTEMS.keys())
        print(f"SuperStation One - Box Art Fetcher (Fallback)")
        print(f"Downloading missing art for ALL {len(targets)} systems")
        print(f"Output: {MEDIA_DIR}\n")
        print("TIP: Run pull_artwork_from_mister.ps1 first to get all scraped art from console!")
    else:
        targets = []
        for a in args:
            key = next((k for k in SYSTEMS if k.lower() == a.lower()), None)
            if key:
                targets.append(key)
            else:
                print(f"Unknown system '{a}'. Valid: {', '.join(SYSTEMS)}")

    if not targets:
        sys.exit(1)

    t0 = time.time()
    for s in targets:
        fetch_system(s, force=force)

    elapsed = time.time() - t0
    print(f"\n{'='*55}")
    print(f"Box art fetch complete in {elapsed:.0f}s")
    print(f"Images: {MEDIA_DIR}")
    print(f"\nPush to console (fast — skips re-transferring games):")
    print(f"  .\\tools\\transfer_all_to_mister.ps1 -SkipGames")
    print(f"{'='*55}")


if __name__ == "__main__":
    main()
