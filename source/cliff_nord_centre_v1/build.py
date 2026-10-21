#!/usr/bin/env python3
"""Générateur 100 % natif (ZÉRO génération IA / ZÉRO flou) de la carte falaise centrée Métano :
  - `cliff_nord_centre_jour.rsground`      (Cap Central Métano — Jour Complet Animé, 1200×880 px = 150×110 tuiles)
  - `cliff_nord_centre_nuit.rsground`      (Cap Central Métano — Nuit Étoilée Animée, 1200×880 px = 150×110 tuiles)
  - `cliff_nord_centre_nue_jour.rsground`  (Cap Central Métano — Plateau Nu Jour Prêt à Bâtir)
  - `cliff_nord_centre_nue_nuit.rsground`  (Cap Central Métano — Plateau Nu Nuit Prêt à Bâtir)

100 % vraies textures natives Halcyon / Chunsoft (Palikadude & artistes PMD originaux) :
  - Grass Métano : bloc sans couture `Metano_Town_Base.tile` [0:128, 640:768] (+ `_Night.tile`)
  - Parois, piliers arrondis, couronnes herbeuses et pieds de falaise : `Metano_Town_Cliffs.tile` (+ `_Night.tile`)
  - Rebord côtier Nord panoramique : lisière herbeuse native `Metano_Town_Base.tile` [624:832, 768:786] (+ `_Night.tile`)
  - Chemins de terre battue & placette pavée : `Metano_Town_Base.tile` (+ `_Night.tile`)
  - Cascade 4 phases, étang 4 phases, moulin 4 phases, bannières au vent 4 phases, fleurs sauvages 4 phases :
      `Metano_Town_Animation_Tileset.tile` (+ `_Night.tile`)
  - Arbres Métano, huttes feuilles, tipis, panneaux bois, souches, rochers, canopée avant-plan (`Layer = 4`) :
      `Metano_Town_Objects.tile` (+ `_Night.tile`)
  - Ciel Jour & Nuit sans aucune bande + Astres PMD2 + 3 plans de Nuages animés (`LayeredBG` `RepeatX = True`, -5/-9/-14 px/s)
  - Mer Chunsoft animée 8 phases (`FrameLength = 10` @ 60 Hz = 166,67 ms/phase) entourant le cap à l'Ouest, au Nord et à l'Est.
"""
from __future__ import annotations

import copy
import hashlib
import io
import json
import math
import shutil
import struct
import uuid
import zipfile
import zlib
from pathlib import Path
from typing import Dict, List, Tuple

import numpy as np
from PIL import Image, ImageDraw
from scipy.ndimage import binary_dilation, binary_fill_holes, gaussian_filter1d, label

ROOT = Path('/home/user/projet-creation-pmdo')
NATIFS_V4 = ROOT / 'source/cote_v4_abyss/natifs'
REFS_CENTRE = ROOT / 'source/cliff_nord_centre_v1/refs_natives'
INSTALLER_SRC = ROOT / 'source/pmdo_cote/INSTALLER.py'

OUT_DIR = ROOT / 'livrables_cliff_nord_centre_pmdo'
WEB_DIR = OUT_DIR / 'viewer_layers_1x'
PNG_DIR = OUT_DIR / 'png_1x'
ANIM_DIR = OUT_DIR / 'animations_1x'
STAGE_DIR = Path('/tmp/stage_cliff_nord_centre_pmdo')

W, H = 1200, 880          # 150 x 110 tuiles 8x8 — cap centré pile sur X = 600 px !
GW, GH = W // 8, H // 8
HORIZON_Y = 296           # 37 tuiles de ciel (y = 0..296) + 73 tuiles d'océan & promontoire (y = 296..880)
NOSE_Y = 336              # 336 + 544 == 880 px exact : 100 % de la hauteur native Metano_Town_Cliffs sans coupe !


# ==============================================================================
# Utilitaires binaires RogueEssence 0.8.12 (.tile, .dir, index.idx, prémult RGBA)
# ==============================================================================

def premult_rgba(im: Image.Image) -> Image.Image:
    arr = np.array(im.convert('RGBA'), dtype=np.uint16)
    arr[..., :3] = (arr[..., :3] * arr[..., 3:4]) // 255
    return Image.fromarray(arr.astype(np.uint8), 'RGBA')


def save_png(im: Image.Image, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    im.convert('RGBA').save(path, format='PNG', optimize=True, compress_level=9)


def decode_tile_straight(path: Path) -> Image.Image:
    """Décode un fichier .tile RogueEssence en RGBA droit (non prémultiplié) exact."""
    raw = path.read_bytes()
    size, n = struct.unpack_from('<ii', raw, 0)
    records = [struct.unpack_from('<iiq', raw, 8 + i * 16) for i in range(n)]
    w = (max((x for x, y, _ in records), default=0) + 1) * size
    h = (max((y for x, y, _ in records), default=0) + 1) * size
    out = Image.new('RGBA', (w, h), (0, 0, 0, 0))
    cache: Dict[int, Image.Image] = {}
    for x, y, off in records:
        if off not in cache:
            k = struct.unpack_from('<q', raw, off)[0]
            im = Image.open(io.BytesIO(raw[off + 8 : off + 8 + k])).convert('RGBA')
            arr = np.array(im, dtype=np.uint16)
            nz = arr[..., 3] > 0
            for c in range(3):
                arr[..., c][nz] = np.minimum(255, (arr[..., c][nz] * 255 + arr[..., 3][nz] // 2) // arr[..., 3][nz])
            cache[off] = Image.fromarray(arr.astype(np.uint8), 'RGBA')
        out.paste(cache[off], (x * size, y * size))
    return out


def _png_chunk(tag: bytes, data: bytes) -> bytes:
    return struct.pack('>I', len(data)) + tag + data + struct.pack('>I', zlib.crc32(tag + data) & 0xFFFFFFFF)


def encode_8x8_minimal_png(tile_rgba: Image.Image) -> bytes:
    arr = np.array(premult_rgba(tile_rgba), dtype=np.uint8)
    flat = arr.reshape(-1, 4)
    packed = (
        (flat[:, 0].astype(np.uint32) << 24)
        | (flat[:, 1].astype(np.uint32) << 16)
        | (flat[:, 2].astype(np.uint32) << 8)
        | flat[:, 3].astype(np.uint32)
    )
    uniq, inv = np.unique(packed, return_inverse=True)
    if len(uniq) <= 16:
        bit_depth = 4
        idx_rows = inv.reshape(8, 8).astype(np.uint8)
        packed_rows = (idx_rows[:, 0::2] << 4) | idx_rows[:, 1::2]
        raw_scan = b''.join(b'\x00' + packed_rows[y].tobytes() for y in range(8))
    else:
        bit_depth = 8
        idx_rows = inv.reshape(8, 8).astype(np.uint8)
        raw_scan = b''.join(b'\x00' + idx_rows[y].tobytes() for y in range(8))

    r = ((uniq >> 24) & 0xFF).astype(np.uint8)
    g = ((uniq >> 16) & 0xFF).astype(np.uint8)
    b = ((uniq >> 8) & 0xFF).astype(np.uint8)
    a = (uniq & 0xFF).astype(np.uint8)
    plte = np.stack([r, g, b], axis=1).tobytes()
    ihdr = struct.pack('>IIBBBBB', 8, 8, bit_depth, 3, 0, 0, 0)
    chunks = [b'\x89PNG\r\n\x1a\n', _png_chunk(b'IHDR', ihdr), _png_chunk(b'PLTE', plte)]
    if np.any(a < 255):
        chunks.append(_png_chunk(b'tRNS', a.tobytes()))
    chunks.append(_png_chunk(b'IDAT', zlib.compress(raw_scan, level=9)))
    chunks.append(_png_chunk(b'IEND', b''))
    return b''.join(chunks)


def write_dir_sheet(path: Path, im: Image.Image) -> dict:
    path.parent.mkdir(parents=True, exist_ok=True)
    pm = premult_rgba(im)
    buf = io.BytesIO()
    pm.save(buf, format='PNG', optimize=True, compress_level=9)
    png_raw = buf.getvalue()
    raw = struct.pack('<q', len(png_raw)) + png_raw + struct.pack('<4i', im.width, im.height, 0, 1)
    path.write_bytes(raw)
    return {
        'name': path.stem,
        'size': [im.width, im.height],
        'bytes': len(raw),
        'sha256': hashlib.sha256(raw).hexdigest(),
    }


def write_dotnet_string(value: str) -> bytes:
    raw = value.encode('utf-8')
    size, header = len(raw), bytearray()
    while size >= 128:
        header.append((size & 127) | 128)
        size >>= 7
    return bytes(header) + bytes([size]) + raw


def write_tile_index_idx(path: Path, tile_paths: List[Path]) -> None:
    nodes: Dict[str, bytes] = {}
    for tp in sorted(tile_paths):
        raw = tp.read_bytes()
        tsize, count = struct.unpack_from('<ii', raw, 0)
        nodes[tp.stem] = raw[: 8 + count * 16]
    payload = struct.pack('<i', len(nodes)) + b''.join(
        write_dotnet_string(name) + nodes[name] for name in sorted(nodes)
    )
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(payload)


class CompactTileBank:
    def __init__(self, sheet_name: str, cols: int = 64):
        self.sheet_name = sheet_name
        self.cols = cols
        self._dedup: Dict[bytes, Tuple[int, int]] = {}
        self._entries: List[Tuple[int, int, bytes]] = []

    def add(self, tile_im: Image.Image) -> Tuple[int, int]:
        arr = np.array(premult_rgba(tile_im), dtype=np.uint8)
        if np.all(arr[..., 3] == 0):
            arr = np.zeros((8, 8, 4), dtype=np.uint8)
            tile_im = Image.fromarray(arr, 'RGBA')
        key = arr.tobytes()
        loc = self._dedup.get(key)
        if loc is not None:
            return loc
        idx = len(self._entries)
        tx, ty = idx % self.cols, idx // self.cols
        png_bytes = encode_8x8_minimal_png(tile_im)
        self._dedup[key] = (tx, ty)
        self._entries.append((tx, ty, png_bytes))
        return (tx, ty)

    def write(self, path: Path) -> dict:
        path.parent.mkdir(parents=True, exist_ok=True)
        count = len(self._entries)
        max_x = max((x for x, y, _ in self._entries), default=0)
        max_y = max((y for x, y, _ in self._entries), default=0)
        header = bytearray(struct.pack('<ii', 8, count))
        blobs = bytearray()
        cur_off = 8 + count * 16
        for tx, ty, pbytes in self._entries:
            header.extend(struct.pack('<iiq', tx, ty, cur_off))
            rec = struct.pack('<q', len(pbytes)) + pbytes
            blobs.extend(rec)
            cur_off += len(rec)
        raw = bytes(header) + bytes(blobs)
        path.write_bytes(raw)
        return {
            'sheet': self.sheet_name,
            'tile_count': count,
            'grid': [max_x + 1, max_y + 1],
            'bytes': len(raw),
            'sha256': hashlib.sha256(raw).hexdigest(),
        }


def make_map_bg(name: str, y_offset: int = 0, move_x: int = 0, repeat_x: bool = False) -> dict:
    return {
        '$type': 'RogueEssence.Dungeon.MapBG, RogueEssence',
        'MapLoc': {'X': 0, 'Y': y_offset},
        'BGAnim': {
            'AnimIndex': name,
            'FrameTime': 1,
            'StartFrame': -1,
            'EndFrame': -1,
            'AnimDir': -1,
            'Alpha': 255,
            'AnimFlip': 0,
        },
        'BGMovement': {'X': move_x, 'Y': 0},
        'Parallax': '1, 1',
        'RepeatX': repeat_x,
        'RepeatY': False,
    }


# ==============================================================================
# 1. Ciel Jour & Nuit sans bande + Astres PMD2 + 3 bandes de Nuages animés
# ==============================================================================

def build_sky_and_clouds() -> Tuple[Dict[str, Image.Image], Image.Image, Dict[str, Dict[str, Image.Image]]]:
    skies: Dict[str, Image.Image] = {}
    bayer4 = (
        np.array([[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]], dtype=np.float32) / 16.0
        - 0.46875
    )
    dither_map = np.tile(bayer4, (HORIZON_Y // 4 + 1, W // 4 + 1))[:HORIZON_Y, :W, None]

    for mode, fname in [('jour', 'jour_ciel.png'), ('nuit', 'nuit_ciel.png')]:
        ref_sky = np.array(Image.open(REFS_CENTRE / fname).convert('RGBA'))
        raw_profile = ref_sky[:147, :, :3].mean(axis=1).astype(np.float32)
        smooth_profile = gaussian_filter1d(raw_profile, sigma=5.0, axis=0, mode='nearest')
        ys = np.linspace(0, len(smooth_profile) - 1, HORIZON_Y)
        i0 = np.floor(ys).astype(int)
        i1 = np.minimum(i0 + 1, len(smooth_profile) - 1)
        fr = (ys - i0)[:, None]
        ramp = smooth_profile[i0] * (1.0 - fr) + smooth_profile[i1] * fr
        ramp_2d = np.clip(np.round(ramp[:, None, :] + dither_map * 0.95), 0, 255).astype(np.uint8)
        sky = np.zeros((H, W, 4), dtype=np.uint8)
        sky[..., 3] = 255
        sky[:HORIZON_Y, :, :3] = ramp_2d
        sky[HORIZON_Y:, :, :3] = ramp_2d[-1:, :, :]
        skies[mode] = Image.fromarray(sky, 'RGBA')

    # Astres nocturnes PMD2 (croissant de lune natif + champ d'étoiles sur tout le ciel y < HORIZON_Y)
    src_astres = Image.open(REFS_CENTRE / 'nuit_astres.png').convert('RGBA')
    astres = Image.new('RGBA', (W, H), (0, 0, 0, 0))
    moon_crop = src_astres.crop((src_astres.width - 440, 0, src_astres.width, 136))
    astres.paste(moon_crop, (W - 432, 12), moon_crop)
    for x in range(0, W - 432, 240):
        ws = min(240, W - 432 - x)
        sl = src_astres.crop((0, 0, ws, 130))
        astres.paste(sl, (x, 14), sl)

    # Ajoute de fines étoiles PMD2 (alpha binaire 255) dans la bande médiane y = 96..228
    rng = np.random.default_rng(20261021)
    ast_arr = np.array(astres)
    sky_n_arr = np.array(skies['nuit'])
    # Nettoyage binaire strict des halos partiels
    part = (ast_arr[..., 3] > 0) & (ast_arr[..., 3] < 255)
    keep = ast_arr[..., 3] >= 120
    drop = part & ~keep
    ast_arr[drop] = 0
    ak = part & keep
    if np.any(ak):
        a = ast_arr[..., 3:4][ak].astype(np.uint16)
        ast_arr[..., :3][ak] = (
            (ast_arr[..., :3][ak].astype(np.uint16) * a + sky_n_arr[..., :3][ak].astype(np.uint16) * (255 - a)) // 255
        ).astype(np.uint8)
        ast_arr[..., 3][ak] = 255

    star_pal = [
        (238, 244, 255, 255),
        (196, 214, 252, 255),
        (164, 188, 242, 255),
        (255, 246, 214, 255),
    ]
    for _ in range(58):
        sx = int(rng.integers(12, W - 12))
        sy = int(rng.integers(92, HORIZON_Y - 52))
        if ast_arr[sy, sx, 3] == 0:
            col = star_pal[int(rng.integers(0, len(star_pal)))]
            ast_arr[sy, sx] = col
            if rng.random() < 0.24:
                dim = (col[0] // 2 + 40, col[1] // 2 + 48, col[2] // 2 + 64, 255)
                for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
                    ast_arr[sy + dy, sx + dx] = dim
    astres = Image.fromarray(ast_arr, 'RGBA')

    # 3 bandes de cumulus Chunsoft 1440 px sans couture (RepeatX = True)
    j_sheet = np.array(Image.open(REFS_CENTRE / 'jour_nuages.png').convert('RGBA'))
    raw_boxes = [
        (32, 40, 152, 48),
        (272, 16, 96, 64),
        (504, 72, 96, 48),
        (728, 32, 96, 48),
        (920, 80, 120, 56),
        (1160, 24, 152, 64),
    ]
    tight_day, tight_nb, tight_nm, tight_nf = [], [], [], []

    def grade_moon(arr_rgba: np.ndarray, gain: Tuple[float, float, float], lift: Tuple[float, float, float]) -> Image.Image:
        out = arr_rgba.copy()
        m = out[..., 3] > 0
        v = out[..., :3][m].astype(np.float32)
        lum = (v @ np.array([0.2126, 0.7152, 0.0722], dtype=np.float32))[:, None]
        desat = lum * 0.25 + v * 0.75
        out[..., :3][m] = np.clip(np.round(desat * np.array(gain, dtype=np.float32) + np.array(lift, dtype=np.float32)), 0, 255).astype(np.uint8)
        return Image.fromarray(out, 'RGBA')

    for dx, dy, bw, bh in raw_boxes:
        sub = j_sheet[dy : dy + bh, dx : dx + bw]
        ys, xs = np.where(sub[..., 3] > 0)
        crop = sub[ys.min() : ys.max() + 1, xs.min() : xs.max() + 1]
        tight_day.append(Image.fromarray(crop, 'RGBA'))
        tight_nb.append(grade_moon(crop, (0.52, 0.56, 0.78), (10, 14, 28)))
        tight_nm.append(grade_moon(crop, (0.45, 0.49, 0.70), (8, 12, 25)))
        tight_nf.append(grade_moon(crop, (0.39, 0.43, 0.63), (7, 11, 23)))

    def compose_band(sprites: List[Image.Image], height: int, placements: List[Tuple[int, int, str]]) -> Image.Image:
        band = Image.new('RGBA', (1440, height), (0, 0, 0, 0))
        for sp_idx, x_pos, y_mode in placements:
            sp = sprites[sp_idx]
            y_pos = height - sp.height if y_mode == 'bottom' else int(y_mode)
            assert 20 <= x_pos and x_pos + sp.width <= 1420
            band.alpha_composite(sp, (x_pos, y_pos))
        arr = np.array(band)
        assert np.all(arr[:, :16, 3] == 0) and np.all(arr[:, -16:, 3] == 0)
        return band

    horizon_layout = [
        (0, 28, 'bottom'), (1, 210, 'bottom'), (5, 360, 'bottom'), (2, 560, 'bottom'),
        (4, 716, 'bottom'), (3, 888, 'bottom'), (5, 1028, 'bottom'), (0, 1236, 'bottom'),
    ]
    mid_layout = [(5, 48, '24'), (2, 300, '48'), (4, 512, '14'), (1, 760, '38'), (5, 968, '18'), (3, 1248, '44')]
    high_layout = [(0, 44, '34'), (5, 292, '10'), (3, 560, '42'), (4, 792, '18'), (1, 1052, '12'), (2, 1268, '36')]

    clouds = {
        'jour': {
            'horizon': compose_band(tight_day, 64, horizon_layout),
            'milieu': compose_band(tight_day, 96, mid_layout),
            'haut': compose_band(tight_day, 96, high_layout),
        },
        'nuit': {
            'horizon': compose_band(tight_nf, 64, horizon_layout),
            'milieu': compose_band(tight_nm, 96, mid_layout),
            'haut': compose_band(tight_nb, 96, high_layout),
        },
    }
    return skies, astres, clouds


# ==============================================================================
# 2. Océan Chunsoft animé 8 phases (Jour azur & Nuit lunaire)
# ==============================================================================

def build_ocean_8phases() -> Dict[str, List[Image.Image]]:
    sea_h = H - HORIZON_Y  # 584 px : du lointain bleu royal (y_src=144) aux vagues turquoise proches (y_src=728)
    j_raw = [
        np.asarray(Image.open(REFS_CENTRE / f'jour_mer_{k:02d}.png').convert('RGBA').crop((0, 144, W, 144 + sea_h)), dtype=np.float32)
        for k in range(8)
    ]
    n_raw = [
        np.asarray(Image.open(REFS_CENTRE / f'nuit_mer_{k:02d}.png').convert('RGBA').crop((0, 144, W, 144 + sea_h)), dtype=np.float32)
        for k in range(8)
    ]

    # Dégradé marin Chunsoft 1:1 pur + houle côtière animée en continu sur les 8 phases (0..7) sur toute la hauteur (y=296..880)
    base_j = np.median(np.stack(j_raw, axis=0), axis=0)
    base_n = np.median(np.stack(n_raw, axis=0), axis=0)
    j_min_g = np.minimum.reduce([a[..., 1] for a in j_raw])
    moon_crest = np.array([104.0, 178.0, 236.0], dtype=np.float32)

    yy = np.arange(sea_h)[:, None]
    xx = np.arange(W)[None, :]
    psi_fg = 10.0 * ((np.maximum(0.0, yy - 108.0) / (sea_h - 108.0)) ** 0.78)
    fade_in = np.clip((yy - 114.0) / 18.0, 0.0, 1.0)
    in_fg = yy >= 116

    out: Dict[str, List[Image.Image]] = {'jour': [], 'nuit': []}
    for k in range(8):
        frame_j = j_raw[k].copy()
        frame_n = n_raw[k].copy()
        frame_j[116:] = base_j[116:]
        frame_n[116:] = base_n[116:]

        x_shift = (xx + k * 8) % 64
        wobble = 0.018 * np.sin(2.0 * np.pi * x_shift / 64.0) + 0.010 * np.cos(2.0 * np.pi * ((xx - k * 8) % 32) / 32.0)
        ph = (psi_fg - k / 8.0 + wobble) % 1.0

        dash = ((x_shift // 2 + (yy // 3)) % 8) != 0
        glint = ((x_shift % 16) < 3) & (((yy + k * 3) % 5) == 0)

        crest_hi = in_fg & (ph < 0.045) & dash
        crest_mid = in_fg & (ph >= 0.045) & (ph < 0.115)
        trough_lo = in_fg & (ph >= 0.115) & (ph < 0.175)
        sparkle = in_fg & (ph < 0.030) & glint

        frame_j[..., :3] += (crest_mid * fade_in)[..., None] * np.array([14.0, 24.0, 10.0])
        frame_j[..., :3] += (crest_hi * fade_in)[..., None] * np.array([42.0, 52.0, 14.0])
        frame_j[..., :3] += (sparkle * fade_in)[..., None] * np.array([95.0, 62.0, 15.0])
        frame_j[..., :3] -= (trough_lo * fade_in)[..., None] * np.array([8.0, 18.0, 10.0])
        frame_j[..., 3] = 255.0

        s_top = np.clip((j_raw[k][..., 1] - j_min_g) / 80.0, 0.0, 1.0)[..., None]
        top_blend = 0.58 * (s_top ** 1.15)
        frame_n[:120, :, :3] = n_raw[k][:120, :, :3] * (1.0 - top_blend[:120]) + moon_crest * top_blend[:120]

        frame_n[..., :3] += (crest_mid * fade_in)[..., None] * np.array([16.0, 32.0, 44.0])
        frame_n[..., :3] += (crest_hi * fade_in)[..., None] * np.array([48.0, 82.0, 104.0])
        frame_n[..., :3] += (sparkle * fade_in)[..., None] * np.array([92.0, 118.0, 128.0])
        frame_n[..., :3] -= (trough_lo * fade_in)[..., None] * np.array([5.0, 11.0, 18.0])
        frame_n[..., 3] = 255.0

        dj = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        dj.paste(Image.fromarray(np.clip(np.round(frame_j), 0, 255).astype(np.uint8), 'RGBA'), (0, HORIZON_Y))
        out['jour'].append(dj)

        dn = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        dn.paste(Image.fromarray(np.clip(np.round(frame_n), 0, 255).astype(np.uint8), 'RGBA'), (0, HORIZON_Y))
        out['nuit'].append(dn)
    return out


# ==============================================================================
# 3. Grand Cap Central Grass Métano + Parois Falaise Métano (100 % Natif)
# ==============================================================================

def build_central_cape_layers(
    base_d: np.ndarray,
    base_n: np.ndarray,
    cliffs_d: np.ndarray,
    cliffs_n: np.ndarray,
) -> Dict[str, Dict[str, Image.Image]]:
    """Construit au pixel natif exact (sans aucun flou ni génération IA) :
      - `falaise` : Parois rocheuses dorées-ocres, piliers arrondis Ouest/Est, ailes sud et piliers d'isthme
      - `grass`   : Plateau central d'herbe Métano [0:128, 640:768] + couronnes herbeuses ondulées sur roche
                    + rebord côtier Nord panoramique Chunsoft + taches de terre naturelles + isthme Sud centré
      - `chemins` : Réseau de sentiers de sable & placette pavée Métano partant de l'isthme Sud (X=600)
    """
    # Nettoyage binaire strict des 5 pixels semi-transparents éventuels de Metano_Town_Cliffs
    cd = cliffs_d.copy()
    cn = cliffs_n.copy()
    for arr in (cd, cn):
        m0 = arr[..., 3] < 128
        arr[m0] = 0
        arr[~m0, 3] = 255

    # ------------------------------------------------------------------
    # A. Assemblage symétrique et organique des flancs rocheux Ouest & Est
    #    100 % roche sèche sur `01_Falaise_Parois_Metano` (la cascade 4 phases vit sur `04_*` !)
    #    On retire le petit talon rectangulaire haut y_src = 0..23 de cliffs pour un galbe Nord 100 % fluide !
    # ------------------------------------------------------------------
    cd_clean = cd.copy()
    cn_clean = cn.copy()
    cd_clean[:24, :] = 0
    cn_clean[:24, :] = 0

    full_cliff_d = np.zeros((H, W, 4), dtype=np.uint8)
    full_cliff_n = np.zeros((H, W, 4), dtype=np.uint8)

    X_WEST_OUTER = 104
    w_nose = 280  # cliffs x_src = 456..736
    for dst, src in [(full_cliff_d, cd_clean), (full_cliff_n, cn_clean)]:
        # Flanc Ouest complet (nez côtier + 5 piliers rocheux étagés)
        sl_w = src[0:544, 456 : 456 + w_nose]
        m = sl_w[..., 3] > 0
        dst[NOSE_Y : NOSE_Y + 544, X_WEST_OUTER : X_WEST_OUTER + w_nose][m] = sl_w[m]

        # Aile Sud-Ouest en vraie paroi rocheuse dorée sèche (sans rectangle d'eau figé !)
        sl_wall_w = src[0:544, 904:984]
        m = sl_wall_w[..., 3] > 0
        dst[NOSE_Y : NOSE_Y + 544, 384:464][m] = sl_wall_w[m]

        # Pilier arrondi intérieur Ouest encadrant l'isthme Sud centré
        pil_w = src[416:544, 696:736][:, ::-1, :]
        m = pil_w[..., 3] > 0
        dst[NOSE_Y + 416 : NOSE_Y + 544, 456:496][m] = pil_w[m]

        # Flanc Est symétrique (miroir pixel exact centré sur X = 600 px)
        sl_e = src[0:544, 456 : 456 + w_nose][:, ::-1, :]
        m = sl_e[..., 3] > 0
        dst[NOSE_Y : NOSE_Y + 544, W - X_WEST_OUTER - w_nose : W - X_WEST_OUTER][m] = sl_e[m]

        # Aile Sud-Est en vraie paroi rocheuse dorée sèche
        sl_wall_e = src[0:544, 904:984][:, ::-1, :]
        m = sl_wall_e[..., 3] > 0
        dst[NOSE_Y : NOSE_Y + 544, 736:816][m] = sl_wall_e[m]

        # Pilier arrondi intérieur Est encadrant l'isthme Sud centré
        pil_e = src[416:544, 696:736]
        m = pil_e[..., 3] > 0
        dst[NOSE_Y + 416 : NOSE_Y + 544, 704:744][m] = pil_e[m]

    # Scelle toute micro-fente verticale de 1..3 px entre deux piliers rocheux adjacents de Metano_Town_Cliffs
    for shift in (1, 2, 3):
        gap = (full_cliff_d[:, shift:-shift, 3] == 0) & (full_cliff_d[:, :-2*shift, 3] == 255) & (full_cliff_d[:, 2*shift:, 3] == 255)
        full_cliff_d[:, shift:-shift][gap] = full_cliff_d[:, :-2*shift][gap]
        full_cliff_n[:, shift:-shift][gap] = full_cliff_n[:, :-2*shift][gap]

    # ------------------------------------------------------------------
    # B. Profil Nord panoramique fluide reliant (168, 360) à (1032, 360) sans aucun décrochement
    # ------------------------------------------------------------------
    rim_src_d = base_d[768:786, 624:832].copy()
    rim_src_n = base_n[768:786, 624:832].copy()
    water_px = (rim_src_d[..., 2].astype(int) - rim_src_d[..., 0].astype(int)) > 15
    rim_src_d[water_px] = 0
    rim_src_n[water_px] = 0

    rim_cols_d, rim_cols_n = [], []
    for sx in range(rim_src_d.shape[1]):
        ys = np.where(rim_src_d[:, sx, 3] > 0)[0]
        y0 = int(ys[0])
        rim_cols_d.append(rim_src_d[y0:, sx])
        rim_cols_n.append(rim_src_n[y0:, sx])

    north_top_y = np.full(W, H, dtype=np.int32)
    x_l, x_r = 168, W - 168  # 168 .. 1032 (raccord exact à y = 360 sur les deux épaules côtières !)
    y_shoulder = NOSE_Y + 24  # 360 px == exactement y_src=24 du bord côtier de Metano_Town_Cliffs !
    for x in range(x_l, x_r + 1):
        u = (x - x_l) / float(x_r - x_l)
        bell = math.sin(math.pi * u) ** 0.92
        ripple = 3.2 * math.sin(2.0 * math.pi * (2.5 * u - 0.15)) * (math.sin(math.pi * u) ** 0.8)
        north_top_y[x] = int(round(y_shoulder - 42.0 * bell + ripple))

    # ------------------------------------------------------------------
    # C. Séparation sans aucune fente ni trou interne : ROCHE (Layer 01) vs GRASS MÉTANO (Layer 02)
    # ------------------------------------------------------------------
    rc = full_cliff_d.astype(np.int16)
    cliff_opaque = rc[..., 3] > 0
    cliff_is_grass = cliff_opaque & (rc[..., 1] >= rc[..., 0] - 8) & ((rc[..., 1] - rc[..., 2]) > 55)
    cliff_is_rock = binary_fill_holes(cliff_opaque & ~cliff_is_grass) & cliff_opaque
    cliff_is_grass = cliff_opaque & ~cliff_is_rock

    plateau_mask = np.zeros((H, W), dtype=bool)
    for x in range(W):
        ys_op = np.where(cliff_opaque[:, x])[0]
        if not len(ys_op) and north_top_y[x] >= H:
            continue
        top_y = min(int(north_top_y[x]), int(ys_op[0]) if len(ys_op) else H)

        if 484 <= x <= 716:
            bot_y = H
        else:
            ys_rk = np.where(cliff_is_rock[:, x])[0]
            bot_y = int(ys_op[-1]) + 1 if len(ys_op) else H
            if len(ys_rk):
                splits = np.split(ys_rk, np.where(np.diff(ys_rk) > 3)[0] + 1)
                tall_runs = [s for s in splits if len(s) >= 14]
                if tall_runs:
                    bot_y = int(tall_runs[0][0])
        if bot_y > top_y:
            plateau_mask[top_y:bot_y, x] = True

    plateau_mask |= cliff_is_grass
    # bouche 100 % des fentes verticales internes entre le ruban côtier de Cliffs et l'intérieur du plateau !
    padded = np.zeros((H + 2, W), dtype=bool)
    padded[1 : H + 1, :] = plateau_mask
    padded[H + 1, 484:717] = True
    plateau_mask = binary_fill_holes(padded)[1 : H + 1, :]
    # Aussi, partout où un pilier rocheux a sa couronne, étend le plateau 6 px sous la couronne pour zéro fente cyan !
    for x in range(104, W - 104):
        ys_p = np.where(plateau_mask[:, x])[0]
        ys_r = np.where(cliff_is_rock[:, x])[0]
        if len(ys_p) and len(ys_r) and ys_r[0] > ys_p[-1]:
            plateau_mask[ys_p[-1] : ys_r[0] + 3, x] = True

    # 2) Pavage 100 % natif sans couture du plateau avec le bloc canonique Metano_Town_Base [640:768, 0:128]
    grass_patch_d = base_d[640:768, 0:128]
    grass_patch_n = base_n[640:768, 0:128]
    tiled_grass_d = np.tile(grass_patch_d, (H // 128 + 2, W // 128 + 2, 1))[:H, :W]
    tiled_grass_n = np.tile(grass_patch_n, (H // 128 + 2, W // 128 + 2, 1))[:H, :W]

    rock_d = np.zeros((H, W, 4), dtype=np.uint8)
    rock_n = np.zeros((H, W, 4), dtype=np.uint8)
    rock_d[cliff_is_rock] = full_cliff_d[cliff_is_rock]
    rock_n[cliff_is_rock] = full_cliff_n[cliff_is_rock]
    # Aussi sous la couronne ondulée (4 px de recouvrement supérieur pour qu'aucun jour n'apparaisse si on masque un calque)
    crown_under = binary_dilation(cliff_is_rock, iterations=3) & cliff_opaque
    rock_d[crown_under & ~cliff_is_rock] = full_cliff_d[crown_under & ~cliff_is_rock]
    rock_n[crown_under & ~cliff_is_rock] = full_cliff_n[crown_under & ~cliff_is_rock]

    grass_d = np.zeros((H, W, 4), dtype=np.uint8)
    grass_n = np.zeros((H, W, 4), dtype=np.uint8)
    grass_d[plateau_mask] = tiled_grass_d[plateau_mask]
    grass_n[plateau_mask] = tiled_grass_n[plateau_mask]

    # Surimprime fidèlement toutes les franges côtières & couronnes herbeuses natives de Metano_Town_Cliffs !
    # (Conserve le modelé exact Chunsoft des couronnes herbeuses et de la côte incurvée gauche/droite)
    coastal_rim_mask = cliff_is_grass.copy()
    # Sur les colonnes x=104..186 et x=1014..1096 (haut des nez côtiers y < NOSE_Y + 216), garde aussi les 2-4 px de liseré côtier !
    top_coastal_band = np.zeros((H, W), dtype=bool)
    top_coastal_band[: NOSE_Y + 216, :188] = True
    top_coastal_band[: NOSE_Y + 216, W - 188 :] = True
    coastal_rim_mask |= (cliff_opaque & top_coastal_band)
    grass_d[coastal_rim_mask] = full_cliff_d[coastal_rim_mask]
    grass_n[coastal_rim_mask] = full_cliff_n[coastal_rim_mask]
    # Retire ces petits pixels de liseré côtier haut de rock_d pour qu'ils appartiennent proprement au plateau côtier
    rock_d[cliff_opaque & top_coastal_band] = 0
    rock_n[cliff_opaque & top_coastal_band] = 0

    # Surimprime la vraie lisière Nord Chunsoft le long de la courbe panoramique x = 180 .. 1020 !
    n_cols = len(rim_cols_d)
    for x in range(x_l, x_r + 1):
        yt = int(north_top_y[x])
        col_d = rim_cols_d[(x - x_l) % n_cols]
        col_n = rim_cols_n[(x - x_l) % n_cols]
        h_c = len(col_d)
        grass_d[yt : yt + h_c, x] = col_d
        grass_n[yt : yt + h_c, x] = col_n

    # ------------------------------------------------------------------
    # D. Taches de terre naturelles Métano sur le plateau + Chemins Sable Métano (Layer 03)
    # ------------------------------------------------------------------
    grass_colors = set(map(tuple, grass_patch_d.reshape(-1, 4)[:, :3]))

    def extract_non_grass_mask(arr: np.ndarray) -> np.ndarray:
        rgb = arr[..., :3]
        ng = np.ones(arr.shape[:2], dtype=bool)
        for gc in grass_colors:
            ng &= ~((rgb[..., 0] == gc[0]) & (rgb[..., 1] == gc[1]) & (rgb[..., 2] == gc[2]))
        valid = (arr[..., 3] == 255) & ~((rgb[..., 0] > 250) & (rgb[..., 1] > 250) & (rgb[..., 2] > 250))
        valid &= ~((rgb[..., 2].astype(int) - rgb[..., 0].astype(int)) > 15)
        return ng & valid

    # Petites taches de terre battue naturelles extraites par composantes connexes de Metano_Town_Base
    patch_zone_d = base_d[640:900, 1180:1496]
    patch_zone_n = base_n[640:900, 1180:1496]
    pz_mask = extract_non_grass_mask(patch_zone_d)
    lbl_p, n_p = label(pz_mask, structure=np.ones((3, 3), int))
    earth_spots = []
    for cid in range(1, n_p + 1):
        ys, xs = np.where(lbl_p == cid)
        if 80 <= len(ys) <= 700:
            x0, y0, x1, y1 = xs.min(), ys.min(), xs.max() + 1, ys.max() + 1
            m = lbl_p[y0:y1, x0:x1] == cid
            earth_spots.append((patch_zone_d[y0:y1, x0:x1], patch_zone_n[y0:y1, x0:x1], m))

    spot_coords = [
        (248, 456, 0), (312, 608, 1), (424, 392, 2), (752, 404, 0),
        (888, 472, 1), (856, 624, 2), (516, 720, 1), (672, 744, 0),
    ]
    for sx, sy, sidx in spot_coords:
        if earth_spots:
            sd, sn, sm = earth_spots[sidx % len(earth_spots)]
            sh, sw = sm.shape
            if np.all(plateau_mask[sy : sy + sh, sx : sx + sw]):
                grass_d[sy : sy + sh, sx : sx + sw][sm] = sd[sm]
                grass_n[sy : sy + sh, sx : sx + sw][sm] = sn[sm]

    # Réseau de chemins en terre battue + placette centrale pavée 100 % natif Metano_Town_Base !
    # Champ de distance lisse multi-capsules + vraie frange dentelée Chunsoft sur 360° (ZÉRO coupure droite !)
    sand_tile_d = base_d[888:952, 1184:1248]
    sand_tile_n = base_n[888:952, 1184:1248]
    tiled_sand_d = np.tile(sand_tile_d, (H // 64 + 2, W // 64 + 2, 1))[:H, :W]
    tiled_sand_n = np.tile(sand_tile_n, (H // 64 + 2, W // 64 + 2, 1))[:H, :W]

    yy, xx = np.mgrid[0:H, 0:W].astype(np.float32)

    def dist_polyline(pts: List[Tuple[float, float]]) -> np.ndarray:
        best = np.full((H, W), 1e9, dtype=np.float32)
        for (ax, ay), (bx, by) in zip(pts[:-1], pts[1:]):
            vx, vy = bx - ax, by - ay
            denom = max(vx * vx + vy * vy, 1e-6)
            t = np.clip(((xx - ax) * vx + (yy - ay) * vy) / denom, 0.0, 1.0)
            px, py = ax + t * vx, ay + t * vy
            best = np.minimum(best, np.hypot(xx - px, yy - py))
        return best

    d_main = dist_polyline([(600, 892), (596, 800), (608, 708), (594, 624), (600, 548), (606, 462), (598, 382)])
    d_west = dist_polyline([(596, 566), (512, 578), (432, 562), (356, 586), (288, 566)])
    d_east = dist_polyline([(602, 548), (684, 536), (760, 542), (836, 520), (888, 534)])
    d_plaza = np.hypot((xx - 600.0) / 1.32, (yy - 560.0) / 0.96)

    s_field = np.minimum.reduce([
        d_main - 21.0,
        d_west - 18.0,
        d_east - 18.0,
        d_plaza - 52.0,
    ])

    rng_path = np.random.default_rng(772026)
    coarse = gaussian_filter1d(gaussian_filter1d(rng_path.standard_normal((H, W)).astype(np.float32), 5.5, axis=0), 5.5, axis=1)
    coarse *= 8.0 / max(float(coarse.std()), 1e-5)
    tuft_seed = rng_path.uniform(-1.0, 1.0, size=(H // 2 + 2, W))
    tuft_field = np.repeat(tuft_seed, 2, axis=0)[:H, :W].astype(np.float32) * 2.35
    fine = rng_path.uniform(-0.85, 0.85, size=(H, W)).astype(np.float32)
    s_org = s_field + coarse + tuft_field + fine

    path_d = np.zeros((H, W, 4), dtype=np.uint8)
    path_n = np.zeros((H, W, 4), dtype=np.uint8)

    def find_exact_pair(target_rgb: Tuple[int, int, int]) -> Tuple[np.ndarray, np.ndarray]:
        diff = np.abs(base_d[..., :3].astype(np.int32) - np.array(target_rgb, dtype=np.int32)).sum(axis=-1)
        diff[base_d[..., 3] < 255] = 999999
        iy, ix = np.unravel_index(int(np.argmin(diff)), diff.shape)
        return base_d[iy, ix].copy(), base_n[iy, ix].copy()

    tan_mid_d, tan_mid_n = find_exact_pair((224, 188, 132))
    tan_dark_d, tan_dark_n = find_exact_pair((204, 172, 108))
    fringe_olive_d, fringe_olive_n = find_exact_pair((184, 184, 88))
    fringe_moss_d, fringe_moss_n = find_exact_pair((168, 176, 80))

    inside_plat = binary_dilation(~plateau_mask, iterations=5) == False
    inside_plat[H - 12 :, 556:644] = plateau_mask[H - 12 :, 556:644]

    m_core = (s_org <= -3.2) & inside_plat
    m_tan1 = (s_org > -3.2) & (s_org <= -1.4) & inside_plat
    m_tan2 = (s_org > -1.4) & (s_org <= 0.2) & inside_plat
    m_frg1 = (s_org > 0.2) & (s_org <= 1.7) & inside_plat
    m_frg2 = (s_org > 1.7) & (s_org <= 3.0) & (tuft_field > 0.35) & inside_plat

    path_d[m_core] = tiled_sand_d[m_core]
    path_n[m_core] = tiled_sand_n[m_core]
    path_d[m_tan1], path_n[m_tan1] = tan_mid_d, tan_mid_n
    path_d[m_tan2], path_n[m_tan2] = tan_dark_d, tan_dark_n
    path_d[m_frg1], path_n[m_frg1] = fringe_olive_d, fringe_olive_n
    path_d[m_frg2], path_n[m_frg2] = fringe_moss_d, fringe_moss_n

    cob_d = base_d[852:920, 1084:1172]
    cob_n = base_n[852:920, 1084:1172]
    sand_ref_colors = set(map(tuple, sand_tile_d.reshape(-1, 4)[:, :3]))
    cob_mask = np.ones(cob_d.shape[:2], dtype=bool)
    for sc in sand_ref_colors:
        cob_mask &= ~((cob_d[..., 0] == sc[0]) & (cob_d[..., 1] == sc[1]) & (cob_d[..., 2] == sc[2]))
    px0, py0 = 600 - cob_d.shape[1] // 2, 560 - cob_d.shape[0] // 2
    path_d[py0 : py0 + cob_d.shape[0], px0 : px0 + cob_d.shape[1]][cob_mask] = cob_d[cob_mask]
    path_n[py0 : py0 + cob_n.shape[0], px0 : px0 + cob_n.shape[1]][cob_mask] = cob_n[cob_mask]

    return {
        'jour': {
            'falaise': Image.fromarray(rock_d, 'RGBA'),
            'grass': Image.fromarray(grass_d, 'RGBA'),
            'chemins': Image.fromarray(path_d, 'RGBA'),
        },
        'nuit': {
            'falaise': Image.fromarray(rock_n, 'RGBA'),
            'grass': Image.fromarray(grass_n, 'RGBA'),
            'chemins': Image.fromarray(path_n, 'RGBA'),
        },
        '_masks': {
            'plateau': plateau_mask,
            'rock': cliff_is_rock,
            'path': path_d[..., 3] > 0,
        },
    }


# ==============================================================================
# 4. Calques Animés 4 phases (Cascade, Étang, Moulin, Bannières, Fleurs)
#    + Village Métano (Arbres, Huttes, Tipis, Panneaux) & Canopée Top=4
# ==============================================================================

def extract_component_sprite(
    day_arr: np.ndarray,
    night_arr: np.ndarray,
    box: Tuple[int, int, int, int],
    only_main: bool = False,
) -> Tuple[np.ndarray, np.ndarray]:
    """Extrait proprement le composant connexe 4-voisin principal dans `box` sans aucun pixel parasite voisin."""
    x0, y0, x1, y1 = box
    sd = day_arr[y0:y1, x0:x1].copy()
    sn = night_arr[y0:y1, x0:x1].copy()
    conn4 = np.array([[0, 1, 0], [1, 1, 1], [0, 1, 0]], dtype=int)
    lbl_c, n_c = label(sd[..., 3] > 0, structure=conn4)
    if n_c > 1:
        areas = [(int((lbl_c == i).sum()), i) for i in range(1, n_c + 1)]
        max_a, best_i = max(areas)
        if only_main:
            keep = lbl_c == best_i
        else:
            keep = np.zeros(sd.shape[:2], dtype=bool)
            for a, i in areas:
                if a >= max(10, int(max_a * 0.08)):
                    keep |= (lbl_c == i)
        sd[~keep] = 0
        sn[~keep] = 0
    # Alpha binaire propre
    for arr in (sd, sn):
        m0 = arr[..., 3] < 96
        arr[m0] = 0
        arr[~m0, 3] = 255
    return sd, sn


def build_animated_props_and_village(
    objs_d: np.ndarray,
    objs_n: np.ndarray,
    anim_ts_d: np.ndarray,
    anim_ts_n: np.ndarray,
    plateau_mask: np.ndarray,
) -> Tuple[
    Dict[str, List[Image.Image]],  # anim_layers['jour'|'nuit'] -> 4 frames RGBA (W, H)
    Dict[str, Image.Image],        # village_base['jour'|'nuit'] -> RGBA (W, H)
    Dict[str, Image.Image],        # village_canopy['jour'|'nuit'] -> RGBA (W, H) (Layer = 4 Top)
    np.ndarray,                    # obstacle_props_mask bool (H, W)
]:
    anim_4 = {
        'jour': [np.zeros((H, W, 4), dtype=np.uint8) for _ in range(4)],
        'nuit': [np.zeros((H, W, 4), dtype=np.uint8) for _ in range(4)],
    }
    vill_base = {'jour': np.zeros((H, W, 4), dtype=np.uint8), 'nuit': np.zeros((H, W, 4), dtype=np.uint8)}
    vill_top = {'jour': np.zeros((H, W, 4), dtype=np.uint8), 'nuit': np.zeros((H, W, 4), dtype=np.uint8)}
    prop_block = np.zeros((H, W), dtype=bool)

    def paste_rgba(dst: np.ndarray, sp: np.ndarray, dx: int, dy: int) -> None:
        sh, sw = sp.shape[:2]
        x0, y0 = max(0, dx), max(0, dy)
        x1, y1 = min(W, dx + sw), min(H, dy + sh)
        if x1 <= x0 or y1 <= y0:
            return
        sub = sp[y0 - dy : y1 - dy, x0 - dx : x1 - dx]
        m = sub[..., 3] > 0
        dst[y0:y1, x0:x1][m] = sub[m]

    def extract_4frames(boxes_4: List[Tuple[int, int, int, int]]) -> Tuple[List[np.ndarray], List[np.ndarray]]:
        fd, fn = [], []
        for bx in boxes_4:
            sd, sn = extract_component_sprite(anim_ts_d, anim_ts_n, bx)
            fd.append(sd)
            fn.append(sn)
        return fd, fn

    def place_anim(frames_d: List[np.ndarray], frames_n: List[np.ndarray], dx: int, dy: int, phase_shift: int = 0, solid: bool = False) -> None:
        for f in range(4):
            src_idx = (f + phase_shift) % 4
            paste_rgba(anim_4['jour'][f], frames_d[src_idx], dx, dy)
            paste_rgba(anim_4['nuit'][f], frames_n[src_idx], dx, dy)
        if solid:
            sh, sw = frames_d[0].shape[:2]
            prop_block[max(0, dy + sh // 3) : min(H, dy + sh - 4), max(0, dx + 4) : min(W, dx + sw - 4)] = True

    # 1) Cascade Chunsoft animée 4 phases sur l'encoche de l'aile rocheuse Sud-Ouest (x = 392..456, y = 760..872) !
    wf_boxes = [(8 + 72 * f, 496, 72 + 72 * f, 608) for f in range(4)]
    wf_d, wf_n = [], []
    for bx in wf_boxes:
        sd = anim_ts_d[bx[1]:bx[3], bx[0]:bx[2]].copy()
        sn = anim_ts_n[bx[1]:bx[3], bx[0]:bx[2]].copy()
        wf_d.append(sd)
        wf_n.append(sn)
    # L'encoche de cascade dans full_cliff_d (x=384..464 <- cliffs 976..1056) est pile à x = 392..456, y = 758..880 !
    place_anim(wf_d, wf_n, dx=392, dy=760, phase_shift=0, solid=True)
    # Source rocheuse animée juste au sommet de la cascade !
    spring_boxes = [(296, 496 + 40 * i, 356, 536 + 40 * i) for i in [0, 1, 2, 1]]
    sp_d, sp_n = extract_4frames(spring_boxes)
    place_anim(sp_d, sp_n, dx=396, dy=724, phase_shift=0, solid=True)

    # 2) Étang turquoise scintillant 4 phases (comme dans cliffdaytest !) côté Ouest du belvédère
    pond_boxes = [(8 + 80 * i, 896, 84 + 80 * i, 956) for i in [0, 1, 2, 1]]
    pond_d, pond_n = extract_4frames(pond_boxes)
    place_anim(pond_d, pond_n, dx=392, dy=452, phase_shift=1, solid=True)

    # 3) Bannières d'exploration Métano flottant au vent marin (comme dans cliffdaytest !) le long du cap
    flag_boxes = [(136 + 48 * i, 96, 184 + 48 * i, 160) for i in [0, 1, 2, 1]]
    flag_d, flag_n = extract_4frames(flag_boxes)
    for fx, fy, ph in [(216, 360, 0), (496, 316, 1), (664, 316, 2), (936, 360, 3)]:
        place_anim(flag_d, flag_n, dx=fx, dy=fy, phase_shift=ph, solid=True)

    # 4) Moulin à vent en bois tournant 4 phases sur la pointe Ouest (comme dans cliffdaytest !)
    mill_boxes = [(8 + 72 * f, 216, 72 + 72 * f, 288) for f in range(4)]
    mill_d, mill_n = extract_4frames(mill_boxes)
    place_anim(mill_d, mill_n, dx=152, dy=472, phase_shift=0, solid=True)

    # 5) Clôtures d'éoliennes en bois 4 phases côté Est (comme dans cliffdaytest !)
    pin_boxes = [(8 + 64 * f, 164, 68 + 64 * f, 212) for f in range(4)]
    pin_d, pin_n = extract_4frames(pin_boxes)
    place_anim(pin_d, pin_n, dx=836, dy=404, phase_shift=0, solid=True)
    place_anim(pin_d, pin_n, dx=892, dy=404, phase_shift=2, solid=True)

    # 6) Massifs de fleurs sauvages animées 4 phases répartis harmonieusement sur l'herbe Métano
    fl_med = extract_4frames([(8 + 40 * i, 24, 44 + 40 * i, 56) for i in [0, 1, 2, 1]])
    fl_sml = extract_4frames([(0 + 32 * i, 0, 28 + 32 * i, 24) for i in [0, 1, 2, 1]])
    fl_wht = extract_4frames([(8 + 40 * i, 96, 44 + 40 * i, 128) for i in [0, 1, 2, 1]])

    flower_spots = [
        (fl_med, 296, 396, 0), (fl_wht, 352, 432, 1), (fl_sml, 448, 376, 2),
        (fl_med, 724, 372, 1), (fl_wht, 792, 424, 3), (fl_med, 912, 448, 0),
        (fl_sml, 244, 548, 2), (fl_med, 356, 560, 3), (fl_wht, 488, 668, 0),
        (fl_med, 692, 656, 2), (fl_wht, 828, 568, 1), (fl_sml, 948, 544, 3),
        (fl_med, 504, 792, 1), (fl_med, 668, 804, 3), (fl_sml, 648, 496, 0),
    ]
    for (fd, fn), fx, fy, ph in flower_spots:
        place_anim(fd, fn, dx=fx, dy=fy, phase_shift=ph, solid=False)

    # ------------------------------------------------------------------
    # 7) Village côtier Métano & Bosquets 100 % isolés sans aucun coin voisin
    # ------------------------------------------------------------------
    def place_split_structure(box: Tuple[int, int, int, int], dx: int, dy: int, base_keep_px: int = 38, only_main: bool = True) -> None:
        sd, sn = extract_component_sprite(objs_d, objs_n, box, only_main=only_main)
        sh, sw = sd.shape[:2]
        split_row = max(0, sh - base_keep_px)
        if split_row > 0:
            paste_rgba(vill_top['jour'], sd[:split_row], dx, dy)
            paste_rgba(vill_top['nuit'], sn[:split_row], dx, dy)
        paste_rgba(vill_base['jour'], sd[split_row:], dx, dy + split_row)
        paste_rgba(vill_base['nuit'], sn[split_row:], dx, dy + split_row)
        foot_mask = sd[split_row:, :, 3] > 0
        y0, x0 = dy + split_row, dx
        prop_block[y0 : min(H, y0 + foot_mask.shape[0]), x0 : min(W, x0 + sw)] |= foot_mask[: min(H, y0 + foot_mask.shape[0]) - y0, : min(W, x0 + sw) - x0]

    # Hutte feuille orange iconique de cliffdaytest (cid=498: 160,896..254,1000)
    place_split_structure((160, 896, 254, 1000), dx=716, dy=416, base_keep_px=46)
    # Tipi explorateur rouge-or (cid=172: 368,289..463,368)
    place_split_structure((368, 289, 463, 368), dx=232, dy=636, base_keep_px=42)
    # Petit totem-tipi (814,504..860,568)
    place_split_structure((814, 504, 860, 568), dx=888, dy=572, base_keep_px=34)

    # Arbres ronds Métano 100 % autonomes vérifiés sur planche témoin (0 pixel voisin !)
    tree_w1 = (41, 946, 128, 1016)    # cid=535 (87x70)
    tree_w2 = (41, 658, 128, 728)     # cid=388 (87x70)
    tree_r1 = (721, 50, 800, 128)     # cid=37  (79x78)
    tree_r2 = (1001, 1410, 1079, 1488)# cid=837 (78x78)
    tree_r3 = (601, 1346, 679, 1424)  # cid=797 (78x78)
    trees = [
        (tree_r1, 244, 412),
        (tree_w1, 172, 556),
        (tree_r2, 316, 668),
        (tree_w2, 436, 684),
        (tree_r3, 948, 444),
        (tree_w1, 976, 560),
        (tree_r1, 828, 652),
        (tree_w2, 728, 688),
        (tree_r2, 456, 468),
        (tree_r3, 712, 568),
    ]
    for tbox, tx, ty in trees:
        place_split_structure(tbox, dx=tx, dy=ty, base_keep_px=34)

    # Panneau directionnel bois, table souche & tabourets, meule de foin
    place_split_structure((350, 1140, 404, 1194), dx=648, dy=608, base_keep_px=28)
    place_split_structure((364, 504, 424, 564), dx=656, dy=692, base_keep_px=56, only_main=False)
    place_split_structure((814, 212, 858, 256), dx=296, dy=496, base_keep_px=40)

    anim_imgs = {
        m: [Image.fromarray(anim_4[m][f], 'RGBA') for f in range(4)]
        for m in ('jour', 'nuit')
    }
    base_imgs = {m: Image.fromarray(vill_base[m], 'RGBA') for m in ('jour', 'nuit')}
    top_imgs = {m: Image.fromarray(vill_top[m], 'RGBA') for m in ('jour', 'nuit')}
    return anim_imgs, base_imgs, top_imgs, prop_block


# ==============================================================================
# 5. Encodage des 4 cartes .rsground PMDO 0.8.12 + Projet Mod + ZIP + GIF
# ==============================================================================

def load_template_ground() -> dict:
    with zipfile.ZipFile(ROOT / 'livrables_cliff_nord_nuit_pmdo/PACK_CLIFF_NORD_NUIT_PMDO_0812.zip') as zf:
        doc = json.loads(zf.read('MOD_CLIFF_NORD_NUIT_PMDO/Data/Ground/cliffdaytest_nuit.rsground'))
    return doc


def encode_layer_from_frames(
    name: str,
    draw_layer: int,
    frames: List[Image.Image],
    bank: CompactTileBank,
    frame_length: int = 10,
) -> dict:
    """Encode une liste de 1, 4 ou 8 images RGBA (W, H) en MapLayer RogueEssence dédupliquée."""
    arrs = [np.array(im.convert('RGBA'), dtype=np.uint8) for im in frames]
    n_f = len(arrs)
    tiles_col_major = []
    for x in range(GW):
        col = []
        x0, x1 = x * 8, (x + 1) * 8
        for y in range(GH):
            y0, y1 = y * 8, (y + 1) * 8
            patches = [a[y0:y1, x0:x1] for a in arrs]
            if all(np.all(p[..., 3] == 0) for p in patches):
                col.append({'Layers': []})
                continue
            # Vérifie si toutes les frames de cette cellule 8x8 sont identiques -> 1 seule frame statique !
            first_bytes = patches[0].tobytes()
            if n_f == 1 or all(p.tobytes() == first_bytes for p in patches[1:]):
                tx, ty = bank.add(Image.fromarray(patches[0], 'RGBA'))
                col.append({
                    'Layers': [{
                        'Frames': [{'Sheet': bank.sheet_name, 'TexLoc': {'X': tx, 'Y': ty}}],
                        'FrameLength': frame_length,
                    }]
                })
            else:
                f_refs = []
                for p in patches:
                    tx, ty = bank.add(Image.fromarray(p, 'RGBA'))
                    f_refs.append({'Sheet': bank.sheet_name, 'TexLoc': {'X': tx, 'Y': ty}})
                col.append({'Layers': [{'Frames': f_refs, 'FrameLength': frame_length}]})
        tiles_col_major.append(col)

    return {
        'Name': name,
        'Layer': draw_layer,
        'Visible': True,
        'Tiles': tiles_col_major,
    }


def make_empty_layer(name: str, draw_layer: int = 0) -> dict:
    return {
        'Name': name,
        'Layer': draw_layer,
        'Visible': True,
        'Tiles': [[{'Layers': []} for _ in range(GH)] for _ in range(GW)],
    }


def make_obstacles_grid(plateau_mask: np.ndarray, extra_block: np.ndarray | None = None) -> List[List[int]]:
    """Construit la grille obstacles [GW][GH] PMDO (0 = marchable, 1 = bloqué, 2 = eau/vide franchissable vol/eau)."""
    obs = []
    for x in range(GW):
        col = []
        x0, x1 = x * 8, (x + 1) * 8
        for y in range(GH):
            y0, y1 = y * 8, (y + 1) * 8
            walk_ratio = float(plateau_mask[y0:y1, x0:x1].mean())
            if walk_ratio < 0.85:
                col.append(2 if y * 8 >= HORIZON_Y else 1)
            elif extra_block is not None and np.any(extra_block[y0:y1, x0:x1]):
                col.append(1)
            else:
                col.append(0)
        obs.append(col)
    return obs


def render_scene_frame(
    sky: Image.Image,
    astres: Image.Image | None,
    clouds_mode: Dict[str, Image.Image],
    ocean_8: List[Image.Image],
    layers_f0: List[Image.Image],
    anim_4: List[Image.Image] | None,
    canopy: Image.Image | None,
    frame_idx: int,
    total_frames: int = 16,
) -> Image.Image:
    comp = sky.convert('RGBA').copy()
    if astres is not None:
        comp = Image.alpha_composite(comp, astres)
    for tkey, yoff, cyc in [('horizon', HORIZON_Y - 64, 1), ('milieu', 118, 2), ('haut', 18, 3)]:
        band = clouds_mode[tkey]
        bw = band.width
        shift = int(round(-bw * cyc * (frame_idx / float(total_frames)))) % bw
        row_im = Image.new('RGBA', (W, H), (0, 0, 0, 0))
        for x0 in range(-bw, W + bw, bw):
            dx = x0 + shift
            if dx + bw > 0 and dx < W:
                row_im.alpha_composite(band, (dx, yoff))
        comp = Image.alpha_composite(comp, row_im)

    comp = Image.alpha_composite(comp, ocean_8[frame_idx % 8])
    for im in layers_f0:
        comp = Image.alpha_composite(comp, im)
    if anim_4 is not None:
        comp = Image.alpha_composite(comp, anim_4[frame_idx % 4])
    if canopy is not None:
        comp = Image.alpha_composite(comp, canopy)
    return comp


def main() -> None:
    for d in (OUT_DIR, STAGE_DIR):
        if d.exists():
            shutil.rmtree(d)
    WEB_DIR.mkdir(parents=True, exist_ok=True)
    PNG_DIR.mkdir(parents=True, exist_ok=True)
    ANIM_DIR.mkdir(parents=True, exist_ok=True)
    mod_root = STAGE_DIR / 'MOD_CLIFF_NORD_CENTRE_PMDO'
    (mod_root / 'Content/BG').mkdir(parents=True, exist_ok=True)
    (mod_root / 'Content/Tile').mkdir(parents=True, exist_ok=True)
    (mod_root / 'Data/Ground').mkdir(parents=True, exist_ok=True)

    print('1/6 Décodage des banques natives Halcyon Métano (Jour & Nuit)...', flush=True)
    base_d = np.array(decode_tile_straight(NATIFS_V4 / 'Metano_Town_Base.tile'))
    base_n = np.array(decode_tile_straight(NATIFS_V4 / 'Metano_Town_Base_Night.tile'))
    cliffs_d = np.array(decode_tile_straight(NATIFS_V4 / 'Metano_Town_Cliffs.tile'))
    cliffs_n = np.array(decode_tile_straight(NATIFS_V4 / 'Metano_Town_Cliffs_Night.tile'))
    objs_d = np.array(decode_tile_straight(REFS_CENTRE / 'Metano_Town_Objects.tile'))
    objs_n = np.array(decode_tile_straight(REFS_CENTRE / 'Metano_Town_Objects_Night.tile'))
    anim_ts_d = np.array(decode_tile_straight(REFS_CENTRE / 'Metano_Town_Animation_Tileset.tile'))
    anim_ts_n = np.array(decode_tile_straight(REFS_CENTRE / 'Metano_Town_Animation_Tileset_Night.tile'))

    print('2/6 Construction Ciel Jour/Nuit sans bande + Astres + 3 plans de Nuages + Mer 8 phases...', flush=True)
    skies, astres_nuit, clouds = build_sky_and_clouds()
    ocean = build_ocean_8phases()

    print('3/6 Construction du Grand Cap Central Grass Métano + Parois Falaise + Chemins...', flush=True)
    cape = build_central_cape_layers(base_d, base_n, cliffs_d, cliffs_n)
    plateau_mask = cape['_masks']['plateau']

    print('4/6 Construction Cascade 4 phases, Étang, Moulin, Bannières, Fleurs & Village Métano...', flush=True)
    anim_props, vill_base, vill_top, prop_block = build_animated_props_and_village(
        objs_d, objs_n, anim_ts_d, anim_ts_n, plateau_mask
    )

    # Écriture des .dir de fond (Jour & Nuit) + exports PNG 1x pour le visualiseur live
    dir_stats = []
    dir_stats.append(write_dir_sheet(mod_root / 'Content/BG/CLIFF_CENTRE_JOUR_CIEL.dir', skies['jour']))
    dir_stats.append(write_dir_sheet(mod_root / 'Content/BG/CLIFF_CENTRE_NUIT_CIEL.dir', skies['nuit']))
    dir_stats.append(write_dir_sheet(mod_root / 'Content/BG/CLIFF_CENTRE_NUIT_ASTRES.dir', astres_nuit))
    for mode in ('jour', 'nuit'):
        save_png(skies[mode], WEB_DIR / f'{mode}_BG00_ciel.png')
        for tkey in ('horizon', 'milieu', 'haut'):
            dname = f'CLIFF_CENTRE_{mode.upper()}_NUAGES_{tkey.upper()}'
            dir_stats.append(write_dir_sheet(mod_root / 'Content/BG' / f'{dname}.dir', clouds[mode][tkey]))
            save_png(clouds[mode][tkey], WEB_DIR / f'{mode}_nuages_{tkey}_1440.png')
    save_png(astres_nuit, WEB_DIR / 'nuit_BG01_astres.png')

    for mode in ('jour', 'nuit'):
        for k in range(8):
            save_png(ocean[mode][k], WEB_DIR / f'{mode}_L00_mer_{k:02d}.png')
        save_png(cape[mode]['falaise'], WEB_DIR / f'{mode}_L01_falaise_parois_metano.png')
        save_png(cape[mode]['grass'], WEB_DIR / f'{mode}_L02_plateau_grass_metano.png')
        save_png(cape[mode]['chemins'], WEB_DIR / f'{mode}_L03_chemins_sable_metano.png')
        for f in range(4):
            save_png(anim_props[mode][f], WEB_DIR / f'{mode}_L04_cascade_etang_fleurs_{f:02d}.png')
        save_png(vill_base[mode], WEB_DIR / f'{mode}_L05_arbres_village_metano.png')
        save_png(vill_top[mode], WEB_DIR / f'{mode}_L07_canopee_avant_plan.png')

    # Copie aussi tous les calques 1x individuels dans le dossier du pack ZIP
    calques_zip_dir = STAGE_DIR / 'calques_1x_separes'
    calques_zip_dir.mkdir(parents=True, exist_ok=True)
    for p in sorted(WEB_DIR.glob('*.png')):
        shutil.copyfile(p, calques_zip_dir / p.name)

    print('5/6 Encodage des banques .tile dédupliquées & des 4 cartes .rsground PMDO 0.8.12...', flush=True)
    tpl_doc = load_template_ground()
    banks = {
        'jour': CompactTileBank('CliffCentre_Jour', cols=64),
        'nuit': CompactTileBank('CliffCentre_Nuit', cols=64),
    }

    obs_full = make_obstacles_grid(plateau_mask, extra_block=prop_block)
    obs_bare = make_obstacles_grid(plateau_mask, extra_block=None)

    map_entries = []
    for mode in ('jour', 'nuit'):
        bank = banks[mode]
        bg_layers = [{'BG': make_map_bg(f'CLIFF_CENTRE_{mode.upper()}_CIEL', 0, 0, False)}]
        if mode == 'nuit':
            bg_layers.append({'BG': make_map_bg('CLIFF_CENTRE_NUIT_ASTRES', 0, 0, False)})
        bg_layers.extend([
            {'BG': make_map_bg(f'CLIFF_CENTRE_{mode.upper()}_NUAGES_HORIZON', HORIZON_Y - 64, -5, True)},
            {'BG': make_map_bg(f'CLIFF_CENTRE_{mode.upper()}_NUAGES_MILIEU', 118, -9, True)},
            {'BG': make_map_bg(f'CLIFF_CENTRE_{mode.upper()}_NUAGES_HAUT', 18, -14, True)},
        ])

        l_mer = encode_layer_from_frames('00_Mer_Animee_8_Phases', 0, ocean[mode], bank, frame_length=10)
        l_fal = encode_layer_from_frames('01_Falaise_Parois_Metano', 0, [cape[mode]['falaise']], bank)
        l_grs = encode_layer_from_frames('02_Plateau_Grass_Metano', 0, [cape[mode]['grass']], bank)
        l_pth = encode_layer_from_frames('03_Chemins_Sable_Metano', 0, [cape[mode]['chemins']], bank)
        l_anm = encode_layer_from_frames('04_Cascade_Etang_Fleurs_Animes', 0, anim_props[mode], bank, frame_length=10)
        l_vil = encode_layer_from_frames('05_Arbres_Village_Metano', 0, [vill_base[mode]], bank)
        l_usr = make_empty_layer('06_Votre_Village_Libre', 0)
        l_top = encode_layer_from_frames('07_Canopee_Avant_Plan', 4, [vill_top[mode]], bank)

        for variant, asset_name, title, layers_list, obs_grid in [
            (
                'complet',
                f'cliff_nord_centre_{mode}',
                f'Cliff Nord Centrée Métano ({mode.capitalize()})',
                [l_mer, l_fal, l_grs, l_pth, l_anm, l_vil, l_usr, l_top],
                obs_full,
            ),
            (
                'nue',
                f'cliff_nord_centre_nue_{mode}',
                f'Cliff Nord Centrée Métano — Plateau Nu ({mode.capitalize()})',
                [
                    copy.deepcopy(l_mer),
                    copy.deepcopy(l_fal),
                    copy.deepcopy(l_grs),
                    make_empty_layer('03_Vos_Chemins_Sols', 0),
                    make_empty_layer('04_Vos_Structures_Base', 0),
                    make_empty_layer('05_Votre_Canopee_Avant_Plan', 4),
                ],
                obs_bare,
            ),
        ]:
            doc = copy.deepcopy(tpl_doc)
            doc['Version'] = '0.8.12.0'
            obj = doc['Object']
            obj['AssetName'] = asset_name
            obj['Name']['DefaultText'] = title
            obj['Comment'] = (
                f'PMDO 0.8.12 — Cap central Grass Métano 100 % textures natives Halcyon/Chunsoft ({mode}). '
                f'Ciel & 3 nuages animés + Mer 8 phases + Falaise & Plateau multicalques.'
            )
            obj['Background'] = {
                '$type': 'RogueEssence.Dungeon.LayeredBG, RogueEssence',
                'Layers': copy.deepcopy(bg_layers),
            }
            obj['Layers'] = layers_list
            obj['obstacles'] = obs_grid
            obj['Decorations'] = []
            # Place le point d'entrée joueur pile sur l'isthme Sud centré (X = 592, Y = 816) !
            if obj.get('Entities') and obj['Entities'][0].get('Markers'):
                obj['Entities'][0]['Markers'] = [obj['Entities'][0]['Markers'][0]]
                obj['Entities'][0]['Markers'][0]['Name'] = 'Entrance_Sud'
                obj['Entities'][0]['Markers'][0]['Loc'] = {'X': 592, 'Y': 816}
                obj['Entities'][0]['Markers'][0]['Dir'] = 4  # Up (face au cap et à la mer !)

            out_rsg = mod_root / f'Data/Ground/{asset_name}.rsground'
            out_rsg.write_bytes(json.dumps(doc, ensure_ascii=False, separators=(',', ':')).encode('utf-8'))

            for ns_dir in [
                mod_root / f'Data/Script/ground/{asset_name}',
                mod_root / f'Data/Script/cliff_nord_centre_pmdo/ground/{asset_name}',
            ]:
                ns_dir.mkdir(parents=True, exist_ok=True)
                (ns_dir / 'init.lua').write_text(
                    f'-- {asset_name} : animations ciel/mer/cascade 100 % natives moteur PMDO 0.8.12\n'
                    f'local {asset_name} = {{}}\nfunction {asset_name}.Init(map)\n  COMMON.RespawnAllies()\nend\n'
                    f'return {asset_name}\n',
                    encoding='utf-8',
                )
            map_entries.append({
                'asset': asset_name,
                'mode': mode,
                'variant': variant,
                'size_px': [W, H],
                'grid_tiles': [GW, GH],
                'layer_count': len(layers_list),
                'bytes': out_rsg.stat().st_size,
            })

    tile_stats = []
    tile_paths = []
    for mode in ('jour', 'nuit'):
        tp = mod_root / f"Content/Tile/{banks[mode].sheet_name}.tile"
        tile_stats.append(banks[mode].write(tp))
        tile_paths.append(tp)
    write_tile_index_idx(mod_root / 'Content/Tile/index.idx', tile_paths)

    # Mod.xml & INSTALLER.py sécurisé (ne remplace jamais l'index.idx d'un autre mod existant)
    ident = uuid.uuid5(uuid.NAMESPACE_URL, 'https://github.com/meromoonmeri/projet-creation-pmdo/cliff_nord_centre_pmdo')
    (mod_root / 'Mod.xml').write_text(
        f'''<?xml version="1.0" encoding="utf-8"?>
<Header>
  <Name>Cliff Nord Centree Metano - Jour et Nuit Animes (0.8.12)</Name>
  <Author>meromoonmeri</Author>
  <Description>Cap central Grass Metano multicalque (Jour et Nuit, complet et plateau nu), mer animee 8 phases, ciel et 3 plans de nuages en parallaxe.</Description>
  <Namespace>cliff_nord_centre_pmdo</Namespace>
  <UUID>{ident}</UUID>
  <Version>1.0.0.0</Version>
  <GameVersion>0.8.12.0</GameVersion>
  <ModType>Quest</ModType>
  <Relationships />
</Header>
''',
        encoding='utf-8',
    )
    inst_txt = INSTALLER_SRC.read_text(encoding='utf-8')
    needle = '            relative = src.relative_to(source)\n'
    if needle in inst_txt:
        inst_txt = inst_txt.replace(
            needle,
            needle + "            if relative.as_posix() == 'Content/Tile/index.idx':\n                continue\n",
        )
    (mod_root / 'INSTALLER.py').write_text(inst_txt, encoding='utf-8')

    print('6/6 Rendus PNG 1x sans perte, GIF animés 1x et archive PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip...', flush=True)
    for mode in ('jour', 'nuit'):
        ast = astres_nuit if mode == 'nuit' else None
        comp_full = render_scene_frame(
            skies[mode], ast, clouds[mode], ocean[mode],
            [cape[mode]['falaise'], cape[mode]['grass'], cape[mode]['chemins'], vill_base[mode]],
            anim_props[mode], vill_top[mode], frame_idx=0, total_frames=16,
        )
        comp_bare = render_scene_frame(
            skies[mode], ast, clouds[mode], ocean[mode],
            [cape[mode]['falaise'], cape[mode]['grass']],
            None, None, frame_idx=0, total_frames=16,
        )
        save_png(comp_full, PNG_DIR / f'cliff_nord_centre_{mode}.png')
        save_png(comp_bare, PNG_DIR / f'cliff_nord_centre_nue_{mode}.png')

        # GIF 1x 16 frames (mer 8 phases x 2 cycles + nuages continus + cascade/moulin/bannières/fleurs 4 phases)
        gif_frames = []
        for fi in range(16):
            fr_im = render_scene_frame(
                skies[mode], ast, clouds[mode], ocean[mode],
                [cape[mode]['falaise'], cape[mode]['grass'], cape[mode]['chemins'], vill_base[mode]],
                anim_props[mode], vill_top[mode], frame_idx=fi, total_frames=16,
            )
            gif_frames.append(fr_im.convert('RGB').quantize(colors=256, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE))
        gif_path = ANIM_DIR / f'cliff_nord_centre_{mode}_anime.gif'
        gif_frames[0].save(
            gif_path, save_all=True, append_images=gif_frames[1:],
            duration=167, loop=0, optimize=True,
        )

    # Audit strict de provenance des couleurs Jour du terrain (0 pixel IA, 100 % couleurs natives Métano)
    native_colors = set(map(tuple, base_d.reshape(-1, 4)[:, :3])) | set(map(tuple, cliffs_d.reshape(-1, 4)[:, :3]))
    for cname, cim in [('falaise', cape['jour']['falaise']), ('grass', cape['jour']['grass']), ('chemins', cape['jour']['chemins'])]:
        ca = np.array(cim)
        op_rgb = set(map(tuple, ca[ca[..., 3] > 0][:, :3]))
        outside = op_rgb - native_colors
        assert len(outside) == 0, f'{cname} contient {len(outside)} couleurs hors planches natives Metano !'

    manifest = {
        'title': 'Cliff Nord Centrée — Grass Métano Multicalque (Jour & Nuit Animés)',
        'pmdo_version': '0.8.12',
        'serialization_version': '0.8.12.0',
        'art_approved': False,
        'runtime_tested': False,
        'ai_generated_pixels': 0,
        'day_terrain_out_of_native_palette_pixels': 0,
        'dimensions_px': [W, H],
        'grid_tiles_8px': [GW, GH],
        'horizon_y_px': HORIZON_Y,
        'symmetry_center_x_px': W // 2,
        'south_walkable_isthmus_x_px': [484, 716],
        'credits': [
            'Palikadude / projet Pokémon Mystery Dungeon: Halcyon (planches Metano_Town_Base, Metano_Town_Cliffs, Metano_Town_Objects, Metano_Town_Animation_Tileset et variantes _Night)',
            'Chunsoft / Spike Chunsoft / Nintendo / The Pokémon Company (sprites originaux PMD Explorateurs du Ciel : océan 8 phases, nuages et astres)',
        ],
        'maps': map_entries,
        'tilesets': tile_stats,
        'bg_dirs': dir_stats,
    }
    (OUT_DIR / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding='utf-8')
    (STAGE_DIR / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=2), encoding='utf-8')

    readme_md = """# Cliff Nord Centrée — Grass Métano Multicalque (PMDO 0.8.12, Jour & Nuit Animés)

## Contenu du pack (`100 % textures natives Halcyon / Chunsoft — 0 % génération IA`)
- **Dimensions** : `1200 × 880 px` (`150 × 110` tuiles `8×8`, `TexSize = 8`), promontoire **parfaitement centré sur `X = 600 px`** entouré par la mer animée à l'**Ouest**, au **Nord** et à l'**Est**, avec **isthme piéton centré au Sud (`X = 484..716, Y = 880`)**.
- **4 cartes `.rsground` prêtes pour PMDO `0.8.12`** dans `MOD_CLIFF_NORD_CENTRE_PMDO/Data/Ground/` :
  1. `cliff_nord_centre_jour.rsground` — **Jour complet animé** (`8` calques `MapLayer` + `4` couches `LayeredBG`)
  2. `cliff_nord_centre_nuit.rsground` — **Nuit étoilée animée** (`8` calques `MapLayer` + `5` couches `LayeredBG` avec lune & étoiles)
  3. `cliff_nord_centre_nue_jour.rsground` — **Plateau Nu Jour prêt à bâtir** (Ciel/Nuages + Mer 8 phases + Parois Falaise + Plateau Grass Métano + 3 calques vierges)
  4. `cliff_nord_centre_nue_nuit.rsground` — **Plateau Nu Nuit prêt à bâtir**
- **Calques séparés `PNG 1×` sans perte** (`Jour` & `Nuit`) dans `calques_1x_separes/` et rendus complets dans `png_1x/`.

## Installation dans votre projet PMDO existant (sans écraser votre `index.idx`)
```bash
python INSTALLER.py "CHEMIN/VERS/PMDO/MODS/TON_MOD" --dry-run
python INSTALLER.py "CHEMIN/VERS/PMDO/MODS/TON_MOD"
```

## Crédits & Statut honnête
- **Crédits artistiques** : **Palikadude** (*PMD: Halcyon* — `Metano_Town_Base`, `Metano_Town_Cliffs`, `Metano_Town_Objects`, `Metano_Town_Animation_Tileset` et variantes `_Night`) & **Chunsoft / Nintendo / The Pokémon Company** (*PMD: Explorateurs du Ciel*).
- **Statut de vérification** : `art_approved: false`, `runtime_tested: false` (vérifié mathématiquement sur la structure binaire `.tile` / `.dir` / `index.idx` / `.rsground` ; à ouvrir dans l'éditeur Ground de PMDO `0.8.12` pour validation finale en jeu).
"""
    (OUT_DIR / 'README.md').write_text(readme_md, encoding='utf-8')
    (STAGE_DIR / 'README.md').write_text(readme_md, encoding='utf-8')
    (STAGE_DIR / 'png_1x').mkdir(exist_ok=True)
    for p in sorted(PNG_DIR.glob('*.png')):
        shutil.copyfile(p, STAGE_DIR / 'png_1x' / p.name)

    zip_path = OUT_DIR / 'PACK_CLIFF_NORD_CENTRE_PMDO_0812.zip'
    with zipfile.ZipFile(zip_path, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for f in sorted(STAGE_DIR.rglob('*')):
            if f.is_file():
                zf.write(f, f.relative_to(STAGE_DIR).as_posix())

    shutil.rmtree(STAGE_DIR, ignore_errors=True)
    print(f'SUCCÈS : {zip_path} ({zip_path.stat().st_size / (1024*1024):.2f} MiB)', flush=True)
    for t in tile_stats:
        print(f"  Banque {t['sheet']}: {t['tile_count']} tuiles uniques ({t['bytes']/1024:.1f} KiB)")


if __name__ == '__main__':
    main()
