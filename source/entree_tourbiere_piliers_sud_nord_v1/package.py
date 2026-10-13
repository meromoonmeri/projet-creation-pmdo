#!/usr/bin/env python3
"""Empaquetage — entree_tourbiere_piliers_sud_nord_v1 (ETB1)."""
from __future__ import annotations

from pathlib import Path
import zipfile

from build import EXPORTS, MAP_ID, PREFIX, RENDERS, main as run_build


def package() -> Path:
    if not (EXPORTS / f"{MAP_ID}.rsground").exists():
        run_build()
    zip_path = EXPORTS / f"{MAP_ID}.zip"
    with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for p in sorted(EXPORTS.iterdir()):
            if p.suffix in {".tile", ".rsground", ".json", ".png"} and p.name != zip_path.name:
                zf.write(p, arcname=p.name)
        for p in sorted(RENDERS.iterdir()):
            if p.suffix in {".png", ".gif", ".html"}:
                zf.write(p, arcname=f"renders/{p.name}")
    print(f"[{PREFIX}] Archive créée : {zip_path} ({zip_path.stat().st_size} octets)")
    return zip_path


if __name__ == "__main__":
    package()
