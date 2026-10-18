#!/usr/bin/env python3
"""Aperçu HTML interactif et archive ZIP du mod PMDO 0.8.12 pour Fin de la Tour Temporelle V2 (FTN2).

.venv/bin/python source/fin_tour_temporelle_noire_or_v2/package.py
"""
from __future__ import annotations

import json
import zipfile
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
LOT = "fin_tour_temporelle_noire_or_v2"
OUT = R / "renders" / LOT
STAGE = R / ".cache" / LOT / LOT
ZIP = R / ".cache" / LOT / f"mod_{LOT}_pmdo_0812.zip"
ZIP_RENDER = OUT / "FTN2_projet_pmdo_0812.zip"
HTML = R / f"apercu_{LOT}.html"
VIEWER_LOCAL = OUT / "viewer.html"
REVIEW_INDEX = OUT / "review" / "index.html"


def build_zip() -> None:
    for zpath in (ZIP, ZIP_RENDER):
        zpath.parent.mkdir(parents=True, exist_ok=True)
        with zipfile.ZipFile(zpath, "w", zipfile.ZIP_DEFLATED) as z:
            for p in sorted(STAGE.rglob("*")):
                if p.is_file():
                    z.write(p, f"{LOT}/{p.relative_to(STAGE).as_posix()}")
    with zipfile.ZipFile(ZIP) as z:
        names = set(z.namelist())
        for req in [
            f"{LOT}/Mod.xml",
            f"{LOT}/INSTALLER.py",
            f"{LOT}/README.md",
            f"{LOT}/Data/Ground/ftn2_fin_tour_temporelle_noire_or.rsground",
            f"{LOT}/Content/Tile/index.idx",
        ]:
            assert req in names, req
        assert sum(n.endswith(".tile") for n in names) == 13


def build_html() -> None:
    m = json.loads((OUT / "manifest.json").read_text(encoding="utf-8"))
    walk = np.array(Image.open(OUT / "masques" / "FTN2_masque_praticable.png")) > 0
    blk = (~walk).reshape(72, 8, 96, 8).mean((1, 3)) > 0.25
    by, bx = np.nonzero(blk)
    banks = m["pmdo"]["banks"]
    tiles = m["pmdo"]["tiles_per_bank"]
    layers_root = []
    layers_local = []
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
        lbl = stem.replace("FTN2_", "").replace("_", " ")
        layers_root.append(
            {
                "id": stem,
                "label": lbl,
                "srcs": srcs_root,
                "ticks": tk,
                "tiles": tiles[banks[i]],
            }
        )
        layers_local.append(
            {
                "id": stem,
                "label": lbl,
                "srcs": srcs_local,
                "ticks": tk,
                "tiles": tiles[banks[i]],
            }
        )

    base_spec = {
        "loop_ticks": m["scene_loop_ticks"],
        "fidelite": m["fidelite_rip"]["mesures"],
        "seuil": m["fidelite_rip"]["seuil"],
        "blocked": [[int(x), int(y)] for y, x in zip(by, bx)],
        "entry": m["access"]["entry_px"],
        "boss": m["access"]["boss_px"],
        "threshold": m["access"]["threshold_px"],
    }
    tpl = (HERE / "viewer_template.html").read_text(encoding="utf-8")

    spec_root = {**base_spec, "layers": layers_root}
    HTML.write_text(tpl.replace("__SPEC_JSON__", json.dumps(spec_root, separators=(",", ":"))), encoding="utf-8")

    spec_local = {**base_spec, "layers": layers_local}
    html_local = (
        tpl.replace("__SPEC_JSON__", json.dumps(spec_local, separators=(",", ":")))
        .replace(f"renders/{LOT}/", "")
        .replace(f"source/{LOT}/", f"../../source/{LOT}/")
    )
    VIEWER_LOCAL.write_text(html_local, encoding="utf-8")

    REVIEW_INDEX.parent.mkdir(parents=True, exist_ok=True)
    REVIEW_INDEX.write_text(
        """<!doctype html>
<html lang="fr">
<head>
<meta charset="utf-8">
<title>Planches de contrôle — FTN2 Fin de la Tour Temporelle V2 (Sommet Noir &amp; Or)</title>
<style>
  body { margin: 0; padding: 24px; font: 14px/1.5 system-ui, sans-serif; background: #100c14; color: #f4eef8; }
  h1 { color: #f7d56e; margin-top: 0; }
  .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(360px, 1fr)); gap: 16px; }
  .card { background: #1a1320; border: 1px solid #3c2938; border-radius: 8px; padding: 12px; }
  .card h2 { font-size: 14px; color: #f2cf7e; margin: 0 0 8px; }
  img { width: 100%; height: auto; image-rendering: pixelated; border: 1px solid #4d3548; }
</style>
</head>
<body>
  <h1>Planches de contrôle — FTN2 Fin de la Tour Temporelle V2 (768 × 576 px)</h1>
  <div class="grid">
    <div class="card"><h2>Scène maîtresse t=000</h2><img src="FTN2_scene_t000.png"></div>
    <div class="card"><h2>Scène animée (24 phases × 10 ticks = 240 ticks)</h2><img src="FTN2_scene_animee.webp"></div>
    <div class="card"><h2>Collisions &amp; marqueurs (entrance / boss / objectif)</h2><img src="FTN2_collisions_marqueurs.png"></div>
    <div class="card"><h2>Zoom ×2 Trou Noir, anneau d'accrétion, reliquaire &amp; cadran</h2><img src="FTN2_zoom_reliquaire_cadran.png"></div>
    <div class="card"><h2>Planche des couches principales (3×3)</h2><img src="FTN2_planche_couches.png"></div>
  </div>
</body>
</html>
""",
        encoding="utf-8",
    )


if __name__ == "__main__":
    build_zip()
    build_html()
    print(f"OK {ZIP.name} ({ZIP.stat().st_size // 1024} Ko) + {HTML.name}")
