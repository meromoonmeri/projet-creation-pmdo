#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Correcteur de convergence pour les échecs mapgen détectés au runtime.

Applique aux étages INVALIDES (lus depuis un JSONL moteur réel) la recette
validée sur magma_cavern/wish_cave/sky_tower — corrections au niveau des
paramètres RogueElements uniquement, par profil :

  * tous profils    : grille >= 4x3 (un contrat >=4 salles est
                      mathématiquement intenable sur 3x2) ;
  * large_rooms     : RoomRatio.Min=100, ConnectPercent=100 (garantit
                      >=1 branche ou boucle avec les grandes salles) ;
  * looping         : ConnectPercent=100 (cycle garanti) ;
  * branching       : BranchRatio.Min>=60, ConnectPercent<=10 (préserve
                      les impasses exigées par le contrat) ;
  * mixed/lattice   : RoomRatio.Min>=85, BranchRatio.Min>=50,
                      ConnectPercent=100.

Aucune map statique, aucun seed fixe : uniquement des bornes de génération.
Usage: canonical_dungeon_fix.py <jsonl> [<jsonl>...]
"""
from __future__ import annotations

import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
PROTECTED = {
    "tiny_woods", "thunderwave_cave", "mt_steel", "mt_thunder",
    "silent_chasm", "great_canyon", "lapis_cave", "mt_freeze",
    "mt_blaze", "mt_thunder_peak", "mt_blaze_peak", "mt_freeze_peak",
}


def load_zone(zone: str):
    p = ROOT / "Data" / "Zone" / f"{zone}.json"
    raw = p.read_bytes()
    return p, raw[:3] == b"\xef\xbb\xbf", json.loads(raw.decode("utf-8-sig"))


def save_zone(p: Path, bom: bool, z: dict) -> None:
    # Garde-fou CH1-5 : les ressources verrouillées sont immuables.
    # Toute tentative d'écriture échoue (PermissionError), ne modifie rien.
    sys.path.insert(0, str(ROOT))
    from dev.tools.ch1_5_lockfile import assert_unlocked
    assert_unlocked(p)
    text = json.dumps(z, indent=2, ensure_ascii=False) + "\n"
    p.write_bytes((("\ufeff" if bom else "") + text).encode("utf-8"))


def floors_of(z: dict, seg: int):
    segs = z["Object"]["Segments"]
    if isinstance(segs, dict):
        segs = segs["$values"]
    fl = segs[seg].get("Floors")
    if fl is None:
        return None                      # segment sans Floors (LoadGen etc.)
    if isinstance(fl, dict):
        fl = fl.get("$values")
    return fl if isinstance(fl, list) else None


def fix_floor(floor: dict, profile: str) -> list[str]:
    changed: list[str] = []

    def walk(o):
        if isinstance(o, dict):
            t = o.get("$type", "")
            if "InitGridPlanStep" in t:
                cx, cy = o.get("CellX", 0), o.get("CellY", 0)
                nx, ny = max(cx, 4), max(cy, 3)
                if (nx, ny) != (cx, cy):
                    o["CellX"], o["CellY"] = nx, ny
                    changed.append(f"grid {cx}x{cy}->{nx}x{ny}")
            if "GridPathBranch" in t:
                rr = o.get("RoomRatio")
                br = o.get("BranchRatio")
                def raise_min(rng, floor_val, label):
                    """Élève Min en garantissant TOUJOURS Min <= Max."""
                    if not rng or rng.get("Min", 0) >= floor_val:
                        return
                    changed.append(f"{label} {rng['Min']}->{floor_val}")
                    rng["Min"] = floor_val
                    rng["Max"] = max(rng.get("Max", 0), floor_val)

                if profile == "large_rooms":
                    raise_min(rr, 100, "room")
                    raise_min(br, 65, "branch")
                elif profile == "branching":
                    raise_min(br, 60, "branch")
                else:  # mixed / lattice / autres procéduraux
                    raise_min(rr, 85, "room")
                    raise_min(br, 50, "branch")
            if "ConnectGridBranchStep" in t:
                cp = o.get("ConnectPercent", 100)
                if profile == "branching":
                    if cp > 10:
                        changed.append(f"connect {cp}->10")
                        o["ConnectPercent"] = 10
                elif cp < 100:
                    changed.append(f"connect {cp}->100")
                    o["ConnectPercent"] = 100
            for v in o.values():
                walk(v)
        elif isinstance(o, list):
            for v in o:
                walk(v)

    walk(floor)
    return changed


def main(argv: list[str]) -> int:
    invalid: list[dict] = []
    for path in argv:
        for line in Path(path).read_text(encoding="utf-8",
                                         errors="replace").splitlines():
            try:
                r = json.loads(line)
            except Exception:
                continue
            if r.get("event") == "floor" and not r.get("valid"):
                invalid.append(r)
    if not invalid:
        print("aucun étage invalide dans les JSONL fournis")
        return 0

    # dédupliquer par (zone, segment, floor); garder le profil
    seen: dict[tuple, str] = {}
    for r in invalid:
        seen[(r["zone"], r["segment"], r["floor"])] = r.get("profile",
                                                            "unknown")
    n = 0
    by_zone: dict[str, list] = {}
    for (zone, seg, floor), prof in sorted(seen.items()):
        by_zone.setdefault(zone, []).append((seg, floor, prof))
    for zone, items in by_zone.items():
        if zone in PROTECTED:
            print(f"{zone}: PROTÉGÉ — non modifié "
                  f"({len(items)} étage(s) signalé(s) à revoir manuellement)")
            continue
        p, bom, z = load_zone(zone)
        any_change = False
        for seg, floor, prof in items:
            fl = floors_of(z, seg)
            if fl is None or floor >= len(fl):
                print(f"{zone} seg{seg} f{floor} [{prof}]: segment sans "
                      f"Floors indexables (REVIEW_REQUIRED)")
                continue
            ch = fix_floor(fl[floor], prof)
            if ch:
                any_change = True
                n += 1
                print(f"{zone} seg{seg} f{floor} [{prof}]: {ch}")
            else:
                print(f"{zone} seg{seg} f{floor} [{prof}]: no change "
                      f"(REVIEW_REQUIRED)")
        if any_change:
            save_zone(p, bom, z)
    print(f"=> {n} étage(s) corrigé(s)")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
