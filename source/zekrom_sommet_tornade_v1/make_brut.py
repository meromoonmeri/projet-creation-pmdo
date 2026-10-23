#!/usr/bin/env python3
"""Génère le brut 1x Chunsoft `base_zekrom_sommet_tornade.png` (768x576) :
Sommet naturel Mt. Thunder Summit centré dans l'œil #FF00FF du cyclone cylindrique électrique."""
from __future__ import annotations

import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
if str(REPO_ROOT) not in sys.path:
    sys.path.insert(0, str(REPO_ROOT))

from source.assembleur_bruts_unova_1x import assemble_sommet_mont_thunder_cyclone


def main() -> None:
    paths = assemble_sommet_mont_thunder_cyclone(
        mode="zekrom_electric",
        map_dir=HERE,
        asset_name="zekrom_sommet_tornade",
    )
    print("OK ->", {k: str(v.relative_to(REPO_ROOT)) for k, v in paths.items()})


if __name__ == "__main__":
    main()
