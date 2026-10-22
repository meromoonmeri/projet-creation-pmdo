#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
sky_extract_dungeon_tables.py — Tables canoniques des donjons de PMD
Explorers of Sky EU (§13 du prompt maître : lire les tables réelles,
comprendre leur signification, ne rien réécrire).

Sources (toutes dans la ROM EU vérifiée sha256 1fa39d35…) :
  - BALANCE/mappa_s.bin      : 100 listes d'étages (layouts, spawns Pokémon,
                               items sol/boutique/maison des monstres/enfouis,
                               pièges, densités, météo, terrain, shops…)
  - arm9 HardcodedDungeons   : table des 180 donjons (mappa_index,
                               start_after, number_floors) — c'est la clé
                               donjon→liste d'étages, lue par skytemple.
  - MESSAGE/text_e.str (+ _f) : noms canoniques EN/FR (donjons bloc
                               "Dungeon Names (Main)", Pokémon, items).
  - pret/pmd-sky enum dungeon_id (déjà utilisé par le manifest) pour
    l'énumération technique.

AUCUNE valeur modifiée : densités, poids de spawn (sur 10000), chances,
IDs de tileset/fixed floor/musique sont copiés tels quels.

Sortie :
  dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables/dungeons/d##_<enum>.json (par donjon)
  dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables/DUNGEON_TABLES_INDEX.json
"""
import gzip
import json
import os
from collections import OrderedDict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ROM = os.path.join(REPO, ".runtime-cache", "sky-rom",
                   "Pokemon Mystery Dungeon - Explorers of Sky (Europe) "
                   "(En,Fr,De,Es,It).nds")
OUT = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS", "Tables")
ROM_SHA256 = "1fa39d35873b58e02f3623438414c334ad93b840651a8a9ac13ee3c789f170c1"

# pret enum dungeon_id (table déjà validée par le manifest Sky)
DUNGEON_NAMES_JSON = "/tmp/sky_dungeon_names.json"

TRAP_NAMES = [
    "UNUSED", "MUD_TRAP", "STICKY_TRAP", "GRIMY_TRAP", "SUMMON_TRAP",
    "PITFALL_TRAP", "WARP_TRAP", "GUST_TRAP", "SPIN_TRAP", "SLUMBER_TRAP",
    "SLOW_TRAP", "SEAL_TRAP", "POISON_TRAP", "SELFDESTRUCT_TRAP",
    "EXPLOSION_TRAP", "PP_ZERO_TRAP", "CHESTNUT_TRAP", "WONDER_TILE",
    "POKEMON_TRAP", "SPIKED_TILE", "STEALTH_ROCK", "TOXIC_SPIKES",
    "TRIP_TRAP", "RANDOM_TRAP", "GRUDGE_TRAP",
]  # ordre MappaTrapType (skytemple-files)

STRUCTURES = ["MEDIUM_LARGE", "SMALL", "SINGLE_MONSTER_HOUSE", "RING",
              "CROSSROADS", "TWO_ROOMS_ONE_MH", "LINE", "CROSS",
              "SMALL_MEDIUM", "BETTLE", "OUTER_ROOMS", "MEDIUM",
              "MEDIUM_LARGE_12", "MEDIUM_LARGE_13", "MEDIUM_LARGE_14",
              "MEDIUM_LARGE_15"]  # MappaFloorStructureType

WEATHERS = ["CLEAR", "SUNNY", "SANDSTORM", "CLOUDY", "RAINY", "HAIL",
            "FOG", "SNOW", "RANDOM"]

ITEM_CATEGORIES = {0: "THROWN_PIERCE", 1: "THROWN_ROCK", 2: "BERRIES_SEEDS_VITAMINS",
                   3: "FOODS_GUMMIES", 4: "HOLD", 5: "TMS", 6: "MONEY",
                   7: "UNK7", 8: "OTHER", 9: "ORBS", 10: "LINK_BOX",
                   0xF: "UNKF"}


def main():
    from ndspy.rom import NintendoDSRom
    from skytemple_files.common.util import get_ppmdu_config_for_rom
    from skytemple_files.common.types.file_types import FileType
    from skytemple_files.hardcoded.dungeons import HardcodedDungeons
    import hashlib

    h = hashlib.sha256(open(ROM, "rb").read()).hexdigest()
    assert h == ROM_SHA256, h
    rom = NintendoDSRom.fromFile(ROM)
    config = get_ppmdu_config_for_rom(rom)
    mappa = FileType.MAPPA_BIN.deserialize(
        rom.getFileByName("BALANCE/mappa_s.bin"))
    dlist = HardcodedDungeons.get_dungeon_list(rom.arm9, config)

    str_e = FileType.STR.deserialize(rom.getFileByName("MESSAGE/text_e.str"))
    str_f = FileType.STR.deserialize(rom.getFileByName("MESSAGE/text_f.str"))
    sb = config.string_index_data.string_blocks

    def block(name, table):
        b = sb[name]
        return table.strings[b.begin:b.end]

    poke_en = block("Pokemon Names", str_e)
    poke_fr = block("Pokemon Names", str_f)
    item_en = block("Item Names", str_e)
    item_fr = block("Item Names", str_f)
    dun_en = block("Dungeon Names (Main)", str_e)
    dun_fr = block("Dungeon Names (Main)", str_f)

    pret = json.load(open(DUNGEON_NAMES_JSON)) \
        if os.path.exists(DUNGEON_NAMES_JSON) else {}

    def poke(md_index):
        i = md_index % 600
        return OrderedDict(md_index=md_index,
                           en=poke_en[i] if i < len(poke_en) else None,
                           fr=poke_fr[i] if i < len(poke_fr) else None)

    def item(iid):
        return OrderedDict(item_id=iid,
                           en=item_en[iid] if iid < len(item_en) else None,
                           fr=item_fr[iid] if iid < len(item_fr) else None)

    def item_list(il):
        return OrderedDict(
            categories=OrderedDict(
                (ITEM_CATEGORIES.get(int(k), f"cat_{int(k)}"), v)
                for k, v in sorted(il.categories.items(),
                                   key=lambda kv: int(kv[0]))),
            items=[OrderedDict(**item(int(iid)), weight=w)
                   for iid, w in sorted(il.items.items(),
                                        key=lambda kv: int(kv[0]))])

    os.makedirs(os.path.join(OUT, "dungeons"), exist_ok=True)
    index = OrderedDict(schema="sky-dungeon-tables/1",
                        source_rom_sha256=ROM_SHA256,
                        authority="BALANCE/mappa_s.bin + arm9 "
                                  "HardcodedDungeons + MESSAGE/text_e|f.str "
                                  "(EU) ; valeurs brutes non modifiées "
                                  "(poids sur 10000)",
                        dungeons=OrderedDict())
    n_floors_total = 0
    for did, d in enumerate(dlist):
        key = f"d{did:02d}"
        enum = (pret.get(key) or {}).get("enum") if pret else None
        name_en = dun_en[did] if did < len(dun_en) else None
        name_fr = dun_fr[did] if did < len(dun_fr) else None
        fl = mappa.floor_lists[d.mappa_index] \
            if d.mappa_index < len(mappa.floor_lists) else []
        floors = fl[d.start_after:d.start_after + d.number_floors]
        entry = OrderedDict(
            dungeon_id=did, pret_enum=enum,
            name_en=name_en, name_fr=name_fr,
            mappa_index=d.mappa_index, start_after=d.start_after,
            number_floors=d.number_floors,
            number_floors_in_group=d.number_floors_in_group,
            floors=[])
        for fi, f in enumerate(floors):
            l = f.layout
            fd = OrderedDict(
                floor=fi + 1,
                layout=OrderedDict(
                    structure=STRUCTURES[l.structure]
                    if l.structure < len(STRUCTURES) else l.structure,
                    tileset_id=l.tileset_id, music_id=l.music_id,
                    weather=WEATHERS[l.weather]
                    if l.weather < len(WEATHERS) else l.weather,
                    floor_connectivity=l.floor_connectivity,
                    room_density=l.room_density,
                    initial_enemy_density=l.initial_enemy_density,
                    item_density=l.item_density,
                    trap_density=l.trap_density,
                    buried_item_density=l.buried_item_density,
                    water_density=l.water_density,
                    extra_hallway_density=l.extra_hallway_density,
                    dead_ends=bool(l.dead_ends),
                    darkness_level=l.darkness_level,
                    monster_house_chance=l.monster_house_chance,
                    empty_monster_house_chance=l.empty_monster_house_chance,
                    kecleon_shop_chance=l.kecleon_shop_chance,
                    kecleon_shop_item_positions=l.kecleon_shop_item_positions,
                    hidden_stairs_spawn_chance=l.hidden_stairs_spawn_chance,
                    sticky_item_chance=l.sticky_item_chance,
                    max_coin_amount=l.max_coin_amount,
                    fixed_floor_id=l.fixed_floor_id,
                    enemy_iq=l.enemy_iq,
                    iq_booster_boost=l.iq_booster_boost,
                    secondary_terrain=l.secondary_terrain,
                    terrain_settings=OrderedDict(
                        has_secondary_terrain=bool(
                            l.terrain_settings.has_secondary_terrain),
                        generate_imperfect_rooms=bool(
                            l.terrain_settings.generate_imperfect_rooms)),
                    unusued_chance=l.unused_chance,
                ),
                monsters=[OrderedDict(
                    **poke(m.md_index), level=m.level,
                    main_spawn_weight=m.main_spawn_weight,
                    monster_house_spawn_weight=m.monster_house_spawn_weight)
                    for m in f.monsters],
                traps=OrderedDict(
                    (TRAP_NAMES[int(t)] if int(t) < len(TRAP_NAMES)
                     else f"trap_{int(t)}", w)
                    for t, w in sorted(f.traps.weights.items(),
                                       key=lambda kv: int(kv[0])) if w),
                items=OrderedDict(
                    floor=item_list(f.floor_items),
                    shop=item_list(f.shop_items),
                    monster_house=item_list(f.monster_house_items),
                    buried=item_list(f.buried_items),
                    unk1=item_list(f.unk_items1),
                    unk2=item_list(f.unk_items2),
                ),
            )
            entry["floors"].append(fd)
        n_floors_total += len(entry["floors"])
        fname = f"{key}_{(enum or 'UNKNOWN').lower()}.json.gz"
        with gzip.open(os.path.join(OUT, "dungeons", fname), "wt",
                       encoding="utf-8") as fh:
            json.dump(entry, fh, ensure_ascii=False, indent=1)
        status = ("PASS" if len(entry["floors"]) == d.number_floors
                  else "PARTIAL")
        note = None
        if status == "PARTIAL":
            # Bizarrerie CANONIQUE de la ROM : la table arm9 pointe hors de
            # la liste mappa (slice vide). Vérifié : d71 (start_after=30
            # dans une liste de 30) et d173 ([M:D1]Dummy). Rien à inventer.
            note = (f"la table arm9 déclare {d.number_floors} étage(s) à "
                    f"partir de l'index {d.start_after} d'une liste mappa "
                    f"de {len(fl)} étage(s) — slice vide DANS LA ROM "
                    f"elle-même (donnée dormante/dummy du jeu)")
        index["dungeons"][key] = OrderedDict(
            file=f"dungeons/{fname}", pret_enum=enum, name_en=name_en,
            name_fr=name_fr, floors=len(entry["floors"]),
            declared_floors=d.number_floors,
            status=status, **({"note": note} if note else {}))
    index["totals"] = OrderedDict(
        dungeons=len(dlist), floors_extracted=n_floors_total,
        floors_pass=sum(1 for v in index["dungeons"].values()
                        if v["status"] == "PASS"))
    with open(os.path.join(OUT, "DUNGEON_TABLES_INDEX.json"), "w",
              encoding="utf-8") as fh:
        json.dump(index, fh, ensure_ascii=False, indent=1)
    print("dungeons:", len(dlist), "floors:", n_floors_total,
          "PASS:", index["totals"]["floors_pass"])


if __name__ == "__main__":
    main()
