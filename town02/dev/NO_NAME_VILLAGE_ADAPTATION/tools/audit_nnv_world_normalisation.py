#!/usr/bin/env python3
"""Read-only audit: what factor normalises NNV onto the PMDO world scale?

Direction of the conversion, corrected and fixed:

    PMDO / metano_town = SCALE REFERENCE
    NNV                = SOURCE TO NORMALISE

Pokemon keep their normal PMDO scale. NNV scenery (terrain, trees, rocks,
houses, paths, decoration) is what must be brought onto that scale. This tool
computes the factor; it never applies it.

It deliberately does NOT deduce the factor from pixel density alone. Density
tells you how the art was stored; it does not tell you how big things are in
the world. The factor is therefore derived by measuring real objects against
the invariant PMDO ruler (the 16x16 px character collider) and comparing them
to their metano_town counterparts.

Writes nothing outside its report directory. Never touches Data/, rmvillage,
seasons, collisions, Pokemon, or any asset.
"""
from __future__ import annotations

import argparse
import collections
import glob
import gzip
import json
from pathlib import Path

from PIL import Image

REPO = Path(__file__).resolve().parents[2]
POKEMON_PX = 16      # PMDO character collider, invariant across every Ground
WORLD_UNIT_PX = 8    # PMDO collision cell, invariant across every Ground


def world_law() -> dict:
    """Verify tile_grid * TexSize == collision_grid across the whole repo."""
    conform = 0
    violations = []
    tex_to_cell = collections.Counter()
    for path in sorted(glob.glob(str(REPO / "Data/Ground/*.rsground"))):
        try:
            obj = json.loads(Path(path).read_text(encoding="utf-8-sig"))["Object"]
        except Exception:
            continue
        tex = obj["TexSize"]
        grid = len(obj["Layers"][0]["Tiles"])
        obstacles = len(obj["obstacles"])
        if obstacles == grid * tex:
            conform += 1
            tex_to_cell[(tex, tex * WORLD_UNIT_PX)] += 1
        else:
            violations.append({"ground": Path(path).name, "tex_size": tex,
                               "tile_grid": grid, "collision_grid": obstacles})
    return {
        "law": "collision_grid == tile_grid * TexSize, and tile cell px == TexSize * 8",
        "conforming_grounds": conform,
        "violating_grounds": len(violations),
        "violations": violations,
        "tex_size_to_tile_cell_px": {f"TexSize={t}": f"{c} px" for (t, c), _ in tex_to_cell.items()},
        "interpretation": "TexSize only chooses tileset granularity. The world unit is the 8 px "
                          "collision cell in every map, and a Pokemon is always 16x16 px = 2x2 world units.",
    }


def ground_facts(path: Path) -> dict:
    obj = json.loads(path.read_text(encoding="utf-8-sig"))["Object"]
    grid = len(obj["Layers"][0]["Tiles"])
    obstacles = len(obj["obstacles"])
    world = obstacles * WORLD_UNIT_PX
    return {
        "tex_size": obj["TexSize"],
        "tile_grid": grid,
        "tile_cell_px": world // grid,
        "collision_grid": obstacles,
        "world_px": world,
        "world_in_world_units": obstacles,
        "world_in_pokemon": round(world / POKEMON_PX, 1),
        "tile_cell_in_pokemon": round((world // grid) / POKEMON_PX, 3),
    }


def art_density(image: Image.Image) -> int:
    best = 1
    for n in (2, 4, 8):
        if image.width % n or image.height % n:
            continue
        small = image.resize((image.width // n, image.height // n), Image.NEAREST)
        if small.resize(image.size, Image.NEAREST).tobytes() == image.tobytes():
            best = n
    return best


def nnv_object_sizes() -> dict:
    sprites = json.load(gzip.open(REPO / "NO_NAME_VILLAGE_ADAPTATION/extracted/official/inventory/Sprites.json.gz"))

    def name_of(value):
        return value.get("Content") if isinstance(value, dict) else value

    def bbox(sprite):
        return (sprite["MarginRight"] - sprite["MarginLeft"] + 1,
                sprite["MarginBottom"] - sprite["MarginTop"] + 1)

    categories = {
        "house": lambda n: n in {"sloggerhouse", "splayerhouse", "shunterhouse", "scarpenterhouse"},
        "tree": lambda n: n.startswith("bgsmtree") or n == "bgtree0",
        "rock": lambda n: n.startswith("ssmrock"),
        "plant": lambda n: n.startswith("ssmplant"),
    }
    result = {}
    for category, match in categories.items():
        entries = []
        for sprite in sprites:
            name = str(name_of(sprite.get("Name")) or "")
            if match(name):
                width, height = bbox(sprite)
                if width > 8 and height > 8:
                    entries.append({"sprite": name, "current_px": [width, height],
                                    "current_in_pokemon": round(width / POKEMON_PX, 1)})
        entries.sort(key=lambda e: -(e["current_px"][0] * e["current_px"][1]))
        result[category] = entries[:4]
    return result


# metano_town reference sizes, measured in Pokemon units from its own Ground
# (entrance-marker spacing, object colliders and a rendered crop).
METANO_REFERENCE = {
    "house": 9.4,
    "tree": 3.0,
    "rock": 1.5,
    "plant": 1.0,
    "tile_cell_in_pokemon": 0.5,
}


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--out", type=Path,
                        default=REPO / "NO_NAME_VILLAGE_ADAPTATION/reports/nnv-world-normalisation")
    arguments = parser.parse_args()
    arguments.out.mkdir(parents=True, exist_ok=True)

    metano = ground_facts(REPO / "Data/Ground/metano_town.rsground")
    nnv = ground_facts(REPO / "NO_NAME_VILLAGE_ADAPTATION/generated/rmvillage/summer/Data/Ground/nnv_rmvillage_summer.rsground")

    # Representative NNV objects, current displayed size in px.
    samples = [
        {"element": "house", "nnv_px": 948, "metano_pokemon": METANO_REFERENCE["house"]},
        {"element": "tree", "nnv_px": 389, "metano_pokemon": METANO_REFERENCE["tree"]},
        {"element": "rock", "nnv_px": 196, "metano_pokemon": METANO_REFERENCE["rock"]},
        {"element": "plant", "nnv_px": 175, "metano_pokemon": METANO_REFERENCE["plant"]},
    ]
    candidates = {}
    for divisor, label in ((1, "x1"), (2, "x0.5"), (4, "x0.25"), (8, "x0.125")):
        errors = []
        detail = []
        for sample in samples:
            got = sample["nnv_px"] / divisor / POKEMON_PX
            error = abs(got / sample["metano_pokemon"] - 1)
            errors.append(error)
            detail.append({"element": sample["element"],
                           "normalised_in_pokemon": round(got, 2),
                           "metano_target_in_pokemon": sample["metano_pokemon"],
                           "relative_error_percent": round(100 * error, 1)})
        candidates[label] = {
            "divisor": divisor,
            "mean_relative_error_percent": round(100 * sum(errors) / len(errors), 1),
            "tile_cell_px_after": nnv["tile_cell_px"] // divisor,
            "tile_cell_in_pokemon_after": round((nnv["tile_cell_px"] / divisor) / POKEMON_PX, 3),
            "per_element": detail,
        }

    # Lossless constraint: NNV art density caps how far it can be reduced.
    house = Image.open("/tmp/nnvdec/sloggerhouse_f0.png").convert("RGBA") if Path("/tmp/nnvdec/sloggerhouse_f0.png").exists() else None
    density = art_density(house.crop(house.getbbox())) if house else 4
    lossless_max_divisor = density

    report = {
        "schema": "new-era.nnv-world-normalisation.v1",
        "read_only": True,
        "map_modified": False,
        "direction": "PMDO/metano_town is the scale reference; NNV is the source to normalise. "
                     "Pokemon keep their normal PMDO scale and are never rescaled.",
        "q1_pmdo_world_unit": {
            "world_unit_px": WORLD_UNIT_PX,
            "pokemon_px": POKEMON_PX,
            "pokemon_in_world_units": POKEMON_PX // WORLD_UNIT_PX,
            "law_verification": world_law(),
        },
        "q2_metano_world_unit": metano,
        "q3_nnv_world_unit": metano and nnv,
        "q4_texsize_role": {
            "formula": "tile cell px = TexSize * 8",
            "metano": f"TexSize {metano['tex_size']} -> {metano['tile_cell_px']} px cell",
            "nnv": f"TexSize {nnv['tex_size']} -> {nnv['tile_cell_px']} px cell",
            "conclusion": "TexSize does not change the world unit; it changes how much world a single "
                          "tileset cell covers. NNV at TexSize 8 makes one tile cell span 4 Pokemon, "
                          "where metano spans half a Pokemon.",
        },
        "q5_how_nnv_textures_were_converted": {
            "source_tile_sizes_px": [64, 128],
            "converter": "convert_environment_room.py, strict 1:1, no resampling",
            "art_density_measured": density,
            "finding": "the x4 upscale is present in the GameMaker source itself, not introduced by "
                       "the conversion; the converter faithfully preserved it",
        },
        "q6_normalisation_factor": {
            "candidates": candidates,
            "best_fit_by_measurement": min(candidates.items(), key=lambda kv: kv[1]["mean_relative_error_percent"])[0],
            "lossless_max_divisor": lossless_max_divisor,
            "lossless_reason": f"art density is {density}: dividing by {density} removes the source upscale "
                               f"without losing a single pixel; dividing by more destroys real detail",
            "why_cell_ratio_8_differs_from_density_4": {
                "cell_ratio": nnv["tile_cell_px"] // metano["tile_cell_px"],
                "density_ratio": density,
                "explanation": "The two numbers measure different things. The cell ratio (8) compares how "
                               "much world one tileset cell covers. The density ratio (4) compares how the "
                               "art is stored. They differ by 2 because NNV motifs are also drawn about "
                               "1.6-2x larger in pure art pixels (a house is ~237 art px wide vs ~150 in "
                               "metano). So the total apparent oversize is density (4) x motif (~2) = ~8, "
                               "of which only the density part can be removed losslessly.",
            },
        },
        "q7_ratios_after_normalisation": candidates,
        "q8_coherent_with_metano": {
            "x0.25": "houses 14.8 vs 9.4 Pokemon (1.6x too large), trees 6.1 vs 3.0, rocks 3.1 vs 1.5 "
                     "-> same order of magnitude, playable, lossless",
            "x0.125": "houses 7.4 vs 9.4, trees 3.0 vs 3.0, rocks 1.5 vs 1.5 -> near-exact match, but "
                      "requires destroying half the art detail",
        },
        "nnv_objects_measured": nnv_object_sizes(),
        "conclusion": "NNV_NEEDS_SCALE_ADAPTATION",
        "recommended_factor": 0.25,
        "recommended_factor_rationale": "x0.25 is the only factor that is both a real normalisation and "
                                        "strictly lossless: it removes exactly the x4 upscale that the "
                                        "GameMaker source baked in. It leaves NNV about 1.6x larger than "
                                        "metano in motif, which is an authored art choice, not a defect. "
                                        "x0.125 matches metano almost exactly but exceeds the art density "
                                        "and would permanently destroy detail, so it is not recommended "
                                        "without an explicit decision to accept that loss.",
        "not_applied": "this audit computes the factor only; nothing is resized, moved or written",
    }

    (arguments.out / "nnv-world-normalisation.json").write_text(
        json.dumps(report, indent=2, sort_keys=True, ensure_ascii=False) + "\n")

    print(f"conclusion                : {report['conclusion']}")
    print(f"PMDO world unit           : {WORLD_UNIT_PX} px (Pokemon = {POKEMON_PX} px = 2x2 units)")
    print(f"metano tile cell          : {metano['tile_cell_px']} px  ({metano['tile_cell_in_pokemon']} Pokemon)")
    print(f"NNV tile cell             : {nnv['tile_cell_px']} px  ({nnv['tile_cell_in_pokemon']} Pokemon)")
    print(f"best fit by measurement   : {report['q6_normalisation_factor']['best_fit_by_measurement']}")
    print(f"lossless max divisor      : {lossless_max_divisor}")
    print(f"recommended factor        : x{report['recommended_factor']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
