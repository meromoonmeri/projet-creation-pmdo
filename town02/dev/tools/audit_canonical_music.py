#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Audit musical canonique PMD Red -> zones PMDO.

Chaîne d'autorité (aucune invention) :
  1. pret/pmd-red data/dungeon/<Dungeon>/main_data.inc : chaque ligne est
     une FloorProperties (28 octets) ; l'octet [3] est `bgMusic`
     (include/structs/str_dungeon.h, champ vérifié).
  2. include/constants/bg_music.h : enum MusicID (MUS_* = index).
  3. dev/tools/dungeon_builder/data/base_music.txt + Content/Music du mod :
     titres réellement disponibles côté PMDO.
  4. Data/Zone/<zone>.json : MapDataStep.Music réellement joué par PMDO.

Sortie : rapport par zone/étage {canonical MUS_*, piste PMDO actuelle,
verdict CANON_PASS / CANON_MISMATCH / TRACK_MISSING / NO_ROM_DATA}.
Avec --apply, corrige les MapDataStep.Music des zones NON protégées
lorsque la piste canonique existe dans Content/Music (mod ou base).
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PRET = ROOT / "dev" / "external" / "pret_pmd_red"
OUT = ROOT / "dev" / "docs" / "canonical_dungeon_runtime" / "music_audit.json"

PROTECTED = {
    "tiny_woods", "thunderwave_cave", "mt_steel", "mt_thunder",
    "silent_chasm", "great_canyon", "lapis_cave", "mt_freeze",
    "mt_blaze", "mt_thunder_peak", "mt_blaze_peak", "mt_freeze_peak",
}

# Correspondance dossier pret -> zone(s) New Era. Uniquement des
# correspondances d'identité canonique (pas d'interprétation).
PRET_TO_ZONE = {
    "TinyWoods": ["tiny_woods"],
    "ThunderwaveCave": ["thunderwave_cave"],
    "MtSteel": ["mt_steel"],
    "SinisterWoods": [],                        # géré par relic_forest/b41
    "SilentChasm": ["silent_chasm"],
    "MtThunder": ["mt_thunder"],
    "MtThunderPeak": ["mt_thunder_peak"],
    "GreatCanyon": ["great_canyon"],
    "LapisCave": ["lapis_cave"],
    "MtBlaze": ["mt_blaze"],
    "MtBlazePeak": ["mt_blaze_peak"],
    "FrostyForest": ["frosty_forest"],
    "FrostyGrotto": ["frosty_grotto"],
    "MtFreeze": ["mt_freeze"],
    "MtFreezePeak": ["mt_freeze_peak"],
    "MagmaCavern": ["magma_cavern"],
    "MagmaCavernPit": ["magma_cavern_pit"],
    "SkyTower": ["sky_tower"],
    "SkyTowerSummit": ["sky_tower_summit"],
    "UproarForest": ["uproar_forest"],
    "HowlingForest": ["howling_forest"],
    "StormySea": ["stormy_sea"],
    "SilverTrench": ["silver_trench"],
    "MeteorCave": ["meteor_cave"],
    "FieryField": ["fiery_field"],
    "LightningField": ["lightning_field"],
    "NorthwindField": ["northwind_field"],
    "MtFaraway": ["mt_faraway"],
    "WesternCave": ["western_cave"],
    "NorthernRange": ["northern_range"],
    "PitfallValley": ["pitfall_valley"],
    "BuriedRelic": ["buried_relic"],
    "WishCave": ["wish_cave"],
    "MurkyCave": ["murky_cave"],
    "DesertRegion": ["desert_region"],
    "SouthernCavern": ["southern_cavern"],
    "WyvernHill": ["wyvern_hill"],
    "SolarCave": ["solar_cave"],
    "DarknightRelic": ["darknight_relic"],
    "GrandSea": ["grand_sea"],
    "FaroffSea": ["far_off_sea"],
    "MarvelousSea": ["marvelous_sea"],
    "FantasyStrait": ["fantasy_strait"],
    "UnownRelic": ["unown_relic"],
    "JoyousTower": ["joyous_tower"],
    "PurityForest": ["purity_forest"],
    "RemainsIsland": ["remains_island"],
    "OddityCave": ["oddity_cave"],
    "RockPath": ["rock_path"],
    "SnowPath": ["snow_path"],
    "WaterfallPond": ["waterfall_pond"],
    "WishCaveB100": [],
}


def load_music_enum() -> dict[int, str]:
    text = (PRET / "include" / "constants" / "bg_music.h").read_text()
    enum: dict[int, str] = {}
    idx = None
    for m in re.finditer(r"^\s*(MUS_\w+)(?:\s*=\s*(\d+))?\s*,", text, re.M):
        name, val = m.group(1), m.group(2)
        idx = int(val) if val is not None else (idx + 1 if idx is not None
                                                else 0)
        enum[idx] = name
    return enum


def load_dungeon_music_table() -> list[str]:
    """gDungeonMusic[76] (src/dungeon_config.c) : bgMusic (FloorProperties)
    est un INDEX dans cette table, pas un MusicID direct."""
    text = (PRET / "src" / "dungeon_config.c").read_text()
    m = re.search(r"gDungeonMusic\[76\]\s*=\s*\{(.*?)\};", text, re.S)
    if not m:
        raise RuntimeError("gDungeonMusic introuvable dans dungeon_config.c")
    entries = re.findall(r"MUS_\w+", m.group(1))
    if len(entries) != 76:
        raise RuntimeError(f"gDungeonMusic: {len(entries)} entrées != 76")
    return entries


def mus_to_track(mus: str, available: set[str]) -> str | None:
    """MUS_MT_THUNDER -> 'Mt Thunder' -> meilleure piste disponible."""
    words = mus.removeprefix("MUS_").replace("_", " ").title()
    # normalisations connues du projet (base_music.txt)
    candidates = [
        words,
        words.replace("Mt ", "Mt. "),
        words.replace(" Of ", " of ").replace(" The ", " the "),
        words.replace("Mt ", "Mt. ").replace(" Of ", " of ")
             .replace(" The ", " the "),
        words.replace(" In ", " in ").replace(" To ", " to "),
        words.replace("Mt ", "Mt. ").replace(" In ", " in ")
             .replace(" To ", " to ").replace(" Of ", " of ")
             .replace(" The ", " the ").replace(" With ", " with "),
    ]
    for c in candidates:
        if c in available:
            return c
    lower = {a.lower(): a for a in available}
    return lower.get(words.lower())


def floors_music(dungeon_dir: Path) -> list[int]:
    inc = dungeon_dir / "main_data.inc"
    if not inc.exists():
        return []
    out = []
    for line in inc.read_text().splitlines():
        b = re.findall(r"0x([0-9a-fA-F]{2})", line)
        if len(b) >= 4:
            out.append(int(b[3], 16))
    return out


def zone_music_steps(zone: str) -> list[tuple[int, int, str]]:
    """(segment, floor, Music) de chaque MapDataStep, récursif — couvre
    LayeredSegment/ChanceFloorGen/LoadGen et toute imbrication."""
    zp = ROOT / "Data" / "Zone" / f"{zone}.json"
    if not zp.exists():
        return []
    z = json.loads(zp.read_text(encoding="utf-8-sig"))
    segs = z["Object"]["Segments"]
    if isinstance(segs, dict):
        segs = segs["$values"]
    rows = []

    def collect(o, si, fi):
        if isinstance(o, dict):
            if "MapDataStep" in str(o.get("$type", "")):
                rows.append((si, fi, str(o.get("Music", ""))))
            for v in o.values():
                collect(v, si, fi)
        elif isinstance(o, list):
            for v in o:
                collect(v, si, fi)

    for si, seg in enumerate(segs):
        fl = seg.get("Floors")
        if isinstance(fl, dict):
            fl = fl.get("$values")
        if isinstance(fl, list):
            for fi, f in enumerate(fl):
                collect(f, si, fi)
        else:
            collect(seg, si, -1)
    return rows


def apply_zone_music(zone: str, floor_tracks: list[str]) -> int:
    """Applique la musique canonique PAR ÉTAGE (ordre ROM = ordre des
    floors PMDO, segment par segment). Ne touche que les MapDataStep
    dont Music est vide ou non canonique."""
    zp = ROOT / "Data" / "Zone" / f"{zone}.json"
    raw = zp.read_bytes()
    bom = raw[:3] == b"\xef\xbb\xbf"
    z = json.loads(raw.decode("utf-8-sig"))
    n = 0
    cursor = 0

    def set_music(o, track):
        nonlocal n
        if isinstance(o, dict):
            if "MapDataStep" in str(o.get("$type", "")):
                want = f"{track}.ogg"
                if str(o.get("Music", "")) != want:
                    o["Music"] = want
                    n += 1
            for v in o.values():
                set_music(v, track)
        elif isinstance(o, list):
            for v in o:
                set_music(v, track)

    segs = z["Object"]["Segments"]
    if isinstance(segs, dict):
        segs = segs["$values"]
    for seg in segs:
        fl = seg.get("Floors")
        if isinstance(fl, dict):
            fl = fl.get("$values")
        if not isinstance(fl, list):
            continue
        for f in fl:
            track = floor_tracks[min(cursor, len(floor_tracks) - 1)]
            set_music(f, track)
            cursor += 1
    if n:
        # Garde-fou CH1-5 : ressources verrouillées immuables (échec immédiat).
        import sys as _sys
        _sys.path.insert(0, str(ROOT))
        from dev.tools.ch1_5_lockfile import assert_unlocked
        assert_unlocked(zp)
        text = json.dumps(z, indent=2, ensure_ascii=False) + "\n"
        zp.write_bytes((("\ufeff" if bom else "") + text).encode("utf-8"))
    return n


def main(argv=None) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--apply", action="store_true")
    args = ap.parse_args(argv)

    enum = load_music_enum()
    dungeon_music = load_dungeon_music_table()
    base_tracks = set()
    bm = ROOT / "dev" / "tools" / "dungeon_builder" / "data" / "base_music.txt"
    for line in bm.read_text().splitlines():
        line = line.strip()
        if line and not line.startswith("#"):
            base_tracks.add(line)
    mod_tracks = {p.stem for p in (ROOT / "Content" / "Music").glob("*.ogg")}
    available = base_tracks | mod_tracks

    report = {}
    fixed = 0
    for pret_name, zones in sorted(PRET_TO_ZONE.items()):
        ddir = PRET / "data" / "dungeon" / pret_name
        mus_ids = floors_music(ddir)
        if not mus_ids or not zones:
            continue
        # bgMusic est un index dans gDungeonMusic (vérifié:
        # run_dungeon.c:323 DungeonStartNewBGM(gDungeonMusic[unk3A10])).
        per_floor = [(i + 1,
                      dungeon_music[mid] if mid < len(dungeon_music)
                      else f"MUS_IDX_{mid:02X}")
                     for i, mid in enumerate(mus_ids)]
        uniq = sorted({m for _, m in per_floor})
        for zone in zones:
            steps = zone_music_steps(zone)
            current = sorted({m for _, _, m in steps if m})
            canonical_tracks = {}
            missing = []
            for mus in uniq:
                tr = mus_to_track(mus, available)
                if tr is None:
                    missing.append(mus)
                else:
                    canonical_tracks[mus] = tr
            def norm(s: str) -> str:
                return (s.replace(".ogg", "").replace("Mt. ", "Mt ")
                        .lower().strip())
            want = {norm(t) for t in canonical_tracks.values()}
            cur_n = {norm(c) for c in current}
            verdict = "CANON_PASS" if (cur_n and cur_n <= want) else (
                "TRACK_MISSING" if missing and not canonical_tracks else
                "CANON_MISMATCH")
            rec = {
                "pret": pret_name,
                "floors": len(per_floor),
                "canonical_music": uniq,
                "canonical_tracks": canonical_tracks,
                "tracks_missing": missing,
                "pmdo_current": current,
                "verdict": verdict,
                "protected": zone in PROTECTED,
            }
            if (args.apply and verdict == "CANON_MISMATCH" and
                    zone not in PROTECTED and canonical_tracks):
                # piste par étage: bgMusic ROM -> gDungeonMusic -> track
                floor_tracks = []
                for _fn, mus in per_floor:
                    tr = canonical_tracks.get(mus)
                    if tr is None:
                        tr = mus_to_track(mus, available)
                    floor_tracks.append(tr or
                                        next(iter(canonical_tracks.values())))
                n = apply_zone_music(zone, floor_tracks)
                rec["applied"] = n
                fixed += n
            report[zone] = rec

    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(report, indent=1, ensure_ascii=False),
                   encoding="utf-8")
    ok = sum(1 for r in report.values() if r["verdict"] == "CANON_PASS")
    mis = {z: r for z, r in report.items()
           if r["verdict"] == "CANON_MISMATCH"}
    print(f"zones auditées: {len(report)}; CANON_PASS: {ok}; "
          f"mismatch: {len(mis)}; corrections appliquées: {fixed}")
    for z, r in sorted(mis.items()):
        tag = " [PROTÉGÉ]" if r["protected"] else ""
        print(f"  {z}{tag}: canon={r['canonical_music']} "
              f"pmdo={r['pmdo_current'][:2]} "
              f"-> {list(r['canonical_tracks'].values())}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
