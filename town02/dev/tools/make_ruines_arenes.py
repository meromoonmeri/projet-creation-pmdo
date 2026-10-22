#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
make_ruines_arenes.py — construit les QUATRE etages-arenes des Aegis Cave.

CONTEXTE
--------
Portage d'Aegis Cave. Chaque Regi attend au bout de SON labyrinthe, dans une
salle qui appartient au meme biome que le labyrinthe qui y mene. Ces salles
sont des ETAGES DE LA ZONE (LayeredSegment -> LoadGen -> MappedRoomStep), pas
des grounds de cinematique : la mise en scene se joue en donjon, via
OnMapStarts (patron beginner_lesson.json / dungeon_life.lua).

Avant ce script, les trois chambres etaient des copies conformes de
sanctuaire_titans : meme feuille Titans_Arena_Base, meme Element normal, meme
musique, et leur champ ID portait encore « sanctuaire_titans ». Trois salles
identiques pour trois gardiens qui n'ont rien en commun.

CE QUE FAIT CE SCRIPT
---------------------
Il DESSINE chaque salle, tuile par tuile, au lieu de recopier un gabarit :

  * une nef rectangulaire bordee d'un mur infranchissable ;
  * un CHOEUR surleve au fond, delimite par une bordure de « secondary »
    (la texture d'eau/relief du biome), sur lequel trone le gardien ;
  * une ALLEE centrale qui va de l'entree au choeur — le joueur arrive
    toujours dans l'axe du gardien, jamais de biais ;
  * quatre PILIERS (blocs infranchissables) qui cassent la symetrie plate
    et donnent de la profondeur au cadrage camera ;
  * deux NICHES laterales en retrait, ou se tiennent les renforts du Puits.

La geometrie est parametree par biome : la salle de Regirock est plus large et
plus basse (une carriere), celle de Registeel est etroite et longue (une nef),
celle de Regice est carree et ouverte (une caverne de glace), celle de
Regigigas est la plus vaste des quatre.

TILESETS
--------
Uniquement des AutoTilesets ATTESTES dans le depot (releve sur les
MapTextureStep reels de Data/Zone/*.json, cf. tools/mapgen/data/
tilesets_donjons.json). Aucun nom invente :

  glace   crystal_cave_1_{floor,wall,secondary}   (elements ice/rock/steel)
  roche   rock_maze_{floor,wall,secondary}        (elements rock/steel)
  acier   steel_aegis_cave_{floor,wall,secondary} (Aegis Cave d'origine)
  gigas   concealed_ruins_{floor,wall}            (deja utilise par
                                                   cloven_ruins_boss.rsmap)

FORMAT
------
rsmap : UTF-8 SANS BOM, json.dumps(ensure_ascii=False) sur une seule ligne.
Mesure faite sur les .rsmap existants du depot, cf. make_gemini_cloven.py.

Le script REFUSE d'ecraser sans --force.
"""
from __future__ import annotations
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---

import argparse
import copy
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
MAPDIR = ROOT / "Data/Map"

# Gabarit dont on herite la structure serialisee (champs moteur, MapEffect,
# CurrentTurnMap...). On ne garde de lui QUE l'enveloppe : toute la geometrie
# et tout le casting sont reecrits.
TEMPLATE = MAPDIR / "cloven_ruins_regice.rsmap"


# ---------------------------------------------------------------------------
# BIOMES
# ---------------------------------------------------------------------------
# Chaque entree decrit une salle. Les dimensions sont en TUILES.
#   w,h        taille totale de la carte, bord compris
#   choeur     (x0, y0, x1, y1) rectangle du parvis surleve, inclusif
#   piliers    liste de (x, y) blocs infranchissables
#   niches     (gauche, droite) : (x, y) creux lateraux
#   boss       (x, y) position du gardien, sur le choeur
#   entree     (x, y) arrivee de l'equipe, en bas dans l'axe
# ---------------------------------------------------------------------------
BIOMES = {
    "cloven_ruins_regice": {
        "seg": 1,
        "nom_fr": "Chambre de Regice",
        "nom_en": "Regice's Chamber",
        "commentaire": (
            "Aegis Cave — arene de Regice (etage de zone, segment 1). "
            "Portage Aegis Cave / Ice Maze. Salle carree et ouverte : une "
            "caverne de glace, pas un temple. Le froid a fait eclater les "
            "murs, d'ou les piliers ecartes."
        ),
        "floor": "crystal_cave_1_floor",
        "wall": "crystal_cave_1_wall",
        "secondary": "crystal_cave_1_secondary",
        "element": "ice",
        "musique": "Aegis Cave.ogg",
        "w": 21, "h": 21,
        "choeur": (7, 3, 13, 8),
        "piliers": [(4, 11), (16, 11), (4, 15), (16, 15)],
        "niches": [(2, 5), (18, 5)],
        "boss": (10, 5),
        "entree": (10, 18),
    },
    "cloven_ruins_regirock": {
        "seg": 3,
        "nom_fr": "Chambre de Regirock",
        "nom_en": "Regirock's Chamber",
        "commentaire": (
            "Aegis Cave — arene de Regirock (etage de zone, segment 3). "
            "Portage Aegis Cave / Rock Maze. Salle LARGE et BASSE : une "
            "carriere, pas une nef. Six piliers massifs, alignes comme les "
            "restes d'une galerie effondree."
        ),
        "floor": "rock_maze_floor",
        "wall": "rock_maze_wall",
        "secondary": "rock_maze_secondary",
        "element": "rock",
        "musique": "Aegis Cave.ogg",
        "w": 25, "h": 17,
        "choeur": (9, 2, 15, 6),
        "piliers": [(4, 9), (19, 9), (4, 12), (19, 12), (7, 12), (16, 12)],
        "niches": [(2, 5), (22, 5)],
        "boss": (12, 4),
        "entree": (12, 14),
    },
    "cloven_ruins_registeel": {
        "seg": 5,
        "nom_fr": "Chambre de Registeel",
        "nom_en": "Registeel's Chamber",
        "commentaire": (
            "Aegis Cave — arene de Registeel (etage de zone, segment 5). "
            "Portage Aegis Cave / Steel Maze, tileset d'origine "
            "steel_aegis_cave. Salle ETROITE et LONGUE : une nef. Le gardien "
            "est visible des l'entree, tout au fond — c'est le principe de sa "
            "scene, il n'a jamais bouge."
        ),
        "floor": "steel_aegis_cave_floor",
        "wall": "steel_aegis_cave_wall",
        "secondary": "steel_aegis_cave_secondary",
        "element": "steel",
        "musique": "Aegis Cave.ogg",
        "w": 17, "h": 25,
        "choeur": (5, 2, 11, 7),
        "piliers": [(3, 11), (12, 11), (3, 16), (12, 16)],
        "niches": [(2, 20), (14, 20)],
        "boss": (8, 4),
        "entree": (8, 22),
    },
    "sanctuaire_titans": {
        "seg": 7,
        "nom_fr": "Sanctuaire des Titans",
        "nom_en": "Titans Sanctum",
        "commentaire": (
            "Aegis Cave — arene de Regigigas (etage de zone, segment 7). "
            "Portage Aegis Cave / Regigigas Pit. La plus vaste des quatre : "
            "Regigigas plus ses huit gardes (4 Hitmonlee, 4 Bronzong) plus "
            "les renforts de la guilde doivent tenir dedans. Tileset "
            "concealed_ruins, deja en place sur cloven_ruins_boss."
        ),
        "floor": "concealed_ruins_floor",
        "wall": "concealed_ruins_wall",
        "secondary": "buried_relic_1_floor",
        "element": "normal",
        "musique": "Boss Battle!.ogg",
        "w": 27, "h": 25,
        "choeur": (9, 2, 17, 8),
        "piliers": [(4, 12), (22, 12), (4, 17), (22, 17)],
        "niches": [(2, 6), (24, 6)],
        "boss": (13, 5),
        "entree": (13, 22),
    },
}


# ---------------------------------------------------------------------------
# Fabrique de tuiles
# ---------------------------------------------------------------------------
def tuile(kind: str, tex: str, x: int, y: int) -> dict:
    """Une tuile de la grille de collision. kind = 'floor' | 'unbreakable'."""
    return {
        "Data": {
            "ID": kind,
            "TileTex": {
                "AutoTileset": tex,
                "Associates": [],
                "Layers": [],
                "NeighborCode": 511,
            },
            "StableTex": False,
        },
        "Effect": {
            "TileLoc": {"X": x, "Y": y},
            "ID": "",
            "Revealed": False,
            "Owner": 0,
            "TileStates": [],
        },
    }


def tuile_vide() -> dict:
    return {"AutoTileset": "", "Associates": [], "Layers": [], "NeighborCode": -1}


def dessiner(cfg: dict) -> list:
    """Construit la grille Tiles[x][y]. Retourne une liste de colonnes."""
    w, h = cfg["w"], cfg["h"]
    floor, wall, sec = cfg["floor"], cfg["wall"], cfg["secondary"]
    cx0, cy0, cx1, cy1 = cfg["choeur"]

    grille = []
    for x in range(w):
        col = []
        for y in range(h):
            # Bord exterieur : toujours infranchissable.
            if x == 0 or y == 0 or x == w - 1 or y == h - 1:
                col.append(tuile("unbreakable", wall, x, y))
                continue

            # Bordure du choeur : liseré de texture secondaire. C'est ce qui
            # donne au parvis sa lecture de « marche surelevee » sans changer
            # la collision (le joueur doit pouvoir monter dessus).
            sur_bord_choeur = (
                (cx0 - 1 <= x <= cx1 + 1 and cy0 - 1 <= y <= cy1 + 1)
                and not (cx0 <= x <= cx1 and cy0 <= y <= cy1)
            )
            if sur_bord_choeur:
                col.append(tuile("floor", sec, x, y))
                continue

            col.append(tuile("floor", floor, x, y))
        grille.append(col)

    # Piliers : blocs pleins poses APRES le sol, pour qu'ils ecrasent ce qu'il
    # y avait dessous. Chaque pilier fait 2x2 — un seul tile se lit comme un
    # accident, 2x2 se lit comme une colonne.
    for (px, py) in cfg["piliers"]:
        for dx in range(2):
            for dy in range(2):
                x, y = px + dx, py + dy
                if 1 <= x < w - 1 and 1 <= y < h - 1:
                    grille[x][y] = tuile("unbreakable", wall, x, y)

    # Niches laterales : un creux de 3x3 en texture secondaire, ouvert sur la
    # salle. Les renforts s'y tiennent avant d'entrer dans le champ.
    for (nx, ny) in cfg["niches"]:
        for dx in range(-1, 2):
            for dy in range(-1, 2):
                x, y = nx + dx, ny + dy
                if 1 <= x < w - 1 and 1 <= y < h - 1:
                    grille[x][y] = tuile("floor", sec, x, y)

    # L'ALLEE : on re-creuse la colonne centrale en sol franc, de l'entree
    # jusqu'au choeur. Garantit qu'aucun pilier ne bloque jamais l'axe
    # d'arrivee — le joueur voit le gardien des qu'il pose le pied.
    ax = cfg["entree"][0]
    for y in range(cy1, cfg["entree"][1] + 1):
        for dx in (-1, 0, 1):
            x = ax + dx
            if 1 <= x < w - 1 and 1 <= y < h - 1:
                grille[x][y] = tuile("floor", floor, x, y)

    return grille


def couche_visuelle(w: int, h: int) -> dict:
    return {
        "Name": "New Layer",
        "Layer": 0,
        "Visible": True,
        "Tiles": [[tuile_vide() for _ in range(h)] for _ in range(w)],
    }


# ---------------------------------------------------------------------------
# Assemblage
# ---------------------------------------------------------------------------
def construire(nom: str, cfg: dict, gabarit: dict) -> dict:
    doc = copy.deepcopy(gabarit)
    o = doc["Object"]
    w, h = cfg["w"], cfg["h"]

    o["Name"] = {
        "DefaultText": cfg["nom_en"],
        "LocalTexts": {"fr": cfg["nom_fr"]},
    }
    o["Comment"] = cfg["commentaire"]
    o["AssetName"] = nom
    # Le gabarit trainait « sanctuaire_titans » dans ID pour les trois
    # chambres : chacune doit porter son propre identifiant.
    o["ID"] = nom
    o["Music"] = cfg["musique"]
    o["Element"] = cfg["element"]

    # BlankBG : ce qu'on voit AU-DELA des murs. On le cale sur le mur du
    # biome (patron chapter_3_boss_fight, qui met rock_maze_wall) au lieu de
    # la feuille Titans_Arena_Base heritee.
    o["BlankBG"] = {
        "AutoTileset": cfg["wall"],
        "Associates": [],
        "Layers": [],
        "NeighborCode": -1,
    }

    o["Tiles"] = dessiner(cfg)
    o["Layers"] = [couche_visuelle(w, h)]
    o["Decorations"] = [{"Name": "New Deco", "Layer": 0, "Visible": True, "Anims": []}]
    o["DiscoveryArray"] = [[False] * h for _ in range(w)]

    # Entree : deux points cote a cote, dans l'axe, tournes vers le HAUT
    # (Dir 4 = Up dans les cartes existantes) pour que l'equipe regarde le
    # gardien des l'apparition.
    ex, ey = cfg["entree"]
    o["EntryPoints"] = [
        {"Loc": {"X": ex, "Y": ey}, "Dir": 4},
        {"Loc": {"X": ex - 1, "Y": ey}, "Dir": 4},
    ]

    o["MapTeams"] = []          # casting pose par wire_ruines_arenes.py
    o["AllyTeams"] = []
    o["TeamSpawns"] = []
    o["ItemSpawns"] = {"Spawns": {"spawns": {}, "spawnTotal": 0}}
    o["Items"] = []
    o["MoneyAmount"] = {"Min": 0, "Max": 0}
    o["CurrentTurnMap"] = {
        "CurrentOrder": {"TurnTier": 0, "Faction": 0, "TurnIndex": 0},
        "TurnToChar": [],
    }
    return doc


def valider(nom: str, cfg: dict, doc: dict) -> list:
    """Controle geometrique. Retourne la liste des defauts trouves.

    Ces controles existent parce que la premiere passe en a laisse passer
    quatre : des piliers avales par l'allee centrale (donc invisibles), des
    niches collees a un pilier, et un choeur dont le liseré etait de la meme
    texture que le sol (donc invisible aussi). Un rendu PNG ne les aurait pas
    montres : Content/Tile ne contient pas les AutoTilesets du pack de base,
    l'apercu sort noir, y compris pour les cartes validees en jeu. La preuve
    doit donc etre structurelle.
    """
    o = doc["Object"]
    T = o["Tiles"]
    w, h = cfg["w"], cfg["h"]
    cx0, cy0, cx1, cy1 = cfg["choeur"]
    ex, ey = cfg["entree"]
    bx, by = cfg["boss"]
    defauts = []

    def sol(x, y):
        return 0 <= x < w and 0 <= y < h and T[x][y]["Data"]["ID"] == "floor"

    # 1. Entree et emplacement du gardien jouables.
    if not sol(ex, ey):
        defauts.append(f"entree ({ex},{ey}) dans un mur")
    if not sol(bx, by):
        defauts.append(f"gardien ({bx},{by}) dans un mur")
    if not (cx0 <= bx <= cx1 and cy0 <= by <= cy1):
        defauts.append(f"gardien ({bx},{by}) hors du choeur")

    # 2. Connexite : tout le sol doit etre atteignable depuis l'entree.
    seen, pile = set(), [(ex, ey)]
    while pile:
        x, y = pile.pop()
        if (x, y) in seen or not sol(x, y):
            continue
        seen.add((x, y))
        pile += [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
    total = sum(1 for x in range(w) for y in range(h) if sol(x, y))
    if len(seen) != total:
        defauts.append(f"{total - len(seen)} tuiles isolees (ilots injoignables)")

    # 3. Les piliers doivent avoir SURVECU au creusement de l'allee.
    #    C'est le defaut qui avait mange 2 piliers sur 4 chez Regice.
    for (px, py) in cfg["piliers"]:
        pleins = sum(
            1 for dx in range(2) for dy in range(2)
            if 0 <= px + dx < w and 0 <= py + dy < h
            and T[px + dx][py + dy]["Data"]["ID"] == "unbreakable"
        )
        if pleins < 4:
            defauts.append(f"pilier ({px},{py}) rogne : {pleins}/4 blocs restants")

    # 4. Le liseré du choeur doit etre VISIBLE, donc d'une texture distincte
    #    du sol. Sinon le parvis ne se lit pas a l'ecran.
    if cfg["secondary"] == cfg["floor"]:
        defauts.append("liseré du choeur invisible (secondary == floor)")

    # 5. Symetrie des niches : meme surface a gauche et a droite.
    surfaces = []
    for (nx, ny) in cfg["niches"]:
        surfaces.append(sum(
            1 for dx in range(-1, 2) for dy in range(-1, 2)
            if sol(nx + dx, ny + dy)
            and T[nx + dx][ny + dy]["Data"]["TileTex"]["AutoTileset"] == cfg["secondary"]
        ))
    if len(set(surfaces)) > 1:
        defauts.append(f"niches asymetriques : {surfaces}")

    # 6. L'axe entree -> choeur doit etre degage sur toute sa longueur :
    #    le joueur doit voir le gardien des qu'il pose le pied dans la salle.
    for y in range(cy1, ey + 1):
        if not sol(ex, y):
            defauts.append(f"axe d'arrivee bloque en ({ex},{y})")
            break

    return defauts


def ecrire(path: Path, doc: dict) -> None:
    # UTF-8 SANS BOM, une seule ligne — format mesure sur les .rsmap du depot.
    path.write_text(json.dumps(doc, ensure_ascii=False), encoding="utf-8")


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--force", action="store_true")
    ap.add_argument("--only", help="ne traiter qu'une carte")
    args = ap.parse_args()

    gabarit = json.loads(TEMPLATE.read_text(encoding="utf-8-sig"))
    echecs = 0

    for nom, cfg in BIOMES.items():
        if args.only and args.only != nom:
            continue
        dest = MAPDIR / f"{nom}.rsmap"
        if dest.exists() and not args.force:
            print(f"REFUS  {dest.name} existe (utiliser --force)")
            continue
        doc = construire(nom, cfg, gabarit)
        defauts = valider(nom, cfg, doc)
        sol = sum(
            1 for col in doc["Object"]["Tiles"] for t in col
            if t["Data"]["ID"] == "floor"
        )
        if defauts:
            echecs += 1
            print(f"ECHEC  {dest.name:34s} — NON ECRITE")
            for d in defauts:
                print(f"         · {d}")
            continue
        ecrire(dest, doc)
        print(
            f"OK     {dest.name:34s} {cfg['w']:2d}x{cfg['h']:2d}  "
            f"{sol:4d} tuiles jouables  {cfg['floor']}"
        )
    if echecs:
        print(f"\n{echecs} carte(s) refusee(s) : geometrie invalide.")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
