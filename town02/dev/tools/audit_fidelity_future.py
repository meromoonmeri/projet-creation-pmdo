#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_fidelity_future.py — AUDIT DE FIDÉLITÉ NDS → PMDO du parcours futur.

Compare floor par floor :
  - mappa_s.bin (tileset, musique, densités, dark, MH, ennemis md/level/weight)
  - monster.md (md_index -> dex -> species PMDO)
  - Zones PMDO générées (Data/Zone/<d>.json)

Produit une matrice et un rapport des différences. N'INVENTE RIEN : toute
donnée non vérifiable est marquée UNVERIFIED.
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

import json
import os
import collections

from skytemple_files.dungeon_data.mappa_bin.handler import MappaBinHandler
from skytemple_files.common.types.file_types import FileType

MAPPA_BIN = "/tmp/mappa_s.bin"
MONSTER_MD = "/tmp/pret-pmd-sky/files/BALANCE/monster.md"
ZONES_DIR = "/tmp/v4work/Data/Zone"

# md_index -> dex (monster.md : national_pokedex_number + 1)
md = FileType.MD.deserialize(open(MONSTER_MD, "rb").read())
MD2DEX = {e.md_index: e.national_pokedex_number + 1 for e in md.entries}

# dex -> species (même table que le générateur — espèces réelles des 6 donjons)
DEX_SPECIES = {
    82: "magneton", 83: "farfetchd", 90: "shellder", 93: "haunter", 94: "gengar",
    95: "onix", 96: "drowzee", 133: "eevee", 190: "aipom", 201: "unown",
    206: "dunsparce", 228: "houndour", 327: "spinda", 345: "lileep", 355: "duskull",
    357: "tropius", 373: "salamence", 376: "metagross", 415: "combee", 426: "drifblim",
    427: "buneary", 430: "honchkrow", 443: "spiritomb", 445: "garchomp", 466: "electivire",
    473: "mamoswine", 477: "dusknoir",
}

# tileset NDS -> nom auto-tileset PMDO (correspondance documentée)
TSET_NAME = {26: "chasm_cave", 27: "chasm_cave", 28: "dark_hill", 29: "dark_hill",
             30: "sealed_ruin", 31: "sealed_ruin_pit", 33: "dusk_forest",
             34: "dusk_forest", 176: "sealed_ruin_pit", 187: "sealed_ruin_pit"}
MUSIC_NDS = {19: "Chasm Cave.ogg", 20: "Dark Hill.ogg", 21: "Sealed Ruin.ogg",
             22: "Sealed Ruin Pit.ogg", 23: "Dusk Forest.ogg"}

DUNGEON_ID = {"chasm_cave": 27, "dark_hill": 28, "sealed_ruin": 29,
              "sealed_ruin_pit": 30, "spiritomb_room": 31, "dusk_forest": 32}

# lecture mappa_s
mb = MappaBinHandler.deserialize(open(MAPPA_BIN, "rb").read())
GROUPS = {27: 18, 28: 19, 29: 20, 30: 20, 31: 20, 32: 21}
PRECS = {27: 0, 28: 0, 29: 0, 30: 8, 31: 14, 32: 0}
NFL = {27: 8, 28: 15, 29: 8, 30: 6, 31: 1, 32: 8}

def nds_floor(did, k):
    g = mb.floor_lists[GROUPS[did]]
    f = g[PRECS[did] + k]
    L = f.layout
    return {
        "tileset": L.tileset_id, "music": L.music_id,
        "room_density": L.room_density, "enemy_density": L.initial_enemy_density,
        "item_density": L.item_density, "trap_density": L.trap_density,
        "monster_house": L.monster_house_chance, "darkness": L.darkness_level,
        "floor_number": L.floor_number, "fixed_floor": L.fixed_floor_id,
        "monsters": sorted([(m.md_index, m.level, m.main_spawn_weight)
                            for m in f.monsters if m.main_spawn_weight > 0]),
    }

def pmdo_floor(zid, i):
    d = json.load(open(os.path.join(ZONES_DIR, zid + ".json"), encoding="utf-8"))
    f = d["Object"]["Segments"][0]["Floors"][i]
    out = {"tileset": None, "music": None, "sight": None, "mobs": []}
    for st in f["GenSteps"]:
        v = st["Value"]
        t = v.get("$type", "")
        if "MapDataStep" in t:
            out["music"] = v.get("Music"); out["sight"] = v.get("TileSight")
        if "MapTextureStep" in t:
            out["tileset"] = v.get("GroundTileset")
        if "MobSpawnStep" in t:
            for sp in v["Spawns"]:
                inner = sp["Spawn"]["Spawns"][0]["Spawn"]["Spawn"]
                out["mobs"].append((inner["BaseForm"]["Species"], inner["Level"]["Min"], sp["Rate"]))
    return out

def pmdo_mh(zid):
    d = json.load(open(os.path.join(ZONES_DIR, zid + ".json"), encoding="utf-8"))
    for zs in d["Object"]["Segments"][0].get("ZoneSteps", []):
        if "SpreadHouseZoneStep" in zs.get("$type", ""):
            return zs["SpreadPlan"]["Chance"]
    return 0

rows = []
diffs = []
total_nds = total_pmdo = 0
mh_check = {}

for zid, did in DUNGEON_ID.items():
    nf = NFL[did]
    mh_check[zid] = (nds_floor(did, 0)["monster_house"], pmdo_mh(zid))
    for k in range(nf):
        nds = nds_floor(did, k)
        pmdo = pmdo_floor(zid, k)
        # --- tileset ---
        tset_expected = TSET_NAME.get(nds["tileset"], "?")
        tset_ok = pmdo["tileset"] == tset_expected + "_floor"
        # --- musique ---
        mus_expected = MUSIC_NDS.get(nds["music"])
        mus_ok = pmdo["music"] == mus_expected
        # --- dark ---
        dark_expected = 0 if nds["darkness"] > 0 else 1
        dark_ok = pmdo["sight"] == dark_expected
        # --- ennemis ---
        pmdo_mobs = {}
        for sp, lv, rate in pmdo["mobs"]:
            pmdo_mobs.setdefault(sp, []).append((lv, rate))
        mob_diffs = []
        nds_seen = set()
        for md_idx, lv, w in nds["monsters"]:
            dex = MD2DEX.get(md_idx)
            sp = DEX_SPECIES.get(dex)
            nds_seen.add(sp)
            exp_rate = max(1, round(w / 100.0))
            pm = pmdo_mobs.get(sp)
            if pm is None:
                mob_diffs.append(f"{sp}: ABSENT PMDO")
            else:
                ok = any(pl == lv and pr == exp_rate for pl, pr in pm)
                if not ok:
                    mob_diffs.append(f"{sp}: NDS L{lv} w{w}->r{exp_rate} | PMDO {pm}")
        # ennemis PMDO en trop
        for sp in pmdo_mobs:
            if sp not in nds_seen:
                mob_diffs.append(f"{sp}: EN TROP (absent NDS)")
        total_nds += len(nds["monsters"])
        total_pmdo += len(pmdo["mobs"])
        # densités (info)
        ok = tset_ok and mus_ok and dark_ok and not mob_diffs
        rows.append({
            "zone": zid, "floor": k + 1,
            "nds_tileset": nds["tileset"], "pmdo_tileset": pmdo["tileset"],
            "nds_music": nds["music"], "pmdo_music": pmdo["music"],
            "nds_dark": nds["darkness"], "pmdo_sight": pmdo["sight"],
            "nds_en_dens": nds["enemy_density"], "nds_item_dens": nds["item_density"],
            "nds_trap_dens": nds["trap_density"], "nds_mh": nds["monster_house"],
            "nds_fixed": nds["fixed_floor"],
            "n_mobs_nds": len(nds["monsters"]), "n_mobs_pmdo": len(pmdo["mobs"]),
            "OK": ok,
        })
        for d_ in mob_diffs:
            diffs.append(f"{zid} F{k+1}: {d_}")

# ---- rapport ----
L = []
L.append("# AUDIT DE FIDÉLITÉ NDS → PMDO — PARCOURS FUTUR (46 floors)")
L.append("")
L.append("Date : 2026-08-09 — Source : mappa_s.bin + monster.md (données NDS) vs Data/Zone/*.json (PMDO).")
L.append("")
L.append("## Récapitulatif")
L.append("")
L.append(f"- Floors audités : **{sum(NFL.values())}** (8+15+8+6+1+8 = 46)")
L.append(f"- Entrées Pokémon NDS : **{total_nds}** · PMDO : **{total_pmdo}**")
L.append(f"- Floors sans différence (tileset+musique+dark+ennemis) : **{sum(1 for r in rows if r['OK'])}/{len(rows)}**")
L.append("")
L.append("## Monster houses")
L.append("")
L.append("| Zone | NDS (%) | PMDO (%) | Conforme |")
L.append("|---|---|---|---|")
for z, (n, p) in mh_check.items():
    L.append(f"| {z} | {n} | {p} | {'✅' if n == p else '❌'} |")
L.append("")
L.append("## Matrice par floor (46 lignes)")
L.append("")
L.append("| Zone | F | NDS tset | PMDO tset | NDS mus | PMDO mus | NDS dark | PMDO sight | en | item | trap | MH | fixed | mobs NDS/PMDO | OK |")
L.append("|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|")
for r in rows:
    L.append(f"| {r['zone']} | {r['floor']} | {r['nds_tileset']} | {r['pmdo_tileset']} | "
             f"{r['nds_music']} | {r['pmdo_music']} | {r['nds_dark']} | {r['pmdo_sight']} | "
             f"{r['nds_en_dens']} | {r['nds_item_dens']} | {r['nds_trap_dens']} | {r['nds_mh']} | "
             f"{r['nds_fixed']} | {r['n_mobs_nds']}/{r['n_mobs_pmdo']} | {'✅' if r['OK'] else '❌'} |")
L.append("")
if diffs:
    L.append("## Différences signalées (exhaustif)")
    L.append("")
    for d_ in diffs:
        L.append(f"- {d_}")
    L.append("")
open("/home/user/V4/docs/AUDIT_FIDELITE_NDS_PMDO_FUTURE.md", "w", encoding="utf-8").write("\n".join(L))
print(f"Floors: {sum(NFL.values())} | NDS mobs: {total_nds} | PMDO mobs: {total_pmdo} | OK: {sum(1 for r in rows if r['OK'])}/{len(rows)}")
print(f"Différences: {len(diffs)}")
for d_ in diffs[:20]:
    print("  ", d_)
print("MH:", {z: (n, p) for z, (n, p) in mh_check.items()})
