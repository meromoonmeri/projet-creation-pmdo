#!/usr/bin/env python3
"""Assemble le brut `768 × 576` `#FF00FF`, la canopée `Top` et la référence composite pour SWE1 (Bois Sinistre — Entrée)."""
from __future__ import annotations

import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
for p in (str(REPO_ROOT), str(REPO_ROOT / "source")):
    if p not in sys.path:
        sys.path.insert(0, p)

from source.moteur_forets_pmd_red import assemble_foret_pmd_red_1x

if __name__ == "__main__":
    res = assemble_foret_pmd_red_1x(
        gen_path=HERE / "bruts" / "decor_sinister_woods_entree_magenta.png",
        out_brut_path=HERE / "bruts" / "base_sinister_woods_entree.png",
        out_canopy_path=HERE / "bruts" / "canopee_arbres_top.png",
        out_ref_canon_path=HERE / "references" / "ref_canon_sinister_woods_entree.png",
        mode="sinister_woods_mist",
    )
    print("OK ->", res)
