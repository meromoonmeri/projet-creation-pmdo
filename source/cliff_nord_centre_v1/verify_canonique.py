#!/usr/bin/env python3
"""Audit mathématique indépendant des 10 falaises côtières centrées canoniques :
  1. Vérifie les SHA-256 des planches natives `Metano_Town_{Base,Cliffs,Fringe}[_Night].tile`
  2. Vérifie que `abyss_night()` reproduit bit-à-bit l'intégralité des 3 planches `_Night.tile`
  3. Reconstruit indépendamment les 50 calques Jour + 50 calques Nuit depuis `placements.json`
     et prouve `generated_terrain_rgb_pixels == 0` et `pixel_differences == 0` sur les 100 calques !
"""
from __future__ import annotations

import hashlib
import json
import sys
from pathlib import Path
import numpy as np
from PIL import Image

ROOT = Path("/home/user/projet-creation-pmdo")
ABYSS_DIR = ROOT / "source/cote_v4_abyss"
OUT_DIR = ROOT / "livrables_cliff_nord_centre_pmdo"
WEB_DIR = OUT_DIR / "viewer_layers_1x"
PROV_DIR = OUT_DIR / "provenance_canonique"

sys.path.insert(0, str(ABYSS_DIR))
from sample import decode as decode_abyss
from night import night as abyss_night


def main() -> None:
    prov_ref = json.loads((ABYSS_DIR / "provenance.json").read_text(encoding="utf-8"))
    for f in prov_ref["files"]:
        raw = (ROOT / f["local"]).read_bytes()
        assert hashlib.sha256(raw).hexdigest() == f["sha256"], f["local"]

    sheets = {k: decode_abyss(ABYSS_DIR / "natifs" / f"Metano_Town_{k}.tile") for k in ("Base", "Cliffs", "Fringe")}
    for k, arr in sheets.items():
        assert np.array_equal(
            np.array(abyss_night(Image.fromarray(arr))),
            decode_abyss(ABYSS_DIR / "natifs" / f"Metano_Town_{k}_Night.tile"),
        ), k

    manifest = json.loads((OUT_DIR / "manifest.json").read_text(encoding="utf-8"))
    modules = manifest["canonical_metano_modules"]
    plane_files = manifest["terrain_planes"]
    total_placements = 0

    for z in manifest["zones"]:
        slug = z["id"]
        land = np.asarray(Image.open(PROV_DIR / f"{slug}_mask_land.png").convert("L")) > 0
        grass = np.asarray(Image.open(PROV_DIR / f"{slug}_mask_grass.png").convert("L")) > 0
        rock = land & (~grass)
        h, w = land.shape
        rebuilt = [np.zeros((h, w, 4), dtype=np.uint8) for _ in plane_files]

        mask_map = {"grass": grass, "rock": rock, "land": land}
        records = json.loads((PROV_DIR / f"{slug}_placements.json").read_text(encoding="utf-8"))
        for rec in records:
            x, y = rec["dest"]
            assert x % 8 == 0 and y % 8 == 0
            mod_name = rec["module"]
            bank, (sx, sy, ex, ey) = modules[mod_name]
            lyr = rec["layer"]
            mname = rec.get("mask", "grass" if lyr == 0 else "rock")
            l, t, r, b = max(x, 0), max(y, 0), min(x + ex - sx, w), min(y + ey - sy, h)
            src = sheets[bank][sy + t - y : sy + b - y, sx + l - x : sx + r - x]
            sel = mask_map[mname][t:b, l:r] & (src[..., 3] == 255)
            if mod_name.startswith("cour_") or mod_name.startswith("retour_"):
                rgb = src.astype(np.int16)
                sel &= ~((rgb[..., 1] > rgb[..., 0] - 8) & (rgb[..., 1] - rgb[..., 2] > 58))
            rebuilt[lyr][t:b, l:r][sel] = src[sel]

        merged = Image.new("RGBA", (w, h))
        for arr, pf in zip(rebuilt, plane_files):
            day_disk = np.asarray(Image.open(WEB_DIR / f"{slug}_jour_{pf}").convert("RGBA"))
            night_disk = np.asarray(Image.open(WEB_DIR / f"{slug}_nuit_{pf}").convert("RGBA"))
            assert np.array_equal(day_disk, arr), f"Jour diff {slug} {pf}"
            assert np.array_equal(night_disk, np.asarray(abyss_night(Image.fromarray(arr)))), f"Nuit diff {slug} {pf}"
            merged = Image.alpha_composite(merged, Image.fromarray(arr))

        assert np.array_equal(np.asarray(merged)[..., 3] > 0, land), f"Land alpha diff {slug}"
        assert hashlib.sha256(merged.tobytes()).hexdigest() == z["terrain_sha256"], f"SHA mismatch {slug}"
        total_placements += len(records)

    report = {
        "status": "PASS",
        "zones_verified": len(manifest["zones"]),
        "layers_verified_bit_identical": len(manifest["zones"]) * len(plane_files) * 2,
        "native_module_placements_rebuilt": total_placements,
        "generated_terrain_rgb_pixels": 0,
        "entire_base_cliffs_fringe_night_sheets_equal": True,
        "land_alpha_differences": 0,
    }
    (OUT_DIR / "verification_canonique.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
