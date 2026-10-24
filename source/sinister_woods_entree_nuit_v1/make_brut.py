#!/usr/bin/env python3
"""Assemble le brut 1× `768 × 576` de `SWEN` (Bois Sinistre — Entrée, Version Nuit)."""
from __future__ import annotations

import json
import sys
from pathlib import Path

SOURCE_DIR = Path(__file__).resolve().parent.parent
REPO_ROOT = SOURCE_DIR.parent
for p in (str(REPO_ROOT), str(SOURCE_DIR)):
    if p not in sys.path:
        sys.path.insert(0, p)

from source.moteur_forets_pmd_red import assemble_foret_pmd_red_1x

HERE = Path(__file__).resolve().parent
DAY_DIR = SOURCE_DIR / "sinister_woods_entree_v1"


def main() -> None:
    info = assemble_foret_pmd_red_1x(
        gen_path=DAY_DIR / "bruts" / "decor_sinister_woods_entree_magenta.png",
        out_brut_path=HERE / "bruts" / "base_sinister_woods_entree_nuit.png",
        out_canopy_path=HERE / "bruts" / "canopee_arbres_top.png",
        out_ref_canon_path=HERE / "references" / "ref_canon_sinister_woods_entree_nuit.png",
        mode="sinister_woods_night",
    )
    print(json.dumps(info, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
