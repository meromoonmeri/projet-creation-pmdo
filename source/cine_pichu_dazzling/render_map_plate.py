#!/usr/bin/env python3
"""Rend la carte native `cliffdaytest.rsground` (« CliffReverietownnordest ») en plaques PNG
fidèles au moteur PMDO, pour la cinématique « Pichu & la Team Dazzling » :

  * grille réelle 123×99 cellules de 8 px → 984×792 (l'ancien rendu inversait L/H et
    rognait 24 colonnes : bouts de falaise et mer manquants) ;
  * calques statiques : `under` (sol + falaises + objets bas) et `over` (objets SOLIDES
    des calques objets : canopées/toits qui occultent les personnages derrière eux) ;
  * tuiles ANIMÉES (eau, mer, drapeaux, fleurs…) : atlas 8 px + séquences de frames,
    rejouées frame par frame par le moteur (plus rien n'est figé) ;
  * grille de marche extraite de `obstacles` (Tags) → mask RLE base64 pour le routage et les tests.

    .venv/bin/python source/cine_pichu_dazzling/render_map_plate.py
"""
from __future__ import annotations

import base64
import json
import sys
from pathlib import Path

import numpy as np
from PIL import Image

ROOT = Path(__file__).resolve().parent.parent.parent
sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(ROOT / "source"))

from source.cliff_nord_centre_v1.build import decode_tile_straight  # type: ignore

T02 = Path("/tmp/t02/Content/Tile")
OUT = Path(__file__).resolve().parent / "plates"
TILE = 8
ANIM_FPS = 7.5          # vitesse des tuiles animées PMDO (ticks → s)
OVER_LAYERS = (3, 5)    # calques « objets » : les cellules solides passent AU-DESSUS des persos


def main() -> None:
    obj = json.loads((ROOT / "cliffdaytest.rsground").read_text(encoding="utf-8-sig"))["Object"]
    layers = obj["Layers"]
    nc, nr = len(layers[0]["Tiles"]), len(layers[0]["Tiles"][0])
    W, H = nc * TILE, nr * TILE

    # ---- grille de marche (Tags != 0 = bloqué) ----
    blocked = [[(c["Tags"] or 0) != 0 for c in col] for col in obj["obstacles"]]
    bitstr = "".join("1" if blocked[idx % nc][idx // nc] else "0" for idx in range(nc * nr))
    raw = int(bitstr, 2).to_bytes((nc * nr + 7) // 8, "big")
    walk = {"w": nc, "h": nr, "b64": base64.b64encode(raw).decode()}

    sheets: dict[str, np.ndarray] = {}

    def sheet(name: str) -> np.ndarray:
        if name not in sheets:
            sheets[name] = np.asarray(decode_tile_straight(T02 / f"{name}.tile").convert("RGBA"))
        return sheets[name]

    under = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    over = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    atlas_cells: dict[tuple[str, int, int], int] = {}
    atlas_blocks: list[np.ndarray] = []
    seqs: list[list] = []
    n_static = n_over = 0

    def cell_index(sheet_name: str, tx: int, ty: int) -> int:
        key = (sheet_name, tx, ty)
        if key not in atlas_cells:
            sh = sheet(sheet_name)
            atlas_cells[key] = len(atlas_blocks)
            atlas_blocks.append(sh[ty:ty + TILE, tx:tx + TILE])
        return atlas_cells[key]

    for li, layer in enumerate(layers):
        if not layer.get("Visible", True):
            continue
        for x, col in enumerate(layer["Tiles"]):
            for y, cell in enumerate(col):
                solid = blocked[x][y] if (li in OVER_LAYERS and x < nc and y < nr) else False
                for seq in cell.get("Layers", []):
                    frames = seq.get("Frames") or []
                    if not frames:
                        continue
                    if len(frames) == 1:
                        f = frames[0]
                        sh = sheet(f["Sheet"])
                        tx, ty = f["TexLoc"]["X"] * TILE, f["TexLoc"]["Y"] * TILE
                        if ty + TILE > sh.shape[0] or tx + TILE > sh.shape[1]:
                            continue
                        blk = Image.fromarray(sh[ty:ty + TILE, tx:tx + TILE], "RGBA")
                        if solid:
                            over.alpha_composite(blk, (x * TILE, y * TILE))
                            n_over += 1
                        else:
                            under.alpha_composite(blk, (x * TILE, y * TILE))
                            n_static += 1
                    else:
                        idxs = []
                        ok = True
                        for f in frames:
                            sh = sheet(f["Sheet"])
                            tx, ty = f["TexLoc"]["X"] * TILE, f["TexLoc"]["Y"] * TILE
                            if ty + TILE > sh.shape[0] or tx + TILE > sh.shape[1]:
                                ok = False
                                break
                            idxs.append(cell_index(f["Sheet"], tx, ty))
                        if ok:
                            seqs.append([x * TILE, y * TILE, idxs])

    # ---- atlas des tuiles animées ----
    cols = 64
    rows = (len(atlas_blocks) + cols - 1) // cols
    atlas = Image.new("RGBA", (cols * TILE, rows * TILE), (0, 0, 0, 0))
    for i, blk in enumerate(atlas_blocks):
        atlas.paste(Image.fromarray(blk, "RGBA"), ((i % cols) * TILE, (i // cols) * TILE))

    OUT.mkdir(parents=True, exist_ok=True)
    under.save(OUT / "cliffdaytest_jour_under.png", optimize=True)
    over.save(OUT / "cliffdaytest_jour_over.png", optimize=True)
    atlas.save(OUT / "cliffdaytest_jour_anim_atlas.png", optimize=True)
    (OUT / "cliffdaytest_jour_anim.json").write_text(
        json.dumps({"fps": ANIM_FPS, "cols": cols, "seqs": seqs}, separators=(",", ":")), encoding="utf-8")
    (OUT / "cliffdaytest_walk.json").write_text(json.dumps(walk, separators=(",", ":")), encoding="utf-8")
    comp = under.copy()
    comp.alpha_composite(over)
    comp.save(OUT / "cliffdaytest_jour.png", optimize=True)

    # ---- variante NUIT : LUT 3D native jour→nuit (paire Metano_Town_Base / _Night),
    #      aucune couleur inventée — gradation nocturne canonique PMDO ----
    from source.cliff_nord_centre_v1.build_refs_nuit import _apply, _lut_from_pair  # type: ignore
    day = np.asarray(decode_tile_straight(T02 / "Metano_Town_Base.tile").convert("RGBA"))
    ngt = np.asarray(decode_tile_straight(T02 / "Metano_Town_Base_Night.tile").convert("RGBA"))
    lut = _lut_from_pair(day, ngt)
    for name in ("under", "over", "anim_atlas"):
        arr = _apply(lut, np.asarray(Image.open(OUT / f"cliffdaytest_jour_{name}.png").convert("RGBA")))
        Image.fromarray(arr, "RGBA").save(OUT / f"cliffdaytest_nuit_{name}.png", optimize=True)
    compn = Image.open(OUT / "cliffdaytest_nuit_under.png").convert("RGBA")
    compn.alpha_composite(Image.open(OUT / "cliffdaytest_nuit_over.png").convert("RGBA"))
    compn.save(OUT / "cliffdaytest_nuit.png", optimize=True)
    print(f"cliffdaytest jour+nuit : {W}x{H} ({nc}x{nr} cellules) — static={n_static} over={n_over} "
          f"animseqs={len(seqs)} atlas={atlas.size} frames max={max(len(s[2]) for s in seqs)}")


if __name__ == "__main__":
    main()
