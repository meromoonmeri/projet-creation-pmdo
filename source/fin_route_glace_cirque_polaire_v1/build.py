"""Build script for Fin Route de Glace - Cirque Polaire (4:3) (FRG1) — 4:3 (768 x 576, 96 x 72 cells of 8 px).
Pur décor naturel/architectural sans artefact ni objet rapporté.

.venv/bin/python source/fin_route_glace_cirque_polaire_v1/build.py
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
LOT = "fin_route_glace_cirque_polaire_v1"
OUT = R / "renders" / LOT
NAMESPACE = "fin_route_glace_cirque_polaire"
STAGE = R / ".cache" / LOT / NAMESPACE
ASSET = "frg1_fin_route_glace_cirque_polaire"
PFX = "FRG1"
REF_CODE = "iceroadpmdsky"
KIND = "fin"
TITLE = "Fin Route de Glace - Cirque Polaire (4:3)"
BIOME = "Cirque Polaire de Glace (ref. pmdskyicearena / iceroadpmdsky)"

W, H = 768, 576
GW, GH = W // 8, H // 8
SRC = (1200, 896)
ANIM_PHASES = 16
ANIM_TICKS = 5
LOOP_TICKS = ANIM_PHASES * ANIM_TICKS


def loadmod(name, path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


def sha(p):
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def load_rgb(p, size=(W, H)):
    im = Image.open(p).convert("RGB")
    if im.size != size:
        im = im.resize(size, Image.Resampling.NEAREST)
    return np.array(im, dtype=np.uint8)


def write_ora(path, layers_dict):
    with zipfile.ZipFile(path, "w", zipfile.ZIP_DEFLATED) as z:
        z.writestr("mimetype", "image/openraster", compress_type=zipfile.ZIP_STORED)
        stack_xml = [f'<image version="0.0.3" w="{W}" h="{H}"><stack>']
        merged = Image.new("RGBA", (W, H), (0, 0, 0, 0))
        items = list(layers_dict.items())
        for name, arr in items:
            merged.alpha_composite(Image.fromarray(arr))
        for idx, (name, arr) in enumerate(reversed(items)):
            fn = f"data/{idx:02d}_{name}.png"
            buf = BytesIO()
            Image.fromarray(arr).save(buf, format="PNG")
            z.writestr(fn, buf.getvalue())
            stack_xml.append(f'<layer name="{name}" src="{fn}" x="0" y="0" opacity="1.0" visibility="visible"/>')
        stack_xml.append("</stack></image>")
        z.writestr("stack.xml", "\n".join(stack_xml))
        b_full, b_thumb = BytesIO(), BytesIO()
        merged.save(b_full, format="PNG")
        merged.resize((256, 192), Image.Resampling.NEAREST).save(b_thumb, format="PNG")
        z.writestr("mergedimage.png", b_full.getvalue())
        z.writestr("Thumbnails/thumbnail.png", b_thumb.getvalue())


def bfs_16x16(blocked, start_xy, goal_xy):
    sx, sy = start_xy[0] // 8, start_xy[1] // 8
    gx, gy = goal_xy[0] // 8, goal_xy[1] // 8

    def can_stand(cx, cy):
        if cx < 0 or cy < 0 or cx + 1 >= GW or cy + 1 >= GH:
            return False
        return not blocked[cy:cy+2, cx:cx+2].any()

    if not can_stand(sx, sy) or not can_stand(gx, gy):
        return False, 0
    vis = {(sx, sy)}
    q = deque([(sx, sy)])
    while q:
        cx, cy = q.popleft()
        if (cx, cy) == (gx, gy):
            return True, len(vis)
        for dx, dy in ((0, -1), (0, 1), (-1, 0), (1, 0)):
            nx, ny = cx + dx, cy + dy
            if (nx, ny) not in vis and can_stand(nx, ny):
                vis.add((nx, ny))
                q.append((nx, ny))
    return False, len(vis)


def make_layers_and_anim():
    decor = load_rgb(RAW / "decor.png")
    mag_im = load_rgb(RAW / "decor_magenta.png")
    sol_base = load_rgb(RAW / "sol_complet.png")

    r_m, g_m, b_m = mag_im[:,:,0].astype(int), mag_im[:,:,1].astype(int), mag_im[:,:,2].astype(int)
    r_d, g_d, b_d = decor[:,:,0].astype(float), decor[:,:,1].astype(float), decor[:,:,2].astype(float)
    is_mag = (r_m > 195) & (b_m > 195) & (g_m < 95) & (np.abs(r_m - b_m) < 55)
    walk_floor = nd.binary_erosion(is_mag, iterations=1)
    yy, xx = np.mgrid[:H, :W]

    if LOT == "fin_apple_woods_clairiere_pommier_v1":
        # Use the clean sandy clearing directly from decor.png so no phantom boulders from decor_magenta appear
        sand_clean = (r_d > 190) & (g_d > 140) & (b_d < 140) & (r_d - b_d > 65) & (yy >= 145)
        walk_floor = walk_floor | sand_clean
        detail_mask = (r_d > 165) & (g_d < 95) & (r_d - g_d > 75) & (~walk_floor)  # red apples in the trees
    elif LOT == "entree_apple_woods_sud_nord_v1":
        detail_mask = ((r_d > 165) & (g_d < 95) & (r_d - g_d > 75) & (~walk_floor)) | (
            (yy >= 68) & (yy <= 176) & (xx >= 300) & (xx <= 468) & (~walk_floor)
        )
    elif LOT == "entree_route_glace_sud_nord_v1":
        # Restrict walkable floor to the central clearing and south-to-north pass
        central_ice = ((yy >= 136) & (yy <= 430) & (xx >= 216) & (xx <= 552)) | ((yy >= 400) & (xx >= 320) & (xx <= 448))
        walk_floor = walk_floor & central_ice
        # Couronnes/parois hautes: northern cavern arch and upper mountain horizon
        detail_mask = (yy < 168) & (~walk_floor)
    elif LOT == "fin_route_glace_cirque_polaire_v1":
        detail_mask = (yy < 168) & (~walk_floor)
    elif LOT == "entree_ruine_legendaire_sud_nord_v1":
        # Use clean stone slab courtyard from decor.png
        stone_clean = (np.abs(r_d - g_d) < 18) & (np.abs(g_d - b_d) < 18) & (r_d > 118) & (yy >= 236) & (yy <= 380) & (xx >= 140) & (xx <= 628)
        walk_floor = walk_floor | stone_clean
        detail_mask = (yy >= 16) & (yy <= 180) & (xx >= 256) & (xx <= 512) & (~walk_floor)
    elif LOT == "fin_ruine_legendaire_sanctuaire_v1":
        # Include the flat engraved central Star Seal disc in walkable floor (00_sol)
        star_disc = ((xx - 384)**2 + (yy - 288)**2 <= 76**2)
        walk_floor = walk_floor | star_disc
        detail_mask = (yy < 156) & (~walk_floor)

    lab, _ = nd.label(walk_floor)
    bot_labs = [v for v in np.unique(lab[H-8:, :]) if v != 0]
    walk_zone = np.isin(lab, bot_labs)
    walk_zone = nd.binary_fill_holes(walk_zone)

    # 00_sol: full 768x576 opaque floor
    sol_rgb = sol_base.copy()
    sol_rgb[walk_zone] = decor[walk_zone]
    sol_rgba = np.dstack([sol_rgb, np.full((H, W), 255, dtype=np.uint8)])

    # 01_relief and 02_couronnes (pure architectural/natural decor layers, zero artifacts)
    detail_mask = detail_mask & (~walk_zone)
    relief_mask = (~walk_zone) & (~detail_mask)

    relief_rgba = np.zeros((H, W, 4), dtype=np.uint8)
    relief_rgba[relief_mask, :3] = decor[relief_mask]
    relief_rgba[relief_mask, 3] = 255

    couronnes_rgba = np.zeros((H, W, 4), dtype=np.uint8)
    couronnes_rgba[detail_mask, :3] = decor[detail_mask]
    couronnes_rgba[detail_mask, 3] = 255

    # 03_animation: 16-phase closed-loop natural/architectural animation
    anim_frames = []
    rng = np.random.default_rng(42)

    if "apple_woods" in LOT:
        hq = loadmod("hq", R / "source/zone_zero_v2/haute_qualite.py")
        apples = (r_d > 165) & (g_d < 95) & (r_d - g_d > 75) & (~walk_zone)
        flowers = (r_d > 145) & (b_d > 135) & (g_d < 145) & (~walk_zone)
        sun_Highlights = (g_d > 195) & (r_d > 135) & (b_d < 100) & (~walk_zone)
        active = apples | flowers | sun_Highlights

        # 6 closed-loop butterflies flying over the Apple Woods clearing
        bf_list = []
        for i in range(6):
            wing = hq.WINGS[i % len(hq.WINGS)]
            dark = tuple(max(0, v - 70) for v in wing)
            spr_o, spr_c = hq.butterfly_sprites(wing, dark)
            cx = int(rng.integers(240, 528))
            cy = int(rng.integers(190, 440))
            rx = int(rng.integers(14, 28))
            ry = int(rng.integers(10, 22))
            bf_list.append((cx, cy, rx, ry, i * 2.0 * np.pi / 6.0, spr_o, spr_c))

        for f in range(ANIM_PHASES):
            fr = np.zeros((H, W, 4), dtype=np.uint8)
            theta = 2.0 * np.pi * f / ANIM_PHASES
            wave = np.sin(theta + xx * 0.15 + yy * 0.12)[active]
            fr[active, 0] = np.clip(r_d[active] + wave * 20.0, 0, 255).astype(np.uint8)
            fr[active, 1] = np.clip(g_d[active] + wave * 18.0, 0, 255).astype(np.uint8)
            fr[active, 2] = np.clip(b_d[active] + wave * 14.0, 0, 255).astype(np.uint8)
            fr[active, 3] = 255
            for cx, cy, rx, ry, phi0, spr_o, spr_c in bf_list:
                bx = int(round(cx + rx * np.cos(theta + phi0)))
                by = int(round(cy + ry * np.sin(2.0 * (theta + phi0))))
                spr = spr_o if (f % 2 == 0) else spr_c
                hq.paste(fr, spr, by, bx)
            anim_frames.append(fr)

    elif "glace" in LOT:
        # Crystalline facets on stalagmites + sub-surface frost shimmer + 24 twinkling frost stars
        ice_facets = (b_d > 215) & (g_d > 195) & (r_d > 175) & (~walk_zone) & (yy >= 80)
        floor_frost = walk_zone & ((xx + yy) % 19 == 0)
        active = ice_facets | floor_frost
        fy, fx = np.nonzero(ice_facets)
        idx_pick = np.linspace(0, len(fy) - 1, 28, dtype=int)
        star_pts = [(int(fy[i]), int(fx[i]), int(k % ANIM_PHASES)) for k, i in enumerate(idx_pick)]

        for f in range(ANIM_PHASES):
            fr = np.zeros((H, W, 4), dtype=np.uint8)
            theta = 2.0 * np.pi * f / ANIM_PHASES
            wave = np.sin(theta + xx * 0.12 - yy * 0.14)[active]
            fr[active, 0] = np.clip(r_d[active] + wave * 18.0, 0, 255).astype(np.uint8)
            fr[active, 1] = np.clip(g_d[active] + wave * 20.0, 0, 255).astype(np.uint8)
            fr[active, 2] = np.clip(b_d[active] + wave * 16.0, 0, 255).astype(np.uint8)
            fr[active, 3] = 255
            for sy, sx, off in star_pts:
                phase = (f - off) % ANIM_PHASES
                arm = {0: 1, 1: 2, 2: 3, 3: 2, 4: 1}.get(phase, 0)
                if arm > 0 and 4 <= sy < H - 4 and 4 <= sx < W - 4:
                    fr[sy, sx] = (255, 255, 255, 255)
                    for d in range(1, arm + 1):
                        col = (220, 245, 255, 255) if d == 1 else (165, 215, 250, 255)
                        for dy, dx in ((-d, 0), (d, 0), (0, -d), (0, d)):
                            fr[sy + dy, sx + dx] = col
            anim_frames.append(fr)

    elif "ruine_legendaire" in LOT:
        # Star Seal wave (in FRL1) + sunlit foliage breeze on outer forest + ancient stone starlight sparkles
        foliage = (g_d > r_d + 25) & (g_d > 110) & (~walk_zone)
        star_ring = ((xx - 384)**2 + (yy - 288)**2 <= 74**2) & (b_d > r_d + 15) if KIND == "fin" else np.zeros((H, W), bool)
        active = foliage | star_ring
        # Stone colonnade sparkle points
        stone_hi = (r_d > 165) & (np.abs(r_d - g_d) < 15) & (~walk_zone) & (yy >= 40) & (yy <= 520)
        sy_all, sx_all = np.nonzero(stone_hi)
        idx_pick = np.linspace(0, len(sy_all) - 1, 24, dtype=int)
        star_pts = [(int(sy_all[i]), int(sx_all[i]), int(k % ANIM_PHASES)) for k, i in enumerate(idx_pick)]

        for f in range(ANIM_PHASES):
            fr = np.zeros((H, W, 4), dtype=np.uint8)
            theta = 2.0 * np.pi * f / ANIM_PHASES
            if foliage.any():
                fw = np.sin(theta + xx * 0.16 + yy * 0.14)[foliage]
                fr[foliage, 0] = np.clip(r_d[foliage] + fw * 16.0, 0, 255).astype(np.uint8)
                fr[foliage, 1] = np.clip(g_d[foliage] + fw * 20.0, 0, 255).astype(np.uint8)
                fr[foliage, 2] = np.clip(b_d[foliage] + fw * 12.0, 0, 255).astype(np.uint8)
                fr[foliage, 3] = 255
            if star_ring.any():
                rad = np.sqrt((xx - 384.0)**2 + (yy - 288.0)**2)
                sw = np.sin(theta - rad * 0.11)[star_ring]
                fr[star_ring, 0] = np.clip(r_d[star_ring] + sw * 24.0, 0, 255).astype(np.uint8)
                fr[star_ring, 1] = np.clip(g_d[star_ring] + sw * 26.0, 0, 255).astype(np.uint8)
                fr[star_ring, 2] = np.clip(b_d[star_ring] + sw * 28.0, 0, 255).astype(np.uint8)
                fr[star_ring, 3] = 255
            for sy, sx, off in star_pts:
                phase = (f - off) % ANIM_PHASES
                arm = {0: 1, 1: 2, 2: 2, 3: 1}.get(phase, 0)
                if arm > 0 and 4 <= sy < H - 4 and 4 <= sx < W - 4:
                    fr[sy, sx] = (250, 248, 220, 255)
                    for d in range(1, arm + 1):
                        for dy, dx in ((-d, 0), (d, 0), (0, -d), (0, d)):
                            fr[sy + dy, sx + dx] = (210, 225, 245, 255)
            anim_frames.append(fr)

    return {
        "sol": sol_rgba,
        "relief": relief_rgba,
        "couronnes": couronnes_rgba,
        "anim": anim_frames,
        "walk_zone": walk_zone,
        "relief_mask": relief_mask,
        "couronnes_mask": detail_mask,
    }


def compute_grid_and_markers(walk_zone):
    cell_walk = walk_zone.reshape(GH, 8, GW, 8).mean(axis=(1, 3)) >= 0.75
    blocked = ~cell_walk

    def snap_free(px, py):
        gx0, gy0 = px // 8, py // 8
        for rad in range(0, 25):
            for dy in sorted(range(-rad, rad + 1), key=abs):
                for dx in sorted(range(-rad, rad + 1), key=abs):
                    gx, gy = gx0 + dx, gy0 + dy
                    if 0 <= gx < GW - 1 and 0 <= gy < GH - 1:
                        if not blocked[gy:gy+2, gx:gx+2].any():
                            return [gx * 8, gy * 8]
        raise RuntimeError(f"No free 16x16 spot near ({px}, {py})")

    ys_w = np.where(walk_zone[:, 360:408].any(axis=1))[0]
    y_top_walk = int(ys_w.min()) + 16
    entrance = snap_free(376, H - 24)
    if KIND == "entree":
        seuil = snap_free(376, y_top_walk)
        markers = {"entrance": entrance, "donjon_seuil": seuil}
    else:
        boss = snap_free(376, (y_top_walk + H - 80) // 2)
        objectif = snap_free(376, y_top_walk)
        markers = {"entrance": entrance, "boss": boss, "objectif": objectif}

    paths = {}
    for k, pos in markers.items():
        if k == "entrance":
            continue
        ok, explored = bfs_16x16(blocked, entrance, pos)
        assert ok, f"BFS 16x16 failed from entrance {entrance} to {k} {pos}"
        paths[k] = {"ok": ok, "cases_explorees": explored}

    return blocked, markers, paths


def build_ground_project(stack, blocked, markers, gfx, tools):
    if STAGE.exists():
        shutil.rmtree(STAGE)
    tpl = json.loads((R / "cliffdaytest.rsground").read_text(encoding="utf-8-sig"))
    o = tpl["Object"]
    layers, banks = [], []
    for i, (title, frames, ticks) in enumerate(stack):
        bank = gfx.TileBank(f"{PFX}_{i:02d}_{title.split()[0].upper()}")
        bank.ids[bytes(256)] = (0, 0)
        bank.data[(0, 0)] = bytes(256)

        def cell(x, y, frames=frames, bank=bank):
            fs = []
            for a in frames:
                f = bank.add(Image.fromarray(a[y*8:y*8+8, x*8:x*8+8]), x, y)
                fs.append(f if f else {"Sheet": bank.name, "TexLoc": {"X": 0, "Y": 0}})
            if all(f["TexLoc"] == {"X": 0, "Y": 0} for f in fs):
                return []
            return [fs[0]] if all(f == fs[0] for f in fs) else fs

        layers.append(gfx.layer(f"{i:02d} {title}", GW, GH, cell, ticks))
        banks.append(bank)

    layers.append(gfx.layer(f"{len(layers):02d} Vos elements avant-plan (Top)", GW, GH, draw=4))
    for bank in banks:
        bank.write(STAGE / f"Content/Tile/{bank.name}.tile")

    mk = lambda n, p, d: {
        "EntName": n,
        "Direction": d,
        "EntEnabled": True,
        "triggerType": 0,
        "Collider": {"X": p[0], "Y": p[1], "Width": 16, "Height": 16},
    }
    marker_list = [mk("entrance", markers["entrance"], 0)]
    if KIND == "entree":
        marker_list.append(mk("donjon_seuil", markers["donjon_seuil"], 0))
    else:
        marker_list.append(mk("boss", markers["boss"], 4))
        marker_list.append(mk("objectif", markers["objectif"], 0))

    o.update(
        Name={"DefaultText": TITLE, "LocalTexts": {}},
        AssetName=ASSET,
        Released=False,
        TexSize=1,
        Music="",
        EdgeView=1,
        ViewCenter=None,
        ViewOffset={"X": 0, "Y": 0},
        ActiveChar=None,
        Status={},
        Layers=layers,
        Background={"$type": "RogueEssence.Dungeon.LayeredBG, RogueEssence", "Layers": []},
        Comment=f"PMDO 0.8.12.0 — {TITLE} ({BIOME}). Decor pur sans artefact. Grille 8x8 (96x72). Aucun warp.",
    )
    o["obstacles"] = [
        [{"Bounds": {"X": x*8, "Y": y*8, "Width": 8, "Height": 8}, "Tags": int(blocked[y, x])} for y in range(GH)]
        for x in range(GW)
    ]
    o["Entities"] = [
        {
            "Name": "Entrees et vos acteurs",
            "Visible": True,
            "MapChars": [],
            "GroundObjects": [],
            "Spawners": [],
            "Markers": marker_list,
        }
    ]
    o["Decorations"] = [{"Name": "Vos decorations", "Layer": 2, "Visible": True, "Anims": []}]
    tpl["Version"] = "0.8.12.0"
    gfx.save(STAGE / f"Data/Ground/{ASSET}.rsground", json.dumps(tpl, ensure_ascii=False, separators=(",", ":")).encode("utf-8"))
    gfx.save(
        STAGE / f"Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua",
        f"-- {ASSET} : base d edition, aucun warp.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n".encode("utf-8"),
    )

    nodes = {}
    for p in sorted((STAGE / "Content/Tile").glob("*.tile")):
        with p.open("rb") as f:
            nodes[p.stem] = tools.read_node(f)
    (STAGE / "Content/Tile/index.idx").write_bytes(tools.encode_index(nodes))

    ident = uuid.uuid5(uuid.NAMESPACE_URL, "https://github.com/meromoonmeri/projet-creation-pmdo/" + NAMESPACE)
    (STAGE / "Mod.xml").write_text(
        f"""<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>{TITLE} - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'edition PMDO 0.8.12.0 : {BIOME}. Decor pur sans artefact. Pas une aventure jouable.</Description>
  <Namespace>{NAMESPACE}</Namespace>
  <UUID>{ident}</UUID>
  <Version>1.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
""",
        encoding="utf-8",
    )
    script = (R / "source/pmdo_cote/INSTALLER.py").read_text(encoding="utf-8")
    needle = "            relative = src.relative_to(source)\n"
    if needle in script:
        script = script.replace(needle, needle + "            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n")
    (STAGE / "INSTALLER.py").write_text(script, encoding="utf-8")
    shutil.copyfile(HERE / "README_PACK.md", STAGE / "README.md")
    return {b.name: len(b.data) for b in banks}


def build():
    gfx = loadmod("pmdo_codec", R / "source/pmdo_cote/build.py")
    tools = loadmod("index_tools", R / "source/pmdo_cote/INSTALLER.py")
    if OUT.exists():
        for d in ["calques", "animation", "masques", "review"]:
            shutil.rmtree(OUT / d, ignore_errors=True)
    for d in ["calques", "animation/animation", "masques", "review"]:
        (OUT / d).mkdir(parents=True, exist_ok=True)

    D = make_layers_and_anim()
    blocked, markers, paths = compute_grid_and_markers(D["walk_zone"])

    Image.fromarray((D["walk_zone"] * 255).astype(np.uint8)).save(OUT / "masques" / f"{PFX}_masque_praticable.png")
    Image.fromarray((D["relief_mask"] * 255).astype(np.uint8)).save(OUT / "masques" / f"{PFX}_masque_relief.png")
    Image.fromarray((D["couronnes_mask"] * 255).astype(np.uint8)).save(OUT / "masques" / f"{PFX}_masque_couronnes.png")

    stack_named = [
        ("sol", [D["sol"]], 60),
        ("relief", [D["relief"]], 60),
        ("couronnes", [D["couronnes"]], 60),
        ("animation", D["anim"], ANIM_TICKS),
    ]
    files = {}
    for i, (nm, frames, tk) in enumerate(stack_named):
        if len(frames) == 1:
            fn = f"calques/{PFX}_{i:02d}_{nm}.png"
            Image.fromarray(frames[0]).save(OUT / fn)
        else:
            fn = f"animation/{nm}/{PFX}_{i:02d}_{nm}_fNN.png"
            for t, fr_ in enumerate(frames):
                Image.fromarray(fr_).save(OUT / fn.replace("NN", f"{t:02d}"))
        files[nm] = fn

    scenes = []
    for f in range(ANIM_PHASES):
        im = Image.new("RGBA", (W, H))
        im.alpha_composite(Image.fromarray(D["sol"]))
        im.alpha_composite(Image.fromarray(D["relief"]))
        im.alpha_composite(Image.fromarray(D["couronnes"]))
        im.alpha_composite(Image.fromarray(D["anim"][f]))
        scenes.append(im)

    scenes[0].save(OUT / "review" / f"{PFX}_scene_t000.png")
    scenes[0].save(
        OUT / "review" / f"{PFX}_scene_animee.webp",
        save_all=True,
        append_images=scenes[1:],
        duration=round(ANIM_TICKS * 1000 / 60),
        loop=0,
        lossless=True,
    )

    colim = scenes[0].copy()
    ov = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    dr = ImageDraw.Draw(ov)
    for y, x in zip(*np.nonzero(blocked)):
        dr.rectangle([x*8, y*8, x*8+7, y*8+7], fill=(220, 40, 40, 90))
    colors_mk = {
        "entrance": (255, 230, 40, 255),
        "donjon_seuil": (60, 220, 255, 255),
        "boss": (255, 80, 200, 255),
        "objectif": (60, 220, 255, 255),
    }
    for k, q in markers.items():
        dr.rectangle([q[0], q[1], q[0] + 15, q[1] + 15], outline=colors_mk[k], width=2)
    colim.alpha_composite(ov)
    colim.save(OUT / "review" / f"{PFX}_collisions_marqueurs.png")

    write_ora(
        OUT / f"{PFX}_{LOT}_calques.ora",
        {
            "00_sol": D["sol"],
            "01_relief": D["relief"],
            "02_couronnes": D["couronnes"],
            "03_animation_f00": D["anim"][0],
        },
    )

    counts = build_ground_project(
        [
            ("Sol", [D["sol"]], 60),
            ("Relief", [D["relief"]], 60),
            ("Couronnes", [D["couronnes"]], 60),
            (f"Animation {ANIM_PHASES} phases", D["anim"], ANIM_TICKS),
        ],
        blocked,
        markers,
        gfx,
        tools,
    )

    manifest = {
        "lot": LOT,
        "prefix": PFX,
        "biome": BIOME,
        "kind": KIND,
        "format": "4:3 vaste",
        "size_px": [W, H],
        "grid_8px": [GW, GH],
        "decor_pur_sans_artefact": True,
        "reference_da": [f"source/{LOT}/reference/{REF_CODE}.png"],
        "raw_inputs": [
            {"file": f"source/{LOT}/bruts/sol_complet.png", "sha256": sha(RAW / "sol_complet.png"), "size": list(SRC)},
            {"file": f"source/{LOT}/bruts/decor.png", "sha256": sha(RAW / "decor.png"), "size": list(SRC)},
            {"file": f"source/{LOT}/bruts/decor_magenta.png", "sha256": sha(RAW / "decor_magenta.png"), "size": list(SRC)},
        ],
        "layer_order_bottom_to_top": [files[t] for t, _, _ in stack_named],
        "animation": {
            "phases": ANIM_PHASES,
            "frame_length_ticks": ANIM_TICKS,
            "loop_ticks": LOOP_TICKS,
        },
        "scene_loop_ticks": LOOP_TICKS,
        "access": {
            "markers": markers,
            "chemins_16x16": paths,
            "blocked_cells": int(blocked.sum()),
            "total_cells": int(blocked.size),
        },
        "pmdo": {
            "target": "0.8.12.0",
            "asset": ASSET,
            "namespace": NAMESPACE,
            "tiles_per_bank": counts,
            "banks": list(counts),
            "runtime_tested": False,
            "warp": "aucun",
        },
        "art_approved": False,
    }
    (OUT / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    shutil.copyfile(OUT / "manifest.json", STAGE / "manifest.json")
    print(json.dumps({"lot": LOT, "pfx": PFX, "markers": markers, "paths": paths, "tiles": counts}, indent=2))


if __name__ == "__main__":
    build()
