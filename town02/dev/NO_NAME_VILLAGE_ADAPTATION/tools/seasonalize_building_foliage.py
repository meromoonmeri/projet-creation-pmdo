#!/usr/bin/env python3
"""Accorde le feuillage des batiments a la saison, depuis les arbres NNV reels.

Le probleme
-----------
Deux batiments du village portent de la verdure :

    frame 0  sanctuaire      30,3 % de pixels verts
    frame 2  maison a feuilles 65,7 % de pixels verts

Le verrou `verify_season_building_coherence.py` exige qu'un batiment soit
pixel-identique aux quatre saisons. C'est juste pour la pierre, le bois et la
tuile. Ca ne l'est pas pour des FEUILLES : en automne le village entier vire a
l'orange et en hiver a la neige, sauf ces deux toits restes vert vif.

La teinte n'est pas inventee
----------------------------
Elle est mesuree sur les sprites d'arbres que NNV utilise reellement pour
chaque saison, declares dans `season-vm-evidence.json` :

    spring  bgtree     H 0,410  S 0,744  V 0,690
    summer  bgsmtree   H 0,310  S 0,641  V 0,655
    autumn  bgautree   H 0,094  S 0,725  V 0,898
    winter  bgwntree   H 0,649  S 0,207  V 0,890

Mediane HSV sur ~99 000 pixels opaques et colores par arbre. L'ete sert de
reference puisque la planche PMU est authoree en teintes d'ete : le decalage
applique est celui qui mene de `bgsmtree` a l'arbre de la saison visee.

Ce qui est recolore, et ce qui ne l'est pas
-------------------------------------------
Seuls les pixels VERTS sont touches : teinte dans [0,18 ; 0,45], saturation
> 0,25, valeur > 0,12. La pierre, le bois, le tissu, les fruits rouges et les
ombres neutres sont hors selection et restent identiques d'une saison a
l'autre. Le masque est calcule une fois et enregistre : la meme selection sert
aux quatre saisons, donc aucune derive de bord n'est possible.

Le decalage porte sur la TEINTE et la SATURATION, pas sur la luminosite
relative : les nuances internes du feuillage (nervures claires, dessous
sombres) sont conservees telles quelles. Une feuille reste lisible comme une
feuille, elle change juste de couleur.

Ecrit une planche par saison. Les frames sans verdure sont recopiees
octet pour octet, ce qui garantit qu'elles ne peuvent pas diverger.
"""
from __future__ import annotations

import argparse
import colorsys
import hashlib
import io
import json
import struct
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parent
GEN = ROOT / "generated/rmvillage"
SHEET = "NNV_rmvillage_PMU_Buildings.tile"
SEASONS = ("spring", "summer", "autumn", "winter")
REFERENCE_SEASON = "summer"

# Mediane HSV du feuillage des arbres NNV, par saison. Mesure, pas choix.
TREE_HSV = {
    "spring": {"h": 0.4097, "s": 0.744, "v": 0.690, "sprite": "bgtree"},
    "summer": {"h": 0.3100, "s": 0.641, "v": 0.655, "sprite": "bgsmtree"},
    "autumn": {"h": 0.0944, "s": 0.725, "v": 0.898, "sprite": "bgautree"},
    "winter": {"h": 0.6489, "s": 0.207, "v": 0.890, "sprite": "bgwntree"},
}

# Borne basse a 0,155 et non 0,18.
#
# Mesure sur overw1 : la pelouse de Waves of Nostalgia se situe a H 0,155-0,18,
# JUSTE sous l'ancien seuil. Resultat visible a l'image : en hiver, le feuillage
# des arbres virait au lavande pendant que le sol restait jaune-vert d'ete.
#
# La borne ne peut pas descendre plus bas : a H 0,111 se trouve (255,223,159),
# qui est EXACTEMENT la meme couleur pour la pelouse claire et pour le chemin
# de sable. Recolorer cette teinte peindrait les chemins en orange puis en
# lavande. Verifie a l'image : la bande 0,155-0,18 couvre la pelouse et epargne
# le sable.
GREEN_HUE = (0.155, 0.45)
GREEN_MIN_SAT = 0.25
GREEN_MIN_VAL = 0.12

# Une frame n'est traitee que si sa verdure est MATIERE et non artefact.
# Mesure sur les 4 frames : sanctuaire 30,3 %, maison a feuilles 65,7 % d'un
# cote ; four a pain 0,08 % (6 px) et maison-Pokemon 3,1 % (248 px) de l'autre.
# Ces 6 et 248 px ont ete REGARDES : ce sont des liseres de contour et de
# l'antialiasing, pas des feuilles. Les recolorer poserait une frange orange
# ou lavande autour de batiments qui n'ont aucune verdure.
FOLIAGE_MATERIAL_RATIO = 0.10

# Compression de l'etalement des teintes autour de la couleur cible. A 1,0 on
# retombe sur un decalage rigide ; a 0 tout le feuillage devient monochrome.
# 0,45 conserve la lecture des nuances tout en empechant les extremes de sortir
# de la famille de couleur de la saison.
HUE_SPREAD = 0.45


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_sheet(payload: bytes):
    tile_size, count = struct.unpack_from("<II", payload, 0)
    entries = []
    for index in range(count):
        key, offset = struct.unpack_from("<QQ", payload, 8 + index * 16)
        (length,) = struct.unpack_from("<Q", payload, offset)
        entries.append((key, payload[offset + 8: offset + 8 + length]))
    return tile_size, entries


def write_sheet(path: Path, tile_size: int, entries) -> None:
    header = struct.pack("<II", tile_size, len(entries))
    offset = len(header) + len(entries) * 16
    table = b""
    body = b""
    for key, blob in entries:
        table += struct.pack("<QQ", key, offset)
        body += struct.pack("<Q", len(blob)) + blob
        offset += 8 + len(blob)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(header + table + body)


def foliage_mask(image: Image.Image) -> set[tuple[int, int]]:
    """Les pixels de feuillage, selectionnes une seule fois pour les 4 saisons."""
    pixels = image.load()
    mask = set()
    for y in range(image.height):
        for x in range(image.width):
            r, g, b, a = pixels[x, y]
            if a < 8:
                continue
            hue, sat, val = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
            if GREEN_HUE[0] <= hue <= GREEN_HUE[1] and sat > GREEN_MIN_SAT and val > GREEN_MIN_VAL:
                mask.add((x, y))
    return mask


def recolor(image: Image.Image, mask, season: str) -> Image.Image:
    """Applique le decalage ete -> saison visee sur les seuls pixels du masque."""
    if season == REFERENCE_SEASON:
        return image.copy()
    source = TREE_HSV[REFERENCE_SEASON]
    target = TREE_HSV[season]

    out = image.copy()
    pixels = out.load()
    for x, y in mask:
        r, g, b, a = pixels[x, y]
        hue, sat, val = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)

        # RECENTRAGE, et non decalage constant.
        #
        # Un decalage rigide H += (cible - reference) supposait que tout le
        # feuillage partage la teinte de l'arbre d'ete. Faux : la verdure
        # s'etale de H 0,155 (pelouse claire) a H 0,45 (vert profond). En
        # automne, le decalage de -0,216 envoyait la pelouse WoN de H 0,253 a
        # H 0,037 — du ROUGE. Mesure a l'image : le village entier virait au
        # rose fluo au lieu de l'orange.
        #
        # On mappe donc l'ECART a la reference, comprime autour de la teinte
        # cible. Une feuille plus claire que la moyenne le reste, mais la
        # famille entiere se recentre sur la couleur de la saison.
        delta = ((hue - source["h"] + 0.5) % 1.0) - 0.5
        hue = (target["h"] + delta * HUE_SPREAD) % 1.0
        sat = max(0.0, min(1.0, sat * (target["s"] / source["s"])))
        # La valeur (luminosite) n'est PAS ecrasee : les nervures claires et les
        # dessous sombres du feuillage doivent survivre au changement de saison.
        nr, ng, nb = colorsys.hsv_to_rgb(hue, sat, val)
        pixels[x, y] = (round(nr * 255), round(ng * 255), round(nb * 255), a)
    return out


def seasonal_variants(image: Image.Image) -> dict:
    """Les 4 variantes saisonnieres d'une image, masque calcule une seule fois.

    Expose pour que l'asset du proprietaire suive exactement la meme regle que
    les batiments de la planche : meme selection, memes teintes mesurees sur
    les arbres NNV. Deux chemins de recoloration divergeraient tot ou tard.
    """
    mask = foliage_mask(image)
    opaque = sum(1 for y in range(image.height) for x in range(image.width)
                 if image.getpixel((x, y))[3] >= 8)
    if len(mask) / max(1, opaque) < FOLIAGE_MATERIAL_RATIO:
        return {season: image.copy() for season in SEASONS}, 0
    return {season: recolor(image, mask, season) for season in SEASONS}, len(mask)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--apply", action="store_true",
                        help="ecrire les planches ; sans ce drapeau, simulation seule")
    parser.add_argument("--report", type=Path,
                        default=ROOT / "reports/season-coherence/FOLIAGE_SEASONALISATION.json")
    args = parser.parse_args()

    reference_sheet = GEN / f"{REFERENCE_SEASON}/Content/Tile/{SHEET}"
    tile_size, entries = read_sheet(reference_sheet.read_bytes())

    frames = [Image.open(io.BytesIO(blob)).convert("RGBA") for _, blob in entries]
    raw_masks = [foliage_mask(image) for image in frames]
    masks = []
    for image, mask in zip(frames, raw_masks):
        opaque = sum(1 for y in range(image.height) for x in range(image.width)
                     if image.getpixel((x, y))[3] >= 8)
        ratio = len(mask) / max(1, opaque)
        # En dessous du seuil, la selection est du bord, pas du feuillage.
        masks.append(mask if ratio >= FOLIAGE_MATERIAL_RATIO else set())

    per_frame = []
    for index, (image, mask, raw) in enumerate(zip(frames, masks, raw_masks)):
        opaque = sum(1 for y in range(image.height) for x in range(image.width)
                     if image.getpixel((x, y))[3] >= 8)
        per_frame.append({
            "frame": index,
            "size_px": list(image.size),
            "opaque_px": opaque,
            "green_px_selected": len(raw),
            "green_ratio": round(len(raw) / max(1, opaque), 4),
            "foliage_px": len(mask),
            "recolored": bool(mask),
            "note": (f"recopiee octet pour octet : {len(raw)} px verts, "
                     f"{round(100 * len(raw) / max(1, opaque), 2)} % — sous le seuil de "
                     f"{int(100 * FOLIAGE_MATERIAL_RATIO)} %, c'est du lisere de contour "
                     "et non du feuillage (verifie a l'image)"
                     if not mask else None),
        })

    written = {}
    if args.apply:
        for season in SEASONS:
            season_entries = []
            for (key, blob), image, mask in zip(entries, frames, masks):
                if not mask:
                    season_entries.append((key, blob))  # identique par construction
                    continue
                buffer = io.BytesIO()
                recolor(image, mask, season).save(buffer, format="PNG",
                                                  optimize=False, compress_level=9)
                season_entries.append((key, buffer.getvalue()))
            target = GEN / f"{season}/Content/Tile/{SHEET}"
            write_sheet(target, tile_size, season_entries)
            written[season] = sha256_file(target)

        # Verification : les frames SANS feuillage doivent rester identiques
        # entre saisons, celles AVEC doivent differer. L'inverse serait un bug.
        checks = []
        per_season = {season: read_sheet((GEN / f"{season}/Content/Tile/{SHEET}").read_bytes())[1]
                      for season in SEASONS}
        for index, entry in enumerate(per_frame):
            blobs = {season: per_season[season][index][1] for season in SEASONS}
            distinct = len({hashlib.sha256(b).hexdigest() for b in blobs.values()})
            expected = 4 if entry["recolored"] else 1
            checks.append({"frame": index, "distinct_variants": distinct,
                           "expected": expected, "ok": distinct == expected})
        if not all(check["ok"] for check in checks):
            raise SystemExit(f"verification echouee : {checks}")
    else:
        checks = []

    report = {
        "schema": "new-era.nnv-foliage-seasonalisation.v1",
        "question": "le feuillage des batiments suit-il la saison ?",
        "hue_source": ("mediane HSV des sprites d'arbres NNV declares dans "
                       "season-vm-evidence.json, ~99 000 px opaques par saison"),
        "reference_season": REFERENCE_SEASON,
        "tree_hsv": TREE_HSV,
        "foliage_selection": {"hue_range": list(GREEN_HUE),
                              "min_saturation": GREEN_MIN_SAT,
                              "min_value": GREEN_MIN_VAL,
                              "material_ratio_threshold": FOLIAGE_MATERIAL_RATIO,
                              "note": ("masque calcule UNE fois sur la planche de "
                                       "reference et reutilise pour les 4 saisons ; "
                                       "sous le seuil de materialite la frame est "
                                       "recopiee telle quelle")},
        "value_preserved": True,
        "why_value_preserved": ("la luminosite n'est pas ecrasee : nervures claires et "
                                "dessous sombres survivent, une feuille reste lisible"),
        "frames": per_frame,
        "frames_recolored": sum(1 for f in per_frame if f["recolored"]),
        "frames_untouched": sum(1 for f in per_frame if not f["recolored"]),
        "variant_checks": checks,
        "sheet_sha256_per_season": written,
        "applied": bool(args.apply),
    }
    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(report, indent=2, ensure_ascii=False, sort_keys=True) + "\n",
                           encoding="utf-8")
    print(json.dumps({k: report[k] for k in
                      ("frames_recolored", "frames_untouched", "variant_checks", "applied")},
                     indent=2, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
