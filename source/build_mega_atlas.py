#!/usr/bin/env python3
"""Atlas de la Méga-Évolution « fissures » (référence : meromoonmeri/projet-pmdo · renders/mega_evolution_v2).

L'animation de référence est un cycle de 192 images à 30 im/s (6,4 s) composé de six calques :
sol → énergie arrière → personnage → sphère → énergie avant → fracture → emblème.
Le personnage n'est PAS dans les atlas (il est composé par le moteur, ici avec les sprites PMDO de
Lucario `0448` / Méga-Lucario `9448`), le changement de forme a lieu à l'image 78, caché par la sphère
devenue opaque.

Ce script recadre chaque calque sur sa zone utile, range les images en grille, encode en WebP et écrit
`combat_bruts/mega_sheets.json` (métadonnées : nombre d'images, grille, point d'ancrage au sol).

    .venv/bin/python source/build_mega_atlas.py
"""
from __future__ import annotations

import io
import json
import subprocess
import sys
from pathlib import Path

import numpy as np
from PIL import Image

SOURCE_DIR = Path(__file__).resolve().parent
ROOT = SOURCE_DIR.parent
CACHE = ROOT / ".cache" / "mega_evolution_v2"
OUT = SOURCE_DIR / "pmd_destiny_fangame_v1" / "combat_bruts"
REPO = "https://github.com/meromoonmeri/projet-pmdo"

CELL = (240, 256)          # dimensions d'une image dans les atlas de référence
COLS_ATLAS = 12
GROUND_ANCHOR = (120, 198)  # point d'ancrage au sol dans l'image (pieds du personnage)
# calque -> (clé moteur, tranche d'images de la timeline maîtresse, boîte de recadrage)
LAYERS = (
    ("rear_energy", "mRear", (1, 104), (44, 85, 194, 197)),
    ("front_energy", "mFront", (1, 104), (79, 149, 160, 242)),
    ("sphere", "mSphere", (30, 107), (78, 144, 162, 228)),
    ("fracture", "mBreak", (97, 148), (70, 136, 167, 234)),
    ("emblem", "mEmblem", (46, 181), (110, 91, 129, 142)),
)
QUALITY = 48
GRID_COLS = 12


def ensure_sources() -> Path:
    atl = CACHE / "atlases"
    if (atl / "MEGAGEN_V2_sphere.png").exists():
        return atl
    CACHE.mkdir(parents=True, exist_ok=True)
    tmp = CACHE / "_clone"
    if not (tmp / ".git").exists():
        subprocess.run(["git", "clone", "-q", "--filter=blob:none", "--no-checkout", REPO, str(tmp)], check=True)
        subprocess.run(["git", "-C", str(tmp), "sparse-checkout", "init", "--no-cone"], check=True)
        subprocess.run(["git", "-C", str(tmp), "sparse-checkout", "set", "renders/mega_evolution_v2/atlases"], check=True)
        subprocess.run(["git", "-C", str(tmp), "checkout", "-q"], check=True)
    src = tmp / "renders" / "mega_evolution_v2" / "atlases"
    if not (src / "MEGAGEN_V2_sphere.png").exists():
        raise SystemExit("atlas de la Méga-Évolution introuvable : " + str(src))
    atl.mkdir(parents=True, exist_ok=True)
    for f in src.glob("*.png"):
        (atl / f.name).write_bytes(f.read_bytes())
    return atl


def build_layer(atl: Path, name: str, key: str, span: tuple, box: tuple) -> dict:
    a = np.asarray(Image.open(atl / f"MEGAGEN_V2_{name}.png").convert("RGBA"))
    x0, y0, x1, y1 = box
    cw, ch = x1 - x0, y1 - y0
    f0, f1 = span
    frames = []
    for i in range(f0, f1 + 1):
        r, c = divmod(i, COLS_ATLAS)
        cell = a[r * CELL[1] + y0: r * CELL[1] + y1, c * CELL[0] + x0: c * CELL[0] + x1]
        frames.append(Image.fromarray(cell))
    n = len(frames)
    rows = (n + GRID_COLS - 1) // GRID_COLS
    sheet = Image.new("RGBA", (cw * GRID_COLS, ch * rows), (0, 0, 0, 0))
    for k, f in enumerate(frames):
        sheet.paste(f, ((k % GRID_COLS) * cw, (k // GRID_COLS) * ch))
    buf = io.BytesIO()
    sheet.save(buf, "WEBP", quality=QUALITY, method=5, exact=False)
    (OUT / f"megaSheet_{key}.webp").write_bytes(buf.getvalue())
    return {"n": n, "cols": GRID_COLS, "cw": cw, "ch": ch, "f0": f0, "f1": f1,
            "ax": GROUND_ANCHOR[0] - x0, "ay": GROUND_ANCHOR[1] - y0, "fps": 30,
            "bytes": buf.tell()}


def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    atl = ensure_sources()
    meta = {"fps": 30, "frames": 192, "form_switch_frame": 78, "cell": list(CELL),
            "ground_anchor": list(GROUND_ANCHOR), "source": "meromoonmeri/projet-pmdo renders/mega_evolution_v2"}
    total = 0
    for name, key, span, box in LAYERS:
        m = build_layer(atl, name, key, span, box)
        meta[key] = m
        total += m["bytes"]
        print(f"  {key:8s} {m['n']:3d} images {m['cw']}x{m['ch']} -> {m['bytes'] // 1024} Ko")
    (OUT / "mega_sheets.json").write_text(json.dumps(meta, indent=1), encoding="utf-8")
    print(f"total {total // 1024} Ko (base64 ~{int(total * 4 / 3 / 1024)} Ko)")
    return 0


if __name__ == "__main__":
    sys.exit(main())
