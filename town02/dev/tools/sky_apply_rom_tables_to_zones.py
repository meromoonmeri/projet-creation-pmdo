#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
sky_apply_rom_tables_to_zones.py — Correction chirurgicale des 6 zones Sky
du dépôt (D27-D32) pour aligner leurs tables sur la ROM EU exacte.

Écarts mesurés par sky_compare_zones_to_rom.py (jamais présumés) :
  1. RATES DE SPAWN : les PoolTeamSpawner utilisaient des poids cumulés
     arrondis /100 (23/31/54/77/100) au lieu des poids ROM exacts /10000
     (2286/3143/5429/7714/10000) → substituer les poids individuels exacts.
  2. ITEMS : ItemSpawnZoneStep vide alors que la ROM définit une table
     d'items par étage → injecter la table (catégorie floor) avec les
     poids individuels exacts, pour les items MAPPABLES (PMDO_MAPPING
     EXACT/RENAMED/TM). Les items REQUIRES_MOD_ITEM sont EXCLUS et
     DOCUMENTÉS (poids listés dans le rapport + Comment de zone) — les
     substituer serait une modification du canon.
  3. PIÈGES : TileSpawnZoneStep en poids /100 arrondis → poids ROM exacts
     décumulés (/10000).

Ne touche à rien d'autre : structure, musiques, niveaux, espèces,
darkness, monster houses, arènes, grounds restent intacts.

Sortie : Data/Zone/<zone>.json (in place) +
         dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables/ZONE_FIX_REPORT.json
"""
import glob
import gzip
import json
import os
import re
from collections import OrderedDict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TABLES = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS", "Tables")
MAPPING = json.load(open(os.path.join(TABLES, "PMDO_MAPPING.json")))
ITEM_ENTRIES = MAPPING["items"]["entries"]
TRAP_ENTRIES = MAPPING["traps"]["entries"]

ZONE_TO_DUNGEON = {
    "chasm_cave": "d27", "dark_hill": "d28", "sealed_ruin": "d29",
    "sealed_ruin_pit": "d30", "spiritomb_room": "d31", "dusk_forest": "d32",
}


def rom_table(dkey):
    for f in glob.glob(os.path.join(TABLES, "dungeons", f"{dkey}_*.json.gz")):
        return json.load(gzip.open(f, "rt"))
    return None


def decumulate(pairs):
    out, prev = [], 0
    for k, w in pairs:
        out.append((k, w - prev))
        prev = w
    return out


def fix_mob_rates(zone_obj, rom_floors, report):
    """Remplace les Rate des PoolTeamSpawner par les poids ROM individuels
    exacts (base 10000), par étage, en préservant l'ordre des espèces."""
    fixed = 0
    zfloors = []
    for s in zone_obj["Segments"]:
        zfloors.extend(s.get("Floors", []))
    for fi, (zf, rf) in enumerate(zip(zfloors, rom_floors)):
        rom_sp = [(m["en"], m["main_spawn_weight"]) for m in rf["monsters"]
                  if m["main_spawn_weight"] > 0 and m["en"]
                  and m["en"] != "Decoy"]
        rom_ind = decumulate(rom_sp)
        # trouver le MobSpawnStep de l'étage
        for step in zf.get("GenSteps", []):
            val = step.get("Value", {})
            if "MobSpawnStep" not in val.get("$type", ""):
                continue
            spawns = val.get("Spawns", [])
            pool = [sp for sp in spawns
                    if "PoolTeamSpawner" in sp.get("Spawn", {})
                    .get("$type", "")]
            if len(pool) != len(rom_ind):
                report.append({"floor": fi + 1, "status": "SKIPPED",
                               "reason": f"{len(pool)} spawners vs "
                                         f"{len(rom_ind)} entrées ROM"})
                continue
            # les Rate de PMDO SpawnList sont des poids relatifs ; l'ancien
            # export utilisait le cumul — réécrire en poids INDIVIDUELS
            # exacts (proportions strictement identiques à la ROM)
            for sp, (en, w) in zip(pool, rom_ind):
                sp["Rate"] = w
            fixed += 1
    return fixed


def build_item_spawns(rom_floors, zone_id):
    """CategorySpawn 'canonical_floor_items' (format des zones Red du
    dépôt) : items sol mappables, poids individuels exacts, par plage
    d'étages identiques."""
    # regrouper les étages par table identique
    sigs = OrderedDict()
    for fi, rf in enumerate(rom_floors):
        sig = json.dumps(rf["items"]["floor"], sort_keys=True)
        sigs.setdefault(sig, []).append(fi)
    excluded_total = OrderedDict()
    spawn_entries = []
    ranges = []
    for sig, fls in sigs.items():
        rf = rom_floors[fls[0]]
        pairs = [(it["en"], it["weight"], it["item_id"])
                 for it in rf["items"]["floor"]["items"] if it["en"]]
        ind = decumulate([(en, w) for en, w, _ in pairs])
        lo, hi = min(fls), max(fls) + 1
        for (en, w), (_, _, iid) in zip(ind, pairs):
            if w <= 0:
                continue
            ent = ITEM_ENTRIES.get(en, {})
            st = ent.get("status")
            if st in ("EXACT", "RENAMED", "TM"):
                spawn_entries.append(OrderedDict(
                    Spawn=OrderedDict(ID=ent["pmdo_item"], Cursed=False,
                                      HiddenValue="", Amount=0, Price=0),
                    Rate=w, Range=OrderedDict(Min=lo, Max=hi)))
            elif st == "MONEY":
                pass  # géré par MoneySpawnZoneStep déjà présent
            else:
                key = f"{en} (sky_id {iid})"
                excluded_total.setdefault(key, 0)
                excluded_total[key] += w
        ranges.append((lo, hi))
    lo_all = min(lo for lo, _ in ranges)
    hi_all = max(hi for _, hi in ranges)
    cat = OrderedDict()
    cat["Spawns"] = spawn_entries
    cat["SpawnRates"] = OrderedDict(nodes=[OrderedDict(
        Item=1, Range=OrderedDict(Min=lo_all, Max=hi_all))])
    return cat, excluded_total


def fix_items(zone_obj, rom_floors, zone_id, report):
    cat, excluded = build_item_spawns(rom_floors, zone_id)
    for s in zone_obj["Segments"]:
        for st in s.get("ZoneSteps", []):
            if "ItemSpawnZoneStep" in st.get("$type", ""):
                if st.get("Spawns"):
                    report.append({"item_step": "déjà rempli, non touché"})
                    return excluded
                st["Spawns"] = {"canonical_floor_items": cat}
                report.append({"item_step": "rempli",
                               "entries": len(cat["Spawns"]),
                               "excluded_requires_mod_item":
                               dict(excluded)})
                return excluded
    report.append({"item_step": "ABSENT — aucun ItemSpawnZoneStep"})
    return excluded


def fix_traps(zone_obj, rom_floors, report):
    """RECONSTRUIT la liste du TileSpawnZoneStep depuis la table ROM
    décumulée exacte : ajoute les pièges manquants (ex. trap_warp,
    trap_pokemon), retire les entrées hors-ROM (ex. trap_trigger jamais
    présent dans ces tables), réécrit tous les poids /10000.
    EXCEPTION documentée : tile_wonder (WONDER_TILE) est spawné par le
    step par-étage dédié de ce format de zone (PickerSpawner/LoopedRand
    2-4 par étage) — il est donc exclu de la liste zone pour ne pas
    doubler le spawn ; son poids ROM reste tracé dans le rapport."""
    rom_traps = [(k, w) for k, w in rom_floors[0]["traps"].items()]
    ind = decumulate(rom_traps)
    by_pmdo = OrderedDict()
    wonder_weight = None
    for tr, w in ind:
        if w <= 0:
            continue
        pid = TRAP_ENTRIES.get(tr, {}).get("pmdo_tile")
        if pid == "tile_wonder":
            wonder_weight = w
            continue
        if pid:
            by_pmdo[pid] = w
    for s in zone_obj["Segments"]:
        for st in s.get("ZoneSteps", []):
            if st.get("$type", "").startswith(
                    "RogueEssence.LevelGen.TileSpawnZoneStep"):
                old = st.get("Spawns", [])
                # gabarit de Range existant (plage d'étages du segment)
                rng = (old[0].get("Range") if old
                       else {"Min": 0, "Max": len(rom_floors)})
                removed = [sp["Spawn"]["ID"] for sp in old
                           if sp["Spawn"]["ID"] not in by_pmdo]
                st["Spawns"] = [OrderedDict(
                    Spawn=OrderedDict(TileLoc={"X": 0, "Y": 0}, ID=pid,
                                      Revealed=True, Owner=0,
                                      TileStates=[]),
                    Rate=w, Range=dict(rng)) for pid, w in by_pmdo.items()]
                report.append({
                    "trap_step": "reconstruit depuis table ROM",
                    "entries": len(by_pmdo),
                    "removed_non_rom": removed,
                    "wonder_tile_rom_weight": wonder_weight,
                    "wonder_tile_note": "spawné par le step par-étage "
                                        "dédié (2-4/étage), exclu ici "
                                        "pour éviter le double spawn"})
    return


def main():
    full_report = OrderedDict(schema="sky-zone-fix/1", zones=OrderedDict())
    for zid, dkey in ZONE_TO_DUNGEON.items():
        zpath = os.path.join(REPO, "Data", "Zone", f"{zid}.json")
        t = rom_table(dkey)
        raw = open(zpath, encoding="utf-8-sig").read()
        doc = json.loads(raw)
        z = doc["Object"]
        rep = []
        n_rates = fix_mob_rates(z, t["floors"], rep)
        excluded = fix_items(z, t["floors"], zid, rep)
        fix_traps(z, t["floors"], rep)
        # tracer la correction dans le commentaire de zone (traçabilité)
        note = (" [Tables realignées ROM EU mappa_s.bin exact "
                "(poids /10000) ; items REQUIRES_MOD_ITEM exclus et "
                "documentés dans ZONE_FIX_REPORT.json]")
        if note.strip() not in (z.get("Comment") or ""):
            z["Comment"] = (z.get("Comment") or "") + note
        with open(zpath, "w", encoding="utf-8-sig") as fh:
            json.dump(doc, fh, ensure_ascii=False, indent=2)
        full_report["zones"][zid] = OrderedDict(
            dungeon=dkey, floors_rates_fixed=n_rates, details=rep)
        print(f"{zid}: {n_rates} étages réalignés ; items exclus "
              f"(mod requis): {len(excluded)}")
    out = os.path.join(TABLES, "ZONE_FIX_REPORT.json")
    with open(out, "w", encoding="utf-8") as fh:
        json.dump(full_report, fh, ensure_ascii=False, indent=1)
    print(out)


if __name__ == "__main__":
    main()
