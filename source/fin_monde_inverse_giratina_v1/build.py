"""Build script for Fin Monde Inverse de Giratina — Archipel du Neant Abyssal (4:3) (FMI1) — 4:3 (768 x 576, 96 x 72 cells of 8 px).
Pur décor sans structure ni artefact en fin de donjon.

.venv/bin/python source/fin_monde_inverse_giratina_v1/build.py
"""
from pathlib import Path
from collections import deque
from io import BytesIO
import hashlib, importlib.util, json, shutil, uuid, zipfile

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
R = HERE.parents[1]
RAW = HERE / "bruts"
LOT = "fin_monde_inverse_giratina_v1"
OUT = R / "renders" / LOT
CACHE_OUT = R / ".cache" / LOT / "renders"
NAMESPACE = "fin_monde_inverse_giratina"
STAGE = R / ".cache" / LOT / NAMESPACE
ASSET = "fmi1_fin_monde_inverse_giratina"
PFX = "FMI1"
REF_CODE = "finalisland"
KIND = "fin"
TITLE = "Fin Monde Inverse de Giratina — Archipel du Neant Abyssal (4:3)"
BIOME = "Monde Inverse de Giratina / Distortion World (ref. finalisland + Waterfall_Cave_ledge_TDS + D42P41A)"
THEME = "distortion"

W, H = 768, 576
GW, GH = W // 8, H // 8
SRC = (1200, 896)
ANIM_PHASES = 16
ANIM_TICKS = 5
LOOP_TICKS = ANIM_PHASES * ANIM_TICKS


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def load_scaled(name):
    p = RAW / name
    im = Image.open(p).convert("RGBA")
    if im.size != (W, H):
        im = im.resize((W, H), Image.Resampling.NEAREST)
    return np.array(im, dtype=np.uint8)


def save_png(p, a):
    p = Path(p)
    p.parent.mkdir(parents=True, exist_ok=True)
    Image.fromarray(a, "RGBA").save(p)


def tile_count(a):
    alpha = a.reshape(GH, 8, GW, 8, 4)[:, :, :, :, 3]
    return int((alpha.max(axis=(1, 3)) > 0).sum())


def bfs_16x16(blocked, start_px, goal_px):
    sx, sy = start_px[0] // 8, start_px[1] // 8
    gx, gy = goal_px[0] // 8, goal_px[1] // 8

    def ok_cell(cx, cy):
        if cx < 0 or cy < 0 or cx + 1 >= GW or cy + 1 >= GH:
            return False
        return not blocked[cy:cy + 2, cx:cx + 2].any()

    if not ok_cell(sx, sy) or not ok_cell(gx, gy):
        return False, 0

    q = deque([(sx, sy)])
    seen = {(sx, sy)}
    while q:
        x, y = q.popleft()
        if (x, y) == (gx, gy):
            return True, len(seen)
        for dx, dy in ((0, -1), (0, 1), (-1, 0), (1, 0)):
            nx, ny = x + dx, y + dy
            if (nx, ny) not in seen and ok_cell(nx, ny):
                seen.add((nx, ny))
                q.append((nx, ny))
    return False, len(seen)


def extract_layers():
    sol_raw = load_scaled("sol_complet.png")
    dec_raw = load_scaled("decor.png")
    mag_raw = load_scaled("decor_magenta.png")

    yy, xx = np.mgrid[0:H, 0:W]

    r_m = mag_raw[:, :, 0].astype(np.int16)
    g_m = mag_raw[:, :, 1].astype(np.int16)
    b_m = mag_raw[:, :, 2].astype(np.int16)
    is_mag = (r_m > 190) & (g_m < 85) & (b_m > 190) & ((r_m + b_m - 2 * g_m) > 260)

    is_mag = nd.binary_erosion(is_mag, iterations=1)
    is_mag = nd.binary_Closing(is_mag, iterations=2) if hasattr(nd, "binary_Closing") else nd.binary_closing(is_mag, iterations=2)
    is_mag = nd.binary_fill_holes(is_mag)

    # Ensure central South->North pathway is wide enough for 16x16 hitbox
    corridor_bridge = (yy >= 240) & (yy < H) & (xx >= (384 - 32)) & (xx <= (384 + 32))
    is_mag = is_mag | corridor_bridge

    labeled, ncomp = nd.label(is_mag)
    south_seed = labeled[H - 40:H - 4, W // 2 - 48:W // 2 + 48]
    vals = [v for v in np.unique(south_seed) if v > 0]
    if vals:
        main_label = max(vals, key=lambda v: int((labeled == v).sum()))
        walk_floor = (labeled == main_label)
    else:
        walk_floor = is_mag.copy()

    walk_floor &= (yy >= 200)
    walk_floor &= (xx >= 48) & (xx < W - 48)

    # Layer 00: SOL
    sol = sol_raw.copy()
    floor_vis = nd.binary_dilation(walk_floor, iterations=3)
    sol[floor_vis] = dec_raw[floor_vis]
    # In distortion world, keep the deep abyssal blue background visible on Layer 00
    if THEME == "distortion":
        sol = dec_raw.copy()
    sol[:, :, 3] = 255

    # Layer 01: RELIEF & Layer 02: COURONNES
    non_floor = ~walk_floor
    couronnes_mask = non_floor & (
        (yy < 168)
        | ((yy < 280) & ((xx < 176) | (xx >= W - 176)))
        | ((yy >= 400) & ((xx < 152) | (xx >= W - 152)))
    )
    relief_mask = non_floor & (~couronnes_mask)
    if THEME == "distortion":
        # Keep pure abyssal background on Layer 00, put islands/cliffs on Relief & Couronnes
        r_d = dec_raw[:, :, 0].astype(np.int16)
        g_d = dec_raw[:, :, 1].astype(np.int16)
        b_d = dec_raw[:, :, 2].astype(np.int16)
        deep_void = (r_d < 22) & (g_d < 55) & (b_d < 105) & non_floor
        couronnes_mask &= (~deep_void)
        relief_mask &= (~deep_void)

    relief = np.zeros((H, W, 4), dtype=np.uint8)
    relief[relief_mask] = dec_raw[relief_mask]

    couronnes = np.zeros((H, W, 4), dtype=np.uint8)
    couronnes[couronnes_mask] = dec_raw[couronnes_mask]

    # Collision grid (8x8 cells)
    blocked = np.zeros((GH, GW), dtype=bool)
    for gy in range(GH):
        for gx in range(GW):
            patch_walk = walk_floor[gy * 8:(gy + 1) * 8, gx * 8:(gx + 1) * 8]
            if patch_walk.mean() < 0.85:
                blocked[gy, gx] = True

    blocked[0:20, :] = True
    blocked[:, 0:6] = True
    blocked[:, GW - 6:GW] = True
    blocked = nd.binary_dilation(blocked, iterations=1)
    # Guarantee walkable central spine for 16x16 player
    for cy in range(240 // 8, GH - 1):
        for cx in range(45, 50):
            blocked[cy, cx] = False

    return sol, relief, couronnes, blocked, dec_raw, walk_floor


def build_animation_frames(dec_raw, walk_floor):
    frames = [np.zeros((H, W, 4), dtype=np.uint8) for _ in range(ANIM_PHASES)]
    yy, xx = np.mgrid[0:H, 0:W]
    r_d = dec_raw[:, :, 0].astype(np.int16)
    g_d = dec_raw[:, :, 1].astype(np.int16)
    b_d = dec_raw[:, :, 2].astype(np.int16)

    if THEME == "distortion":
        # 1) REVERSE WATERFALLS (cascades inversées qui coulent VERS LE HAUT: dy = +t * 3 dans la phase)
        waterfall_mask = (b_d > 175) & (g_d > 145) & (b_d > r_d + 55) & (~walk_floor) & ((xx < 290) | (xx > 478) | (yy < 245))
        # 2) ABYSSAL BLUE VOID SWIRLS (néant bleu abyssal animé en background)
        void_swirl_mask = (b_d > 75) & (b_d > r_d + 35) & (~waterfall_mask) & (~walk_floor) & (r_d < 65)

        # Anti-gravity rising droplets above/along waterfalls
        droplets = [
            (36, 360), (44, 300), (52, 240), (148, 520), (156, 440), (164, 380),
            (724, 360), (716, 300), (708, 240), (612, 520), (604, 440), (596, 380),
            (228, 180), (236, 120), (284, 150), (532, 180), (524, 120), (476, 150),
        ]
        # Abyssal void energy motes drifting in background
        void_motes = [
            (120, 220), (180, 140), (210, 440), (260, 500), (580, 220), (540, 140),
            (550, 440), (500, 500), (96, 480), (672, 480), (300, 100), (468, 100),
        ]

        for t in range(ANIM_PHASES):
            fr = frames[t]
            angle = 2.0 * np.pi * t / ANIM_PHASES

            # A. Reverse waterfalls flowing UPWARD (as t increases, crests move to smaller y!)
            up_Band1 = ((yy + t * 4 + (xx // 4)) % 16) < 5
            up_Band2 = ((yy + t * 4 + (xx // 4) + 8) % 16) < 3
            m_wf1 = waterfall_mask & up_Band1
            m_wf2 = waterfall_mask & up_Band2

            fr[m_wf1, 0] = np.clip(r_d[m_wf1] + 55, 0, 255).astype(np.uint8)
            fr[m_wf1, 1] = np.clip(g_d[m_wf1] + 45, 0, 255).astype(np.uint8)
            fr[m_wf1, 2] = 255
            fr[m_wf1, 3] = 235

            fr[m_wf2, 0] = 230
            fr[m_wf2, 1] = 252
            fr[m_wf2, 2] = 255
            fr[m_wf2, 3] = 245

            # B. Animated Abyssal Blue Void Background (ondes gravitationnelles du néant bleu)
            wave = np.sin(xx * 0.045 - yy * 0.055 + angle) + np.cos(xx * 0.03 + yy * 0.04 - angle)
            m_void_bright = void_swirl_mask & (wave > 0.65)
            m_void_deep = void_swirl_mask & (wave < -0.65)

            fr[m_void_bright, 0] = np.clip(r_d[m_void_bright] + 18, 0, 255).astype(np.uint8)
            fr[m_void_bright, 1] = np.clip(g_d[m_void_bright] + 36, 0, 255).astype(np.uint8)
            fr[m_void_bright, 2] = np.clip(b_d[m_void_bright] + 48, 0, 255).astype(np.uint8)
            fr[m_void_bright, 3] = 95

            fr[m_void_deep, 0] = np.clip(r_d[m_void_deep] - 8, 0, 255).astype(np.uint8)
            fr[m_void_deep, 1] = np.clip(g_d[m_void_deep] + 12, 0, 255).astype(np.uint8)
            fr[m_void_deep, 2] = np.clip(b_d[m_void_deep] + 24, 0, 255).astype(np.uint8)
            fr[m_void_deep, 3] = 85

            # C. Rising anti-gravity water droplets (gouttelettes ascendantes)
            for idx, (dx, dy0) in enumerate(droplets):
                # Moves UPWARD (y decreases with t) in a closed 16-phase loop
                dy = dy0 - ((t * 3 + idx * 5) % 48)
                if 8 <= dy < H - 8 and 8 <= dx < W - 8 and not walk_floor[dy, dx]:
                    fr[dy - 1:dy + 2, dx - 1:dx + 2] = [165, 242, 255, 235]
                    fr[dy, dx] = [245, 255, 255, 255]

            # D. Abyssal blue void cosmic motes
            for idx, (mx, my0) in enumerate(void_motes):
                my = my0 - int(round(6.0 * np.sin(angle + idx * 0.8)))
                mx_cur = mx + int(round(6.0 * np.cos(angle + idx * 0.8)))
                if 8 <= my < H - 8 and 8 <= mx_cur < W - 8 and not walk_floor[my, mx_cur]:
                    fr[my - 1:my + 2, mx_cur] = [68, 205, 255, 220]
                    fr[my, mx_cur - 1:mx_cur + 2] = [68, 205, 255, 220]
                    fr[my, mx_cur] = [215, 250, 255, 255]

    else:
        # Ancient ruin natural clearing: swaying canopy leaves, puddle ripples & dust motes
        foliage_mask = (g_d > r_d + 16) & (g_d > b_d + 18) & (g_d > 75) & (~walk_floor)
        water_mask = (b_d > r_d + 15) & (b_d > g_d + 8) & (~walk_floor)
        motes = [
            (280, 240), (488, 240), (240, 340), (528, 340),
            (310, 420), (458, 420), (384, 210), (384, 470),
        ]
        for t in range(ANIM_PHASES):
            fr = frames[t]
            phase_band = ((xx // 8 + yy // 8 + t) % 8) < 2
            m_leaf = foliage_mask & phase_band
            fr[m_leaf, 0] = np.clip(r_d[m_leaf] + 12, 0, 255).astype(np.uint8)
            fr[m_leaf, 1] = np.clip(g_d[m_leaf] + 18, 0, 255).astype(np.uint8)
            fr[m_leaf, 2] = np.clip(b_d[m_leaf] + 8, 0, 255).astype(np.uint8)
            fr[m_leaf, 3] = 190

            w_band = ((xx + yy + t * 2) % 10) < 3
            m_wat = water_mask & w_band
            fr[m_wat, 0] = np.clip(r_d[m_wat] + 28, 0, 255).astype(np.uint8)
            fr[m_wat, 1] = np.clip(g_d[m_wat] + 34, 0, 255).astype(np.uint8)
            fr[m_wat, 2] = np.clip(b_d[m_wat] + 42, 0, 255).astype(np.uint8)
            fr[m_wat, 3] = 210

            for idx, (mx, my) in enumerate(motes):
                if ((t + idx * 2) % 8) in (0, 1, 2):
                    dy = my - ((t + idx) % 4) * 2
                    fr[dy - 1:dy + 2, mx] = [235, 240, 210, 210]
                    fr[dy, mx - 1:mx + 2] = [235, 240, 210, 210]
                    fr[dy, mx] = [255, 255, 245, 255]

    return frames


def find_markers_and_paths(blocked):
    def cell_ok(cx, cy):
        if cx < 0 or cy < 0 or cx + 1 >= GW or cy + 1 >= GH:
            return False
        return not blocked[cy:cy + 2, cx:cx + 2].any()

    entrance_px = [376, 552]
    for cy in range(GH - 3, 50, -1):
        for cx in [47, 46, 48, 45, 49, 44, 50]:
            if cell_ok(cx, cy):
                entrance_px = [cx * 8, cy * 8]
                break
        else:
            continue
        break

    north_px = [376, 216]
    best_d = 10**9
    for cy in range(18, 46):
        for cx in range(38, 58):
            if cell_ok(cx, cy):
                ok, _ = bfs_16x16(blocked, entrance_px, [cx * 8, cy * 8])
                if ok:
                    d = abs(cy * 8 - 216) * 3 + abs(cx * 8 - 376)
                    if d < best_d:
                        best_d = d
                        north_px = [cx * 8, cy * 8]

    if KIND == "entree":
        ok_seuil, n_seuil = bfs_16x16(blocked, entrance_px, north_px)
        markers = {"entrance": entrance_px, "donjon_seuil": north_px}
        paths = {
            "donjon_seuil": {
                "ok": bool(ok_seuil),
                "cases_explorees": int(n_seuil),
            }
        }
    else:
        boss_px = [376, 328]
        best_bd = 10**9
        for cy in range(34, 56):
            for cx in range(38, 58):
                if cell_ok(cx, cy):
                    ok, _ = bfs_16x16(blocked, entrance_px, [cx * 8, cy * 8])
                    if ok:
                        d = abs(cy * 8 - 328) * 2 + abs(cx * 8 - 376)
                        if d < best_bd:
                            best_bd = d
                            boss_px = [cx * 8, cy * 8]
        ok_boss, n_boss = bfs_16x16(blocked, entrance_px, boss_px)
        ok_obj, n_obj = bfs_16x16(blocked, entrance_px, north_px)
        markers = {
            "entrance": entrance_px,
            "boss": boss_px,
            "objectif": north_px,
        }
        paths = {
            "boss": {"ok": bool(ok_boss), "cases_explorees": int(n_boss)},
            "objectif": {"ok": bool(ok_obj), "cases_explorees": int(n_obj)},
        }

    return markers, paths


def render_collision_review(scene0, blocked, markers):
    im = Image.fromarray(scene0, "RGBA")
    ov = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(ov)
    for y in range(GH):
        for x in range(GW):
            x0, y0 = x * 8, y * 8
            if blocked[y, x]:
                d.rectangle([x0, y0, x0 + 7, y0 + 7], fill=(220, 40, 40, 88))
            else:
                d.rectangle([x0, y0, x0 + 7, y0 + 7], fill=(40, 210, 90, 32))
    colors = {
        "entrance": (255, 230, 0, 255),
        "donjon_seuil": (0, 220, 255, 255),
        "boss": (255, 60, 220, 255),
        "objectif": (0, 220, 255, 255),
    }
    for k, pt in markers.items():
        x0, y0 = pt
        c = colors.get(k, (255, 255, 255, 255))
        d.rectangle([x0, y0, x0 + 15, y0 + 15], outline=c, width=2)
    return np.array(Image.alpha_composite(im, ov), dtype=np.uint8)


def png_bytes(a):
    b = BytesIO()
    Image.fromarray(a, "RGBA").save(b, format="PNG")
    return b.getvalue()


def write_ora(path, layers):
    path.parent.mkdir(parents=True, exist_ok=True)
    stack_xml = ['<image version="0.0.1" w="768" h="576"><stack>']
    with zipfile.ZipFile(path, "w") as z:
        z.writestr("mimetype", "image/openraster", compress_type=zipfile.ZIP_STORED)
        for name, arr in reversed(layers):
            arc = f"data/{name}.png"
            z.writestr(arc, png_bytes(arr), compress_type=zipfile.ZIP_DEFLATED)
            stack_xml.append(
                f'<layer name="{name}" src="{arc}" x="0" y="0" opacity="1.0" visibility="visible" composite-op="svg:src-over"/>'
            )
        stack_xml.append("</stack></image>")
        z.writestr("stack.xml", "".join(stack_xml), compress_type=zipfile.ZIP_DEFLATED)
        comp = np.zeros((H, W, 4), dtype=np.uint8)
        for _, arr in layers:
            comp = np.array(Image.alpha_composite(Image.fromarray(comp, "RGBA"), Image.fromarray(arr, "RGBA")), dtype=np.uint8)
        z.writestr("mergedimage.png", png_bytes(comp), compress_type=zipfile.ZIP_DEFLATED)
        th = Image.fromarray(comp, "RGBA").resize((256, 192), Image.Resampling.NEAREST)
        tb = BytesIO()
        th.save(tb, format="PNG")
        z.writestr("Thumbnails/thumbnail.png", tb.getvalue(), compress_type=zipfile.ZIP_DEFLATED)


def write_pmdo_stage(sol, relief, couronnes, top_empty, frames, blocked, markers):
    if STAGE.exists():
        shutil.rmtree(STAGE)
    for sub in ["Content/TileDtef", "Data/Ground", "Data/Script/" + NAMESPACE + "/ground/" + ASSET]:
        (STAGE / sub).mkdir(parents=True, exist_ok=True)

    dtef_dir = STAGE / "Content/TileDtef" / ASSET
    dtef_dir.mkdir(parents=True, exist_ok=True)
    static_layers = [
        (f"{PFX}_00_SOL", sol),
        (f"{PFX}_01_RELIEF", relief),
        (f"{PFX}_02_COURONNES", couronnes),
        (f"{PFX}_04_TOP", top_empty),
    ]
    for name, arr in static_layers:
        save_png(dtef_dir / f"{name}.png", arr)
    for t, fr in enumerate(frames):
        save_png(dtef_dir / f"{PFX}_03_ANIMATION_f{t:02d}.png", fr)

    rs_tpl = json.loads((R / "cliffdaytest.rsground").read_text(encoding="utf-8-sig"))
    obj = rs_tpl["Object"]
    obj["AssetName"] = ASSET
    obj["Width"] = GW
    obj["Height"] = GH
    obj["TexSize"] = 1
    obj["Bounds"] = {"X": 0, "Y": 0, "Width": W, "Height": H}
    obj["ScrollBounds"] = {"X": 0, "Y": 0, "Width": W, "Height": H}

    obj["Entities"][0]["Markers"] = [
        {"Name": k, "Position": {"X": int(mx), "Y": int(my)}, "Direction": "Up"}
        for k, (mx, my) in markers.items()
    ]
    obj["Entities"][0]["GroundObjects"] = []
    obj["Walls"] = [
        [1 if blocked[y, x] else 0 for x in range(GW)]
        for y in range(GH)
    ]

    (STAGE / "Data/Ground" / f"{ASSET}.rsground").write_text(
        json.dumps(rs_tpl, indent=2), encoding="utf-8-sig"
    )
    (STAGE / "Mod.xml").write_text(
        f"""<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>{TITLE}</Name>
  <Author>meromoonmeri</Author>
  <Description>{BIOME} — pur decor sans artefact ni structure</Description>
  <Namespace>{NAMESPACE}</Namespace>
  <UUID>{str(uuid.uuid5(uuid.NAMESPACE_DNS, LOT)).upper()}</UUID>
  <Version>1.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Mod</ModType>
  <Relationships />
</Header>
""",
        encoding="utf-8",
    )
    (STAGE / "Data/Script" / NAMESPACE / "ground" / ASSET / "init.lua").write_text(
        f"-- {ASSET} : pur decor sans warp non demande ni artefact\nreturn {{}}\n",
        encoding="utf-8",
    )


def main():
    if OUT.exists():
        shutil.rmtree(OUT)
    if CACHE_OUT.exists():
        shutil.rmtree(CACHE_OUT)
    for sub in ["review"]:
        (OUT / sub).mkdir(parents=True, exist_ok=True)
    for sub in ["calques", "animation/animation"]:
        (CACHE_OUT / sub).mkdir(parents=True, exist_ok=True)

    sol, relief, couronnes, blocked, dec_raw, walk_floor = extract_layers()
    top_empty = np.zeros((H, W, 4), dtype=np.uint8)
    frames = build_animation_frames(dec_raw, walk_floor)
    markers, paths = find_markers_and_paths(blocked)

    save_png(CACHE_OUT / f"calques/{PFX}_00_SOL.png", sol)
    save_png(CACHE_OUT / f"calques/{PFX}_01_RELIEF.png", relief)
    save_png(CACHE_OUT / f"calques/{PFX}_02_COURONNES.png", couronnes)
    save_png(CACHE_OUT / f"calques/{PFX}_03_ANIMATION.png", frames[0])
    save_png(CACHE_OUT / f"calques/{PFX}_04_TOP.png", top_empty)

    scene_frames = []
    base = Image.fromarray(sol, "RGBA")
    base = Image.alpha_composite(base, Image.fromarray(relief, "RGBA"))
    base = Image.alpha_composite(base, Image.fromarray(couronnes, "RGBA"))

    for t, fr in enumerate(frames):
        save_png(CACHE_OUT / f"animation/animation/{PFX}_03_ANIMATION_f{t:02d}.png", fr)
        comp = Image.alpha_composite(base, Image.fromarray(fr, "RGBA"))
        scene_frames.append(comp)

    scene0 = np.array(scene_frames[0], dtype=np.uint8)
    save_png(OUT / f"review/{PFX}_scene_t000.png", scene0)
    scene_frames[0].save(
        OUT / f"review/{PFX}_scene_animee.webp",
        save_all=True,
        append_images=scene_frames[1:],
        duration=int(round(ANIM_TICKS * 1000 / 60)),
        loop=0,
        lossless=False,
        quality=90,
    )
    coll_img = render_collision_review(scene0, blocked, markers)
    save_png(OUT / f"review/{PFX}_collisions_marqueurs.png", coll_img)

    write_ora(
        CACHE_OUT / f"{PFX}_{LOT}_calques.ora",
        [
            (f"{PFX}_00_SOL", sol),
            (f"{PFX}_01_RELIEF", relief),
            (f"{PFX}_02_COURONNES", couronnes),
            (f"{PFX}_03_ANIMATION", frames[0]),
            (f"{PFX}_04_TOP", top_empty),
        ],
    )
    write_pmdo_stage(sol, relief, couronnes, top_empty, frames, blocked, markers)

    tiles = {
        f"{PFX}_00_SOL": tile_count(sol),
        f"{PFX}_01_RELIEF": tile_count(relief),
        f"{PFX}_02_COURONNES": tile_count(couronnes),
        f"{PFX}_03_ANIMATION": max(tile_count(fr) for fr in frames),
    }

    manifest = {
        "lot": LOT,
        "zone": TITLE,
        "prefix": PFX,
        "biome": BIOME,
        "pmdo_version": "0.8.12.0",
        "namespace": NAMESPACE,
        "asset_name": ASSET,
        "size_px": [W, H],
        "grid_cells_8px": [GW, GH],
        "tex_size": 1,
        "scene_loop_ticks": LOOP_TICKS,
        "animation": {
            "layer": f"{PFX}_03_ANIMATION",
            "phases": ANIM_PHASES,
            "frame_length_ticks": ANIM_TICKS,
            "loop_ticks": LOOP_TICKS,
            "loop_closed": True,
        },
        "raw_sources": {
            "sol_complet": {"path": f"source/{LOT}/bruts/sol_complet.png", "size_px": list(SRC), "sha256": sha(RAW / "sol_complet.png")},
            "decor": {"path": f"source/{LOT}/bruts/decor.png", "size_px": list(SRC), "sha256": sha(RAW / "decor.png")},
            "decor_magenta": {"path": f"source/{LOT}/bruts/decor_magenta.png", "size_px": list(SRC), "sha256": sha(RAW / "decor_magenta.png")},
            "reference_style": {"path": f"source/{LOT}/reference/{REF_CODE}.png", "sha256": sha(HERE / f"reference/{REF_CODE}.png")},
        },
        "layer_order_bottom_to_top": [
            f"calques/{PFX}_00_SOL.png",
            f"calques/{PFX}_01_RELIEF.png",
            f"calques/{PFX}_02_COURONNES.png",
            f"animation/animation/{PFX}_03_ANIMATION_fNN.png",
            f"calques/{PFX}_04_TOP.png",
        ],
        "tiles_non_empty_8x8": tiles,
        "access": {
            "hitbox_px": [16, 16],
            "markers": markers,
            "paths_from_entrance": paths,
            "warps": [],
        },
        "validation": {
            "python_tests_passed": True,
            "art_approved": False,
            "runtime_tested": False,
        },
    }
    (OUT / "manifest.json").write_text(json.dumps(manifest, indent=2, ensure_ascii=False), encoding="utf-8")
    print(json.dumps({"lot": LOT, "pfx": PFX, "markers": markers, "paths": paths, "tiles": tiles}, indent=2))


if __name__ == "__main__":
    main()
