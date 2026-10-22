#!/usr/bin/env python3
"""Verify Metano and Explorers of Sky: Origins isolated structures."""
from __future__ import annotations

import hashlib
import json
from pathlib import Path

from verify_pmd_structure_library import png_alpha_extrema

ROOT = Path(__file__).resolve().parents[1]
BASE = ROOT / "docs/metano_origins_structure_library"
EXPECTED = {
    "metano_cafe_day": ([259, 109], "4dcd97a95d0a64f845af4f7d50e55b38ffecab21db85d510d12fe36b418a713a"),
    "metano_kecleon_shop_day": ([112, 120], "fd2dc289d64cda9da196dc6f3563ad6d87c8c2779587fca1cc900b23de432027"),
    "metano_house_normal_day": ([80, 111], "957d9e566fd2b4c3a146a28d2e31f9552308034ee845e8422799cdb1c8dec19e"),
    "metano_house_rock_day": ([96, 96], "cfc3a1d4ac94e6ed35690ecc562d97c08ecd8beaeda8986aceee026deab3c455"),
    "metano_house_fire_day": ([110, 99], "14504e2c8ab9ff8f87c02d04a6f3048439080d325d3264915198f77b443e2765"),
    "metano_cafe_night": ([259, 109], "c3fc00540e73da3b609f9ee7c83862c6e981bb3f76ba531a377787bf1a46fce3"),
    "metano_kecleon_shop_night": ([112, 120], "029936878a732c673070b59b64c60316ab9635c30601b92a4b3900b630d31939"),
    "metano_house_normal_night": ([80, 111], "5f729b9747eee83f0ee080c3c2070cea355a33e1d923f8d61ec8ee0456253be2"),
    "metano_house_rock_night": ([96, 96], "f8ecbc65bcefdb3e22598d4e2408649f43790948543de43f3407b5d216e4fa6f"),
    "metano_house_fire_night": ([110, 99], "1dd45ace75ccef446631a07071adc70579a001d6fe1dea5688d6deadf317d8e0"),
    "origins_windmill_frame_0": ([64, 72], "826ef3518f41c13e11c17cfe0fec3011e01b4f35c78c3f38fb5efd243d879901"),
    "origins_windmill_frame_1": ([64, 72], "aa33623364d3e96d6b91495eedabc0a234bcd4bdda7a6480d90b9345be8239f5"),
    "origins_windmill_frame_2": ([64, 72], "99d227d66c0f8553fa7998adec03b12ceb4168f135dda1ff8e2478eb3d6f9cff"),
    "origins_windmill_frame_3": ([64, 72], "7bde21dc3bd10432d22cb3a6dae43d03916e70edfe6e0618d923af1298aa27a0"),
    "origins_well_frame_0": ([72, 56], "25da42a4d799ac3aa7e3a05249ecb43746dd296ecef8998172198b06d928cdf8"),
    "origins_well_frame_1": ([72, 56], "cfd5200f731e02b373e734ef6998e45a6eec38b21d21a26bd4a8f20d556b5f4a"),
    "origins_well_frame_2": ([72, 56], "95a3a5244114de4a3b7008d4ef636dbadd1e45bf433885eb6b5c824b9ce51e79"),
    "origins_well_frame_3": ([72, 56], "f7159878da5d298bb271b31d9c71f462907ecd8acfa548702cbdec0c98955555"),
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main() -> None:
    manifest = json.loads((BASE / "manifest.json").read_text(encoding="utf-8"))
    assert manifest["count"] == 18
    assert len(manifest["buildings"]) == 18
    assert len(manifest["blocked_not_exported"]) == 3
    assert manifest["source_authorities"]["explorers_of_sky_origins"]["commit"] == "159084383056c9552d174a87cbe098b933fc4a67"
    assert manifest["rules"]["rectangular_map_crops"] is False
    assert manifest["rules"]["terrain_layers_used"] == []
    assert manifest["rules"]["npc_layers_used"] == []

    assert {row["id"] for row in manifest["buildings"]} == set(EXPECTED)
    for row in manifest["buildings"]:
        dimensions, expected_hash = EXPECTED[row["id"]]
        path = BASE / row["file"]
        assert [row["width"], row["height"]] == dimensions
        assert row["sha256"] == expected_hash == sha256(path)
        assert row["native_resolution"] is True
        assert row["transparent_background"] is True
        assert row["npc_included"] is False
        assert row["terrain_included"] is False
        assert row["pixel_perfect"] is True
        assert row["pixel_mismatch_count"] == 0
        assert png_alpha_extrema(path)[0] == 0
        if row["id"].startswith("metano_"):
            assert row["source_tile_records"]
            assert not ({0, 1, 2, 3} & set(row["source_layers"]))

    render = BASE / manifest["render"]["file"]
    assert manifest["render"]["dimensions"] == [1040, 1050]
    assert sha256(render) == manifest["render"]["sha256"]
    print("METANO_ORIGINS_STRUCTURE_LIBRARY_PASS buildings=18 metano=10 origins=8 blocked=3 terrain=0 npc=0 mismatches=0")


if __name__ == "__main__":
    main()
