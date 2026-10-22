#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
make_miniboss_arenas.py — génère les arènes mini-boss des donjons chapitre 6+.

Pour chaque donjon cible :
  1. Data/Map/<zone>_miniboss.rsmap        arène de combat (LayeredSegment)
     -> clone de Data/Map/searing_tunnel_miniboss.rsmap (template validé en jeu)
     -> swap des AutoTileset mt_blaze_* vers le triplet du biome du donjon
     -> équipe : 2 espèces issues/compatibles avec le biome (Unrecruitable)
  2. Data/Ground/<zone>_miniboss.rsground  salle de cinématique assortie
     -> structure clonée de Data/Ground/searing_tunnel_midpoint.rsground
        (format prouvé, round-trip octet-identique vérifié)
     -> géométrie : ring de murs AutoTileset <biome>_wall + plancher
        <biome>_floor (NeighborCode 511, comme les arènes ch5 validées)
     -> entités : Main_Entrance_Marker + TEAMMATE_1..3 (pas de sorties ni
        rocher Kangourex : la suite est entièrement pilotée par les scènes)

Formats (MESURÉS, cf. tools/make_gemini_cloven.py) :
  - rsmap  : UTF-8 sans BOM, json.dumps(ensure_ascii=False) (une ligne)
  - rsground : BOM UTF-8 + json.dumps(ensure_ascii=False, indent=0)

Refuse d'écraser un fichier existant sans --force (preuve avant hypothèse).
"""
from __future__ import annotations

import argparse
import copy
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TEMPLATE_RSMAP = ROOT / "Data/Map/searing_tunnel_miniboss.rsmap"
TEMPLATE_RSGROUND = ROOT / "Data/Ground/searing_tunnel_midpoint.rsground"

# ---------------------------------------------------------------------------
# Configuration des quatre arènes (casting documenté dans le rapport) :
# chaque duo est choisi pour coller au biome et au boss du donjon, à partir
# d'espèces vanilla PMDO (les boss existants prouvent que les sprites
# vanilla se chargent sans entrée dans Content/Chara).
# gender codes PMDO : 0=Unknown 1=Male 2=Female 3=Genderless
# ---------------------------------------------------------------------------
CONFIG = {
    "gloomy_forest": {
        "chapter": 6,
        "tex_wall": "treeshroud_forest_1_wall",
        "tex_floor": "treeshroud_forest_1_floor",
        "element": "grass",
        "name_en": "Gloomy Hollow",
        "name_fr": "Creux Ombragé",
        "team": [
            {"species": "shiftry", "nick": "Tengalice", "gender": 1,
             "level": 25, "hp_bonus": 70, "el": ("grass", "dark"),
             "skills": ["razor_leaf", "feint_attack", "leaf_blade", "fake_out"],
             "loc": (6, 3)},
            {"species": "murkrow", "nick": "Cornèbre", "gender": 1,
             "level": 25, "hp_bonus": 60, "el": ("dark", "flying"),
             "skills": ["peck", "astonish", "night_shade", "gust"],
             "loc": (9, 3)},
        ],
    },
    "cloven_ruins": {
        "chapter": 7,
        "tex_wall": "western_cave_1_wall",
        "tex_floor": "western_cave_1_floor",
        "element": "rock",
        "name_en": "Ruin Guardpost",
        "name_fr": "Poste de Garde",
        "team": [
            {"species": "claydol", "nick": "Kaorine", "gender": 3,
             "level": 26, "hp_bonus": 80, "el": ("ground", "psychic"),
             "skills": ["psybeam", "ancient_power", "mud_shot", "rapid_spin"],
             "loc": (6, 3)},
            {"species": "golurk", "nick": "Golemastoc", "gender": 3,
             "level": 26, "hp_bonus": 80, "el": ("ground", "ghost"),
             "skills": ["shadow_punch", "stomp", "astonish", "mud_shot"],
             "loc": (9, 3)},
        ],
    },
    "crystal_sanctuary": {
        "chapter": 8,
        "tex_wall": "crystal_cave_1_wall",
        "tex_floor": "crystal_cave_1_floor",
        "element": "ice",
        "name_en": "Crystal Threshold",
        "name_fr": "Seuil de Cristal",
        "team": [
            {"species": "carbink", "nick": "Strassie", "gender": 3,
             "level": 28, "hp_bonus": 85, "el": ("rock", "fairy"),
             "skills": ["rock_throw", "dazzling_gleam", "power_gem", "tackle"],
             "loc": (6, 3)},
            {"species": "froslass", "nick": "Momartik", "gender": 2,
             "level": 28, "hp_bonus": 75, "el": ("ice", "ghost"),
             "skills": ["icy_wind", "astonish", "ice_shard", "hex"],
             "loc": (9, 3)},
        ],
    },
    "forgotten_marsh": {
        "chapter": 9,
        "tex_wall": "murky_cave_wall",
        "tex_floor": "murky_cave_floor",
        "element": "water",
        "name_en": "Sunken Crossing",
        "name_fr": "Gué Englouti",
        "team": [
            {"species": "swalot", "nick": "Avaltout", "gender": 1,
             "level": 30, "hp_bonus": 95, "el": ("poison", "none"),
             "skills": ["sludge_bomb", "acid", "toxic", "body_slam"],
             "loc": (6, 3)},
            {"species": "toxicroak", "nick": "Coatox", "gender": 1,
             "level": 30, "hp_bonus": 85, "el": ("poison", "fighting"),
             "skills": ["venoshock", "poison_jab", "sucker_punch", "rock_smash"],
             "loc": (9, 3)},
        ],
    },
}

# Taille de l'arène rsmap : 15x15 tuiles autotile (ring 1 de murs + plancher),
# calqué sur le template searing (56 murs / 169 sols).
ARENA_CELLS = 15

# Le ground de cinématique : même gabarit 19x19 tuiles @TexSize 3 (24 px)
# que le relais template, ring de 2 tuiles de murs (coincé entre y=48..408 px,
# coordonnées des scènes étalonnées pour cette salle).
GROUND_CELLS = 19
WALL_RING = 2


def load_json(path: Path):
    raw = path.read_bytes()
    bom = raw[:3] == b"\xef\xbb\xbf"
    data = json.loads(raw.decode("utf-8-sig" if bom else "utf-8"))
    return data, bom


def dump_rsmap(data: dict, path: Path):
    path.write_bytes(json.dumps(data, ensure_ascii=False).encode("utf-8"))


def dump_rsground(data: dict, path: Path):
    path.write_bytes(
        b"\xef\xbb\xbf" + json.dumps(data, ensure_ascii=False, indent=0).encode("utf-8")
    )


def cell(tex: str) -> dict:
    return {
        "AutoTileset": tex,
        "Associates": [],
        "Layers": [],
        "NeighborCode": 511,
    }


def build_player(template_player: dict, spec: dict) -> dict:
    p = copy.deepcopy(template_player)
    p["Nickname"] = spec["nick"]
    p["BaseForm"] = {
        "Species": spec["species"], "Form": 0, "Skin": "normal",
        "Gender": spec["gender"],
    }
    p["CurrentForm"] = copy.deepcopy(p["BaseForm"])
    p["ProxySprite"] = copy.deepcopy(p["CurrentForm"])
    p["Level"] = spec["level"]
    p["MaxHPBonus"] = spec["hp_bonus"]
    p["Element1"], p["Element2"] = spec["el"]
    skills = [{"SkillNum": sk, "Charges": 20, "CanForget": True}
              for sk in spec["skills"]]
    p["BaseSkills"] = skills
    # liste runtime miroir (format SlotList : Element/BackRef)
    p["Skills"] = [
        {"Element": {"SkillNum": sk["SkillNum"], "Charges": sk["Charges"],
                     "Enabled": True, "Sealed": False},
         "BackRef": i}
        for i, sk in enumerate(skills)
    ]
    p["serializationLoc"] = {"X": spec["loc"][0], "Y": spec["loc"][1]}
    return p


def make_rsmap(zone: str, cfg: dict, force: bool) -> Path:
    tpl, _ = load_json(TEMPLATE_RSMAP)
    out = copy.deepcopy(tpl)
    obj = out["Object"]
    obj["AssetName"] = f"{zone}_miniboss"
    obj["Name"] = {"DefaultText": cfg["name_en"],
                   "LocalTexts": {"fr": cfg["name_fr"]}}
    obj["Comment"] = (
        f"Mini-boss arena {zone} (chapter {cfg['chapter']}). "
        f"Generee par tools/make_miniboss_arenas.py depuis le template "
        f"searing_tunnel_miniboss."
    )
    obj["Element"] = cfg["element"]
    obj["Music"] = "Boss Battle!.ogg"

    # Géométrie : ring de murs + plancher, AutoTileset du biome.
    tiles = []
    for y in range(ARENA_CELLS):
        row = []
        for x in range(ARENA_CELLS):
            wall = x == 0 or y == 0 or x == ARENA_CELLS - 1 or y == ARENA_CELLS - 1
            tex = cfg["tex_wall"] if wall else cfg["tex_floor"]
            row.append({
                "Data": {
                    "ID": "unbreakable" if wall else "floor",
                    "TileTex": cell(tex),
                    "StableTex": False,
                },
                "Effect": {
                    "TileLoc": {"X": x, "Y": y},
                    "ID": "", "Revealed": False, "Owner": 0, "TileStates": [],
                },
            })
        tiles.append(row)
    obj["Tiles"] = tiles

    # Équipe : 2 joueurs reconstruits depuis le template Torkoal.
    tpl_player = tpl["Object"]["MapTeams"][0]["Players"][0]
    players = [build_player(tpl_player, s) for s in cfg["team"]]
    obj["MapTeams"] = [{
        "$type": tpl["Object"]["MapTeams"][0]["$type"],
        "Players": players,
    }]

    dest = ROOT / f"Data/Map/{zone}_miniboss.rsmap"
    if dest.exists() and not force:
        raise SystemExit(f"REFUS: {dest} existe (passez --force)")
    dump_rsmap(out, dest)
    return dest


def make_rsground(zone: str, cfg: dict, force: bool) -> Path:
    tpl, _ = load_json(TEMPLATE_RSGROUND)
    out = copy.deepcopy(tpl)
    obj = out["Object"]
    obj["AssetName"] = f"{zone}_miniboss"
    obj["Name"] = {"DefaultText": cfg["name_en"],
                   "LocalTexts": {"fr": cfg["name_fr"]}}
    obj["Comment"] = (
        f"Salle cinematique du mini-boss {zone} (chapitre {cfg['chapter']}). "
        f"Salle autotile biome (gen_par tools/make_miniboss_arenas.py)."
    )
    obj["Music"] = "In the Depths of the Pit.ogg"

    # --- géométrie : ring de WALL_RING tuiles de murs + plancher intérieur.
    tiles = []
    for y in range(GROUND_CELLS):
        row = []
        for x in range(GROUND_CELLS):
            wall = (x < WALL_RING or y < WALL_RING
                    or x >= GROUND_CELLS - WALL_RING
                    or y >= GROUND_CELLS - WALL_RING)
            row.append(cell(cfg["tex_wall"] if wall else cfg["tex_floor"]))
        tiles.append(row)
    obj["Layers"] = [{
        "Name": "New Layer", "Layer": 0, "Visible": True, "Tiles": tiles,
    }]

    # --- grille d'obstacles (57x57 cellules de 8 px) : le clone du relais
    # gardait la géométrie du pont central (156 cellules Tags=1) qui ne
    # correspond pas à une salle fermée. Ring de 6 cellules (2 tuiles de
    # 24 px) bloqué tout autour, intérieur libre.
    ring = WALL_RING * 3  # 2 tuiles de 24 px = 6 cellules de 8 px
    obstacles = []
    for x in range(57):
        col = []
        for y in range(57):
            blocked = (x < ring or y < ring
                       or x >= 57 - ring or y >= 57 - ring)
            col.append({
                "Bounds": {"X": x * 8, "Y": y * 8, "Width": 8, "Height": 8},
                "Tags": 1 if blocked else 0,
            })
        obstacles.append(col)
    obj["obstacles"] = obstacles

    # --- entités : marker d'entrée + trois coéquipiers, rien d'autre.
    def marker(name, x, y, direction=4):
        return {"EntName": name, "Direction": direction, "EntEnabled": True,
                "EntOrder": 0, "InteractOrder": 0, "triggerType": 0,
                "Collider": {"X": x, "Y": y, "Width": 16, "Height": 16}}

    tpl_spawn = tpl["Object"]["Entities"][0]["Spawners"][0]

    def teammate(npc_name, ent_name, x, y, direction=0):
        s = copy.deepcopy(tpl_spawn)
        s["NPCName"] = npc_name
        s["EntName"] = ent_name
        s["Direction"] = direction
        s["Collider"] = {"X": x, "Y": y, "Width": 16, "Height": 16}
        return s

    ent = tpl["Object"]["Entities"][0]
    new_ent = copy.deepcopy(ent)
    new_ent["Markers"] = [marker("Main_Entrance_Marker", 228, 348)]
    new_ent["GroundObjects"] = []
    new_ent["Spawners"] = [
        teammate("Teammate1", "TEAMMATE_1", 272, 344),
        teammate("Teammate2", "TEAMMATE_2", 240, 376),
        teammate("Teammate3", "TEAMMATE_3", 272, 376),
    ]
    obj["Entities"] = [new_ent]

    dest = ROOT / f"Data/Ground/{zone}_miniboss.rsground"
    if dest.exists() and not force:
        raise SystemExit(f"REFUS: {dest} existe (passez --force)")
    dump_rsground(out, dest)
    return dest


def verify(zone: str) -> list[str]:
    """Relecture stricte des deux fichiers générés (géométrie + swap)."""
    problems = []
    rsmap, bom = load_json(ROOT / f"Data/Map/{zone}_miniboss.rsmap")
    if bom:
        problems.append("rsmap avec BOM (le template n'en a pas)")
    obj = rsmap["Object"]
    cfg = CONFIG[zone]
    tex = set()
    for row in obj["Tiles"]:
        for t in row:
            tex.add(t["Data"]["TileTex"]["AutoTileset"])
    if tex != {cfg["tex_wall"], cfg["tex_floor"]}:
        problems.append(f"rsmap textures {tex} != biome attendu")
    species = [p["BaseForm"]["Species"] for p in obj["MapTeams"][0]["Players"]]
    want = [s["species"] for s in cfg["team"]]
    if species != want:
        problems.append(f"équipe rsmap {species} != {want}")

    ground, bom = load_json(ROOT / f"Data/Ground/{zone}_miniboss.rsground")
    if not bom:
        problems.append("rsground sans BOM")
    gobj = ground["Object"]
    gtex = set()
    for row in gobj["Layers"][0]["Tiles"]:
        for t in row:
            gtex.add(t["AutoTileset"])
    if gtex != {cfg["tex_wall"], cfg["tex_floor"]}:
        problems.append(f"ground textures {gtex} != biome attendu")
    # ring d'obstacles cohérent avec la géométrie dessinée
    obs = gobj["obstacles"]
    ring = 6
    bad = 0
    for x in range(57):
        for y in range(57):
            want = (x < ring or y < ring or x >= 51 or y >= 51)
            if (obs[x][y].get("Tags") != 0) != want:
                bad += 1
    if bad:
        problems.append(f"obstacles: {bad} cellule(s) hors ring attendu")
    names = []
    for ent in gobj["Entities"]:
        names += [s.get("EntName") for s in ent.get("Spawners", [])]
        names += [s.get("EntName") for s in ent.get("Markers", [])]
    for required in ("TEAMMATE_1", "TEAMMATE_2", "TEAMMATE_3",
                     "Main_Entrance_Marker"):
        if required not in names:
            problems.append(f"entité manquante: {required}")
    return problems


def main() -> int:
    ap = argparse.ArgumentParser(description=__doc__)
    ap.add_argument("--force", action="store_true",
                    help="écrase les fichiers existants")
    ap.add_argument("--zones", nargs="*", default=sorted(CONFIG),
                    choices=sorted(CONFIG))
    args = ap.parse_args()

    made = []
    for zone in args.zones:
        cfg = CONFIG[zone]
        rsmap = make_rsmap(zone, cfg, args.force)
        ground = make_rsground(zone, cfg, args.force)
        made.append((zone, rsmap, ground))
        print(f"[OK] {zone}: {rsmap.name} + {ground.name}")

    failures = 0
    for zone in args.zones:
        problems = verify(zone)
        if problems:
            failures += 1
            for p in problems:
                print(f"[ECHEC] {zone}: {p}")
        else:
            print(f"[VERIF] {zone}: géométrie + biome OK")
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
