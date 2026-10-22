#!/usr/bin/env python3
"""Mesure une structure fournie par le proprietaire et la ramene a l'echelle PMDO.

Ce que cet outil NE fait pas
----------------------------
Il n'ecrit rien sous `Data/`, ne touche aucun `.rsground`, aucune planche
`.tile`, aucune map. Il produit des mesures et des apercus. Le choix de
l'echelle finale revient au proprietaire du projet.

Constat mesure sur ASSSET.png, et pourquoi il compte
----------------------------------------------------
L'image fournie n'est PAS du pixel-art natif, malgre son apparence :

    224 057 couleurs distinctes        (du pixel-art en a quelques dizaines)
    alpha maximal 254, jamais 255      (aucun pixel pleinement opaque)
    epaisseur de contour 5 a 12 px     (un contour natif est constant)
    aucune grille de blocs detectable  (variance intra-bloc croissante des f=2)

Consequence directe : il n'existe pas de "taille native" a retrouver par
division entiere. Toute reduction est un rendu, pas une restitution. L'outil
l'assume et le dit, au lieu de choisir un facteur en silence.

Referentiel applique — celui deja etabli et versionne dans
`reports/pmdo-scale-reference/` :

    unite monde PMDO   = 8 px
    Pokemon            = 16 px = 2x2 unites monde
    maison PMDO type   = 114 px de large (mediane mesuree) = 7,1 Pokemon
    structures PMU confirmees : 40 a 212 px, mediane 98 px

Reechantillonnage : NEAREST exclusivement, conformement a la regle du projet.
LANCZOS n'est produit qu'en colonne de CONTROLE, explicitement etiquetee, pour
rendre visible ce que NEAREST coute sur une source non-pixel-art. Il n'est
jamais propose a l'integration.
"""
from __future__ import annotations

import argparse
import hashlib
import json
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parent

POKEMON_PX = 16
WORLD_UNIT_PX = 8
PMDO_HOUSE_MEDIAN_PX = 114
PMU_CONFIRMED_MIN = 40
PMU_CONFIRMED_MAX = 212
PMU_CONFIRMED_MEDIAN = 98


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def opacify_body(image: Image.Image, threshold: int = 250) -> tuple[Image.Image, int]:
    """Ramene a 255 les pixels quasi opaques du corps du batiment.

    Pourquoi c'est necessaire, et pourquoi ce n'est pas une retouche d'auteur
    ----------------------------------------------------------------------
    L'asset fourni n'a AUCUN pixel a alpha 255 : son maximum est 254, et
    l'essentiel du corps est a 253. Ce n'est pas une intention artistique, c'est
    un artefact de generation — un batiment opaque n'a pas de raison de laisser
    passer 1 % du fond.

    Consequence mesuree en situation : compose sur le terrain rmvillage, le
    meme batiment donnait 23 382 divergences de pixels entre les quatre
    saisons. Le terrain saisonnier transparaissait a travers les murs. En jeu,
    la maison se serait teintee en vert au printemps et en lavande en hiver.

    Seuls les pixels DEJA quasi opaques (alpha >= 250) sont concernes. Les
    bords volontairement doux, les ombres portees et les zones translucides
    sont laisses intacts : ils doivent se composer avec le terrain.
    """
    pixels = image.load()
    promoted = 0
    for y in range(image.height):
        for x in range(image.width):
            r, g, b, a = pixels[x, y]
            if threshold <= a < 255:
                pixels[x, y] = (r, g, b, 255)
                promoted += 1
    return image, promoted


def strip_halo(image: Image.Image, threshold: int) -> tuple[Image.Image, int]:
    """Retire le halo quasi transparent qui entoure le sujet.

    L'image fournie porte 27 889 px d'alpha 1..8, colores en noir pur, vert pur
    et rouge pur — des residus de compression, pas du dessin. Les garder
    fausserait la bbox de 6 px et polluerait les bords en jeu.
    """
    pixels = image.load()
    removed = 0
    for y in range(image.height):
        for x in range(image.width):
            r, g, b, a = pixels[x, y]
            if 0 < a <= threshold:
                pixels[x, y] = (0, 0, 0, 0)
                removed += 1
    return image, removed


def native_grid_probe(image: Image.Image) -> dict:
    """Cherche une grille de pixel-art. Repond NON quand il n'y en a pas."""
    source = image.convert("RGB")
    width, height = source.size
    data = list(source.getdata())  # noqa: PIL deprecation, stable en 12.x

    def block_variance(factor: int) -> float:
        total = 0.0
        blocks = 0
        for by in range(0, height - factor + 1, factor):
            for bx in range(0, width - factor + 1, factor):
                values = [data[(by + dy) * width + bx + dx]
                          for dy in range(factor) for dx in range(factor)]
                for channel in range(3):
                    column = [v[channel] for v in values]
                    mean = sum(column) / len(column)
                    total += sum((c - mean) ** 2 for c in column) / len(column)
                blocks += 1
        return total / max(1, blocks)

    probes = {factor: round(block_variance(factor), 3) for factor in (2, 3, 4)}
    monotonic = probes[2] < probes[3] < probes[4]
    return {
        "intra_block_variance": probes,
        "grid_detected": not monotonic,
        "interpretation": (
            "aucune grille : la variance intra-bloc croit des f=2, l'image est "
            "au pixel pres" if monotonic else
            "grille possible, verifier manuellement avant tout downscale"
        ),
    }


def alpha_profile(image: Image.Image) -> dict:
    alpha = image.split()[3].histogram()
    return {
        "fully_transparent": alpha[0],
        "fully_opaque_255": alpha[255],
        "partially_transparent": sum(alpha) - alpha[0] - alpha[255],
        "note": ("aucun pixel a alpha 255 : le moteur composera TOUT le "
                 "batiment avec le terrain, y compris son coeur"
                 if alpha[255] == 0 else "coeur pleinement opaque present"),
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--asset", type=Path, default=REPO / "ASSSET.png")
    parser.add_argument("--halo-threshold", type=int, default=8)
    parser.add_argument("--out", type=Path, default=ROOT / "reports/owner-structure")
    parser.add_argument("--targets", type=int, nargs="+", default=[114, 144, 176, 212],
                        help="largeurs cibles en px, exprimees dans le referentiel PMDO")
    args = parser.parse_args()

    args.out.mkdir(parents=True, exist_ok=True)
    original = Image.open(args.asset).convert("RGBA")
    source_size = list(original.size)

    cleaned, halo_removed = strip_halo(original.copy(), args.halo_threshold)
    box = cleaned.getbbox()
    core = cleaned.crop(box)
    core, opacified = opacify_body(core)
    core_path = args.out / "core_native.png"
    core.save(core_path)

    grid = native_grid_probe(core.resize((core.width // 4, core.height // 4), Image.NEAREST))
    alpha = alpha_profile(core)

    variants = []
    for target in args.targets:
        ratio = target / core.width
        height = max(1, round(core.height * ratio))
        nearest = core.resize((target, height), Image.NEAREST)
        name = f"core_w{target}_NEAREST.png"
        nearest.save(args.out / name)
        control = core.resize((target, height), Image.LANCZOS)
        control_name = f"CONTROL_ONLY_core_w{target}_LANCZOS.png"
        control.save(args.out / control_name)
        variants.append({
            "target_width_px": target,
            "result_px": [target, height],
            "divisor_from_source": round(core.width / target, 3),
            "divisor_is_integer": abs(core.width / target - round(core.width / target)) < 1e-9,
            "in_pokemon_units": [round(target / POKEMON_PX, 2), round(height / POKEMON_PX, 2)],
            "world_units_8px": [round(target / WORLD_UNIT_PX, 2), round(height / WORLD_UNIT_PX, 2)],
            "vs_pmdo_house_median": round(target / PMDO_HOUSE_MEDIAN_PX, 2),
            "within_pmu_confirmed_range": PMU_CONFIRMED_MIN <= target <= PMU_CONFIRMED_MAX,
            "nearest_png": name,
            "nearest_sha256": sha256(args.out / name),
            "control_lanczos_png": control_name,
            "control_note": "COLONNE DE CONTROLE — jamais integree, sert a montrer le cout de NEAREST",
        })

    report = {
        "schema": "new-era.owner-structure-measurement.v1",
        "asset": str(args.asset.relative_to(REPO)),
        "asset_sha256": sha256(args.asset),
        "source_px": source_size,
        "halo_px_removed": halo_removed,
        "body_px_opacified_to_255": opacified,
        "why_opacified": ("l'asset n'avait AUCUN pixel a alpha 255 ; le terrain "
                          "saisonnier transparaissait a travers les murs, 23 382 px "
                          "divergeaient entre les 4 saisons. Seuls les pixels deja "
                          "quasi opaques (alpha >= 250) sont promus ; bords doux et "
                          "ombres restent translucides."),
        "halo_threshold_alpha": args.halo_threshold,
        "core_bbox_in_source": list(box),
        "core_px": [core.width, core.height],
        "core_sha256": sha256(core_path),
        "is_native_pixel_art": False,
        "why_not_native_pixel_art": {
            "distinct_colors": len(core.convert("RGB").getcolors(1 << 24) or []),
            "grid_probe": grid,
            "alpha_profile": alpha,
        },
        "pmdo_reference": {
            "world_unit_px": WORLD_UNIT_PX,
            "pokemon_px": POKEMON_PX,
            "house_median_px": PMDO_HOUSE_MEDIAN_PX,
            "pmu_confirmed_range_px": [PMU_CONFIRMED_MIN, PMU_CONFIRMED_MAX],
            "pmu_confirmed_median_px": PMU_CONFIRMED_MEDIAN,
            "source": "reports/pmdo-scale-reference/",
        },
        "core_in_pokemon_units_at_x1": [round(core.width / POKEMON_PX, 2),
                                        round(core.height / POKEMON_PX, 2)],
        "verdict_at_x1": (f"{round(core.width / PMDO_HOUSE_MEDIAN_PX, 1)}x trop large pour "
                          f"une maison PMDO : integration a x1 refusee"),
        "resampling": "NEAREST exclusivement ; LANCZOS produit en controle etiquete, jamais integre",
        "variants": variants,
        "stage": "MEASUREMENT_ONLY",
        "map_modified": False,
        "integration_allowed": False,
        "integration_unlock_condition": "le proprietaire choisit une largeur cible et valide l'apercu",
    }

    (args.out / "owner-structure.json").write_text(
        json.dumps(report, indent=2, ensure_ascii=False, sort_keys=True) + "\n", encoding="utf-8")
    print(json.dumps({k: report[k] for k in
                      ("core_px", "core_in_pokemon_units_at_x1", "verdict_at_x1",
                       "is_native_pixel_art", "halo_px_removed")},
                     indent=2, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
