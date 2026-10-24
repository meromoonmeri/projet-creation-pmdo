#!/usr/bin/env python3
"""Génère le brut `768 × 576` et les références natives de `KYA1`."""
from __future__ import annotations

import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
REPO_ROOT = HERE.parents[1]
for p in (str(REPO_ROOT), str(REPO_ROOT / "source")):
    if p not in sys.path:
        sys.path.insert(0, p)

from source.moteur_grotte_cyclopeenne_kyurem import assemble_kyurem_sanctuaire_glace_brut


def main() -> None:
    res = assemble_kyurem_sanctuaire_glace_brut(HERE)
    for k, v in res.items():
        print(f"{k}: {v}")


if __name__ == "__main__":
    main()
