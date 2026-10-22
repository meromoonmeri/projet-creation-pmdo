#!/usr/bin/env python3
"""Audit pixel des Grounds WoN : cherche les bugs de texture et d'affichage.

Ce que « pas de bug » doit vouloir dire
---------------------------------------
Un compteur a zero ne prouve rien. Cet audit repond a des questions precises,
chacune capable de repondre NON, et chaque reponse est mesuree sur les octets
reellement ecrits — pas sur une intention.

Controles appliques a chaque carte et chaque saison
---------------------------------------------------
1. **Fidelite pixel** — le Ground est recompose depuis sa planche `.tile` et sa
   grille, exactement comme le moteur le fera, puis compare au rendu source de
   la ROM. Pour la saison de reference (ete), l'egalite doit etre STRICTE :
   toute difference est une texture corrompue, decalee ou perdue.

2. **Tuiles resolues** — chaque cellule de la grille doit trouver sa texture
   dans la planche. Une cellule non resolue est un trou noir a l'ecran.

3. **Couverture** — aucune cellule ne doit rester vide si la source ne l'etait
   pas.

4. **Alignement de grille** — `TexSize`, dimensions de la planche, grille de
   collision et grille de tuiles doivent coincider. Un decalage d'une cellule
   suffit a decaler tout l'affichage.

5. **Premultiplication** — PMDO stocke l'alpha premultiplie. Un canal RGB
   superieur a son alpha est impossible dans une image correctement
   premultipliee et produit des halos clairs sur les bords.

6. **Divergence saisonniere** — les saisons doivent differer LA ou il y a du
   feuillage, et etre identiques ailleurs. Une carte sans verdure dont les
   quatre saisons different signale une recoloration parasite.

Fail-closed : toute anomalie est listee, aucune n'est arrondie.
"""
from __future__ import annotations

import argparse
import hashlib
import io
import json
import struct
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parent
CELL = 8
SEASONS = ("spring", "summer", "autumn", "winter")
REFERENCE = "summer"


def read_sheet(path: Path):
    raw = path.read_bytes()
    tile_size, count = struct.unpack_from("<II", raw, 0)
    images = {}
    for index in range(count):
        key, offset = struct.unpack_from("<QQ", raw, 8 + index * 16)
        (length,) = struct.unpack_from("<Q", raw, offset)
        images[key] = Image.open(io.BytesIO(raw[offset + 8: offset + 8 + length])).convert("RGBA")
    return tile_size, images


def unpremultiply(image: Image.Image) -> Image.Image:
    pixels = bytearray(image.tobytes())
    for offset in range(0, len(pixels), 4):
        alpha = pixels[offset + 3]
        if alpha:
            for channel in range(3):
                pixels[offset + channel] = min(
                    255, (pixels[offset + channel] * 255 + alpha // 2) // alpha)
    return Image.frombytes("RGBA", image.size, bytes(pixels))


def premultiply_violations(images) -> int:
    """RGB > alpha est impossible en premultiplie : signe de halo clair."""
    bad = 0
    for image in images.values():
        data = image.tobytes()
        for offset in range(0, len(data), 4):
            alpha = data[offset + 3]
            if data[offset] > alpha or data[offset + 1] > alpha or data[offset + 2] > alpha:
                bad += 1
    return bad


def compose(ground_path: Path, sheets) -> tuple[Image.Image, int, int]:
    obj = json.loads(ground_path.read_text(encoding="utf-8-sig"))["Object"]
    columns = len(obj["Layers"][0]["Tiles"])
    rows = len(obj["Layers"][0]["Tiles"][0])
    canvas = Image.new("RGBA", (columns * CELL, rows * CELL), (0, 0, 0, 0))
    unresolved = empty = 0
    for layer in obj["Layers"]:
        if not layer.get("Visible"):
            continue
        for cx in range(columns):
            for cy in range(rows):
                stack = layer["Tiles"][cx][cy].get("Layers") or []
                if not stack:
                    empty += 1
                    continue
                frames = stack[0].get("Frames") or []
                if not frames:
                    empty += 1
                    continue
                frame = frames[0]
                sheet = sheets.get(frame["Sheet"])
                block = sheet.get((frame["TexLoc"]["Y"] << 32) | frame["TexLoc"]["X"]) if sheet else None
                if block is None:
                    unresolved += 1
                    continue
                canvas.alpha_composite(block, (cx * CELL, cy * CELL))
    return canvas, unresolved, empty, obj


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--grounds", type=Path, default=REPO / ".runtime-cache/won-grounds")
    parser.add_argument("--renders", type=Path, required=True)
    parser.add_argument("--report", type=Path,
                        default=ROOT / "reports/won-world/TEXTURE_AUDIT.json")
    args = parser.parse_args()

    maps = []
    anomalies = []
    for map_dir in sorted(p for p in args.grounds.iterdir() if p.is_dir()):
        name = map_dir.name
        source_png = args.renders / f"{name}.png"
        source = Image.open(source_png).convert("RGBA")

        per_season = {}
        composed = {}
        for season in SEASONS:
            ground = map_dir / f"{season}/Data/Ground/won_{name}_{season}.rsground"
            sheet_path = map_dir / f"{season}/Content/Tile/WoN_{name}_{season}.tile"
            tile_size, raw_images = read_sheet(sheet_path)
            premul_bad = premultiply_violations(raw_images)
            sheets = {sheet_path.stem: {k: unpremultiply(v) for k, v in raw_images.items()}}
            canvas, unresolved, empty, obj = compose(ground, sheets)
            composed[season] = canvas

            columns = len(obj["Layers"][0]["Tiles"])
            rows = len(obj["Layers"][0]["Tiles"][0])
            grid_ok = (obj["TexSize"] == 1
                       and tile_size == CELL
                       and len(obj["obstacles"]) == columns
                       and len(obj["obstacles"][0]) == rows
                       and canvas.size == source.size)

            entry = {
                "tile_size_px": tile_size,
                "tex_size": obj["TexSize"],
                "grid": [columns, rows],
                "canvas_px": list(canvas.size),
                "tiles_unresolved": unresolved,
                "cells_empty": empty,
                "grid_aligned": grid_ok,
                "premultiply_violations": premul_bad,
            }

            if season == REFERENCE:
                differing = 0
                sp, cp = source.load(), canvas.load()
                for y in range(source.height):
                    for x in range(source.width):
                        if sp[x, y] != cp[x, y]:
                            differing += 1
                entry["pixels_vs_source"] = source.width * source.height
                entry["pixels_differing_from_source"] = differing
                entry["pixel_identical_to_source"] = differing == 0
                if differing:
                    anomalies.append({"map": name, "season": season,
                                      "issue": "rendu different de la source ROM",
                                      "differing_px": differing})

            if unresolved:
                anomalies.append({"map": name, "season": season,
                                  "issue": "tuiles non resolues", "count": unresolved})
            if empty:
                anomalies.append({"map": name, "season": season,
                                  "issue": "cellules vides", "count": empty})
            if not grid_ok:
                anomalies.append({"map": name, "season": season,
                                  "issue": "grille desalignee", "detail": entry})
            if premul_bad:
                anomalies.append({"map": name, "season": season,
                                  "issue": "alpha premultiplie invalide (halos)",
                                  "count": premul_bad})
            per_season[season] = entry

        # Divergence saisonniere : doit exister si et seulement s'il y a du feuillage.
        digests = {s: hashlib.sha256(composed[s].tobytes()).hexdigest() for s in SEASONS}
        distinct = len(set(digests.values()))
        conversion = json.loads((ROOT / "reports/won-world/CONVERSION.json").read_text())
        record = next(m for m in conversion["maps"] if m["map"] == name)
        expected_distinct = 4 if record["foliage_seasonalised"] else 1
        season_ok = distinct == expected_distinct
        if not season_ok:
            anomalies.append({"map": name, "issue": "variantes saisonnieres incoherentes",
                              "distinct": distinct, "expected": expected_distinct})

        maps.append({
            "map": name,
            "source_px": list(source.size),
            "foliage_seasonalised": record["foliage_seasonalised"],
            "distinct_season_variants": distinct,
            "expected_season_variants": expected_distinct,
            "season_variants_ok": season_ok,
            "seasons": per_season,
        })
        flag = "OK" if not [a for a in anomalies if a.get("map") == name] else "ANOMALIE"
        print(f"  {name:10} {flag}", flush=True)

    report = {
        "schema": "new-era.won-texture-audit.v1",
        "checks": [
            "fidelite pixel du Ground recompose contre le rendu ROM (saison de reference)",
            "tuiles resolues dans la planche",
            "cellules vides",
            "alignement TexSize / planche / collision / tuiles",
            "alpha premultiplie valide (RGB <= alpha)",
            "divergence saisonniere presente si et seulement s'il y a du feuillage",
        ],
        "maps_audited": len(maps),
        "anomalies": anomalies,
        "anomaly_count": len(anomalies),
        "verdict": "CLEAN" if not anomalies else "ANOMALIES",
        "maps": maps,
        "not_proven": ("l'audit porte sur les octets ecrits et la composition hors moteur ; "
                       "il ne prouve pas que PMDO 0.8.12 affiche ces Grounds"),
    }
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2, ensure_ascii=False, sort_keys=True) + "\n",
                           encoding="utf-8")
    print(json.dumps({"maps": len(maps), "anomalies": len(anomalies),
                      "verdict": report["verdict"]}, indent=2))
    return 0 if not anomalies else 1


if __name__ == "__main__":
    raise SystemExit(main())
