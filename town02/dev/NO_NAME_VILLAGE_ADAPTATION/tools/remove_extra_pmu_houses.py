#!/usr/bin/env python3
"""Retire les DEUX maisons PMU posees hors parcelle, jamais demandees.

Ce qui s'est passe
------------------
Le commit `9de06a7d` — « Add two more PMU houses on real NNV clearings » — a
ajoute deux batiments au village :

    frame 4  tiles9_0361  110x98  @(304,272)   plot invente « hamlet_center »
    frame 5  tiles9_0380  125x88  @(432,456)   plot invente « hamlet_south »

Le village compte quatre parcelles NNV : `objplayerhouse`, `objloggerhouse`,
`objhunterhouse`, `objcarpenterhouse`. Les frames 0 a 3 les occupent. Les
frames 4 et 5 ne correspondent a **aucune** parcelle : ce sont des maisons
ajoutees sur des clairieres, pas des remplacements. Le proprietaire ne les a
jamais demandees.

Le retrait ne se limite pas aux sprites
---------------------------------------
Poser ces deux maisons avait aussi modifie le terrain sous elles. Mesure faite
contre l'etat d'avant `9de06a7d` :

    2 Decorations       ajoutees
    1 195 cellules      d'herbe effacees (715 sur `NNV grass0`, 480 sur `NNV grass1`)
    219 cellules 8 px   de collision posees

Retirer seulement les sprites laisserait deux clairieres pelees avec des murs
invisibles. Les trois sont donc annulees ensemble.

Methode : restauration, pas reconstruction
------------------------------------------
Le terrain d'origine n'est pas redessine ni extrapole — il est **relu dans le
Ground tel qu'il etait avant** `9de06a7d`, qui a la meme geometrie (TexSize 1,
78x78, 15 couches). Chaque cellule restauree est copiee depuis la donnee
historique. Aucun pixel n'est invente.

Les quatre parcelles NNV et leurs quatre batiments ne sont pas touches : les
frames 0 a 3 sont verifiees identiques avant et apres.
"""
from __future__ import annotations

import argparse
import gzip
import hashlib
import io
import json
import struct
import subprocess
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parent
GEN = ROOT / "generated/rmvillage"
SEASONS = ("spring", "summer", "autumn", "winter")
SHEET = "NNV_rmvillage_PMU_Buildings.tile"
GROUND = "summer/Data/Ground/nnv_rmvillage_summer.rsground"
INTRODUCING_COMMIT = "9de06a7d"
EXTRA_FRAMES = (4, 5)
TERRAIN_LAYERS = ("NNV grass0", "NNV grass1")


def sha256_bytes(payload: bytes) -> str:
    return hashlib.sha256(payload).hexdigest()


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def git_show(revision: str, path: str) -> bytes:
    return subprocess.run(["git", "show", f"{revision}:{path}"],
                          cwd=REPO, capture_output=True, check=True).stdout


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
    table_size = len(entries) * 16
    offset = len(header) + table_size
    table = b""
    body = b""
    for key, blob in entries:
        table += struct.pack("<QQ", key, offset)
        body += struct.pack("<Q", len(blob)) + blob
        offset += 8 + len(blob)
    path.write_bytes(header + table + body)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--apply", action="store_true",
                        help="ecrire les fichiers ; sans ce drapeau, simulation seule")
    parser.add_argument("--report", type=Path,
                        default=ROOT / "reports/plot-adaptation/extra-houses-removal.json")
    args = parser.parse_args()

    ground_path = GEN / GROUND
    document = json.loads(ground_path.read_text(encoding="utf-8-sig"))
    obj = document["Object"]

    historic = json.loads(git_show(f"{INTRODUCING_COMMIT}^",
                                   f"NO_NAME_VILLAGE_ADAPTATION/generated/rmvillage/{GROUND}")
                          .decode("utf-8-sig"))["Object"]

    if (historic["TexSize"] != obj["TexSize"]
            or len(historic["obstacles"]) != len(obj["obstacles"])
            or [l["Name"] for l in historic["Layers"]] != [l["Name"] for l in obj["Layers"]]):
        raise SystemExit("geometrie divergente : restauration refusee (fail-closed)")

    before_frames = sorted(anim["Anim"]["StartFrame"]
                           for group in obj["Decorations"] for anim in group["Anims"])

    # 1. Decorations : ne garder que les quatre batiments de parcelle.
    removed = []
    for group in obj["Decorations"]:
        keep = []
        for anim in group["Anims"]:
            frame = anim["Anim"]["StartFrame"]
            if frame in EXTRA_FRAMES:
                removed.append({"frame": frame,
                                "map_loc": [anim["MapLoc"]["X"], anim["MapLoc"]["Y"]]})
            else:
                keep.append(anim)
        group["Anims"] = keep

    # 2. Terrain : restaurer les cellules d'herbe depuis la donnee historique.
    restored_cells = {}
    for layer, reference in zip(obj["Layers"], historic["Layers"]):
        if layer["Name"] not in TERRAIN_LAYERS:
            continue
        count = 0
        for cx in range(len(layer["Tiles"])):
            for cy in range(len(layer["Tiles"][cx])):
                current = json.dumps(layer["Tiles"][cx][cy], sort_keys=True)
                original = json.dumps(reference["Tiles"][cx][cy], sort_keys=True)
                if current != original:
                    layer["Tiles"][cx][cy] = json.loads(original)
                    count += 1
        restored_cells[layer["Name"]] = count

    # 3. Collision : restaurer les cellules 8 px posees pour ces deux maisons.
    collision_restored = 0
    for cx in range(len(obj["obstacles"])):
        for cy in range(len(obj["obstacles"][cx])):
            if obj["obstacles"][cx][cy]["Tags"] != historic["obstacles"][cx][cy]["Tags"]:
                obj["obstacles"][cx][cy]["Tags"] = historic["obstacles"][cx][cy]["Tags"]
                collision_restored += 1

    after_frames = sorted(anim["Anim"]["StartFrame"]
                          for group in obj["Decorations"] for anim in group["Anims"])
    if after_frames != [0, 1, 2, 3]:
        raise SystemExit(f"resultat inattendu : frames restantes {after_frames}")

    # 4. Planche : les frames 4 et 5 ne sont plus referencees, on les retire aussi.
    sheet_source = GEN / f"summer/Content/Tile/{SHEET}"
    tile_size, entries = read_sheet(sheet_source.read_bytes())
    kept_entries = [entry for index, entry in enumerate(entries) if index not in EXTRA_FRAMES]
    kept_sizes = [Image.open(io.BytesIO(blob)).size for _, blob in kept_entries]

    summary = {
        "schema": "new-era.nnv-extra-houses-removal.v1",
        "reason": ("les frames 4 et 5 ne correspondent a aucune parcelle NNV ; "
                   "elles ont ete ajoutees par 9de06a7d et n'ont jamais ete demandees"),
        "introducing_commit": INTRODUCING_COMMIT,
        "restoration_source": f"{INTRODUCING_COMMIT}^ (donnee historique relue, rien de reconstruit)",
        "decorations_before": before_frames,
        "decorations_after": after_frames,
        "decorations_removed": removed,
        "terrain_cells_restored": restored_cells,
        "terrain_cells_restored_total": sum(restored_cells.values()),
        "collision_cells_restored": collision_restored,
        "sheet_frames_before": len(entries),
        "sheet_frames_after": len(kept_entries),
        "sheet_frame_sizes_after": [f"{w}x{h}" for w, h in kept_sizes],
        "plot_buildings_untouched": [0, 1, 2, 3],
        "applied": bool(args.apply),
    }

    if args.apply:
        ground_path.write_text("\ufeff" + json.dumps(document, ensure_ascii=False,
                                                     separators=(",", ":")),
                               encoding="utf-8")
        for season in SEASONS:
            write_sheet(GEN / f"{season}/Content/Tile/{SHEET}", tile_size, kept_entries)

        check = json.loads(ground_path.read_text(encoding="utf-8-sig"))["Object"]
        relu = sorted(anim["Anim"]["StartFrame"]
                      for group in check["Decorations"] for anim in group["Anims"])
        if relu != [0, 1, 2, 3]:
            raise SystemExit("relecture : les Decorations ne sont pas celles attendues")
        hashes = {season: sha256_file(GEN / f"{season}/Content/Tile/{SHEET}")
                  for season in SEASONS}
        if len(set(hashes.values())) != 1:
            raise SystemExit("les planches divergent entre saisons apres ecriture")
        summary["ground_sha256"] = sha256_file(ground_path)
        summary["sheet_sha256_per_season"] = hashes
        summary["sheet_identical_across_seasons"] = True
        summary["reread_decorations"] = relu

    args.report.parent.mkdir(parents=True, exist_ok=True)
    args.report.write_text(json.dumps(summary, indent=2, ensure_ascii=False, sort_keys=True) + "\n",
                           encoding="utf-8")
    print(json.dumps(summary, indent=2, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
