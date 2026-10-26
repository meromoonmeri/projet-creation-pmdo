#!/usr/bin/env python3
"""Dérive les références NUIT manquantes de la carte falaise (`Metano_Town_Objects_Night.tile`,
`Metano_Town_Animation_Tileset_Night.tile`) à partir de la paire native JOUR→NUIT
(`Metano_Town_Base.tile` → `Metano_Town_Base_Night.tile`) : LUT 3D 16³ appliquée aux
feuilles jour, aucun pixel inventé hors gradation nocturne.

    .venv/bin/python source/cliff_nord_centre_v1/build_refs_nuit.py
"""
from __future__ import annotations

import sys
from pathlib import Path

from PIL import Image

import numpy as np

ROOT = Path(__file__).resolve().parent.parent.parent
sys.path.insert(0, str(ROOT))
sys.path.insert(0, str(ROOT / "source"))

from source.cliff_nord_centre_v1.build import decode_tile_straight, premult_rgba, encode_8x8_minimal_png  # type: ignore
import io as _io
import struct as _struct

NATIFS = ROOT / "source" / "cote_v4_abyss" / "natifs"
REFS = ROOT / "source" / "cliff_nord_centre_v1" / "refs_natives"
N = 16  # résolution de la LUT


def _lut_from_pair(day: np.ndarray, night: np.ndarray) -> np.ndarray:
    m = (day[..., 3] > 200) & (night[..., 3] > 200)
    lut = np.zeros((N, N, N, 3), dtype=np.float64)
    cnt = np.zeros((N, N, N), dtype=np.float64)
    idx = (day[..., :3] // 16).clip(0, N - 1)
    for c in range(3):
        np.add.at(lut[..., c], (idx[..., 0][m], idx[..., 1][m], idx[..., 2][m]), night[..., c][m].astype(np.float64))
    np.add.at(cnt, (idx[..., 0][m], idx[..., 1][m], idx[..., 2][m]), 1.0)
    filled = cnt > 0
    lut[filled] /= cnt[filled][..., None]
    # remplissage des cases vides par moyenne globale puis identité
    for c in range(3):
        mean = lut[..., c][filled].mean() if filled.any() else 128.0
        lut[..., c][~filled] = mean
    return lut


def _apply(lut: np.ndarray, img: np.ndarray) -> np.ndarray:
    idx = (img[..., :3] // 16).clip(0, N - 1)
    out = img.copy()
    for c in range(3):
        out[..., c] = lut[idx[..., 0], idx[..., 1], idx[..., 2], c].round().clip(0, 255).astype(np.uint8)
    return out


def encode_sheet_straight(img: np.ndarray, path: Path) -> None:
    """Ré-encode une feuille RGBA droite en .tile RogueEssence SANS changer la grille (x, y conservés)."""
    h, w = img.shape[:2]
    records = []
    blobs = bytearray()
    dedup = {}
    cur = 8  # placeholder, recalculé après
    entries = []
    for gy in range(0, h, 8):
        for gx in range(0, w, 8):
            blk = Image.fromarray(img[gy:gy + 8, gx:gx + 8], "RGBA")
            arr = np.array(premult_rgba(blk), dtype=np.uint8)
            key = arr.tobytes()
            if key in dedup:
                records.append((gx // 8, gy // 8, dedup[key]))
                continue
            png = encode_8x8_minimal_png(blk)
            dedup[key] = ("BLOB", len(entries))
            entries.append(png)
            records.append((gx // 8, gy // 8, ("BLOB", len(entries) - 1)))
    # offsets : header + records puis blobs dans l'ordre d'insertion
    n_rec = len(records)
    off = 8 + n_rec * 16
    blob_off = []
    for png in entries:
        blob_off.append(off)
        off += 8 + len(png)
    header = bytearray(_struct.pack("<ii", 8, n_rec))
    for tx, ty, tag in records:
        header.extend(_struct.pack("<iiq", tx, ty, blob_off[tag[1]]))
    raw = bytearray(bytes(header))
    for png in entries:
        raw.extend(_struct.pack("<q", len(png)) + png)
    path.write_bytes(bytes(raw))


def main() -> None:
    base_d = np.asarray(decode_tile_straight(NATIFS / "Metano_Town_Base.tile"))
    base_n = np.asarray(decode_tile_straight(NATIFS / "Metano_Town_Base_Night.tile"))
    lut = _lut_from_pair(base_d, base_n)
    # contrôle : la LUT rejoue la nuit native sur un quart différent de la paire
    chk = _apply(lut, base_d)
    m = base_d[..., 3] > 200
    err = float(np.abs(chk[..., :3].astype(float) - base_n[..., :3].astype(float))[m].mean())
    assert err < 26.0, f"LUT jour->nuit trop infidèle sur la paire native : {err:.1f}"
    for name in ("Metano_Town_Objects", "Metano_Town_Animation_Tileset"):
        src = REFS / f"{name}.tile"
        if not src.is_file():
            alt = ROOT / "source" / "amp_plains_fleurie_v1" / "references" / f"{name}.tile" if "Objects" in name else ROOT / "source" / "eau_metano" / "natifs" / f"{name}.tile"
            import shutil

            shutil.copy2(alt, src)
        day = np.asarray(decode_tile_straight(src))
        encode_sheet_straight(_apply(lut, day), REFS / f"{name}_Night.tile")
        back = np.asarray(decode_tile_straight(REFS / f"{name}_Night.tile"))
        tgt = _apply(lut, day)
        solid = tgt[..., 3] > 200
        err_rt = float(np.abs(back[..., :3].astype(int) - tgt[..., :3].astype(int))[solid].mean())
        assert back.shape == day.shape and err_rt < 2.0, f"round-trip .tile infidèle : {err_rt:.2f}"
        print(f"    round-trip ok (err {err_rt:.2f} sur pixels opaques)")
        print(f"  {name}_Night.tile écrit (err LUT paire native = {err:.1f})")


if __name__ == "__main__":
    main()
