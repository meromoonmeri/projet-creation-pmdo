#!/usr/bin/env python3
"""Replace the four rmvillage NNV houses with native PMU buildings, and
re-shape each NNV plot around the real footprint of its new building.

Owner contract:
    NNV terrain      = base, kept; never rebuilt from other maps
    NNV house + door = removed (structure layers + door cells + door entity)
    PMU building     = placed at NATIVE x1, never rescaled
    NNV plot         = re-shaped to the PMU building's real footprint
    access path      = re-routed to the new entrance
    trees / decor    = kept unless they conflict with the building or its access

The plot is expressed in the NNV terrain layers themselves: `NNV ground` is a
uniform dirt bed and `NNV grass0`/`grass1` paint grass on top. A bare plot is
therefore an ABSENCE of grass. Re-shaping a plot means editing only those grass
layers with tiles already present in the NNV tileset - no foreign asset, no
invented tile, no imported terrain.

Buildings are drawn into the Ground as GroundObject decorations referencing a
dedicated PMU sheet, so the NNV tileset stays untouched.

Writes only under NO_NAME_VILLAGE_ADAPTATION/generated/. Never modifies
docs/pmuniverse_buildings (verified by hash), Data/, or Content/.
"""
from __future__ import annotations

import argparse
import hashlib
import io
import json
import struct
from pathlib import Path

from PIL import Image

REPO = Path(__file__).resolve().parents[2]
GEN = REPO / "NO_NAME_VILLAGE_ADAPTATION/generated/rmvillage"
LIB = REPO / "docs/pmuniverse_buildings"
CELL = 8                      # PMDO cell after normalisation
GRID = 78

STRUCTURE_LAYERS = ("NNV HouseBelow", "NNV sHouseBelow")
GRASS_LAYERS = ("NNV grass0", "NNV grass1")

# Door cell blocks on `NNV instances`, in the ORIGINAL 64 px grid (unchanged by
# normalisation: the tile grid stays 78x78).
DOOR_BLOCKS = {
    106508: {"origin": (14, 51), "size": (3, 3)},
    106510: {"origin": (17, 30), "size": (2, 3)},
    106511: {"origin": (34, 9), "size": (3, 3)},
    106509: {"origin": (61, 32), "size": (2, 3)},
}

# One distinct building per plot. Footprint ratios 0.79-0.96 of the old house,
# so each plot is re-shaped rather than left oversized.
PLOTS = {
    "objplayerhouse": {
        "door": 106508, "building": "tiles9_0744",
        "house_px": (150, 123), "house_origin_px": (36, 358),
        "entrance": "south",
    },
    "objloggerhouse": {
        "door": 106510, "building": "tiles9_0422",
        "house_px": (118, 105), "house_origin_px": (101, 175),
        "entrance": "south",
    },
    "objhunterhouse": {
        "door": 106509, "building": "tiles9_0434",
        "house_px": (118, 107), "house_origin_px": (477, 206),
        "entrance": "south",
    },
    "objcarpenterhouse": {
        "door": 106511, "building": "tiles9_0406",
        "house_px": (149, 91), "house_origin_px": (165, 6),
        "entrance": "south",
    },
}


def sha256_file(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def read_tile(path: Path):
    raw = path.read_bytes()
    size, count = struct.unpack_from("<II", raw, 0)
    out = []
    for i in range(count):
        key, off = struct.unpack_from("<QQ", raw, 8 + i * 16)
        (ln,) = struct.unpack_from("<Q", raw, off)
        out.append((key, raw[off + 8: off + 8 + ln]))
    return size, out


def write_tile(path: Path, tile_size: int, entries):
    offsets, payloads = {}, []
    offset = 8 + len(entries) * 16
    for _, payload in entries:
        if payload not in offsets:
            offsets[payload] = offset
            payloads.append(payload)
            offset += 8 + len(payload)
    out = bytearray(struct.pack("<II", tile_size, len(entries)))
    for key, payload in entries:
        out.extend(struct.pack("<QQ", key, offsets[payload]))
    for payload in payloads:
        out.extend(struct.pack("<Q", len(payload)))
        out.extend(payload)
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(bytes(out))


def premultiply(image: Image.Image) -> Image.Image:
    out = Image.new("RGBA", image.size)
    src, dst = image.load(), out.load()
    for y in range(image.height):
        for x in range(image.width):
            r, g, b, a = src[x, y]
            dst[x, y] = (r * a // 255, g * a // 255, b * a // 255, a)
    return out


def door_cells(door_id: int):
    b = DOOR_BLOCKS[door_id]
    ox, oy = b["origin"]
    w, h = b["size"]
    return {(ox + dx, oy + dy) for dx in range(w) for dy in range(h)}


def filled(layer, cx, cy) -> bool:
    stack = layer["Tiles"][cx][cy].get("Layers") or []
    return bool(stack and (stack[0].get("Frames") or []))


def clear_cell(layer, cx, cy) -> None:
    layer["Tiles"][cx][cy] = {"AutoTileset": "", "Associates": [],
                              "Layers": [{"Frames": [], "FrameLength": 1}],
                              "NeighborCode": -1}


def copy_cell(layer, src, dst) -> None:
    layer["Tiles"][dst[0]][dst[1]] = json.loads(json.dumps(layer["Tiles"][src[0]][src[1]]))


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--season", default="summer")
    parser.add_argument("--out", type=Path,
                        default=REPO / "NO_NAME_VILLAGE_ADAPTATION/reports/plot-adaptation")
    args = parser.parse_args()
    args.out.mkdir(parents=True, exist_ok=True)

    pmu_before = {p.name: sha256_file(p) for p in sorted((LIB / "buildings").glob("*.png"))}

    ground_path = GEN / args.season / f"Data/Ground/nnv_rmvillage_{args.season}.rsground"
    document = json.loads(ground_path.read_text(encoding="utf-8-sig"))
    obj = document["Object"]
    layers = {l["Name"]: l for l in obj["Layers"]}
    obstacles = obj["obstacles"]
    world = len(obstacles) * CELL

    # ---- build the PMU sheet: native x1 images, one tile row per building ----
    sheet_entries = []
    placements = []
    report = []

    for name, spec in PLOTS.items():
        bid = spec["building"]
        image = Image.open(LIB / "buildings" / f"{bid}.png").convert("RGBA")
        bw, bh = image.size

        hx, hy = spec["house_origin_px"]
        hw, hh = spec["house_px"]

        # Anchor the building so its base sits where the old house base was,
        # horizontally centred on the old footprint.
        bx = hx + (hw - bw) // 2
        by = hy + hh - bh
        bx = max(0, min(world - bw, bx))
        by = max(0, min(world - bh, by))

        # ---- 1. remove the old NNV structure over its footprint ----
        removed = 0
        for lname in STRUCTURE_LAYERS:
            layer = layers[lname]
            n = len(layer["Tiles"])
            step = world // n
            for cx in range(max(0, hx // step), min(n, (hx + hw - 1) // step + 1)):
                for cy in range(max(0, hy // step), min(n, (hy + hh - 1) // step + 1)):
                    if filled(layer, cx, cy):
                        clear_cell(layer, cx, cy)
                        removed += 1

        # ---- 2. remove the door graphic ----
        inst = layers["NNV instances"]
        for cx, cy in door_cells(spec["door"]):
            if 0 <= cx < len(inst["Tiles"]) and 0 <= cy < len(inst["Tiles"][0]):
                if filled(inst, cx, cy):
                    clear_cell(inst, cx, cy)

        # ---- 3. re-shape the plot to the PMU footprint ----
        # Bare ground = no grass. Old plot was sized for the old house; we clear
        # grass over the new footprint plus a walking margin, and restore grass
        # where the old plot extended well beyond the new building.
        margin = 16  # px of bare ground around the building for circulation
        px0, py0 = bx - margin, by - margin
        px1, py1 = bx + bw + margin, by + bh + margin
        # access strip toward the entrance (south): keep bare down to the path
        access_w = 48
        ax0 = bx + bw // 2 - access_w // 2
        ax1 = ax0 + access_w
        ay1 = min(world, by + bh + 72)

        cleared = restored = 0
        grass_src = None
        for lname in GRASS_LAYERS:
            layer = layers[lname]
            n = len(layer["Tiles"])
            step = world // n
            # find a donor grass cell far from all plots, to restore with a real NNV tile
            if grass_src is None:
                for sx in range(n - 1, 0, -1):
                    for sy in range(n - 1, 0, -1):
                        if filled(layer, sx, sy):
                            grass_src = (sx, sy)
                            break
                    if grass_src:
                        break
            # clear grass over new footprint + margin + access strip
            for cx in range(max(0, px0 // step), min(n, px1 // step + 1)):
                for cy in range(max(0, py0 // step), min(n, py1 // step + 1)):
                    if filled(layer, cx, cy):
                        clear_cell(layer, cx, cy)
                        cleared += 1
            for cx in range(max(0, ax0 // step), min(n, ax1 // step + 1)):
                for cy in range(max(0, (by + bh) // step), min(n, ay1 // step + 1)):
                    if filled(layer, cx, cy):
                        clear_cell(layer, cx, cy)
                        cleared += 1
            # restore grass on the part of the OLD plot the new building no longer uses
            if grass_src:
                for cx in range(max(0, hx // step), min(n, (hx + hw) // step + 1)):
                    for cy in range(max(0, hy // step), min(n, (hy + hh) // step + 1)):
                        cxp, cyp = cx * step, cy * step
                        inside_new = (px0 <= cxp <= px1 and py0 <= cyp <= py1)
                        inside_acc = (ax0 <= cxp <= ax1 and by + bh <= cyp <= ay1)
                        if not inside_new and not inside_acc and not filled(layer, cx, cy):
                            copy_cell(layer, grass_src, (cx, cy))
                            restored += 1

        # ---- 4. collision: clear the old house, block the new building ----
        for gx in range(max(0, hx // CELL), min(len(obstacles), (hx + hw) // CELL + 1)):
            for gy in range(max(0, hy // CELL), min(len(obstacles[0]), (hy + hh) // CELL + 1)):
                obstacles[gx][gy]["Tags"] = 0
        alpha = image.getchannel("A").load()
        blocked = 0
        for gx in range(bx // CELL, min(len(obstacles), (bx + bw) // CELL + 1)):
            for gy in range(by // CELL, min(len(obstacles[0]), (by + bh) // CELL + 1)):
                opaque = 0
                for dx in range(CELL):
                    for dy in range(CELL):
                        ix, iy = gx * CELL + dx - bx, gy * CELL + dy - by
                        if 0 <= ix < bw and 0 <= iy < bh and alpha[ix, iy] > 0:
                            opaque += 1
                if opaque >= (CELL * CELL) // 2:
                    obstacles[gx][gy]["Tags"] = 1
                    blocked += 1

        # ---- 5. register the building as a PMU sheet tile + GroundObject ----
        key = (len(sheet_entries) << 32) | 0
        buf = io.BytesIO()
        premultiply(image).save(buf, format="PNG", optimize=False, compress_level=9)
        sheet_entries.append((key, buf.getvalue()))
        placements.append({"name": name, "building": bid, "x": bx, "y": by,
                           "w": bw, "h": bh, "key": key})

        report.append({
            "plot": name,
            "old_house_px": [hw, hh], "old_origin_px": [hx, hy],
            "pmu_building": bid, "pmu_native_px": [bw, bh], "pmu_rescaled": False,
            "footprint_ratio": round((bw * bh) / (hw * hh), 3),
            "new_origin_px": [bx, by],
            "structure_cells_removed": removed,
            "door_removed": f"Exit_Door_{spec['door']}",
            "plot_grass_cleared": cleared,
            "plot_grass_restored": restored,
            "access_strip_px": [ax0, by + bh, access_w, ay1 - (by + bh)],
            "collision_cells_blocked": blocked,
            "entrance": spec["entrance"],
        })
        print(f"  {name:20} {bid:14} {bw:>3}x{bh:<3} @({bx},{by})  "
              f"grass -{cleared}/+{restored}  collision {blocked}")

    # ---- remove the four door entities ----
    group = obj["Entities"][0]
    before = len(group["GroundObjects"])
    group["GroundObjects"] = [g for g in group["GroundObjects"]
                              if not g["EntName"].startswith("Exit_Door_")]
    doors_removed = before - len(group["GroundObjects"])

    # ---- write PMU sheet next to the season tileset ----
    sheet_name = "NNV_rmvillage_PMU_Buildings"
    tile_dir = GEN / args.season / "Content/Tile"
    max_dim = max(max(p["w"], p["h"]) for p in placements)
    write_tile(tile_dir / f"{sheet_name}.tile", max_dim, sheet_entries)

    # ---- add buildings as decorations ----
    deco = obj["Decorations"][0]
    deco["Anims"] = [{
        "$type": "RogueEssence.Ground.GroundAnim, RogueEssence",
        "MapLoc": {"X": p["x"], "Y": p["y"]},
        "LocHeight": 0,
        "Anim": {"$type": "RogueEssence.Content.ObjAnimData, RogueEssence",
                 "AnimIndex": sheet_name, "FrameTime": 1,
                 "StartFrame": idx, "EndFrame": idx, "AnimDir": -1,
                 "Alpha": 255, "AnimFlip": 0},
    } for idx, p in enumerate(placements)]

    payload = json.dumps(document, ensure_ascii=False, indent=2)
    ground_path.write_text("\ufeff" + payload, encoding="utf-8")

    pmu_after = {p.name: sha256_file(p) for p in sorted((LIB / "buildings").glob("*.png"))}
    assert pmu_before == pmu_after, "PMU source assets were modified"

    summary = {
        "schema": "new-era.nnv-plot-adaptation.v1",
        "season": args.season,
        "rule": "NNV terrain is the base; NNV house+door removed; PMU building placed at "
                "native x1; NNV plot re-shaped to the PMU footprint; access path re-routed",
        "pmu_rescaled": False,
        "pmu_sheet": sheet_name,
        "doors_removed": doors_removed,
        "plots": report,
        "pmu_source_assets_unchanged": pmu_before == pmu_after,
        "runtime_status": "NOT_RUN",
        "certification_status": "NOT_CERTIFIED",
    }
    (args.out / "plot-adaptation.json").write_text(
        json.dumps(summary, indent=2, sort_keys=True, ensure_ascii=False) + "\n")
    print(f"\n  portes retirees : {doors_removed}")
    print(f"  assets PMU sources inchanges : {pmu_before == pmu_after}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
