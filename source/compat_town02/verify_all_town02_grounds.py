#!/usr/bin/env python3
"""
Vérificateur exhaustif zéro-confiance de la compatibilité 100 % native `meromoonmeri/town02`
pour l'intégralité des 62 cartes `.rsground` du dépôt `projet-creation-pmdo` (sur disque et dans toutes les archives `.zip`).
"""
from __future__ import annotations

import glob
import io
import json
import os
import struct
import zipfile
from pathlib import Path
from typing import Dict, Tuple

import numpy as np
from PIL import Image

ROOT = Path("/home/user/projet-creation-pmdo")
TOWN02_TILES = Path("/tmp/town02_git/Content/Tile")


def main() -> None:
    valid_coords: Dict[str, set] = {}
    for p in glob.glob(str(TOWN02_TILES / "*.tile")):
        sname = os.path.basename(p)[:-5]
        raw = open(p, "rb").read()
        tsize, cnt = struct.unpack_from("<II", raw, 0)
        coords = set()
        for i in range(cnt):
            k, _ = struct.unpack_from("<QQ", raw, 8 + i * 16)
            coords.add((int(k & 0xFFFFFFFF), int(k >> 32)))
        valid_coords[sname] = coords

    targets = []
    for p in sorted(
        list(ROOT.glob("*.rsground"))
        + list((ROOT / "renders").rglob("*.rsground"))
        + list((ROOT / "livrables_cliff_nord_nuit_pmdo").rglob("*.rsground"))
    ):
        targets.append((str(p.relative_to(ROOT)), p.stem, p.read_bytes()))

    for zp in sorted(ROOT.glob("livrables_*/*.zip")):
        with zipfile.ZipFile(zp, "r") as zf:
            for n in sorted(zf.namelist()):
                if n.endswith(".rsground"):
                    targets.append((f"{zp.name}::{n}", Path(n).stem, zf.read(n)))

    total_frames = 0
    animated_cells = 0
    errors = []

    for label, stem, raw_bytes in targets:
        doc = json.loads(raw_bytes.decode("utf-8-sig"))
        if doc.get("Version") != "0.8.12.0":
            errors.append((label, f"Version={doc.get('Version')}"))
        o = doc["Object"]
        if o.get("$type") != "RogueEssence.Ground.GroundMap, RogueEssence":
            errors.append((label, f"Bad $type={o.get('$type')}"))
        if o.get("AssetName") != stem:
            errors.append((label, f"AssetName={o.get('AssetName')} != {stem}"))
        bg = o.get("Background", {})
        if bg.get("$type") != "RogueEssence.Dungeon.MapBG, RogueEssence" or bg.get("BGAnim", {}).get("AnimIndex") != "" or bg.get("Parallax") != "0, 0":
            errors.append((label, f"Non-standalone Background={bg}"))
        if not o.get("Decorations"):
            errors.append((label, "Empty Decorations"))
        gw = len(o["Layers"][0]["Tiles"])
        gh = len(o["Layers"][0]["Tiles"][0])
        if len(o.get("obstacles", [])) != gw or len(o["obstacles"][0]) != gh:
            errors.append((label, "Invalid obstacles dimensions"))
        ent0 = o.get("Entities", [{}])[0]
        if not ent0.get("Spawners") or not ent0.get("Markers"):
            errors.append((label, "Missing Spawners or Markers"))
        for lyr in o["Layers"]:
            for col in lyr["Tiles"]:
                for cell in col:
                    if "AutoTileset" not in cell or "NeighborCode" not in cell:
                        errors.append((label, "Incomplete AutoTile cell keys"))
                    for tl in cell.get("Layers", []):
                        frs = tl.get("Frames", [])
                        if len(frs) > 1:
                            animated_cells += 1
                        for fr in frs:
                            total_frames += 1
                            sh = fr.get("Sheet", "")
                            tx, ty = fr["TexLoc"]["X"], fr["TexLoc"]["Y"]
                            if sh not in valid_coords:
                                errors.append((label, f"Missing sheet in town02: {sh!r}"))
                            elif (tx, ty) not in valid_coords[sh]:
                                errors.append((label, f"Out-of-bounds TexLoc ({tx},{ty}) in {sh}"))

    assert not errors, f"FAILED WITH {len(errors)} ERRORS: {errors[:10]}"

    # Décoder 4 cartes réelles (`.rsground` pur + `.tile` de `/tmp/town02_git/Content/Tile/` SEULEMENT !) pour preuve visuelle
    tile_img_cache: Dict[Tuple[str, int, int], Image.Image] = {}
    sheet_raw_cache: Dict[str, Tuple[bytes, Dict[Tuple[int, int], int]]] = {}

    def get_town02_tile_im(sh: str, tx: int, ty: int) -> Image.Image:
        key = (sh, tx, ty)
        im = tile_img_cache.get(key)
        if im is not None:
            return im
        if sh not in sheet_raw_cache:
            raw = (TOWN02_TILES / f"{sh}.tile").read_bytes()
            _, cnt = struct.unpack_from("<II", raw, 0)
            tbl = {}
            for i in range(cnt):
                k, off = struct.unpack_from("<QQ", raw, 8 + i * 16)
                tbl[(int(k & 0xFFFFFFFF), int(k >> 32))] = off
            sheet_raw_cache[sh] = (raw, tbl)
        raw, tbl = sheet_raw_cache[sh]
        off = tbl[(tx, ty)]
        (ln,) = struct.unpack_from("<q", raw, off)
        im = Image.open(io.BytesIO(raw[off + 8 : off + 8 + ln])).convert("RGBA")
        tile_img_cache[key] = im
        return im

    os.makedirs("/tmp/verified_town02_previews", exist_ok=True)
    with zipfile.ZipFile(ROOT / "livrables_cliff_nord_centre_pmdo/TOUTES_MAPS_TOWN02_RSGROUND.zip") as zf:
        for sample in [
            "cliff_centre_01_grand_cap_panoramique_nuit.rsground",
            "cliff_centre_01_grand_cap_panoramique_crepuscule.rsground",
            "guilde_vide_guild_second_floor.rsground",
            "metano_gen_accueil.rsground",
        ]:
            doc = json.loads(zf.read(f"Data/Ground/{sample}").decode("utf-8"))
            o = doc["Object"]
            gw = len(o["Layers"][0]["Tiles"])
            gh = len(o["Layers"][0]["Tiles"][0])
            canvas = Image.new("RGBA", (gw * 8, gh * 8), (0, 0, 0, 255))
            for lyr in o["Layers"]:
                layer_im = Image.new("RGBA", (gw * 8, gh * 8), (0, 0, 0, 0))
                has_any = False
                for cx in range(gw):
                    for cy in range(gh):
                        for tl in lyr["Tiles"][cx][cy].get("Layers", []):
                            frs = tl["Frames"]
                            fr = frs[5 % len(frs)]
                            t_im = get_town02_tile_im(fr["Sheet"], fr["TexLoc"]["X"], fr["TexLoc"]["Y"])
                            layer_im.alpha_composite(t_im, (cx * 8, cy * 8))
                            has_any = True
                if has_any:
                    canvas.alpha_composite(layer_im)
            canvas.save(f"/tmp/verified_town02_previews/{sample}.png")

    with zipfile.ZipFile(ROOT / "livrables_cliff_nord_centre_pmdo/TOUTES_MAPS_TOWN02_RSGROUND.zip") as zf_cnt:
        unique_master_count = sum(n.endswith(".rsground") for n in zf_cnt.namelist())

    report = {
        "status": "PASS",
        "town02_tilesets_verified_against": len(valid_coords),
        "rsground_instances_verified_zero_error": len(targets),
        "unique_project_maps_in_master_pack": unique_master_count,
        "total_tile_frame_references_verified_100pct_in_town02": total_frames,
        "animated_multi_frame_cells_verified": animated_cells,
        "missing_tile_sheets": 0,
        "out_of_bounds_texlocs": 0,
        "external_dir_backgrounds_required": 0,
        "external_tile_files_required": 0,
    }
    (ROOT / "livrables_cliff_nord_centre_pmdo/verification_compatibilite_town02.json").write_text(
        json.dumps(report, indent=2, ensure_ascii=False), encoding="utf-8"
    )
    print(json.dumps(report, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
