#!/usr/bin/env python3
"""Build the 51 canonical Ch.6–32 dungeon definitions (step 6 of the pipeline).

Canonical sources, in this order of authority:

1. `docs/ROSTER_IMPORT_DONJONS_PMD_RED_CH7_CH32.md` — the project's own roster of
   the 51 importable PMD Red story dungeons (floors, boss, converted asset,
   chapter, French name).  The list is never re-invented here: it is parsed.
2. `pret/pmd-red` (the ROM disassembly the roster itself cites) for the machine
   readable canonical data: `data/dungeon/<Dungeon>/floor_id.json`,
   `pokemon_found.json`, `data/dungeon/dungeon_item_data.json`,
   `trap_data.json`, `data/dungeon/dungeon_data.json`.
3. The repository itself for what exists locally: tilesets, Grounds, `.rsmap`,
   item ids (`CONVERSION/Item.txt`, `Data/Item/*.json`).

Anything that cannot be resolved from those sources is written into the
definition's `blocked` list as `BLOCKED/<REASON>` — never guessed.

    python3 tools/build_canonical_definitions.py --source ~/.cache/src_pmdred
    python3 tools/build_canonical_definitions.py --source ... --only tiny_woods
"""
from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any, Dict, List, Optional, Sequence, Tuple

ROOT = Path(__file__).resolve().parents[1]
ROSTER = ROOT / "docs" / "ROSTER_IMPORT_DONJONS_PMD_RED_CH7_CH32.md"
OUT_DIR = ROOT / "DungeonDefs" / "canonical"
ZONE_DIR = ROOT / "Data" / "Zone"
GROUND_DIR = ROOT / "Data" / "Ground"
MAP_DIR = ROOT / "Data" / "Map"
ITEM_DIR = ROOT / "Data" / "Item"
CONVERSION_ITEMS = ROOT / "CONVERSION" / "Item.txt"

sys.path.insert(0, str(ROOT / "tools"))
from dungeon_builder.dtef import base_tilesets  # noqa: E402
from dungeon_builder.grounds import END_SUFFIXES  # noqa: E402
from dungeon_builder.scenes import (ACTIVE_GROUND, ARCHIVED, NONE, locate as locate_scene,
                                    parse_inventory, readiness, scenes_for)  # noqa: E402

# --------------------------------------------------------------------------
# Hand-authored mapping tables.  Every entry is a decision, documented inline.
# --------------------------------------------------------------------------

#: roster english name -> folder in pret/pmd-red/data/dungeon
PMDRED_FOLDER = {
    "Tiny Woods": "TinyWoods", "Thunderwave Cave": "ThunderwaveCave", "Mt. Steel": "MtSteel",
    "Sinister Woods": "SinisterWoods", "Silent Chasm": "SilentChasm", "Mt. Thunder": "MtThunder",
    "Mt. Thunder Peak": "MtThunderPeak", "Great Canyon": "GreatCanyon", "Lapis Cave": "LapisCave",
    "Mt. Blaze": "MtBlaze", "Mt. Blaze Peak": "MtBlazePeak", "Frosty Forest": "FrostyForest",
    "Frosty Grotto": "FrostyGrotto", "Mt. Freeze": "MtFreeze", "Mt. Freeze Peak": "MtFreezePeak",
    "Magma Cavern": "MagmaCavern", "Magma Cavern Pit": "MagmaCavernPit", "Sky Tower": "SkyTower",
    "Sky Tower Summit": "SkyTowerSummit", "Stormy Sea": "StormySea", "Silver Trench": "SilverTrench",
    "Meteor Cave": "MeteorCave", "Western Cave": "WesternCave", "Wish Cave": "WishCave",
    "Buried Relic": "BuriedRelic", "Pitfall Valley": "PitfallValley",
    "Northern Range": "NorthernRange", "Desert Region": "DesertRegion",
    "Southern Cavern": "SouthernCavern", "Wyvern Hill": "WyvernHill", "Fiery Field": "FieryField",
    "Northwind Field": "NorthwindField", "Solar Cave": "SolarCave",
    "Lightning Field": "LightningField", "Darknight Relic": "DarknightRelic",
    "Murky Cave": "MurkyCave", "Grand Sea": "GrandSea", "Uproar Forest": "UproarForest",
    "Oddity Cave": "OddityCave", "Remains Island": "RemainsIsland",
    "Marvelous Sea": "MarvelousSea", "Fantasy Strait": "FantasyStrait", "Rock Path": "RockPath",
    "Snow Path": "SnowPath", "Howling Forest": "HowlingForest", "Waterfall Pond": "WaterfallPond",
    "Unown Relic": "UnownRelic", "Joyous Tower": "JoyousTower", "Far-Off Sea": "FaroffSea",
    "Mt. Faraway": "MtFaraway", "Purity Forest": "PurityForest",
}

#: nature of the dungeon -> ordered architecture profiles per segment position.
#: chosen from the audited RogueElements profiles, not at random.
NATURE_PROFILES = {
    "forest": (["branching", "dense", "mixed"], ["looping", "branching", "mixed"],
               ["mixed", "large_rooms", "looping"]),
    "cave": (["branching", "mixed", "dense"], ["looping", "lattice", "mixed"],
             ["large_rooms", "mixed", "looping"]),
    "mountain": (["twosides", "branching", "mixed"], ["branching", "crossroads", "mixed"],
                 ["large_rooms", "mixed", "branching"]),
    "peak": (["large_rooms", "crossroads", "mixed"],),
    "sea": (["looping", "ring", "mixed"], ["ring", "lattice", "looping"],
            ["large_rooms", "looping", "mixed"]),
    "relic": (["crossroads", "lattice", "mixed"], ["lattice", "looping", "dense"],
              ["large_rooms", "crossroads", "mixed"]),
    "field": (["twosides", "large_rooms", "mixed"], ["looping", "mixed", "large_rooms"],
              ["large_rooms", "ring", "mixed"]),
    "tower": (["crossroads", "branching", "mixed"], ["lattice", "looping", "mixed"],
              ["large_rooms", "crossroads", "mixed"]),
    "desert": (["large_rooms", "twosides", "mixed"], ["looping", "mixed", "dense"],
               ["large_rooms", "mixed", "looping"]),
}

#: dungeon slug -> (nature, biome names per segment, tileset triplet base, justification)
#: A tileset is only assigned when a triplet really exists locally (mod DTEF or a
#: base PMDO tileset already referenced by shipped data) AND matches the biome.
DUNGEON_SETUP: Dict[str, Dict[str, Any]] = {
    "tiny_woods":        {"nature": "forest", "biomes": ["young_woods"], "tileset": "tiny_meadow",
                          "justification": 'Forêt Tendre : biome de prairie/bosquet de départ ; utilisateur unique.'},
    "thunderwave_cave":  {"nature": "cave", "biomes": ["static_cave"], "tileset": "crystal_cave_2",
                          "justification": 'Grotte Statique : aucun DTEF Thunderwave importé ; même biome de grotte sèche que le Gouffre Muet, qui reste propriétaire du triplet.'},
    "mt_steel":          {"nature": "mountain", "biomes": ["steel_slope", "steel_summit"],
                          "tileset": "steel_aegis_cave",
                          "justification": "biome métallique ; tileset acier disponible localement."},
    "sinister_woods":    {"nature": "forest", "biomes": ["forest_edge", "deep_forest", "forest_clearing"],
                          "tileset": "sinister_woods_b41", "owner": "gloomy_forest"},
    "silent_chasm":      {"nature": "cave", "biomes": ["silent_rim", "chasm_depths"], "tileset": "silent_chasm",
                          "justification": None},
    "mt_thunder":        {"nature": "mountain", "biomes": ["thunder_slope", "thunder_ridge"],
                          "tileset": "mt_thunder", "justification": None},
    "mt_thunder_peak":   {"nature": "peak", "biomes": ["thunder_peak"], "tileset": "far_amp_plains",
                          "justification": 'Cime du Mont Grondant : plaines électriques, seul utilisateur ; le triplet mt_thunder reste au massif.'},
    "great_canyon":      {"nature": "mountain", "biomes": ["canyon_rim", "canyon_floor"],
                          "tileset": "mt_horn", "justification": None},
    "lapis_cave":        {"nature": "cave", "biomes": ["lapis_gallery", "lapis_depths"],
                          "tileset": "lapis_cave", "justification": None},
    "mt_blaze":          {"nature": "mountain", "biomes": ["blaze_slope", "blaze_ridge"],
                          "tileset": "mt_blaze", "justification": None},
    "mt_blaze_peak":     {"nature": "peak", "biomes": ["blaze_peak"], "tileset": "magma_cavern_2",
                          "justification": 'Cime du Mont Cendré : même massif volcanique que la Gorge Ardente (Sulfura) ; réutilisation du biome canonique du massif, assumée et documentée.'},
    "frosty_forest":     {"nature": "forest", "biomes": ["frosty_edge", "frosty_heart"],
                          "tileset": "frosty_forest", "justification": None},
    "frosty_grotto":     {"nature": "cave", "biomes": ["frosty_grotto"], "tileset": "mt_freeze",
                          "justification": 'Grotte Givrée : cavité du massif du Mont Gelé (Artikodin) ; même biome canonique que le massif.'},
    "mt_freeze":         {"nature": "mountain", "biomes": ["freeze_slope", "freeze_ridge"],
                          "tileset": "mt_freeze", "justification": None},
    "mt_freeze_peak":    {"nature": "peak", "biomes": ["freeze_peak"], "tileset": "mt_freeze",
                          "justification": 'Cime du Mont Gelé : même massif que le Mont Gelé, biome canonique identique.'},
    "magma_cavern":      {"nature": "cave", "biomes": ["magma_gallery", "magma_core", "magma_abyss"],
                          "tileset": "magma_cavern_2", "justification": None},
    "magma_cavern_pit":  {"nature": "cave", "biomes": ["magma_pit"], "tileset": "world_abyss_2",
                          "justification": 'Fond de la Gorge Ardente (Groudon) : abysse volcanique, unique utilisateur de ce triplet.'},
    "sky_tower":         {"nature": "tower", "biomes": ["sky_ascent"], "tileset": "sky_tower"},
    "sky_tower_summit":  {"nature": "peak", "biomes": ["sky_summit"], "tileset": "sky_tower",
                          "justification": "Sommet de la Tour Céleste : même édifice que la Tour "
                                           "Céleste, biome canonique identique."},
    "stormy_sea":        {"nature": "sea", "biomes": ["stormy_shelf", "stormy_deep", "stormy_abyss"],
                          "tileset": "stormy_sea_1", "justification": None},
    "silver_trench":     {"nature": "sea", "biomes": ["silver_shelf", "silver_deep", "silver_trench"],
                          "tileset": "silver_trench_3",
                          "justification": None},
    "meteor_cave":       {"nature": "cave", "biomes": ["meteor_shell", "meteor_core"],
                          "tileset": "spacial_rift_1",
                          "justification": "grotte de la météorite (Deoxys) ; biome spatial/anormal."},
    "western_cave":      {"nature": "cave", "biomes": ["western_gallery", "western_depths", "western_abyss"],
                          "tileset": "western_cave_1", "justification": None},
    "wish_cave":         {"nature": "cave", "biomes": ["wish_gallery", "wish_sanctum"],
                          "tileset": "wish_cave_1",
                          "justification": None},
    "buried_relic":      {"nature": "relic", "biomes": ["relic_halls", "relic_depths", "relic_vault"],
                          "tileset": "buried_relic_1", "justification": None},
    "pitfall_valley":    {"nature": "mountain", "biomes": ["pitfall_rim", "pitfall_floor"],
                          "tileset": "pitfall_valley_1", "justification": None},
    "northern_range":    {"nature": "mountain", "biomes": ["north_ridge", "north_heights"],
                          "tileset": "craggy_peak",
                          "justification": 'Chaîne Nordique : crêtes rocheuses, aucun triplet Northern Range importé ; utilisateur unique.'},   # resolved as a conflict below if reused
    "desert_region":     {"nature": "desert", "biomes": ["dunes", "deep_desert"],
                          "tileset": "northern_desert_1", "justification": None},
    "southern_cavern":   {"nature": "cave", "biomes": ["south_gallery", "south_depths", "south_abyss"],
                          "tileset": "crystal_cave_1", "justification": 'Caverne Méridionale : seconde variante de la grande caverne occidentale, distincte de western_cave_1 conservé par Western Cave.'},
    "wyvern_hill":       {"nature": "mountain", "biomes": ["wyvern_slope", "wyvern_crest"],
                          "tileset": "wyvern_hill", "justification": None},
    "fiery_field":       {"nature": "field", "biomes": ["ember_plain", "burning_plain"],
                          "tileset": "deep_dark_crater", "justification": 'Plaine Ardente : cratère volcanique, aucun triplet Fiery Field importé ; utilisateur unique.'},
    "northwind_field":   {"nature": "field", "biomes": ["north_plain", "gale_plain"],
                          "tileset": "northwind_field", "dtef_package": True,
                          "justification": None},
    "solar_cave":        {"nature": "cave", "biomes": ["solar_gallery", "solar_heart"],
                          "tileset": "golden_chamber",
                          "justification": 'Grotte Solaire : chambre dorée, seul biome lumineux disponible ; unique utilisateur.'},
    "lightning_field":   {"nature": "field", "biomes": ["storm_plain", "thunder_plain"],
                          "tileset": "lightning_field", "justification": 'Champ de Foudre : plaines électriques canoniques ; unique utilisateur.'},
    "darknight_relic":   {"nature": "relic", "biomes": ["dark_halls", "dark_sanctum"],
                          "tileset": "the_nightmare",
                          "justification": "relique nocturne ; biome onirique sombre disponible."},
    "murky_cave":        {"nature": "cave", "biomes": ["murky_gallery", "murky_depths"],
                          "tileset": "murky_cave", "justification": None},
    "grand_sea":         {"nature": "sea", "biomes": ["grand_shelf", "grand_deep"],
                          "tileset": "surrounded_sea", "justification": None},
    "uproar_forest":     {"nature": "forest", "biomes": ["uproar_edge", "uproar_heart"],
                          "tileset": "treeshroud_forest_2", "justification": 'Forêt du Tumulte : second tileset forestier PMDO, distinct de howling_forest_2 conservé par la Forêt des Hurlements.'},
    "oddity_cave":       {"nature": "cave", "biomes": ["oddity_gallery", "oddity_core"],
                          "tileset": "spacial_rift_2",
                          "justification": "caverne étrange ; seconde faille spatiale, distincte de "
                                           "spacial_rift_1."},
    "remains_island":    {"nature": "relic", "biomes": ["remains_shore", "remains_ruins"],
                          "tileset": "concealed_ruins", "justification": None},
    "marvelous_sea":     {"nature": "sea", "biomes": ["marvelous_shelf", "marvelous_deep"],
                          "tileset": "miracle_sea", "justification": None},
    "fantasy_strait":    {"nature": "sea", "biomes": ["strait_shelf", "strait_deep"],
                          "tileset": "craggy_coast", "justification": 'Détroit Fantastique : côte escarpée, seul biome de détroit disponible ; utilisateur unique.'},
    "rock_path":         {"nature": "cave", "biomes": ["rock_path"], "tileset": "rock_path_rb",
                          "justification": None},
    "snow_path":         {"nature": "field", "biomes": ["snow_path"], "tileset": "sky_peak_4th_pass",
                          "justification": "Sentier Neigeux : col d'altitude enneigé ; utilisateur unique après déplacement de la Cime du Mont Gelé."},
    "howling_forest":    {"nature": "forest", "biomes": ["howling_edge", "howling_heart"],
                          "tileset": "howling_forest_2", "justification": None},
    "waterfall_pond":    {"nature": "sea", "biomes": ["pond_shore", "pond_depths"],
                          "tileset": "unused_waterfall_pond", "justification": None},
    "unown_relic":       {"nature": "relic", "biomes": ["unown_halls", "unown_vault"],
                          "tileset": "deep_sealed_ruin",
                          "justification": "relique des Zarbi ; fosse de ruine scellée, distincte de "
                                           "sealed_ruin."},
    "joyous_tower":      {"nature": "tower", "biomes": ["tower_base", "tower_middle", "tower_top"],
                          "tileset": "lush_prairie",
                          "justification": "tour joyeuse, ambiance claire et végétale ; prairie disponible."},
    "far_off_sea":       {"nature": "sea", "biomes": ["far_shelf", "far_deep", "far_abyss"],
                          "tileset": "zero_isle_east_4",
                          "justification": "mer lointaine ; biome insulaire lointain disponible."},
    "mt_faraway":        {"nature": "mountain", "biomes": ["faraway_slope", "faraway_ridge", "faraway_peak"],
                          "tileset": "hidden_highland", "justification": 'Mont Lointain : hautes terres isolées, aucun triplet Mt. Faraway importé ; utilisateur unique.'},
    "purity_forest":     {"nature": "forest", "biomes": ["purity_outer", "purity_inner", "purity_heart",
                                                         "purity_core"],
                          "tileset": "purity_forest_4", "justification": None},
}

#: canonical end Grounds already converted in Data/Ground (verified file by file).
#: When one exists the final battle happens there — never in a new arena.
END_GROUND = {
    "magma_cavern_pit": "fosse_ardente",       # Fond de la Gorge Ardente (Groudon)
    "wish_cave": "sanctuaire_voeu",            # salle finale du Vœu (Jirachi) + .rsmap homonyme
    "lapis_cave": "grotte_lazuli_fond",        # fond de la Grotte Lazuli
    "magma_cavern": "gorge_ardente_coeur",     # cœur de la Gorge Ardente
    # Forêt de la Pureté : le mod situe Celebi dans « forêt de guérison »
    # (arbitrage §4.6 du roster) ; la scène existe en archive et fait donc foi.
    "purity_forest": "foret_guerison",
}

#: scenes that *might* correspond to a dungeon but need a human arbitration.
#: They are recorded, never used silently.
SCENE_CANDIDATES = {
    "buried_relic": ["relique_ancienne", "tour_reliques_porte", "fleche_reliques_courroux",
                     "sanctuaire_titans (déjà utilisé par cloven_ruins ch5)"],
    "meteor_cave": [],
}

#: Dungeons whose canonical boss encounter happens INSIDE the dungeon.
#: Evidence: pret/pmd-red `src/dungeon_boss_dialogue.c` holds in-dungeon
#: pre/post-fight dialogue for these bosses, and the PMD Red ground archive only
#: covers D01–D25 — these dungeons own no Ground scene at all.  The correct
#: implementation is therefore a fixed dungeon room (.rsmap loaded as a floor),
#: never an invented cutscene Ground.
#: fixed in-dungeon boss rooms produced by tools/dungeon_builder/fixed_rooms.py
FIXED_BOSS_ROOM = {
    "buried_relic": "buried_relic_arena",
    "meteor_cave": "meteor_cave_arena",
}

IN_DUNGEON_BOSS = {
    "buried_relic": ("Regirock / Regice / Registeel", "gRegirockPreFightDialogue, "
                     "gRegicePreFightDialogue, gRegisteelPreFightDialogue"),
    "meteor_cave": ("Deoxys", "gDeoxysPreFightDialogue_1..4"),
}

#: canonical entrance Grounds already converted in Data/Ground
ENTRANCE_GROUND = {
    "frosty_forest": "foret_givree_oree",
    "mt_freeze": "mont_gele_pied",
    "mt_blaze": "mont_cendre_pied",
    "magma_cavern": "gorge_ardente_porte",
    "lapis_cave": "grotte_lazuli_seuil",
    "pitfall_valley": "vallon_perdu",
}

#: canonical bosses that the roster attaches to a dungeon
BOSS_SPECIES = {
    "Zapdos": "zapdos", "Moltres": "moltres", "Articuno": "articuno", "Groudon": "groudon",
    "Rayquaza": "rayquaza", "Kyogre": "kyogre", "Lugia": "lugia", "Deoxys": "deoxys",
    "Mewtwo": "mewtwo", "Jirachi": "jirachi", "Latios": "latios", "Entei": "entei",
    "Suicune": "suicune", "Raikou": "raikou", "Ho-Oh": "ho_oh", "Celebi": "celebi",
    "Regis": "regirock",
}

#: roster name -> constant in dungeon_data.json when the disassembly differs
DUNGEON_CONST_OVERRIDES = {
    "Unown Relic": "DUNGEON_UNKNOWN_RELIC",
    "Far-Off Sea": "DUNGEON_FAR_OFF_SEA",
}

SPECIES_OVERRIDES = {
    "MONSTER_NIDORAN_M": "nidoran_m", "MONSTER_NIDORAN_F": "nidoran_f",
    "MONSTER_MR_MIME": "mr_mime", "MONSTER_MIME_JR": "mime_jr",
    "MONSTER_FARFETCH_D": "farfetchd", "MONSTER_FARFETCHD": "farfetchd",
    "MONSTER_HO_OH": "ho_oh", "MONSTER_PORYGON2": "porygon2", "MONSTER_PORYGON_Z": "porygon_z",
    "MONSTER_TYPE_NULL": "type_null",
}
#: canonical RRT item -> id verified in Data/Item (only real equivalents)
ITEM_OVERRIDES = {
    "ITEM_GEO_PEBBLE": "ammo_geo_pebble", "ITEM_IRON_THORN": "ammo_iron_thorn",
    "ITEM_STICK": "ammo_stick", "ITEM_CACNEA_SPIKE": "ammo_cacnea_spike",
    "ITEM_CORSOLA_TWIG": "ammo_corsola_twig", "ITEM_BIG_APPLE": "food_apple_big",
    "ITEM_HUGE_APPLE": "food_apple_huge", "ITEM_INSOMNISCOPE": "held_insomniascope",
    "ITEM_DEF_SCARF": "held_defense_scarf", "ITEM_LINK_BOX": "machine_recall_box",
    "ITEM_CHESTNUT": "food_chestnut", "ITEM_GRIMY_FOOD": "food_apple",
}

SPECIES_SKIP = {"MONSTER_DECOY", "MONSTER_KECLEON", "MONSTER_NONE", "MONSTER_DUMMY_0x0",
                "MONSTER_STATUE_DECOY"}


# --------------------------------------------------------------------------
def roster_assets(cell: str) -> set:
    """Extract the converted asset names quoted in the roster's asset column.

    `grotte_lazuli_seuil/fond` -> {grotte_lazuli_seuil, grotte_lazuli_fond}
    """
    names: set = set()
    for token in re.findall(r"`([^`]+)`", cell):
        for part in token.split():
            if "/" in part:
                head, *tails = part.split("/")
                names.add(head)
                prefix = "_".join(head.split("_")[:-1])
                for tail in tails:
                    names.add(f"{prefix}_{tail}" if prefix else tail)
            elif re.fullmatch(r"[a-z0-9_]+", part):
                names.add(part)
    return names


BUILDER_MARKER = "tools/dungeon_builder"


def _legacy_from_git(rel_path: str) -> str:
    """Read a file as it was in the repository's root commit (pre-takeover)."""
    import subprocess
    try:
        root = subprocess.run(["git", "rev-list", "--max-parents=0", "HEAD"], cwd=ROOT,
                              capture_output=True, text=True, check=True).stdout.split()[0]
        return subprocess.run(["git", "show", f"{root}:{rel_path}"], cwd=ROOT,
                              capture_output=True, text=True, check=True).stdout
    except (subprocess.CalledProcessError, IndexError, OSError):
        return ""


def harvest_legacy_zone(zone_id: str) -> Dict[str, Any]:
    """Extract the still-useful data from a legacy zone before replacing it.

    Only project-authored values are kept (music, level/rescue flags, Ground
    references, the canonical note); the legacy floor structure is discarded on
    purpose — that is precisely what the Builder rebuilds.
    """
    path = ZONE_DIR / f"{zone_id}.json"
    text = ""
    if path.exists():
        text = path.read_text(encoding="utf-8-sig")
    if not text or BUILDER_MARKER in text[:4000]:
        # our rebuild already replaced it: read the legacy content from the
        # repository's root commit so the provenance never disappears
        text = _legacy_from_git(f"Data/Zone/{zone_id}.json")
    if not text:
        return {}
    try:
        obj = json.loads(text.lstrip("\ufeff"))["Object"]
    except (json.JSONDecodeError, KeyError):
        return {}
    if BUILDER_MARKER in (obj.get("Comment") or ""):
        return {}                       # already ours, nothing to harvest
    music: List[str] = []

    def walk(node):
        if isinstance(node, dict):
            value = node.get("Music")
            if isinstance(value, str) and value and value not in music:
                music.append(value)
            for child in node.values():
                walk(child)
        elif isinstance(node, list):
            for child in node:
                walk(child)

    walk(obj)
    floors = sum(len(segment.get("Floors", [])) for segment in obj.get("Segments", []))
    return {
        "music": music[0] if music else "",
        "all_music": music,
        "level": obj.get("Level", -1),
        "rescues": obj.get("Rescues", 2),
        "released": bool(obj.get("Released", False)),
        "grounds": list(obj.get("GroundMaps", [])),
        "note": (obj.get("Comment") or "").strip(),
        "legacy_floor_count": floors,
    }


def slugify(name: str) -> str:
    text = name.lower().replace("mt.", "mt").replace("-", " ").replace("'", "")
    text = re.sub(r"[^a-z0-9]+", "_", text).strip("_")
    return text


def parse_roster(path: Path = ROSTER) -> List[Dict[str, Any]]:
    rows: List[Dict[str, Any]] = []
    for line in path.read_text(encoding="utf-8").splitlines():
        if not line.startswith("| ") or "|---" in line:
            continue
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if len(cells) != 8 or not cells[0].isdigit():
            continue
        floors = re.sub(r"[^0-9]", "", cells[2])
        chapter = re.sub(r"[^0-9]", "", cells[6])
        rows.append({
            "index": int(cells[0]),
            "name": cells[1].replace("**", "").strip(),
            "floors": int(floors) if floors else 0,
            "boss": cells[3].replace("**", "").strip(" —"),
            "asset": cells[4],
            "tier": cells[5],
            "chapter": int(chapter) if chapter else 0,
            "already_done": "✅" in cells[6],
            "fr_name": cells[7].replace("(déjà)", "").strip(),
        })
    return rows


def load_item_conversion() -> Dict[str, str]:
    mapping: Dict[str, str] = {}
    if CONVERSION_ITEMS.exists():
        for line in CONVERSION_ITEMS.read_text(encoding="utf-8").splitlines():
            parts = line.split("\t")
            if len(parts) == 2:
                mapping[parts[0].strip()] = parts[1].strip()
    return mapping


def known_items() -> Dict[str, int]:
    prices: Dict[str, int] = {}
    for path in ITEM_DIR.glob("*.json"):
        try:
            data = json.loads(path.read_text(encoding="utf-8-sig"))["Object"]
        except Exception:
            continue
        prices[path.stem] = int(data.get("Price", 0))
    return prices


def convert_species(raw: str) -> Optional[str]:
    if raw in SPECIES_SKIP:
        return None
    if raw in SPECIES_OVERRIDES:
        return SPECIES_OVERRIDES[raw]
    if not raw.startswith("MONSTER_"):
        return None
    return raw[len("MONSTER_"):].lower()


def convert_item(raw: str, conversion: Dict[str, str], prices: Dict[str, int]) -> Optional[str]:
    if raw in ITEM_OVERRIDES:
        candidate = ITEM_OVERRIDES[raw]
        return candidate if candidate in prices else None
    key = raw[len("ITEM_"):].lower() if raw.startswith("ITEM_") else raw.lower()
    if key in ("poke", "none", "used_tm"):
        return None
    candidate = conversion.get(key)
    if candidate and candidate in prices:
        return candidate
    # Direct hit is safe.  Cross-family guessing is forbidden: it previously
    # mapped ITEM_WARP_ORB to seed_warp merely because orb_warp was absent.
    # A missing mapping must stay visible until CONVERSION/Item.txt or the
    # explicit override table documents a real runtime equivalent.
    if key in prices:
        return key
    return None


# --------------------------------------------------------------------------
class CanonicalSource:
    def __init__(self, root: Path):
        self.root = Path(root)
        base = self.root / "data" / "dungeon"
        if not base.exists():
            raise SystemExit(f"pret/pmd-red data not found under {base}")
        self.base = base
        self.dungeon_flags = {entry["name"]: entry
                              for entry in json.loads((base / "dungeon_data.json").read_text())}
        self.item_tables = json.loads((base / "dungeon_item_data.json").read_text())
        self.trap_tables = json.loads((base / "trap_data.json").read_text())

    def floors(self, folder: str) -> List[Dict[str, int]]:
        path = self.base / folder / "floor_id.json"
        return json.loads(path.read_text())["tables"]

    def pokemon_tables(self, folder: str) -> List[Dict[str, Any]]:
        path = self.base / folder / "pokemon_found.json"
        if not path.exists():
            return []
        return json.loads(path.read_text())["tables"]

    def flags(self, dungeon_const: str) -> Dict[str, Any]:
        return self.dungeon_flags.get(dungeon_const, {})


def chapter_base_level(chapter: int) -> int:
    """Level floor of a chapter's tier in New Era (ch.6 = 18 … ch.32 = 60).

    « Renivelage » is a *translation*, not a multiplication: the canonical
    species, their probabilities and their relative level deltas are preserved,
    only the band is moved onto the chapter's tier.
    """
    return int(round(18 + (chapter - 6) * 1.62))


def build_definition(row: Dict[str, Any], source: CanonicalSource,
                     conversion: Dict[str, str], prices: Dict[str, int],
                     tilesets: set, ground_names: set, map_names: set,
                     zone_names: set, inventory: Dict[str, Any]) -> Dict[str, Any]:
    slug = slugify(row["name"])
    setup = DUNGEON_SETUP.get(slug, {})
    blocked: List[str] = []
    folder = PMDRED_FOLDER.get(row["name"])
    definition: Dict[str, Any] = {
        "id": setup.get("owner", slug),
        "aliases": sorted(({slug} | roster_assets(row["asset"])) - {setup.get("owner", slug)}),
        "name": {"en": row["name"], "fr": row["fr_name"]},
        "chapter": row["chapter"],
        "route": "secondary",
        "source": (f"Pokémon Mystery Dungeon: Red Rescue Team — {row['name']} "
                   f"({row['floors']}F). Espèces, niveaux, probabilités, tables d'objets, pièges et "
                   f"boutiques extraits de pret/pmd-red (data/dungeon/{folder}) via "
                   f"tools/build_canonical_definitions.py ; niveaux renivelés au palier du chapitre "
                   f"{row['chapter']}. Recoupé avec Bulbapedia (page « {row['name']} »)."),
        "comment": (f"Définition canonique générée pour le chapitre {row['chapter']}. "
                    "Aucun étage pré-calculé : la topologie est produite en jeu par RogueElements."),
        "floors": row["floors"],
    }

    if folder is None:
        blocked.append("BLOCKED/MISSING_SOURCE: no pret/pmd-red folder mapped for this dungeon")
        definition["blocked"] = blocked
        return definition

    floor_tables = source.floors(folder)
    if len(floor_tables) != row["floors"]:
        definition["comment"] += (f" Note: floor_id.json déclare {len(floor_tables)} étages contre "
                                  f"{row['floors']} au roster ; la valeur canonique du disassembly "
                                  "est retenue.")
        definition["floors"] = len(floor_tables)
    total_floors = definition["floors"]

    const = DUNGEON_CONST_OVERRIDES.get(
        row["name"],
        "DUNGEON_" + re.sub(r"[^A-Z0-9]+", "_", row["name"].upper().replace("MT.", "MT")).strip("_"))
    flags = source.flags(const)
    if not flags:
        blocked.append(f"BLOCKED/MISSING_SOURCE: dungeon_data.json has no entry named {const}")

    direction = "sommet" if flags.get("stairDirectionUp") else "fond"
    legacy = harvest_legacy_zone(setup.get("owner", slug))
    previous_path = OUT_DIR / f"{slug}.json"
    previous: Dict[str, Any] = {}
    if previous_path.exists():
        try:
            previous = json.loads(previous_path.read_text(encoding="utf-8-sig"))
        except json.JSONDecodeError:
            previous = {}
    definition["biome"] = (setup.get("biomes") or ["unknown"])[0]
    definition["level"] = chapter_base_level(row["chapter"])
    definition["rescues"] = 2 if flags.get("rescuesAllowed", -1) != 0 else 0
    definition["released"] = False
    definition["music"] = legacy.get("music", "")
    if not legacy and previous.get("harvested_from_legacy"):
        # the legacy zone has already been replaced by our rebuild: keep the
        # provenance record so the takeover stays auditable
        definition["harvested_from_legacy"] = previous["harvested_from_legacy"]
        definition["music"] = definition["music"] or previous.get("music", "")
        definition["rescues"] = previous.get("rescues", definition["rescues"])
    if legacy:
        definition["harvested_from_legacy"] = {
            "zone": f"Data/Zone/{setup.get('owner', slug)}.json",
            "kept": {k: legacy[k] for k in ("music", "rescues", "grounds", "note") if legacy.get(k)},
            "discarded": (f"legacy floor structure ({legacy.get('legacy_floor_count', 0)} floors "
                          f"vs {row['floors']} canonical) — rebuilt by the Builder"),
        }
        if legacy.get("rescues") is not None:
            definition["rescues"] = int(legacy["rescues"])
    definition["variation"] = {
        "direction": direction,
        "time_limit": int(flags.get("turnLimit", 1500) or 1500),
        "max_foes": 6,
        "respawn_time": 100,
        "level_scaling": {"policy": "translation to chapter tier",
                          "chapter_base_level": chapter_base_level(row["chapter"])},
        "canonical_flags": {k: flags.get(k) for k in
                            ("maxItemsAllowed", "maxPartyMembers", "keepMoney",
                             "recruitingEnabled", "stairDirectionUp")},
    }
    definition["stairs"] = {"min_distance": 4,
                            "exit_tile": "stairs_go_up" if direction == "sommet" else "stairs_go_down"}

    # ---- tileset ---------------------------------------------------------
    tileset = setup.get("tileset")
    if not tileset:
        blocked.append("BLOCKED/MISSING_TILESET: no DTEF triplet assigned for this biome")
        definition["dtef"] = {}
    elif setup.get("dtef_package"):
        definition["dtef"] = {"package": tileset,
                              "element": setup.get("element", "ice" if "wind" in slug else "normal")}
    elif tileset == "sinister_woods_b41":
        definition["dtef"] = {"package": tileset, "element": "grass"}
    else:
        triplet = (f"{tileset}_floor", f"{tileset}_wall", f"{tileset}_secondary")
        if not all(name in tilesets for name in triplet):
            blocked.append(f"BLOCKED/MISSING_TILESET: triplet '{tileset}' incomplete locally")
            definition["dtef"] = {}
        else:
            definition["dtef"] = {"floor": triplet[0], "wall": triplet[1], "secondary": triplet[2],
                                  "name": tileset, "element": "normal"}
            if setup.get("justification"):
                definition["dtef"]["justification"] = setup["justification"]

    # ---- species ---------------------------------------------------------
    pk_tables = source.pokemon_tables(folder)
    pk_base = floor_tables[0]["Pokemon"] if floor_tables else 0
    per_floor: Dict[int, List[Dict[str, Any]]] = {}
    for floor_index, table in enumerate(floor_tables, start=1):
        offset = table.get("Pokemon", pk_base) - pk_base
        if 0 <= offset < len(pk_tables):
            per_floor[floor_index] = pk_tables[offset].get("pokemon", [])
    if not per_floor:
        blocked.append("BLOCKED/MISSING_SOURCE: no pokemon_found table resolved")

    base_level = chapter_base_level(row["chapter"])
    canonical_min = min((int(entry.get("level", 1))
                         for entries in per_floor.values() for entry in entries
                         if int(entry.get("probability", 0)) > 0), default=1)
    species_data: Dict[str, Dict[str, Any]] = {}
    unknown_species: set = set()
    for floor_index, entries in per_floor.items():
        for entry in entries:
            if int(entry.get("probability", 0)) <= 0:
                continue
            species = convert_species(entry["species"])
            if species is None:
                if entry["species"] not in SPECIES_SKIP:
                    unknown_species.add(entry["species"])
                continue
            level = max(5, base_level + int(entry.get("level", 1)) - canonical_min)
            record = species_data.setdefault(species, {"levels": [], "floors": [], "prob": []})
            record["levels"].append(level)
            record["floors"].append(floor_index)
            record["prob"].append(int(entry["probability"]))
    if unknown_species:
        blocked.append("BLOCKED/MISSING_SOURCE: unmapped species "
                       + ", ".join(sorted(unknown_species)[:8]))

    # ---- segments --------------------------------------------------------
    biomes = setup.get("biomes") or ["unknown"]
    segment_count = min(len(biomes), max(1, total_floors // 5) or 1)
    segment_count = max(1, min(segment_count, len(biomes)))
    bounds: List[Tuple[int, int]] = []
    step = total_floors / segment_count
    start = 1
    for index in range(segment_count):
        end = total_floors if index == segment_count - 1 else int(round((index + 1) * step))
        end = max(start, min(total_floors, end))
        bounds.append((start, end))
        start = end + 1

    nature = setup.get("nature", "cave")
    profile_sets = NATURE_PROFILES.get(nature, NATURE_PROFILES["cave"])

    # ---- items -----------------------------------------------------------
    def item_table_for(floor_range: Tuple[int, int]) -> Tuple[Dict[str, Any], List[str], bool]:
        indices = {floor_tables[f - 1].get("Items") for f in range(floor_range[0], floor_range[1] + 1)
                   if f - 1 < len(floor_tables)}
        entries: Dict[str, int] = {}
        missing: List[str] = []
        money_only = True
        for index in sorted(i for i in indices if isinstance(i, int)):
            if not (0 <= index < len(source.item_tables)):
                continue
            for category in source.item_tables[index].get("categories", []):
                if int(category.get("categoryProbability", 0)) <= 0:
                    continue
                for item in category.get("items", []):
                    probability = int(item.get("itemProbability", 0))
                    if probability <= 0:
                        continue
                    if item["item"] in ("ITEM_POKE", "ITEM_NONE"):
                        continue          # money is handled by MoneySpawnZoneStep
                    money_only = False
                    converted = convert_item(item["item"], conversion, prices)
                    if converted is None:
                        missing.append(item["item"])
                        continue
                    weight = max(1, round(probability / 500))
                    entries[converted] = max(entries.get(converted, 0), weight)
        table = {"amount": [2, 5],
                 "entries": [{"item": name, "weight": weight}
                             for name, weight in sorted(entries.items())]}
        return table, missing, money_only

    # ---- kecleon shop ----------------------------------------------------
    shop_floors = [f for f, table in enumerate(floor_tables, start=1)
                   if isinstance(table.get("KecleonShop"), int) and table["KecleonShop"] > 0]
    shop_items: List[Dict[str, Any]] = []
    if shop_floors:
        shop_index = floor_tables[shop_floors[0] - 1]["KecleonShop"]
        if 0 <= shop_index < len(source.item_tables):
            for category in source.item_tables[shop_index].get("categories", []):
                for item in category.get("items", []):
                    if int(item.get("itemProbability", 0)) <= 0:
                        continue
                    converted = convert_item(item["item"], conversion, prices)
                    if converted is None:
                        continue
                    shop_items.append({"item": converted,
                                       "price": max(50, prices.get(converted, 20) * 5),
                                       "weight": max(1, round(int(item["itemProbability"]) / 700))})

    # ---- traps -----------------------------------------------------------
    trap_kinds: Dict[str, int] = {}
    for table in floor_tables:
        index = table.get("Traps")
        if isinstance(index, int) and 0 <= index < len(source.trap_tables):
            for name, weight in source.trap_tables[index].get("traps", {}).items():
                if int(weight) > 0:
                    trap_kinds[name] = max(trap_kinds.get(name, 0), int(weight))

    # ---- monster house ---------------------------------------------------
    house_floors = [f for f, table in enumerate(floor_tables, start=1)
                    if isinstance(table.get("MonsterRoomItems"), int) and table["MonsterRoomItems"] > 0]

    missing_items: List[str] = []
    money_only_segments: List[str] = []
    segments: List[Dict[str, Any]] = []
    for index, (lo, hi) in enumerate(bounds):
        segment_species = []
        for species, record in sorted(species_data.items()):
            floors_in = [f for f in record["floors"] if lo <= f <= hi]
            if not floors_in:
                continue
            levels = [record["levels"][i] for i, f in enumerate(record["floors"]) if lo <= f <= hi]
            probs = [record["prob"][i] for i, f in enumerate(record["floors"]) if lo <= f <= hi]
            segment_species.append({
                "species": species,
                "level": [min(levels), max(levels)],
                "weight": max(1, round(sum(probs) / len(probs) / 500)),
                "floors": [min(floors_in), max(floors_in)],
            })
        table, missing, money_only = item_table_for((lo, hi))
        missing_items.extend(missing)
        segments.append({
            "name": biomes[min(index, len(biomes) - 1)],
            "floors": [lo, hi],
            "biome": biomes[min(index, len(biomes) - 1)],
            "profiles": [{"name": name, "weight": weight}
                         for name, weight in zip(profile_sets[min(index, len(profile_sets) - 1)],
                                                 (24, 18, 14))],
            "pokemon": segment_species,
            "inherit_pokemon": False,
            "items": {"canonical": table} if table["entries"] else {},
            "inherit_items": False,
        })
        if not segment_species:
            blocked.append(f"BLOCKED/MISSING_SOURCE: segment {lo}-{hi} has no canonical species")
        if not table["entries"]:
            if money_only:
                money_only_segments.append(f"{lo}-{hi}")
            else:
                blocked.append(
                    f"BLOCKED/MISSING_SOURCE: segment {lo}-{hi} has no convertible item table")

    if money_only_segments:
        definition["comment"] += (" Étages canoniquement sans objet au sol (argent uniquement) : "
                                  + ", ".join(money_only_segments) + ".")
    if missing_items:
        unmapped = sorted(set(missing_items))
        definition["canonical_items_without_pmdo_equivalent"] = unmapped
        definition["comment"] += (f" {len(unmapped)} objets canoniques n'existent pas dans le jeu "
                                  "d'objets du mod et sont omis de la table (liste conservée dans "
                                  "`canonical_items_without_pmdo_equivalent`).")

    fixed_room = FIXED_BOSS_ROOM.get(slug)
    if fixed_room and fixed_room in map_names and segments:
        last = segments[-1]
        last.setdefault("fixed_floors", {})[str(total_floors)] = {
            "map": fixed_room,
            "comment": ("Salle fixe canonique du boss, chargée en étage par LoadGen + "
                        "MappedRoomStep : le combat reste dans le donjon."),
        }

    definition["segments"] = segments
    definition["money"] = [100 + 20 * row["chapter"], 140 + 26 * row["chapter"]]
    definition["profiles"] = [{"name": name, "weight": 10} for name in profile_sets[0]]
    definition["items"] = {}

    features: Dict[str, Any] = {}
    if shop_items:
        features["shop"] = {"enabled": True, "floors": [min(shop_floors), max(shop_floors)],
                            "trials": 2, "percent": 45,
                            "price_policy": "Data/Item Price x5",
                            "items": shop_items[:14]}
    elif shop_floors:
        blocked.append("BLOCKED/MISSING_SOURCE: Kecleon shop floors known but no convertible stock")
    if house_floors:
        features["monster_house"] = {"enabled": True,
                                     "floors": [min(house_floors), max(house_floors)],
                                     "trials": 2, "percent": 30, "species": 6, "level_boost": 2,
                                     "items": []}
    if trap_kinds:
        features["traps"] = {"enabled": True, "canonical_kinds": sorted(trap_kinds),
                             "note": "conversion des pièges PMDO à faire par TileSpawnZoneStep"}
    definition["features"] = features

    # ---- canonical scenes (cinematic = battle = end) ---------------------
    scene_set = scenes_for(row["name"], inventory)
    scene_end = scene_set.canonical_end if scene_set else None
    scene_state, scene_reason = readiness(scene_end)
    if scene_set:
        definition["scenes"] = {
            "source": "docs/INVENTAIRE_GROUNDS_DONJONS_PMD_RED.md",
            "entrance_ground": scene_set.entrance.name if scene_set.entrance
                               and scene_set.entrance.exists else "",
            "relay_ground": scene_set.relay.name if scene_set.relay and scene_set.relay.exists else "",
            "canonical_end_ground": scene_end.name if scene_end and scene_end.exists else "",
            "state": scene_state,
            "location": scene_end.location if scene_end else "",
            "cinematic_ground": scene_end.name if scene_end and scene_end.exists else "",
            "battle_ground": scene_end.name if scene_end and scene_end.exists else "",
            "rule": ("La cinématique, les dialogues, le déclenchement du combat, le combat et "
                     "sa conclusion se déroulent sur ce même Ground : aucune arène séparée, "
                     "aucune téléportation."),
        }

    # ---- narrative content that must follow the dungeon ------------------
    narrative: Dict[str, Any] = {"transferred": False, "cutscenes": [], "red_cinematics": [],
                                 "zone_script": ""}
    scene_asset_names = []
    curated_scene = END_GROUND.get(slug)
    if curated_scene:
        scene_asset_names.append(curated_scene)
    if scene_set:
        for asset in [scene_set.entrance, scene_set.relay, *scene_set.end]:
            if asset and asset.name:
                scene_asset_names.append(asset.name)
    for asset_name in sorted(set(scene_asset_names)):
        # the live script tree wins; the archive is only listed when nothing is live
        live = ROOT / "Data" / "Script" / "halcyon" / "ground" / asset_name
        archived = ROOT / "RESERVE" / "scripts_ground" / asset_name
        if live.is_dir():
            narrative["cutscenes"].append({"scene": asset_name, "state": "active",
                                           "path": str(live.relative_to(ROOT))})
        elif archived.is_dir():
            narrative["cutscenes"].append({"scene": asset_name, "state": "archived",
                                           "path": str(archived.relative_to(ROOT)),
                                           "restore_to": f"Data/Script/halcyon/ground/{asset_name}"})
    zone_script = ROOT / "Data" / "Script" / "halcyon" / "zone" / definition["id"]
    if zone_script.is_dir():
        narrative["zone_script"] = str(zone_script.relative_to(ROOT))
    if scene_set and scene_set.code:
        for cif in sorted((ROOT / "RESERVE" / "red_cinematics").glob(
                f"{scene_set.code.lower()}p*.cif.json")):
            narrative["red_cinematics"].append(str(cif.relative_to(ROOT)))
    has_content = bool(narrative["cutscenes"] or narrative["zone_script"])
    scripts_live = has_content and all(entry["state"] == "active"
                                       for entry in narrative["cutscenes"])
    unported = [c for c in narrative["red_cinematics"]
                if not narrative["cutscenes"] and not narrative["zone_script"]]
    narrative["pending_cinematics"] = unported
    narrative["transferred"] = scripts_live and not unported
    if narrative["transferred"]:
        narrative["transfer_check"] = ("every cutscene folder is live under Data/Script/halcyon "
                                       "and is replayed on the canonical Ground")
    elif not scripts_live:
        narrative["transfer_check"] = "some cutscene folders are still archived"
    else:
        narrative["transfer_check"] = ("PMD Red cinematic IR not ported to Lua yet: "
                                       + ", ".join(unported))
    if narrative["cutscenes"] or narrative["red_cinematics"] or narrative["zone_script"]:
        narrative["rule"] = ("Ces séquences appartiennent au donjon : elles sont reprises par le "
                             "nouveau pipeline et rejouées sur le Ground canonique "
                             "(cinématique = combat = fin).")
        definition["narrative"] = narrative

    # ---- fixed grounds / boss -------------------------------------------
    candidates = []
    aliases = {slug, definition["id"], *definition.get("aliases", [])}
    for name in sorted(ground_names):
        for base_name in aliases:
            if name.startswith(base_name):
                suffix = name[len(base_name):].strip("_")
                if suffix and any(re.fullmatch(rf"{s}\d*", suffix) for s in END_SUFFIXES):
                    candidates.append(name)
                    break
    curated_end = END_GROUND.get(slug)
    if curated_end:
        located = locate_scene(curated_end)
        if located.exists and curated_end not in candidates and located.state == "ACTIVE_GROUND":
            candidates.insert(0, curated_end)
        elif located.exists and not scene_end:
            scene_end, (scene_state, scene_reason) = located, readiness(located)
    if SCENE_CANDIDATES.get(slug):
        definition["scene_candidates"] = {
            "note": ("scènes possiblement canoniques repérées dans le dépôt : arbitrage humain "
                     "requis avant toute création d'arène"),
            "candidates": SCENE_CANDIDATES[slug]}
    if scene_end and scene_end.state == ACTIVE_GROUND and scene_end.name not in candidates:
        candidates.insert(0, scene_end.name)
    fixed: Dict[str, str] = {}
    # relay/midpoint Ground harvested from the legacy implementation
    for ground in legacy.get("grounds", []):
        if ground.endswith("_midpoint") and ground in ground_names:
            fixed["mid"] = ground
    entrance = ENTRANCE_GROUND.get(slug, f"{slug}_entrance")
    if scene_set and scene_set.entrance and scene_set.entrance.state == ACTIVE_GROUND:
        entrance = scene_set.entrance.name
    if entrance in ground_names:
        fixed["entrance"] = entrance
    boss_name = row["boss"]
    boss: Dict[str, Any] = {}
    if candidates:
        fixed["end"] = candidates[0]
        boss = {"mode": "canonical_ground", "ground": candidates[0],
                "notes": "Ground de fin canonique existant : le combat final s'y déroule, "
                         "aucune arène séparée."}
        rsmap = f"{candidates[0]}"
        if rsmap in map_names:
            boss["map"] = rsmap
    elif scene_end and scene_end.exists:
        # the canonical scene exists but is not a live Ground yet: it must be
        # integrated as-is, never replaced by a separate arena
        boss = {"mode": "canonical_ground", "ground": scene_end.name,
                "pending_integration": True, "source_asset": scene_end.location,
                "notes": ("Scène canonique existante : à intégrer telle quelle comme Ground de "
                          "cinématique ET de combat ; aucune arène séparée.")}
        blocked.append(f"BLOCKED/{scene_reason}")
    elif boss_name and boss_name not in ("", "—"):
        arena = f"{slug}_arena"
        in_dungeon = IN_DUNGEON_BOSS.get(slug)
        boss = {"mode": "arena_rsmap", "map": arena,
                "arena_kind": "in_dungeon_fixed_room" if in_dungeon else "dedicated_arena",
                "notes": ("Aucune scène canonique (actif ni archive) : le combat canonique se "
                          "déroule à l'intérieur du donjon (dialogue de boss en donjon), la salle "
                          "fixe .rsmap est donc l'implémentation correcte."
                          if in_dungeon else
                          "Aucune scène canonique dans l'inventaire PMD Red : arène dédiée à "
                          "créer, puis à raccorder au narratif du donjon.")}
        if in_dungeon and FIXED_BOSS_ROOM.get(slug) in map_names:
            boss["floor"] = total_floors
            boss["fixed_room"] = FIXED_BOSS_ROOM[slug]
        if in_dungeon:
            boss["canonical_evidence"] = {
                "source": "pret/pmd-red src/dungeon_boss_dialogue.c",
                "symbols": in_dungeon[1],
                "conclusion": ("rencontre en donjon, aucun Ground de cinématique dans la source "
                               "(les archives PMD Red ne couvrent que D01–D25)")}
            definition.setdefault("scene_candidates", {})["rejected_reason"] = (
                "aucun de ces Grounds n'est la scène canonique de ce donjon : la source ne fournit "
                "aucun Ground pour lui et le combat est scripté en donjon")
        if arena not in map_names:
            blocked.append(f"BLOCKED/MISSING_ASSET: arena '{arena}.rsmap' must be authored before "
                           "the boss scene can be converted to a Ground")
    if boss and boss_name and boss_name not in ("", "—"):
        species = BOSS_SPECIES.get(boss_name)
        if species:
            boss["roster"] = [{"species": species,
                               "level": [definition["level"] + 10, definition["level"] + 10],
                               "role": "leader"}]
        else:
            blocked.append(f"BLOCKED/MISSING_SOURCE: boss '{boss_name}' has no species mapping")
    if boss:
        definition["boss"] = boss
    definition["fixed_grounds"] = fixed

    if total_floors >= 12 and definition["route"] == "main":
        definition["midpoint"] = {
            "floor": total_floors // 2,
            "template": "searing_tunnel_midpoint",
            "retexture": setup.get("tileset") or "",
            "sheet": "",
            "checkpoint": True, "heal": True, "save": True, "rest": True,
            "statue": "kangaskhan",
            "required_objects": ["Kangaskhan_Rock", "North_Exit", "South_Exit"],
            "notes": "Ground fixe à produire via `dungeon_builder ground` ; jamais procédural.",
        }
        blocked.append("BLOCKED/MISSING_ASSET: midpoint Ground not produced yet "
                       "(needs a .tile sheet for this biome)")
    elif total_floors >= 12:
        definition["comment"] += (" Donjon secondaire : aucun relais/midpoint (règle du framework "
                                  "§1, réservés aux donjons d'histoire).")

    # A legacy implementation is not a reason to stop: the dungeon is in this
    # Builder's scope, so the old content is harvested, its narrative is
    # transferred, and the old files are deleted once the rebuild exists.
    zone_path = ZONE_DIR / f"{definition['id']}.json"
    zone_is_ours = zone_path.exists() and BUILDER_MARKER in zone_path.read_text(
        encoding="utf-8-sig")[:4000]
    if zone_is_ours:
        definition.setdefault("takeover", {}).update({
            "legacy_zone": f"Data/Zone/{definition['id']}.json",
            "status": "COMPLETED",
            "policy": "legacy implementation replaced by this Builder's regeneration"})
    else:
        if row["already_done"]:
            definition.setdefault("takeover", {}).update({
                "legacy": "imported by a previous agent (Sky Tower arc)",
                "status": "PENDING",
                "policy": "rebuild then remove the legacy implementation"})
            blocked.append("BLOCKED/TAKEOVER_PENDING: legacy implementation from a previous agent "
                           "must be rebuilt by this Builder, then deleted")
        if definition["id"] in zone_names and definition["id"] != "gloomy_forest":
            definition.setdefault("takeover", {}).update({
                "legacy_zone": f"Data/Zone/{definition['id']}.json",
                "status": "PENDING",
                "policy": "rebuild then remove the legacy implementation"})
            blocked.append(
                f"BLOCKED/TAKEOVER_PENDING: legacy zone Data/Zone/{definition['id']}.json must be "
                "replaced by the Builder's regeneration (harvest + transfer first)")

    if blocked:
        definition["blocked"] = blocked
    return definition


def main(argv: Optional[Sequence[str]] = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--source", required=True, help="path to a pret/pmd-red checkout")
    parser.add_argument("--only", default=None)
    parser.add_argument("--out", default=str(OUT_DIR))
    parser.add_argument("--dry-run", action="store_true")
    args = parser.parse_args(argv)

    source = CanonicalSource(Path(args.source).expanduser())
    inventory = parse_inventory()
    conversion = load_item_conversion()
    prices = known_items()
    tilesets = base_tilesets() | {p.stem for p in (ROOT / "Data" / "AutoTile").glob("*.json")}
    ground_names = {p.stem for p in GROUND_DIR.glob("*.rsground")}
    map_names = {p.stem for p in MAP_DIR.glob("*.rsmap")}
    zone_names = {p.stem for p in ZONE_DIR.glob("*.json")}

    out_dir = Path(args.out)
    out_dir.mkdir(parents=True, exist_ok=True)
    rows = parse_roster()
    print(f"roster: {len(rows)} dungeons")
    written = 0
    for row in rows:
        slug = slugify(row["name"])
        if args.only and args.only not in (slug, row["name"]):
            continue
        if slug == "sinister_woods":
            print(f"  = {slug}: kept as-is (validated reference dungeon)")
            continue
        definition = build_definition(row, source, conversion, prices, tilesets,
                                      ground_names, map_names, zone_names, inventory)
        path = out_dir / f"{slug}.json"
        if not args.dry_run:
            path.write_text(json.dumps(definition, ensure_ascii=False, indent=2) + "\n",
                            encoding="utf-8")
        written += 1
        flag = "BLOCKED" if definition.get("blocked") else "ok"
        print(f"  + {slug:20s} ch{row['chapter']:<3d} {definition.get('floors', 0):>3d}F  {flag}")
    print(f"{written} definitions written to {out_dir}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
