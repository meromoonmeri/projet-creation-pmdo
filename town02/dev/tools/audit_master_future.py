#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_master_future.py — AUDIT MAÎTRE FINAL NDS → PMDO (parcours futur).

Repart des sources NDS réelles :
  - mappa_s.bin (floors des dungeons 27-32)
  - monster.md  (md_index -> dex -> species)
  - fixed.bin   (fixed floor 7 = arène Spiritomb)
  - LSD / SSA   (flux des scènes)

et vérifie les fichiers PMDO réels :
  - Data/Zone/{chasm_cave,dark_hill,sealed_ruin,sealed_ruin_pit,spiritomb_room,dusk_forest}.json
  - Data/Map/spiritomb_arena.rsmap
  - Data/Ground/d1[89]p11a..d22p11a.rsground
  - Content/Tile/*.tile
  - Data/Script/halcyon/{ground,zone,future_arc}/*.lua

Retourne un code d'erreur non-zero si un problème est détecté
(floor manquant, Pokémon différent, naming mismatch, référence morte,
placeholder, BGM absent, etc.).

Usage : python3 audit_master_future.py  (exit 0 = OK)
"""

import json
import os
import re
import sys
import glob

V4 = "/tmp/v4work"
MAPPA = "/tmp/mappa_s.bin"
MONSTER = "/tmp/pret-pmd-sky/files/BALANCE/monster.md"
FIXED = "/tmp/fixed.bin"

FAIL = 0
WARN = 0
def fail(msg):
    global FAIL
    FAIL += 1
    print(f"  [FAIL] {msg}")
def warn(msg):
    global WARN
    WARN += 1
    print(f"  [WARN] {msg}")

from skytemple_files.dungeon_data.mappa_bin.handler import MappaBinHandler
from skytemple_files.common.types.file_types import FileType
from skytemple_files.dungeon_data.fixed_bin.handler import FixedBinHandler

# ============================================================
# 1. VÉRITÉ NDS
# ============================================================
print("=" * 70)
print("1. SOURCE DE VÉRITÉ NDS (mappa_s.bin, monster.md, fixed.bin)")
print("=" * 70)
mb = MappaBinHandler.deserialize(open(MAPPA, "rb").read())
md = FileType.MD.deserialize(open(MONSTER, "rb").read())
MD2DEX = {e.md_index: e.national_pokedex_number + 1 for e in md.entries}
fb = FixedBinHandler.deserialize(open(FIXED, "rb").read())

# groupes / prec / nfloors (déjà établis et validés)
GROUPS = {27: 18, 28: 19, 29: 20, 30: 20, 31: 20, 32: 21}
PRECS  = {27: 0, 28: 0, 29: 0, 30: 8, 31: 14, 32: 0}
NFL    = {27: 8, 28: 15, 29: 8, 30: 6, 31: 1, 32: 8}

# CORRECTION 2026-08-09 : le champ monstre de mappa_s.bin est le MONSTER_ID
# (1-based, pmdsky-debug). L'ancienne table indexée par « npn+1 » donnait des
# espèces décalées après le bloc des 28 formes de Zarbi. Identité directe :
DEX_SPECIES = {
    41: "zubat", 42: "golbat", 67: "machoke", 68: "machamp",
    81: "magnemite", 82: "magneton", 89: "muk", 92: "gastly",
    93: "haunter", 94: "gengar", 95: "onix", 132: "ditto",
    169: "crobat", 189: "jumpluff", 200: "misdreavus", 232: "forretress",
    254: "skarmory", 354: "grumpig", 372: "claydol", 386: "banette",
    388: "dusclops", 404: "shelgon", 407: "metang", 453: "mothim",
    467: "drifloon", 468: "drifblim", 471: "mismagius", 484: "spiritomb",
    486: "gabite", 507: "tangrowth", 514: "gliscor", 518: "probopass",
}
TSET_NAME = {26: "chasm_cave", 27: "chasm_cave", 28: "dark_hill", 29: "dark_hill",
             30: "sealed_ruin", 31: "sealed_ruin_pit", 33: "dusk_forest",
             34: "dusk_forest", 176: "sealed_ruin_pit", 187: "sealed_ruin_pit"}
MUSIC_NDS = {19: "Chasm Cave.ogg", 20: "Dark Hill.ogg", 21: "Sealed Ruin.ogg",
             22: "Sealed Ruin Pit.ogg", 23: "Dusk Forest.ogg"}

DUNGEONS = {  # zone_id -> (did, nom canonique)
    "chasm_cave": (27, "Chasm Cave"),
    "dark_hill": (28, "Dark Hill"),
    "sealed_ruin": (29, "Sealed Ruin"),
    "sealed_ruin_pit": (30, "Sealed Ruin Pit"),
    "spiritomb_room": (31, "Spiritomb Room"),
    "dusk_forest": (32, "Dusk Forest"),
}

def nds_floor(did, k):
    g = mb.floor_lists[GROUPS[did]]
    f = g[PRECS[did] + k]
    L = f.layout
    return {
        "tileset": L.tileset_id, "music": L.music_id, "darkness": L.darkness_level,
        "monster_house": L.monster_house_chance, "fixed_floor": L.fixed_floor_id,
        "monsters": sorted([(m.md_index, m.level, m.main_spawn_weight)
                            for m in f.monsters if m.main_spawn_weight > 0]),
    }

# ============================================================
# 2. VÉRIFICATION DES 46 FLOORS + 224 POKÉMON
# ============================================================
print()
print("=" * 70)
print("2. AUDIT DES 46 FLOORS (Zones PMDO vs mappa_s.bin)")
print("=" * 70)

total_nds_mobs = 0
total_pmdo_mobs = 0
floor_ok = 0
floor_total = 0

for zid, (did, name) in DUNGEONS.items():
    zpath = os.path.join(V4, "Data/Zone", zid + ".json")
    if not os.path.exists(zpath):
        fail(f"Zone manquante : {zid}.json")
        continue
    try:
        d = json.load(open(zpath, encoding="utf-8"))
    except Exception as e:
        fail(f"Zone {zid}.json illisible : {e}")
        continue
    # nom canonique du segment
    seg_name = d["Object"].get("Name", {}).get("DefaultText", "")
    if seg_name != name:
        warn(f"Nom de zone '{seg_name}' != canonique '{name}' ({zid})")
    seg = d["Object"]["Segments"][0]
    floors = seg.get("Floors") or []
    if len(floors) != NFL[did]:
        fail(f"{zid}: {len(floors)} floors au lieu de {NFL[did]}")
    for k in range(NFL[did]):
        floor_total += 1
        nds = nds_floor(did, k)
        f = floors[k]
        if zid == "spiritomb_room":
            # FIXED FLOOR : vérifié en section 4 (RoomGenLoadMap + .rsmap + MapTeams)
            # pas de MobSpawnStep/dark dans le GridFloorGen — le boss est dans la .rsmap
            floor_ok += 1
            continue
        pm = {"tileset": None, "music": None, "sight": None, "mobs": []}
        for st in f.get("GenSteps", []):
            v = st.get("Value", {})
            t = v.get("$type", "")
            if "MapDataStep" in t:
                pm["music"] = v.get("Music"); pm["sight"] = v.get("TileSight")
            if "MapTextureStep" in t:
                pm["tileset"] = v.get("GroundTileset")
            if "MobSpawnStep" in t:
                for sp in v.get("Spawns", []):
                    inner = sp["Spawn"]["Spawns"][0]["Spawn"]["Spawn"]
                    pm["mobs"].append((inner["BaseForm"]["Species"], inner["Level"]["Min"], sp["Rate"]))
        errs = []
        # tileset
        exp_ts = TSET_NAME.get(nds["tileset"])
        if pm["tileset"] != exp_ts + "_floor":
            errs.append(f"tileset PMDO {pm['tileset']} != NDS {nds['tileset']}({exp_ts})")
        # musique
        exp_mus = MUSIC_NDS.get(nds["music"])
        if pm["music"] != exp_mus:
            errs.append(f"musique {pm['music']} != NDS {nds['music']}({exp_mus})")
        # dark
        exp_sight = 0 if nds["darkness"] > 0 else 1
        if pm["sight"] != exp_sight:
            errs.append(f"dark: sight {pm['sight']} != attendu {exp_sight}")
        # monstres
        pm_mobs = {}
        for sp, lv, rate in pm["mobs"]:
            pm_mobs.setdefault(sp, []).append((lv, rate))
        nds_seen = set()
        for md_idx, lv, w in nds["monsters"]:
            sp = DEX_SPECIES.get(md_idx)  # md_idx = MONSTER_ID (identité directe)
            if not sp:
                errs.append(f"md {md_idx} non résolu")
                continue
            nds_seen.add(sp)
            exp_rate = max(1, round(w / 100.0))
            plist = pm_mobs.get(sp)
            if plist is None:
                errs.append(f"Pokémon {sp} (md {md_idx}) absent PMDO")
            else:
                if not any(pl == lv and pr == exp_rate for pl, pr in plist):
                    errs.append(f"{sp}: NDS L{lv} w{w}->r{exp_rate} | PMDO {plist}")
        for sp in pm_mobs:
            if sp not in nds_seen:
                errs.append(f"Pokémon {sp} en trop (absent NDS)")
        total_nds_mobs += len(nds["monsters"])
        total_pmdo_mobs += len(pm["mobs"])
        if errs:
            fail(f"{zid} F{k+1}: {'; '.join(errs)}")
        else:
            floor_ok += 1

print(f"Floors : {floor_ok}/{floor_total}")
print(f"Pokémon : NDS {total_nds_mobs} / PMDO {total_pmdo_mobs}")

# ============================================================
# 3. MONSTER HOUSES
# ============================================================
print()
print("=" * 70)
print("3. MONSTER HOUSES (NDS vs PMDO)")
print("=" * 70)
EXPECTED_MH = {"chasm_cave": 0, "dark_hill": 0, "sealed_ruin": 5,
               "sealed_ruin_pit": 5, "spiritomb_room": 5, "dusk_forest": 0}
for zid, exp in EXPECTED_MH.items():
    zpath = os.path.join(V4, "Data/Zone", zid + ".json")
    d = json.load(open(zpath, encoding="utf-8"))
    pm = 0
    for zs in d["Object"]["Segments"][0].get("ZoneSteps", []):
        if "SpreadHouseZoneStep" in zs.get("$type", ""):
            pm = zs["SpreadPlan"]["Chance"]
    if pm != exp:
        fail(f"{zid}: MH PMDO {pm} != NDS {exp}")
    else:
        print(f"  {zid}: MH={pm} ✅")

# ============================================================
# 4. SPIRITOMB — FIXED FLOOR (audit critique)
# ============================================================
print()
print("=" * 70)
print("4. SPIRITOMB — FIXED FLOOR (spiritomb_room.json + spiritomb_arena.rsmap)")
print("=" * 70)

# 4a. fixed floor 7 NDS
ff7 = fb.fixed_floors[7]
if ff7.width != 22 or ff7.height != 17:
    fail(f"Fixed floor 7 NDS : {ff7.width}x{ff7.height} != 22x17")
else:
    print(f"  Fixed floor 7 NDS : {ff7.width}x{ff7.height} ✅")

# 4b. spiritomb_room.json : RoomGenLoadMap -> spiritomb_arena
zpath = os.path.join(V4, "Data/Zone/spiritomb_room.json")
d = json.load(open(zpath, encoding="utf-8"))
f0 = d["Object"]["Segments"][0]["Floors"][0]
s = json.dumps(d)
if "RoomGenLoadMap" not in s:
    fail("spiritomb_room.json : pas de RoomGenLoadMap (fixed floor attendu)")
else:
    if '"MapID": "spiritomb_arena"' not in s:
        fail("spiritomb_room.json : MapID != spiritomb_arena")
    else:
        print("  spiritomb_room.json : RoomGenLoadMap(MapID=spiritomb_arena) ✅")

# 4c. spiritomb_arena.rsmap
rmap = os.path.join(V4, "Data/Map/spiritomb_arena.rsmap")
if not os.path.exists(rmap):
    fail("spiritomb_arena.rsmap absent")
else:
    d = json.load(open(rmap, encoding="utf-8-sig"))
    obj = d["Object"]
    tiles = obj.get("Tiles", [])
    W_, H_ = len(tiles), len(tiles[0]) if tiles else 0
    if (W_, H_) != (22, 17):
        fail(f"spiritomb_arena : {W_}x{H_} != 22x17")
    else:
        print(f"  spiritomb_arena.rsmap : {W_}x{H_} ✅")
    # MapTeams[0] = Spiritomb L51
    mt = obj.get("MapTeams", [])
    if not mt:
        fail("spiritomb_arena : MapTeams vide (pas de boss)")
    else:
        p0 = mt[0].get("Players", [{}])[0]
        sp = p0.get("BaseForm", {}).get("Species")
        lv = p0.get("Level")
        if sp != "spiritomb" or lv != 51:
            fail(f"spiritomb_arena : boss {sp} L{lv} != spiritomb L51")
        else:
            print(f"  spiritomb_arena : Spiritomb L51 ✅")
    # BattlePositionEvent
    me = json.dumps(obj.get("MapEffect", {}))
    if "BattlePositionEvent" not in me:
        fail("spiritomb_arena : BattlePositionEvent absent (pas de déclenchement de combat)")
    else:
        print("  spiritomb_arena : BattlePositionEvent ✅")
    # EntryPoints
    if not obj.get("EntryPoints"):
        fail("spiritomb_arena : pas d'EntryPoints")
    else:
        print(f"  spiritomb_arena : EntryPoints {obj['EntryPoints']} ✅")

# ============================================================
# 5. D21P41A init.lua — flux combat
# ============================================================
print()
print("=" * 70)
print("5. d21p41a/init.lua — flux combat (approche -> intro -> EnterDungeon -> fuite)")
print("=" * 70)
init = open(os.path.join(V4, "Data/Script/halcyon/ground/d21p41a/init.lua"), encoding="utf-8").read()
for needle, label in [
    ("d21p41a_m18b1101", "m18b1101 approche"),
    ("d21p41a_m18b1201", "m18b1201 intro"),
    ("EnterDungeon('spiritomb_room'", "EnterDungeon spiritomb_room"),
    ("SpiritombBattleDone", "flag SpiritombBattleDone"),
    ("d21p41a_m18b1301", "m18b1301 fuite"),
    ("EnterGroundMap('d22p11a'", "transition d22p11a"),
]:
    if needle not in init:
        fail(f"d21p41a/init.lua : {label} absent")
    else:
        print(f"  {label} ✅")

# ============================================================
# 6. GROUNDS — fichiers + nommage canonique
# ============================================================
print()
print("=" * 70)
print("6. GROUNDS (rsground + tile + init + master_zone + nommage)")
print("=" * 70)
GROUNDS = ["d18p11a", "d19p11a", "d20p11a", "d21p21a", "d21p41a", "d22p11a"]
mz = json.load(open(os.path.join(V4, "Data/Zone/master_zone.json"), encoding="utf-8"))
mz_grounds = mz["Object"]["GroundMaps"]
for g in GROUPS_LABEL if False else GROUNDS:
    rs = os.path.join(V4, "Data/Ground", g + ".rsground")
    tile = os.path.join(V4, "Content/Tile", g[0].upper() + g[1:] + "_Base.tile")
    init = os.path.join(V4, "Data/Script/halcyon/ground", g, "init.lua")
    ok = True
    if not os.path.exists(rs):
        fail(f"{g}.rsground absent"); ok = False
    if not os.path.exists(tile):
        # essayer minuscule
        tile2 = os.path.join(V4, "Content/Tile", g + "_Base.tile")
        if not os.path.exists(tile2):
            fail(f"{g}_Base.tile absent"); ok = False
    if not os.path.exists(init):
        fail(f"{g}/init.lua absent"); ok = False
    if g not in mz_grounds:
        fail(f"{g} absent de master_zone"); ok = False
    # nommage canonique : AssetName du rsground == g
    if os.path.exists(rs):
        try:
            rd = json.load(open(rs, encoding="utf-8-sig"))
            an = rd["Object"].get("AssetName", "")
            if an.lower() != g:
                warn(f"{g}.rsground AssetName '{an}' != canonique '{g}'")
        except Exception as e:
            warn(f"{g}.rsground illisible : {e}")
    if ok:
        print(f"  {g} : rsground+tile+init+master_zone ✅")

# ============================================================
# 7. CHAÎNE DE PARCOURS (transitions runtime)
# ============================================================
print()
print("=" * 70)
print("7. CHAÎNE DE PARCOURS (transitions câblées)")
print("=" * 70)
# p05p04a -> d18p11a (FutureArc.NEXT_GROUND)
fa = open(os.path.join(V4, "Data/Script/halcyon/future_arc/FutureArc.lua"), encoding="utf-8").read()
if "NEXT_GROUND['p05p04a'] = 'd18p11a'" not in fa:
    fail("FutureArc : p05p04a -> d18p11a non câblé")
else:
    print("  FutureArc : p05p04a -> d18p11a ✅")
# d18p11a -> d19p11a (AfterDungeon)
for src, dst in [("d18p11a", "d19p11a"), ("d19p11a", "d20p11a"), ("d20p11a", "d21p21a"),
                 ("d21p21a", "d21p41a"), ("d21p41a", "d22p11a"), ("d22p11a", "p08p01a")]:
    p = os.path.join(V4, "Data/Script/halcyon/ground", src, "init.lua")
    t = open(p, encoding="utf-8").read()
    if f"EnterGroundMap('{dst}'" not in t:
        fail(f"{src}/init.lua : transition -> {dst} absente")
    else:
        print(f"  {src} -> {dst} ✅")

# ============================================================
# 8. RECHERCHE DE FAUX POSITIFS / PLACEHOLDERS / RÉFÉRENCES MORTES
# ============================================================
print()
print("=" * 70)
print("8. FAUX POSITIFS / PLACEHOLDERS / RÉFÉRENCES MORTES")
print("=" * 70)
BANNED = ["generic arena", "battle_room", "arena_default", "default arena",
          "temp_ground", "stub_ground", "generic_ground", "ground_01", "scene_ground",
          "Dungeon_27", "Zone_28", "Area_003", "ImportedDungeon", "GenericCave",
          "Floor_001", "Structure_01", "Room_A", "BossRoomGeneric", "ImportRoom"]
search_dirs = [
    os.path.join(V4, "Data/Zone/chasm_cave.json"), os.path.join(V4, "Data/Zone/dark_hill.json"),
    os.path.join(V4, "Data/Zone/sealed_ruin.json"), os.path.join(V4, "Data/Zone/sealed_ruin_pit.json"),
    os.path.join(V4, "Data/Zone/spiritomb_room.json"), os.path.join(V4, "Data/Zone/dusk_forest.json"),
    os.path.join(V4, "Data/Map/spiritomb_arena.rsmap"),
    os.path.join(V4, "Data/Script/halcyon/future_arc"),
    os.path.join(V4, "Data/Script/halcyon/zone/chasm_cave"), os.path.join(V4, "Data/Script/halcyon/zone/dark_hill"),
    os.path.join(V4, "Data/Script/halcyon/zone/sealed_ruin"), os.path.join(V4, "Data/Script/halcyon/zone/sealed_ruin_pit"),
    os.path.join(V4, "Data/Script/halcyon/zone/spiritomb_room"), os.path.join(V4, "Data/Script/halcyon/zone/dusk_forest"),
    os.path.join(V4, "Data/Script/halcyon/ground/d18p11a"), os.path.join(V4, "Data/Script/halcyon/ground/d19p11a"),
    os.path.join(V4, "Data/Script/halcyon/ground/d20p11a"), os.path.join(V4, "Data/Script/halcyon/ground/d21p21a"),
    os.path.join(V4, "Data/Script/halcyon/ground/d21p41a"), os.path.join(V4, "Data/Script/halcyon/ground/d22p11a"),
]
found_banned = []
for d_ in search_dirs:
    for p in glob.glob(os.path.join(d_, "**", "*"), recursive=True):
        if os.path.isfile(p) and p.endswith((".json", ".lua", ".rsmap", ".rsground")):
            try:
                if p.endswith(".rsground"):
                    continue  # binaires/JSON lourds vérifiés ailleurs
                txt = open(p, encoding="utf-8", errors="ignore").read()
            except Exception:
                continue
            for b in BANNED:
                if b.lower() in txt.lower():
                    found_banned.append((os.path.relpath(p, V4), b))
for f_, b in found_banned:
    fail(f"placeholder/bannissement '{b}' dans {f_}")
if not found_banned:
    print("  Aucun placeholder / nom générique détecté ✅")

# TODO / FIXME / NOT CONVERTED dans les scènes D (hors commentaires légitimes)
todo_dirs = [os.path.join(V4, "Data/Script/halcyon/future_arc/scene")]
for d_ in todo_dirs:
    for p in glob.glob(os.path.join(d_, "d2*.lua")) + glob.glob(os.path.join(d_, "d1*.lua")):
        txt = open(p, encoding="utf-8").read()
        # on ne compte que les NON CONVERTI dans le corps (pas l'en-tête)
        body = txt.split("]]", 1)[-1] if "]]" in txt else txt
        if "NON CONVERTI" in body:
            warn(f"{os.path.basename(p)} : op NON CONVERTI dans le corps")

# ============================================================
# 9. AUDIO (recherche globale des BGM)
# ============================================================
print()
print("=" * 70)
print("9. AUDIO (recherche globale BGM)")
print("=" * 70)
import subprocess
music_files = set()
try:
    out = subprocess.run(["git", "-C", V4, "ls-files", "Content/Music"],
                         capture_output=True, text=True, timeout=30).stdout
    for line in out.splitlines():
        music_files.add(os.path.basename(line))
except Exception:
    pass
for p in glob.glob(os.path.join(V4, "Content/Music", "*.ogg")):
    music_files.add(os.path.basename(p))
for need in ["Chasm Cave.ogg", "Dark Hill.ogg", "Sealed Ruin.ogg",
             "Sealed Ruin Pit.ogg", "Dusk Forest.ogg"]:
    if need in music_files:
        print(f"  {need} ✅")
    else:
        fail(f"BGM absent : {need} (REQUIRES_ASSET)")

# ============================================================
# 10. PIÈGES (équivalents / non mappés)
# ============================================================
print()
print("=" * 70)
print("10. PIÈGES (équivalents PMDO documentés)")
print("=" * 70)
# collecte des traps référencés dans les zones
traps_used = set()
for zid in DUNGEONS:
    zpath = os.path.join(V4, "Data/Zone", zid + ".json")
    d = json.load(open(zpath, encoding="utf-8"))
    s = json.dumps(d)
    for m in re.finditer(r'"ID": "(trap_[a-z_]+)"', s):
        traps_used.add(m.group(1))
print(f"  Pièges mappés dans les zones : {len(traps_used)} ({sorted(traps_used)})")
# pièges NDS sans équivalent (documentés)
print("  Pièges NDS sans équivalent PMDO (documentés, non mappés) :")
print("    Pitfall, Warp, WonderTile, SpikedTile, StealthRock, ToxicSpikes, Spikes")

# ============================================================
# RAPPORT FINAL
# ============================================================
print()
print("=" * 70)
print("RÉSULTAT AUDIT")
print("=" * 70)
print(f"Floors OK : {floor_ok}/{floor_total}")
print(f"Pokémon : NDS {total_nds_mobs} / PMDO {total_pmdo_mobs}")
print(f"FAIL : {FAIL} | WARN : {WARN}")
sys.exit(1 if FAIL else 0)
