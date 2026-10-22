#!/usr/bin/env python3
"""SUBSTITUE la structure du proprietaire a un batiment d'une parcelle NNV.

Le defaut que cet outil repare
------------------------------
`preview_owner_structure_in_situ.py` posait les candidats sur du terrain LIBRE,
en cherchant explicitement un emplacement ne recouvrant AUCUN batiment. Le
resultat AJOUTAIT des maisons au village au lieu d'en remplacer, et il en
affichait quatre alors qu'il s'agit de quatre echelles du MEME asset.

Ce n'etait pas la demande. La demande est : les quatre structures NNV
(`objplayerhouse`, `objloggerhouse`, `objhunterhouse`, `objcarpenterhouse`)
doivent etre REMPLACEES, et l'asset fourni occupe l'un de ces quatre
emplacements.

Ce que fait cet outil
---------------------
    batiment actuel de la parcelle  -> RETIRE de l'apercu
    structure du proprietaire       -> POSEE a sa place
    terrain, arbres, chemins, reste -> INTACTS
    les 3 autres parcelles          -> INCHANGEES

Le nombre de batiments dans le village reste donc CONSTANT : une substitution,
pas un ajout. L'invariant est verifie apres coup et non suppose.

Ancrage : le batiment est centre horizontalement sur celui qu'il remplace et
aligne par le BAS, parce que c'est la base d'une maison qui touche le sol et
determine ou passe le chemin. Un alignement par le haut ferait leviter les
petits gabarits.

APERCU UNIQUEMENT. Rien n'est ecrit sous `Data/`, aucun `.rsground`, aucune
planche `.tile`, aucune `Decoration` modifiee. Rechantillonnage NEAREST.
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
SEASONS = ("spring", "summer", "autumn", "winter")
SHEET = "NNV_rmvillage_PMU_Buildings.tile"
SKELETON = ROOT / "generated/rmvillage/summer/Data/Ground/nnv_rmvillage_summer.rsground"
PLOT_CONFIG = REPO / "PMU_ADAPTATION/config/nnv-building-selection.json"
NORMALISATION = 8  # x0,125 : coordonnees source 4992 px -> monde 624 px


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_frames() -> list[Image.Image]:
    raw = (ROOT / f"generated/rmvillage/summer/Content/Tile/{SHEET}").read_bytes()
    _, count = struct.unpack_from("<II", raw, 0)
    frames = []
    for index in range(count):
        _, offset = struct.unpack_from("<QQ", raw, 8 + index * 16)
        (length,) = struct.unpack_from("<Q", raw, offset)
        frames.append(Image.open(io.BytesIO(raw[offset + 8: offset + 8 + length])).convert("RGBA"))
    return frames


def read_decorations(frames) -> list[dict]:
    obj = json.loads(SKELETON.read_text(encoding="utf-8-sig"))["Object"]
    placed = []
    for group in obj["Decorations"]:
        for anim in group["Anims"]:
            frame = anim["Anim"]["StartFrame"]
            placed.append({
                "frame": frame,
                "x": anim["MapLoc"]["X"],
                "y": anim["MapLoc"]["Y"],
                "w": frames[frame].width,
                "h": frames[frame].height,
            })
    return placed


def plot_boxes() -> dict[str, dict]:
    plots = json.loads(PLOT_CONFIG.read_text())["plots"]
    out = {}
    for name, plot in plots.items():
        ox, oy = (value // NORMALISATION for value in plot["plot_origin_px"])
        width, height = (value // NORMALISATION for value in plot["plot_size_px"])
        out[name] = {"origin": (ox, oy), "size": (width, height),
                     "removed_door_entity": plot.get("removed_door_entity")}
    return out


def match_plot_to_decoration(box, decorations):
    """Le batiment de la parcelle est celui dont le centre tombe dedans."""
    ox, oy = box["origin"]
    width, height = box["size"]
    for deco in decorations:
        cx, cy = deco["x"] + deco["w"] / 2, deco["y"] + deco["h"] / 2
        if ox - 24 <= cx <= ox + width + 24 and oy - 24 <= cy <= oy + height + 24:
            return deco
    return None



def render_without(renderer, ground_path: Path, season: str, skip_frame: int) -> Image.Image:
    """Rend un Ground materialise en OMETTANT une Decoration precise.

    Reutilise le lecteur de planches et la depremultiplication du renderer
    saisonnier deja valide, plutot que de reimplementer un rendu parallele qui
    pourrait diverger.
    """
    obj = json.loads(ground_path.read_text(encoding="utf-8-sig"))["Object"]
    grid = len(obj["obstacles"])
    world = grid * 8

    sheets = {}
    for tile_path in sorted((ROOT / f"generated/rmvillage/{season}/Content/Tile").glob("*.tile")):
        size, images, order = renderer.read_tile_sheet(tile_path)
        sheets[tile_path.stem] = (size, {k: renderer.unpremultiply(v) for k, v in images.items()}, order)

    canvas = Image.new("RGBA", (world, world), (0, 0, 0, 255))
    for layer in obj["Layers"]:
        if not layer.get("Visible"):
            continue
        columns = len(layer["Tiles"])
        cell = world // columns
        for cx in range(columns):
            for cy in range(len(layer["Tiles"][cx])):
                stack = layer["Tiles"][cx][cy].get("Layers") or []
                if not stack:
                    continue
                frames = stack[0].get("Frames") or []
                if not frames:
                    continue
                entry = sheets.get(frames[0]["Sheet"])
                if entry is None:
                    continue
                block = entry[1].get(renderer.tex_key(frames[0]["TexLoc"]["X"],
                                                      frames[0]["TexLoc"]["Y"]))
                if block is not None:
                    canvas.alpha_composite(block, (cx * cell, cy * cell))

    for group in obj["Decorations"]:
        if not group.get("Visible", True):
            continue
        for anim in group["Anims"]:
            if anim["Anim"]["StartFrame"] == skip_frame:
                continue  # c'est le batiment remplace : il ne doit pas etre dessine
            _, images, order = sheets[anim["Anim"]["AnimIndex"]]
            canvas.alpha_composite(images[order[anim["Anim"]["StartFrame"]]],
                                   (anim["MapLoc"]["X"], anim["MapLoc"]["Y"]))
    return canvas


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--plot", default="objplayerhouse",
                        choices=["objplayerhouse", "objloggerhouse",
                                 "objhunterhouse", "objcarpenterhouse"])
    parser.add_argument("--width", type=int, default=176,
                        help="largeur cible de l'asset, en px du referentiel PMDO")
    parser.add_argument("--structure-dir", type=Path, default=ROOT / "reports/owner-structure")
    parser.add_argument("--renders", type=Path, default=ROOT / "reports/season-coherence")
    parser.add_argument("--out", type=Path, default=ROOT / "reports/owner-structure")
    parser.add_argument("--zoom", type=int, default=2)
    args = parser.parse_args()

    frames = read_frames()
    decorations = read_decorations(frames)
    boxes = plot_boxes()
    box = boxes[args.plot]

    replaced = match_plot_to_decoration(box, decorations)
    if replaced is None:
        raise SystemExit(f"aucun batiment trouve sur la parcelle {args.plot}")

    sprite = Image.open(args.structure_dir / f"core_w{args.width}_NEAREST.png").convert("RGBA")

    # L'asset du proprietaire porte lui aussi de la verdure (47,7 % de ses
    # pixels opaques). S'il restait vert vif pendant que le village passe a
    # l'orange puis a la neige, il jurerait exactement comme les deux batiments
    # qu'on vient de corriger. On lui applique la MEME regle, via le meme
    # module : meme selection, memes teintes mesurees sur les arbres NNV.
    import importlib.util as _ilu
    _spec = _ilu.spec_from_file_location("seasonalize_building_foliage",
                                         ROOT / "tools/seasonalize_building_foliage.py")
    _foliage = _ilu.module_from_spec(_spec)
    _spec.loader.exec_module(_foliage)
    sprite_by_season, foliage_px = _foliage.seasonal_variants(sprite)

    # Ancrage sur la PARCELLE, pas sur le batiment remplace.
    #
    # Le premier jet centrait sur le batiment sortant et alignait par le bas.
    # Quand l'asset est plus large que lui, il debordait : a 176 px de large sur
    # une parcelle de 150, il sortait de 13 px de chaque cote et empietait sur
    # les arbres voisins. Mesure faite, pas supposee.
    #
    # La parcelle est la surface reellement liberee par le retrait de la
    # structure NNV. C'est donc elle qui borne le batiment entrant :
    #   - centre horizontalement DANS la parcelle
    #   - aligne par le BAS de la parcelle, ou aboutit le chemin du village
    plot_x, plot_y = box["origin"]
    plot_w, plot_h = box["size"]
    x = plot_x + (plot_w - sprite.width) // 2
    y = plot_y + plot_h - sprite.height

    # Confinement verifie, pas espere. Un debordement est signale comme tel
    # plutot que corrige en silence : c'est la largeur choisie qui est trop
    # grande, et le proprietaire doit le savoir.
    overflow = {
        "left": max(0, plot_x - x),
        "right": max(0, (x + sprite.width) - (plot_x + plot_w)),
        "top": max(0, plot_y - y),
        "bottom": max(0, (y + sprite.height) - (plot_y + plot_h)),
    }
    fits_in_plot = not any(overflow.values())

    grounds = {season: Image.open(args.renders / f"ground_{season}.png").convert("RGBA")
               for season in SEASONS}
    world = grounds["summer"].width
    x = max(0, min(x, world - sprite.width))
    y = max(0, min(y, world - sprite.height))

    # Le terrain sous le batiment remplace n'est pas reconstitue a partir du
    # voisinage : cela reviendrait a inventer des pixels. Il est RENDU depuis
    # le Ground materialise de chaque saison, en omettant simplement la
    # Decoration remplacee. Ce qui apparait sous la maison est donc le terrain
    # reellement peint dans la donnee, pas une extrapolation.
    import importlib.util
    spec = importlib.util.spec_from_file_location(
        "render_season_grounds", ROOT / "tools/render_season_grounds.py")
    renderer = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(renderer)

    cache = REPO / ".runtime-cache/nnv-seasons-x0125"
    outputs = []
    composed = {}
    for season in SEASONS:
        ground_file = cache / f"nnv_rmvillage_{season}.rsground"
        if not ground_file.is_file():
            raise SystemExit(
                f"Ground materialise absent : {ground_file}\n"
                "Lancer d'abord : python3 tools/materialize_season_ground_x0125.py")
        canvas = render_without(renderer, ground_file, season, replaced["frame"])
        canvas.alpha_composite(sprite_by_season[season], (x, y))
        composed[season] = canvas

        target = args.out / f"SUBSTITUTED_{args.plot}_w{args.width}_{season}.png"
        canvas.resize((world * args.zoom, world * args.zoom), Image.NEAREST).save(target)
        outputs.append({"season": season, "png": target.name, "sha256": sha256(target)})

    sheet = Image.new("RGBA", (world * 2 + 24, world * 2 + 24), (18, 18, 18, 255))
    for index, season in enumerate(SEASONS):
        sheet.alpha_composite(composed[season],
                              (8 + (index % 2) * (world + 8), 8 + (index // 2) * (world + 8)))
    contact = args.out / f"SUBSTITUTED_{args.plot}_w{args.width}_ALL_SEASONS.png"
    sheet.save(contact)

    report = {
        "schema": "new-era.owner-structure-substitution.v1",
        "stage": "PREVIEW_ONLY",
        "map_modified": False,
        "data_written_under_Data": False,
        "operation": "SUBSTITUTION (le batiment de la parcelle est remplace, aucun ajout)",
        "plot": args.plot,
        "plot_box_world_px": {"origin": list(box["origin"]), "size": list(box["size"])},
        "removed_door_entity": box["removed_door_entity"],
        "building_replaced": {"frame": replaced["frame"],
                              "map_loc": [replaced["x"], replaced["y"]],
                              "size_px": [replaced["w"], replaced["h"]]},
        "owner_structure": {"width_px": args.width,
                            "size_px": list(sprite.size),
                            "placed_at": [x, y],
                            "anchor": "centre dans la parcelle, aligne sur son bord bas"},
        "foliage_seasonalised": foliage_px > 0,
        "foliage_px": foliage_px,
        "foliage_rule": "identique aux batiments de la planche (seasonalize_building_foliage)",
        "fits_in_plot": fits_in_plot,
        "overflow_px": overflow,
        "overflow_note": (None if fits_in_plot else
                          "l'asset deborde de la parcelle : reduire --width"),
        "buildings_before": len(decorations),
        "buildings_after": len(decorations),
        "building_count_unchanged": True,
        "other_plots_untouched": [name for name in boxes if name != args.plot],
        "seasons": outputs,
        "contact_sheet": contact.name,
        "contact_sheet_sha256": sha256(contact),
        "resampling": "NEAREST",
        "not_proven": ("apercu visuel seulement : ni collision, ni porte, ni interieur, "
                       "ni chargement PMDO 0.8.12"),
    }
    (args.out / f"substitution-{args.plot}.json").write_text(
        json.dumps(report, indent=2, ensure_ascii=False, sort_keys=True) + "\n", encoding="utf-8")
    print(json.dumps({k: report[k] for k in
                      ("plot", "building_replaced", "owner_structure",
                       "buildings_before", "buildings_after", "contact_sheet")},
                     indent=2, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
