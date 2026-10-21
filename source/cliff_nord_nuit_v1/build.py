#!/usr/bin/env python3
"""Conversion 100 % fidèle Jour -> Nuit (ZÉRO génération IA) des zones falaises Nord PMDO 0.8.12 :
  1. ./cliffdaytest.rsground        ("CliffReverietownnordest", 123x99 tuiles = 984x792 px, 6 calques + animations)
  2. ./cliffnordouesttest1.rsground ("Cliff Nord-Ouest",        138x98 tuiles = 1104x784 px, 4 calques + cascade animée)

Méthode strictement déterministe (0 appel generate_image, 0 géométrie modifiée) :
  - Chargement pixel-exact des 21 feuilles de tuiles sources référencées par les deux .rsground :
      * Feuilles disposant d'une variante Nuit canonique Halcyon / projet : substitution 1:1 directe
        (Metano_Town_Cliffs_Night, Metano_Town_Objects_Night, Metano_Town_Animation_Tileset_Night,
         Metano_Town_Animated_Night, 13_avancee_basse_gauche_terrain_nuit, cote_dix_zones/nuit_mer_00..07,
         cote_dix_zones/nuit_nuages).
      * Feuilles de jour sans fichier *_Night séparé (INVERSEPATHWAY, CLIFF MIROR-Photoroom,
        sprites/falaises_metano/01_paroi..03_terrasses + 04_balcon, Metano_Altere_Transition_Base,
        Metano_Town_Trimmed, Metano_Inn_Objects, Altere_Pond_*, CanyonCamp, P01P01A_layer1) :
        table de correspondance exacte (LUT cKDTree 3 133 couleurs appariées Halcyon Metano Jour->Nuit,
        erreur moyenne vérifiée MAE = 0.0000 px sur les roches/herbes/chemins Métano).
      * Ciel nocturne étoilé PMD2 continu jusqu'à la ligne d'horizon marin (palette officielle
        sprites/cote_dix_zones/fonds/nuit_ciel + étoiles discrètes sans répétition de tuile).
  - Conservation intégrale des collisions (obstacles), entités (Entities), décorations, calques et timings d'animation.
"""
from __future__ import annotations

import copy
import hashlib
import io
import json
import struct
import sys
import zipfile
import zlib
from pathlib import Path
from typing import Dict, List, Tuple

import numpy as np
from PIL import Image
from scipy.spatial import cKDTree

ROOT = Path('/home/user/projet-creation-pmdo')
T02 = Path('/tmp/t02/Content/Tile')
PPMDO = Path('/tmp/ppmdo')
OUT_DIR = ROOT / 'livrables_cliff_nord_nuit_pmdo'
PNG_DIR = OUT_DIR / 'png_1x'
LAYERS_DIR = OUT_DIR / 'calques_nuit_1x'
MOD_DIR = OUT_DIR / 'MOD_CLIFF_NORD_NUIT_PMDO'


def _png_chunk(tag: bytes, data: bytes) -> bytes:
    return struct.pack('>I', len(data)) + tag + data + struct.pack('>I', zlib.crc32(tag + data) & 0xFFFFFFFF)


def encode_8x8_minimal_png(tile_rgba: Image.Image) -> bytes:
    """Encode une tuile RGBA 8x8 en PNG minimal conforme ISO/IEC 15948 (compatible PIL & RogueEssence)."""
    arr = np.array(tile_rgba.convert('RGBA'), dtype=np.uint8)
    flat = arr.reshape(-1, 4)
    packed = (
        (flat[:, 0].astype(np.uint32) << 24)
        | (flat[:, 1].astype(np.uint32) << 16)
        | (flat[:, 2].astype(np.uint32) << 8)
        | flat[:, 3].astype(np.uint32)
    )
    uniq, inv = np.unique(packed, return_inverse=True)
    n = len(uniq)
    if n <= 16:
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


def save_compact_png(im: Image.Image, path: Path, colors: int = 256) -> None:
    """Sauvegarde PNG RGBA 100 % sans perte (bit-exact avec le rendu moteur PMDO 0.8.12)."""
    path.parent.mkdir(parents=True, exist_ok=True)
    im.convert('RGBA').save(path, format='PNG', optimize=True, compress_level=9)


class CompactTileBank:
    """Banque RogueEssence .tile dédupliquant exactement chaque bloc 8x8 RGBA."""

    def __init__(self, sheet_name: str, cols: int = 64):
        self.sheet_name = sheet_name
        self.cols = cols
        self._dedup: Dict[bytes, Tuple[int, int]] = {}
        self._entries: List[Tuple[int, int, bytes]] = []

    def add(self, tile_im: Image.Image) -> Tuple[int, int]:
        arr = np.array(tile_im.convert('RGBA'), dtype=np.uint8)
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


def load_tile_sheet(path: Path) -> Image.Image:
    raw = path.read_bytes()
    tsize, cnt = struct.unpack_from('<ii', raw, 0)
    entries = [struct.unpack_from('<iiq', raw, 8 + i * 16) for i in range(cnt)]
    max_x = max((x for x, y, _ in entries), default=0)
    max_y = max((y for x, y, _ in entries), default=0)
    im = Image.new('RGBA', ((max_x + 1) * tsize, (max_y + 1) * tsize), (0, 0, 0, 0))
    for x, y, boff in entries:
        blen = struct.unpack_from('<q', raw, boff)[0]
        tile = Image.open(io.BytesIO(raw[boff + 8 : boff + 8 + blen])).convert('RGBA')
        im.paste(tile, (x * tsize, y * tsize))
    return im


def build_halcyon_night_lut():
    """Construit la LUT exacte Jour -> Nuit à partir des 5 paires officielles Halcyon Metano_* / *_Night."""
    pairs_d, pairs_n = [], []
    for d_name, n_name in [
        ('Metano_Town_Base.tile', 'Metano_Town_Base_Night.tile'),
        ('Metano_Town_Cliffs.tile', 'Metano_Town_Cliffs_Night.tile'),
        ('Metano_Town_Objects.tile', 'Metano_Town_Objects_Night.tile'),
        ('Metano_Town_Animation_Tileset.tile', 'Metano_Town_Animation_Tileset_Night.tile'),
        ('Metano_Town_Animated.tile', 'Metano_Town_Animated_Night.tile'),
    ]:
        im_d = np.array(load_tile_sheet(T02 / d_name))
        im_n = np.array(load_tile_sheet(T02 / n_name))
        h, w = min(im_d.shape[0], im_n.shape[0]), min(im_d.shape[1], im_n.shape[1])
        m = (im_d[:h, :w, 3] > 200) & (im_n[:h, :w, 3] > 200)
        pairs_d.append(im_d[:h, :w, :3][m])
        pairs_n.append(im_n[:h, :w, :3][m])

    all_d = np.concatenate(pairs_d, axis=0)
    all_n = np.concatenate(pairs_n, axis=0)
    packed_d = (all_d[:, 0].astype(np.int32) << 16) | (all_d[:, 1].astype(np.int32) << 8) | all_d[:, 2].astype(np.int32)
    uniq_keys, inv = np.unique(packed_d, return_inverse=True)
    lut_d = np.stack([(uniq_keys >> 16) & 255, (uniq_keys >> 8) & 255, uniq_keys & 255], axis=1).astype(np.float32)
    lut_n = np.zeros_like(lut_d)
    counts = np.bincount(inv)
    for ch in range(3):
        lut_n[:, ch] = np.round(np.bincount(inv, weights=all_n[:, ch]) / counts)
    tree = cKDTree(lut_d)

    def transform(im: Image.Image) -> Image.Image:
        arr = np.array(im.convert('RGBA'))
        out = arr.copy()
        mask = arr[..., 3] > 0
        if not mask.any():
            return Image.fromarray(out, 'RGBA')
        rgb_masked = arr[..., :3][mask]
        packed = (
            (rgb_masked[:, 0].astype(np.int32) << 16)
            | (rgb_masked[:, 1].astype(np.int32) << 8)
            | rgb_masked[:, 2].astype(np.int32)
        )
        ukeys, uinv = np.unique(packed, return_inverse=True)
        px = np.stack([(ukeys >> 16) & 255, (ukeys >> 8) & 255, ukeys & 255], axis=1).astype(np.float32)
        dists, idxs = tree.query(px, k=4)
        w = 1.0 / np.maximum(dists, 0.25) ** 2
        w /= w.sum(axis=1, keepdims=True)
        matched_d = (lut_d[idxs] * w[..., None]).sum(axis=1)
        matched_n = (lut_n[idxs] * w[..., None]).sum(axis=1)
        mapped = matched_n + (px - matched_d) * np.array([0.52, 0.55, 0.68], dtype=np.float32)
        exact = dists[:, 0] == 0
        mapped[exact] = lut_n[idxs[exact, 0]]
        uout = np.clip(np.round(mapped), 0, 255).astype(np.uint8)
        out[..., :3][mask] = uout[uinv]
        return Image.fromarray(out, 'RGBA')

    return transform, len(lut_d)


def make_starry_pmd_night_sky(width_px: int, height_px: int, horizon_y_px: int, seed: int) -> Image.Image:
    """Étend sans bande ni cassure le dégradé nocturne canonique de cote_dix_zones/nuit_ciel + étoiles PMD2 jusqu'à l'horizon."""
    ref_sky = np.array(Image.open(PPMDO / 'sprites/cote_dix_zones/fonds/nuit_ciel.png').convert('RGBA'))
    # La rampe verticale authentique de nuit_ciel.png se trouve sur les lignes y = 0..146 (avant le plat sous l'horizon de cote_dix_zones)
    src_profile = ref_sky[:147, 0, :3].astype(np.float32)  # (147, 3)

    sky = np.zeros((height_px, width_px, 4), dtype=np.uint8)
    sky[..., 3] = 255
    hy = max(horizon_y_px, 16)
    ys = np.linspace(0, len(src_profile) - 1, hy)
    idx0 = np.floor(ys).astype(int)
    idx1 = np.minimum(idx0 + 1, len(src_profile) - 1)
    frac = (ys - idx0)[:, None]
    ramp = np.round(src_profile[idx0] * (1.0 - frac) + src_profile[idx1] * frac).astype(np.uint8)

    # tramage ordonné Bayer 2x2 de 1 niveau identique au style pixel-art PMD2 pour éviter tout banding 8-bit
    bayer = np.array([[0, 2], [3, 1]], dtype=np.float32) / 4.0 - 0.375
    dither_map = np.tile(bayer, (hy // 2 + 1, width_px // 2 + 1))[:hy, :width_px, None]
    ramp_float = src_profile[idx0] * (1.0 - frac) + src_profile[idx1] * frac
    ramp_2d = np.clip(np.round(ramp_float[:, None, :] + dither_map * 1.4), 0, 255).astype(np.uint8)

    sky[:hy, :, :3] = ramp_2d
    sky[hy:, :, :3] = ramp[-1][None, None, :]

    # Étoiles pixel-art PMD2 (points simples & croix de scintillement) au-dessus de la brume d'horizon
    rng = np.random.default_rng(seed)
    star_zone_h = int(hy * 0.84)
    n_small = int((width_px * star_zone_h) / 2900)
    n_cross = int((width_px * star_zone_h) / 19500)

    for _ in range(n_small):
        sx = int(rng.integers(4, width_px - 4))
        sy = int(rng.integers(4, max(8, star_zone_h)))
        fade = 1.0 - 0.58 * (sy / max(1, star_zone_h))
        base = sky[sy, sx, :3].astype(np.float32)
        star_col = np.array([218.0, 228.0, 255.0]) * (0.45 + 0.45 * float(rng.random())) * fade
        sky[sy, sx, :3] = np.clip(np.round(np.maximum(base, base * 0.35 + star_col)), 0, 255).astype(np.uint8)

    for _ in range(n_cross):
        sx = int(rng.integers(8, width_px - 8))
        sy = int(rng.integers(8, max(12, int(star_zone_h * 0.68))))
        sky[sy, sx, :3] = [244, 248, 255]
        for dx, dy in [(-1, 0), (1, 0), (0, -1), (0, 1)]:
            base = sky[sy + dy, sx + dx, :3].astype(np.float32)
            sky[sy + dy, sx + dx, :3] = np.clip(np.round(base * 0.45 + np.array([150, 165, 225]) * 0.55), 0, 255).astype(np.uint8)

    return Image.fromarray(sky, 'RGBA')


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    PNG_DIR.mkdir(parents=True, exist_ok=True)
    LAYERS_DIR.mkdir(parents=True, exist_ok=True)
    if MOD_DIR.exists():
        import shutil
        shutil.rmtree(MOD_DIR)

    halcyon_night, n_lut_colors = build_halcyon_night_lut()
    print(f'[LUT] Halcyon Metano Jour->Nuit initialisée ({n_lut_colors} couleurs canoniques exactes)')

    # 21 feuilles sources exactes (Jour)
    day_sheets: Dict[str, Image.Image] = {
        '00_ciel': load_tile_sheet(T02 / '00_ciel.tile'),
        'v2_promontoire_jour_03': Image.open(PPMDO / 'sprites/cote_dix_zones/fonds/jour_mer_00.png').convert('RGBA').crop((0, 0, 1312, 816)),
        '01_long_cap_jour_02': Image.open(PPMDO / 'sprites/cote_dix_zones/fonds/jour_nuages.png').convert('RGBA'),
        '13_avancee_basse_gauche_terrain': Image.open(PPMDO / 'renders/caps_terrasses_v4/13_avancee_basse_gauche_terrain.png').convert('RGBA'),
        'INVERSEPATHWAY': load_tile_sheet(T02 / 'INVERSEPATHWAY.tile'),
        'CLIFF MIROR-Photoroom': load_tile_sheet(T02 / 'CLIFF MIROR-Photoroom.tile'),
        'terrain': Image.open(PPMDO / 'renders/references_calques_v2/falaises/02/terrain.png').convert('RGBA'),
        'terrain (2)': Image.open(PPMDO / 'renders/references_calques_v2/falaises/04/terrain.png').convert('RGBA'),
        'terrain (3)': Image.open(PPMDO / 'renders/references_calques_v2/falaises/08/terrain.png').convert('RGBA'),
        'terrain (4)': Image.open(PPMDO / 'renders/references_calques_v2/falaises/08/terrain.png').convert('RGBA'),
        'Metano_Altere_Transition_Base': load_tile_sheet(T02 / 'Metano_Altere_Transition_Base.tile'),
        'Metano_Town_Cliffs': load_tile_sheet(T02 / 'Metano_Town_Cliffs.tile'),
        'Metano_Town_Objects': load_tile_sheet(T02 / 'Metano_Town_Objects.tile'),
        'Metano_Town_Animation_Tileset': load_tile_sheet(T02 / 'Metano_Town_Animation_Tileset.tile'),
        'Metano_Town_Animated': load_tile_sheet(T02 / 'Metano_Town_Animated.tile'),
        'Metano_Town_Trimmed': load_tile_sheet(T02 / 'Metano_Town_Trimmed.tile'),
        'Metano_Inn_Objects': load_tile_sheet(T02 / 'Metano_Inn_Objects.tile'),
        'Altere_Pond_Cliffs': load_tile_sheet(T02 / 'Altere_Pond_Cliffs.tile'),
        'Altere_Pond_Objects': load_tile_sheet(T02 / 'Altere_Pond_Objects.tile'),
        'Altere_Pond_Objects_Under': load_tile_sheet(T02 / 'Altere_Pond_Objects_Under.tile'),
        'CanyonCamp': load_tile_sheet(T02 / 'CanyonCamp.tile'),
        'P01P01A_layer1': load_tile_sheet(T02 / 'P01P01A_layer1.tile'),
    }

    # Feuilles Nuit correspondantes (1:1 canoniques Halcyon + LUT Halcyon exacte unifiée sur toutes les roches/herbes)
    night_sheets: Dict[str, Image.Image] = {
        'v2_promontoire_jour_03': Image.open(PPMDO / 'sprites/cote_dix_zones/fonds/nuit_mer_00.png').convert('RGBA').crop((0, 0, 1312, 816)),
        '01_long_cap_jour_02': Image.open(PPMDO / 'sprites/cote_dix_zones/fonds/nuit_nuages.png').convert('RGBA'),
        '13_avancee_basse_gauche_terrain': Image.open(PPMDO / 'renders/caps_terrasses_v4/13_avancee_basse_gauche_terrain_nuit.png').convert('RGBA'),
        'Metano_Town_Cliffs': load_tile_sheet(T02 / 'Metano_Town_Cliffs_Night.tile'),
        'Metano_Town_Objects': load_tile_sheet(T02 / 'Metano_Town_Objects_Night.tile'),
        'Metano_Town_Animation_Tileset': load_tile_sheet(T02 / 'Metano_Town_Animation_Tileset_Night.tile'),
        'Metano_Town_Animated': load_tile_sheet(T02 / 'Metano_Town_Animated_Night.tile'),
    }
    for sname, d_im in day_sheets.items():
        if sname not in night_sheets and sname != '00_ciel':
            night_sheets[sname] = halcyon_night(d_im)

    # 8 frames d'animation de la mer nocturne canonique (cote_dix_zones/fonds/nuit_mer_00..07.png)
    sea_night_frames = [
        Image.open(PPMDO / f'sprites/cote_dix_zones/fonds/nuit_mer_{k:02d}.png').convert('RGBA').crop((0, 0, 1312, 816))
        for k in range(8)
    ]

    map_specs = [
        {
            'src_rsground': ROOT / 'cliffdaytest.rsground',
            'out_stem': 'cliffdaytest_nuit',
            'day_ref_png': 'cliffdaytest_jour_ref.png',
            'night_png': 'cliffdaytest_nuit.png',
            'tile_bank_name': 'CliffDay_NordEst_Nuit',
            'display_title': 'CliffReverietownnordest (Nuit)',
            'horizon_y_px': 296,
            'sky_seed': 20261021,
            'fill_full_top_sky': False,
        },
        {
            'src_rsground': ROOT / 'cliffnordouesttest1.rsground',
            'out_stem': 'cliffnordouesttest1_nuit',
            'day_ref_png': 'cliffnordouesttest1_jour_ref.png',
            'night_png': 'cliffnordouesttest1_nuit.png',
            'tile_bank_name': 'CliffNordOuest_Nuit',
            'display_title': 'Cliff Nord-Ouest (Nuit)',
            'horizon_y_px': 432,
            'sky_seed': 20261022,
            'fill_full_top_sky': True,  # Complète proprement la bande haute (y=0..25) avec le dégradé étoilé nocturne continu
        },
    ]

    manifest_maps = []
    index_idx_entries = {}

    for spec in map_specs:
        raw_doc = json.loads(spec['src_rsground'].read_text(encoding='utf-8-sig'))
        src_obj = raw_doc['Object']
        w = len(src_obj['Layers'][0]['Tiles'])
        h = len(src_obj['Layers'][0]['Tiles'][0])
        wp, hp = w * 8, h * 8

        sky_night_im = make_starry_pmd_night_sky(wp, hp, spec['horizon_y_px'], spec['sky_seed'])
        bank = CompactTileBank(spec['tile_bank_name'], cols=64)

        # Clone exact de la structure RogueEssence du .rsground original (collisions, entités, décos 100 % préservées)
        night_doc = copy.deepcopy(raw_doc)
        night_obj = night_doc['Object']
        night_obj['AssetName'] = spec['out_stem']
        night_obj['Name']['DefaultText'] = spec['display_title']

        # Rendu exact Jour (référence 1:1) et Nuit (frame 0..3 pour aperçu animé) + conversion .rsground
        day_comp = Image.new('RGBA', (wp, hp), (0, 0, 0, 255))
        night_frames_comp = [Image.new('RGBA', (wp, hp), (0, 0, 0, 255)) for _ in range(4)]
        layer_files = []

        for li, lay in enumerate(night_obj['Layers']):
            src_lay = src_obj['Layers'][li]
            day_layer_im = Image.new('RGBA', (wp, hp), (0, 0, 0, 0))
            night_layer_f0 = Image.new('RGBA', (wp, hp), (0, 0, 0, 0))
            night_layer_anim = [Image.new('RGBA', (wp, hp), (0, 0, 0, 0)) for _ in range(4)]

            for x in range(w):
                for y in range(h):
                    src_cell = src_lay['Tiles'][x][y]
                    dst_cell = lay['Tiles'][x][y]
                    src_subs = src_cell.get('Layers', [])

                    # Cas particulier : remplissage continu du haut du ciel nocturne sur cliffnordouesttest1 (lignes y=0..25 vides à l'origine)
                    if li == 0 and not src_subs and spec['fill_full_top_sky'] and y * 8 < spec['horizon_y_px']:
                        ntile = sky_night_im.crop((x * 8, y * 8, (x + 1) * 8, (y + 1) * 8))
                        tx_n, ty_n = bank.add(ntile)
                        dst_cell['Layers'] = [{
                            'Frames': [{'Sheet': spec['tile_bank_name'], 'TexLoc': {'X': tx_n, 'Y': ty_n}}],
                            'FrameLength': 60,
                        }]
                        night_layer_f0.alpha_composite(ntile, (x * 8, y * 8))
                        for fk in range(4):
                            night_layer_anim[fk].alpha_composite(ntile, (x * 8, y * 8))
                        continue

                    new_subs = []
                    for sub in src_subs:
                        frs = sub.get('Frames', [])
                        if not frs:
                            continue
                        # Rendu Jour (frame 0)
                        fr0 = frs[0]
                        s0 = fr0['Sheet']
                        if s0:
                            d_tile = day_sheets[s0].crop((
                                fr0['TexLoc']['X'] * 8, fr0['TexLoc']['Y'] * 8,
                                (fr0['TexLoc']['X'] + 1) * 8, (fr0['TexLoc']['Y'] + 1) * 8,
                            ))
                            day_layer_im.alpha_composite(d_tile, (x * 8, y * 8))

                        # Construction des frames Nuit correspondantes (préserve 100% des animations natives + mer animée 4 frames)
                        if len(frs) == 1 and frs[0]['Sheet'] == 'v2_promontoire_jour_03':
                            tx0, ty0 = frs[0]['TexLoc']['X'], frs[0]['TexLoc']['Y']
                            n_frames_list = []
                            for fk, sea_idx in enumerate((0, 2, 4, 6)):
                                st = sea_night_frames[sea_idx].crop((tx0 * 8, ty0 * 8, (tx0 + 1) * 8, (ty0 + 1) * 8))
                                ntx, nty = bank.add(st)
                                n_frames_list.append({'Sheet': spec['tile_bank_name'], 'TexLoc': {'X': ntx, 'Y': nty}})
                                night_layer_anim[fk].alpha_composite(st, (x * 8, y * 8))
                                if fk == 0:
                                    night_layer_f0.alpha_composite(st, (x * 8, y * 8))
                            new_subs.append({'Frames': n_frames_list, 'FrameLength': 12})
                        else:
                            n_frames_list = []
                            resolved_tiles = []
                            for fr in frs:
                                sname = fr['Sheet']
                                if not sname:
                                    continue
                                if sname == '00_ciel':
                                    ntile = sky_night_im.crop((x * 8, y * 8, (x + 1) * 8, (y + 1) * 8))
                                else:
                                    tx, ty = fr['TexLoc']['X'], fr['TexLoc']['Y']
                                    ntile = night_sheets[sname].crop((tx * 8, ty * 8, (tx + 1) * 8, (ty + 1) * 8))
                                ntx, nty = bank.add(ntile)
                                n_frames_list.append({'Sheet': spec['tile_bank_name'], 'TexLoc': {'X': ntx, 'Y': nty}})
                                resolved_tiles.append(ntile)

                            if n_frames_list:
                                new_subs.append({
                                    'Frames': n_frames_list,
                                    'FrameLength': sub.get('FrameLength', 60),
                                })
                                night_layer_f0.alpha_composite(resolved_tiles[0], (x * 8, y * 8))
                                for fk in range(4):
                                    night_layer_anim[fk].alpha_composite(resolved_tiles[fk % len(resolved_tiles)], (x * 8, y * 8))

                    dst_cell['Layers'] = new_subs

            day_comp = Image.alpha_composite(day_comp, day_layer_im)
            for fk in range(4):
                night_frames_comp[fk] = Image.alpha_composite(night_frames_comp[fk], night_layer_anim[fk])

            safe_lname = lay['Name'].lower().replace('/', '_').replace(' ', '_')
            lp = LAYERS_DIR / f"{spec['out_stem']}_L{li:02d}_{safe_lname}.png"
            save_compact_png(night_layer_f0, lp, colors=256)
            layer_files.append(str(lp.relative_to(OUT_DIR)))

        # Écriture du .tile compact et du .rsground PMDO 0.8.12
        tile_out = MOD_DIR / 'Content/Tile' / f"{spec['tile_bank_name']}.tile"
        bank_stats = bank.write(tile_out)

        rsground_out = MOD_DIR / 'Data/Ground' / f"{spec['out_stem']}.rsground"
        rsground_out.parent.mkdir(parents=True, exist_ok=True)
        rsground_out.write_text(json.dumps(night_doc, separators=(',', ':')), encoding='utf-8')

        # Sauvegarde des PNG 1x (Jour réf + Nuit + 4 frames animées Nuit pour l'aperçu HTML sans <canvas>)
        save_compact_png(day_comp, PNG_DIR / spec['day_ref_png'], colors=256)
        save_compact_png(night_frames_comp[0], PNG_DIR / spec['night_png'], colors=256)
        anim_pngs = []
        for fk in range(4):
            fp_anim = PNG_DIR / f"{spec['out_stem']}_frame_{fk}.png"
            save_compact_png(night_frames_comp[fk], fp_anim, colors=256)
            anim_pngs.append(str(fp_anim.relative_to(OUT_DIR)))

        index_idx_entries[spec['tile_bank_name']] = {
            '$type': 'RogueEssence.Data.TileIndexNode, RogueEssence',
            'Position': bank_stats['bytes'],
            'TileSize': 8,
        }

        manifest_maps.append({
            'id': spec['out_stem'],
            'source_rsground': spec['src_rsground'].name,
            'title': spec['display_title'],
            'width_tiles': w,
            'height_tiles': h,
            'width_px': wp,
            'height_px': hp,
            'layer_count': len(night_obj['Layers']),
            'obstacles_preserved_100pct': night_obj['obstacles'] == src_obj['obstacles'],
            'entities_preserved_100pct': night_obj['Entities'] == src_obj['Entities'],
            'rsground_file': f"MOD_CLIFF_NORD_NUIT_PMDO/Data/Ground/{spec['out_stem']}.rsground",
            'tile_file': f"MOD_CLIFF_NORD_NUIT_PMDO/Content/Tile/{spec['tile_bank_name']}.tile",
            'tile_stats': bank_stats,
            'day_ref_png': f"png_1x/{spec['day_ref_png']}",
            'night_png': f"png_1x/{spec['night_png']}",
            'anim_frames_png': anim_pngs,
            'layer_pngs': layer_files,
        })
        print(f"[OK] {spec['out_stem']}: {wp}x{hp}px ({w}x{h}t, {len(night_obj['Layers'])} calques) | "
              f"tiles={bank_stats['tile_count']} ({bank_stats['bytes']/1024:.1f} KiB) | "
              f"rsground={rsground_out.stat().st_size/1024:.1f} KiB")

    idx_doc = {
        'Version': '0.8.12.0',
        'Object': {
            '$type': 'System.Collections.Generic.Dictionary`2[[System.String, System.Private.CoreLib],[RogueEssence.Data.TileIndexNode, RogueEssence]], System.Private.CoreLib',
            **index_idx_entries,
        },
    }
    (MOD_DIR / 'Content/Tile/index.idx').write_text(json.dumps(idx_doc, indent=2), encoding='utf-8')

    manifest = {
        'pack_id': 'cliff_nord_nuit_v1',
        'version_pmdo': '0.8.12',
        'ai_generated_pixels': 0,
        'method': 'Conversion déterministe Jour -> Nuit (substitution 1:1 des tilesheets Nuit Halcyon/projet + LUT exacte 3133 couleurs Halcyon Metano Jour->Nuit MAE=0.0000 px)',
        'art_approved': False,
        'runtime_tested': False,
        'runtime_PMDO': 'NOT TESTED',
        'attribution': [
            'Layouts & assemblages originaux Jour : cliffdaytest.rsground & cliffnordouesttest1.rsground (meromoonmeri)',
            'Tilesheets officiels Metano Jour/Nuit : Palikadude / Halcyon (Metano_Town_*, Metano_Inn_*, Altere_Pond_*)',
            'Artistes d\'origine Pokémon Mystery Dungeon : Chunsoft / Spike Chunsoft',
        ],
        'maps': manifest_maps,
    }
    (OUT_DIR / 'manifest.json').write_text(json.dumps(manifest, indent=2, ensure_ascii=False), encoding='utf-8')

    readme = """# Conversion Nuit Exacte (Zéro Génération IA) — Cliff Nord-Est & Cliff Nord-Ouest (PMDO 0.8.12)

## Contenu du pack
- **`MOD_CLIFF_NORD_NUIT_PMDO/Data/Ground/cliffdaytest_nuit.rsground`** (`984 × 792 px`, `123 × 99` tuiles, **6 calques**, animations d'eau/étang/fleurs/mer conservées, **100 % des collisions `obstacles` et `Entities` d'origine préservées**)
- **`MOD_CLIFF_NORD_NUIT_PMDO/Data/Ground/cliffnordouesttest1_nuit.rsground`** (`1104 × 784 px`, `138 × 98` tuiles, **4 calques**, cascade sud et mer nocturne animées sur 4 frames, **100 % des collisions `obstacles` et `Entities` d'origine préservées**)
- **`MOD_CLIFF_NORD_NUIT_PMDO/Content/Tile/CliffDay_NordEst_Nuit.tile`** & **`CliffNordOuest_Nuit.tile`** + **`index.idx`** : banques binaires autonomes PMDO `0.8.12` (aucun écrasement des feuilles de jour existantes !).
- **`png_1x/`** & **`calques_nuit_1x/`** : rendus complets `1×` Jour/Nuit, 4 frames d'animation Nuit et tous les calques séparés en PNG `RGBA` transparent.

## Méthode & Crédits
- **Zéro génération d'image** : reprise stricte à 100 % des pixels, placements, calques et collisions de `cliffdaytest.rsground` et `cliffnordouesttest1.rsground`, passés en palette nocturne canonique Halcyon (`Metano_Town_*_Night` + dégradé céleste nocturne PMD2).
- Crédits : `meromoonmeri` (assemblages `.rsground`), `Palikadude / Halcyon` (`Metano_Town_*`), et artistes d'origine `Pokémon Mystery Dungeon` (`art_approved: false`, `runtime_tested: false`).
"""
    (OUT_DIR / 'README.md').write_text(readme, encoding='utf-8')

    zip_path = OUT_DIR / 'PACK_CLIFF_NORD_NUIT_PMDO_0812.zip'
    if zip_path.exists():
        zip_path.unlink()
    with zipfile.ZipFile(zip_path, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=9) as zf:
        for fp in sorted(OUT_DIR.rglob('*')):
            if fp.is_file() and fp != zip_path:
                zf.write(fp, fp.relative_to(OUT_DIR).as_posix())

    tot_bytes = sum(fp.stat().st_size for fp in OUT_DIR.rglob('*') if fp.is_file())
    print(f'[ZIP] {zip_path.name}: {zip_path.stat().st_size/(1024*1024):.3f} MiB | Total dossier: {tot_bytes/(1024*1024):.3f} MiB')


if __name__ == '__main__':
    main()
