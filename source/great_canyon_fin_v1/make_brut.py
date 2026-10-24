#!/usr/bin/env python3
"""Assemble le brut `768 × 576` `#FF00FF`, le calque `Top` et la référence composite pour GCF1 (Colline des Anciens / Xatu)."""
from __future__ import annotations

import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
for p in (str(REPO_ROOT), str(REPO_ROOT / "source")):
    if p not in sys.path:
        sys.path.insert(0, p)

from source.moteur_gouffre_et_canyon_pmd_red import assemble_gouffre_canyon_1x

if __name__ == "__main__":
    res = assemble_gouffre_canyon_1x(
        gen_path=HERE / "bruts" / "decor_great_canyon_fin_magenta.png",
        out_brut_path=HERE / "bruts" / "base_great_canyon_fin.png",
        out_canopy_path=HERE / "bruts" / "cretes_horizon_top.png",
        out_ref_canon_path=HERE / "references" / "ref_canon_great_canyon_fin.png",
        mode="hill_of_ancients",
    )
    print("OK ->", res)
