#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
sky_build_pmdo_mapping.py — Mapping canonique Sky → PMDO (§2 de la mission :
correspondance explicite source → cible, statuts stricts, zéro invention).

Entrées :
  - dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables/dungeons/*.json.gz
    (tables ROM EU extraites par sky_extract_dungeon_tables.py — autorité)
  - /tmp/pmdo_species.txt        : espèces PMDO (DumpAsset Data/Monster,
    liste régénérable : gh api git/trees — 1011 slugs)
  - dev/tools/dungeon_builder/data/base_item_catalog.json : catalogue items
    PMDO du Dungeon Builder EXISTANT (2452 entrées, id + nom humain)
  - /tmp/pmdo_tiles.txt          : tuiles/pièges PMDO (DumpAsset Data/Tile)

Trois familles, chacune avec des statuts stricts :
  EXACT          — même identité, correspondance mécanique
  RENAMED        — équivalence 1:1 documentée (PMDO renomme des items
                   Sky : Def. Scarf→Defense Scarf, X-Eye Seed→Blinker Seed…)
                   TOUJOURS avec la justification dans `evidence`
  MONEY/SPECIAL  — géré par un AUTRE système PMDO (Poké → MoneySpawnZoneStep,
                   Decoy → mob spécial de fixed floor)
  UNMAPPED       — REVIEW_REQUIRED, jamais silencieusement ignoré

Sortie : dev/CAMPAIGNS/PMD_SKY_EXPLORERS/Tables/PMDO_MAPPING.json
"""
import glob
import gzip
import json
import os
import re
from collections import OrderedDict

REPO = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
TABLES = os.path.join(REPO, "dev", "CAMPAIGNS", "PMD_SKY_EXPLORERS", "Tables")
CATALOG = os.path.join(REPO, "dev", "tools", "dungeon_builder", "data",
                       "base_item_catalog.json")
OUT = os.path.join(TABLES, "PMDO_MAPPING.json")

# ---------------------------------------------------------------------------
# Équivalences items Sky → PMDO documentées.
# PMDO (PMDC) reprend l'inventaire d'Explorers en renommant certains items ;
# chaque entrée cite la nature de l'équivalence. AUCUNE invention : si le
# doute existe, l'item reste UNMAPPED.
# ---------------------------------------------------------------------------
ITEM_RENAMES = {
    # nom EU Sky -> (id PMDO, justification VÉRIFIÉE dans le catalogue).
    # Seules les identités certaines (orthographe/espacement/renommage PMDO
    # attesté). Tout le reste devient SKY_ONLY, jamais un mapping de confort.
    "Def. Scarf": ("held_defense_scarf",
                   "abréviation d'affichage Sky de Defense Scarf"),
    "Gaggle Specs": ("held_goggle_specs",
                     "nom EU de Goggle Specs (même item, variation "
                     "régionale du texte EU)"),
    "Deepseascale": ("evo_deep_sea_scale",
                     "espacement: Deepseascale = Deep Sea Scale"),
    "Deepseatooth": ("evo_deep_sea_tooth",
                     "espacement: Deepseatooth = Deep Sea Tooth"),
    "Thunderstone": ("evo_thunder_stone",
                     "espacement: Thunderstone = Thunder Stone"),
    "Upgrade": ("evo_up_grade", "graphie: Upgrade = Up-Grade"),
    "X-Eye Seed": ("seed_blinker",
                   "renommage PMDO attesté: le X-Eye Seed d'Explorers "
                   "(vision brouillée) est le Blinker Seed de PMDO/PMDC"),
}

# Items Sky ABSENTS du roster PMDO de base (PMDC a redessiné l'inventaire).
# candidate = équivalent fonctionnel POSSIBLE, jamais appliqué d'office ;
# la fidélité canonique exigerait de définir ces items dans le mod
# (REQUIRES_MOD_ITEM) plutôt que de substituer silencieusement.
SKY_ONLY_CANDIDATES = {
    "Oren Berry": "aucun (baie piège -HP propre à Explorers)",
    "Heal Seed": "berry_lum (guérit les statuts dans PMDO)",
    "Life Seed": "boost_hp_up (montée de PV max)",
    "Quick Seed": "aucun exact (X Speed medicine_x_speed est temporaire)",
    "Stun Seed": "seed_ban/orb paralysie (effets voisins, non identiques)",
    "Totter Seed": "orb_totter / wand_totter (même effet, autre forme)",
    "Slip Seed": "aucun (marche sur l'eau propre à Explorers)",
    "Via Seed": "seed_pure (téléportation vers escaliers ≈ Pure Seed)",
    "Dough Seed": "aucun (génère de l'argent au sol)",
    "Violent Seed": "seed_last_chance? NON vérifié — laisser en mod item",
    "Reviser Seed": "seed_reviver (Reviser = faux Reviver, item piège "
                    "DISTINCT: ne pas fusionner)",
    "Dropeye Seed": "aucun (malus vision propre à Explorers)",
    "Eyedrop Seed": "aucun (bonus vision objets)",
    "Ginseng": "aucun (boost de puissance d'attaque permanent)",
    "Mix Elixir": "medicine_elixir (restaure PP, mais Mix = tous alliés)",
    "Link Box": "machine_link_box absent; PMDO gère les capacités liées "
                "autrement (menu skills)",
    "Gravelyrock": "food_gravelyrock absent (nourriture Bonsly/Sudowoodo)",
    "Wander Gummi": "aucun (gummi générique d'Explorers)",
    "Bounce Band": "aucun", "Curve Band": "aucun", "Detect Band": "aucun",
    "Patsy Band": "aucun", "Racket Band": "aucun", "Stamina Band": "aucun",
    "Weather Band": "held_weather_rock? rôle différent — mod item",
    "Persim Band": "berry_persim (même rôle anti-confusion, autre forme)",
    "Munch Belt": "aucun", "Tight Belt": "held_binding_band? NON vérifié",
    "Pecha Scarf": "berry_pecha (même rôle anti-poison, autre forme)",
    "Sneak Scarf": "aucun", "Dodge Scarf": "aucun",
    "Insomniscope": "aucun (anti-sommeil porté)",
    "Lockon Specs": "held_scope_lens? rôle précision — NON identique",
    "Whiff Specs": "aucun (malus lancer)",
    "Y-Ray Specs": "aucun (item Sky distinct de X-Ray Specs)",
    "No-Aim Scope": "aucun (malus visée, item farce)",
    "No-Slip Cap": "aucun (anti Slip/gluant)",
    "No-Stick Cap": "aucun (anti Sticky)",
    "Diet Ribbon": "aucun (anti-faim négatif)",
    "Gold Ribbon": "aucun (objet de valeur à revendre)",
    "Joy Ribbon": "held_heal_ribbon? rôle différent (EXP vs soin) — mod",
    "Plain Ribbon": "aucun (ruban sans effet)",
    "Frozen Rock": "evo_ice_stone (évolution glace PMDO) — substitution "
                   "d'évolution possible mais item distinct",
    "Mossy Rock": "evo_leaf_stone (idem)",
    "Coronet Rock": "aucun (évolution Mt Coronet)",
    "Gone Pebble": "aucun (Défilé Brumeux)",
    "Lost Loot": "aucun (trésor de valeur)",
    "Sky Gift": "aucun (cadeau Cime Céleste)",
}


def slug_species(n):
    s = n.lower().replace("♀", "_f").replace("♂", "_m")
    s = re.sub(r"[.'’]", "", s)
    s = re.sub(r"[\s-]+", "_", s)
    return s


TRAP_MAP = {
    # MappaTrapType (ROM) -> tuile PMDO DumpAsset (identités visibles 1:1)
    "MUD_TRAP": "trap_mud", "STICKY_TRAP": "trap_sticky",
    "GRIMY_TRAP": "trap_grimy", "SUMMON_TRAP": "trap_summon",
    "PITFALL_TRAP": "trap_pitfall", "WARP_TRAP": "trap_warp",
    "GUST_TRAP": "trap_gust", "SPIN_TRAP": "trap_spin",
    "SLUMBER_TRAP": "trap_slumber", "SLOW_TRAP": "trap_slow",
    "SEAL_TRAP": "trap_seal", "POISON_TRAP": "trap_poison",
    "SELFDESTRUCT_TRAP": "trap_self_destruct",
    "EXPLOSION_TRAP": "trap_explosion", "PP_ZERO_TRAP": "trap_pp_leech",
    "CHESTNUT_TRAP": "trap_chestnut", "WONDER_TILE": "tile_wonder",
    "POKEMON_TRAP": "trap_pokemon", "SPIKED_TILE": "trap_spikes",
    "STEALTH_ROCK": "trap_stealth_rock",
    "TOXIC_SPIKES": "trap_toxic_spikes", "TRIP_TRAP": "trap_trip",
    "RANDOM_TRAP": "trap_trigger", "GRUDGE_TRAP": "trap_grudge",
}


def main():
    species_pmdo = set(open("/tmp/pmdo_species.txt").read().split())
    tiles_pmdo = set(open("/tmp/pmdo_tiles.txt").read().split())
    cat = json.load(open(CATALOG))["entries"]
    item_ids = {it["id"] for it in cat}
    item_by_name = {}
    for it in cat:
        item_by_name.setdefault(it["name"].lower(), it["id"])

    # inventaire complet depuis les tables ROM
    rom_species, rom_items, rom_traps = {}, {}, {}
    for f in sorted(glob.glob(os.path.join(TABLES, "dungeons",
                                           "*.json.gz"))):
        d = json.load(gzip.open(f, "rt"))
        for fl in d["floors"]:
            for m in fl["monsters"]:
                if m["en"]:
                    rom_species.setdefault(
                        m["en"], OrderedDict(md_indexes=set(), uses=0))
                    rom_species[m["en"]]["md_indexes"].add(m["md_index"])
                    rom_species[m["en"]]["uses"] += 1
            for t in fl["traps"]:
                rom_traps[t] = rom_traps.get(t, 0) + 1
            for il in fl["items"].values():
                for it in il["items"]:
                    if it["en"]:
                        rom_items.setdefault(
                            it["en"], OrderedDict(item_id=it["item_id"],
                                                  uses=0))
                        rom_items[it["en"]]["uses"] += 1

    # --- espèces
    sp_map = OrderedDict()
    sp_counts = {"EXACT": 0, "SPECIAL": 0, "UNMAPPED": 0}
    for en in sorted(rom_species):
        s = slug_species(en)
        info = rom_species[en]
        entry = OrderedDict(
            md_indexes=sorted(info["md_indexes"]), uses=info["uses"])
        if en == "Decoy":
            entry["status"] = "SPECIAL"
            entry["note"] = ("entité leurre du moteur Sky (md 0x229), pas "
                             "une espèce — équivalent PMDO: objet "
                             "seed_decoy / mécanique de leurre")
            sp_counts["SPECIAL"] += 1
        elif s in species_pmdo:
            entry["status"] = "EXACT"
            entry["pmdo_species"] = s
            sp_counts["EXACT"] += 1
        else:
            entry["status"] = "UNMAPPED"
            sp_counts["UNMAPPED"] += 1
        sp_map[en] = entry

    # --- items
    it_map = OrderedDict()
    it_counts = {"EXACT": 0, "RENAMED": 0, "TM": 0, "MONEY": 0,
                 "REQUIRES_MOD_ITEM": 0, "UNMAPPED": 0}
    for en in sorted(rom_items):
        entry = OrderedDict(sky_item_id=rom_items[en]["item_id"],
                            uses=rom_items[en]["uses"])
        if en == "Poké":
            entry["status"] = "MONEY"
            entry["pmdo_system"] = ("MoneySpawnZoneStep + CoinModGenState "
                                    "(déjà utilisé par les zones du dépôt)")
            it_counts["MONEY"] += 1
        elif en.startswith("[M:I0]"):
            # marqueur icône TM/HM du texte ROM
            move = en[6:]
            tm = "tm_" + re.sub(r"[\s-]+", "_",
                                re.sub(r"[.'’]", "", move.lower()))
            if tm in item_ids:
                entry["status"] = "TM"
                entry["pmdo_item"] = tm
                it_counts["TM"] += 1
            else:
                # graphies GBA/NDS: SolarBeam→Solar Beam, Vacuum-Cut…
                tm2 = "tm_" + re.sub(
                    r"[\s-]+", "_", re.sub(
                        r"[.'’]", "", re.sub(
                            r"(?<=[a-z])(?=[A-Z])", " ", move).lower()))
                if tm2 in item_ids:
                    entry["status"] = "TM"
                    entry["pmdo_item"] = tm2
                    entry["evidence"] = (f"graphie compacte NDS «{move}» = "
                                         f"{tm2}")
                    it_counts["TM"] += 1
                else:
                    entry["status"] = "REQUIRES_MOD_ITEM"
                    entry["note"] = (f"TM «{move}» absent du roster PMDO "
                                     f"(candidats {tm}/{tm2} inexistants) — "
                                     f"move d'Explorers non porté")
                    it_counts["REQUIRES_MOD_ITEM"] += 1
        elif en.startswith("[M:I1]"):
            # marqueur icône Orbe du texte ROM
            orb = en[6:]
            base = re.sub(r"\s*Orb$", "", orb)
            oid = "orb_" + re.sub(r"[\s-]+", "_",
                                  re.sub(r"[.'’]", "", base.lower()))
            if oid in item_ids:
                entry["status"] = "EXACT"
                entry["pmdo_item"] = oid
                entry["evidence"] = f"marqueur [M:I1] = icône orbe ; {orb}"
                it_counts["EXACT"] += 1
            elif orb.lower() in item_by_name:
                entry["status"] = "EXACT"
                entry["pmdo_item"] = item_by_name[orb.lower()]
                it_counts["EXACT"] += 1
            else:
                entry["status"] = "REQUIRES_MOD_ITEM"
                entry["note"] = (f"orbe «{orb}» absent du roster PMDO — "
                                 f"orbe d'Explorers non porté")
                it_counts["REQUIRES_MOD_ITEM"] += 1
        elif en.lower() in item_by_name:
            entry["status"] = "EXACT"
            entry["pmdo_item"] = item_by_name[en.lower()]
            it_counts["EXACT"] += 1
        elif en in ITEM_RENAMES:
            pid, why = ITEM_RENAMES[en]
            if pid in item_ids:
                entry["status"] = "RENAMED"
                entry["pmdo_item"] = pid
                entry["evidence"] = why
                it_counts["RENAMED"] += 1
            else:
                entry["status"] = "UNMAPPED"
                entry["note"] = f"rename candidat {pid} absent du catalogue"
                it_counts["UNMAPPED"] += 1
        elif en in SKY_ONLY_CANDIDATES:
            entry["status"] = "REQUIRES_MOD_ITEM"
            entry["note"] = ("item d'Explorers absent du roster PMDO de "
                             "base — à définir dans le mod pour la "
                             "fidélité canonique")
            entry["functional_candidate"] = SKY_ONLY_CANDIDATES[en]
            it_counts["REQUIRES_MOD_ITEM"] += 1
        else:
            entry["status"] = "UNMAPPED"
            it_counts["UNMAPPED"] += 1
        it_map[en] = entry

    # --- pièges
    tr_map = OrderedDict()
    tr_counts = {"EXACT": 0, "UNMAPPED": 0}
    for t in sorted(rom_traps):
        entry = OrderedDict(uses=rom_traps[t])
        pid = TRAP_MAP.get(t)
        if pid and pid in tiles_pmdo:
            entry["status"] = "EXACT"
            entry["pmdo_tile"] = pid
            tr_counts["EXACT"] += 1
        else:
            entry["status"] = "UNMAPPED"
            tr_counts["UNMAPPED"] += 1
        tr_map[t] = entry

    out = OrderedDict(
        schema="sky-pmdo-mapping/1",
        authority=OrderedDict(
            rom="tables mappa_s.bin EU (Tables/dungeons/*.json.gz)",
            pmdo_species="DumpAsset@9d864d14 Data/Monster (1011 slugs)",
            pmdo_items="dev/tools/dungeon_builder/data/"
                       "base_item_catalog.json (catalogue existant du "
                       "Dungeon Builder)",
            pmdo_tiles="DumpAsset@9d864d14 Data/Tile",
            rule="RENAMED exige une équivalence 1:1 documentée ; le doute "
                 "reste UNMAPPED (REVIEW_REQUIRED)"),
        species=OrderedDict(counts=sp_counts, entries=sp_map),
        items=OrderedDict(counts=it_counts, entries=it_map),
        traps=OrderedDict(counts=tr_counts, entries=tr_map),
    )
    with open(OUT, "w", encoding="utf-8") as fh:
        json.dump(out, fh, ensure_ascii=False, indent=1)
    print("species:", sp_counts)
    print("items:", it_counts)
    print("traps:", tr_counts)
    unm = [k for k, v in it_map.items() if v["status"] == "UNMAPPED"]
    print("items UNMAPPED:", unm[:40])
    unm_s = [k for k, v in sp_map.items() if v["status"] == "UNMAPPED"]
    print("species UNMAPPED:", unm_s)
    print(OUT)


if __name__ == "__main__":
    main()
