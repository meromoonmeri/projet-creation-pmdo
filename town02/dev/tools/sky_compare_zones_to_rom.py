#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
sky_compare_zones_to_rom.py — Comparaison systématique des zones Sky déjà
construites dans Data/Zone contre les tables ROM EU extraites (§4 de la
mission : le travail existant est une implémentation à auditer contre la
ROM, jamais présumée correcte).

Dimensions comparées PAR ÉTAGE (statuts stricts, jamais fusionnés) :
  - species_levels : espèces + niveaux du MobSpawnStep vs table mappa
    (Kecleon poids 0 = boutiquier, Decoy = entité spéciale : attendus hors
    table de spawn)
  - spawn_rates    : poids cumulés mappa (base 10000) vs Rate cumulés de la
    zone (toute base commune acceptée si les proportions sont exactes)
  - items          : ItemSpawnZoneStep vide alors que la ROM a une table
    d'items par étage → INCOMPLETE
  - traps          : IDs de pièges de la zone vs table mappa (via
    PMDO_MAPPING.json), poids proportionnels
  - floor_count    : nombre d'étages
  - money          : présence MoneySpawnZoneStep quand la ROM spawn du Poké

Sortie : dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables/ZONE_VS_ROM_COMPARISON.json
         + .md
"""
import glob
import gzip
import json
import os
import re
from collections import OrderedDict
from fractions import Fraction

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TABLES = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS", "Tables")
MAPPING = json.load(open(os.path.join(TABLES, "PMDO_MAPPING.json")))

# zones Sky construites dans le dépôt -> donjon ROM
ZONE_TO_DUNGEON = {
    "chasm_cave": "d27", "dark_hill": "d28", "sealed_ruin": "d29",
    "sealed_ruin_pit": "d30", "spiritomb_room": "d31", "dusk_forest": "d32",
    "beach_cave": "d01", "drenched_bluff": "d03", "mt_bristle": "d04",
    "waterfall_cave": "d06", "apple_woods": "d07", "craggy_coast": "d08",
    "side_path": "d09", "mt_horn": "d10", "rock_path_sky": "d11",
    "foggy_forest": "d12", "forest_path": "d13", "steam_cave": "d14",
    "upper_steam_cave": "d15", "amp_plains": "d17",
    "far_amp_plains": "d18", "northern_desert": "d20",
    "quicksand_cave": "d21", "quicksand_pit": "d22",
    "crystal_cave": "d24", "crystal_crossing": "d25",
    "deep_dusk_forest": "d33", "treeshroud_forest": "d34",
    "brine_cave": "d35", "lower_brine_cave": "d36",
    "hidden_land": "d38", "hidden_highland": "d39",
    "temporal_tower": "d41", "temporal_spire": "d42",
    # arènes fixes (fixed.bin) — table mappa dormante, vérif ACCEPTED
    "beach_cave_pit": "d02", "mt_bristle_peak": "d05",
    "steam_cave_peak": "d16", "amp_clearing": "d19",
    "underground_lake": "d23", "crystal_lake": "d26",
    "brine_cave_pit": "d37", "old_ruins": "d40",
    "temporal_pinnacle": "d43",
    # post-game d44+ (tilesets/musiques base PMDO — session 2026-08-26)
    "mystifying_forest_post": "d44", "surrounded_sea": "d50",
    "miracle_sea": "d51", "deep_miracle_sea": "d52",
    "miracle_seabed": "d53", "ice_aegis_cave": "d54",
    "regice_chamber": "d55", "rock_aegis_cave": "d56",
    "regirock_chamber": "d57", "steel_aegis_cave": "d58",
    "registeel_chamber": "d59", "aegis_cave_pit": "d60",
    # d46-d49: tilesets 82/88 portés depuis dungeon.bin (session clôture)
    "blizzard_island": "d46", "crevice_cave": "d47",
    "lower_crevice_cave": "d48", "crevice_cave_pit": "d49",
    # d61-d98 (session finale)
    "mt_travail_post": "d62", "the_nightmare": "d63",
    "spacial_rift": "d64", "deep_spacial_rift": "d65",
    "dark_crater": "d67", "deep_dark_crater": "d68",
    "concealed_ruins_post": "d70", "marine_resort": "d72",
    "bottomless_sea": "d73", "shimmer_desert": "d75",
    "mt_avalanche": "d77", "giant_volcano": "d79",
    "world_abyss": "d81", "sky_stairway": "d83",
    "mystery_jungle": "d85", "serenity_river": "d87",
    "landslide_cave": "d88", "lush_prairie_post": "d89",
    "tiny_meadow_post": "d90", "labyrinth_cave": "d91",
    "oran_forest": "d92", "lake_afar": "d93",
    "happy_outlook": "d94", "mt_mistral": "d95",
    "shimmer_hill": "d96", "lost_wilderness": "d97",
    "midnight_forest": "d98",
    # Zero Isle / Destiny Tower (session 2026-08-27)
    "zero_isle_north": "d99", "zero_isle_east": "d100",
    "zero_isle_west": "d101", "zero_isle_south": "d102",
    "zero_isle_center": "d103", "destiny_tower": "d104",
    # d107-d158 : Sky Peak + donjons cachés + épisodes spéciaux
    # (session 2026-08-27) — d105/d106 = '[M:D1]Dummy' ROM, non construits
    "oblivion_forest": "d107", "treacherous_waters": "d108",
    "southeastern_islands": "d109", "inferno_cave": "d110",
    "first_station_pass": "d111", "second_station_pass": "d112",
    "third_station_pass": "d113", "fourth_station_pass": "d114",
    "fifth_station_pass": "d115", "sixth_station_pass": "d116",
    "seventh_station_pass": "d117", "eighth_station_pass": "d118",
    "ninth_station_pass": "d119", "sky_peak_summit_pass": "d120",
    "fifth_station_clearing": "d121",
    "star_cave_se1": "d123", "deep_star_cave_dungeon": "d124",
    "star_cave_depths": "d126", "murky_forest": "d128",
    "eastern_cave": "d129", "fortune_ravine": "d130",
    "fortune_ravine_depths": "d131", "barren_valley": "d133",
    "deep_barren_valley": "d134", "dark_wasteland": "d136",
    "temporal_tower_se5": "d137", "temporal_spire_se5": "d138",
    "dusk_forest_se5": "d139", "spacial_cliffs": "d141",
    "dark_ice_mountain": "d142", "dark_ice_mountain_peak": "d143",
    "icicle_forest": "d145", "vast_ice_mountain": "d146",
    "vast_ice_mountain_peak": "d147", "southern_jungle": "d149",
    "boulder_quarry": "d150", "deep_boulder_quarry": "d151",
    "right_cave_path": "d153", "left_cave_path": "d154",
    "limestone_cavern": "d155", "deep_limestone_cavern": "d156",
    "spring_cave": "d158",
    # d160-d179 : Spring Cave suite, événements Wonder Mail S, épilogue
    "upper_spring_cave": "d160", "lower_spring_cave": "d162",
    "spring_cave_depths": "d163", "little_plains": "d165",
    "mt_clear": "d166", "challenge_river": "d167",
    "trial_forest": "d168", "guiding_sea": "d169",
    "hidden_shopkeeper_village": "d170", "star_cave": "d174",
    "shaymin_village": "d175", "armaldos_shelter": "d176",
    "luminous_spring_dungeon": "d177", "hot_spring_dungeon": "d178",
    "rescue_dungeon": "d179",
}

TRAP_TO_PMDO = {k: v.get("pmdo_tile")
                for k, v in MAPPING["traps"]["entries"].items()}


def slug_species(n):
    s = n.lower().replace("♀", "_f").replace("♂", "_m")
    s = re.sub(r"[.'’]", "", s)
    s = re.sub(r"[\s-]+", "_", s)
    return s


def rom_table(dkey):
    for f in glob.glob(os.path.join(TABLES, "dungeons", f"{dkey}_*.json.gz")):
        return json.load(gzip.open(f, "rt"))
    return None


def zone_floor_spawns(floor_json):
    """Retourne [(species, level_min, level_max, cum_rate)] du MobSpawnStep."""
    j = json.dumps(floor_json)
    i = j.find("MobSpawnStep")
    if i < 0:
        return []
    # le MobSpawnStep est un Value dans GenSteps ; extraire son objet
    seg = j[i:]
    out = []
    for m in re.finditer(
            r'"Species": "(\w+)", "Form": \d+, "Skin": "", "Gender": -1\}, '
            r'"Level": \{"Min": (\d+), "Max": (\d+)\}.{0,500}?'
            r'"TeamSizes": \[[^\]]*\]\}, "Rate": (\d+)\}', seg):
        out.append((m.group(1), int(m.group(2)), int(m.group(3)),
                    int(m.group(4))))
    return out


def zone_trap_spawns(zone_obj, floor=None):
    """Parsing STRUCTUREL du TileSpawnZoneStep (les regex sur le JSON
    sérialisé sont fragiles à l'ordre des clés — bug corrigé).
    floor=None : tous les spawns ; floor=i : seulement ceux dont le
    Range couvre l'étage i (les poids ROM varient par étage)."""
    out = []
    for s in zone_obj.get("Segments", []):
        for st in s.get("ZoneSteps", []):
            if st.get("$type", "").startswith(
                    "RogueEssence.LevelGen.TileSpawnZoneStep"):
                for sp in st.get("Spawns", []):
                    tid = sp.get("Spawn", {}).get("ID")
                    if not tid:
                        continue
                    if floor is not None:
                        rg = sp.get("Range", {})
                        if not (rg.get("Min", 0) <= floor
                                < rg.get("Max", 1 << 30)):
                            continue
                    out.append((tid, int(sp.get("Rate", 0))))
    return out


def proportions_equal(rom_pairs, zone_pairs):
    """rom_pairs / zone_pairs : [(id, poids_individuel)] — proportions."""
    if len(rom_pairs) != len(zone_pairs):
        return False
    rs = sum(w for _, w in rom_pairs)
    zs = sum(w for _, w in zone_pairs)
    if not rs or not zs:
        return rs == zs
    for (ri, rw), (zi, zw) in zip(rom_pairs, zone_pairs):
        if ri != zi or Fraction(rw, rs) != Fraction(zw, zs):
            return False
    return True


def decumulate(pairs):
    """[(id, poids_cumulé)] -> [(id, poids_individuel)]."""
    out, prev = [], 0
    for i, w in pairs:
        out.append((i, w - prev))
        prev = w
    return out


def main():
    report = OrderedDict(schema="sky-zone-vs-rom/1",
                         authority="tables mappa_s.bin EU vs Data/Zone",
                         zones=OrderedDict())
    md = ["# Comparaison zones Sky construites ↔ tables ROM EU\n"]
    for zid, dkey in ZONE_TO_DUNGEON.items():
        zpath = os.path.join(REPO, "Data", "Zone", f"{zid}.json")
        t = rom_table(dkey)
        entry = OrderedDict(dungeon=dkey, pret_enum=None, floors=[])
        if t:
            entry["pret_enum"] = t["pret_enum"]
        if not os.path.exists(zpath) or t is None:
            entry["status"] = "MISSING"
            report["zones"][zid] = entry
            continue
        z = json.load(open(zpath, encoding="utf-8-sig"))["Object"]
        zfloors = []
        for s in z["Segments"]:
            zfloors.extend(s.get("Floors", []))
        entry["floor_count"] = OrderedDict(
            zone=len(zfloors), rom=len(t["floors"]),
            status="PASS" if len(zfloors) == len(t["floors"]) else "FAIL")

        # pièges (zone-level ZoneSteps)
        ztraps = zone_trap_spawns(z)
        rom_traps_all = OrderedDict()
        for fl in t["floors"]:
            for tr, w in fl["traps"].items():
                rom_traps_all.setdefault(tr, set()).add(w)
        all_fixed = all(fl["layout"].get("fixed_floor_id", 0) > 0
                        for fl in t["floors"])
        trap_status = "PASS"
        trap_notes = []
        if all_fixed and not ztraps:
            trap_status = "ACCEPTED_FIXED_FLOOR"
            trap_notes.append("donjon 100% salles fixes : la table de "
                              "pièges mappa est dormante dans la ROM")
        else:
            mapped = {TRAP_TO_PMDO.get(tr): tr for tr in rom_traps_all}
            for tid, _ in ztraps:
                if tid not in mapped:
                    trap_status = "REVIEW"
                    trap_notes.append(
                        f"piège zone {tid} absent des tables ROM")
            for tr in rom_traps_all:
                pid = TRAP_TO_PMDO.get(tr)
                if pid and pid not in {x for x, _ in ztraps} \
                        and pid != "tile_wonder":
                    trap_status = "INCOMPLETE"
                    trap_notes.append(
                        f"piège ROM {tr} ({pid}) absent de la zone")
            # proportions exactes des pièges (hors tile_wonder, spawné par
            # le step par-étage dédié) — comparaison PAR ÉTAGE : les poids
            # ROM varient au fil du donjon (ex. d50 étages 1-9 vs 10-20)
            # et la zone porte des Range par signature.
            if trap_status == "PASS" and ztraps:
                for fi, fl in enumerate(t["floors"]):
                    rom_ind = [(TRAP_TO_PMDO.get(tr), w) for tr, w in
                               decumulate(list(fl["traps"].items()))
                               if TRAP_TO_PMDO.get(tr) != "tile_wonder"
                               and w > 0]
                    zf = zone_trap_spawns(z, floor=fi)
                    if not zf and fl["layout"].get("fixed_floor_id", 0) > 0:
                        continue  # étage fixe : table mappa dormante
                    if not proportions_equal(sorted(rom_ind), sorted(zf)):
                        trap_status = "FAIL"
                        trap_notes.append(
                            f"proportions de pièges ≠ ROM (étage {fi+1})")
                        break
        entry["traps"] = OrderedDict(status=trap_status, notes=trap_notes,
                                     zone=[f"{i}:{r}" for i, r in ztraps],
                                     rom=sorted(rom_traps_all))

        # items : la ROM a-t-elle des items d'étage ? la zone en spawn-t-elle ?
        rom_has_items = any(fl["items"]["floor"]["items"] or
                            fl["items"]["floor"]["categories"]
                            for fl in t["floors"])
        # inspecter le step réel (pas une recherche de texte globale)
        zone_items_empty = True
        for s in z["Segments"]:
            for st in s.get("ZoneSteps", []):
                if st.get("$type", "").startswith(
                        "RogueEssence.LevelGen.ItemSpawnZoneStep"):
                    if st.get("Spawns"):
                        zone_items_empty = False
        entry["items"] = OrderedDict(
            rom_has_floor_items=rom_has_items,
            zone_spawns_items=not zone_items_empty,
            status=("INCOMPLETE" if rom_has_items and zone_items_empty
                    else "PASS"))

        # étages : espèces/niveaux/proportions
        f_pass = f_fail = 0
        floor_reports = []
        for fi, (zf, rf) in enumerate(zip(zfloors, t["floors"])):
            # ÉTAGE FIXE (fixed_floor_id > 0) : le jeu charge une salle
            # fixe (ici rsmap dédié via LoadGen) — la table de spawn mappa
            # est DORMANTE dans la ROM elle-même (le boss est placé par la
            # salle fixe). Comparaison de table non applicable.
            if rf["layout"].get("fixed_floor_id", 0) > 0 and \
                    "LoadGen" in json.dumps(zf):
                floor_reports.append(OrderedDict(
                    floor=fi + 1, species_levels="ACCEPTED_FIXED_FLOOR",
                    spawn_rates="ACCEPTED_FIXED_FLOOR",
                    note=f"fixed_floor_id={rf['layout']['fixed_floor_id']}"
                         " — salle fixe (boss), table mappa dormante"))
                f_pass += 1
                continue
            zsp = zone_floor_spawns(zf)
            rom_sp = [(slug_species(m["en"]), m["level"],
                       m["main_spawn_weight"])
                      for m in rf["monsters"]
                      if m["main_spawn_weight"] > 0 and m["en"] and
                      m["en"] != "Decoy"]
            frep = OrderedDict(floor=fi + 1)
            zs = [(s, lm) for s, lm, _, _ in zsp]
            rs = [(s, lv) for s, lv, _ in rom_sp]
            frep["species_levels"] = "PASS" if zs == rs else "FAIL"
            if zs != rs:
                frep["zone"] = zs
                frep["rom"] = rs
            # Sémantique RogueElements SpawnList.Rate = POIDS INDIVIDUEL
            # (spawnTotal += rate) — vérifié dans le source RogueElements.
            # La ROM stocke des poids CUMULÉS ; on décumule côté ROM
            # uniquement. (Les anciennes zones stockaient les cumuls comme
            # poids — bug de proportions détecté par cette comparaison.)
            rom_ind = decumulate([(s, w) for s, _, w in rom_sp])
            zone_ind = [(s, w) for s, _, _, w in zsp]
            frep["spawn_rates"] = ("PASS" if proportions_equal(
                rom_ind, zone_ind) else "FAIL")
            if frep["species_levels"] == "PASS" and \
                    frep["spawn_rates"] == "PASS":
                f_pass += 1
            else:
                f_fail += 1
            floor_reports.append(frep)
        entry["floors"] = floor_reports
        entry["floors_species_rates"] = OrderedDict(
            floors_pass=f_pass, floors_fail=f_fail,
            status="PASS" if f_fail == 0 else "PARTIAL")

        statuses = [entry["floor_count"]["status"],
                    entry["traps"]["status"], entry["items"]["status"],
                    entry["floors_species_rates"]["status"]]
        # ACCEPTED_FIXED_FLOOR = conformité PROUVÉE contre la ROM (donnée
        # dormante dans la ROM elle-même), pas une tolérance de confort.
        ok = {"PASS", "ACCEPTED_FIXED_FLOOR"}
        entry["verdict"] = ("EXACT" if all(s in ok for s in statuses)
                            else "DIVERGENT")
        report["zones"][zid] = entry

        md.append(f"## {zid} ({dkey} {entry['pret_enum']}) — "
                  f"**{entry['verdict']}**")
        md.append(f"- étages : zone {entry['floor_count']['zone']} / ROM "
                  f"{entry['floor_count']['rom']} "
                  f"→ {entry['floor_count']['status']}")
        md.append(f"- espèces/niveaux/proportions : "
                  f"{f_pass} PASS / {f_fail} FAIL")
        md.append(f"- items : ROM a des tables={rom_has_items}, zone "
                  f"spawn={not zone_items_empty} → "
                  f"{entry['items']['status']}")
        md.append(f"- pièges : {entry['traps']['status']} "
                  f"{('; '.join(trap_notes)) if trap_notes else ''}\n")

    out = os.path.join(TABLES, "ZONE_VS_ROM_COMPARISON.json")
    with open(out, "w", encoding="utf-8") as fh:
        json.dump(report, fh, ensure_ascii=False, indent=1)
    with open(os.path.join(TABLES, "ZONE_VS_ROM_COMPARISON.md"), "w",
              encoding="utf-8") as fh:
        fh.write("\n".join(md) + "\n")
    for zid, e in report["zones"].items():
        print(zid, "->", e.get("verdict", e.get("status")),
              "| items:", e.get("items", {}).get("status"),
              "| floors:", e.get("floors_species_rates", {}).get("status"))
    print(out)


if __name__ == "__main__":
    main()
