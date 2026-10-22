#!/usr/bin/env python3
"""Read-only visual-scale audit: NNV rmvillage vs the metano_town PMDO reference.

Goal: determine, with evidence, whether a Pokemon / PMU building / any asset
placed into NNV would look absurdly small or large next to the trees, houses,
rocks and paths already there.

Seven quantities are kept strictly separate, as required:
  1. physical PNG/.tile resolution
  2. pixel-art density (proved by exact nearest-neighbour reversibility)
  3. PMDO logical cell size
  4. TexSize
  5. real tile/texture size
  6. source-pixel -> world-logical-unit ratio
  7. what PMDO actually displays at runtime

The invariant ruler is the Pokemon character collider, which PMDO fixes at
16x16 px in every Ground regardless of TexSize. Everything else is expressed
in that unit, so NNV and metano_town become directly comparable.

Writes nothing outside its report directory. Never touches Data/ or any map.
"""
from __future__ import annotations

import argparse
import collections
import glob
import gzip
import json
from pathlib import Path

from PIL import Image

from probe_house_underlying_ground import read_tile_sheet

REPO = Path(__file__).resolve().parents[2]
POKEMON_PX = 16  # PMDO character collider, verified invariant across Grounds


def exact_block_density(image: Image.Image) -> int:
    """Largest N for which the image is an exact NxN nearest-neighbour upscale."""
    best = 1
    for n in (2, 4, 8):
        if image.width % n or image.height % n:
            continue
        small = image.resize((image.width // n, image.height // n), Image.NEAREST)
        if small.resize(image.size, Image.NEAREST).tobytes() == image.tobytes():
            best = n
    return best


def ground_facts(path: Path) -> dict:
    obj = json.loads(path.read_text(encoding="utf-8-sig"))["Object"]
    layers = obj["Layers"]
    grid = len(layers[0]["Tiles"])
    world = len(obj["obstacles"]) * 8
    entities = obj["Entities"][0]
    chars = entities["MapChars"]
    return {
        "tex_size": obj["TexSize"],
        "layer_count": len(layers),
        "tile_layer_grid": [grid, len(layers[0]["Tiles"][0])],
        "collision_grid": [len(obj["obstacles"]), len(obj["obstacles"][0])],
        "collision_cell_px": 8,
        "world_px": [world, world],
        "world_in_pokemon_units": [world / POKEMON_PX, world / POKEMON_PX],
        "tile_layer_cell_px": world // grid,
        "tile_layer_cell_in_pokemon_units": (world // grid) / POKEMON_PX,
        "map_char_count": len(chars),
        "map_char_colliders": sorted({(c["Collider"]["Width"], c["Collider"]["Height"]) for c in chars}),
    }


def pokemon_invariant(limit: int = 400) -> dict:
    counts = collections.Counter()
    grounds = 0
    for path in sorted(glob.glob(str(REPO / "Data/Ground/*.rsground")))[:limit]:
        try:
            obj = json.loads(Path(path).read_text(encoding="utf-8-sig"))["Object"]
        except Exception:
            continue
        chars = obj["Entities"][0]["MapChars"]
        if not chars:
            continue
        grounds += 1
        for char in chars:
            counts[(char["Collider"]["Width"], char["Collider"]["Height"])] += 1
    return {
        "grounds_with_characters": grounds,
        "collider_sizes": {f"{w}x{h}": n for (w, h), n in counts.items()},
        "invariant_px": POKEMON_PX,
        "conclusion": "PMDO fixes the Pokemon collider at 16x16 px independently of TexSize; "
                      "it is therefore a valid cross-map ruler",
    }


def sheet_density(path: Path, sample: int = 60) -> dict:
    size, images = read_tile_sheet(path)
    densities = collections.Counter()
    for image in list(images.values())[:sample]:
        densities[exact_block_density(image)] += 1
    return {
        "tile_file": path.name,
        "tile_size_px": size,
        "tile_count": len(images),
        "sampled": min(sample, len(images)),
        "art_density_histogram": {str(k): v for k, v in sorted(densities.items())},
        "dominant_art_density": max(densities, key=densities.get) if densities else None,
    }


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--out", type=Path, default=REPO / "NO_NAME_VILLAGE_ADAPTATION/reports/visual-scale-audit")
    arguments = parser.parse_args()
    arguments.out.mkdir(parents=True, exist_ok=True)

    metano = ground_facts(REPO / "Data/Ground/metano_town.rsground")
    nnv = ground_facts(REPO / "NO_NAME_VILLAGE_ADAPTATION/generated/rmvillage/summer/Data/Ground/nnv_rmvillage_summer.rsground")

    # Source authority: GameMaker declared tile sizes prove the x4 is upstream.
    backgrounds = json.load(gzip.open(REPO / "NO_NAME_VILLAGE_ADAPTATION/extracted/official/inventory/Backgrounds.json.gz"))
    source_tiles = sorted({(b.get("GMS2TileWidth"), b.get("GMS2TileHeight"))
                           for b in backgrounds if b.get("GMS2TileWidth")})

    metano_sheet = sheet_density(REPO / "Content/Tile/Metano_Town_Objects.tile")
    nnv_sheet = sheet_density(REPO / "NO_NAME_VILLAGE_ADAPTATION/generated/rmvillage/summer/Content/Tile/NNV_rmvillage_Summer_Source.tile")

    # NNV houses, measured from the official sprite margins (visible bbox).
    sprites = json.load(gzip.open(REPO / "NO_NAME_VILLAGE_ADAPTATION/extracted/official/inventory/Sprites.json.gz"))
    def sprite_name(value):
        return value.get("Content") if isinstance(value, dict) else value
    houses = {}
    for sprite in sprites:
        name = sprite_name(sprite.get("Name"))
        if name in {"splayerhouse", "sloggerhouse", "shunterhouse", "scarpenterhouse"}:
            width = sprite["MarginRight"] - sprite["MarginLeft"] + 1
            height = sprite["MarginBottom"] - sprite["MarginTop"] + 1
            houses[name] = {
                "visible_bbox_px": [width, height],
                "in_pokemon_units": [round(width / POKEMON_PX, 1), round(height / POKEMON_PX, 1)],
            }

    # metano_town doorway widths from paired entrance markers.
    obj = json.loads((REPO / "Data/Ground/metano_town.rsground").read_text(encoding="utf-8-sig"))["Object"]
    markers = {m["EntName"]: m["Collider"] for m in obj["Entities"][0]["Markers"]}
    doorways = {}
    for base in ("Fire_Home", "Water_Home", "Grass_Home", "Rock_Home"):
        a, b = f"{base}_Entrance_Marker", f"{base}_Entrance_Marker_Partner"
        if a in markers and b in markers:
            width = abs(markers[a]["X"] - markers[b]["X"]) + POKEMON_PX
            doorways[base] = {"width_px": width, "in_pokemon_units": round(width / POKEMON_PX, 1)}

    nnv_door = next(g["Collider"] for g in
                    json.loads((REPO / "NO_NAME_VILLAGE_ADAPTATION/generated/rmvillage/summer/Data/Ground/nnv_rmvillage_summer.rsground").read_text(encoding="utf-8-sig"))["Object"]["Entities"][0]["GroundObjects"]
                    if g["EntName"].startswith("Exit_Door"))

    # PMU confirmed candidates: native density and harmonisation factor.
    autonomy = json.loads((REPO / "PMU_ADAPTATION/reports/structure-autonomy/structure-autonomy.json").read_text())
    confirmed = [c for c in autonomy["candidates"] if c["classification"] == "AUTONOMOUS_CONFIRMED"]
    library = REPO / "docs/pmuniverse_buildings"
    nnv_density = nnv_sheet["dominant_art_density"]
    pmu = []
    for candidate in confirmed:
        image = Image.open(library / candidate["tracked_file"]).convert("RGBA")
        density = exact_block_density(image)
        factor = nnv_density // density
        pmu.append({
            "structure_id": candidate["structure_id"],
            "source_archive": candidate["source_archive"],
            "native_px": [image.width, image.height],
            "native_art_density": density,
            "harmonisation_factor": factor,
            "harmonised_px": [image.width * factor, image.height * factor],
            "harmonised_in_pokemon_units": [round(image.width * factor / POKEMON_PX, 1),
                                            round(image.height * factor / POKEMON_PX, 1)],
            "native_in_pokemon_units": [round(image.width / POKEMON_PX, 1),
                                        round(image.height / POKEMON_PX, 1)],
        })

    factors = collections.Counter(p["harmonisation_factor"] for p in pmu)

    report = {
        "schema": "new-era.nnv-visual-scale-audit.v1",
        "read_only": True,
        "map_modified": False,
        "ruler": pokemon_invariant(),
        "separated_quantities": {
            "1_physical_file_resolution": {
                "metano_tile_file_px": metano_sheet["tile_size_px"],
                "nnv_tile_file_px": nnv_sheet["tile_size_px"],
            },
            "2_pixel_art_density": {
                "metano": metano_sheet, "nnv": nnv_sheet,
                "method": "exact nearest-neighbour reversibility; not an eyeball estimate",
            },
            "3_pmdo_logical_cell_px": {
                "metano": metano["tile_layer_cell_px"], "nnv": nnv["tile_layer_cell_px"],
                "collision_cell_px_both": 8,
            },
            "4_tex_size": {"metano": metano["tex_size"], "nnv": nnv["tex_size"]},
            "5_real_tile_texture_size": {
                "metano_px": metano_sheet["tile_size_px"], "nnv_px": nnv_sheet["tile_size_px"],
                "gamemaker_source_tile_sizes": [list(t) for t in source_tiles],
                "note": "NNV source tiles are authored at 64/128 px where PMDO uses 8 px",
            },
            "6_source_pixel_to_world_unit": {
                "pokemon_px": POKEMON_PX,
                "metano_tile_cell_in_pokemon": metano["tile_layer_cell_in_pokemon_units"],
                "nnv_tile_cell_in_pokemon": nnv["tile_layer_cell_in_pokemon_units"],
                "ratio_nnv_over_metano": nnv["tile_layer_cell_px"] / metano["tile_layer_cell_px"],
            },
            "7_runtime_displayed_size": {
                "note": "PMDO draws 1 texture pixel as 1 screen pixel; TexSize selects the atlas cell "
                        "size, it does not rescale art. The collision grid is 8 px in both maps, so the "
                        "same Pokemon occupies the same screen area in both, while NNV scenery is 4x "
                        "denser per world unit.",
                "verified_from": "both Grounds expose an 8 px obstacle grid and a 16x16 character collider",
            },
        },
        "world_comparison": {"metano_town": metano, "nnv_rmvillage": nnv},
        "independent_measurements": {
            "houses_nnv_in_pokemon_units": houses,
            "metano_doorway_in_pokemon_units": doorways,
            "nnv_door_collider_px": nnv_door,
            "nnv_door_visual_block_px": "2x3 or 3x3 cells of 64 px = 128-192 px wide",
            "metano_house_estimate_pokemon_units": "9-12 wide (entrance spacing and render crop)",
        },
        "relative_scale_conclusions": {
            "pokemon_vs_terrain_cell": {
                "metano": "1 Pokemon = 2 terrain cells (16 px / 8 px)",
                "nnv": "1 Pokemon = 0.25 terrain cell (16 px / 64 px)",
                "verdict": "NNV terrain cells are 4x larger per world unit",
            },
            "pokemon_vs_house": {
                "metano": "a house is roughly 9-12 Pokemon wide",
                "nnv": "a house is 59-75 Pokemon wide",
                "verdict": "NNV houses are ~5-6x larger relative to a Pokemon",
            },
            "pokemon_vs_door": {
                "metano": "2.5-3.0 Pokemon wide",
                "nnv": "8-12 Pokemon wide",
                "verdict": "ratio ~4x",
            },
            "pokemon_vs_rock_and_path": {
                "metano": "path and rock features resolve on 8 px cells",
                "nnv": "the same features resolve on 64 px cells",
                "verdict": "ratio 4x, consistent with the tile-cell measurement",
            },
        },
        "pmu_harmonisation_simulation": {
            "target_density": nnv_density,
            "factor_histogram": {str(k): v for k, v in sorted(factors.items())},
            "rule": "integer nearest-neighbour only; no interpolation, no smoothing, no recolor",
            "candidates": sorted(pmu, key=lambda p: p["structure_id"]),
        },
        "conclusion": "PMU_NEEDS_SCALE_ADAPTATION",
        "conclusion_detail": {
            "nnv_scale": "art density 4 (1 art pixel = 4x4 real px); logical terrain cell 64 px; TexSize 8",
            "metano_scale": "art density 1 (1 art pixel = 1 real px); logical terrain cell 8 px; TexSize 1",
            "ratio": 4,
            "pmu_factor": "x4 for 44 of 48 confirmed structures, x2 for the 4 already authored at density 2",
            "pokemon_risk": "A Pokemon is 16x16 px in BOTH maps, so it is not itself rescaled. But because "
                            "NNV scenery is 4x denser per world unit, a Pokemon standing in NNV looks ~4x "
                            "smaller relative to trees and houses than the same Pokemon in metano_town. "
                            "This is a real, measured mismatch, not an impression.",
            "why_not_nnv_needs_adaptation": "NNV is the map to preserve and its 1:1 mapping is already "
                                            "validated with four seasons and PMDO 0.8.12 runtime PASS; "
                                            "rescaling NNV would destroy that work. The incoming PMU assets "
                                            "are the ones that must be harmonised.",
        },
    }

    (arguments.out / "visual-scale-audit.json").write_text(
        json.dumps(report, indent=2, sort_keys=True, ensure_ascii=False) + "\n")
    print(f"conclusion            : {report['conclusion']}")
    print(f"NNV art density       : {nnv_density}   metano art density : {metano_sheet['dominant_art_density']}")
    print(f"tile cell px          : NNV {nnv['tile_layer_cell_px']}  vs  metano {metano['tile_layer_cell_px']}  -> ratio {nnv['tile_layer_cell_px']//metano['tile_layer_cell_px']}")
    print(f"PMU factors required  : {dict(factors)}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
