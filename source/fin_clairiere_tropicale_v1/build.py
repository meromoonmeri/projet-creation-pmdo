#!/usr/bin/env python3
"""Fin Clairière tropicale (FCT2) — production générée référencée puis Ground PMDO natif.

Format 4:3 vaste : 768 × 576 px, grille 96 × 72 de 8 px, cible PMDO 0.8.12.
Référence canonique : D54P32A de PMD Explorers of Sky, rendu par l'outil maps PMD Sky.
Le rendu sert de référence artistique et de composition ; les textures finales sont générées,
quantifiées, découpées en calques puis encodées en .tile / .rsground. Ce ne sont pas des tuiles
natives extraites du jeu.

Usage : .venv/bin/python source/fin_clairiere_tropicale_v1/build.py
"""
from pathlib import Path
import hashlib
import importlib.util
import io
import json
import shutil
import uuid
import zipfile
import xml.etree.ElementTree as ET

import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
RAW = HERE / 'bruts'
REF = HERE / 'reference/D54P32A.png'
TEMPLATE = ROOT / 'source/cote_v5_expeditions/references/ExplorersOfSkyOrigins__drenched_bluff_entrance.rsground'
LOT = 'fin_clairiere_tropicale_v1'
PFX = 'FCT2'  # Préfixe du jour ; FTC1 est réservé dans l'historique des branches sœurs.
PFX_NIGHT = 'FCT2N'  # Vérifié absent des lots présents ; banques propres à la variante nuit.
NAMESPACE = 'fin_clairiere_tropicale'
ASSET = 'fct2_fin_clairiere_tropicale'
ASSET_NIGHT = 'fct2_fin_clairiere_tropicale_nuit'
OUT = ROOT / 'renders' / LOT
STAGE = ROOT / '.cache' / LOT / NAMESPACE
W, H = 768, 576
SRC = (1200, 896)
PHASES, TICKS = 24, 5
LOOP_TICKS = PHASES * TICKS
FIDELITY_MAX = 35
# Silhouette manuelle du sanctuaire à pleine résolution ; le brut généré le teintait de vert.
SHRINE_POLYGON_RAW = [
    (592, 162), (609, 162), (623, 168), (634, 178), (641, 190), (646, 203),
    (648, 219), (648, 237), (646, 253), (542, 253), (541, 241), (542, 225),
    (544, 210), (548, 197), (554, 185), (563, 175), (576, 168), (585, 164),
]

GEN = [
    {
        'source': 'generation/FCT2_jour_genere.png',
        'target': 'decor.png',
        'variant': 'jour',
        'role': 'illustration standalone complète',
        'images': ['source/fin_clairiere_tropicale_v1/reference/D54P32A.png'],
        'generator': 'Arena image generator, génération référencée ; option 1 sélectionnée par l utilisateur',
        'prompt_summary': 'Nouvelle clairière tropicale 4:3, textures/palette/feuillage du rip canonique Southern Jungle ; arène ovale, sanctuaire gris au nord, corridor d entrée sud, pas de texte ni d UI.',
    },
    {
        'source': 'generation/FCT2_sol_complet_genere.png',
        'target': 'sol_complet.png',
        'variant': 'jour',
        'role': 'sous-sol complet généré',
        'images': [
            'source/fin_clairiere_tropicale_v1/generation/FCT2_jour_genere.png',
            'source/fin_clairiere_tropicale_v1/reference/D54P32A.png',
        ],
        'generator': 'Arena image generator, édition référencée ; sortie sans sélection d options',
        'prompt_summary': 'Sous-sol plein cadre : retrait de toute végétation, pierre, objet et ombre ; continuation de la texture sol générée et du rip canonique.',
    },
    {
        'source': 'generation/FCT2N_nuit_genere.png',
        'target': 'decor_nuit.png',
        'variant': 'nuit',
        'role': 'illustration standalone complète, lumière séparée',
        'images': [
            'source/fin_clairiere_tropicale_v1/generation/FCT2_jour_genere.png',
            'source/fin_clairiere_tropicale_v1/reference/D54P32A.png',
        ],
        'generator': 'Arena image generator, option nocturne retenue puis éditée sur la même source pour aligner le layout jour et séparer les lumières ; le candidat intermédiaire n est pas conservé',
        'prompt_summary': 'Variante nocturne générée depuis le layout jour et les textures du rip, palette Mystic Forest bleu-vert, roches gris-bleu, sans lueurs intégrées ; les halos seront un calque animation séparé.',
    },
    {
        'source': 'generation/FCT2N_sol_complet_genere.png',
        'target': 'sol_complet_nuit.png',
        'variant': 'nuit',
        'role': 'sous-sol complet nocturne généré',
        'images': [
            'source/fin_clairiere_tropicale_v1/generation/FCT2N_nuit_genere.png',
            'source/fin_clairiere_tropicale_v1/reference/D54P32A.png',
        ],
        'generator': 'Arena image generator, édition référencée ; sortie sans sélection d options',
        'prompt_summary': 'Sous-sol nocturne plein cadre, retrait de toute végétation, pierre, objet, ombre et lueur ; texture sol et étalonnage nuit dérivés des références.',
    },
]

PALETTE_GROUPS = {
    'terrain': {'layers': ['sol_complet', 'clairiere', 'ombres'], 'colors': 96},
    'vegetation': {'layers': ['jungle', 'canopee_avant'], 'colors': 96},
    'pierre': {'layers': ['roches', 'sanctuaire'], 'colors': 48},
}
LAYER_ORDER = ['sol_complet', 'clairiere', 'ombres', 'jungle', 'roches', 'sanctuaire', 'feuilles', 'canopee_avant']


def loadmod(name, path):
    spec = importlib.util.spec_from_file_location(name, path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


# Gabarit 4:3 existant : down_class fait le BOX pondéré par classe, à échelle uniforme.
JM = loadmod('fct2_entree_jungle', ROOT / 'source/entree_jungle_sud_nord_v1/build.py')
BM = JM.BM
PATHS = loadmod('fct2_paths', ROOT / 'source/entree_sud_nord_generee_v1/build.py')
assert (JM.W, JM.H, JM.SRC) == (W, H, SRC)
SCALE, SCALED_W, CROP_X = JM.SCALE, JM.SCALED_W, JM.CROP_X


def sha(path):
    return hashlib.sha256(Path(path).read_bytes()).hexdigest()


def prepare_generated_inputs():
    """Uniformly normalize each image-generator output to the production 1200×896 canvas."""
    prepared = {}
    for entry in GEN:
        source = HERE / entry['source']
        if not source.is_file():
            raise FileNotFoundError(f'Sortie du générateur absente : {source}')
        image = Image.open(source).convert('RGB')
        original_size = image.size
        if abs(original_size[0] / original_size[1] - W / H) > 0.01:
            raise AssertionError(f'Ratio du brut généré hors 4:3 : {source} {original_size}')
        scale = max(SRC[0] / original_size[0], SRC[1] / original_size[1])
        resized = (int(np.ceil(original_size[0] * scale)), int(np.ceil(original_size[1] * scale)))
        if image.size != resized:
            image = image.resize(resized, Image.Resampling.LANCZOS)
        left = (resized[0] - SRC[0]) // 2
        top = (resized[1] - SRC[1]) // 2
        image = image.crop((left, top, left + SRC[0], top + SRC[1]))
        destination = RAW / entry['target']
        destination.parent.mkdir(parents=True, exist_ok=True)
        image.save(destination, format='PNG', optimize=True)
        prepared[entry['target']] = {
            'generator_file': f'source/{LOT}/{entry["source"]}',
            'generator_sha256': sha(source),
            'original_size_px': list(original_size),
            'prepared_file': f'source/{LOT}/bruts/{entry["target"]}',
            'prepared_size_px': list(image.size),
            'uniform_scale': round(float(scale), 8),
            'crop_px': [left, top, resized[0] - left - SRC[0], resized[1] - top - SRC[1]],
            'method': 'mise à l échelle uniforme LANCZOS puis crop centré, aucun étirement',
        }
    return prepared


def rgb(path):
    return np.asarray(Image.open(path).convert('RGB'), dtype=np.uint8)


def lum(a):
    return a[..., :3].astype(np.float32) @ np.array([0.299, 0.587, 0.114], dtype=np.float32)


def keep_large(mask, minimum):
    labels, n = nd.label(mask)
    if n == 0:
        return np.zeros(mask.shape, bool)
    sizes = np.bincount(labels.ravel())
    good = np.flatnonzero(sizes >= minimum)
    good = good[good != 0]
    return np.isin(labels, good)


def close_edge(mask, iterations):
    if iterations <= 0:
        return mask.copy()
    pad = iterations + 2
    expanded = np.pad(mask, pad, mode='edge')
    return nd.binary_closing(expanded, iterations=iterations)[pad:-pad, pad:-pad]


def polygon_mask(points, shape):
    mask = Image.new('L', (shape[1], shape[0]), 0)
    ImageDraw.Draw(mask).polygon(points, fill=255)
    return np.asarray(mask) > 0


def materials(a):
    """Classifieur commun au rip et au brut : sol ocre, végétation verte, pierre grise."""
    x = a.astype(np.int16)
    r, g, b = x.transpose(2, 0, 1)
    value = lum(x)
    sat = x.max(2) - x.min(2)
    foliage = (g > r + 12) & (g > b + 16) & (value > 36)
    ground = (r > 112) & (g > 120) & (g - b > 32) & (r - b > 28) & (np.abs(g - r) < 58) & ~foliage
    stone = (sat < 46) & (value > 38) & ~ground & ~foliage
    return {'clairiere': ground, 'feuillage': foliage, 'pierre': stone}


def fidelity(a, ref):
    """Même classifieur appliqué au rip et au brut, distance euclidienne des moyennes RGB."""
    ma, mr = materials(a), materials(ref)
    result = {}
    for key in ma:
        ca, cr = int(ma[key].sum()), int(mr[key].sum())
        if ca < 100 or cr < 100:
            result[key] = {'pixels_brut': ca, 'pixels_rip': cr, 'distance': None}
            continue
        mean_a = a[ma[key]].astype(np.float64).mean(0)
        mean_r = ref[mr[key]].astype(np.float64).mean(0)
        result[key] = {
            'pixels_brut': ca,
            'pixels_rip': cr,
            'rgb_brut': [round(float(v), 1) for v in mean_a],
            'rgb_rip': [round(float(v), 1) for v in mean_r],
            'distance': round(float(np.linalg.norm(mean_a - mean_r)), 2),
        }
    return result


def classify(a, underlay):
    """Segmentation à pleine résolution ; les calques de terrain/objets forment une partition exclusive."""
    hh, ww = a.shape[:2]
    yy, xx = np.mgrid[:hh, :ww]
    mats = materials(a)
    source_floor = mats['clairiere']
    raw_foliage = mats['feuillage']
    raw_stone = mats['pierre']
    value = lum(a)

    # Pierres en composantes : conserver le sanctuaire, les rochers et les galets détectables.
    rock = close_edge(raw_stone, 2)
    rock = nd.binary_opening(rock, iterations=1)
    rock = keep_large(rock, 24)

    # Ancrer le monument par sa plus grande composante pierre, puis compléter son silhouette
    # avec une forme mesurée sur le brut : sa couronne verte ne passe pas le classifieur gris.
    rl, rn = nd.label(rock)
    shrine_roi = np.zeros_like(rock)
    shrine_roi[int(hh * 0.10):int(hh * 0.42), int(ww * 0.35):int(ww * 0.65)] = True
    shrine_scores = []
    for i in range(1, rn + 1):
        count = int((rl == i)[shrine_roi].sum())
        if count:
            shrine_scores.append((count, i))
    shrine_id = max(shrine_scores)[1] if shrine_scores else 0
    shrine_core = (rl == shrine_id) if shrine_id else np.zeros_like(rock)
    shrine = shrine_core | polygon_mask(SHRINE_POLYGON_RAW, rock.shape)

    # Enveloppe de sol : fermeture puis remplissage des petits trous, en retenant la composante
    # reliée à l'entrée sud. À l'intérieur de cette enveloppe, les pixels non classés comme plante
    # ou objet sont du sol — ils ne sont pas envoyés par défaut dans le calque de jungle.
    ground_envelope = nd.binary_fill_holes(close_edge(source_floor, 7))
    labels, n = nd.label(ground_envelope)
    if n:
        sizes = np.bincount(labels.ravel())
        bottom_ids = np.unique(labels[-8:, :])
        bottom_ids = [int(i) for i in bottom_ids if i > 0]
        if bottom_ids:
            main_id = max(bottom_ids, key=lambda i: sizes[i])
        else:
            main_id = int(np.argmax(sizes[1:]) + 1)
        ground_envelope = labels == main_id
    else:
        ground_envelope = np.zeros_like(source_floor)

    # Garder les feuilles sombres reliées au bord bas pour le premier plan, même si leur vert
    # profond échappe au classifieur matière. Le couloir de sol reste clair et praticable.
    dark_bottom = (yy >= int(hh * 0.72)) & (value < 62)
    dl, dn = nd.label(dark_bottom)
    bottom_ids = np.unique(dl[-1, :]) if dn else np.array([], dtype=int)
    bottom_ids = [int(i) for i in bottom_ids if i > 0]
    foreground_candidates = np.isin(dl, bottom_ids) & dark_bottom if bottom_ids else np.zeros_like(source_floor)

    unknown = ~(source_floor | raw_foliage | raw_stone)
    unclassified_floor = ground_envelope & unknown & ~foreground_candidates & ~shrine
    small_stone_floor = ground_envelope & raw_stone & ~rock & ~foreground_candidates & ~shrine
    ground = ((ground_envelope & source_floor) | unclassified_floor | small_stone_floor)
    # Les taches vertes de l'arène restent des objets distincts, jamais des pixels de sol.
    ground &= ~raw_foliage & ~rock & ~foreground_candidates & ~shrine

    # Le générateur a inclus une ombre douce au pied des bordures. La comparaison au sol complet
    # sert uniquement à isoler cette bande, pas à repeindre la matière.
    under_value = lum(underlay)
    edge_distance = nd.distance_transform_edt(ground)
    shadow = ground & (edge_distance <= 26) & (value < under_value - 7) & (value < 165)
    shadow = keep_large(close_edge(shadow, 1), 40) & ground
    floor = ground & ~shadow

    # La jungle est le fond hors enveloppe, plus les végétations/avant-plans identifiés dedans.
    # Les inconnus de l'enveloppe sont déjà affectés au sol ci-dessus.
    jungle = ((~ground_envelope) | (ground_envelope & raw_foliage) |
              (ground_envelope & foreground_candidates)) & ~rock & ~shrine
    foreground = foreground_candidates & jungle
    foreground = nd.binary_closing(foreground, iterations=2) & jungle
    jungle_only = jungle & ~foreground

    # La silhouette complétée reste sur le calque sanctuaire ; les autres composantes sur roches.
    stones = rock & ~shrine

    masks = {
        'clairiere': floor,
        'ombres': shadow,
        'jungle': jungle_only,
        'roches': stones,
        'sanctuaire': shrine,
        'canopee_avant': foreground,
    }
    # La partition n'inclut pas les calques générés ultérieurement (feuilles) : elle doit couvrir le brut.
    coverage = np.sum(np.stack(list(masks.values()), axis=0), axis=0)
    if not np.all(coverage == 1):
        raise AssertionError(f'Partition pleine résolution invalide : min={coverage.min()}, max={coverage.max()}')
    meta = {
        'source_floor_pixels': int(source_floor.sum()),
        'ground_envelope_pixels': int(ground_envelope.sum()),
        'unclassified_floor_pixels': int(unclassified_floor.sum()),
        'foliage_preserved_inside_arena_pixels': int((ground_envelope & raw_foliage).sum()),
        'small_stone_assigned_to_floor_pixels': int(small_stone_floor.sum()),
        'walkable_floor_pixels': int(ground.sum()),
        'shadow_pixels': int(shadow.sum()),
        'rock_pixels': int(rock.sum()),
        'shrine_pixels': int(shrine.sum()),
        'foliage_pixels': int(jungle.sum()),
        'foreground_pixels': int(foreground.sum()),
        'shrine_roi_raw_xyxy': [int(ww * .35), int(hh * .10), int(ww * .65), int(hh * .42)],
        'shrine_polygon_raw_xy': [list(point) for point in SHRINE_POLYGON_RAW],
        'stone_color_correction': 'warm neutral gray from luminance: [Y-30, Y-30, Y-44], no green channel dominance',
    }
    return masks, meta


def quantized_layers(a, underlay, *, masks_override=None, night=False):
    if masks_override is None:
        masks, segmentation = classify(a, underlay)
    else:
        masks = masks_override
        segmentation = {
            'geometry_source': 'partition pleine résolution du décor jour réutilisée pour conserver le même layout 4:3',
            'mask_pixels': {name: int(mask.sum()) for name, mask in masks.items()},
            'stone_color_correction': 'blue-grey neutral from luminance: [Y-12, Y-4, Y+5], no green channel dominance' if night else 'gray warm neutral from luminance: [Y-30, Y-30, Y-44], no green channel dominance',
        }
    order = ['clairiere', 'ombres', 'jungle', 'roches', 'sanctuaire', 'canopee_avant']
    exclusive, colors = JM.down_class(a, masks, order)
    full = JM.rgba(JM.down_full(underlay), np.ones((H, W), bool))
    layers = {'sol_complet': full}
    for name in order:
        layers[name] = JM.rgba(colors[name], exclusive[name])
    layers['roches'] = neutralize_stone(layers['roches'], night=night)
    layers['sanctuaire'] = neutralize_stone(layers['sanctuaire'], night=night)

    output = {}
    for cfg in PALETTE_GROUPS.values():
        selected = {name: layers[name] for name in cfg['layers']}
        output.update(quantize_group(selected, cfg['colors']))
    # Une palette MEDIANCUT sans dither par matière ; les pixels transparents restent RGB 0.
    return output, exclusive, segmentation, masks


def neutralize_stone(layer, night=False):
    """Neutraliser les pierres sans dominante verte, alpha et relief préservés."""
    out = layer.copy()
    opaque = out[..., 3] > 0
    value = lum(out[..., :3])
    if night:
        neutral = np.stack((value - 12, value - 4, value + 5), axis=-1)
    else:
        neutral = np.stack((value - 30, value - 30, value - 44), axis=-1)
    out[..., :3][opaque] = np.clip(neutral[opaque], 0, 255).astype('uint8')
    out[~opaque] = 0
    return out


def night_light_frames(phases=range(PHASES)):
    """Générer des halos cyan/menthe très transparents et des lucioles discrètes."""
    yy, xx = np.mgrid[:H, :W].astype(np.float32)
    points = [
        (126, 202, (131, 224, 207), 1),
        (644, 203, (154, 229, 204), 7),
        (105, 340, (138, 211, 229), 12),
        (665, 342, (177, 229, 173), 18),
        (254, 410, (205, 211, 151), 5),
        (521, 411, (142, 219, 215), 14),
        (363, 179, (172, 223, 206), 9),
    ]
    frames = []
    for phase in phases:
        opacity = np.zeros((H, W), dtype=np.float32)
        color_weight = np.zeros((H, W, 3), dtype=np.float32)

        def add_glow(cx, cy, sigma_x, sigma_y, peak, color, pulse=1.0):
            nonlocal opacity, color_weight
            gaussian = np.exp(-0.5 * (((xx - cx) / sigma_x) ** 2 + ((yy - cy) / sigma_y) ** 2))
            contribution = np.clip(peak * pulse * gaussian, 0, 64) / 255.0
            contribution[contribution < 0.25 / 255.0] = 0
            opacity = 1.0 - (1.0 - opacity) * (1.0 - contribution)
            color_weight += contribution[..., None] * np.asarray(color, dtype=np.float32)

        # Brume autour du sanctuaire : large et très légère, sans aplat opaque.
        shrine_pulse = 0.88 + 0.12 * (0.5 + 0.5 * np.sin(2 * np.pi * phase / PHASES))
        add_glow(W * .5, 138, 49, 37, 26, (107, 195, 219), shrine_pulse)
        for x, y, color, offset in points:
            angle = 2 * np.pi * (phase + offset) / PHASES
            pulse = 0.30 + 0.70 * (0.5 + 0.5 * np.sin(angle))
            cx = x + 1.5 * np.sin(angle)
            cy = y + 1.2 * np.cos(angle * 0.75)
            add_glow(cx, cy, 10, 12, 13, color, pulse)
            add_glow(cx, cy, 2.3, 2.3, 35, color, pulse)

        frame = np.zeros((H, W, 4), dtype=np.uint8)
        valid = opacity > 0
        frame[valid, :3] = np.clip(color_weight[valid] / np.maximum(opacity[valid, None], 1e-8), 0, 255).astype('uint8')
        frame[..., 3] = np.clip(np.round(opacity * 255), 0, 64).astype('uint8')
        frame[~valid] = 0
        frames.append(frame)
    return frames


def quantize_group(layers, colors):
    opaque = [layer[layer[..., 3] == 255][:, :3] for layer in layers.values()]
    opaque = [a for a in opaque if len(a)]
    if not opaque:
        raise ValueError('Groupe palette vide')
    pixels = np.concatenate(opaque).astype('uint8')
    q = Image.fromarray(pixels.reshape(-1, 1, 3)).quantize(
        colors=colors, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    palette = np.asarray(q.getpalette()[:colors * 3], dtype=np.uint8).reshape(-1, 3)
    result = {}
    for name, layer in layers.items():
        out = layer.copy()
        opaque_mask = out[..., 3] == 255
        if opaque_mask.any():
            mapped = np.asarray(Image.fromarray(out[..., :3]).quantize(palette=q, dither=Image.Dither.NONE))
            out[..., :3] = palette[mapped]
        out[~opaque_mask] = 0
        result[name] = out
    return result


def green_palette(layer):
    pixels = layer[layer[..., 3] == 255][:, :3].astype(np.int16)
    select = (pixels[:, 1] > pixels[:, 0] + 5) & (pixels[:, 1] > pixels[:, 2] + 8)
    pixels = pixels[select]
    if len(pixels) < 3:
        raise ValueError('Palette de feuillage insuffisante pour les feuilles animées')
    value = pixels @ np.array([0.299, 0.587, 0.114])
    order = np.argsort(value)
    return [tuple(int(c) for c in pixels[order[int((len(order) - 1) * q)]]) for q in (0.18, 0.55, 0.90)]


def leaf_sprite(palette, variant=0):
    # Forme 5 × 5, pixels de palette prélevés sur la végétation du décor généré.
    pattern = np.array([
        [-1, -1, 2, -1, -1],
        [-1, 2, 1, 2, -1],
        [2, 1, 1, 0, -1],
        [-1, 2, 1, 0, -1],
        [-1, -1, 2, -1, -1],
    ], dtype=int)
    if variant:
        pattern = np.rot90(pattern, 1)
    sprite = np.zeros((5, 5, 4), dtype=np.uint8)
    for idx, color in enumerate(palette):
        selected = pattern == idx
        sprite[..., :3][selected] = color
        sprite[..., 3][selected] = 255
    return sprite


def leaf_frames(walk, foliage_layer, ts=range(PHASES)):
    palette = green_palette(foliage_layer)
    sprites = [leaf_sprite(palette, 0), leaf_sprite(palette, 1)]
    inside = nd.distance_transform_edt(walk)
    edge = walk & (inside <= 18)
    yy, xx = np.mgrid[:H, :W]
    edge &= (yy > 24) & (yy < H - 34) & (xx > 24) & (xx < W - 24)
    candidates = np.argwhere(edge)
    rng = np.random.default_rng(20261003)
    rng.shuffle(candidates)
    emitters = []
    for y, x in candidates:
        y, x = int(y), int(x)
        if any(max(abs(x - e['x']), abs(y - e['y'])) < 44 for e in emitters):
            continue
        sense = 1 if y < H * .50 else -1
        path_ok = True
        for k in range(12):
            cy = y + sense * int(round(k * 1.15))
            cx = x + int(round(2 * np.sin(2 * np.pi * k / 12)))
            y0, x0 = cy - 2, cx - 2
            if y0 < 0 or x0 < 0 or y0 + 5 > H or x0 + 5 > W or not walk[y0:y0 + 5, x0:x0 + 5].all():
                path_ok = False
                break
        if path_ok:
            emitters.append({'x': x, 'y': y, 'offset': len(emitters) * 3 % PHASES,
                             'direction': sense, 'variant': len(emitters) % 2})
        if len(emitters) >= 8:
            break
    if len(emitters) < 4:
        raise AssertionError(f'Trop peu de départs de feuilles sûrs : {len(emitters)}')

    frames = []
    for t in ts:
        frame = np.zeros((H, W, 4), dtype=np.uint8)
        for e in emitters:
            k = (int(t) + e['offset']) % PHASES
            if k >= 12:
                continue
            cx = e['x'] + int(round(2 * np.sin(2 * np.pi * k / 12)))
            cy = e['y'] + e['direction'] * int(round(k * 1.15))
            sprite = sprites[e['variant']]
            x0, y0 = cx - 2, cy - 2
            for sy in range(5):
                for sx in range(5):
                    if sprite[sy, sx, 3] and walk[y0 + sy, x0 + sx]:
                        frame[y0 + sy, x0 + sx] = sprite[sy, sx]
        frames.append(frame)
    return frames, emitters, palette, sprites


def save_ora(path, layers, title='Fin Clairière tropicale (FCT2)'):
    root = ET.Element('image', w=str(W), h=str(H), name=title)
    stack = ET.SubElement(root, 'stack')
    composite = Image.new('RGBA', (W, H))
    with zipfile.ZipFile(path, 'w', zipfile.ZIP_DEFLATED) as archive:
        archive.writestr('mimetype', 'image/openraster', compress_type=zipfile.ZIP_STORED)
        for i, (name, image) in reversed(list(enumerate(layers.items()))):
            filename = f'data/layer{i:02d}.png'
            ET.SubElement(stack, 'layer', name=name, src=filename, x='0', y='0', opacity='1.0',
                          visibility='visible', **{'composite-op': 'svg:src-over'})
            buf = io.BytesIO()
            Image.fromarray(image).save(buf, format='PNG')
            archive.writestr(filename, buf.getvalue())
        for image in layers.values():
            composite.alpha_composite(Image.fromarray(image))
        buf = io.BytesIO(); composite.save(buf, format='PNG'); archive.writestr('mergedimage.png', buf.getvalue())
        thumb = composite.copy(); thumb.thumbnail((256, 256))
        buf = io.BytesIO(); thumb.save(buf, format='PNG'); archive.writestr('Thumbnails/thumbnail.png', buf.getvalue())
        archive.writestr('stack.xml', ET.tostring(root, encoding='utf-8', xml_declaration=True))


def reconstruction_metrics(source_rgb, rendered_scene):
    """Mesurer l'écart de l'assemblage multicalque au brut généré réduit uniformément."""
    target = JM.down_full(source_rgb).astype(np.int16)
    actual = np.asarray(rendered_scene.convert('RGB'), dtype=np.int16)
    if actual.shape != target.shape:
        raise AssertionError(f'Comparaison de reconstruction incompatible : {actual.shape}/{target.shape}')
    error = np.abs(actual - target)
    max_channel = error.max(2)
    return {
        'source_size_px': [SRC[0], SRC[1]],
        'render_size_px': [W, H],
        'mean_absolute_rgb_error': round(float(error.mean()), 3),
        'mean_max_channel_error': round(float(max_channel.mean()), 3),
        'p95_max_channel_error': round(float(np.percentile(max_channel, 95)), 2),
        'pixels_with_max_channel_error_le_8_percent': round(float(100 * np.mean(max_channel <= 8)), 2),
        'pixels_with_max_channel_error_le_16_percent': round(float(100 * np.mean(max_channel <= 16)), 2),
        'comparison': 'assemblage des calques statiques contre image générée réduite BOX à échelle uniforme ; palettes matière et neutralisation pierre peuvent modifier les pixels',
    }


def export_variant_assets(prefix, variant_dir, stack, blocked, markers, exclusive, sprites,
                          *, ora_name, ora_title):
    for folder in ('calques', 'animation/feuilles', 'animation/lumieres', 'masques', 'review', 'poses'):
        (variant_dir / folder).mkdir(parents=True, exist_ok=True)
    for name, mask in exclusive.items():
        Image.fromarray((mask * 255).astype('uint8')).save(variant_dir / 'masques' / f'{prefix}_masque_{name}.png')
    for index, sprite in enumerate(sprites):
        Image.fromarray(sprite).save(variant_dir / 'poses' / f'{prefix}_feuille_pose_{index}.png')

    layer_manifest = []
    for index, (name, slug, frames, ticks, draw) in enumerate(stack):
        if len(frames) == 1:
            filename = f'calques/{prefix}_{index:02d}_{name}.png'
            Image.fromarray(frames[0]).save(variant_dir / filename)
        else:
            folder = 'lumieres' if name == 'lumieres' else 'feuilles'
            filename = f'animation/{folder}/{prefix}_{index:02d}_{name}_fNN.png'
            for phase, frame in enumerate(frames):
                Image.fromarray(frame).save(variant_dir / filename.replace('fNN', f'f{phase:02d}'))
        layer_manifest.append({
            'name': name,
            'file': filename,
            'phases': len(frames),
            'ticks': ticks,
            'draw_layer': draw,
        })

    ora_layers = {f'{index:02d}_{name}' + ('_f00' if len(frames) > 1 else ''): frames[0]
                  for index, (name, _, frames, _, _) in enumerate(stack)}
    save_ora(variant_dir / ora_name, ora_layers, ora_title)

    review_frames = [composite_scene(stack, tick) for tick in range(0, LOOP_TICKS, TICKS)]
    review_frames[0].save(variant_dir / 'review' / f'{prefix}_scene_t000.png')
    review_frames[0].save(variant_dir / 'review' / f'{prefix}_scene_animee.webp', save_all=True,
                          append_images=review_frames[1:], duration=round(TICKS * 1000 / 60), loop=0, lossless=True)
    draw_collision_review(review_frames[0], blocked, markers).save(
        variant_dir / 'review' / f'{prefix}_collisions_marqueurs.png')
    pose_sheet = Image.new('RGBA', (7 * 44, 44), (20, 42, 32, 255))
    for i, sprite in enumerate(sprites):
        enlarged = Image.fromarray(sprite).resize((20, 20), Image.Resampling.NEAREST)
        pose_sheet.alpha_composite(enlarged, (i * 44 + 12, 12))
    pose_sheet.save(variant_dir / 'review' / f'{prefix}_planche_poses.png')
    return layer_manifest, review_frames


def ground_project(stack, blocked, markers, codec, index_tools, *, prefix=PFX, asset=ASSET,
                   map_title='Fin Clairière tropicale - sanctuaire de la jungle (4:3)',
                   night=False, reset_stage=True):
    if not TEMPLATE.is_file():
        raise FileNotFoundError(f'Gabarit PMDO 0.8.12 manquant : {TEMPLATE}')
    if reset_stage:
        shutil.rmtree(STAGE, ignore_errors=True)
    tpl = json.loads(TEMPLATE.read_text(encoding='utf-8-sig'))
    obj = tpl['Object']
    gw, gh = W // 8, H // 8
    ground_layers, banks = [], []
    display_titles = {
        'sol_complet': 'Sol complet',
        'clairiere': 'Clairière',
        'ombres': 'Ombres',
        'jungle': 'Jungle',
        'roches': 'Roches',
        'sanctuaire': 'Sanctuaire',
        'feuilles': 'Feuilles',
        'lumieres': 'Lumières',
        'canopee_avant': 'Canopée avant',
    }

    for i, (title, slug, frames, ticks, draw) in enumerate(stack):
        bank = codec.TileBank(f'{prefix}_{i:02d}_{slug}')
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

        ground_layers.append(codec.layer(f'{i:02d} {display_titles.get(title, title)}', gw, gh, cell, ticks, draw=draw))
        banks.append(bank)

    # Calque natif d'avant-plan, séparé, puis calque Top vide pour l'édition dans PMDO.
    ground_layers.append(codec.layer(f'{len(ground_layers):02d} Top (vide)', gw, gh, draw=4))
    for bank in banks:
        bank.write(STAGE / f'Content/Tile/{bank.name}.tile')

    obj.update(
        Name={'DefaultText': map_title, 'LocalTexts': {}},
        AssetName=asset,
        Released=False,
        TexSize=1,
        Music='',
        EdgeView=1,
        ViewCenter=None,
        ViewOffset={'X': 0, 'Y': 0},
        ActiveChar=None,
        Status={},
        Layers=ground_layers,
        Background={'$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence', 'Layers': []},
        Comment=(
            'PMDO 0.8.12. Fin de donjon au style Southern Jungle : décor généré à partir de la référence D54P32A, '
            'textures non natives reconstruites en calques et tuiles de 8 px. '
            + ('Étalonnage nuit bleu-vert et lumières translucides calculées.' if night else 'Pierre corrigée en gris chaud ; feuilles animées calculées.')
            + ' Arrivée au sud, arène au centre, sanctuaire au nord. Aucun warp ni destination configurée.'
        ),
    )
    obj['obstacles'] = [
        [{'Bounds': {'X': x * 8, 'Y': y * 8, 'Width': 8, 'Height': 8}, 'Tags': int(blocked[y, x])}
         for y in range(gh)] for x in range(gw)
    ]
    make_marker = lambda name, point, direction: {
        'EntName': name, 'Direction': direction, 'EntEnabled': True, 'triggerType': 0,
        'Collider': {'X': int(point[0]), 'Y': int(point[1]), 'Width': 16, 'Height': 16},
    }
    obj['Entities'] = [{
        'Name': 'Arrivee, boss et objectif', 'Visible': True, 'MapChars': [], 'GroundObjects': [], 'Spawners': [],
        'Markers': [
            make_marker('entrance', markers['entrance'], 0),
            make_marker('boss', markers['boss'], 4),
            make_marker('objectif', markers['objectif'], 0),
        ],
    }]
    obj['Decorations'] = [{'Name': 'Vos decorations', 'Layer': 2, 'Visible': True, 'Anims': []}]
    tpl['Version'] = '0.8.12.0'
    stage_ground = STAGE / f'Data/Ground/{asset}.rsground'
    codec.save(stage_ground, json.dumps(tpl, ensure_ascii=False, separators=(',', ':')).encode())
    codec.save(STAGE / f'Data/Script/ground/{asset}/init.lua',
               f'-- {asset} : base d edition, aucun warp.\nlocal {asset} = {{}}\nreturn {asset}\n'.encode())

    nodes = {}
    for path in sorted((STAGE / 'Content/Tile').glob('*.tile')):
        with path.open('rb') as stream:
            nodes[path.stem] = index_tools.read_node(stream)
    (STAGE / 'Content/Tile/index.idx').write_bytes(index_tools.encode_index(nodes))

    mod_uuid = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/projet-creation-pmdo/' + NAMESPACE)
    (STAGE / 'Mod.xml').write_text(f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Fin Clairière tropicale 4:3 - Atelier PMDO 0.8.12</Name>
  <Author>meromoonmeri</Author>
  <Description>Projet d'édition : clairière d'arène de fin, variantes jour et nuit ; textures générées en référence à Southern Jungle D54P32A, calques natifs 8 px. Pas une aventure jouable.</Description>
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
    if needle not in installer:
        raise AssertionError('Point d insertion INSTALLER.py inattendu')
    installer = installer.replace(needle, needle + "            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n")
    (STAGE / 'INSTALLER.py').write_text(installer, encoding='utf-8')
    (STAGE / 'README.md').write_text((HERE / 'README_PACK.md').read_text(encoding='utf-8'), encoding='utf-8')
    return {bank.name: len(bank.data) for bank in banks}


def choose_markers(blocked, walk, shrine):
    gh, gw = blocked.shape

    def free(x, y):
        return 0 <= x < gw - 1 and 0 <= y < gh - 1 and not blocked[y:y + 2, x:x + 2].any()

    bottom = [(x, y) for y in range(gh - 2, max(-1, gh - 8), -1) for x in range(gw)
              if free(x, y)]
    if not bottom:
        raise AssertionError('Aucune arrivée 16×16 praticable au sud')
    entry_cell = min(bottom, key=lambda p: (abs(p[0] + 1 - gw / 2), gh - 2 - p[1]))

    walk_y, walk_x = np.nonzero(walk)
    target_boss = (int(np.median(walk_x)) // 8, int(np.median(walk_y)) // 8)
    boss_candidates = [(x, y) for y in range(gh) for x in range(gw) if free(x, y)
                       and gh * 0.30 <= y <= gh * 0.72]
    boss_cell = min(boss_candidates, key=lambda p: (p[0] - target_boss[0]) ** 2 + (p[1] - target_boss[1]) ** 2)

    sy, sx = np.nonzero(shrine)
    target_x = int(round(float(sx.mean()) / 8)) if len(sx) else gw // 2
    target_y = int(sy.max() // 8) + 2 if len(sy) else int(gh * .28)
    obj_candidates = [(x, y) for y in range(gh) for x in range(gw) if free(x, y)
                      and y < boss_cell[1] - 6 and abs(x - target_x) < gw // 5]
    if not obj_candidates:
        raise AssertionError('Aucune case 16×16 libre au pied du sanctuaire')
    objective_cell = min(obj_candidates, key=lambda p: (p[0] - target_x) ** 2 + (p[1] - target_y) ** 2)

    markers = {
        'entrance': [entry_cell[0] * 8, entry_cell[1] * 8],
        'boss': [boss_cell[0] * 8, boss_cell[1] * 8],
        'objectif': [objective_cell[0] * 8, objective_cell[1] * 8],
    }
    path_boss, explored_boss = PATHS.reachable(blocked, (entry_cell[1], entry_cell[0]), (boss_cell[1], boss_cell[0]))
    path_objective, explored_objective = PATHS.reachable(blocked, (entry_cell[1], entry_cell[0]),
                                                         (objective_cell[1], objective_cell[0]))
    if not path_boss or not path_objective:
        raise AssertionError(f'Chemin de 16×16 absent : boss={path_boss}, objectif={path_objective}')
    return markers, {
        'path_found_16x16': True,
        'path_to_boss': path_boss,
        'path_to_objective': path_objective,
        'cells_explored_boss': explored_boss,
        'cells_explored_objective': explored_objective,
        'entry_cell': list(entry_cell),
        'boss_cell': list(boss_cell),
        'objective_cell': list(objective_cell),
    }


def build():
    prepared_inputs = prepare_generated_inputs()
    if not REF.is_file():
        raise FileNotFoundError(f'Référence canonique absente : {REF}')
    for raw in ('decor.png', 'sol_complet.png', 'decor_nuit.png', 'sol_complet_nuit.png'):
        if not (RAW / raw).is_file():
            raise FileNotFoundError(f'Brut généré absent : {RAW / raw}')

    codec = loadmod('fct2_pmdo_codec', ROOT / 'source/pmdo_cote/build.py')
    index_tools = loadmod('fct2_index_tools', ROOT / 'source/pmdo_cote/INSTALLER.py')
    OUT.mkdir(parents=True, exist_ok=True)
    for folder in ('calques', 'animation', 'masques', 'review', 'poses', 'nuit'):
        shutil.rmtree(OUT / folder, ignore_errors=True)
    for folder in ('calques', 'animation/feuilles', 'animation/lumieres', 'masques', 'review', 'poses'):
        (OUT / folder).mkdir(parents=True, exist_ok=True)
    shutil.copyfile(HERE / 'viewer.html', OUT / 'review/index.html')
    (OUT / 'index.html').write_text(
        '<!doctype html><html lang="fr"><meta charset="utf-8">'
        '<meta http-equiv="refresh" content="0; url=review/">'
        '<title>FCT2 — Fin Clairière tropicale</title>'
        '<p><a href="review/">Ouvrir le viewer FCT2</a></p></html>\n',
        encoding='utf-8')
    (OUT / 'nuit').mkdir(parents=True, exist_ok=True)
    STAGE.parent.mkdir(parents=True, exist_ok=True)

    decor = rgb(RAW / 'decor.png')
    underlay = rgb(RAW / 'sol_complet.png')
    decor_night = rgb(RAW / 'decor_nuit.png')
    underlay_night = rgb(RAW / 'sol_complet_nuit.png')
    reference = rgb(REF)
    for name, image in (('décor jour', decor), ('sol jour', underlay),
                        ('décor nuit', decor_night), ('sol nuit', underlay_night)):
        if image.shape[:2] != (SRC[1], SRC[0]):
            raise AssertionError(f'Taille brute attendue {SRC} pour {name}, reçue {image.shape}')

    generation_manifest, raw_inputs = [], []
    for entry in GEN:
        generated = HERE / entry['source']
        prep = prepared_inputs[entry['target']]
        generation_manifest.append({
            **entry,
            'file': f'source/{LOT}/{entry["source"]}',
            'sha256': sha(generated),
            'size_px': list(Image.open(generated).size),
            'preparation': prep,
        })
        raw_inputs.append({
            'file': f'source/{LOT}/bruts/{entry["target"]}',
            'sha256': sha(RAW / entry['target']),
            'size_px': list(Image.open(RAW / entry['target']).size),
            'generator_file': f'source/{LOT}/{entry["source"]}',
            'generator_sha256': prep['generator_sha256'],
            'variant': entry['variant'],
            'role': entry['role'],
            'target': entry['target'],
            'images': entry['images'],
        })

    raw_fidelity = fidelity(decor, reference)
    for material, data in raw_fidelity.items():
        if data['distance'] is None or data['distance'] >= FIDELITY_MAX:
            raise AssertionError(f'Fidélité canonique jour hors seuil {FIDELITY_MAX} : {material} {data}')

    layers, exclusive, segmentation, masks = quantized_layers(decor, underlay)
    # Le rendu de nuit est lui aussi une sortie indépendante du générateur. On réutilise
    # seulement la partition géométrique du jour pour garantir un découpage parfaitement
    # aligné ; toutes ses couleurs viennent du brut nocturne correspondant.
    night_layers, night_exclusive, night_segmentation, night_masks = quantized_layers(
        decor_night, underlay_night, masks_override=masks, night=True)
    if any(not np.array_equal(masks[name], night_masks[name]) for name in masks):
        raise AssertionError('Les variantes ne partagent pas leur partition géométrique')
    walk = (layers['clairiere'][..., 3] == 255) | (layers['ombres'][..., 3] == 255)
    night_walk = (night_layers['clairiere'][..., 3] == 255) | (night_layers['ombres'][..., 3] == 255)
    blocked = BM.cell_grid(~walk)
    night_blocked = BM.cell_grid(~night_walk)
    if blocked.shape != (H // 8, W // 8) or not np.array_equal(blocked, night_blocked):
        raise AssertionError(f'Grilles de collision jour/nuit incompatibles : {blocked.shape}/{night_blocked.shape}')
    markers, access = choose_markers(blocked, walk, exclusive['sanctuaire'])
    night_markers, night_access = choose_markers(night_blocked, night_walk, night_exclusive['sanctuaire'])
    if markers != night_markers or access['path_found_16x16'] != night_access['path_found_16x16']:
        raise AssertionError('Marqueurs ou accès diffèrent entre les variantes')

    # Les deux illustrations autonomes sortent du générateur avec leur propre palette.
    palette = green_palette(layers['jungle'])
    leaves, emitters, palette, sprites = leaf_frames(walk, layers['jungle'])
    night_palette = green_palette(night_layers['jungle'])
    night_leaves, night_emitters, night_palette, night_sprites = leaf_frames(night_walk, night_layers['jungle'])
    static_order = ['sol_complet', 'clairiere', 'ombres', 'jungle', 'roches', 'sanctuaire']
    day_stack = [(name, name.upper(), [layers[name]], 60, 0) for name in static_order]
    day_stack += [('feuilles', 'FEUILLES', leaves, TICKS, 0),
                  ('canopee_avant', 'CANOP_FG', [layers['canopee_avant']], 60, 4)]
    lights = night_light_frames()
    light_max_alpha = max(int(frame[..., 3].max()) for frame in lights)
    light_min_positive = min(int(frame[..., 3][frame[..., 3] > 0].min()) for frame in lights)
    if light_max_alpha > 64 or not (0 < light_min_positive <= light_max_alpha):
        raise AssertionError(f'Opacité des lumières hors limite basse : {light_min_positive}..{light_max_alpha}')
    night_stack = [(name, name.upper(), [night_layers[name]], 60, 0) for name in static_order]
    night_stack += [('feuilles', 'FEUILLES', night_leaves, TICKS, 0),
                    ('lumieres', 'LUMIERES', lights, TICKS, 0),
                    ('canopee_avant', 'CANOP_FG', [night_layers['canopee_avant']], 60, 4)]

    day_layers_manifest, day_review_frames = export_variant_assets(
        PFX, OUT, day_stack, blocked, markers, exclusive, sprites,
        ora_name=f'{PFX}_fin_clairiere_tropicale_calques.ora',
        ora_title='Fin Clairière tropicale — jour (FCT2)')
    night_layers_manifest, night_review_frames = export_variant_assets(
        PFX_NIGHT, OUT / 'nuit', night_stack, night_blocked, night_markers, night_exclusive, night_sprites,
        ora_name=f'{PFX_NIGHT}_fin_clairiere_tropicale_nuit_calques.ora',
        ora_title='Fin Clairière tropicale — nuit (FCT2N)')

    day_static_stack = [layer for layer in day_stack if layer[0] != 'feuilles']
    night_static_stack = [layer for layer in night_stack if layer[0] not in ('feuilles', 'lumieres')]
    reconstruction = {
        'jour': reconstruction_metrics(decor, composite_scene(day_static_stack, 0)),
        'nuit': reconstruction_metrics(decor_night, composite_scene(night_static_stack, 0)),
        'scope': 'comparaison des couches statiques ; animations de feuilles et lumières sont des ajouts au décor généré',
    }

    final_fidelity = {}
    reference_materials = materials(reference)
    layer_for_material = {
        'clairiere': ['clairiere', 'ombres'],
        'feuillage': ['jungle', 'canopee_avant'],
        'pierre': ['roches', 'sanctuaire'],
    }
    for material, names in layer_for_material.items():
        reference_mean = reference[reference_materials[material]].astype(np.float64).mean(0)
        selected = [layers[name][layers[name][..., 3] == 255][:, :3].astype(np.uint8) for name in names]
        selected = [pixels for pixels in selected if len(pixels)]
        pixels = np.concatenate(selected)
        final_mask = materials(pixels.reshape(-1, 1, 3))[material][:, 0]
        pixels = pixels[final_mask].astype(np.float64)
        if len(pixels) < 50:
            raise AssertionError(f'Pas assez de pixels finaux classés {material}: {len(pixels)}')
        mean = pixels.mean(0)
        distance = float(np.linalg.norm(mean - reference_mean))
        final_fidelity[material] = {
            'rgb_final': [round(float(v), 1) for v in mean],
            'rgb_rip': [round(float(v), 1) for v in reference_mean],
            'distance': round(distance, 2),
            'seuil': FIDELITY_MAX,
        }
        if distance >= FIDELITY_MAX:
            raise AssertionError(f'Fidélité des calques jour hors seuil {FIDELITY_MAX} : {material} {final_fidelity[material]}')

    day_bank_counts = ground_project(
        day_stack, blocked, markers, codec, index_tools,
        prefix=PFX, asset=ASSET,
        map_title='Fin Clairière tropicale - jour (4:3)', night=False, reset_stage=True)
    night_bank_counts = ground_project(
        night_stack, night_blocked, night_markers, codec, index_tools,
        prefix=PFX_NIGHT, asset=ASSET_NIGHT,
        map_title='Fin Clairière tropicale - nuit (4:3)', night=True, reset_stage=False)
    all_bank_counts = {**day_bank_counts, **night_bank_counts}

    day_animation = {
        'feuilles': {
            'phases': PHASES,
            'frame_length_ticks': TICKS,
            'loop_ticks': LOOP_TICKS,
            'sprites': '2 sprites 5x5 calculés ; palette prélevée dans le calque de végétation généré, sans recoloration de textures PMD',
            'palette_rgb': [list(c) for c in palette],
            'emitters': emitters,
            'active_phases': 12,
            'hidden_phases': 12,
            'law': 'k=(tick+offset) modulo 24 ; chute de 1,15 px par phase, balancier sinusoïdal ; inactive sur les 12 phases suivantes',
            'origin': 'animation ajoutée par nous, pas une animation officielle PMD',
        },
    }
    night_animation = {
        'feuilles': {
            'phases': PHASES,
            'frame_length_ticks': TICKS,
            'loop_ticks': LOOP_TICKS,
            'sprites': '2 sprites 5x5 calculés ; palette prélevée dans le calque de végétation de la carte nuit générée',
            'palette_rgb': [list(c) for c in night_palette],
            'emitters': night_emitters,
            'active_phases': 12,
            'hidden_phases': 12,
            'law': 'k=(tick+offset) modulo 24 ; chute de 1,15 px par phase, balancier sinusoïdal ; inactive sur les 12 phases suivantes',
            'origin': 'animation ajoutée par nous à la carte nuit générée, pas une animation officielle PMD',
        },
        'lumieres': {
            'phases': PHASES,
            'frame_length_ticks': TICKS,
            'loop_ticks': LOOP_TICKS,
            'alpha_min_positive': light_min_positive,
            'alpha_max': light_max_alpha,
            'max_opacity_percent': round(100 * light_max_alpha / 255, 1),
            'colors': 'cyan, menthe et ambre doux ; opacité partielle, halos derrière la canopée avant',
            'sources_px': [[126, 202], [644, 203], [105, 340], [665, 342], [254, 410], [521, 411], [363, 179]],
            'origin': 'lucioles et halo du sanctuaire générés par ce lot ; non repris d une animation PMD',
        },
    }
    variants = {
        'jour': {
            'prefix': PFX, 'asset': ASSET, 'output_dir': '.',
            'layers': day_layers_manifest, 'banks': day_bank_counts,
            'animation': day_animation, 'review_scene': f'review/{PFX}_scene_t000.png',
            'ora': f'{PFX}_fin_clairiere_tropicale_calques.ora',
            'fidelity': final_fidelity,
        },
        'nuit': {
            'prefix': PFX_NIGHT, 'asset': ASSET_NIGHT, 'output_dir': 'nuit',
            'layers': night_layers_manifest, 'banks': night_bank_counts,
            'animation': night_animation, 'review_scene': f'nuit/review/{PFX_NIGHT}_scene_t000.png',
            'ora': f'nuit/{PFX_NIGHT}_fin_clairiere_tropicale_nuit_calques.ora',
            'generation_source': 'illustration autonome nocturne générée séparément avec référence canonique ; couleurs non dérivées par simple filtre de la carte jour',
            'partition_geometry': 'masques jour réutilisés pour conserver le layout commun ; couleurs calculées depuis les pixels de la carte nuit générée',
            'lighting': night_animation['lumieres'],
            'fidelity_comparison': 'non appliquée : carte générée séparément en palette nocturne ; contrôles pixel à pixel des calques et de leur sérialisation restent actifs',
        },
    }

    manifest = {
        'lot': LOT,
        'prefix': PFX,
        'format': '4:3 vaste',
        'type': 'fin de donjon',
        'size_px': [W, H],
        'grid_8px': [W // 8, H // 8],
        'lineage': {
            'continues': 'série des fins de donjon après FST1 (Fin Star Cave)',
            'prefix_choice': 'FCT2 (jour) et FCT2N (nuit), deux variantes du même lot ; FTC1 est réservé par une branche sœur ; aucune carte sœur n a été reprise.',
        },
        'biome': 'clairière tropicale de Southern Jungle',
        'method': 'illustrations autonomes jour et nuit générées par le générateur d image avec le rip canonique D54P32A comme référence ; sous-sols assortis générés séparément ; segmentation par matière avant réduction uniforme BOX pondérée par classe, correction pierre, palettes par matière et export PMDO 0.8.12',
        'reference_da': {
            'file': 'source/fin_clairiere_tropicale_v1/reference/D54P32A.png',
            'sha256': sha(REF),
            'source': 'pret/pmd-sky, commit c8073235b39746a7ee74e6cea16c730bd91a1e67, MAP_BG D54P32A (BMA/BPC/BPL D54P32A)',
            'identification': 'Southern_Jungle_exit_2_S.png ; écart de capture 0,0 dans index_rom.json',
            'size_px': [600, 456],
            'frames': 1,
            'status': 'référence PMD authentique, identification de scène documentée par capture ; textures du lot générées, non natives',
        },
        'generation': generation_manifest,
        'raw_inputs': raw_inputs,
        'normalization': {
            'scale_uniforme': SCALE,
            'scaled_size': [SCALED_W, H],
            'crop_x': [CROP_X, SCALED_W - W - CROP_X],
            'generated_inputs_preparation': prepared_inputs,
            'method': 'entrées générateur ajustées uniformément à 1200×896 sans étirement ; segmentation avant réduction ; moyenne BOX pondérée par classe, attribution exclusive par poids maximal ; palette MEDIANCUT sans dither',
            'palette_groups': PALETTE_GROUPS,
        },
        'segmentation': {
            'method': 'classifieur matière sur le brut ; enveloppe de clairière reliée au sud ; pixels inconnus dedans affectés au sol ; végétation séparée ; silhouette du sanctuaire complétée manuellement avant réduction',
            'source_floor': 'r>112, g>120, g-b>32, r-b>28, |g-r|<58, hors végétation ; fermeture/remplissage de l’enveloppe, composante reliée au sud',
            'stone': 'jour : sat<46, lum>38 ; composantes >=24 pixels ; silhouette du sanctuaire complétée par le polygone documenté ; partition géométrique reprise pour la nuit afin de conserver l alignement',
            'shrine_polygon_raw_xy': [list(point) for point in SHRINE_POLYGON_RAW],
            'stone_correction': 'jour [Y-30, Y-30, Y-44] gris chaud ; nuit [Y-12, Y-4, Y+5] gris-bleu ; alpha et relief conservés, aucune dominance verte',
            'shadow': 'pixels de sol à <=26 px de la bordure et plus sombres que le sol complet généré (>7 lum)',
            'foreground': 'végétation sombre (lum<62), y>=72% du brut, composantes connectées au bord inférieur',
            'counts_raw_by_variant': {'jour': segmentation, 'nuit': night_segmentation},
        },
        'fidelity': {
            'method': 'distance euclidienne des RGB moyens ; classifieur identique sur le rip et les calques jour ; seuil bloquant <35 pour le jour ; nuit générée séparément en palette sombre, comparaison non appliquée',
            'raw': raw_fidelity,
            'final_layers_day': final_fidelity,
            'night_comparison': {
                'applied': False,
                'reason': 'variante nocturne générée séparément depuis la référence canonique ; palette bleu-vert intentionnelle',
            },
        },
        'reconstruction_from_generated_maps': reconstruction,
        'layers': day_layers_manifest,
        'animation': day_animation,
        'variants': variants,
        'access': {
            'markers_px': markers,
            **access,
            'blocked_cells': int(blocked.sum()),
            'walkable_cells': int((~blocked).sum()),
            'total_cells': int(blocked.size),
            'walkability': 'clairière et ombres ; case bloquée si plus de 25% de ses pixels sont non praticables',
            'exit': 'aucun warp, aucune sortie et aucune destination configurée ; la bande nord et les côtés sont bloqués',
        },
        'pmdo': {
            'target': '0.8.12',
            'asset': ASSET,
            'assets': [ASSET, ASSET_NIGHT],
            'namespace': NAMESPACE,
            'template': 'source/cote_v5_expeditions/references/ExplorersOfSkyOrigins__drenched_bluff_entrance.rsground (version 0.8.12.0, TexSize 1)',
            'banks': all_bank_counts,
            'grid_px': 8,
            'runtime_tested': False,
            'warp': 'aucun',
        },
        'art_approved': False,
    }
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + '\n', encoding='utf-8')
    (OUT / 'README.md').write_text((HERE / 'README_PACK.md').read_text(encoding='utf-8'), encoding='utf-8')
    shutil.copyfile(OUT / 'manifest.json', STAGE / 'manifest.json')
    print(json.dumps({
        'prefixes': [PFX, PFX_NIGHT],
        'assets': [ASSET, ASSET_NIGHT],
        'markers': markers,
        'access': access,
        'segmentation': segmentation,
        'walkable_cells': int((~blocked).sum()),
        'blocked_cells': int(blocked.sum()),
        'leaf_emitters': len(emitters),
        'night_light_alpha': [light_min_positive, light_max_alpha],
        'fidelity_raw': {k: v['distance'] for k, v in raw_fidelity.items()},
        'fidelity_final_day': {k: v['distance'] for k, v in final_fidelity.items()},
        'reconstruction': reconstruction,
        'tiles_by_variant': {'jour': day_bank_counts, 'nuit': night_bank_counts},
    }, ensure_ascii=False, indent=2))

def composite_scene(stack, tick):
    result = Image.new('RGBA', (W, H))
    for name, _, frames, ticks, _ in stack:
        result.alpha_composite(Image.fromarray(frames[(tick // ticks) % len(frames)]))
    return result


def draw_collision_review(scene, blocked, markers):
    image = scene.copy()
    overlay = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    draw = ImageDraw.Draw(overlay)
    for y, x in zip(*np.nonzero(blocked)):
        draw.rectangle([x * 8, y * 8, x * 8 + 7, y * 8 + 7], fill=(220, 40, 40, 90))
    colors = {'entrance': (255, 230, 40, 255), 'boss': (255, 70, 210, 255), 'objectif': (60, 220, 255, 255)}
    for name, point in markers.items():
        draw.rectangle([point[0], point[1], point[0] + 15, point[1] + 15], outline=colors[name], width=2)
    image.alpha_composite(overlay)
    return image


if __name__ == '__main__':
    build()
