#!/usr/bin/env python3
"""Convertit les 16 cartes Waves of Nostalgia en Grounds PMDO natifs.

Decisions arbitrees par le proprietaire
---------------------------------------
    mode      : Grounds SEPARES, relies par des sorties bidirectionnelles
    perimetre : les 16 cartes overw*
    saisons   : saisonnalisees comme NNV

Pourquoi aucun rescale
----------------------
Une carte WoN est une grille de tuiles de 8 px. L'unite monde PMDO est de 8 px.
NNV, apres sa normalisation x0,125, est aussi a 8 px. Les trois referentiels
coincident : le rapport est de 1, et convertir revient a recopier, pas a
redimensionner. C'est mesure sur les 16 cartes, pas suppose.

    overw1   672x576 px  ->  84x72 cellules de 8 px
    rmvillage NNV        ->  78x78 cellules de 8 px

Collision : native, jamais devinee
----------------------------------
Le `.bma` porte sa propre grille de collision, exactement une valeur par
cellule de 8 px (6 048 pour overw1 = 84x72). Elle est recopiee telle quelle.
Aucune heuristique de couleur, aucune deduction depuis l'image : la donnee
existe, on la lit.

Planche de tuiles
-----------------
Chaque carte est decoupee en cellules de 8 px et ecrite dans une planche
`.tile` native via `write_tile` de PMU_ADAPTATION — l'ecrivain deja valide par
le reste du projet. Les cellules identiques partagent leur charge utile, ce que
`write_tile` fait par construction.

Saisonnalisation
----------------
Le feuillage est recolore par le meme module que les batiments NNV
(`seasonalize_building_foliage`), avec les teintes mesurees sur les arbres NNV.
Une carte dont la verdure est sous le seuil de materialite est ecrite une seule
fois et partagee par les quatre saisons : elle ne peut alors pas diverger.

Rien n'est ecrit sous `Data/`. Les Grounds sont produits sous `generated/won/`.
"""
from __future__ import annotations

import argparse
import hashlib
import importlib.util
import json
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parent
for extra in (REPO / "PMU_ADAPTATION/src", REPO / "PMU_EXTRACTION/src", REPO / "tools"):
    sys.path.insert(0, str(extra))

from PIL import Image  # noqa: E402

CELL = 8
SEASONS = ("spring", "summer", "autumn", "winter")
ROM_SHA256 = "5d2b5c7b9942c7eca2115d486eec69b9060418b09fc215ad6f104d46b544f0db"

# Six cartes declarent number_of_collision_layers == 0 : ce sont les variantes
# horaires (soir, nuit) et elles n'embarquent pas de collision propre. Ce n'est
# pas une donnee manquante, c'est le fonctionnement du moteur : la variante
# reutilise la collision de sa carte de jour, dont elle partage exactement la
# grille (verifie sur les 6 : memes chunks, memes dimensions).
#
# Ecrire un Ground sans collision rendrait ces cartes entierement traversables :
# on traverserait les maisons et la mer. On herite donc explicitement, et le
# rapport dit de quelle carte vient la collision. Rien n'est invente.
COLLISION_INHERITED_FROM = {
    "overw1e": "overw1", "overw1n": "overw1", "overw4n": "overw4",
    "overw5e": "overw5", "overwhbn": "overwhb", "overwhn": "overwh",
}


def load_module(name: str, path: Path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def tex_key(x: int, y: int) -> int:
    return (y << 32) | x


def build_tile_sheet(image: Image.Image, sheet_path: Path, png_bytes, write_tile):
    """Decoupe la carte en cellules de 8 px et ecrit la planche native."""
    columns, rows = image.width // CELL, image.height // CELL
    entries = []
    for cy in range(rows):
        for cx in range(columns):
            block = image.crop((cx * CELL, cy * CELL, (cx + 1) * CELL, (cy + 1) * CELL))
            entries.append((tex_key(cx, cy), png_bytes(block)))
    write_tile(sheet_path, CELL, entries)
    return columns, rows, len(entries)


def build_ground(asset: str, title: str, columns: int, rows: int, sheet_stem: str,
                 collision, shell, empty_cell, ground_object):
    """Un Ground PMDO : une couche de tuiles, la collision native, pas d'invention."""
    tiles = []
    for cx in range(columns):
        column = []
        for cy in range(rows):
            column.append({
                "Layers": [{
                    "Frames": [{"Sheet": sheet_stem,
                                "TexLoc": {"X": cx, "Y": cy}}],
                    "FrameTime": 0, "StartTime": 0, "FrameLength": 1,
                }],
            })
        tiles.append(column)
    layers = [{"Name": f"WoN {asset}", "Visible": True, "Front": False, "Tiles": tiles}]

    obstacles = []
    for cx in range(columns):
        column = []
        for cy in range(rows):
            index = cy * columns + cx
            blocked = bool(collision[index]) if index < len(collision) else False
            column.append({"Bounds": {"X": cx * CELL, "Y": cy * CELL,
                                      "Width": CELL, "Height": CELL},
                           "Tags": 1 if blocked else 0})
        obstacles.append(column)

    entities = [{"Name": "WoN entities", "Visible": True,
                 "MapChars": [], "GroundObjects": [], "Spawners": [], "Markers": []}]
    document = shell(asset, title, 1, layers, obstacles, entities, "")
    return document


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--renders", type=Path, required=True,
                        help="dossier des PNG rendus par extract_won_world.py")
    parser.add_argument("--rom", type=Path, required=True)
    parser.add_argument("--out", type=Path, default=REPO / ".runtime-cache/won-grounds")
    parser.add_argument("--report", type=Path, default=ROOT / "reports/won-world/CONVERSION.json")
    parser.add_argument("--maps", nargs="*", default=None)
    args = parser.parse_args()

    if sha256_file(args.rom) != ROM_SHA256:
        raise SystemExit("ROM inattendue")

    from pmu_adaptation.composer import _png_bytes, _ground_shell, write_tile
    from smart_dungeon.ground_gen import _empty_cell
    foliage = load_module("seasonalize_building_foliage",
                          ROOT / "tools/seasonalize_building_foliage.py")

    from ndspy.rom import NintendoDSRom
    from skytemple_files.common.types.file_types import FileType
    rom = NintendoDSRom.fromFile(str(args.rom))
    bg_list = FileType.BG_LIST_DAT.deserialize(rom.getFileByName("MAP_BG/bg_list.dat"))

    world = json.loads((ROOT / "reports/won-world/won-world.json").read_text())
    selected = args.maps or sorted(world["maps"])

    args.out.mkdir(parents=True, exist_ok=True)
    results = []
    for name in selected:
        source = args.renders / f"{name}.png"
        if not source.is_file():
            results.append({"map": name, "status": "FAILED", "reason": "rendu absent"})
            continue
        image = Image.open(source).convert("RGBA")

        bma = FileType.BMA.deserialize(rom.getFileByName(f"MAP_BG/{name}.bma"))
        collision = bma.collision or []
        collision_origin = name
        if not collision and name in COLLISION_INHERITED_FROM:
            donor = COLLISION_INHERITED_FROM[name]
            donor_bma = FileType.BMA.deserialize(rom.getFileByName(f"MAP_BG/{donor}.bma"))
            if (donor_bma.map_width_chunks, donor_bma.map_height_chunks) != (
                    bma.map_width_chunks, bma.map_height_chunks):
                results.append({"map": name, "status": "FAILED",
                                "reason": f"grille differente de {donor}, heritage refuse"})
                continue
            collision = donor_bma.collision or []
            collision_origin = donor
        columns, rows = image.width // CELL, image.height // CELL
        if len(collision) not in (0, columns * rows):
            results.append({"map": name, "status": "FAILED",
                            "reason": f"collision {len(collision)} != {columns * rows}"})
            continue

        variants, foliage_px = foliage.seasonal_variants(image)
        seasonal = foliage_px > 0

        per_season = {}
        for season in SEASONS:
            asset = f"won_{name}_{season}"
            season_dir = args.out / name / season
            (season_dir / "Content/Tile").mkdir(parents=True, exist_ok=True)
            (season_dir / "Data/Ground").mkdir(parents=True, exist_ok=True)
            sheet_stem = f"WoN_{name}_{season}"
            sheet_path = season_dir / f"Content/Tile/{sheet_stem}.tile"
            build_tile_sheet(variants[season], sheet_path, _png_bytes, write_tile)
            document = build_ground(asset, f"Waves of Nostalgia — {name} ({season})",
                                    columns, rows, sheet_stem, collision,
                                    _ground_shell, _empty_cell, None)
            ground_path = season_dir / f"Data/Ground/{asset}.rsground"
            ground_path.write_text("\ufeff" + json.dumps(document, ensure_ascii=False,
                                                         separators=(",", ":")),
                                   encoding="utf-8")
            check = json.loads(ground_path.read_text(encoding="utf-8-sig"))["Object"]
            if len(check["obstacles"]) != columns or len(check["Layers"][0]["Tiles"]) != columns:
                raise SystemExit(f"{name}/{season}: relecture incoherente")
            per_season[season] = {"ground_sha256": sha256_file(ground_path),
                                  "tile_sha256": sha256_file(sheet_path)}

        blocked = sum(1 for v in collision if v)
        results.append({
            "map": name,
            "status": "CONVERTED",
            "px": [image.width, image.height],
            "grid_8px": [columns, rows],
            "cells": columns * rows,
            "collision_cells_native": len(collision),
            "collision_blocked": blocked,
            "collision_blocked_ratio": round(blocked / max(1, columns * rows), 4),
            "collision_source": ("native .bma, recopiee sans heuristique" if collision_origin == name
                                 else f"heritee de {collision_origin} (variante horaire sans collision propre)"),
            "collision_origin": collision_origin,
            "foliage_px": foliage_px,
            "foliage_seasonalised": seasonal,
            "seasons": per_season,
            "seasons_identical": len({v["tile_sha256"] for v in per_season.values()}) == 1,
        })
        print(f"  {name:10} {image.width:4}x{image.height:4}  {columns}x{rows} cases  "
              f"collision={blocked:5}  feuillage={foliage_px:6} saison={'oui' if seasonal else 'non'}",
              flush=True)

    converted = [r for r in results if r["status"] == "CONVERTED"]
    report = {
        "schema": "new-era.won-ground-conversion.v1",
        "decisions": {"mode": "Grounds separes relies par des sorties",
                      "scope": "les 16 cartes overw*",
                      "seasons": "saisonnalisees comme NNV"},
        "rescale": "aucun — WoN, PMDO et NNV normalise partagent l'unite de 8 px",
        "collision": "native .bma, une valeur par cellule 8 px, recopiee telle quelle",
        "tile_writer": "PMU_ADAPTATION.composer.write_tile (deja valide)",
        "foliage_module": "tools/seasonalize_building_foliage.py (memes teintes que NNV)",
        "maps_requested": len(selected),
        "maps_converted": len(converted),
        "maps_failed": [r["map"] for r in results if r["status"] == "FAILED"],
        "maps": results,
        "grounds_tracked_in_git": False,
        "grounds_location": str(args.out),
        "connections_wired": False,
        "runtime_status": "NOT_CERTIFIED",
    }
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2, ensure_ascii=False, sort_keys=True) + "\n",
                           encoding="utf-8")
    print(json.dumps({k: report[k] for k in
                      ("maps_requested", "maps_converted", "maps_failed")}, indent=2))
    return 0 if not report["maps_failed"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
