#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
fix_future_dungeons_species.py — CORRECTION CHIRURGICALE des espèces
des 6 Zones de l'arc futur (D27-D32) dans le dépôt.

CONTEXTE (audit maître 2026-08-09) :
  Le champ monstre de mappa_s.bin est le MONSTER_ID (pmdsky-debug, 1-based).
  L'ancienne conversion « npn+1 » donnait des espèces décalées pour tous les
  ids après le bloc des 28 formes de Zarbi. Cette correction ne touche QUE
  le champ "Species" des PoolTeamSpawner (MobSpawnStep), en réappariant
  positionnellement chaque entrée de spawn au monstre NDS correspondant.

Aucune autre valeur n'est modifiée (niveaux, poids, structure, musique,
pièges, dark, MH, arènes, BattlePositionEvent…).
"""
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
import json, os, sys

OUT = "/tmp/v4work/Data/Zone"
DOCS = "/home/user/V4/docs/ssb_ir"

with open(os.path.join(DOCS, "_future_dungeons_mappa.json"), encoding="utf-8") as f:
    MAPPA = {int(k): v for k, v in json.load(f).items()}

MID_SPECIES = {
    41: "zubat", 42: "golbat", 67: "machoke", 68: "machamp",
    81: "magnemite", 82: "magneton", 89: "muk", 92: "gastly",
    93: "haunter", 94: "gengar", 95: "onix", 132: "ditto",
    169: "crobat", 189: "jumpluff", 200: "misdreavus", 232: "forretress",
    254: "skarmory", 354: "grumpig", 372: "claydol", 386: "banette",
    388: "dusclops", 404: "shelgon", 407: "metang", 453: "mothim",
    467: "drifloon", 468: "drifblim", 471: "mismagius", 484: "spiritomb",
    486: "gabite", 507: "tangrowth", 514: "gliscor", 518: "probopass",
}

ZONES = {27: "chasm_cave", 28: "dark_hill", 29: "sealed_ruin",
         30: "sealed_ruin_pit", 31: "spiritomb_room", 32: "dusk_forest"}

def patch_zone(did, zid):
    path = os.path.join(OUT, zid + ".json")
    d = json.load(open(path, encoding="utf-8"))
    obj = d.get("Object", d)
    mappa_floors = MAPPA.get(did)
    if mappa_floors is None:
        print(f"[{zid}] PAS de données mappa (dungeon {did})"); return 0, 0
    # zone : segment unique, floors en ordre mappa
    seg = obj["Segments"][0]
    floors = seg["Floors"]
    n_patch = n_check = 0
    for fi, floor in enumerate(floors):
        if fi >= len(mappa_floors):
            break
        mons = [m for m in mappa_floors[fi]["monsters"] if m["md"] in MID_SPECIES]
        for g in floor.get("GenSteps", []):
            val = g.get("Value", {})
            if "MobSpawnStep" not in val.get("$type", ""):
                continue
            spawns = val.get("Spawns", [])
            if len(spawns) != len(mons):
                print(f"[{zid}] F{fi}: ATTENTION {len(spawns)} spawns vs {len(mons)} mappa — on patche quand même par position")
            for j, entry in enumerate(spawns):
                if j >= len(mons):
                    break
                mid = mons[j]["md"]
                species = MID_SPECIES[mid]
                bf = entry["Spawn"]["Spawns"][0]["Spawn"]["Spawn"]["BaseForm"]
                old = bf.get("Species")
                if old != species:
                    bf["Species"] = species
                    n_patch += 1
                n_check += 1
    with open(path, "w", encoding="utf-8") as f:
        json.dump(d, f, ensure_ascii=False, indent=1)
    print(f"[{zid}] floors={len(floors)} spawns_verifies={n_check} species_corrigees={n_patch}")
    return n_patch, n_check

def main():
    total = 0
    for did, zid in ZONES.items():
        p, c = patch_zone(did, zid)
        total += p
    print(f"\nTOTAL espèces corrigées : {total}")

if __name__ == "__main__":
    main()
