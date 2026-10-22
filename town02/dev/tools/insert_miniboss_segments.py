#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
insert_miniboss_segments.py — insère l'arène mini-boss + les 3 étages du
second tiers dans les zones chapitre 6+, et enregistre les nouvelles grounds.

Structure cible (conception_donjons_segmentes.md, à partir du chapitre 6) :
    plage principale -> relais -> 3F -> MINI-BOSS -> 3F -> boss

  gloomy_forest (pas de relais-segment, son camp est le ground midpoint) :
    [0] 18F  [1] 3F  [2]=NEW miniboss  [3]=NEW 3F  [4] boss
    -> les anciens segments >=2 décalent de +2 (verdant 5, annexe 6,
       dazzling 7, metano_raid 8..10)
  cloven_ruins / crystal_sanctuary / forgotten_marsh :
    [0] étages  [1] relay  [2] 3F  [3]=NEW miniboss  [4]=NEW 3F
    [5] boss (ex-3)  [6] annexe (ex-4)

Enregistrement des grounds (obligatoire, cf. verify_ground_registration) :
  - Data/Zone/index.idx  : master_zone.Grounds += 4 noms, À LA FIN pour ne
    décaler AUCUN mapID existant (nouveaux IDs 82..85).
  - Data/Zone/master_zone.json : GroundMaps += mêmes noms, même ordre.

Formats mesurés (round-trips testés octet-identique) :
  zone json     : BOM + indent=1
  index.idx     : BOM + indent=2
  master_zone   : indent=2, pas de BOM

Idempotent : refuse de ré-insérer une arène déjà présente.
"""
from __future__ import annotations
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---

import copy
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent

ZONES = {
    # zone : (index où insérer le duo [miniboss, 3F], index du Layered boss
    # servant de modèle, MapID de l'arène, noms d'étage)
    "gloomy_forest": {
        "insert_at": 2, "boss_seg": 2, "depths_seg": 1,
        "arena": "gloomy_forest_miniboss",
        "floor_en": "Gloomy Hollow", "floor_fr": "Creux Ombragé",
        "comment_add": " | mini-boss : gardes du coeur (Tengalice + Cornèbre), 3F -> miniboss -> 3F -> Zarude.",
    },
    "cloven_ruins": {
        "insert_at": 3, "boss_seg": 3, "depths_seg": 2,
        "arena": "cloven_ruins_miniboss",
        "floor_en": "Ruin Guardpost", "floor_fr": "Poste de Garde",
        "comment_add": " | mini-boss : gardiens antiques (Kaorine + Golemastoc), 3F -> miniboss -> 3F -> Regigigas.",
    },
    "crystal_sanctuary": {
        "insert_at": 3, "boss_seg": 3, "depths_seg": 2,
        "arena": "crystal_sanctuary_miniboss",
        "floor_en": "Crystal Threshold", "floor_fr": "Seuil de Cristal",
        "comment_add": " | mini-boss : heraut et spectre (Strassie + Momartik), 3F -> miniboss -> 3F -> Diancie.",
    },
    "forgotten_marsh": {
        "insert_at": 3, "boss_seg": 3, "depths_seg": 2,
        "arena": "forgotten_marsh_miniboss",
        "floor_en": "Sunken Crossing", "floor_fr": "Gué Englouti",
        "comment_add": " | mini-boss : boue et venin (Avaltout + Coatox), 3F -> miniboss -> 3F -> Laggron.",
    },
}

NEW_GROUNDS = [
    "gloomy_forest_miniboss",
    "cloven_ruins_miniboss",
    "crystal_sanctuary_miniboss",
    "forgotten_marsh_miniboss",
]


def load(path: Path):
    raw = path.read_bytes()
    bom = raw[:3] == b"\xef\xbb\xbf"
    return json.loads(raw.decode("utf-8-sig" if bom else "utf-8")), bom


def save(path: Path, data, bom: bool, indent: int):
    out = json.dumps(data, ensure_ascii=False, indent=indent).encode("utf-8")
    path.write_bytes((b"\xef\xbb\xbf" if bom else b"") + out)


def patch_zone(zone: str, cfg: dict) -> None:
    path = ROOT / f"Data/Zone/{zone}.json"
    data, bom = load(path)
    obj = data["Object"]
    segs = obj["Segments"]

    arena = cfg["arena"]
    for seg in segs:
        txt = json.dumps(seg)
        if f'"MapID": "{arena}"' in txt or f'"MapID":"{arena}"' in txt:
            raise SystemExit(f"REFUS: {arena} déjà inséré dans {zone}")

    # 1. LayeredSegment miniboss : clone du seg boss (mêmes ZoneSteps).
    mini = copy.deepcopy(segs[cfg["boss_seg"]])
    found = False
    for floor in mini.get("Floors", []):
        for gs in floor.get("GenSteps", []):
            v = gs.get("Value", {})
            if v.get("MapID"):
                v["MapID"] = arena
                found = True
    if not found:
        raise SystemExit(f"ECHEC: pas de MapID dans le seg boss de {zone}")
    for zs in mini.get("ZoneSteps", []):
        if "FloorNameDropZoneStep" in zs.get("$type", ""):
            zs["Name"] = {"DefaultText": cfg["floor_en"],
                          "LocalTexts": {"fr": cfg["floor_fr"]}}
    mini["Comment"] = (f"Mini-boss {zone} (insertion "
                       f"tools/insert_miniboss_segments.py).")

    # 2. RangeDictSegment 3F : clone des profondeurs (identique, 0..3).
    depths = copy.deepcopy(segs[cfg["depths_seg"]])
    depths["Comment"] = (f"3F au-dessus du mini-boss {zone} "
                         f"(clone du premier tiers post-relais).")

    at = cfg["insert_at"]
    segs[at:at] = [mini, depths]

    # 3. GroundMaps
    if arena not in obj.get("GroundMaps", []):
        obj.setdefault("GroundMaps", []).append(arena)

    # 4. Comment
    if cfg["comment_add"] not in obj.get("Comment", ""):
        obj["Comment"] = obj.get("Comment", "") + cfg["comment_add"]

    save(path, data, bom, 1)
    print(f"[ZONE] {zone}: miniboss+3F insérés à l'index {at} "
          f"(total {len(segs)} segments)")


def patch_index() -> None:
    path = ROOT / "Data/Zone/index.idx"
    data, bom = load(path)
    grounds = data["Object"]["master_zone"]["Grounds"]
    for g in NEW_GROUNDS:
        if g not in grounds:
            grounds.append(g)
            print(f"[IDX] + {g} (mapID {len(grounds) - 1})")
        else:
            print(f"[IDX] {g} déjà présent (mapID {grounds.index(g)})")
    save(path, data, bom, 2)


def patch_master_zone() -> None:
    path = ROOT / "Data/Zone/master_zone.json"
    data, bom = load(path)
    gm = data["Object"]["GroundMaps"]
    for g in NEW_GROUNDS:
        if g not in gm:
            gm.append(g)
            print(f"[MZ] + {g}")
    save(path, data, bom, 2)


def verify() -> int:
    failures = 0
    for zone, cfg in ZONES.items():
        data, _ = load(ROOT / f"Data/Zone/{zone}.json")
        obj = data["Object"]
        segs = obj["Segments"]
        at = cfg["insert_at"]
        arena = cfg["arena"]
        ok_arena = f'"{arena}"' in json.dumps(segs[at])
        ok_depths = "RangeDictSegment" in json.dumps(segs[at + 1].get("$type", ""))
        if not (ok_arena and ok_depths):
            print(f"[ECHEC] {zone}: seg[{at}] arène={ok_arena} seg[{at+1}] 3F={ok_depths}")
            failures += 1
        gm = obj.get("GroundMaps", [])
        if arena not in gm:
            print(f"[ECHEC] {zone}: {arena} absent de GroundMaps")
            failures += 1
    idx, _ = load(ROOT / "Data/Zone/index.idx")
    grounds = idx["Object"]["master_zone"]["Grounds"]
    mz, _ = load(ROOT / "Data/Zone/master_zone.json")
    gm = mz["Object"]["GroundMaps"]
    for g in NEW_GROUNDS:
        if g not in grounds:
            print(f"[ECHEC] index.idx sans {g}")
            failures += 1
        if g not in gm:
            print(f"[ECHEC] master_zone sans {g}")
            failures += 1
    # les 82 premiers IDs n'ont PAS bougé
    expected = ["relic_forest", "metano_town", "guild_heros_room",
                "guild_bedroom_hallway"]
    if grounds[:4] != expected:
        print("[ECHEC] mapIDs du début décalés !")
        failures += 1
    if len(grounds) != len(gm):
        print(f"[ECHEC] index={len(grounds)} != master_zone={len(gm)}")
        failures += 1

    print(f"[VERIFY] {'OK' if failures == 0 else str(failures) + ' échec(s)'}")
    return failures


def main() -> int:
    for zone, cfg in ZONES.items():
        patch_zone(zone, cfg)
    patch_index()
    patch_master_zone()
    return 1 if verify() else 0


if __name__ == "__main__":
    sys.exit(main())
