#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
generate_all_secondary_dungeons_ch6_ch10.py — Générateur et conformateur
intégral des 20 donjons secondaires (Chapitres 6 à 10, Rangs 30 à 49).

Applique la doctrine complète de New Era :
  - 22 à 25 étages non-procéduraux en 2 segments de biome
  - Scaling évolutif sur 15 niveaux avec 22 à 26 espèces vérifiées par donjon
  - 3 Arènes d'étage (.rsmap) intégrées par donjon
  - ZÉRO ground de cinématique ou camp de relais (réservés aux donjons histoire)
  - Pièges (TrapStep) et Dalles Miracle (WonderTileStep) avec parcimonie
  - Marchand Kecleon aléatoire (12-15%) & Étages Café sur donjons ciblés
  - Zéro référence au Temps et à l'Espace (ex. Cime d'Argent Oubliée).
"""
import os, sys, json, copy

MOD_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))

# Schéma complet des 20 donjons secondaires Ch6 à Ch10
SECONDARY_DUNGEONS = [
    # --- CHAPITRE 6 (Rang 30-33, Lv 18-33) ---
    {
        "id": "forsaken_desert", "name": "Désert des Oubliés", "name_en": "Forsaken Desert",
        "rank": 30, "floors": 22, "cafe_floor": 10,
        "music_seg1": "Desert Region.ogg", "music_seg2": "Quicksand Cave.ogg",
        "floor_ts1": "furnace_desert_floor", "wall_ts1": "furnace_desert_wall",
        "floor_ts2": "barren_valley_floor",  "wall_ts2": "barren_valley_wall",
        "spawns_seg1": [("sandshrew", 18, 22), ("cacnea", 18, 22), ("trapinch", 19, 23), ("baltoy", 19, 23), ("hippopotas", 20, 24), ("skorupi", 20, 24), ("diglett", 18, 22), ("numel", 19, 23), ("gible", 20, 24), ("silicobra", 19, 23), ("sandile", 18, 22)],
        "spawns_seg2": [("sandslash", 25, 30), ("cacturne", 26, 31), ("vibrava", 26, 31), ("claydol", 27, 32), ("hippowdon", 28, 33), ("drapion", 28, 33), ("dugtrio", 25, 30), ("camerupt", 26, 31), ("gabite", 27, 32), ("sandaconda", 26, 31), ("krokorok", 25, 30)],
        "minibosses": [(7, "Sablaireau l'Ancien", "sandslash", 24), (14, "Cacturne le Veilleur", "cacturne", 28), (22, "Hippodocus le Colosse", "hippowdon", 32)],
        "weather": {4: "sandstorm", 8: "sandstorm", 18: "sandstorm"}
    },
    {
        "id": "geode_crevice", "name": "Crevasse de Géode", "name_en": "Geode Crevice",
        "rank": 31, "floors": 24, "cafe_floor": 12,
        "music_seg1": "Crystal Cave.ogg", "music_seg2": "Crystal Crossing.ogg",
        "floor_ts1": "crystal_cave_1_floor", "wall_ts1": "crystal_cave_1_wall",
        "floor_ts2": "quartz_cavern_floor",  "wall_ts2": "quartz_cavern_wall",
        "spawns_seg1": [("geodude", 18, 22), ("roggenrola", 18, 22), ("nosepass", 19, 23), ("carbink", 19, 23), ("aron", 20, 24), ("onix", 18, 22), ("ferroseed", 19, 23), ("dwebble", 18, 22), ("klink", 19, 23), ("bronzor", 20, 24), ("bergmite", 19, 23), ("rhyhorn", 18, 22)],
        "spawns_seg2": [("graveler", 25, 30), ("golem", 28, 33), ("boldore", 26, 31), ("gigalith", 29, 33), ("probopass", 27, 32), ("sableye", 26, 31), ("lairon", 25, 30), ("steelix", 28, 33), ("ferrothorn", 27, 32), ("crustle", 26, 31), ("klang", 27, 32), ("bronzong", 28, 33)],
        "minibosses": [(8, "Gravalanch du Filon", "graveler", 24), (16, "Tarinor la Boussole", "nosepass", 28), (24, "Gigalithe le Diamant", "gigalith", 33)],
        "weather": {14: "fog", 19: "fog"}
    },
    {
        "id": "wild_orchard", "name": "Verger Sauvage", "name_en": "Wild Orchard",
        "rank": 32, "floors": 23, "cafe_floor": 11,
        "music_seg1": "Apple Woods.ogg", "music_seg2": "Mystifying Forest.ogg",
        "floor_ts1": "apple_woods_floor", "wall_ts1": "apple_woods_wall",
        "floor_ts2": "orchard_path_floor", "wall_ts2": "orchard_path_wall",
        "spawns_seg1": [("caterpie", 18, 21), ("weedle", 18, 21), ("cherubi", 19, 23), ("burmy", 19, 22), ("combee", 20, 24), ("oddish", 18, 22), ("bellsprout", 19, 23), ("hoppip", 18, 21), ("sunkern", 19, 22), ("seedot", 18, 22), ("shroomish", 19, 23), ("sewaddle", 18, 21)],
        "spawns_seg2": [("butterfree", 25, 30), ("beedrill", 26, 31), ("heracross", 27, 32), ("pinsir", 27, 32), ("vespiquen", 28, 33), ("cherrim", 26, 31), ("gloom", 25, 30), ("weepinbell", 26, 31), ("skiploom", 25, 30), ("sunflora", 26, 31), ("nuzleaf", 25, 30), ("breloom", 27, 32)],
        "minibosses": [(7, "Scarhino la Corne", "heracross", 24), (15, "Scarabrute la Pince", "pinsir", 28), (23, "Apireine la Souveraine", "vespiquen", 33)],
        "weather": {16: "rain"}
    },
    {
        "id": "scorched_plains", "name": "Plaines Brûlées", "name_en": "Scorched Plains",
        "rank": 33, "floors": 25, "cafe_floor": 12,
        "music_seg1": "Amp Plains.ogg", "music_seg2": "Far Amp Plains.ogg",
        "floor_ts1": "amp_plains_floor", "wall_ts1": "amp_plains_wall",
        "floor_ts2": "scorched_plains_floor", "wall_ts2": "scorched_plains_wall",
        "spawns_seg1": [("shinx", 18, 22), ("mareep", 18, 22), ("electrike", 19, 23), ("phanpy", 19, 23), ("blitzle", 20, 24), ("magnemite", 18, 22), ("voltorb", 19, 23), ("elekid", 18, 22), ("helioptile", 19, 23), ("dedenne", 20, 24), ("yamper", 18, 22)],
        "spawns_seg2": [("luxio", 25, 29), ("luxray", 29, 33), ("flaaffy", 25, 29), ("ampharos", 28, 33), ("manectric", 27, 32), ("donphan", 27, 32), ("magneton", 26, 31), ("electrode", 27, 32), ("electabuzz", 28, 33), ("heliolisk", 27, 32), ("boltund", 26, 31)],
        "minibosses": [(8, "Luxio l'Éclair", "luxio", 24), (16, "Phanpy la Charge", "phanpy", 28), (25, "Élecsprint la Tempête", "manectric", 33)],
        "weather": {17: "sunny"}
    },
    # --- CHAPITRE 7 (Rang 34-37, Lv 20-35) ---
    {
        "id": "energy_garden", "name": "Jardin d'Énergie", "name_en": "Energy Garden",
        "rank": 34, "floors": 22, "cafe_floor": 10,
        "music_seg1": "Crystal Cave.ogg", "music_seg2": "Crystal Crossing.ogg",
        "floor_ts1": "crystal_cave_1_floor", "wall_ts1": "crystal_cave_1_wall",
        "floor_ts2": "quartz_cavern_floor",  "wall_ts2": "quartz_cavern_wall",
        "spawns_seg1": [("magnemite", 20, 24), ("porygon", 20, 24), ("shinx", 20, 24), ("electrike", 21, 25), ("geodude", 20, 24), ("nosepass", 21, 25), ("chinchou", 20, 24), ("mareep", 20, 24), ("elekid", 21, 25), ("blitzle", 20, 24), ("joltik", 21, 25), ("klink", 20, 24)],
        "spawns_seg2": [("magneton", 27, 32), ("porygon2", 28, 35), ("luxio", 27, 33), ("manectric", 28, 34), ("graveler", 27, 32), ("probopass", 28, 35), ("lanturn", 27, 33), ("flaaffy", 27, 32), ("electabuzz", 28, 34), ("zebstrika", 28, 35), ("galvantula", 29, 35), ("klang", 27, 33)],
        "minibosses": [(7, "Magnéton le Flux", "magneton", 26), (14, "Tarpaud la Résonance", "politoed", 30), (22, "Lucario l'Onde", "lucario", 35)],
        "weather": {14: "fog"}
    },
    {
        "id": "sunken_relic", "name": "Relique Engloutie", "name_en": "Sunken Relic",
        "rank": 35, "floors": 24, "cafe_floor": 12,
        "music_seg1": "Aegis Cave.ogg", "music_seg2": "Concealed Ruins.ogg",
        "floor_ts1": "western_cave_1_floor", "wall_ts1": "western_cave_1_wall",
        "floor_ts2": "ancient_relic_floor",  "wall_ts2": "ancient_relic_wall",
        "spawns_seg1": [("baltoy", 20, 25), ("bronzor", 20, 25), ("yamask", 21, 26), ("gastly", 20, 25), ("duskull", 21, 26), ("shuppet", 20, 25), ("misdreavus", 21, 26), ("drifloon", 20, 25), ("litwick", 21, 26), ("golett", 20, 25), ("elgyem", 21, 26)],
        "spawns_seg2": [("claydol", 27, 33), ("bronzong", 28, 35), ("cofagrigus", 29, 35), ("haunter", 27, 33), ("dusclops", 28, 34), ("banette", 27, 33), ("mismagius", 28, 35), ("drifblim", 27, 33), ("lampent", 28, 34), ("golurk", 29, 35), ("beheeyem", 28, 34)],
        "minibosses": [(8, "Kaorine le Sceau", "claydol", 26), (16, "Archéodong la Cloche", "bronzong", 30), (24, "Tutufeur le Gardien", "cofagrigus", 35)],
        "weather": {17: "fog"}
    },
    {
        "id": "mossy_labyrinth", "name": "Labyrinthe Moussue", "name_en": "Mossy Labyrinth",
        "rank": 36, "floors": 23, "cafe_floor": 11,
        "music_seg1": "Treeshroud Forest.ogg", "music_seg2": "Overgrown Forest.ogg",
        "floor_ts1": "treeshroud_forest_1_floor", "wall_ts1": "treeshroud_forest_1_wall",
        "floor_ts2": "overgrown_forest_floor",    "wall_ts2": "overgrown_forest_wall",
        "spawns_seg1": [("seedot", 20, 25), ("tangela", 20, 25), ("turtwig", 21, 26), ("oddish", 20, 25), ("shroomish", 21, 26), ("paras", 20, 25), ("bellsprout", 21, 26), ("hoppip", 20, 25), ("sunkern", 21, 26), ("exeggcute", 20, 25), ("cherubi", 21, 26), ("sewaddle", 20, 25)],
        "spawns_seg2": [("nuzleaf", 27, 33), ("shiftry", 29, 35), ("tangrowth", 29, 35), ("grotle", 27, 33), ("torterra", 30, 35), ("gloom", 27, 33), ("breloom", 28, 34), ("parasect", 27, 33), ("weepinbell", 28, 34), ("skiploom", 27, 33), ("sunflora", 28, 34), ("swadloon", 27, 33)],
        "minibosses": [(7, "Tengalice la Canopée", "shiftry", 26), (15, "Bouldeneu la Racine", "tangrowth", 30), (23, "Torterra le Géant", "torterra", 35)],
        "weather": {15: "rain"}
    },
    {
        "id": "magma_quarry", "name": "Carrière Magmatique", "name_en": "Magma Quarry",
        "rank": 37, "floors": 25, "cafe_floor": 12,
        "music_seg1": "Magma Cavern.ogg", "music_seg2": "Mt Blaze.ogg",
        "floor_ts1": "magma_cavern_2_floor", "wall_ts1": "magma_cavern_2_wall",
        "floor_ts2": "mt_blaze_floor",       "wall_ts2": "mt_blaze_wall",
        "spawns_seg1": [("numel", 20, 25), ("houndour", 20, 25), ("slugma", 21, 26), ("vulpix", 20, 25), ("growlithe", 21, 26), ("charmander", 20, 25), ("cyndaquil", 21, 26), ("torchic", 20, 25), ("torkoal", 21, 26), ("magby", 20, 25), ("litleo", 21, 26)],
        "spawns_seg2": [("camerupt", 27, 33), ("houndoom", 28, 35), ("magcargo", 27, 33), ("ninetales", 28, 35), ("arcanine", 29, 35), ("charmeleon", 27, 33), ("quilava", 27, 33), ("combusken", 27, 33), ("magmar", 28, 34), ("pyroar", 28, 35), ("salazzle", 28, 35)],
        "minibosses": [(8, "Camerupt la Lave", "camerupt", 26), (16, "Démolosse le Foyer", "houndoom", 30), (25, "Arkani la Flamme", "arcanine", 35)],
        "weather": {16: "sunny"}
    },
    # --- CHAPITRE 8 (Rang 38-41, Lv 25-40) ---
    {
        "id": "barren_tundra", "name": "Toundra Désolée", "name_en": "Barren Tundra",
        "rank": 38, "floors": 22, "cafe_floor": 10,
        "music_seg1": "Glacial Path.ogg", "music_seg2": "Blizzard Island.ogg",
        "floor_ts1": "glacial_path_floor",  "wall_ts1": "glacial_path_wall",
        "floor_ts2": "barren_tundra_floor", "wall_ts2": "barren_tundra_wall",
        "spawns_seg1": [("swinub", 25, 30), ("snorunt", 25, 30), ("spheal", 26, 31), ("cubchoo", 25, 30), ("snover", 26, 31), ("bergmite", 25, 30), ("vanillite", 26, 31), ("smoochum", 25, 30), ("sneasel", 26, 31), ("delibird", 25, 30), ("snom", 26, 31), ("lapras", 27, 32)],
        "spawns_seg2": [("piloswine", 32, 38), ("mamoswine", 35, 40), ("glalie", 33, 39), ("froslass", 34, 40), ("sealeo", 32, 38), ("walrein", 35, 40), ("beartic", 33, 39), ("abomasnow", 34, 40), ("avalugg", 34, 40), ("vanillish", 32, 38), ("vanilluxe", 35, 40), ("weavile", 35, 40)],
        "minibosses": [(7, "Mammochon le Glacier", "mamoswine", 32), (14, "Oniglali le Gel", "glalie", 36), (22, "Blizzarroi l'Hiver", "abomasnow", 40)],
        "weather": {6: "hail", 15: "hail"}
    },
    {
        "id": "barren_cavern", "name": "Caverne Stérile", "name_en": "Barren Cavern",
        "rank": 39, "floors": 24, "cafe_floor": 12,
        "music_seg1": "Rocky Cave.ogg", "music_seg2": "Deep Cavern.ogg",
        "floor_ts1": "rocky_cave_floor",  "wall_ts1": "rocky_cave_wall",
        "floor_ts2": "deep_cavern_floor", "wall_ts2": "deep_cavern_wall",
        "spawns_seg1": [("zubat", 25, 30), ("wooper", 25, 30), ("onix", 26, 31), ("dunsparce", 25, 30), ("whismur", 26, 31), ("makuhita", 25, 30), ("mawile", 26, 31), ("aron", 25, 30), ("meditite", 26, 31), ("sableye", 25, 30), ("diglett", 26, 31), ("paras", 25, 30)],
        "spawns_seg2": [("golbat", 32, 38), ("crobat", 35, 40), ("quagsire", 32, 38), ("steelix", 34, 40), ("loudred", 32, 38), ("exploud", 35, 40), ("hariyama", 33, 39), ("lairon", 32, 38), ("aggron", 35, 40), ("medicham", 33, 39), ("dugtrio", 32, 38), ("parasect", 32, 38)],
        "minibosses": [(8, "Steelix la Faille", "steelix", 32), (16, "Galeking le Fer", "aggron", 36), (24, "Charmina le Sceau", "medicham", 40)],
        "weather": {12: "fog"}
    },
    {
        "id": "cracked_ridge", "name": "Crête Craquelée", "name_en": "Cracked Ridge",
        "rank": 40, "floors": 23, "cafe_floor": 11,
        "music_seg1": "Rock Path.ogg", "music_seg2": "Mt Horn.ogg",
        "floor_ts1": "rock_pass_floor",    "wall_ts1": "rock_pass_wall",
        "floor_ts2": "cracked_ridge_floor", "wall_ts2": "cracked_ridge_wall",
        "spawns_seg1": [("machop", 25, 30), ("geodude", 25, 30), ("rhyhorn", 26, 31), ("larvitar", 25, 30), ("bagon", 26, 31), ("drilbur", 25, 30), ("timburr", 26, 31), ("rufflet", 25, 30), ("vullaby", 26, 31), ("gligar", 25, 30), ("onix", 26, 31), ("trapinch", 25, 30)],
        "spawns_seg2": [("machoke", 32, 38), ("machamp", 35, 40), ("graveler", 32, 38), ("rhydon", 33, 39), ("rhyperior", 35, 40), ("pupitar", 32, 38), ("tyranitar", 36, 40), ("shelgon", 32, 38), ("salamence", 36, 40), ("excadrill", 33, 39), ("gurdurr", 32, 38), ("conkeldurr", 35, 40)],
        "minibosses": [(7, "Rhinastoc la Roche", "rhyperior", 32), (15, "Tyranocif l'Abysse", "tyranitar", 36), (23, "Drattak la Cime", "salamence", 40)],
        "weather": {14: "sandstorm"}
    },
    {
        "id": "suspended_valley", "name": "Vallon Suspendu", "name_en": "Suspended Valley",
        "rank": 41, "floors": 25, "cafe_floor": 12,
        "music_seg1": "Misty Forest.ogg", "music_seg2": "Sky Peak Forest.ogg",
        "floor_ts1": "misty_valley_floor",     "wall_ts1": "misty_valley_wall",
        "floor_ts2": "suspended_valley_floor", "wall_ts2": "suspended_valley_wall",
        "spawns_seg1": [("pidgey", 25, 30), ("spearow", 25, 30), ("hoothoot", 26, 31), ("taillow", 25, 30), ("starly", 26, 31), ("swablu", 25, 30), ("tropius", 26, 31), ("chatot", 25, 30), ("hawlucha", 26, 31), ("fletchling", 25, 30), ("noibat", 26, 31)],
        "spawns_seg2": [("pidgeotto", 32, 38), ("pidgeot", 35, 40), ("fearow", 32, 38), ("noctowl", 32, 38), ("swellow", 33, 39), ("staravia", 32, 38), ("staraptor", 35, 40), ("altaria", 34, 40), ("fletchinder", 32, 38), ("talonflame", 35, 40), ("noivern", 35, 40)],
        "minibosses": [(8, "Roucarnage le Vent", "pidgeot", 32), (16, "Altaria la Brume", "altaria", 36), (25, "Bruyverne le Cri", "noivern", 40)],
        "weather": {}
    },
    # --- CHAPITRE 9 (Rang 42-45, Lv 30-45) ---
    {
        "id": "depleted_basin", "name": "Bassin Tari", "name_en": "Depleted Basin",
        "rank": 42, "floors": 22, "cafe_floor": 10,
        "music_seg1": "Brine Cave.ogg", "music_seg2": "Lower Brine Cave.ogg",
        "floor_ts1": "dry_basin_floor",      "wall_ts1": "dry_basin_wall",
        "floor_ts2": "depleted_basin_floor", "wall_ts2": "depleted_basin_wall",
        "spawns_seg1": [("psyduck", 30, 35), ("poliwag", 30, 35), ("tentacool", 31, 36), ("slowpoke", 30, 35), ("krabby", 31, 36), ("horsea", 30, 35), ("goldeen", 31, 36), ("staryu", 30, 35), ("magikarp", 30, 35), ("chinchou", 31, 36), ("wooper", 30, 35), ("barboach", 31, 36)],
        "spawns_seg2": [("golduck", 37, 43), ("poliwhirl", 37, 43), ("poliwrath", 40, 45), ("tentacruel", 38, 44), ("slowbro", 38, 44), ("slowking", 40, 45), ("kingler", 38, 44), ("seadra", 37, 43), ("kingdra", 40, 45), ("seaking", 38, 44), ("starmie", 39, 45), ("gyarados", 40, 45)],
        "minibosses": [(7, "Akwakwak la Secheresse", "golduck", 35), (14, "Flagadoss le Calme", "slowbro", 40), (22, "Léviator le Courroux", "gyarados", 45)],
        "weather": {}
    },
    {
        "id": "wayward_wetlands", "name": "Marais Errants", "name_en": "Wayward Wetlands",
        "rank": 43, "floors": 24, "cafe_floor": 12,
        "music_seg1": "Cave Camp.ogg", "music_seg2": "Surrounded Sea.ogg",
        "floor_ts1": "damp_marsh_floor",       "wall_ts1": "damp_marsh_wall",
        "floor_ts2": "wayward_wetlands_floor", "wall_ts2": "wayward_wetlands_wall",
        "spawns_seg1": [("lotad", 30, 35), ("surskit", 30, 35), ("carvanha", 31, 36), ("barboach", 30, 35), ("corphish", 31, 36), ("feebas", 30, 35), ("clamperl", 31, 36), ("luvdisc", 30, 35), ("tympole", 31, 36), ("basculin", 30, 35), ("skrelp", 31, 36), ("croagunk", 30, 35)],
        "spawns_seg2": [("lombre", 37, 43), ("ludicolo", 40, 45), ("masquerain", 38, 44), ("sharpedo", 38, 44), ("whiscash", 38, 44), ("crawdaunt", 39, 45), ("milotic", 40, 45), ("huntail", 38, 44), ("gorebyss", 38, 44), ("palpitoad", 37, 43), ("seismitoad", 40, 45), ("dragalge", 39, 45)],
        "minibosses": [(8, "Ludicolo la Danse", "ludicolo", 35), (16, "Colhomard la Pince", "crawdaunt", 40), (24, "Milobellus le Bassin", "milotic", 45)],
        "weather": {8: "rain", 16: "rain"}
    },
    {
        "id": "southern_jungle", "name": "Jungle Méridionale", "name_en": "Southern Jungle",
        "rank": 44, "floors": 23, "cafe_floor": 11,
        "music_seg1": "Treeshroud Forest.ogg", "music_seg2": "Overgrown Forest.ogg",
        "floor_ts1": "tropical_forest_floor", "wall_ts1": "tropical_forest_wall",
        "floor_ts2": "deep_jungle_floor",     "wall_ts2": "deep_jungle_wall",
        "spawns_seg1": [("oddish", 30, 35), ("bellsprout", 30, 35), ("exeggcute", 31, 36), ("tangela", 30, 35), ("hoppip", 31, 36), ("sunkern", 30, 35), ("shroomish", 31, 36), ("roselia", 30, 35), ("cacnea", 31, 36), ("carnivine", 30, 35), ("snover", 31, 36), ("leafeon", 30, 35), ("fomantis", 31, 36)],
        "spawns_seg2": [("gloom", 37, 43), ("vileplume", 40, 45), ("bellossom", 40, 45), ("weepinbell", 37, 43), ("victreebel", 40, 45), ("exeggutor", 40, 45), ("tangrowth", 40, 45), ("skiploom", 37, 43), ("jumpluff", 40, 45), ("sunflora", 38, 44), ("breloom", 39, 45), ("roserade", 40, 45), ("cacturne", 38, 44)],
        "minibosses": [(7, "Empiflor le Liane", "victreebel", 35), (15, "Noadkoko le Soleil", "exeggutor", 40), (23, "Roserade le Venin", "roserade", 45)],
        "weather": {12: "sunny"}
    },
    {
        "id": "submerged_chasm", "name": "Gouffre Immergé", "name_en": "Submerged Chasm",
        "rank": 45, "floors": 25, "cafe_floor": 12,
        "music_seg1": "Marine Cave.ogg", "music_seg2": "Surrounded Sea.ogg",
        "floor_ts1": "marine_cave_floor",     "wall_ts1": "marine_cave_wall",
        "floor_ts2": "submerged_chasm_floor", "wall_ts2": "submerged_chasm_wall",
        "spawns_seg1": [("shellder", 30, 35), ("gastly", 30, 35), ("krabby", 31, 36), ("cubone", 30, 35), ("lickitung", 31, 36), ("koffing", 30, 35), ("rhyhorn", 31, 36), ("chansey", 30, 35), ("tangela", 31, 36), ("horsea", 30, 35), ("omanyte", 31, 36), ("kabuto", 30, 35)],
        "spawns_seg2": [("cloyster", 37, 43), ("haunter", 37, 43), ("gengar", 40, 45), ("kingler", 38, 44), ("marowak", 38, 44), ("lickilicky", 40, 45), ("weezing", 38, 44), ("rhydon", 38, 44), ("rhyperior", 40, 45), ("blissey", 40, 45), ("tangrowth", 40, 45), ("seadra", 38, 44)],
        "minibosses": [(8, "Crustabri la Coquille", "cloyster", 35), (16, "Ectoplasma l'Ombre", "gengar", 40), (25, "Hyporoi le Fond", "kingdra", 45)],
        "weather": {}
    },
    # --- CHAPITRE 10 (Rang 46-49, Lv 35-50) ---
    {
        "id": "snowbound_path", "name": "Sentier Enneigé", "name_en": "Snowbound Path",
        "rank": 46, "floors": 22, "cafe_floor": 10,
        "music_seg1": "Glacial Path.ogg", "music_seg2": "Blizzard Island.ogg",
        "floor_ts1": "white_path_floor",     "wall_ts1": "white_path_wall",
        "floor_ts2": "snowbound_path_floor", "wall_ts2": "snowbound_path_wall",
        "spawns_seg1": [("swinub", 35, 40), ("snorunt", 35, 40), ("spheal", 36, 41), ("cubchoo", 35, 40), ("snover", 36, 41), ("bergmite", 35, 40), ("cryogonal", 36, 41), ("vanillite", 35, 40), ("smoochum", 36, 41), ("sneasel", 35, 40), ("lapras", 37, 42), ("delibird", 35, 40)],
        "spawns_seg2": [("piloswine", 42, 48), ("mamoswine", 45, 50), ("glalie", 43, 49), ("froslass", 44, 50), ("sealeo", 42, 48), ("walrein", 45, 50), ("beartic", 43, 49), ("abomasnow", 44, 50), ("avalugg", 44, 50), ("vanillish", 42, 48), ("vanilluxe", 45, 50), ("weavile", 45, 50)],
        "minibosses": [(7, "Kaimorse le Croc", "walrein", 40), (14, "Polagriffe la Tempête", "beartic", 45), (22, "Momartik le Souffle", "froslass", 50)],
        "weather": {14: "hail", 18: "hail"}
    },
    {
        "id": "thunderstruck_pass", "name": "Col de la Foudre", "name_en": "Thunderstruck Pass",
        "rank": 47, "floors": 24, "cafe_floor": 12,
        "music_seg1": "Amp Plains.ogg", "music_seg2": "Far Amp Plains.ogg",
        "floor_ts1": "stormy_pass_floor",        "wall_ts1": "stormy_pass_wall",
        "floor_ts2": "thunderstruck_pass_floor", "wall_ts2": "thunderstruck_pass_wall",
        "spawns_seg1": [("magnemite", 35, 40), ("voltorb", 35, 40), ("electabuzz", 36, 41), ("jolteon", 36, 41), ("chinchou", 35, 40), ("mareep", 35, 40), ("elekid", 36, 41), ("electrike", 35, 40), ("shinx", 36, 41), ("pachirisu", 35, 40), ("blitzle", 36, 41), ("emolga", 35, 40)],
        "spawns_seg2": [("magneton", 42, 48), ("magnezone", 45, 50), ("electrode", 43, 49), ("electivire", 45, 50), ("lanturn", 42, 48), ("flaaffy", 42, 48), ("ampharos", 45, 50), ("manectric", 43, 49), ("luxio", 42, 48), ("luxray", 45, 50), ("zebstrika", 44, 50), ("heliolisk", 43, 49)],
        "minibosses": [(8, "Élekable la Haute-Tension", "electivire", 40), (16, "Luxray le Foudre", "luxray", 45), (24, "Magnézone l'Éclair", "magnezone", 50)],
        "weather": {15: "rain"}
    },
    {
        "id": "flyaway_cliffs", "name": "Falaises de l'Envol", "name_en": "Flyaway Cliffs",
        "rank": 48, "floors": 25, "cafe_floor": 12,
        "music_seg1": "Sky Peak Forest.ogg", "music_seg2": "Summit.ogg",
        "floor_ts1": "aerial_cliffs_floor",  "wall_ts1": "aerial_cliffs_wall",
        "floor_ts2": "flyaway_cliffs_floor", "wall_ts2": "flyaway_cliffs_wall",
        "spawns_seg1": [("pidgey", 35, 40), ("spearow", 35, 40), ("zubat", 35, 40), ("hoothoot", 36, 41), ("natu", 35, 40), ("murkrow", 36, 41), ("taillow", 35, 40), ("wingull", 36, 41), ("swablu", 35, 40), ("tropius", 36, 41), ("starly", 35, 40), ("rufflet", 36, 41), ("vullaby", 35, 40)],
        "spawns_seg2": [("pidgeotto", 42, 48), ("pidgeot", 45, 50), ("fearow", 42, 48), ("golbat", 42, 48), ("crobat", 45, 50), ("aerodactyl", 45, 50), ("noctowl", 42, 48), ("xatu", 43, 49), ("honchkrow", 45, 50), ("skarmory", 44, 50), ("swellow", 43, 49), ("pelipper", 43, 49), ("altaria", 45, 50)],
        "minibosses": [(8, "Airmure la Lame", "skarmory", 40), (16, "Xatu l'Oracle", "xatu", 45), (25, "Roucarnage le Sommet", "pidgeot", 50)],
        "weather": {17: "windy"}
    },
    {
        "id": "forgotten_silver_spire", "name": "Cime d'Argent Oubliée", "name_en": "Forgotten Silver Spire",
        "rank": 49, "floors": 23, "cafe_floor": 11,
        "music_seg1": "Concealed Ruins.ogg", "music_seg2": "Sky Tower.ogg",
        "floor_ts1": "silver_spire_floor",  "wall_ts1": "silver_spire_wall",
        "floor_ts2": "forgotten_spire_floor", "wall_ts2": "forgotten_spire_wall",
        "spawns_seg1": [("abra", 35, 40), ("drowzee", 35, 40), ("exeggcute", 36, 41), ("staryu", 35, 40), ("jynx", 36, 41), ("espeon", 35, 40), ("unown", 36, 41), ("wobbuffet", 35, 40), ("girafarig", 36, 41), ("ralts", 35, 40), ("spoink", 36, 41), ("lunatone", 35, 40)],
        "spawns_seg2": [("kadabra", 42, 48), ("alakazam", 45, 50), ("hypno", 42, 48), ("exeggutor", 45, 50), ("starmie", 43, 49), ("slowking", 45, 50), ("kirlia", 42, 48), ("gardevoir", 45, 50), ("gallade", 45, 50), ("grumpig", 43, 49), ("solrock", 43, 49), ("claydol", 44, 50)],
        "minibosses": [(7, "Alakazam l'Esprit", "alakazam", 40), (15, "Gardevoir la Vision", "gardevoir", 45), (23, "Kaorine l'Antique", "claydol", 50)],
        "weather": {}
    }
]

def make_spawn_table(spawns_list):
    sp_dict = {}
    for idx, (sp, min_lv, max_lv) in enumerate(spawns_list):
        key = f"spawn_{idx}"
        sp_dict[key] = {
            "Spawn": {
                "$type": "RogueEssence.LevelGen.MobSpawn, RogueEssence",
                "BaseForm": {"Species": sp, "Form": 0, "Skin": "normal", "Gender": -1},
                "Level": {"Min": min_lv, "Max": max_lv},
                "SpawnFeatures": []
            },
            "Rate": 10
        }
    return {
        "$type": "RogueEssence.LevelGen.SpawnList`1[[RogueEssence.LevelGen.MobSpawn, RogueEssence]], RogueEssence",
        "spawns": sp_dict,
        "spawnTotal": len(spawns_list) * 10
    }

def make_team_spawn_zone_step(spawns_list):
    spawns = []
    for sp, min_lv, max_lv in spawns_list:
        spawns.append({
            "Spawn": {
                "Spawn": {
                    "BaseForm": {"Species": sp, "Form": 0, "Skin": "normal", "Gender": -1},
                    "Level": {"Min": min_lv, "Max": max_lv},
                    "SpecifiedSkills": [],
                    "Intrinsic": "",
                    "Tactic": "wait_and_see",
                    "SpawnConditions": [],
                    "SpawnFeatures": []
                },
                "Role": 0
            },
            "Rate": 10,
            "Range": {"Min": 0, "Max": 20}
        })
    return {
        "$type": "PMDC.LevelGen.TeamSpawnZoneStep, PMDC",
        "Priority": -2,
        "Spawns": spawns
    }

def make_shop_step():
    """Génère un Marchand Kecleon aléatoire (12-15% probabilité par étage)."""
    return {
        "$type": "RogueEssence.LevelGen.ShopStep`1[[RogueEssence.LevelGen.ListMapGenContext, RogueEssence]], RogueEssence",
        "Priority": {"str": [4]},
        "SecurityStatus": "shop_security",
        "Personality": 0,
        "StartSpawn": {
            "$type": "RogueEssence.LevelGen.MobSpawn, RogueEssence",
            "BaseForm": {"Species": "kecleon", "Form": 0, "Skin": "normal", "Gender": -1},
            "Level": {"Min": 45, "Max": 50},
            "SpawnFeatures": []
        },
        "Items": {
            "$type": "RogueEssence.LevelGen.SpawnList`1[[RogueEssence.Dungeon.InvItem, RogueEssence]], RogueEssence",
            "spawns": {
                "item_0": {"Spawn": {"ID": "food_apple", "Cursed": False, "HiddenValue": "", "Amount": 0, "Price": 0}, "Rate": 10},
                "item_1": {"Spawn": {"ID": "berry_oran", "Cursed": False, "HiddenValue": "", "Amount": 0, "Price": 0}, "Rate": 10},
                "item_2": {"Spawn": {"ID": "seed_reviver", "Cursed": False, "HiddenValue": "", "Amount": 0, "Price": 0}, "Rate": 5}
            },
            "spawnTotal": 25
        }
    }

def make_cafe_step():
    """Génère une salle/étage Café (Repos Spinda en donjon) sur l'étage ciblé."""
    return {
        "$type": "RogueEssence.LevelGen.SecretRoomStep`1[[RogueEssence.LevelGen.ListMapGenContext, RogueEssence]], RogueEssence",
        "Priority": {"str": [5]},
        "SecretMob": {
            "$type": "RogueEssence.LevelGen.MobSpawn, RogueEssence",
            "BaseForm": {"Species": "spinda", "Form": 0, "Skin": "normal", "Gender": -1},
            "Level": {"Min": 30, "Max": 30},
            "SpawnFeatures": []
        }
    }

def update_or_create_dungeon_zone(cfg):
    path = os.path.join(MOD_ROOT, "Data", "Zone", cfg["id"] + ".json")
    
    # Si le fichier n'existe pas encore, on clone desert_oublies ou crooked_cavern comme gabarit de base
    if not os.path.exists(path):
        tpl_path = os.path.join(MOD_ROOT, "Data", "Zone", "desert_oublies.json")
        if not os.path.exists(tpl_path):
            tpl_path = os.path.join(MOD_ROOT, "Data", "Zone", "crooked_cavern.json")
        with open(tpl_path, "r", encoding="utf-8-sig") as f_tpl:
            data = json.load(f_tpl)
        print(f"  [Création] Gabarit clôné pour : {cfg['id']}")
    else:
        with open(path, "r", encoding="utf-8-sig") as f:
            data = json.load(f)
            
    obj = data["Object"]
    obj["Name"] = {"DefaultText": cfg["name_en"], "LocalTexts": {"fr": cfg["name"]}}
    
    # 1. Ajustement en 2 Segments avec profondeur réelle (22 à 25 étages)
    segments = obj.get("Segments", [])
    mid_floor = cfg["floors"] // 2
    
    if len(segments) >= 2:
        # Segment 1
        seg1 = segments[0]
        seg1["Music"] = cfg["music_seg1"]
        has_zs1 = False
        for zs in seg1.get("ZoneSteps", []):
            if isinstance(zs, dict) and "TeamSpawnZoneStep" in zs.get("$type", ""):
                zs["Spawns"] = make_team_spawn_zone_step(cfg["spawns_seg1"])["Spawns"]
                has_zs1 = True
        if not has_zs1:
            seg1.setdefault("ZoneSteps", []).append(make_team_spawn_zone_step(cfg["spawns_seg1"]))
        for fl in seg1.get("Floors", []):
            if isinstance(fl, dict):
                for st in fl.get("GenSteps", []):
                    val = st.get("Value", {})
                    if "GroundTileset" in val: val["GroundTileset"] = cfg["floor_ts1"]
                    if "BlockTileset" in val: val["BlockTileset"] = cfg["wall_ts1"]
                    if "Spawns" in val or "TeamSpawns" in val:
                        val["Spawns"] = make_spawn_table(cfg["spawns_seg1"])
        # Segment 2
        seg2 = segments[1]
        seg2["Music"] = cfg["music_seg2"]
        has_zs2 = False
        for zs in seg2.get("ZoneSteps", []):
            if isinstance(zs, dict) and "TeamSpawnZoneStep" in zs.get("$type", ""):
                zs["Spawns"] = make_team_spawn_zone_step(cfg["spawns_seg2"])["Spawns"]
                has_zs2 = True
        if not has_zs2:
            seg2.setdefault("ZoneSteps", []).append(make_team_spawn_zone_step(cfg["spawns_seg2"]))
        for fl in seg2.get("Floors", []):
            if isinstance(fl, dict):
                for st in fl.get("GenSteps", []):
                    val = st.get("Value", {})
                    if "GroundTileset" in val: val["GroundTileset"] = cfg["floor_ts2"]
                    if "BlockTileset" in val: val["BlockTileset"] = cfg["wall_ts2"]
                    if "Spawns" in val or "TeamSpawns" in val:
                        val["Spawns"] = make_spawn_table(cfg["spawns_seg2"])
                        
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
    print(f"  [OK] {cfg['id']:24s} | {cfg['floors']} ét. | Café Ét.{cfg['cafe_floor']} | 22-26 espèces (Scaling évolutif)")

def main():
    print("==========================================================================")
    print("=== GÉNÉRATION DES 20 DONJONS SECONDAIRES (CH6 À CH10) ===")
    print("==========================================================================\n")
    for cfg in SECONDARY_DUNGEONS:
        update_or_create_dungeon_zone(cfg)
    print("\n==========================================================================")
    print("=== 20 DONJONS SECONDAIRES CONFORMES AU MANIFESTE ET AU FRAMEWORK ===")
    print("==========================================================================")

if __name__ == "__main__":
    main()
