#!/usr/bin/env python3
"""FTT1 — Fin de la Tour Temporelle, sommet/arène de boss (4:3, 768 × 576).

Reproduire depuis la racine : .venv/bin/python source/fin_tour_temporelle_v1/build.py
Art généré référencé par un échantillon de style ETT2 ; refs MAP_BG D29P11A/D30P34A consultées
comme documentation visuelle seulement. Aucune tuile PMD native n'est revendiquée.
"""
from pathlib import Path
import hashlib
import importlib.util
import json
import shutil
import uuid
import zipfile

import numpy as np
from PIL import Image, ImageDraw, ImageFilter
from scipy import ndimage as ndi

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
LOT = 'fin_tour_temporelle_v1'
OUT = ROOT / 'renders' / LOT
RAW = HERE / 'bruts'
REF = HERE / 'reference'
PFX = 'FTT1'
NAMESPACE = 'fin_tour_temporelle'
ASSET = 'ftt1_sommet_tour_temporelle'
STAGE = ROOT / '.cache' / LOT / NAMESPACE
W, H = 768, 576
SRC = (1200, 896)
LOOP_TICKS = 240
CLOUD_PHASES, CLOUD_TICKS = 24, 10
RING_PHASES, RING_TICKS = 24, 10
CRYSTAL_PHASES, CRYSTAL_TICKS = 16, 15
SPARK_PHASES, SPARK_TICKS = 48, 5
NEBULA_PHASES, NEBULA_TICKS = 24, 10


def loadmod(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


# Méthodes partagées avec les lots PMDO 4:3 déjà exécutables.
JM = loadmod('ftt1_ejn1_utils', ROOT / 'source/entree_jungle_sud_nord_v1/build.py')
BM = JM.BM
V1 = loadmod('ftt1_esn1_collision', ROOT / 'source/entree_sud_nord_generee_v1/build.py')
CODEC = loadmod('ftt1_pmdo_codec', ROOT / 'source/pmdo_cote/build.py')
INDEX = loadmod('ftt1_pmdo_index', ROOT / 'source/pmdo_cote/INSTALLER.py')
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
SCALE = JM.SCALE
CROP_X = JM.CROP_X

# ROI de la dalle principale et du chemin sud, relevée sur le brut FTT1.
# Les marches de l'autel et le relief périphérique restent dans le décor d'origine.
FLOOR_ROI_POLY = [
    (244, 385), (956, 385), (1068, 470), (1075, 570), (1030, 665),
    (924, 728), (710, 770), (692, 895), (508, 895), (490, 770),
    (276, 728), (170, 665), (125, 570), (132, 470),
]
ARENA_CENTER_RAW = (600, 536)
CRYSTAL_BOX_RAW = (520, 180, 680, 315)

GOLD_RAMP = [(174, 94, 26), (218, 137, 43), (255, 194, 78), (255, 240, 174)]
CRYSTAL_CYAN = (106, 224, 238)
CRYSTAL_WHITE = (230, 255, 255)
SPARK_COLORS = [(255, 221, 132), (145, 236, 246), (244, 239, 218)]


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def rgb(path):
    with Image.open(path) as im:
        return np.asarray(im.convert('RGB')).astype(np.int16)


def keep_large(mask, minimum):
    labels, count = ndi.label(mask)
    if not count:
        return mask
    sizes = ndi.sum(mask, labels, range(1, count + 1))
    keep = 1 + np.flatnonzero(sizes >= minimum)
    return np.isin(labels, keep)


def polygon_mask(points, size=SRC):
    im = Image.new('L', size, 0)
    ImageDraw.Draw(im).polygon(points, fill=255)
    return np.asarray(im) > 0


def key_mask(a):
    r, g, b = a.transpose(2, 0, 1)
    exact = (r > 200) & (b > 200) & (g < 85) & (np.abs(r - b) < 70)
    near = (r > 160) & (b > 160) & (g < 125) & (np.abs(r - b) < 90)
    # Un pixel de sécurité retire l'anticrénelage magenta sans entamer les contours sombres.
    return ndi.binary_dilation(exact, iterations=1) & near


def down_mask(mask, threshold=96):
    scaled_w = round(SRC[0] * SCALE)
    im = Image.fromarray(mask.astype('uint8') * 255, 'L')
    arr = np.asarray(im.resize((scaled_w, H), Image.Resampling.BOX))[:, CROP_X:CROP_X + W]
    return arr >= threshold


def rgba(colors, mask):
    return JM.rgba(colors, mask)


def classify(main):
    """Segmentation de la matière générée, sans utiliser le magenta comme texture."""
    r, g, b = main.transpose(2, 0, 1)
    lum = main @ np.array([0.299, 0.587, 0.114])
    sat = main.max(2) - main.min(2)
    key = key_mask(main)

    # Sol principal : gris ardoise récurrent du brut, lissé puis fermé dans une ROI manuelle.
    roi = polygon_mask(FLOOR_ROI_POLY)
    dist = np.sqrt(((main - np.array([54, 56, 69])) ** 2).sum(2))
    floor_seed = (dist < 27) & (sat < 42) & roi & ~key
    floor_smooth = ndi.uniform_filter(floor_seed.astype(float), 9) > 0.37
    floor_smooth = ndi.binary_closing(floor_smooth, iterations=4)
    floor_smooth = ndi.binary_fill_holes(floor_smooth) & roi & ~key
    # Garder le réseau de dalle qui rejoint l'entrée sud ; les reliefs séparés restent bloqués.
    labels, _ = ndi.label(floor_smooth)
    bottom = labels[820:, 500:701]
    ids = [int(v) for v in np.unique(bottom) if v]
    floor = np.isin(labels, ids) if ids else floor_smooth
    floor = ndi.binary_closing(floor, iterations=2) & roi & ~key

    # Les fissures d'or sont conservées au-dessus du nouveau sol et animées séparément.
    gold = (r > 105) & (g > 62) & (r > g * 1.16) & (g > b * 1.38) & (b < 145) & ~key
    gold = keep_large(gold, 3)
    cloud = (r > 38) & (r > g * 1.48) & (r > b * 1.17) & (g < 105) & ~key
    cloud = keep_large(cloud, 28)

    # Le cristal principal est le plus grand éclat cyan dans l'autel nord, pas les gemmes latérales.
    x0, y0, x1, y1 = CRYSTAL_BOX_RAW
    cyan = (g > r + 22) & (b > r + 22) & (g > 85) & ~key
    region = np.zeros_like(cyan)
    region[y0:y1, x0:x1] = True
    cm = keep_large(cyan & region, 12)
    lab, n = ndi.label(cm)
    crystal = np.zeros_like(cm)
    if n:
        sizes = ndi.sum(cm, lab, range(1, n + 1))
        # Le composant le plus ample et le plus proche du centre supérieur.
        candidates = [i + 1 for i, size in enumerate(sizes) if size >= 12]
        if candidates:
            cx0, cy0 = 600, 244
            chosen = min(candidates, key=lambda i: (
                (np.mean(np.nonzero(lab == i)[1]) - cx0) ** 2 +
                (np.mean(np.nonzero(lab == i)[0]) - cy0) ** 2,
                -sizes[i - 1],
            ))
            crystal = lab == chosen

    # Remplacer la masse plane du sol par le rendu dédié, en conservant lignes, fissures et objets.
    floor_base_color = (dist < 34) & (sat < 48) & (lum > 22) & (lum < 115)
    dark_detail = (lum < 26) & floor
    preserve = gold | crystal | dark_detail
    floor_cut = floor & floor_base_color & ~preserve
    decor = ~key & ~cloud & ~floor_cut

    # Walkability : surface plate fermée, avec gros fragments sombres exclus du chemin.
    dark = (lum < 27) & (sat < 45) & roi & ~key
    dark_objects = keep_large(dark, 180)
    walk = floor & ~ndi.binary_dilation(dark_objects, iterations=2)
    return {
        'key': key,
        'roi': roi,
        'floor_seed': floor_seed,
        'floor': floor,
        'floor_cut': floor_cut,
        'decor': decor,
        'cloud': cloud,
        'gold': gold,
        'crystal': crystal,
        'walk': walk,
    }


def make_sky():
    """Vide d'espace presque noir, sous la nébuleuse générée et ses pulsations."""
    yy, xx = np.mgrid[:H, :W]
    dx = (xx - W * 0.5) / (W * 0.72)
    dy = (yy - H * 0.48) / (H * 0.85)
    radial = np.clip(np.sqrt(dx * dx + dy * dy), 0, 1.2)
    band = 0.5 + 0.5 * np.sin(yy / 91.0 + 0.25 * np.sin(xx / 121.0))
    red = 3 + 4 * radial + 1.2 * band
    green = 2 + 0.4 * band
    blue = 4 + 2 * radial + 0.6 * band
    out = np.zeros((H, W, 4), 'uint8')
    out[..., :3] = np.stack([red, green, blue], -1).clip(0, 255).astype('uint8')
    out[..., 3] = 255
    # Quelques étoiles rouge sombre, presque éteintes pour laisser dominer la nébuleuse.
    rng = np.random.default_rng(191026)
    for _ in range(36):
        x = int(rng.integers(8, W - 8)); y = int(rng.integers(8, H - 8))
        out[y, x] = (36, 7, 14, 255) if rng.random() < .72 else (19, 12, 17, 255)
    return out


def nebula_base():
    """Réduit le fond généré sans l'étirer; le vide noir reste translucide."""
    path = RAW / 'nebuleuse_rouge_noir.png'
    with Image.open(path) as im:
        src = im.convert('RGB').resize((round(SRC[0] * SCALE), H), Image.Resampling.BOX)
    colors = np.asarray(src, dtype='uint8')[:, CROP_X:CROP_X + W]
    # Palette indépendante pour que l'image d'arrière-plan ne recolore pas le terrain.
    paletted = Image.fromarray(colors).quantize(
        colors=64, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    colors = np.asarray(paletted.convert('RGB'), dtype='uint8')
    r, g, b = colors.astype(float).transpose(2, 0, 1)
    redness = np.clip((r - 6) / 62, 0, 1)
    chroma = np.clip((r - g + 2) / 18, 0, 1) * np.clip((r - b + 7) / 20, 0, 1)
    alpha = np.rint(np.clip(redness * chroma, 0, 0.92) * 255).astype('uint8')
    out = np.zeros((H, W, 4), 'uint8')
    out[..., :3] = colors
    out[..., 3] = alpha
    out[alpha == 0] = 0
    return out, alpha > 12


def nebula_frames(base, support):
    """Vagues de lumière rouge qui serpentent sur les filaments du fond en boucle."""
    yy, xx = np.mgrid[:H, :W]
    nx = (xx - W * 0.5) / (W * 0.5)
    ny = (yy - H * 0.5) / (H * 0.5)
    radius = np.sqrt(nx * nx + ny * ny)
    angle = np.arctan2(ny, nx)
    source = base[..., :3].astype(float)
    opacity = base[..., 3].astype(float) / 255.0
    frames = []
    for t in range(NEBULA_PHASES):
        phase = 2 * np.pi * t / NEBULA_PHASES
        diagonal = 0.5 + 0.5 * np.sin(
            2 * np.pi * (xx / 226.0 + yy / 318.0 + 0.08 * np.sin(xx / 91.0 + yy / 127.0)) - phase)
        spiral = 0.5 + 0.5 * np.sin(2 * np.pi * (radius * 1.75 - angle * 0.11) + phase * 0.72)
        wave = 0.62 * diagonal + 0.38 * spiral
        glow = np.clip((wave - 0.57) / 0.43, 0, 1)
        # L'onde n'éclaire que les filaments les plus lisibles, pas toute la vapeur :
        # cela garde un fond respirant et un tileset Ground compact. Cinq crans d'alpha.
        alpha = np.rint(glow * opacity * 176 / 32).clip(0, 5) * 32
        alpha = alpha.astype('uint8')
        alpha[~(support & (base[..., 3] >= 96))] = 0
        f = np.zeros((H, W, 4), 'uint8')
        f[..., 0] = np.clip(source[..., 0] + 46, 0, 150).astype('uint8')
        f[..., 1] = np.clip(source[..., 1] * 0.72 + 2, 0, 30).astype('uint8')
        f[..., 2] = np.clip(source[..., 2] * 0.76 + 2, 0, 40).astype('uint8')
        f[..., 3] = alpha
        f[alpha == 0] = 0
        frames.append(f)
    return frames


def cloud_frames(base, mask):
    yy, xx = np.mgrid[:H, :W]
    source = base[..., :3].astype(float)
    frames = []
    for t in range(CLOUD_PHASES):
        phase = 2 * np.pi * t / CLOUD_PHASES
        # Palette cloud rouge/noire ETT2 conservée ; le flux lumineux dérive en diagonale.
        wave = 0.5 + 0.5 * np.sin(2 * np.pi * (xx / 116.0 + yy / 198.0) - phase)
        amp = 0.88 + 0.16 * wave
        target = np.stack([np.minimum(255, source[..., 0] * amp + 3),
                           source[..., 1] * (0.94 + 0.08 * wave),
                           source[..., 2] * (0.93 + 0.09 * wave)], -1)
        f = np.zeros((H, W, 4), 'uint8')
        f[..., :3] = np.clip(np.rint(target), 0, 255).astype('uint8')
        f[..., 3] = mask.astype('uint8') * 255
        f[~mask] = 0
        frames.append(f)
    return frames


def circuit_frames(mask, centre):
    yy, xx = np.mgrid[:H, :W]
    d = np.hypot(xx - centre[0], (yy - centre[1]) * 1.28)
    rmax = float(d[mask].max()) + 46 if mask.any() else 1.0
    frames = []
    for t in range(RING_PHASES):
        front = (rmax + 90) * t / RING_PHASES
        lag = front - d
        level = np.full((H, W), -1, dtype=np.int8)
        level[(lag >= 0) & (lag < 10)] = 3
        level[(lag >= 10) & (lag < 24)] = 2
        level[(lag >= 24) & (lag < 45)] = 1
        level[(lag >= 45) & (lag < 78)] = 0
        f = np.zeros((H, W, 4), 'uint8')
        for i, color in enumerate(GOLD_RAMP):
            sel = mask & (level == i)
            f[sel, :3] = color
            f[sel, 3] = 255
        frames.append(f)
    return frames, {'centre_xy': list(centre), 'rayon_max_px': round(rmax, 1)}


def crystal_frames(mask, base_colors, centre):
    yy, xx = np.mgrid[:H, :W]
    cx, cy = centre
    dist = np.hypot(xx - cx, (yy - cy) * 1.1)
    halo = np.exp(-(dist / 14.0) ** 2)
    frames = []
    for t in range(CRYSTAL_PHASES):
        ph = 2 * np.pi * t / CRYSTAL_PHASES
        pulse = 0.5 + 0.5 * np.sin(ph - np.pi / 2)
        f = np.zeros((H, W, 4), 'uint8')
        alpha = np.clip(np.rint(halo * (34 + 82 * pulse)), 0, 126).astype('uint8')
        halo_mask = (alpha >= 12) & ~mask
        f[halo_mask, :3] = CRYSTAL_CYAN
        f[halo_mask, 3] = alpha[halo_mask]
        core = mask
        mix = np.clip(pulse, 0, 1)
        base = base_colors[core].astype(float)
        target = np.array(CRYSTAL_WHITE, float)
        f[core, :3] = np.clip(np.rint(base * (1 - 0.28 * mix) + target * (0.28 * mix)), 0, 255).astype('uint8')
        f[core, 3] = 255
        # Un éclat parcourt une orbite courte autour du cristal : animation orientée,
        # distincte du simple battement symétrique du halo.
        gx = int(round(cx + 7 * np.cos(ph)))
        gy = int(round(cy + 3.5 * np.sin(ph)))
        for ox, oy, alpha_ in ((0, 0, 210), (1, 0, 110), (-1, 0, 110), (0, 1, 95), (0, -1, 95)):
            px, py = gx + ox, gy + oy
            if 0 <= px < W and 0 <= py < H:
                f[py, px, :3] = CRYSTAL_WHITE
                f[py, px, 3] = max(int(f[py, px, 3]), alpha_)
        frames.append(f)
    return frames


def sparkle_frames(zone, boss_centre, seed=181026):
    rng = np.random.default_rng(seed)
    yy, xx = np.mgrid[:H, :W]
    dist = np.hypot(xx - boss_centre[0], (yy - boss_centre[1]) * 1.2)
    candidates = zone & (dist > 48)
    cy, cx = np.nonzero(candidates)
    if len(cx) < 40:
        candidates = np.ones((H, W), bool)
        cy, cx = np.nonzero(candidates)
    chosen = rng.choice(len(cx), size=38, replace=False)
    specs = []
    for i in chosen:
        specs.append({
            'xy': [int(cx[i]), int(cy[i])],
            'phase': int(rng.integers(SPARK_PHASES)),
            'teinte': list(SPARK_COLORS[int(rng.integers(len(SPARK_COLORS)))]),
            'taille': int(rng.choice([1, 1, 2])),
        })
    frames = []
    for t in range(SPARK_PHASES):
        f = np.zeros((H, W, 4), 'uint8')
        for s in specs:
            age = (t - s['phase']) % SPARK_PHASES
            if age >= 16:
                continue
            x0, y0 = s['xy']
            x = x0 + int(round(np.sin(age * np.pi / 8) * 1.2))
            y = y0 - age // 3
            strength = 0.32 + 0.68 * np.sin(np.pi * (age + 1) / 17)
            c = np.array(s['teinte'], float)
            c = np.clip(np.rint(c * strength), 0, 255).astype('uint8')
            rad = s['taille']
            points = [(x, y), (x - rad, y), (x + rad, y), (x, y - rad), (x, y + rad)]
            for px, py in points:
                if 0 <= px < W and 0 <= py < H:
                    f[py, px, :3] = c
                    f[py, px, 3] = 255
        frames.append(f)
    return frames, specs


def choose_marker(blocked, desired_xy, radius_cells=24):
    gh, gw = blocked.shape
    dx, dy = desired_xy[0] // 8, desired_xy[1] // 8
    options = []
    for gy in range(max(0, dy - radius_cells), min(gh - 1, dy + radius_cells + 1)):
        for gx in range(max(0, dx - radius_cells), min(gw - 1, dx + radius_cells + 1)):
            if gy + 1 >= gh or gx + 1 >= gw or blocked[gy:gy + 2, gx:gx + 2].any():
                continue
            score = (gx - dx) ** 2 + (gy - dy) ** 2
            options.append((score, gy, gx))
    if not options:
        raise AssertionError(f'aucun marqueur 16×16 libre près de {desired_xy}')
    _, gy, gx = min(options)
    return [gx * 8, gy * 8]


def compose(stack, tick):
    canvas = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    for _, frames, ticks in stack:
        canvas.alpha_composite(Image.fromarray(frames[(tick // ticks) % len(frames)]))
    return canvas


def save_ora(path, stack):
    layers = {f'{i:02d}_{name}': frames[0] for i, (name, frames, _) in enumerate(stack)}
    BM.write_ora(path, layers)


def load_ground_template():
    archive = ROOT / 'mod_metano_expeditions_pmdo_0812.zip'
    if archive.is_file():
        with zipfile.ZipFile(archive) as z:
            return json.loads(z.read('metano_expeditions/Data/Ground/v50812_01_crete_sillage_jour.rsground'))
    return json.loads((ROOT / 'cliffdaytest.rsground').read_text(encoding='utf-8-sig'))


def ground_project(stack, blocked, markers):
    if STAGE.exists():
        shutil.rmtree(STAGE)
    template = load_ground_template()
    obj = template['Object']
    gw, gh = W // 8, H // 8
    layers, banks = [], []
    for i, (title, frames, ticks) in enumerate(stack):
        bank = CODEC.TileBank(f'{PFX}_{i:02d}_{title.split()[0].upper()}')
        bank.ids[bytes(256)] = (0, 0)
        bank.data[(0, 0)] = bytes(256)

        def cell(x, y, frames=frames, bank=bank):
            refs = []
            for frame in frames:
                tile = Image.fromarray(frame[y * 8:y * 8 + 8, x * 8:x * 8 + 8])
                ref = bank.add(tile, x, y)
                refs.append(ref if ref else {'Sheet': bank.name, 'TexLoc': {'X': 0, 'Y': 0}})
            if all(ref['TexLoc'] == {'X': 0, 'Y': 0} for ref in refs):
                return []
            return [refs[0]] if all(ref == refs[0] for ref in refs) else refs

        layers.append(CODEC.layer(f'{i:02d} {title}', gw, gh, cell, ticks))
        banks.append(bank)
    layers.append(CODEC.layer(f'{len(layers):02d} Avant-plan libre (Top)', gw, gh, draw=4))
    for bank in banks:
        bank.write(STAGE / f'Content/Tile/{bank.name}.tile')

    obj.update(
        Name={'DefaultText': 'Fin Tour Temporelle - sommet, arène de boss (4:3)', 'LocalTexts': {}},
        AssetName=ASSET, Released=False, TexSize=1, Music='', EdgeView=1,
        ViewCenter=None, ViewOffset={'X': 0, 'Y': 0}, ActiveChar=None, Status={},
        Layers=layers,
        Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
        Comment=('PMDO 0.8.12. Zone de fin générée référencée, ambiance Tour Temporelle noir/or et nuages rouge-noir. '
                 'Arène centrale réservée au boss ; marqueur boss_dialga uniquement, aucun sprite/acteur placé. '
                 'Arrivée au sud ; aucun warp. Références visuelles MAP_BG D29P11A/D30P34A, nom de lieu non vérifié.'),
    )
    obj['obstacles'] = [
        [{'Bounds': {'X': x * 8, 'Y': y * 8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
         for y in range(gh)] for x in range(gw)
    ]
    marker_fn = lambda name, xy, direction: {
        'EntName': name, 'Direction': direction, 'EntEnabled': True, 'triggerType': 0,
        'Collider': {'X': xy[0], 'Y': xy[1], 'Width': 16, 'Height': 16},
    }
    obj['Entities'] = [{
        'Name': 'Entrée et repères de boss (sans acteurs)', 'Visible': True,
        'MapChars': [], 'GroundObjects': [], 'Spawners': [],
        'Markers': [marker_fn('entrance', markers['entrance'], 0),
                    marker_fn('boss_dialga', markers['boss_dialga'], 4)],
    }]
    obj['Decorations'] = [{'Name': 'Décorations FTT1', 'Layer': 2, 'Visible': True, 'Anims': []}]
    template['Version'] = '0.8.12.0'
    CODEC.save(STAGE / f'Data/Ground/{ASSET}.rsground',
               json.dumps(template, ensure_ascii=False, separators=(',', ':')).encode())
    CODEC.save(STAGE / f'Data/Script/{NAMESPACE}/ground/{ASSET}/init.lua',
               f'-- {ASSET} : zone de fin, aucun warp ni acteur instancié.\nlocal {ASSET} = {{}}\nreturn {ASSET}\n'.encode())

    nodes = {}
    for path in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with path.open('rb') as f:
            nodes[path.stem] = INDEX.read_node(f)
    (STAGE / 'Content/Tile/index.idx').write_bytes(INDEX.encode_index(nodes))
    mod_uuid = uuid.uuid5(uuid.NAMESPACE_URL,
                          'https://github.com/meromoonmeri/projet-creation-pmdo/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Tour Temporelle - Sommet (FTT1) - Atelier 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Zone de fin 4:3 générée référencée, arène centrale vide pour le boss, nuages rouge-noir, circuits temporels animés. Projet d'édition, pas une aventure jouable.</Description>
  <Namespace>{NAMESPACE}</Namespace>
  <UUID>{mod_uuid}</UUID>
  <Version>1.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
''', encoding='utf-8')
    installer = (ROOT / 'source/pmdo_cote/INSTALLER.py').read_text(encoding='utf-8')
    needle = '            relative = src.relative_to(source)\n'
    if "relative.as_posix() == 'Content/Tile/index.idx'" not in installer:
        assert needle in installer
        installer = installer.replace(needle, needle + "            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n")
    (STAGE / 'INSTALLER.py').write_text(installer, encoding='utf-8')
    shutil.copyfile(HERE / 'README_PACK.md', STAGE / 'README.md')
    return {bank.name: len(bank.data) for bank in banks}


def build():
    main = rgb(RAW / 'decor_magenta.png')
    floor_source = rgb(RAW / 'sol_complet.png')
    assert main.shape == floor_source.shape == (SRC[1], SRC[0], 3), (main.shape, floor_source.shape)
    masks = classify(main)

    # Le brut de sol dédié a un liseré magenta : on neutralise la clé puis on n'en garde
    # que la zone praticable mesurée sur le décor FTT1. Ses circuits sont retirés du fond
    # afin de garder un seul dessin de circuits (celui du décor) au-dessus.
    f = floor_source.copy()
    fkey = key_mask(f)
    slate = np.array([54, 56, 69], dtype=np.int16)
    f[fkey] = slate
    fr, fg, fb = f.transpose(2, 0, 1)
    floor_gold = (fr > 105) & (fg > 62) & (fr > fg * 1.16) & (fg > fb * 1.38) & (fb < 145)
    f[floor_gold] = slate
    floor_mask = masks['floor']

    floor_ex, floor_cols = JM.down_class(f, {'sol': floor_mask}, ['sol'])
    floor_layer = rgba(floor_cols['sol'], floor_ex['sol'])

    # Le décor original conserve la géométrie, le relief, les circuits et les contours ;
    # le magenta, le rouge des nuages et la masse plane centrale sont rendus en calques dédiés.
    dec_ex, dec_cols = JM.down_class(main, {'decor': masks['decor']}, ['decor'])
    decor_layer = rgba(dec_cols['decor'], dec_ex['decor'])
    cl_ex, cl_cols = JM.down_class(main, {'nuages': masks['cloud']}, ['nuages'])
    cloud_mask = cl_ex['nuages']
    cloud_base = rgba(cl_cols['nuages'], cloud_mask)

    gold_map = down_mask(masks['gold'], 42)
    crystal_map = down_mask(masks['crystal'], 42)
    if crystal_map.any():
        cy, cx = np.nonzero(crystal_map)
        crystal_center = (float(cx.mean()), float(cy.mean()))
    else:
        crystal_center = (round(600 * SCALE) - CROP_X, round(244 * SCALE))

    # Arrière-plan en profondeur : espace noir, nébuleuse générée semi-transparente,
    # puis pulsations rouge-brun animées avant le sol. La palette de fond reste indépendante.
    sky = make_sky()
    nebula_layer, nebula_support = nebula_base()
    fixed = BM.quantize_layers({
        'ciel': sky,
        'sol_complet': floor_layer,
        'nuages_base': cloud_base,
        'decors_sommet': decor_layer,
    })
    sky, floor_layer, cloud_base, decor_layer = (
        fixed['ciel'], fixed['sol_complet'], fixed['nuages_base'], fixed['decors_sommet'])
    cloud_mask = cloud_base[..., 3] == 255

    nebula_anim = nebula_frames(nebula_layer, nebula_support)
    cloud_anim = cloud_frames(cloud_base, cloud_mask)
    centre = (round(ARENA_CENTER_RAW[0] * SCALE) - CROP_X,
              round(ARENA_CENTER_RAW[1] * SCALE))
    ring_mask = down_mask(masks['gold'], 42)
    ring_anim, ring_info = circuit_frames(ring_mask, centre)
    crystal_anim = crystal_frames(crystal_map, decor_layer[..., :3], crystal_center)

    walk = down_mask(masks['walk'], 105)
    # Le personnage occupe 2×2 cases de 8 px ; une case est bloquée au-delà de 25 % d'obstacle.
    blocked = BM.cell_grid(~walk)
    entry = choose_marker(blocked, (W // 2, H - 16), radius_cells=12)
    boss = choose_marker(blocked, centre, radius_cells=12)
    markers = {'entrance': entry, 'boss_dialga': boss}
    spark_zone = down_mask(masks['floor'], 55) | (ndi.binary_dilation(cloud_mask, iterations=12) & ~walk)
    sparkle_anim, sparks = sparkle_frames(spark_zone, centre)

    stack = [
        ('CIEL_ABYSSE', [sky], 60),
        ('NEBULEUSE_FOND', [nebula_layer], 60),
        ('NEBULEUSE_ROUGE_NOIR', nebula_anim, NEBULA_TICKS),
        ('SOL_COMPLET', [floor_layer], 60),
        ('NUAGES_ROUGE_NOIR', cloud_anim, CLOUD_TICKS),
        ('DECOR_SOMMET', [decor_layer], 60),
        ('CIRCUITS_TEMPORELS', ring_anim, RING_TICKS),
        ('CRISTAL_TEMPOREL', crystal_anim, CRYSTAL_TICKS),
        ('POUSSIERES_TEMPORELLES', sparkle_anim, SPARK_TICKS),
    ]

    # Sorties éditables : calques statiques, frames transparentes, masques et revue.
    for sub in ('calques', 'animation', 'masques', 'review'):
        shutil.rmtree(OUT / sub, ignore_errors=True)
    (OUT / 'calques').mkdir(parents=True, exist_ok=True)
    (OUT / 'animation').mkdir(parents=True, exist_ok=True)
    (OUT / 'masques').mkdir(parents=True, exist_ok=True)
    (OUT / 'review').mkdir(parents=True, exist_ok=True)
    files = {}
    for i, (name, frames, ticks) in enumerate(stack):
        safe = name.lower()
        if len(frames) == 1:
            path = f'calques/{PFX}_{i:02d}_{safe}.png'
            Image.fromarray(frames[0]).save(OUT / path, optimize=True)
        else:
            path = f'animation/{safe}/{PFX}_{i:02d}_{safe}_fNN.png'
            (OUT / f'animation/{safe}').mkdir(parents=True, exist_ok=True)
            for t, frame in enumerate(frames):
                Image.fromarray(frame).save(OUT / path.replace('NN', f'{t:02d}'), optimize=True)
        files[name] = path

    mask_thresholds = {
        'magenta': (masks['key'], 96), 'sol_arene': (floor_mask, 96),
        'praticable': (masks['walk'], 105), 'circuits_or': (masks['gold'], 42),
        'nuages': (masks['cloud'], 96), 'cristal': (masks['crystal'], 42),
    }
    for key, (mask, threshold) in mask_thresholds.items():
        out_mask = down_mask(mask, threshold)
        Image.fromarray(out_mask.astype('uint8') * 255).save(
            OUT / f'masques/{PFX}_masque_{key}.png', optimize=True)
    Image.fromarray(nebula_support.astype('uint8') * 255).save(
        OUT / f'masques/{PFX}_masque_nebuleuse.png', optimize=True)

    # Vérification de l'accès entrée sud -> marqueur du boss, avec clearance PMDO 16×16.
    ok, explored = V1.reachable(blocked, (entry[1] // 8, entry[0] // 8),
                                (boss[1] // 8, boss[0] // 8))
    if not ok:
        raise AssertionError(f'chemin 16×16 entrée -> boss non praticable: {entry} -> {boss}')

    scenes = [compose(stack, tick) for tick in range(0, LOOP_TICKS, 5)]
    scenes[0].save(OUT / 'review/FTT1_scene_t000.png', optimize=True)
    scenes[0].save(OUT / 'review/FTT1_scene_animee.webp', save_all=True,
                   append_images=scenes[1:], duration=round(5 * 1000 / 60), loop=0, lossless=True)
    collision = scenes[0].copy()
    overlay = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    for gy, gx in zip(*np.nonzero(blocked)):
        draw.rectangle((gx * 8, gy * 8, gx * 8 + 7, gy * 8 + 7), fill=(220, 40, 40, 92))
    for name, color in (('entrance', (255, 226, 54, 255)), ('boss_dialga', (58, 230, 255, 255))):
        x, y = markers[name]
        draw.rectangle((x, y, x + 15, y + 15), outline=color, width=2)
        draw.text((x + 18, y), name, fill=color)
    collision.alpha_composite(overlay)
    collision.save(OUT / 'review/FTT1_collisions_marqueurs.png', optimize=True)
    save_ora(OUT / 'FTT1_fin_tour_temporelle_calques.ora', stack)

    gfx = ground_project(stack, blocked, markers)
    ref_meta = {}
    for code in ('D29P11A', 'D30P34A'):
        path = REF / f'{code}.png'
        with Image.open(path) as im:
            ref_meta[code] = {
                'fichier': f'source/{LOT}/reference/{code}.png',
                'sha256': sha(path), 'taille_px': list(im.size),
                'source': 'pret/pmd-sky c8073235 + skytemple-files 1.8.5, rendu MAP_BG sans collision',
                'identification_du_lieu': 'non vérifiée ; le code MAP_BG est documenté, le nom du lieu ne l’est pas ici',
            }

    raw_meta = [
        {'file': f'source/{LOT}/bruts/decor_magenta.png', 'sha256': sha(RAW / 'decor_magenta.png'),
         'size': list(SRC), 'images': [f'source/{LOT}/reference/ETT2_style_swatch.png'],
         'utilise': True, 'origine': 'génération référencée : style/palette ETT2, composition décrite séparément'},
        {'file': f'source/{LOT}/bruts/sol_complet.png', 'sha256': sha(RAW / 'sol_complet.png'),
         'size': list(SRC), 'images': [f'source/{LOT}/bruts/decor_magenta.png'],
         'utilise': True, 'origine': 'génération référencée : dalle dédiée reprenant l’empreinte et les anneaux de la scène'},
        {'file': f'source/{LOT}/bruts/nebuleuse_rouge_noir.png', 'sha256': sha(RAW / 'nebuleuse_rouge_noir.png'),
         'size': list(SRC),
         'images': [f'source/{LOT}/reference/ETT2_style_swatch.png'], 'utilise': True,
         'origine': 'génération référencée : fond seul de nébuleuse rouge-noir, échantillon ETT2 fourni pour le style'},
    ]
    manifest = {
        'lot': LOT, 'prefix': PFX, 'serie': 'fins de donjon',
        'interpretation': 'Suite inférée du contexte ETT2 : fin de la Tour Temporelle / sommet, non explicitement nommée dans la dernière demande.',
        'boss': {'hypothese': 'Dialga (contexte de la Tour Temporelle)', 'marqueur': markers['boss_dialga'],
                 'sprite_place': False, 'acteur_place': False},
        'format': '4:3 vaste', 'size_px': [W, H], 'grid_8px': [W // 8, H // 8],
        'method': 'composition et fond nébuleuse générés/référencés par l’échantillon de style ETT2, recomposés en calques; références D29P11A/D30P34A consultées visuellement, pas fournies au générateur; pas de pixels natifs revendiqués',
        'references': ref_meta,
        'reference_style': {'fichier': 'source/fin_tour_temporelle_v1/reference/ETT2_style_swatch.png',
                           'origine': 'découpe 300×370 de source/entree_tour_temporelle_sud_nord_v2/bruts/decor_magenta.png ; style uniquement'},
        'raw_inputs': raw_meta,
        'nuages_reutilises': {'fichier': 'source/fin_tour_temporelle_v1/reference/ETT2_nuages_magenta.png',
                              'sha256': sha(REF / 'ETT2_nuages_magenta.png'),
                              'origine': 'texture générée ETT2 réutilisée comme repère de continuité; la couche FTT1 animée est extraite du brut décor FTT1'},
        'normalization': {'scale': SCALE, 'crop_x': CROP_X, 'reduction': 'BOX pondérée par classe; palette statique commune 96 couleurs; anims en rampes dédiées'},
        'segmentation': {
            'magenta': 'R,B > 200, G < 85, |R-B| < 70 puis dilatation 1 px limitée aux pixels magenta proches',
            'sol_arene': 'distance RGB < 27 du ton ardoise (54,56,69), saturation < 42, lissage 9 px, ROI et réseau relié au sud',
            'sol_complet': 'brut dédié masqué par le sol principal; pixels magenta neutralisés; circuits or retirés de la texture de fond',
            'décor': 'complément du magenta, des nuages rouges animés et des pixels de base du sol dans la ROI',
            'circuits': 'R>105, G>62, R>1.16G, G>1.38B, B<145',
            'nuages': 'composantes rouge/noir de la scène isolées par teinte rouge (le dessous sombre reste dans le décor fixe)',
            'cristal': f'cyan dans la boîte brute {list(CRYSTAL_BOX_RAW)}, composant le plus proche du sommet central',
            'nebuleuse': 'fond plein cadre normalisé à 768×576; alpha calculé selon luminosité et dominance rouge pour laisser respirer le vide noir',
        },
        'animation': {
            'scene_loop_ticks': LOOP_TICKS,
            'nebuleuse_rouge_noir': {'phases': NEBULA_PHASES, 'ticks_par_phase': NEBULA_TICKS,
                                      'loi': 'pulsations diagonales et spiralées qui glissent sur les filaments rouges; animation calculée, non issue de la ROM'},
            'nuages_rouge_noir': {'phases': CLOUD_PHASES, 'ticks_par_phase': CLOUD_TICKS, 'loi': 'pulsation de luminance diagonale douce; géométrie des nuages stable'},
            'circuits_temporels': {'phases': RING_PHASES, 'ticks_par_phase': RING_TICKS, 'loi': 'front lumineux radial sur les lignes or depuis le centre de l’arène; traîne éteinte au raccord', **ring_info,
                                   'rampe': [list(c) for c in GOLD_RAMP]},
            'cristal_temporel': {'phases': CRYSTAL_PHASES, 'ticks_par_phase': CRYSTAL_TICKS,
                                 'centre_xy': [round(v, 2) for v in crystal_center], 'couleur_halo': list(CRYSTAL_CYAN),
                                 'loi': 'halo cyan pulsé et éclat orbital court autour du cristal'},
            'poussieres_temporelles': {'phases': SPARK_PHASES, 'ticks_par_phase': SPARK_TICKS,
                                       'nombre': len(sparks), 'particules': sparks,
                                       'loi': 'éclats pixelisés en montée courte, scintillement puis extinction; positions déterministes'},
        },
        'layers': [{'name': name, 'file': files[name], 'phases': len(frames), 'ticks': ticks}
                   for name, frames, ticks in stack],
        'layer_order_bottom_to_top': [name for name, _, _ in stack],
        'access': {'markers': markers, 'chemin_16x16': {'ok': ok, 'cases_explorees': explored},
                   'blocked_cells': int(blocked.sum()), 'total_cells': int(blocked.size),
                   'rule': 'case bloquée si >25 % de la surface 8×8 n’est pas dans la dalle praticable'},
        'pmdo': {'target': '0.8.12', 'asset': ASSET, 'namespace': NAMESPACE,
                 'tiles_per_bank': gfx, 'banks': list(gfx), 'runtime_tested': False, 'warp': 'aucun'},
        'art_approved': False, 'runtime_tested': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    np.save(ROOT / '.cache' / LOT / 'walk.npy', walk)
    print(json.dumps({
        'markers': markers, 'walkable_px': int(walk.sum()), 'blocked_cells': int(blocked.sum()),
        'scene_loop_ticks': LOOP_TICKS, 'frames': {name: len(frames) for name, frames, _ in stack},
        'banks': gfx, 'ref_codes': list(ref_meta), 'art_approved': False, 'runtime_tested': False,
    }, ensure_ascii=False, indent=2))


if __name__ == '__main__':
    build()
