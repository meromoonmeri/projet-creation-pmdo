"""Utilitaires partagés pour la trilogie Tour Céleste (EST1, MST1, SST1) et sa suite directe FGM1.

Respect strict de METHODE_MAGENTA_ET_GENERATEUR.md et AGENTS.md :
- Extraction des poses sur fond #FF00FF par key() + purge intégrale de toute frange magenta/rose (0 px).
- Segmentation pleine résolution avant réduction non mélangeante down_class + exclusive + quantize_group (dither=NONE).
- Tables matérielles exactes de data/map_bg/D13P01.bpl (Palettes 9 & 10, 8 poses x 8 ticks = 64 ticks).
- Export complet 10 calques RGBA + Top vide (Layer=4) + OpenRaster .ora + .rsground TexSize=1 + .tile + index.idx.
- Aucune mention nominative nulle part.
"""
from __future__ import annotations

import base64
import hashlib
import importlib.util
import io
import json
import re
import shutil
import uuid
import xml.etree.ElementTree as ET
import zipfile
from pathlib import Path

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

R = Path(__file__).resolve().parents[2]


def loadmod(name: str, path: Path):
    sp = importlib.util.spec_from_file_location(name, path)
    m = importlib.util.module_from_spec(sp)
    sp.loader.exec_module(m)
    return m


V1 = loadmod('ewc1_shared_sky', R / 'source/entree_waterfall_cave_sud_nord_v1/build.py')
GFX = loadmod('pmdo_codec_sky', R / 'source/pmdo_cote/build.py')
TOOLS = loadmod('index_tools_sky', R / 'source/pmdo_cote/INSTALLER.py')
ESN = loadmod('esn1_shared_sky', R / 'source/entree_sud_nord_generee_v1/build.py')

keep_large = V1.keep_large
cell_grid = V1.cell_grid
close_ = V1.close_
down_class = V1.down_class
down_full = V1.down_full
rgba = V1.rgba
quantize_group = V1.quantize_group


def sha(p: Path) -> str:
    return hashlib.sha256(Path(p).read_bytes()).hexdigest()


def rgb(p: Path) -> np.ndarray:
    with Image.open(p) as im:
        return np.array(im.convert('RGB')).astype(int)


def lum_of(a: np.ndarray) -> np.ndarray:
    return a[..., :3].astype(float) @ np.array([0.299, 0.587, 0.114])


def dist_rgb(x, y) -> float:
    return round(float(np.linalg.norm(np.asarray(x, float) - np.asarray(y, float))), 2)


def assert_fidelity_below(fidelite_dict: dict[str, dict], limit: float = 35.0) -> None:
    """Garde bloquante de fidélité chromatique au rip (METHODE_MAGENTA_ET_GENERATEUR.md §8)."""
    for mat_name, entry in fidelite_dict.items():
        d = float(entry['distance'] if 'distance' in entry else entry['distance_rip'])
        if not (d < limit):
            raise AssertionError(
                f"Fidélité hors seuil sur '{mat_name}' : distance = {d:.2f} >= {limit:.1f} "
                f"(ref={entry.get('ref_rgb')}, obtenu={entry.get('mean_rgb')})"
            )


def key_and_extract_sky_poses(parts_path: Path) -> tuple[list[np.ndarray], list[np.ndarray]]:
    """Extrait les 4 éclats d'étoile céleste + 4 volutes de brise depuis particules_poses.png.

    - Détourage strict du fond #FF00FF + suppression de tout pixel de frange magenta/violette.
    - Regroupement morphologique sans couper les sprites multi-composantes (pose 03 et pose 07).
    - Réduction non mélangeante à l'échelle pixel-art 1x GBA/DS (grille logique /7) et palette froide pure.
    """
    with Image.open(parts_path) as im:
        pa = np.array(im.convert('RGB')).astype(int)
    r, g, b = pa[..., 0], pa[..., 1], pa[..., 2]
    is_mag = ((r > 155) & (b > 155) & (g < 130)) | ((r - g > 20) & (b - g > 14))
    fg = ~is_mag

    grouped = nd.binary_dilation(fg, iterations=28)
    lab, n = nd.label(grouped)
    raw_items = []
    for i in range(1, n + 1):
        m = (lab == i) & fg
        if int(m.sum()) < 20:
            continue
        ys, xs = np.where(m)
        row = 0 if ys.mean() < pa.shape[0] / 2.0 else 1
        raw_items.append((row, float(xs.mean()), int(xs.min()), int(ys.min()), int(xs.max()) + 1, int(ys.max()) + 1, m))
    raw_items.sort(key=lambda t: (t[0], t[1]))
    assert len(raw_items) == 8, f'Attendu 8 poses sur {parts_path}, trouvé {len(raw_items)}'

    # Palette pixel-art canonique froide (0% magenta/violet possible : R <= G <= B partout)
    cool_pal = np.array([
        [16, 56, 196],
        [36, 96, 248],
        [78, 146, 252],
        [124, 190, 255],
        [168, 224, 255],
        [212, 246, 255],
        [244, 253, 255],
        [255, 255, 255],
    ], dtype=float)

    glints: list[np.ndarray] = []
    breezes: list[np.ndarray] = []
    scale = 7
    for row, _, x0, y0, x1, y1, m in raw_items:
        sub_rgb = pa[y0:y1, x0:x1].astype(float)
        sub_m = m[y0:y1, x0:x1]
        oh = max(6, int(np.ceil(sub_m.shape[0] / scale)))
        ow = max(6, int(np.ceil(sub_m.shape[1] / scale)))
        pad_h = oh * scale - sub_m.shape[0]
        pad_w = ow * scale - sub_m.shape[1]
        pt, pb = pad_h // 2, pad_h - pad_h // 2
        pl, pr = pad_w // 2, pad_w - pad_w // 2
        mp = np.pad(sub_m, ((pt, pb), (pl, pr)), constant_values=False)
        cp = np.pad(sub_rgb, ((pt, pb), (pl, pr), (0, 0)), mode='edge')

        w_block = mp.reshape(oh, scale, ow, scale).mean(axis=(1, 3))
        out_m = w_block >= 0.28
        w_sum = np.maximum(mp.reshape(oh, scale, ow, scale).sum(axis=(1, 3)), 1.0)[..., None]
        weighted = (cp * mp[..., None]).reshape(oh, scale, ow, scale, 3).sum(axis=(1, 3)) / w_sum

        out = np.zeros((oh, ow, 4), dtype=np.uint8)
        if out_m.any():
            pts = weighted[out_m]
            idx = np.argmin(((pts[:, None, :] - cool_pal[None, :, :]) ** 2).sum(-1), axis=1)
            out[out_m, :3] = cool_pal[idx].astype(np.uint8)
            out[out_m, 3] = 255

        # Contour bleu-ciel doux 1 px si la pose est purement blanche afin qu'elle reste lisible partout
        if out_m.any() and float(out[out_m, :3].min()) > 235:
            border = nd.binary_dilation(out_m, iterations=1) & ~out_m
            out[border, :3] = np.array([111, 175, 255], dtype=np.uint8)
            out[border, 3] = 255

        # Recadrage serré + 1 px de marge transparente propre
        ys2, xs2 = np.where(out[..., 3] > 0)
        trimmed = out[ys2.min():ys2.max() + 1, xs2.min():xs2.max() + 1]
        padded = np.zeros((trimmed.shape[0] + 2, trimmed.shape[1] + 2, 4), dtype=np.uint8)
        padded[1:-1, 1:-1] = trimmed
        if row == 0:
            glints.append(padded)
        else:
            breezes.append(padded)

    return glints, breezes


def build_d13p01_bpl_wave_frames(
    bright_layer: np.ndarray,
    bright_mask: np.ndarray,
    deep_layer: np.ndarray,
    deep_mask: np.ndarray,
    bpl_meta: dict,
) -> list[np.ndarray]:
    """Applique les vraies couleurs RVB des Palettes 9 et 10 de D13P01.bpl (8 poses x 8 ticks = 64 ticks)
    le long des bandes organiques de luminance (quantiles continus, 0% damier procédural).
    """
    H, W = bright_mask.shape
    pal9_frames = bpl_meta['palette_9_cloud_plumes']['frames']
    pal10_frames = bpl_meta['palette_10_wind_shadows']['frames']
    assert len(pal9_frames) == len(pal10_frames) == 8

    # Slots cycliques exacts de D13P01.bpl :
    # Palette 9 : slots [11, 12, 13, 14, 6] (du bleu glacier tendre au blanc pur)
    # Palette 10 : slots [11, 12, 13, 14, 1] (du pervenche profond au bleu ciel lumineux)
    slots9 = [11, 12, 13, 14, 6]
    slots10 = [11, 12, 13, 14, 1]

    lum_b = lum_of(bright_layer)
    lum_d = lum_of(deep_layer)

    ranks_b = np.zeros(int(bright_mask.sum()), dtype=int)
    if bright_mask.any():
        vals_b = lum_b[bright_mask]
        q_b = np.quantile(vals_b, [0.20, 0.42, 0.64, 0.84])
        ranks_b = np.searchsorted(q_b, vals_b)

    ranks_d = np.zeros(int(deep_mask.sum()), dtype=int)
    if deep_mask.any():
        vals_d = lum_d[deep_mask]
        q_d = np.quantile(vals_d, [0.22, 0.45, 0.68, 0.86])
        ranks_d = np.searchsorted(q_d, vals_d)

    frames = []
    for t in range(8):
        fr = np.zeros((H, W, 4), dtype=np.uint8)
        if deep_mask.any():
            row10 = np.array([pal10_frames[t][s][:3] for s in slots10], dtype=np.uint8)
            fr[deep_mask, :3] = row10[ranks_d]
            fr[deep_mask, 3] = 255
        if bright_mask.any():
            row9 = np.array([pal9_frames[t][s][:3] for s in slots9], dtype=np.uint8)
            fr[bright_mask, :3] = row9[ranks_b]
            fr[bright_mask, 3] = 255
        frames.append(fr)
    return frames


def build_sky_particles_frames(
    w: int,
    h: int,
    glints: list[np.ndarray],
    breezes: list[np.ndarray],
    glint_spots: list[tuple[int, int]],
    breeze_spots: list[tuple[int, int, int]],
    n_frames: int = 16,
) -> list[np.ndarray]:
    """Anime sur un calque dédié (16 poses x 4 ticks = 64 ticks) les poses détourées :
    - éclats d'étoiles célestes (cycle 0 -> 1 -> 2 -> 1 -> 3 -> repos) ;
    - volutes d'alizé glissant doucement le long des courants (cycle 0 -> 1 -> 2 -> 2 -> 3 -> repos).
    """
    glint_seq = [0, 1, 2, 2, 1, 3, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1]
    breeze_seq = [0, 0, 1, 1, 2, 2, 2, 3, 3, -1, -1, -1, -1, -1, -1, -1]
    frames = []
    for t in range(n_frames):
        canvas = Image.new('RGBA', (w, h), (0, 0, 0, 0))
        for i, (gx, gy) in enumerate(glint_spots):
            ph = (t - (i * 3) % n_frames) % n_frames
            gi = glint_seq[ph]
            if gi >= 0:
                sp = Image.fromarray(glints[gi])
                px = int(np.clip(gx - sp.width // 2, 0, w - sp.width))
                py = int(np.clip(gy - sp.height // 2, 0, h - sp.height))
                canvas.alpha_composite(sp, (px, py))
        for j, (bx, by, dir_x) in enumerate(breeze_spots):
            ph = (t - (j * 5 + 2) % n_frames) % n_frames
            bi = breeze_seq[ph]
            if bi >= 0:
                arr = breezes[bi][:, ::-1] if dir_x < 0 else breezes[bi]
                sp = Image.fromarray(arr)
                drift_x = dir_x * (ph * 2)
                drift_y = -ph
                px = int(np.clip(bx + drift_x - sp.width // 2, 0, w - sp.width))
                py = int(np.clip(by + drift_y - sp.height // 2, 0, h - sp.height))
                canvas.alpha_composite(sp, (px, py))
        frames.append(np.array(canvas))
    return frames


def sample_anchors_from_mask(mask: np.ndarray, count: int, margin: int = 28) -> list[tuple[int, int]]:
    """Sélectionne `count` ancres bien espacées à l'intérieur d'un masque matériau réel."""
    h, w = mask.shape
    inner = mask.copy()
    inner[:margin, :] = False
    inner[-margin:, :] = False
    inner[:, :margin] = False
    inner[:, -margin:] = False
    ys, xs = np.where(inner)
    if len(xs) == 0:
        ys, xs = np.where(mask)
    if len(xs) == 0:
        return []
    step = max(1, len(xs) // 4000)
    pts = list(zip(xs[::step].tolist(), ys[::step].tolist()))
    chosen: list[tuple[int, int]] = [pts[len(pts) // 2]]
    while len(chosen) < count and len(chosen) < len(pts):
        best_pt = max(pts, key=lambda p: min((p[0] - c[0]) ** 2 + (p[1] - c[1]) ** 2 for c in chosen))
        chosen.append((int(best_pt[0]), int(best_pt[1])))
    return chosen


def write_ora(path: Path, layers: dict[str, np.ndarray], w: int, h: int) -> None:
    root = ET.Element('image', version='0.0.5', w=str(w), h=str(h), xres='72', yres='72')
    stack = ET.SubElement(root, 'stack')
    comp = Image.new('RGBA', (w, h))
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED) as z:
        z.writestr('mimetype', 'image/openraster', compress_type=zipfile.ZIP_STORED)
        items = list(layers.items())
        for i, (name, a) in reversed(list(enumerate(items))):
            fn = f'data/layer{i:02d}.png'
            ET.SubElement(stack, 'layer', name=name, src=fn, x='0', y='0', opacity='1.0',
                          visibility='visible', **{'composite-op': 'svg:src-over'})
            b = io.BytesIO()
            Image.fromarray(a).save(b, format='PNG')
            z.writestr(fn, b.getvalue())
        for _, a in items:
            comp.alpha_composite(Image.fromarray(a))
        b = io.BytesIO()
        comp.save(b, format='PNG')
        z.writestr('mergedimage.png', b.getvalue())
        th = comp.copy()
        th.thumbnail((256, 256))
        b = io.BytesIO()
        th.save(b, format='PNG')
        z.writestr('Thumbnails/thumbnail.png', b.getvalue())
        z.writestr('stack.xml', ET.tostring(root, encoding='utf-8', xml_declaration=True))


def find_marker_16x16(blocked: np.ndarray, target_xy_cell: tuple[int, int], y_range: range) -> list[int]:
    tx, ty = target_xy_cell
    best = None
    for y in y_range:
        if y < 0 or y + 2 > blocked.shape[0]:
            continue
        for x in range(2, blocked.shape[1] - 4):
            if not blocked[y:y + 2, x:x + 2].any():
                d = (x - tx) ** 2 + (y - ty) ** 2
                if best is None or d < best[0]:
                    best = (d, x, y)
    assert best is not None, f'Aucune zone 16x16 praticable trouvée près de {target_xy_cell} dans {y_range}'
    return [int(best[1] * 8), int(best[2] * 8)]


def export_ground_project(
    *,
    stage: Path,
    here: Path,
    pfx: str,
    namespace: str,
    asset: str,
    title_en: str,
    title_fr: str,
    description_fr: str,
    comment_fr: str,
    w: int,
    h: int,
    stack_named: list[tuple[str, list[np.ndarray], int]],
    blocked: np.ndarray,
    entry_px: list[int],
    goal_name: str,
    goal_px: list[int],
) -> dict[str, int]:
    """Construit le dossier de mod PMDO 0.8.12 complet (.rsground TexSize=1, .tile, index.idx, Mod.xml, init.lua)."""
    if stage.exists():
        shutil.rmtree(stage)
    tpl = json.loads((R / 'cliffdaytest.rsground').read_text())
    o = tpl['Object']
    gw, gh = w // 8, h // 8
    layers, banks = [], []
    for i, (title, frames, ticks) in enumerate(stack_named):
        slug = re.sub(r'[^A-Z0-9]+', '_', title.upper()).strip('_').split('_')[0]
        bank = GFX.TileBank(f'{pfx}_{i:02d}_{slug}')
        bank.ids[bytes(256)] = (0, 0)
        bank.data[(0, 0)] = bytes(256)

        def cell(x, y, frames=frames, bank=bank):
            fs = []
            for a in frames:
                f = bank.add(Image.fromarray(a[y * 8:y * 8 + 8, x * 8:x * 8 + 8]), x, y)
                fs.append(f if f else {'Sheet': bank.name, 'TexLoc': {'X': 0, 'Y': 0}})
            if all(f['TexLoc'] == {'X': 0, 'Y': 0} for f in fs):
                return []
            return [fs[0]] if all(f == fs[0] for f in fs) else fs

        label = title.replace('_', ' ') + (f' {len(frames)} phases' if len(frames) > 1 else '')
        layers.append(GFX.layer(f'{i:02d} {label}', gw, gh, cell, ticks))
        banks.append(bank)
    layers.append(GFX.layer(f'{len(layers):02d} Vos elements avant-plan (Top)', gw, gh, draw=4))

    for bank in banks:
        bank.write(stage / f'Content/Tile/{bank.name}.tile')

    o.update(
        Name={'DefaultText': title_en, 'LocalTexts': {'fr': title_fr}},
        AssetName=asset,
        Released=False,
        TexSize=1,
        Music='',
        EdgeView=1,
        ViewCenter=None,
        ViewOffset={'X': 0, 'Y': 0},
        ActiveChar=None,
        Status={},
        Layers=layers,
        Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
        Comment=comment_fr,
    )
    o['obstacles'] = [
        [{'Bounds': {'X': x * 8, 'Y': y * 8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
         for y in range(gh)]
        for x in range(gw)
    ]
    mk = lambda n, p: {
        'EntName': n,
        'Direction': 4,
        'EntEnabled': True,
        'triggerType': 0,
        'Collider': {'X': p[0], 'Y': p[1], 'Width': 16, 'Height': 16},
    }
    o['Entities'] = [{
        'Name': 'Entrees et vos acteurs',
        'Visible': True,
        'MapChars': [],
        'GroundObjects': [],
        'Spawners': [],
        'Markers': [mk('entrance', entry_px), mk(goal_name, goal_px)],
    }]
    o['Decorations'] = [{'Name': 'Vos decorations', 'Layer': 2, 'Visible': True, 'Anims': []}]
    tpl['Version'] = '0.8.12.0'

    GFX.save(stage / f'Data/Ground/{asset}.rsground', json.dumps(tpl, ensure_ascii=False, separators=(',', ':')).encode())
    GFX.save(
        stage / f'Data/Script/{namespace}/ground/{asset}/init.lua',
        f'-- {asset} : base d edition, aucun warp.\nlocal {asset} = {{}}\nreturn {asset}\n'.encode(),
    )
    nodes = {}
    for p in sorted((stage / 'Content/Tile').glob('*.tile')):
        with p.open('rb') as f:
            nodes[p.stem] = TOOLS.read_node(f)
    (stage / 'Content/Tile/index.idx').write_bytes(TOOLS.encode_index(nodes))

    ident = uuid.uuid5(uuid.NAMESPACE_OID, 'pmdo-quest-0812:' + namespace)
    (stage / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>{title_en} ({pfx}) - 0.8.12</Name>
  <Author></Author>
  <Description>{description_fr}</Description>
  <Namespace>{namespace}</Namespace>
  <UUID>{ident}</UUID>
  <Version>1.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
''')
    script = (R / 'source/pmdo_cote/INSTALLER.py').read_text()
    needle = '            relative = src.relative_to(source)\n'
    assert needle in script
    script = script.replace(needle, needle + "            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n")
    (stage / 'INSTALLER.py').write_text(script)
    shutil.copyfile(here / 'README_PACK.md', stage / 'README.md')
    return {b.name: len(b.data) for b in banks}


def make_viewer_template(
    *,
    code: str,
    title_short: str,
    subtitle_html: str,
    ref_label: str,
    poses_legend: str,
    status_html: str,
    goal_label: str,
) -> str:
    """Génère le viewer_template.html multicalque 60 i/s autonome (avec navigation entre les 4 scènes + Solo calque)."""
    nav_items = [
        ('index.html', 'Vue d’ensemble (4 scènes)'),
        ('apercu_entree_tour_celeste_sud_nord_v1.html', 'EST1 · Entrée Tour Céleste (D13P01)'),
        ('apercu_relais_tour_celeste_sud_nord_v1.html', 'MST1 · Relais Mi-Tour (D13P02)'),
        ('apercu_sommet_tour_celeste_rayquaza_v1.html', 'SST1 · Sommet Rayquaza (b71)'),
        ('apercu_arene_grotte_meteore_deoxys_native_v1.html', 'FGM1 · Grotte Météore Deoxys (b74 Natif)'),
    ]
    nav_links = ''.join(
        f'<a href="{href}" style="display:inline-block;padding:6px 12px;border-radius:6px;text-decoration:none;'
        f'font-size:13px;font-weight:600;border:1px solid #2d4252;'
        f'background:{"#7ee0ec;color:#0e2533" if code in label else "#182230;color:#cfe4ee"}">{label}</a>'
        for href, label in nav_items
    )
    return f'''<!doctype html>
<html lang="fr">
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>{code} · {title_short}</title>
<style>
body{{background:#121722;color:#e7ecf4;font:15px/1.55 system-ui,sans-serif;margin:0;padding:20px 24px}}
main{{max-width:1260px;margin:auto}}
.topnav{{display:flex;gap:8px;flex-wrap:wrap;margin:0 0 16px;padding-bottom:12px;border-bottom:1px solid #253646}}
h1{{font-size:27px;margin:0 0 6px}}
p{{color:#bcccd8;max-width:92ch}}
.wrap{{display:flex;gap:24px;flex-wrap:wrap;align-items:flex-start}}
.stage{{position:relative;background:#0a0f14;overflow:auto;max-height:86vh;border:1px solid #2d4252;border-radius:6px}}
canvas{{display:block;image-rendering:pixelated}}
aside{{flex:1;min-width:300px;max-width:440px}}
fieldset{{border:1px solid #2d4252;border-radius:8px;margin:0 0 14px;padding:10px 14px}}
legend{{color:#7ee0ec;padding:0 6px;font-weight:600}}
.layrow{{display:flex;align-items:center;justify-content:space-between;gap:6px;padding:2px 0}}
.layrow label{{padding:1px 0;margin:0;flex:1}}
.mini{{padding:2px 7px;font-size:11.5px;background:#223446;color:#cfe4ee;margin:0}}
label{{display:block;padding:3px 0;cursor:pointer}}
button{{background:#cfe4ee;color:#102b38;border:0;border-radius:6px;padding:7px 13px;margin:2px 4px 2px 0;cursor:pointer;font-weight:600}}
button.on{{background:#7ee0ec}}
.note{{border-left:3px solid #7ee0ec;padding-left:12px;font-size:13.5px}}
.fid{{font-size:12.5px;color:#b8d7e6;margin-top:6px}}
.ref{{width:100%;image-rendering:pixelated;border-radius:4px;border:1px solid #2d4252}}
code{{color:#d3ebf7}}
</style>
<main>
<nav class="topnav">{nav_links}</nav>
<h1>{code} · {title_short}</h1>
<p>{subtitle_html}</p>
<div class="wrap">
  <div class="stage"><canvas id="c"></canvas></div>
  <aside>
    <fieldset><legend>Lecture (cadence 60 i/s)</legend><button id="play">Pause</button><button id="step">+2 ticks</button><div id="phase"></div></fieldset>
    <fieldset><legend>Affichage</legend>
      <button data-zoom="1" class="on">1×</button><button data-zoom="2">2×</button><button data-zoom="3">3×</button>
      <label><input type="checkbox" id="grid"> Grille 8 px</label>
      <label><input type="checkbox" id="coll"> Collisions 16×16 et marqueurs</label>
      <label><input type="checkbox" id="view"> Viewport PMDO ×1 (320×240) à l'arrivée</label>
    </fieldset>
    <fieldset><legend>Calques multicalques (bas → haut)</legend><div id="layers"></div><div style="margin-top:6px"><button id="solo">Tout afficher</button></div></fieldset>
    <fieldset><legend>{poses_legend}</legend><div id="poses" style="display:flex;flex-wrap:wrap;gap:6px"></div></fieldset>
    <fieldset><legend>{ref_label}</legend><img id="ref" class="ref" alt="{ref_label}"><div id="fid" class="fid"></div></fieldset>
    <fieldset><legend>Export</legend><button id="png">PNG de la vue actuelle (1×)</button></fieldset>
    <p class="note">{status_html} Jaune = <code>entrance</code>, cyan = <code>{goal_label}</code>.</p>
  </aside>
</div>
</main>
<script>
const D=__DATA__;const [W,H]=D.size;const c=document.getElementById('c'),x=c.getContext('2d');
function img(u){{const i=new Image();i.src=u;return i}}
const L=D.stack.map(l=>({{id:l.id,ticks:l.ticks,frames:l.frames.map(img)}})),coll=img(D.collisions);
document.getElementById('ref').src=D.reference;
if(D.fidelity_summary)document.getElementById('fid').textContent=D.fidelity_summary;
const box=document.getElementById('layers'),checks={{}};
L.forEach((l,idx)=>{{
  const row=document.createElement('div');row.className='layrow';
  const lab=document.createElement('label'),ch=document.createElement('input');
  ch.type='checkbox';ch.checked=true;ch.onchange=draw;checks[l.id]=ch;
  lab.append(ch,' '+String(idx).padStart(2,'0')+' · '+l.id+(l.frames.length>1?' ('+l.frames.length+'×'+l.ticks+' ticks)':''));
  const sb=document.createElement('button');sb.className='mini';sb.textContent='Solo';
  sb.onclick=()=>{{Object.values(checks).forEach(o=>o.checked=false);ch.checked=true;draw()}};
  row.append(lab,sb);box.append(row);
}});
D.poses.forEach(p=>{{const i=img(p.uri);i.width=p.w*4;i.height=p.h*4;i.title=p.id;i.style.cssText='image-rendering:pixelated;background:'+D.surface;document.getElementById('poses').append(i)}});
let zoom=1,tick=0,playing=true,last=performance.now();const STEP=2,MS=STEP*1000/60;
function render(ctx){{ctx.clearRect(0,0,W,H);L.forEach(l=>{{if(checks[l.id].checked)ctx.drawImage(l.frames[Math.floor(tick/l.ticks)%l.frames.length],0,0)}});
 if(document.getElementById('coll').checked)ctx.drawImage(coll,0,0);}}
function draw(){{c.width=W*zoom;c.height=H*zoom;x.imageSmoothingEnabled=false;x.save();x.scale(zoom,zoom);render(x);x.restore();
 if(document.getElementById('grid').checked){{x.strokeStyle='rgba(255,255,255,.18)';x.lineWidth=1;x.beginPath();
  for(let i=0;i<=W;i+=8){{x.moveTo(i*zoom+.5,0);x.lineTo(i*zoom+.5,H*zoom)}}for(let j=0;j<=H;j+=8){{x.moveTo(0,j*zoom+.5);x.lineTo(W*zoom,j*zoom+.5)}}x.stroke()}}
 if(document.getElementById('view').checked){{const cx=Math.min(Math.max(D.entry[0]+8-160,0),W-320),cy=Math.min(Math.max(D.entry[1]+8-120,0),H-240);
  x.strokeStyle='#ffe066';x.lineWidth=2;x.strokeRect(cx*zoom,cy*zoom,320*zoom,240*zoom)}}
 document.getElementById('phase').textContent='tick '+tick+' / '+D.loop;}}
function adv(){{tick=(tick+STEP)%D.loop;draw()}}
function loop(t){{if(playing&&t-last>=MS){{last=t;adv()}}requestAnimationFrame(loop)}}
document.getElementById('play').onclick=e=>{{playing=!playing;e.target.textContent=playing?'Pause':'Lecture'}};
document.getElementById('step').onclick=adv;
document.querySelectorAll('[data-zoom]').forEach(b=>b.onclick=()=>{{zoom=+b.dataset.zoom;document.querySelectorAll('[data-zoom]').forEach(o=>o.classList.toggle('on',o===b));draw()}});
['grid','coll','view'].forEach(id=>document.getElementById(id).onchange=draw);
document.getElementById('solo').onclick=()=>{{Object.values(checks).forEach(ch=>ch.checked=true);draw()}};
document.getElementById('png').onclick=()=>{{const o=document.createElement('canvas');o.width=W;o.height=H;render(o.getContext('2d'));const a=document.createElement('a');a.download='{code}_vue_tick'+String(tick).padStart(3,'0')+'.png';a.href=o.toDataURL('image/png');a.click()}};
Promise.all([...L.flatMap(l=>l.frames),coll].map(i=>i.decode())).then(()=>{{draw();requestAnimationFrame(loop)}});
</script>
</html>
'''


def package_lot(
    *,
    here: Path,
    lot_name: str,
    namespace: str,
    pfx: str,
    ora_name: str,
    anims: list[str],
    ref_rel: str,
    surface_css: str,
    html_name: str,
    goal_key: str,
    fidelity_summary: str,
) -> None:
    """Empaquette les ZIPs PMDO + PNG/ORA + génère l'aperçu HTML autonome + archive virtuelle."""
    out = R / 'renders' / lot_name
    stage = R / '.cache' / lot_name / namespace
    vzip_dir = R / '.cache/virtual_zips'
    vzip_dir.mkdir(parents=True, exist_ok=True)
    m = json.loads((out / 'manifest.json').read_text())

    def zipdir(path: Path, items: list[tuple[Path, str]]) -> None:
        with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED, compresslevel=9) as z:
            for src, arc in items:
                z.write(src, arc)

    pmod_zip = out / f'{pfx}_projet_pmdo_0812.zip'
    zipdir(pmod_zip, [(p, f'{namespace}/' + p.relative_to(stage).as_posix()) for p in sorted(stage.rglob('*')) if p.is_file()])
    shutil.copy2(pmod_zip, vzip_dir / f'{pfx}_{namespace}_pmdo_0812.zip')

    review_names = ['scene_t000.png', 'scene_animee.webp', 'collisions_marqueurs.png', 'planche_poses.png']
    items = [(p, 'calques/' + p.name) for p in sorted((out / 'calques').glob('*.png'))]
    for sub in anims:
        items += [(p, f'animation/{sub}/' + p.name) for p in sorted((out / 'animation' / sub).glob('*.png'))]
    items += [(p, 'poses/' + p.name) for p in sorted((out / 'poses').glob('*.png'))]
    items += [(p, 'masques/' + p.name) for p in sorted((out / 'masques').glob('*.png'))]
    items += [
        (out / ora_name, ora_name),
        (out / 'manifest.json', 'manifest.json'),
        (out / 'README.md', 'README.md'),
    ]
    items += [(out / 'review' / f'{pfx}_{n}', f'apercu/{pfx}_{n}') for n in review_names]
    calq_zip = out / f'{pfx}_calques_png_8px.zip'
    zipdir(calq_zip, items)

    def uri(p: Path) -> str:
        return 'data:image/png;base64,' + base64.b64encode(Path(p).read_bytes()).decode()

    stack = []
    for lay in m['layers']:
        name = re.sub(rf'^{pfx}_\d\d_', '', Path(lay['file']).stem.replace('_fNN', ''))
        frames = [out / lay['file']] if lay['phases'] == 1 else [out / lay['file'].replace('fNN', f'f{t:02d}') for t in range(lay['phases'])]
        stack.append({'id': name, 'ticks': lay['ticks'], 'frames': [uri(p) for p in frames]})

    poses = []
    for p in sorted((out / 'poses').glob('*.png')):
        w, h = Image.open(p).size
        poses.append({'id': p.stem.replace(pfx + '_', ''), 'uri': uri(p), 'w': w, 'h': h})

    data = {
        'size': m['size_px'],
        'loop': m['scene_loop_ticks'],
        'stack': stack,
        'surface': surface_css,
        'poses': poses,
        'reference': uri(here / ref_rel),
        'collisions': uri(out / f'review/{pfx}_collisions_marqueurs.png'),
        'entry': m['access']['entry_px'],
        'threshold': m['access'][goal_key],
        'fidelity_summary': fidelity_summary,
    }
    page = (here / 'viewer_template.html').read_text().replace('__DATA__', json.dumps(data))
    out_html = R / html_name
    out_html.write_text(page)
    for p in [pmod_zip, calq_zip, out_html]:
        print(p.relative_to(R), round(p.stat().st_size / 1e6, 2), 'Mo')
