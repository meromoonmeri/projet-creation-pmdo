#!/usr/bin/env python3
"""Materialise un Ground rmvillage complet pour une saison, APRES normalisation x0,125.

Pourquoi cet outil existe
-------------------------
`materialize_rmvillage_season.py` refuse de tourner depuis la normalisation :
son garde-fou attend la geometrie d'avant (4992 px, TexSize 8) et un baseline
runtime explicitement marque `obsolete: true`. Resultat mesure sur le depot :

    summer/Content/Tile/NNV_rmvillage_PMU_Buildings.tile   PRESENT
    spring|autumn|winter/Content/Tile/...PMU_Buildings.tile ABSENT

Les six batiments PMU n'existaient donc que dans l'ete. Les trois autres
saisons sont des bundles de layers seuls : ni `Decorations`, ni `obstacles`,
ni planche PMU. Les rendus quatre saisons deja publies compositaient les
batiments par-dessus, ce qui donnait l'illusion de la coherence sans qu'elle
existe dans les donnees.

Contrat applique ici
--------------------
    squelette          = le Ground ete (obstacles, Entities, Decorations)
    layers             = ceux de la saison demandee, tels quels
    Decorations        = PARTAGEES, jamais recopiees a la main
    planche PMU        = octets identiques dans les quatre saisons
    assets PMU         = x1 natif, aucun rescale, aucune recoloration

La source unique des batiments est le squelette ete. Une maison ne peut donc
pas diverger d'une saison a l'autre : il n'existe qu'un seul exemplaire de la
donnee. L'invariant est verifie apres coup, pas suppose.

Ecrit uniquement sous `.runtime-cache/` (Grounds complets, ~57 Mo piece, hors
Git) et la planche PMU par saison sous `generated/` (44 Ko, suivie).
"""
from __future__ import annotations

import argparse
import gzip
import hashlib
import json
import shutil
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parent
GEN = ROOT / "generated/rmvillage"
SEASONS = ("spring", "summer", "autumn", "winter")
PMU_SHEET = "NNV_rmvillage_PMU_Buildings.tile"

EXPECTED_TEX = 1
EXPECTED_WORLD = 624
EXPECTED_GRID = 78


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load_summer_skeleton() -> dict:
    path = GEN / "summer/Data/Ground/nnv_rmvillage_summer.rsground"
    document = json.loads(path.read_text(encoding="utf-8-sig"))
    obj = document["Object"]
    if obj["TexSize"] != EXPECTED_TEX:
        raise SystemExit(f"squelette ete: TexSize {obj['TexSize']} != {EXPECTED_TEX}")
    if len(obj["obstacles"]) != EXPECTED_GRID:
        raise SystemExit("squelette ete: grille de collision inattendue")
    return document


def load_season_layers(season: str) -> list:
    if season == "summer":
        return None
    bundle = GEN / season / f"Data/Ground/nnv_rmvillage_{season}.layers.json.gz"
    manifest = json.loads((GEN / season / "manifest.json").read_text())
    declared = manifest["outputs"]["season_layers_sha256"]
    actual = sha256_file(bundle)
    if declared != actual:
        raise SystemExit(f"{season}: hash du bundle de layers divergent")
    with gzip.open(bundle, "rt", encoding="utf-8") as stream:
        data = json.load(stream)
    if data["dimensions_px"] != [EXPECTED_WORLD, EXPECTED_WORLD]:
        raise SystemExit(f"{season}: dimensions {data['dimensions_px']} inattendues")
    if data["tex_size"] != EXPECTED_TEX:
        raise SystemExit(f"{season}: tex_size {data['tex_size']} inattendu")
    return data["layers"]


def decorations_fingerprint(obj: dict) -> str:
    """Empreinte semantique des batiments poses, independante du formatage."""
    anims = []
    for group in obj["Decorations"]:
        for anim in group["Anims"]:
            anims.append({
                "x": anim["MapLoc"]["X"],
                "y": anim["MapLoc"]["Y"],
                "sheet": anim["Anim"]["AnimIndex"],
                "frame": anim["Anim"]["StartFrame"],
                "alpha": anim["Anim"]["Alpha"],
            })
    payload = json.dumps(anims, sort_keys=True, separators=(",", ":"))
    return hashlib.sha256(payload.encode()).hexdigest()


def sync_pmu_sheet(season: str) -> dict:
    """La planche PMU doit exister, octet pour octet, dans chaque saison."""
    source = GEN / "summer/Content/Tile" / PMU_SHEET
    target = GEN / season / "Content/Tile" / PMU_SHEET
    reference = sha256_file(source)
    if season == "summer":
        return {"season": season, "action": "source", "sha256": reference}
    target.parent.mkdir(parents=True, exist_ok=True)
    action = "unchanged"
    if not target.exists() or sha256_file(target) != reference:
        shutil.copyfile(source, target)
        action = "written"
    if sha256_file(target) != reference:
        raise SystemExit(f"{season}: planche PMU non identique apres copie")
    return {"season": season, "action": action, "sha256": reference}


def materialize(season: str, output: Path) -> dict:
    document = load_summer_skeleton()
    obj = document["Object"]
    layers = load_season_layers(season)

    if layers is not None:
        summer_names = [l["Name"] for l in obj["Layers"]]
        season_names = [l["Name"] for l in layers]
        if summer_names != season_names:
            raise SystemExit(f"{season}: jeu de layers different de l'ete")
        obj["Layers"] = layers

    fingerprint = decorations_fingerprint(obj)

    obj["AssetName"] = f"nnv_rmvillage_{season}"
    obj["Name"] = {
        "DefaultText": f"No Name Village — rmvillage ({season})",
        "LocalTexts": {"fr": f"Village Sans Nom — {season}"},
    }

    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text("\ufeff" + json.dumps(document, ensure_ascii=False, separators=(",", ":")),
                      encoding="utf-8")

    check = json.loads(output.read_text(encoding="utf-8-sig"))["Object"]
    if check["AssetName"] != f"nnv_rmvillage_{season}":
        raise SystemExit(f"{season}: AssetName non ecrit")
    if check["TexSize"] != EXPECTED_TEX:
        raise SystemExit(f"{season}: TexSize divergent apres ecriture")
    if len(check["obstacles"]) != EXPECTED_GRID:
        raise SystemExit(f"{season}: obstacles divergents apres ecriture")
    if len(check["Layers"][0]["Tiles"]) != EXPECTED_GRID:
        raise SystemExit(f"{season}: grille de tuiles divergente apres ecriture")
    if decorations_fingerprint(check) != fingerprint:
        raise SystemExit(f"{season}: Decorations alterees a l'ecriture")

    buildings = [
        {"x": a["MapLoc"]["X"], "y": a["MapLoc"]["Y"], "frame": a["Anim"]["StartFrame"],
         "sheet": a["Anim"]["AnimIndex"]}
        for group in check["Decorations"] for a in group["Anims"]
    ]
    blocked = sum(1 for col in check["obstacles"] for cell in col if cell["Tags"])

    return {
        "season": season,
        "output": str(output),
        "sha256": sha256_file(output),
        "tex_size": check["TexSize"],
        "world_px": [EXPECTED_GRID * 8, EXPECTED_GRID * 8],
        "collision_grid": [len(check["obstacles"]), len(check["obstacles"][0])],
        "collision_blocked_cells": blocked,
        "layers": [l["Name"] for l in check["Layers"]],
        "buildings": buildings,
        "decorations_fingerprint": fingerprint,
    }


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--season", choices=SEASONS + ("all",), default="all")
    parser.add_argument("--outdir", type=Path,
                        default=REPO / ".runtime-cache/nnv-seasons-x0125")
    args = parser.parse_args()

    seasons = SEASONS if args.season == "all" else (args.season,)
    results, sheets = [], []
    for season in seasons:
        sheets.append(sync_pmu_sheet(season))
        results.append(materialize(season, args.outdir / f"nnv_rmvillage_{season}.rsground"))

    fingerprints = {r["decorations_fingerprint"] for r in results}
    coherent = len(fingerprints) == 1
    sheet_hashes = {s["sha256"] for s in sheets}

    summary = {
        "schema": "new-era.nnv-season-ground-x0125.v1",
        "rule": "un seul exemplaire des batiments (squelette ete) partage par les quatre saisons",
        "seasons": results,
        "pmu_sheet": sheets,
        "pmu_sheet_identical_across_seasons": len(sheet_hashes) == 1,
        "decorations_identical_across_seasons": coherent,
        "runtime_status": "NOT_RUN",
        "certification_status": "NOT_CERTIFIED",
    }
    print(json.dumps(summary, indent=2, ensure_ascii=False))
    if not coherent:
        raise SystemExit("INCOHERENT: les Decorations divergent entre saisons")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
