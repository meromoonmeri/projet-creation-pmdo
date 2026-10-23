#!/usr/bin/env python3
"""Génère le brut 1x Chunsoft / Halcyon `base_zekrom_montagne_entree.png` (768x576) :
Montagne d'orage face à une clairière Tiny Woods / Sky Peak Prairie et rivière Metano Town."""
from __future__ import annotations

import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from source.assembleur_bruts_unova_1x import assemble_entree_montagne_clairiere_metano


def main() -> None:
    paths = assemble_entree_montagne_clairiere_metano(
        mode="zekrom_electric",
        map_dir=HERE,
        asset_name="zekrom_montagne_entree",
    )
    print("OK ->", {k: str(v.relative_to(REPO_ROOT)) for k, v in paths.items()})


if __name__ == "__main__":
    main()
