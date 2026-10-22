#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Rendu PNG pixel-perfect des maps de Kloa - Child of the Forest.

Compose chaque scène Unity (level0..level40) en recomposant exactement ce
que le moteur sérialise — rien d'inventé :

  * SpriteRenderers actifs uniquement (m_Enabled + GameObject actif,
    parents inclus) ;
  * Tilemaps Unity (le sol/les murs du jeu) : chaque cellule m_Tiles est
    blittée via son sprite de m_TileSpriteArray, à la position
    origine_du_Tilemap + (cellule + m_TileAnchor) × cellSize du Grid
    (1×1 unité = 32 px, lu dans la scène), teinte par cellule, tri par le
    TilemapRenderer associé (sorting layer/order réels) ;
  * transformation monde par composition de la hiérarchie des Transforms
    (position, rotation Z, échelle) ;
  * sprite découpé par UnityPy selon son rect d'atlas (pixels source
    intacts), pivot et PixelsToUnits du sprite ;
  * échelle de rendu native : 32 px/unité (le PPU du pixel art du jeu —
    vérifié : 764/775 sprites de level21 à PPU=32) → les sprites PPU=32
    non étirés sont blittés 1:1, AUCUN resampling ;
  * agrandissements (échelle de Transform, PPU≠32) en NEAREST — jamais
    d'interpolation qui inventerait des pixels ;
  * flip X/Y, teinte/alpha (m_Color), ordre de rendu Unity réel :
    sorting layer (ordre du TagManager) → order in layer → -z.

Limites documentées (composition statique) : SpriteMasks, systèmes de
particules et éclairage dynamique ne sont pas simulés.

Sorties : dev/KLOA_ADAPTATION/renders/<levelN>_<SceneName>.png
Index    : dev/KLOA_ADAPTATION/renders/RENDER_INDEX.json
"""
from __future__ import annotations

import json
import math
import os
import sys
from pathlib import Path

import UnityPy
from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
SRC = ROOT / ".runtime-cache" / "kloa" / "source"
OUT = ROOT / "dev" / "KLOA_ADAPTATION" / "renders"

PPU_RENDER = 32.0          # échelle native du pixel art (px par unité monde)
MAX_CANVAS = 20000         # garde-fou dimensionnel


def scene_names() -> dict[str, str]:
    env = UnityPy.load(str(SRC / "globalgamemanagers"))
    for obj in env.objects:
        if obj.type.name == "BuildSettings":
            d = obj.read_typetree()
            return {f"level{i}": s for i, s in enumerate(d.get("scenes", []))}
    return {}


def sorting_layer_order() -> dict[int, int]:
    """uniqueID (normalisé non signé 32 bits) -> rang de rendu.

    Le TagManager sérialise les uniqueID en non signé, les renderers en
    signé : normaliser les deux avec & 0xFFFFFFFF est indispensable.
    """
    env = UnityPy.load(str(SRC / "globalgamemanagers"))
    for obj in env.objects:
        if obj.type.name == "TagManager":
            d = obj.read_typetree()
            layers = d.get("m_SortingLayers", [])
            order = {}
            for i, l in enumerate(layers):
                order[l.get("uniqueID", 0) & 0xFFFFFFFF] = i
            order.setdefault(0, 0)
            return order
    return {0: 0}


def layer_rank_of(layer_rank: dict, unique_id) -> int:
    return layer_rank.get((unique_id or 0) & 0xFFFFFFFF, 0)


def q_to_z_deg(q: dict) -> float:
    x, y, z, w = q.get("x", 0.0), q.get("y", 0.0), q.get("z", 0.0), q.get("w", 1.0)
    return math.degrees(math.atan2(2 * (w * z + x * y), 1 - 2 * (y * y + z * z)))


def render_level(fname: str, names: dict, layer_rank: dict) -> dict | None:
    env = UnityPy.load(str(SRC / fname))
    transforms: dict[int, dict] = {}
    gos: dict[int, dict] = {}
    renderers = []
    tilemaps: dict[int, object] = {}          # path_id GameObject -> Tilemap obj
    tilemap_renderers = []                    # TilemapRenderer objects
    grid_cell = (1.0, 1.0)
    for o in env.objects:
        t = o.type.name
        if t in ("Transform", "RectTransform"):
            try:
                transforms[o.path_id] = o.read_typetree()
            except Exception:
                pass
        elif t == "GameObject":
            try:
                gos[o.path_id] = o.read_typetree()
            except Exception:
                pass
        elif t == "SpriteRenderer":
            renderers.append(o)
        elif t == "Tilemap":
            try:
                tt = o.read_typetree()
                go_id = (tt.get("m_GameObject") or {}).get("m_PathID", 0)
                tilemaps[go_id] = o
            except Exception:
                pass
        elif t == "TilemapRenderer":
            tilemap_renderers.append(o)
        elif t == "Grid":
            try:
                g = o.read_typetree()
                cs = g.get("m_CellSize", {})
                grid_cell = (cs.get("x", 1.0), cs.get("y", 1.0))
            except Exception:
                pass

    # GameObject du Transform (pour tester l'activité des parents)
    tf_go = {tid: (t.get("m_GameObject") or {}).get("m_PathID", 0)
             for tid, t in transforms.items()}

    world_cache: dict[int, tuple] = {}

    def world(tid: int, depth=0):
        """(x, y, angle_deg, sx, sy, chaine_active) en composant les parents."""
        if tid in world_cache:
            return world_cache[tid]
        if depth > 128 or tid not in transforms:
            return (0.0, 0.0, 0.0, 1.0, 1.0, True)
        t = transforms[tid]
        lp, ls = t.get("m_LocalPosition", {}), t.get("m_LocalScale", {})
        lx, ly = lp.get("x", 0.0), lp.get("y", 0.0)
        sx, sy = ls.get("x", 1.0), ls.get("y", 1.0)
        ang = q_to_z_deg(t.get("m_LocalRotation", {}))
        active = bool(gos.get(tf_go.get(tid, 0), {}).get("m_IsActive", 1))
        father = (t.get("m_Father") or {}).get("m_PathID", 0)
        if father and father in transforms:
            px, py, pang, psx, psy, pact = world(father, depth + 1)
            ca, sa = math.cos(math.radians(pang)), math.sin(math.radians(pang))
            gx = px + (lx * psx) * ca - (ly * psy) * sa
            gy = py + (lx * psx) * sa + (ly * psy) * ca
            res = (gx, gy, pang + ang, psx * sx, psy * sy, pact and active)
        else:
            res = (lx, ly, ang, sx, sy, active)
        world_cache[tid] = res
        return res

    items = []
    for o in renderers:
        try:
            tt = o.read_typetree()
            if not tt.get("m_Enabled", 1):
                continue
            go_id = (tt.get("m_GameObject") or {}).get("m_PathID", 0)
            go = gos.get(go_id)
            if not go or not go.get("m_IsActive", 1):
                continue
            tid = next((c.get("component", {}).get("m_PathID", 0)
                        for c in go.get("m_Component", [])
                        if c.get("component", {}).get("m_PathID", 0) in transforms),
                       None)
            if tid is None:
                continue
            x, y, ang, sx, sy, chain_active = world(tid)
            if not chain_active:
                continue
            d = o.read()
            spr_pptr = d.m_Sprite
            try:
                spr = spr_pptr.read()
            except Exception:
                continue
            img = spr.image
            if img is None or img.width == 0:
                continue
            rect_w, rect_h = spr.m_Rect.width, spr.m_Rect.height
            ppu = float(spr.m_PixelsToUnits) or PPU_RENDER
            pivot = (float(spr.m_Pivot.x), float(spr.m_Pivot.y))
            color = tt.get("m_Color", {})
            lz = transforms[tid].get("m_LocalPosition", {}).get("z", 0.0)
            # z monde approx (les parents portent rarement du z en 2D)
            items.append({
                "img": img, "x": x, "y": y, "ang": ang,
                "sx": sx, "sy": sy,
                "rect_w": rect_w, "rect_h": rect_h, "ppu": ppu,
                "pivot": pivot,
                "flip": (bool(tt.get("m_FlipX")), bool(tt.get("m_FlipY"))),
                "color": (color.get("r", 1.0), color.get("g", 1.0),
                          color.get("b", 1.0), color.get("a", 1.0)),
                "layer": layer_rank_of(layer_rank, tt.get("m_SortingLayerID", 0)),
                "order": tt.get("m_SortingOrder", 0),
                "z": lz,
            })
        except Exception:
            continue
    # --- Tilemaps : chaque cellule devient un item de rendu ------------
    n_cells = 0
    for tro in tilemap_renderers:
        try:
            trt = tro.read_typetree()
            if not trt.get("m_Enabled", 1):
                continue
            go_id = (trt.get("m_GameObject") or {}).get("m_PathID", 0)
            go = gos.get(go_id)
            if not go or not go.get("m_IsActive", 1):
                continue
            tm_obj = tilemaps.get(go_id)
            if tm_obj is None:
                continue
            tid = next((c.get("component", {}).get("m_PathID", 0)
                        for c in go.get("m_Component", [])
                        if c.get("component", {}).get("m_PathID", 0) in transforms),
                       None)
            if tid is None:
                continue
            ox, oy, oang, osx, osy, chain_active = world(tid)
            if not chain_active:
                continue
            tm = tm_obj.read_typetree()
            cells = tm.get("m_Tiles", [])
            if not cells:
                continue
            spr_arr = tm.get("m_TileSpriteArray", [])
            col_arr = tm.get("m_TileColorArray", [])
            anchor = tm.get("m_TileAnchor", {})
            ax, ay = anchor.get("x", 0.5), anchor.get("y", 0.5)
            tm_color = tm.get("m_Color", {})
            layer = layer_rank_of(layer_rank, trt.get("m_SortingLayerID", 0))
            order = trt.get("m_SortingOrder", 0)
            # cache sprite index -> (image PIL, ppu, rect)
            spr_cache: dict[int, tuple] = {}

            def tile_sprite(idx: int):
                if idx in spr_cache:
                    return spr_cache[idx]
                res = None
                if 0 <= idx < len(spr_arr):
                    ref = spr_arr[idx].get("m_Data", {})
                    pid, fid = ref.get("m_PathID", 0), ref.get("m_FileID", 0)
                    if pid:
                        try:
                            from UnityPy.classes import PPtr
                            p = PPtr[object](m_FileID=fid, m_PathID=pid)
                            p.assetsfile = tm_obj.assets_file
                            spr = p.read()
                            img = spr.image
                            if img is not None and img.width:
                                res = (img.convert("RGBA"),
                                       float(spr.m_PixelsToUnits) or PPU_RENDER)
                        except Exception:
                            res = None
                spr_cache[idx] = res
                return res

            for cell in cells:
                pos, data = cell[0], cell[1]
                s = tile_sprite(data.get("m_TileSpriteIndex", -1))
                if s is None:
                    continue
                img, ppu = s
                ci = data.get("m_TileColorIndex", 0)
                cc = (col_arr[ci].get("m_Data", {})
                      if 0 <= ci < len(col_arr) else {})
                # centre monde de la cellule (anchor dans la cellule)
                cx = ox + (pos["x"] + ax) * grid_cell[0] * osx
                cy = oy + (pos["y"] + ay) * grid_cell[1] * osy
                items.append({
                    "img": img, "x": cx, "y": cy, "ang": oang,
                    "sx": osx, "sy": osy,
                    "rect_w": img.width, "rect_h": img.height, "ppu": ppu,
                    "pivot": (0.5, 0.5),
                    "flip": (False, False),
                    "color": (cc.get("r", 1.0) * tm_color.get("r", 1.0),
                              cc.get("g", 1.0) * tm_color.get("g", 1.0),
                              cc.get("b", 1.0) * tm_color.get("b", 1.0),
                              cc.get("a", 1.0) * tm_color.get("a", 1.0)),
                    "layer": layer, "order": order, "z": pos.get("z", 0.0),
                })
                n_cells += 1
        except Exception:
            continue

    if not items:
        return None

    # Ordre de rendu Unity : sorting layer, puis order, puis z décroissant
    items.sort(key=lambda i: (i["layer"], i["order"], -i["z"]))

    # bornes monde
    minx = miny = float("inf")
    maxx = maxy = float("-inf")
    for it in items:
        w_u = it["rect_w"] / it["ppu"] * abs(it["sx"])
        h_u = it["rect_h"] / it["ppu"] * abs(it["sy"])
        r = math.hypot(w_u, h_u) / 2 if it["ang"] else 0
        cx = it["x"] + (0.5 - it["pivot"][0]) * w_u * (1 if it["sx"] >= 0 else -1)
        cy = it["y"] + (0.5 - it["pivot"][1]) * h_u * (1 if it["sy"] >= 0 else -1)
        if it["ang"]:
            minx = min(minx, cx - r); maxx = max(maxx, cx + r)
            miny = min(miny, cy - r); maxy = max(maxy, cy + r)
        else:
            minx = min(minx, cx - w_u / 2); maxx = max(maxx, cx + w_u / 2)
            miny = min(miny, cy - h_u / 2); maxy = max(maxy, cy + h_u / 2)
    W = int(math.ceil((maxx - minx) * PPU_RENDER)) + 2
    H = int(math.ceil((maxy - miny) * PPU_RENDER)) + 2
    if W > MAX_CANVAS or H > MAX_CANVAS or W <= 0 or H <= 0:
        return {"skipped": f"canvas {W}x{H} hors garde-fou"}
    canvas = Image.new("RGBA", (W, H), (0, 0, 0, 0))

    for it in items:
        img = it["img"].convert("RGBA")
        # échelle : PPU du sprite -> PPU_RENDER, puis échelle du Transform
        fx = PPU_RENDER / it["ppu"] * abs(it["sx"])
        fy = PPU_RENDER / it["ppu"] * abs(it["sy"])
        tw = max(1, round(img.width * fx))
        th = max(1, round(img.height * fy))
        if (tw, th) != (img.width, img.height):
            img = img.resize((tw, th), Image.NEAREST)
        flip_x = it["flip"][0] ^ (it["sx"] < 0)
        flip_y = it["flip"][1] ^ (it["sy"] < 0)
        if flip_x:
            img = img.transpose(Image.FLIP_LEFT_RIGHT)
        if flip_y:
            img = img.transpose(Image.FLIP_TOP_BOTTOM)
        r, g, b, a = it["color"]
        if (r, g, b, a) != (1.0, 1.0, 1.0, 1.0):
            ch = img.split()
            img = Image.merge("RGBA", (
                ch[0].point(lambda v: int(v * r)),
                ch[1].point(lambda v: int(v * g)),
                ch[2].point(lambda v: int(v * b)),
                ch[3].point(lambda v: int(v * a))))
        if abs(it["ang"]) > 1e-3:
            img = img.rotate(it["ang"], expand=True, resample=Image.NEAREST)
        w_u = it["rect_w"] / it["ppu"] * abs(it["sx"])
        h_u = it["rect_h"] / it["ppu"] * abs(it["sy"])
        cx_u = it["x"] + (0.5 - it["pivot"][0]) * w_u * (1 if it["sx"] >= 0 else -1)
        cy_u = it["y"] + (0.5 - it["pivot"][1]) * h_u * (1 if it["sy"] >= 0 else -1)
        px = round((cx_u - minx) * PPU_RENDER - img.width / 2)
        py = round((maxy - cy_u) * PPU_RENDER - img.height / 2)
        canvas.alpha_composite(img, (max(-img.width, px), max(-img.height, py)))

    scene = names.get(fname, "").split("/")[-1].replace(".unity", "")
    dest = OUT / f"{fname}_{scene}.png"
    canvas.save(dest, optimize=False)
    return {"file": dest.name, "width": W, "height": H,
            "sprites_rendered": len(items) - n_cells,
            "tilemap_cells_rendered": n_cells}


def main() -> int:
    OUT.mkdir(parents=True, exist_ok=True)
    names = scene_names()
    ranks = sorting_layer_order()
    only = sys.argv[1:] or None
    index = {}
    for f in sorted(os.listdir(SRC), key=lambda s: (len(s), s)):
        if not f.startswith("level") or "." in f:
            continue
        if only and f not in only:
            continue
        try:
            res = render_level(f, names, ranks)
        except Exception as e:
            res = {"error": str(e)[:140]}
        index[f] = res or {"skipped": "aucun sprite"}
        print(f, "->", res)
    (OUT / "RENDER_INDEX.json").write_text(json.dumps(
        {"schema": "new-era.kloa-render-index.v1",
         "ppu_render": PPU_RENDER,
         "order": "sorting_layer(TagManager) -> order_in_layer -> -z",
         "notes": "composition statique; SpriteMasks/particules non simulés",
         "renders": index}, indent=1))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
