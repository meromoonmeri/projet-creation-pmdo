#!/usr/bin/env python3
"""Aperçu HTML interactif et archives ZIP pour Entrée Caverne Saline sud-nord V1 (EBC1)..

.venv/bin/python source/entree_caverne_saline_sud_nord_v1/package.py
"""
from __future__ import annotations

import json
import unittest
import zipfile
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
LOT = "entree_caverne_saline_sud_nord_v1"
OUT = R / "renders" / LOT
STAGE = R / ".cache" / LOT / "entree_caverne_saline"
ZIP_PMDO = OUT / "EBC1_projet_pmdo_0812.zip"
ZIP_PNG = OUT / "EBC1_calques_png_8px.zip"
HTML = R / f"apercu_{LOT}.html"
VIEWER_LOCAL = OUT / "viewer.html"


def build_zips() -> None:
    with zipfile.ZipFile(ZIP_PMDO, "w", zipfile.ZIP_DEFLATED) as z:
        for p in sorted(STAGE.rglob("*")):
            if p.is_file():
                z.write(p, f"entree_caverne_saline/{p.relative_to(STAGE).as_posix()}")
    with zipfile.ZipFile(ZIP_PNG, "w", zipfile.ZIP_DEFLATED) as z:
        for sub in ("calques", "animation", "poses", "masques", "review"):
            for p in sorted((OUT / sub).rglob("*.png")):
                z.write(p, p.relative_to(OUT).as_posix())
        z.write(OUT / "manifest.json", "manifest.json")


def build_html() -> None:
    m = json.loads((OUT / "manifest.json").read_text(encoding="utf-8"))
    walk = np.array(Image.open(OUT / "masques" / "EBC1_masque_praticable.png")) > 0
    blk = (~walk).reshape(72, 8, 96, 8).mean((1, 3)) > 0.25
    by, bx = np.nonzero(blk)
    banks = m["pmdo"]["banks"]
    tiles = m["pmdo"]["tiles_per_bank"]
    layers_root, layers_local = [], []
    for i, entry in enumerate(m["layers"]):
        rel = entry["file"]
        n = entry["phases"]
        tk = entry["ticks"]
        stem = Path(rel).stem.replace("_fNN", "")
        srcs_root = (
            [f"renders/{LOT}/{rel.replace('_fNN.png', f'_f{t:02d}.png')}" for t in range(n)]
            if n > 1
            else [f"renders/{LOT}/{rel}"]
        )
        srcs_local = (
            [f"{rel.replace('_fNN.png', f'_f{t:02d}.png')}" for t in range(n)]
            if n > 1
            else [f"{rel}"]
        )
        lbl = stem.replace("EBC1_", "").replace("_", " ")
        layers_root.append({"id": stem, "label": lbl, "srcs": srcs_root, "ticks": tk, "tiles": tiles[banks[i]]})
        layers_local.append({"id": stem, "label": lbl, "srcs": srcs_local, "ticks": tk, "tiles": tiles[banks[i]]})

    base_spec = {
        "loop_ticks": m["scene_loop_ticks"],
        "fidelite": m["fidelite_rip"]["calques_finaux"],
        "seuil": m["fidelite_rip"]["seuil"],
        "blocked": [[int(x), int(y)] for y, x in zip(by, bx)],
        "entry": m["access"]["entry_px"],
        "boss": m["access"]["boss_px"],
        "threshold": m["access"]["goal_px"],
    }
    tpl = (HERE / "viewer_template.html").read_text(encoding="utf-8")
    HTML.write_text(
        tpl.replace("__SPEC_JSON__", json.dumps({**base_spec, "layers": layers_root}, separators=(",", ":"))),
        encoding="utf-8",
    )
    VIEWER_LOCAL.write_text(
        tpl.replace("__SPEC_JSON__", json.dumps({**base_spec, "layers": layers_local}, separators=(",", ":")))
        .replace(f"renders/{LOT}/", "")
        .replace(f"source/{LOT}/", f"../../source/{LOT}/"),
        encoding="utf-8",
    )


if __name__ == "__main__":
    suite = unittest.defaultTestLoader.discover(str(HERE), pattern="test_build.py")
    res = unittest.TextTestRunner(verbosity=1).run(suite)
    if not res.wasSuccessful():
        raise SystemExit(1)
    build_zips()
    build_html()
    print(f"OK {ZIP_PMDO.name} ({ZIP_PMDO.stat().st_size // 1024} Ko) + {HTML.name}")
