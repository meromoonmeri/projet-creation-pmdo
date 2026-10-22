#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
sky_build_zone_from_tables.py — Traduction technique d'un donjon Sky
(tables ROM EU) vers une Zone PMDO jouable, en RÉUTILISANT le gabarit de
zone déjà validé CANONICAL_RUNTIME_PASS (D27-D32, format gen_future_
dungeons + correctifs ROM de cette session).

ANTI-DOUBLON : aucun nouveau système — le gabarit d'étage est CLONÉ depuis
Data/Zone/dusk_forest.json (types $type natifs 0.8.12 attestés en runtime),
puis chaque champ canonique est substitué depuis les tables ROM :
  - spawns Pokémon (espèces mappées PMDO_MAPPING, niveaux exacts, poids
    /10000 décumulés) ;
  - items par étage (mappables ; REQUIRES_MOD_ITEM exclus + documentés) ;
  - pièges (poids ROM décumulés) ; money (max_coin) ;
  - musique (music_id ROM → .ogg présent, vérifié) ; darkness ;
  - tileset (tileset_id ROM → auto-tilesets beach_cave_* du DumpAsset).
Les densités mappa (room/enemy/item/trap) sont ADAPTÉES aux gabarits
RogueElements existants (les paramètres de génération EoS n'ont pas
d'équivalence 1:1 — différence documentée dans le Comment de zone).

Usage : sky_build_zone_from_tables.py <dXX> <zone_id> [--level N]
Pilote : d01 beach_cave (4 étages, tileset beach_cave, BGM Beach Cave).
"""
import argparse
import copy
import glob
import gzip
import json
import os
import re
from collections import OrderedDict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TABLES = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS", "Tables")
TEMPLATE_ZONE = os.path.join(REPO, "Data", "Zone", "dusk_forest.json")
DUMP_AUTOTILE = os.path.join(REPO, ".runtime-cache", "DumpAsset", "Data",
                             "AutoTile")

# tileset NDS -> base d'auto-tileset PMDO (DumpAsset, noms vanilla EoS).
# Étendu à la demande ; chaque entrée vérifiée présente sur disque.
TSET = {1: "beach_cave", 2: "drenched_bluff", 3: "mt_bristle",
        4: "waterfall_cave", 5: "apple_woods", 6: "craggy_coast",
        7: "side_path", 8: "mt_horn", 9: "rock_path_tds",
        10: "foggy_forest", 11: "forest_path", 12: "steam_cave",
        14: "amp_plains", 15: "far_amp_plains",
        17: "northern_desert_1", 18: "northern_desert_2",
        19: "quicksand_cave", 20: "quicksand_pit",
        22: "crystal_cave_1", 23: "crystal_cave_2", 24: "crystal_crossing",
        26: "chasm_cave", 27: "chasm_cave", 28: "dark_hill",
        29: "dark_hill", 30: "sealed_ruin",
        # 31 = tileset des étages ROM de d30 Deep Sealed Ruin (mappa) ->
        # autotile base PMDO homonyme
        31: "deep_sealed_ruin",
        33: "dusk_forest_1", 34: "dusk_forest_2",
        35: "deep_dusk_forest_1", 36: "deep_dusk_forest_2",
        37: "treeshroud_forest_1", 38: "treeshroud_forest_2",
        39: "brine_cave", 40: "lower_brine_cave",
        42: "hidden_land", 43: "hidden_highland",
        45: "temporal_tower", 46: "temporal_spire",
        # post-game d44+ : autotiles PMDO base (DumpAsset), noms 1:1
        48: "mystifying_forest", 49: "rock_aegis_cave",
        51: "surrounded_sea", 52: "miracle_sea",
        126: "ice_aegis_cave", 127: "steel_aegis_cave",
        # portés depuis DUNGEON/dungeon.bin par sky_port_dungeon_tileset.py
        # (méthode prouvée 141/141 vs autotile officiel ts126, animations
        # DPLA préservées — session 2026-08-26)
        82: "crevice_cave", 88: "blizzard_island",
        # d61-d99 (session finale): base PMDO quand concordance possible,
        # sinon portés depuis dungeon.bin (sky_port_dungeon_tileset)
        53: "mt_travail", 54: "the_nightmare",
        55: "spacial_rift_1", 56: "spacial_rift_2",
        57: "dark_crater_1", 58: "dark_crater_2",
        50: "concealed_ruins", 117: "marine_resort",
        118: "bottomless_sea", 85: "shimmer_desert",
        111: "mt_avalanche", 123: "giant_volcano",
        59: "world_abyss_1", 125: "world_abyss_2",
        99: "sky_stairway", 61: "mystery_jungle_1",
        62: "mystery_jungle_2", 96: "serenity_river",
        103: "landslide_cave", 90: "lush_prairie",
        65: "tiny_meadow", 102: "labyrinth_cave",
        105: "oran_forest", 113: "lake_afar",
        91: "happy_outlook", 119: "mt_mistral",
        106: "shimmer_hill", 108: "lost_wilderness",
        124: "zero_isle_n1",
        # Zero Isle / Destiny Tower (session 2026-08-27) : portés depuis
        # DUNGEON/dungeon.bin (sky_port_dungeon_tileset, méthode 141/141)
        63: "zero_isle_e1", 64: "zero_isle_e2",
        16: "zero_isle_s1", 25: "zero_isle_s2",
        67: "destiny_tower_1",
        76: "zero_isle_c1", 83: "zero_isle_c2", 97: "zero_isle_c3",
        109: "zero_isle_c4", 112: "zero_isle_c5", 114: "zero_isle_c6",
        115: "zero_isle_c7", 116: "zero_isle_c8",
        # d105-d159 (Sky Peak + épisodes spéciaux, session 2026-08-27) :
        # portés depuis dungeon.bin (même méthode)
        0: "test_dungeon_ts", 32: "sky_peak_summit_pass_ts",
        44: "southern_jungle_ts", 66: "third_station_pass_ts",
        75: "southeastern_islands_ts", 80: "deep_star_cave_ts",
        84: "oblivion_forest_ts", 94: "ninth_station_pass_ts",
        104: "fortune_ravine_ts", 110: "inferno_cave_ts",
        122: "left_cave_path_ts", 128: "murky_forest_ts",
        129: "deep_boulder_quarry_ts", 130: "limestone_cavern_ts",
        131: "deep_limestone_cavern_ts", 132: "barren_valley_ts",
        133: "dark_wasteland_ts", 134: "temporal_tower_se5_ts",
        135: "temporal_spire_se5_ts", 136: "spacial_cliffs_ts",
        137: "dark_ice_mountain_ts", 138: "dark_ice_mountain_peak_ts",
        139: "icicle_forest_ts", 140: "vast_ice_mountain_ts",
        141: "vast_ice_mountain_peak_ts", 142: "fourth_station_pass_ts",
        143: "seventh_station_pass_ts",
        # d160-d179 (Spring Cave, événements Wonder Mail S, épilogue)
        78: "little_plains_ts", 89: "shopkeeper_village_ts"}
# tileset NDS 180 (d45 clearing) = MAP_BG v00p03 + fixed floor 11 :
# arène fixe, pipeline sky_build_boss_arenas (pas un donjon procédural).

# music_id mappa (mid) -> piste canonique. AUTORITÉ : MUSIC_MID_MAP.json
# (overlay10 EU MUSIC_ID_TABLE + RANDOM_MUSIC_ID_TABLE × BackgroundMusicIDs
# skytemple, contre-épreuves usage ROM d123/d124/d128/d130/d133/d136 —
# outil dev/tools/sky_music_mid_map.py). Les groupes RANDOM (0x8000|g)
# comptent 4 pistes canoniques ; la ROM en tire une aléatoirement par
# visite — PMDO fixe une musique par étage : on prend la PREMIÈRE piste
# du groupe ROM (ordre de la table), adaptation technique documentée,
# aucune substitution hors du groupe canonique.
def _load_music_mid_map():
    p = os.path.join(TABLES, "MUSIC_MID_MAP.json")
    mm = json.load(open(p))["mids"]
    out = {}
    for mid, e in mm.items():
        if "random_group" in e:
            out[int(mid)] = e["tracks"][0]["ogg"]
        elif e.get("name") == "NONE":
            # mid 0/999 = silence ROM (Music vide, légal PMDO — 53
            # exemples DumpAsset)
            out[int(mid)] = ""
        elif e.get("ogg"):
            out[int(mid)] = e["ogg"]
    return out


MUSIC = _load_music_mid_map()


def slug_species(n):
    s = n.lower().replace("♀", "_f").replace("♂", "_m")
    s = re.sub(r"[.'’]", "", s)
    s = re.sub(r"[\s-]+", "_", s)
    return s


def decumulate(pairs):
    out, prev = [], 0
    for k, w in pairs:
        out.append((k, w - prev))
        prev = w
    return out


def rom_table(dkey):
    for f in glob.glob(os.path.join(TABLES, "dungeons", f"{dkey}_*.json.gz")):
        return json.load(gzip.open(f, "rt"))
    raise SystemExit(f"table {dkey} absente")


def pool_spawner(species, level, weight):
    return {"Spawn": {
        "$type": "RogueEssence.LevelGen.PoolTeamSpawner, RogueEssence",
        "Explorer": False,
        "Spawns": [{"Spawn": {"Spawn": {
            "BaseForm": {"Species": species, "Form": 0, "Skin": "",
                         "Gender": -1},
            "Level": {"Min": level, "Max": level},
            "SpecifiedSkills": [], "Intrinsic": "",
            "Tactic": "wander_normal", "SpawnConditions": [],
            "SpawnFeatures": []}, "Role": 0}, "Rate": 10}],
        "TeamSizes": [{"Spawn": 1, "Rate": 12}]},
        "Rate": weight}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("dungeon")            # d01
    ap.add_argument("zone_id")            # beach_cave
    ap.add_argument("--level", type=int, default=None,
                    help="niveau d'équipe recommandé (défaut: max des "
                         "niveaux de spawn)")
    a = ap.parse_args()

    t = rom_table(a.dungeon)
    mapping = json.load(open(os.path.join(TABLES, "PMDO_MAPPING.json")))
    sp_map = mapping["species"]["entries"]
    it_map = mapping["items"]["entries"]
    tr_map = {k: v.get("pmdo_tile")
              for k, v in mapping["traps"]["entries"].items()}

    tpl_doc = json.load(open(TEMPLATE_ZONE, encoding="utf-8-sig"))
    tpl = tpl_doc["Object"]
    tpl_seg = tpl["Segments"][0]
    tpl_floor = tpl_seg["Floors"][0]

    floors_rom = t["floors"]
    # vérifier tileset/musique disponibles (fail-closed, pas de fallback
    # silencieux)
    tsets = sorted({f["layout"]["tileset_id"] for f in floors_rom})
    for ts in tsets:
        base = TSET.get(ts)
        if not base:
            raise SystemExit(f"tileset NDS {ts} non mappé — compléter TSET")
        for suf in ("floor", "wall", "secondary"):
            p = os.path.join(DUMP_AUTOTILE, f"{base}_{suf}.json")
            pq = os.path.join(REPO, "Data", "AutoTile", f"{base}_{suf}.json")
            if not os.path.exists(p) and not os.path.exists(pq):
                raise SystemExit(f"auto-tileset absent: {base}_{suf}")
    musics = sorted({f["layout"]["music_id"] for f in floors_rom})
    for mid in musics:
        if mid not in MUSIC:
            raise SystemExit(f"music_id {mid} non mappé — compléter MUSIC")

    # ---- zone header
    zone = copy.deepcopy(tpl)
    name_en = t["name_en"]
    name_fr = t["name_fr"]
    max_level = max((m["level"] for f in floors_rom for m in f["monsters"]
                     if m["main_spawn_weight"] > 0), default=5)
    zone["Name"] = {"DefaultText": name_en,
                    "LocalTexts": {"fr": name_fr} if name_fr else {}}
    zone["Level"] = a.level or max_level
    zone["Comment"] = (
        f"PMD Sky EU {a.dungeon} {t['pret_enum']} — zone traduite des "
        f"tables ROM mappa_s.bin exactes (sky_build_zone_from_tables.py, "
        f"gabarit runtime-validé dusk_forest). Spawns/niveaux/poids/"
        f"pièges/items/musique/darkness = ROM ; géométrie = gabarits "
        f"RogueElements natifs (paramètres EoS sans équivalence 1:1 — "
        f"adaptation technique documentée). Items REQUIRES_MOD_ITEM "
        f"exclus (voir ZONE_FIX_REPORT).")

    seg = zone["Segments"][0]
    seg["Comment"] = f"{name_en} B1-B{len(floors_rom)}"

    # ---- zone steps : items, traps, money
    excluded = OrderedDict()
    for st in seg["ZoneSteps"]:
        ty = st.get("$type", "")
        if ty.startswith("RogueEssence.LevelGen.ItemSpawnZoneStep"):
            spawns = []
            sigs = OrderedDict()
            for fi, rf in enumerate(floors_rom):
                sig = json.dumps(rf["items"]["floor"], sort_keys=True)
                sigs.setdefault(sig, []).append(fi)
            for sig, fls in sigs.items():
                rf = floors_rom[fls[0]]
                pairs = [(it["en"], it["weight"]) for it in
                         rf["items"]["floor"]["items"] if it["en"]]
                for (en, w) in decumulate(pairs):
                    if w <= 0:
                        continue
                    ent = it_map.get(en, {})
                    if ent.get("status") in ("EXACT", "RENAMED", "TM"):
                        spawns.append({
                            "Spawn": {"ID": ent["pmdo_item"],
                                      "Cursed": False, "HiddenValue": "",
                                      "Amount": 0, "Price": 0},
                            "Rate": w,
                            "Range": {"Min": min(fls), "Max": max(fls) + 1}})
                    elif ent.get("status") == "MONEY":
                        pass
                    else:
                        excluded[en] = excluded.get(en, 0) + w
            st["Spawns"] = {"canonical_floor_items": {
                "Spawns": spawns,
                "SpawnRates": {"nodes": [{"Item": 1, "Range": {
                    "Min": 0, "Max": len(floors_rom)}}]}}} if spawns else {}
        elif ty.startswith("RogueEssence.LevelGen.TileSpawnZoneStep"):
            # les poids de pièges peuvent varier PAR ÉTAGE dans la ROM
            # (ex. d50 étages 1-9 vs 10-20) : un groupe de spawns par
            # signature, avec les plages d'étages EXACTES — jamais
            # seulement l'étage 1 généralisé.
            spawns = []
            tsigs = OrderedDict()
            for fi, rf in enumerate(floors_rom):
                sig = json.dumps(rf["traps"], sort_keys=True)
                tsigs.setdefault(sig, []).append(fi)
            for sig, fls in tsigs.items():
                rom_traps = decumulate(
                    list(floors_rom[fls[0]]["traps"].items()))
                # plages contiguës d'étages pour cette signature
                ranges = []
                start = prev = fls[0]
                for fi in fls[1:]:
                    if fi == prev + 1:
                        prev = fi
                    else:
                        ranges.append((start, prev))
                        start = prev = fi
                ranges.append((start, prev))
                for (lo, hi) in ranges:
                    spawns.extend({
                        "Spawn": {"TileLoc": {"X": 0, "Y": 0},
                                  "ID": tr_map[tr], "Revealed": True,
                                  "Owner": 0, "TileStates": []},
                        "Rate": w,
                        "Range": {"Min": lo, "Max": hi + 1}}
                        for tr, w in rom_traps
                        if w > 0 and tr_map.get(tr)
                        and tr_map[tr] != "tile_wonder")
            st["Spawns"] = spawns

    # ---- floors
    new_floors = []
    for fi, rf in enumerate(floors_rom):
        fl = copy.deepcopy(tpl_floor)
        l = rf["layout"]
        base = TSET[l["tileset_id"]]
        js = json.dumps(fl)
        js = js.replace('"dusk_forest_1_floor"', f'"{base}_floor"')
        js = js.replace('"dusk_forest_1_wall"', f'"{base}_wall"')
        js = js.replace('"dusk_forest_1_secondary"', f'"{base}_secondary"')
        js = js.replace('"Dusk Forest.ogg"', f'"{MUSIC[l["music_id"]]}"')
        fl = json.loads(js)
        for step in fl.get("GenSteps", []):
            val = step.get("Value", {})
            vt = val.get("$type", "")
            if "MapDataStep" in vt:
                val["Music"] = MUSIC[l["music_id"]]
                val["TileSight"] = 0 if l["darkness_level"] > 0 else 1
                val["CharSight"] = 1
            elif "MobSpawnStep" in vt:
                rom_sp = [(m["en"], m["level"], m["main_spawn_weight"])
                          for m in rf["monsters"]
                          if m["main_spawn_weight"] > 0 and m["en"]
                          and m["en"] != "Decoy"]
                ind = decumulate([(en, w) for en, _, w in rom_sp])
                val["Spawns"] = [
                    pool_spawner(sp_map[en]["pmdo_species"], lv, w)
                    for (en, lv, _), (_, w) in zip(rom_sp, ind) if w > 0]
            elif "PerlinWaterStep" in vt:
                # densité d'eau ROM (0 = pas d'eau)
                if l["water_density"] == 0:
                    val["WaterFrequency"] = {"Min": 0, "Max": 0} if \
                        isinstance(val.get("WaterFrequency"), dict) else 0
        new_floors.append(fl)
    seg["Floors"] = new_floors

    out_p = os.path.join(REPO, "Data", "Zone", f"{a.zone_id}.json")
    if os.path.exists(out_p):
        raise SystemExit(f"{out_p} existe déjà — refus d'écraser "
                         f"(anti-doublon)")
    doc = {"Version": tpl_doc["Version"], "Object": zone}
    with open(out_p, "w", encoding="utf-8-sig") as fh:
        json.dump(doc, fh, ensure_ascii=False, indent=2)

    # index.idx : EntrySummary complet (format RogueEssence attesté)
    idx_p = os.path.join(REPO, "Data", "Zone", "index.idx")
    idx = json.load(open(idx_p, encoding="utf-8-sig"))
    obj = idx["Object"]
    if a.zone_id not in obj:
        obj[a.zone_id] = {
            "$type": "RogueEssence.Data.ZoneEntrySummary, RogueEssence",
            "ExpPercent": zone.get("ExpPercent", 100),
            "Level": zone["Level"], "LevelCap": zone.get("LevelCap", False),
            "KeepSkills": zone.get("KeepSkills", False),
            "TeamRestrict": zone.get("TeamRestrict", False),
            "TeamSize": zone.get("TeamSize", -1),
            "MoneyRestrict": zone.get("MoneyRestrict", False),
            "BagRestrict": zone.get("BagRestrict", -1),
            "KeepTreasure": zone.get("KeepTreasure", False),
            "BagSize": zone.get("BagSize", -1),
            "Rescues": zone.get("Rescues", 2),
            "CountedFloors": len(new_floors), "Rogue": 0,
            "Grounds": list(zone.get("GroundMaps", [])),
            "Maps": [list(range(len(new_floors)))],
            "Name": zone["Name"], "Released": True,
            "Comment": f"PMD Sky EU {a.dungeon} {t['pret_enum']}",
            "SortOrder": 0}
    json.dump(idx, open(idx_p, "w", encoding="utf-8-sig"),
              ensure_ascii=False, indent=2)

    print(f"zone écrite: {out_p} ({len(new_floors)} étages, "
          f"tileset {tsets}, musique {[MUSIC[m] for m in musics]})")
    if excluded:
        print("items exclus (REQUIRES_MOD_ITEM):", dict(excluded))


if __name__ == "__main__":
    main()
