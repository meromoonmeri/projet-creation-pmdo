#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Constructeur PMDO `0.8.12.0` — `DSTN` : Écran-Titre **NUIT** séparé
(**Pokémon Mystery Dungeon : Destiny** — Mer nocturne générée, ~105 étoiles scintillantes +
étoile filante & Blason **Œuf & 2 Ailes de chaque côté** plus petit et centré).
"""
from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import List, Tuple

import numpy as np
from PIL import Image

SOURCE_DIR = Path(__file__).resolve().parent.parent
REPO_ROOT = SOURCE_DIR.parent
for p in (str(REPO_ROOT), str(SOURCE_DIR)):
    if p not in sys.path:
        sys.path.insert(0, p)

from source.moteur_pmd_destiny_fangame import (
    FRAME_TICKS_MENU,
    H_CANON as H_NAT,
    W_CANON as W_NAT,
    build_destiny_separate_scene,
)
from tour_celeste_moteur_nuages import H_CANON, W_CANON, LayerEntry, build_rsground_package  # type: ignore

MAP_ID = "DSTN"
MAP_TITLE = "Pokémon Mystery Dungeon : Destiny — Écran-Titre NUIT (Mer nocturne générée & Blason Œuf Ailé centré)"
GROUND_ID = "pmd_destiny_menu_nuit"

HERE = Path(__file__).resolve().parent
CANON_REF = HERE / "references" / "ref_canon_pmd_destiny_menu_nuit.png"
RENDERS_DIR = REPO_ROOT / "renders" / "pmd_destiny_nuit_v1"
VIRTUAL_ZIP = REPO_ROOT / ".cache" / "virtual_zips" / f"{MAP_ID}_PMDO_0.8.12.zip"


def _resize_frames(frames: List[Image.Image], w: int, h: int) -> List[Image.Image]:
    if (w, h) == (W_NAT, H_NAT):
        return frames
    return [im.resize((w, h), Image.Resampling.NEAREST) for im in frames]


def _write_halcyon_ground_script(pkg_dir: Path, ground_id: str) -> None:
    hdir = pkg_dir / "Data" / "Script" / "halcyon" / "ground" / ground_id
    hdir.mkdir(parents=True, exist_ok=True)
    (hdir / "init.lua").write_text(
        f"require 'origin.common'\n"
        f"local {ground_id} = {{}}\n"
        f"function {ground_id}.Init(map) DEBUG.EnableDbgCoro() end\n"
        f"function {ground_id}.Enter(map)\n"
        f"  UI:WaitShowBG('Title_Screen_Background_Nuit', {FRAME_TICKS_MENU}, 20)\n"
        f"  GAME:FadeIn(20)\n"
        f"end\n"
        f"function {ground_id}.Exit(map) end\n"
        f"function {ground_id}.Update(map) end\n"
        f"function {ground_id}.GameSave(map) end\n"
        f"function {ground_id}.GameLoad(map) GAME:FadeIn(20) end\n"
        f"return {ground_id}\n",
        encoding="utf-8",
    )


def build_layers_for_size(w: int = W_CANON, h: int = H_CANON) -> Tuple[List[LayerEntry], np.ndarray]:
    scene = build_destiny_separate_scene("nuit")
    raw_layers = scene["layers_768"]

    if not CANON_REF.is_file():
        CANON_REF.parent.mkdir(parents=True, exist_ok=True)
        comp0 = scene["bg_composites_768"][0].copy()
        comp0.alpha_composite(raw_layers[-1][3][0])
        comp0.convert("RGB").save(CANON_REF, format="PNG", optimize=True)

    layers = [
        LayerEntry(lid, label, kind, _resize_frames(flist, w, h), frame_length=flen)
        for lid, label, kind, flist, flen in raw_layers
    ]
    gw, gh = w // 8, h // 8
    walk_grid = np.zeros((gh, gw), dtype=np.uint8)
    walk_grid[gh // 2 - 4 : gh // 2 + 4, gw // 2 - 8 : gw // 2 + 8] = 1
    return layers, walk_grid


def build(scale: float = 1.0, output_override: Path | None = None) -> dict:
    w = max(64, int(round(W_CANON * scale / 8)) * 8)
    h = max(64, int(round(H_CANON * scale / 8)) * 8)
    out_dir = output_override if output_override is not None else RENDERS_DIR
    vzip = (out_dir / f"{MAP_ID}_PMDO_0.8.12.zip") if output_override is not None else VIRTUAL_ZIP
    VIRTUAL_ZIP.parent.mkdir(parents=True, exist_ok=True)

    layers, walk_grid = build_layers_for_size(w, h)
    meta = build_rsground_package(
        map_id=MAP_ID,
        map_title=MAP_TITLE,
        layers=layers,
        walk_grid=walk_grid,
        renders_dir=out_dir,
        virtual_zip_path=vzip,
        canonical_ref_for_fidelity=CANON_REF,
        max_fidelity_distance=35.0,
        max_unique_tiles_per_bank=24000,
        namespace_override="pmd_destiny_dstn",
        asset_name_override=GROUND_ID,
    )
    _write_halcyon_ground_script(out_dir / "package", GROUND_ID)
    meta["width"] = w
    meta["height"] = h
    if output_override is None:
        (RENDERS_DIR / "metadata.json").write_text(json.dumps(meta, indent=2, ensure_ascii=False), encoding="utf-8")
    return meta


if __name__ == "__main__":
    info = build()
    print(json.dumps(info, indent=2, ensure_ascii=False))
