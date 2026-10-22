#!/usr/bin/env python3
"""Extrait le monde Waves of Nostalgia depuis la ROM, cartes et connectivite.

Ce que corrige cet outil
------------------------
`docs/waves_nostalgia_structures/` ne contient que **4 batiments decoupes** sur
5 cartes. Ce n'est pas le village : c'est une bibliotheque de sprites, et trois
des cinq cartes y sont marquees `NO_QUALIFYING_BUILDING`.

Le monde reel compte **16 cartes** `overw*` dans la ROM, dont le village, ses
variantes horaires et ses zones annexes.

Provenance de la ROM
--------------------
`WavetoNostalgia.NDS` du depot `meromoonmeri/PMD-RED-PMDO-PORT`, recuperee via
`codeload.github.com` — l'hote LFS `github-cloud.githubusercontent.com` repond
`000` depuis ce bac a sable, codeload resout les pointeurs cote serveur.

    sha256 5d2b5c7b9942c7eca2115d486eec69b9060418b09fc215ad6f104d46b544f0db
    taille 152 547 776 octets

Ce sha est **identique** a celui declare dans
`docs/waves_nostalgia_structures/manifest.json` : c'est bien la ROM qui a servi
a l'extraction partielle precedente.

Rendu fidele : les BPA sont resolues
------------------------------------
Un rendu naif appelle `bma.to_pil(bpc, bpl, [], ...)` sans les BPA et la
bibliotheque emet alors des centaines de `contains invalid tile reference.
Replaced with 0.` — des trous dans l'image, silencieux si on ne lit pas stderr.

Les BPA (tuiles animees : eau, feuillage, feu) sont declarees dans
`bg_list.dat`, pas devinables depuis le nom de fichier. Elles sont donc lues
la, resolues, et passees au rendu. `to_pil` renvoie une LISTE de couches, pas
une image : elles sont composees dans l'ordre.

Connectivite
------------
Les liaisons entre cartes sont lues dans les scripts `.ssb` via les opcodes
`supervision_LoadStation` / `supervision_Station`, dont le premier parametre
indexe `level_list`. Seules les aretes dont les DEUX extremites sont des
cartes `overw*` sont retenues : le reste mene aux donjons, hors sujet ici.

Rien n'est ecrit sous `Data/`. Cet outil produit des rendus et un rapport.
"""
from __future__ import annotations

import argparse
import collections
import hashlib
import json
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
REPO = ROOT.parent

ROM_SHA256 = "5d2b5c7b9942c7eca2115d486eec69b9060418b09fc215ad6f104d46b544f0db"
ROM_BYTES = 152547776
ROM_SOURCE = ("meromoonmeri/PMD-RED-PMDO-PORT :: WavetoNostalgia.NDS, "
              "via codeload.github.com (hote LFS bloque)")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as stream:
        for chunk in iter(lambda: stream.read(1 << 20), b""):
            digest.update(chunk)
    return digest.hexdigest()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("--rom", type=Path, required=True)
    parser.add_argument("--out", type=Path, default=ROOT / "reports/won-world")
    parser.add_argument("--render-dir", type=Path, default=None)
    args = parser.parse_args()

    from ndspy.rom import NintendoDSRom
    from skytemple_files.common.types.file_types import FileType
    from skytemple_files.common.util import get_ppmdu_config_for_rom

    digest = sha256_file(args.rom)
    if digest != ROM_SHA256:
        raise SystemExit(f"ROM inattendue : {digest} != {ROM_SHA256}")

    args.out.mkdir(parents=True, exist_ok=True)
    render_dir = args.render_dir or args.out
    render_dir.mkdir(parents=True, exist_ok=True)

    rom = NintendoDSRom.fromFile(str(args.rom))
    config = get_ppmdu_config_for_rom(rom)
    level_by_id = {index: entry.name.upper()
                   for index, entry in config.script_data.level_list__by_id.items()}

    bg_list = FileType.BG_LIST_DAT.deserialize(rom.getFileByName("MAP_BG/bg_list.dat"))

    maps = {}
    for entry in bg_list.level:
        name = entry.bma_name.lower()
        if not name.startswith("overw"):
            continue
        bma = FileType.BMA.deserialize(rom.getFileByName(f"MAP_BG/{name}.bma"))
        bpc = FileType.BPC.deserialize(rom.getFileByName(f"MAP_BG/{entry.bpc_name.lower()}.bpc"))
        bpl = FileType.BPL.deserialize(rom.getFileByName(f"MAP_BG/{entry.bpl_name.lower()}.bpl"))

        # Les BPA viennent de bg_list.dat. Sans elles, la bibliotheque remplace
        # les tuiles animees par du vide et le rendu se troue en silence.
        bpas = []
        for bpa_name in entry.bpa_names:
            bpas.append(FileType.BPA.deserialize(
                rom.getFileByName(f"MAP_BG/{bpa_name.lower()}.bpa")) if bpa_name else None)
        while len(bpas) < 8:
            bpas.append(None)

        layers = bma.to_pil(bpc, bpl, bpas, False, False)
        canvas = layers[0].convert("RGBA")
        for layer in layers[1:]:
            canvas.alpha_composite(layer.convert("RGBA"))
        target = render_dir / f"{name}.png"
        canvas.save(target)

        maps[name] = {
            "px": [canvas.width, canvas.height],
            "cells_8px": [canvas.width // 8, canvas.height // 8],
            "chunks": [bma.map_width_chunks, bma.map_height_chunks],
            "tiling": bma.tiling_width,
            "bma_layers": bma.number_of_layers,
            "collision_layers": bma.number_of_collision_layers,
            "composited_layers": len(layers),
            "bpa_resolved": [b for b in entry.bpa_names if b],
            "png": target.name,
            "sha256": hashlib.sha256(target.read_bytes()).hexdigest(),
        }

    # Connectivite : uniquement les aretes overw -> overw.
    names = []

    def walk(folder, path=""):
        for file_name in folder.files:
            names.append(f"{path}/{file_name}" if path else file_name)
        for sub_name, sub in folder.folders:
            walk(sub, f"{path}/{sub_name}" if path else sub_name)

    walk(rom.filenames)
    edges = collections.Counter()
    external = collections.Counter()
    for path in names:
        if not (path.upper().startswith("SCRIPT/") and path.lower().endswith(".ssb")):
            continue
        source = path.split("/")[1].upper()
        try:
            script = FileType.SSB.deserialize(rom.getFileByName(path), static_data=config)
        except Exception:
            continue
        for ops in script.routine_ops:
            for op in ops:
                if op.op_code.name not in ("supervision_LoadStation", "supervision_Station",
                                           "supervision_StationCommon"):
                    continue
                params = op.params
                if not params or not isinstance(params[0], int):
                    continue
                target_name = level_by_id.get(params[0])
                if target_name is None or target_name == source:
                    continue
                if source.startswith("OVERW") and target_name.startswith("OVERW"):
                    edges[(source, target_name)] += 1
                elif source.startswith("OVERW"):
                    external[(source, target_name)] += 1

    report = {
        "schema": "new-era.won-world-extraction.v1",
        "rom": {"sha256": digest, "bytes": args.rom.stat().st_size, "source": ROM_SOURCE,
                "sha256_matches_tracked_manifest": digest == ROM_SHA256},
        "maps_count": len(maps),
        "maps": maps,
        "internal_edges": [{"from": a, "to": b, "occurrences": c}
                           for (a, b), c in sorted(edges.items(), key=lambda kv: -kv[1])],
        "external_destinations_count": len(external),
        "scale": {
            "won_tile_px": 8,
            "pmdo_world_unit_px": 8,
            "ratio": 1,
            "note": ("WoN est deja a l'echelle PMDO : 8 px par unite monde, comme "
                     "NNV apres normalisation x0,125. Aucun rescale n'est requis."),
        },
        "supersedes": ("docs/waves_nostalgia_structures/ ne couvrait que 4 batiments "
                       "decoupes sur 5 cartes ; le monde en compte 16"),
        "written_under_Data": False,
    }
    (args.out / "won-world.json").write_text(
        json.dumps(report, indent=2, ensure_ascii=False, sort_keys=True) + "\n", encoding="utf-8")
    print(json.dumps({"maps": len(maps), "internal_edges": len(edges),
                      "rom_verified": digest == ROM_SHA256}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
