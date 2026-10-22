#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
convert_red_all.py — Les 262 dépendances Ground du ROM européen PMD Red,
avec TOUTES leurs animations.

Source canonique : extraction normalisée du ROM européen produite par
``audit_pmdred_eu_rom.py`` + ``docs/pmdred_eu/ground_manifest.json``. pret/pmd-red
reste une référence de format uniquement ; ses ressources US ne sont jamais
utilisées par défaut.

Animations natives PMD Red (ground_bg.c) :
  1. BPA  : tuiles animées (eau, lave, cascades…). Plusieurs slots possibles,
            CHAQUE slot a son propre compteur (numFrames, durationPerFrame).
  2. BPL  : animation de PALETTE (scintillement d'eau, braises, aurores…).
            Chaque palette i animée a (durationPerFrame, numFrames) et une
            table de numFrames×15 couleurs.
  3. BMA  : plusieurs couches (nL) possibles, composées dans l'ordre inverse
            (couche nL-1 = fond, couche 0 = dessus).

Rendu EXACT : par cellule, on rend sa propre période (lcm des périodes des
palettes utilisées + slots BPA utilisés), on compresse les ticks consécutifs
identiques en frames avec FrameLength = longueur de la série ; si les séries
sont inégales, repli EXACT par pas de g = pgcd des runs (1 image par pas de
g ticks, FL = g).

Sortie : RESERVE/red_grounds/<id>.rsground + RESERVE/red_tiles/<id>_Base.tile
+ RESERVE/red_manifest.json.

Usage : python3 tools/convert_red_all.py --source-dir /tmp/pmdred_eu_ground
        [--ids a01p01,b01p00a] [--apply] [--serial] [--resume]
"""
import argparse
import glob
import hashlib
import io
import json
import math
import os
import struct
import sys
import time

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, 'tools'))
import audit_pmdred_eu_rom as eu_audit  # noqa: F401 - compatibility authority API
from pmdred_dungeon_ground import decode_bma_auxiliary_layers

DEFAULT_RED = os.environ.get('PMDRED_EU_GROUND', '/tmp/pmdred-eu-ground')
DEFAULT_MANIFEST = os.path.join(ROOT, 'docs', 'pmdred_eu', 'ground_manifest.json')
RED = DEFAULT_RED
OUT_G = os.path.join(ROOT, 'RESERVE', 'red_grounds')
OUT_T = os.path.join(ROOT, 'RESERVE', 'red_tiles')
APPLY = False
CONVERTER_VERSION = '2.0.1-eu'

XSTRIDE = 128


def lcm(a, b):
    return a * b // math.gcd(a, b) if a and b else (a or b)


def parse_bpl(p):
    """(palettes, specs, anim_pals) — specs seulement si hasPalAnimations."""
    with open(p, 'rb') as stream:
        d = stream.read()
    npal = struct.unpack_from('<h', d, 0)[0]
    has = struct.unpack_from('<h', d, 2)[0]
    palettes = []
    off = 4
    for _ in range(npal):
        cols = [(0, 0, 0, 0)]
        for c in range(15):
            cols.append((d[off], d[off + 1], d[off + 2], 255))
            off += 4
        palettes.append(cols)
    specs = [(0, 0)] * npal
    anim_pals = {}
    if has:
        try:
            for i in range(npal):
                dur, nf = struct.unpack_from('<hh', d, off)
                off += 4
                specs[i] = (dur, nf)
            for i, (dur, nf) in enumerate(specs):
                if nf > 0:
                    frs = []
                    for f in range(nf):
                        cols = [(0, 0, 0, 0)]
                        for c in range(15):
                            cols.append((d[off], d[off + 1], d[off + 2], 255))
                            off += 4
                        frs.append(cols)
                    anim_pals[i] = frs
        except struct.error:
            anim_pals = {}
    return palettes, specs, anim_pals


def parse_bpc(p):
    with open(p, 'rb') as stream:
        d = stream.read()
    cw, chh, nt = struct.unpack_from('<HHH', d, 0)
    nc, = struct.unpack_from('<H', d, 14)
    tiles = [bytes(32)] + [d[16 + i * 32:16 + (i + 1) * 32] for i in range(nt - 1)]
    off = 16 + (nt - 1) * 32
    n = cw * chh
    chunks = [[0] * n]
    for i in range(nc - 1):
        chunks.append(list(struct.unpack_from('<%dH' % n, d, off)))
        off += n * 2
    return cw, chh, tiles, chunks


def decode_bma(p):
    with open(p, 'rb') as stream:
        d = stream.read()
    Wt, Ht, tw, th, Wc, Hc = d[:6]
    nL, hD, hC = struct.unpack_from('<HhH', d, 6)
    src = 12
    STRIDE = 64
    layers = []
    for li in range(nL):
        dst = []
        for j in range(Hc):
            row = []
            prev = dst[(j - 1) * STRIDE:j * STRIDE] if j > 0 else [0] * STRIDE
            k = 0
            while k < Wc:
                cmd = d[src]
                src += 1
                if cmd >= 0xC0:
                    for l in range(cmd - 0xC0 + 1):
                        v = d[src] | (d[src + 1] << 8) | (d[src + 2] << 16)
                        src += 3
                        a, b = v & 0xFFF, (v >> 12) & 0xFFF
                        if j > 0 and len(row) < STRIDE:
                            a ^= prev[len(row)]
                            b ^= prev[len(row) + 1]
                        row += [a, b]
                    k += (cmd - 0xBF) * 2
                elif cmd >= 0x80:
                    v = d[src] | (d[src + 1] << 8) | (d[src + 2] << 16)
                    src += 3
                    for l in range(cmd - 0x80 + 1):
                        a, b = v & 0xFFF, (v >> 12) & 0xFFF
                        if j > 0 and len(row) < STRIDE:
                            a ^= prev[len(row)]
                            b ^= prev[len(row) + 1]
                        row += [a, b]
                    k += (cmd - 0x7F) * 2
                else:
                    for l in range(cmd + 1):
                        if j > 0 and len(row) < STRIDE:
                            row += [prev[len(row)], prev[len(row) + 1]]
                        else:
                            row += [0, 0]
                    k += (cmd + 1) * 2
            row = row[:STRIDE] + [0] * (STRIDE - len(row))
            dst += row
        layers.append(dst)
    return Wt, Ht, Wc, Hc, nL, layers


def decode_bma_auxiliary(path):
    """Decode canonical BMA data plus all collision layers without guessing.

    The unknown/data block is kept separate: it appears related to interaction
    or counter behavior and must never be reinterpreted as PMDO collision.
    """
    with open(path, 'rb') as stream:
        data = stream.read()
    return decode_bma_auxiliary_layers(data, os.path.basename(path))


def decode_bma_collision(path):
    """Compatibility adapter returning every canonical collision layer."""
    decoded = decode_bma_auxiliary(path)
    collisions = [[bool(value) for value in layer] for layer in decoded.collisions]
    return collisions, decoded.width, decoded.height


def parse_bpa(paths):
    """Tuiles BPA par fichier (ordre des slots VRAM). Chaque slot a SON
    compteur (ground_bg.c sub3E0Ptr) : nf, dur, frames."""
    slots = []
    for slot_index, p in enumerate(paths):
        if p is None:
            slots.append(None)
            continue
        with open(p, 'rb') as stream:
            d = stream.read()
        nt = d[0]
        nf = struct.unpack_from('<h', d, 2)[0]
        durs = list(struct.unpack_from('<%di' % nf, d, 4))
        if any(duration < 0 for duration in durs):
            raise ValueError('durée BPA négative dans ' + p)
        off = 4 + nf * 4
        frs = []
        for f in range(nf):
            frs.append([d[off + (f * nt + k) * 32: off + (f * nt + k + 1) * 32]
                        for k in range(nt)])
        # GroundBg's BPA timer uses ``timer-- <= 0`` (unlike the BPL
        # pre-decrement), so a source duration N remains visible for N+1
        # updates.  Zero-duration frames therefore still last one tick.
        effective_durations = [duration + 1 for duration in durs]
        slots.append({'nt': nt, 'nf': nf, 'source_durations': durs,
                      'durations': effective_durations,
                      'cycle': sum(effective_durations), 'frames': frs})
    return slots


def tile_image(td, pal, hf, vf):
    im = Image.new('RGBA', (8, 8), (0, 0, 0, 0))
    px = im.load()
    for y in range(8):
        for x in range(4):
            b = td[y * 4 + x]
            for k2, ci in enumerate((b & 0xF, b >> 4)):
                if ci == 0:
                    continue
                xx = x * 2 + k2
                yy = y
                if hf:
                    xx = 7 - xx
                if vf:
                    yy = 7 - yy
                px[xx, yy] = pal[ci]
    return im


class Renderer:
    def __init__(self, bpc_tiles, bpa_slots, palettes, anim_pals, specs, chunks):
        self.bpc_tiles = bpc_tiles
        self.bpa_slots = bpa_slots
        self.bpa_offsets = []
        off = len(bpc_tiles)
        for slot in bpa_slots:
            self.bpa_offsets.append(off)
            if slot is not None:
                off += slot['nt']
        self.palettes = palettes
        self.anim_pals = anim_pals
        self.specs = specs
        self.chunks = chunks
        self.cache = {}

    def pal_at(self, pi, tick):
        if pi in self.anim_pals and self.specs[pi][0] > 0:
            dur, nf = self.specs[pi]
            return self.anim_pals[pi][(tick // dur) % nf]
        return self.palettes[pi % len(self.palettes)]

    def bpa_frame_at(self, slot_idx, tick):
        slot = self.bpa_slots[slot_idx]
        if slot is None:
            raise ValueError('cannot render an empty BPA dependency slot')
        if slot['nf'] <= 1 or slot['cycle'] <= 0:
            return 0
        position = tick % slot['cycle']
        elapsed = 0
        for frame, duration in enumerate(slot['durations']):
            elapsed += duration
            if position < elapsed:
                return frame
        return slot['nf'] - 1

    def bpa_location(self, tile_index):
        for slot_idx, offset in enumerate(self.bpa_offsets):
            slot = self.bpa_slots[slot_idx]
            if slot is not None and offset <= tile_index < offset + slot['nt']:
                return slot_idx, tile_index - offset
        return None

    def tile(self, ti, pi, tick):
        location = self.bpa_location(ti) if ti >= len(self.bpc_tiles) else None
        bf = self.bpa_frame_at(location[0], tick) if location is not None else 0
        key = (ti, pi, self.pal_frame_key(pi, tick), bf)
        im = self.cache.get(key)
        if im is not None:
            return im
        if ti < len(self.bpc_tiles):
            td = self.bpc_tiles[ti]
        elif location is not None:
            slot_idx, tile_in_slot = location
            td = self.bpa_slots[slot_idx]['frames'][bf][tile_in_slot]
        else:
            # Canonical maps can reference patterned blank VRAM sentinels that
            # sit outside the declared BPC/BPA tile ranges.
            td = bytes(32)
        pal = self.pal_at(pi, tick)
        im = tile_image(td, pal, False, False)
        if len(self.cache) < 400000:
            self.cache[key] = im
        return im

    def pal_frame_key(self, pi, tick):
        if pi in self.anim_pals and self.specs[pi][0] > 0:
            dur, nf = self.specs[pi]
            return (tick // dur) % nf
        return -1

    def chunk_cell(self, cids, tick, cw, chh):
        """Compose une cellule depuis TOUTES les couches BMA (cids par couche).
        Ordre : couche nL-1 d'abord (fond), couche 0 en dernier (dessus)."""
        cell = Image.new('RGBA', (cw * 8, chh * 8), (0, 0, 0, 0))
        for cid in reversed(cids):
            if not (0 < cid < len(self.chunks)):
                continue
            for i, ent in enumerate(self.chunks[cid]):
                ti = ent & 0x3FF
                hf = (ent >> 10) & 1
                vf = (ent >> 11) & 1
                pi = (ent >> 12) & 0xF
                if ti == 0:
                    continue
                tx, ty = (i % cw) * 8, (i // cw) * 8
                im = self.tile(ti, pi, tick)
                if hf or vf:
                    if hf:
                        im = im.transpose(Image.FLIP_LEFT_RIGHT)
                    if vf:
                        im = im.transpose(Image.FLIP_TOP_BOTTOM)
                cell.paste(im, (tx, ty), im)
        return cell


def minimal_period(seq, cap=512):
    """Return a true cyclic period, never a finite-prefix pseudo-period.

    A period of a closed animation cycle must divide its length.  Without the
    divisibility guard, equal beginning/end frames can make ``n-k`` look like a
    period over the first cycle even though PMDO drifts immediately after the
    wrap.  Exact-engine validation exposed that defect on h26p01 at tick 120.
    """
    n = len(seq)
    for p in range(1, min(n, cap + 1)):
        if n % p != 0:
            continue
        if all(seq[i] == seq[i % p] for i in range(n)):
            return p
    return n


def opaque(cell):
    """Compose sur fond noir opaque (patron du port officiel : bg noir
    255 + alpha_composite) — les pixels vides deviennent (0,0,0,255)."""
    bg = Image.new('RGBA', cell.size, (0, 0, 0, 255))
    bg.alpha_composite(cell)
    return bg


def png_bytes(im):
    buf = io.BytesIO()
    im.save(buf, 'PNG', optimize=True)
    return buf.getvalue()


def write_tile(path, entries):
    uniq, order = {}, []
    for key, png in entries:
        if png not in uniq:
            uniq[png] = None
            order.append(png)
    header = 8 + len(entries) * 16
    offsets, pos = {}, header
    for h in order:
        offsets[h] = pos
        pos += 8 + len(h)
    out = bytearray()
    out += struct.pack('<II', 8, len(entries))
    for key, png in entries:
        out += struct.pack('<QQ', key, offsets[png])
    for h in order:
        out += struct.pack('<Q', len(h)) + h
    with open(path, 'wb') as stream:
        stream.write(bytes(out))


def convert(asset_id, bpl, bpc, bma, bpa_list, apply=True, dep_key='', source_hashes=None):
    t0 = time.time()
    source_hashes = source_hashes or {}
    palettes, specs, anim_pals = parse_bpl(os.path.join(RED, bpl + '.bpl'))
    cw, chh, bpc_tiles, chunks = parse_bpc(os.path.join(RED, bpc + '.bpc'))
    Wt, Ht, Wc, Hc, nL, layers = decode_bma(os.path.join(RED, bma + '.bma'))
    # Keep all four dependency-table slots.  A gap has a zero tile count in
    # Red's corresponding BPC metadata; packing only populated names loses
    # canonical slot identity even when rendered VRAM offsets happen to match.
    bpa_slots = parse_bpa([
        os.path.join(RED, name + '.bpa') if name is not None else None
        for name in bpa_list
    ]) if bpa_list else []
    populated_bpa_slots = [(index, slot) for index, slot in enumerate(bpa_slots)
                           if slot is not None]

    L = 1
    anim_desc = []
    for i, (dur, nf) in enumerate(specs):
        if nf > 0:
            L = lcm(L, dur * nf)
            anim_desc.append('P%d:%dx%d' % (i, dur, nf))
    if populated_bpa_slots:
        for _, slot in populated_bpa_slots:
            if slot['nf'] > 1 and slot['cycle'] > 0:
                L = lcm(L, slot['cycle'])
        anim_desc.append(
            'BPA:%dt; %s' %
            (sum(slot['nt'] for _, slot in populated_bpa_slots),
             ','.join('S%d=%d' % (index, slot['cycle'])
                      for index, slot in populated_bpa_slots))
        )
    has_anim = L > 1 or bool(anim_desc)
    if not has_anim:
        L = 1

    renderer = Renderer(bpc_tiles, bpa_slots, palettes, anim_pals, specs, chunks)

    # --- cellules potentiellement animées (toutes couches) ---
    nt = len(bpc_tiles)
    anim_pal_set = set(anim_pals.keys())

    def cell_info(cids):
        per = 1
        used_bpa_slots = set()
        pals = set()
        for cid in cids:
            if not (0 < cid < len(chunks)):
                continue
            for ent in chunks[cid]:
                ti = ent & 0x3FF
                pi = (ent >> 12) & 0xF
                if ti >= nt:
                    location = renderer.bpa_location(ti)
                    if location is not None:
                        used_bpa_slots.add(location[0])
                if pi in anim_pal_set:
                    pals.add(pi)
        for slot_index in used_bpa_slots:
            slot = bpa_slots[slot_index]
            if slot['nf'] > 1 and slot['cycle'] > 0:
                per = lcm(per, slot['cycle'])
        for pi in pals:
            dur, nf = specs[pi]
            per = lcm(per, dur * nf)
        return bool(used_bpa_slots or pals), per

    n_cells = Wc * Hc
    cell_cids = [[layers[l][(ci // Wc) * 64 + ci % Wc] for l in range(nL)]
                 for ci in range(n_cells)]
    cell_infos = [cell_info(cids) for cids in cell_cids]

    # --- rendu PAR CELLULE à sa propre période, découpé en tuiles 8x8 ---
    # Chaque cellule (cw*8 x chh*8) est découpée en cw*chh tuiles 8x8, une
    # par position de GRILLE (tx,ty) — format exact du port officiel
    # (write_tile_file découpe l'image complète en tuiles 8x8, clés
    # (tx | ty<<32), chaque tuile de grille référence TexLoc (tx,ty)).
    entries = []       # (key, png) — PNG 8x8
    grid = [[None] * Ht for _ in range(Wt)]
    n_anim_cells = 0
    for y in range(Hc):
        for x in range(Wc):
            ci = y * Wc + x
            can_anim, per = cell_infos[ci]
            cids = cell_cids[ci]
            if not can_anim or per <= 1:
                cell_img = opaque(renderer.chunk_cell(cids, 0, cw, chh))
                for i in range(cw):
                    for j in range(chh):
                        tx, ty = x * cw + i, y * chh + j
                        if tx >= Wt or ty >= Ht:
                            continue
                        t8 = cell_img.crop((i * 8, j * 8, (i + 1) * 8, (j + 1) * 8))
                        png = png_bytes(t8)
                        entries.append((tx | (ty << 32), png))
                        grid[tx][ty] = {'AutoTileset': '', 'Associates': [],
                                        'NeighborCode': -1,
                                        'Layers': [{'Frames': [
                                            {'Sheet': asset_id + '_Base',
                                             'TexLoc': {'X': tx, 'Y': ty}}],
                                            'FrameLength': 60}]}
                continue
            n_anim_cells += 1
            seq = []
            imgs = []
            for t in range(per):
                img = opaque(renderer.chunk_cell(cids, t, cw, chh))
                imgs.append(img)
                seq.append(hashlib.md5(img.tobytes()).digest())
            p = minimal_period(seq)
            seq = seq[:p]
            imgs = imgs[:p]
            groups = []
            prev_h, cnt = seq[0], 1
            for t in range(1, p):
                if seq[t] == prev_h:
                    cnt += 1
                else:
                    groups.append((prev_h, cnt))
                    prev_h, cnt = seq[t], 1
            groups.append((prev_h, cnt))
            uniform = len({c for _, c in groups}) == 1
            if uniform:
                fl = groups[0][1]
                ticks = []
                tick = 0
                for v, (h, c) in enumerate(groups):
                    ticks.append(tick)
                    tick += c
            else:
                g = 0
                for _, c in groups:
                    g = math.gcd(g, c)
                if g <= 0:
                    g = 1
                fl = g
                ticks = [k * g for k in range(p // g)]
            for i in range(cw):
                for j in range(chh):
                    tx, ty = x * cw + i, y * chh + j
                    if tx >= Wt or ty >= Ht:
                        continue
                    frs = []
                    for v, t in enumerate(ticks):
                        t8 = imgs[t].crop((i * 8, j * 8, (i + 1) * 8, (j + 1) * 8))
                        png = png_bytes(t8)
                        entries.append(((tx + v * XSTRIDE) | (ty << 32), png))
                        frs.append({'Sheet': asset_id + '_Base',
                                    'TexLoc': {'X': tx + v * XSTRIDE, 'Y': ty}})
                    grid[tx][ty] = {'AutoTileset': '', 'Associates': [],
                                    'NeighborCode': -1,
                                    'Layers': [{'Frames': frs, 'FrameLength': fl}]}

    # Collision is decoded from the same EU BMA bytes.  Ground maps in this
    # archive use zero or one collision layer; fail rather than silently
    # inventing/substituting collision if that invariant changes.
    collision_layers, collision_width, collision_height = decode_bma_collision(
        os.path.join(RED, bma + '.bma')
    )
    if len(collision_layers) > 1:
        raise ValueError('%s has %d collision layers; PMDO mapping is undefined' %
                         (bma, len(collision_layers)))
    if (collision_width, collision_height) != (Wt, Ht):
        raise ValueError('%s collision dimensions do not match camera dimensions' % bma)
    coll = collision_layers[0] if collision_layers else None
    per_tile = coll is not None and len(coll) == Wt * Ht
    obstacles = []
    for x in range(Wt):
        col = []
        for y in range(Ht):
            blocked = False
            if coll is None:
                # No collision stream means no canonical solid cells.  Do not
                # invent a PMDO border and misrepresent source geometry.
                blocked = False
            elif per_tile:
                blocked = bool(coll[y * Wt + x])
            else:
                cx, cy = x // 3, y // 3
                if cx < Wc and cy < Hc:
                    blocked = bool(coll[cy * Wc + cx])
            col.append({'Bounds': {'X': x * 8, 'Y': y * 8, 'Width': 8, 'Height': 8},
                        'Tags': 1 if blocked else 0})
        obstacles.append(col)

    result = {'asset': asset_id, 'map_dependency': dep_key,
              'resources': {'bpl': bpl, 'bpc': bpc, 'bma': bma, 'bpa': bpa_list},
              'source_normalized_sha256': source_hashes,
              'anim': has_anim, 'desc': anim_desc,
              'L': L, 'cells_animees': n_anim_cells, 'dims': (Wt, Ht),
              'collision_layers': len(collision_layers),
              'solid_cells': sum(
                  obstacle['Tags'] != 0 for column in obstacles for obstacle in column
              ),
              'time': time.time() - t0}
    if not apply:
        return result

    os.makedirs(OUT_G, exist_ok=True)
    os.makedirs(OUT_T, exist_ok=True)
    write_tile(os.path.join(OUT_T, asset_id + '_Base.tile'), entries)

    bpa_provenance = ','.join(
        'S%d:%s' % (index, name if name is not None else 'empty')
        for index, name in enumerate(bpa_list)
    )
    doc = {
        'Version': '0.8.9.0',
        'Object': {
            '$type': 'RogueEssence.Ground.GroundMap, RogueEssence',
            'TexSize': 1,
            'Name': {'DefaultText': asset_id, 'LocalTexts': {}},
            'Released': True,
            'Comment': ('PMD Red EU ROM — %s; ressources %s/%s/%s%s. Rendu '
                        'graphique canonique par tick (%d ticks), BPA+palette '
                        'animées et collision BMA incluses, sans overlay. '
                        'Animations: %s' %
                        (dep_key, bpl, bpc, bma,
                         ('/' + bpa_provenance) if bpa_provenance else '', L,
                         '; '.join(anim_desc) if anim_desc else 'aucune')),
            'obstacles': obstacles,
            'rand': {'$type': 'RogueElements.ReRandom, RogueElements', 's': [0, 0, 0, 0]},
            'Status': {},
            'Background': {'$type': 'RogueEssence.Dungeon.MapBG, RogueEssence',
                           'MapLoc': {'X': 0, 'Y': 0},
                           'BGAnim': {'AnimIndex': '', 'FrameTime': 1, 'StartFrame': -1,
                                      'EndFrame': -1, 'AnimDir': -1, 'Alpha': 255,
                                      'AnimFlip': 0},
                           'BGMovement': {'X': 0, 'Y': 0}, 'Parallax': '0, 0',
                           'RepeatX': False, 'RepeatY': False},
            'BlankBG': {'AutoTileset': '', 'Associates': [], 'Layers': [], 'NeighborCode': -1},
            'Layers': [{'Name': 'Base', 'Layer': 0, 'Visible': True, 'Tiles': grid}],
            'AssetName': asset_id,
            'Music': '',
            'EdgeView': 0, 'NoSwitching': False,
            'ViewCenter': None, 'ViewOffset': {'X': 0, 'Y': 0},
            'ActiveChar': None,
            'Decorations': [{'Name': 'New Deco', 'Layer': 0, 'Visible': True, 'Anims': []}],
            # Entrances are event/script data, not BMA graphics.  Do not
            # fabricate a central walkable marker and call it canonical.
            'Entities': [{'Name': 'New EntLayer', 'Visible': True,
                          'MapChars': [], 'GroundObjects': [], 'Spawners': [],
                          'Markers': []}],
        },
    }
    ground_path = os.path.join(OUT_G, asset_id + '.rsground')
    tile_path = os.path.join(OUT_T, asset_id + '_Base.tile')
    with io.open(ground_path, 'w', encoding='utf-8-sig') as f:
        json.dump(doc, f, ensure_ascii=False, separators=(',', ':'))

    with open(ground_path, 'rb') as stream:
        ground_sha256 = hashlib.sha256(stream.read()).hexdigest()
    with open(tile_path, 'rb') as stream:
        tile_sha256 = hashlib.sha256(stream.read()).hexdigest()
    result['output_sha256'] = {
        'rsground': ground_sha256,
        'tile': tile_sha256,
    }
    result['time'] = time.time() - t0
    return result


def _worker(job):
    key, v = job
    try:
        r = convert(
            v['bpl'].lower(), v['bpl'], v['bpc'], v['bma'],
            v.get('bpa') or [], APPLY, key, v.get('source_hashes'),
        )
        return ('OK', r)
    except Exception as e:
        return ('ERR', (v['bpl'].lower(), str(e)[:240]))


def parse_args(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--source-dir', default=DEFAULT_RED,
                        help='normalized EU Ground extraction from audit_pmdred_eu_rom.py')
    parser.add_argument('--manifest', default=DEFAULT_MANIFEST,
                        help='authoritative EU Ground manifest')
    parser.add_argument('--ids', help='comma-separated lower-case BPL/map asset IDs')
    parser.add_argument(
        '--conversion-set', choices=('all', 'remaining', 'direct'), default='all',
        help=('canonical conversion-table subset: remaining excludes types 10/11; '
              'direct contains only types 10/11'),
    )
    parser.add_argument('--apply', action='store_true', help='write .tile/.rsground outputs')
    output = parser.add_mutually_exclusive_group()
    output.add_argument(
        '--output-root',
        help='non-destructive output root containing grounds/ and tiles/',
    )
    output.add_argument(
        '--promote-legacy-reserve', action='store_true',
        help=('explicitly overwrite RESERVE/red_grounds, RESERVE/red_tiles and '
              'RESERVE/red_manifest.json (never use for candidate validation)'),
    )
    parser.add_argument('--report', help='write deterministic conversion/validation JSON')
    parser.add_argument('--serial', action='store_true', help='disable multiprocessing')
    parser.add_argument('--resume', action='store_true',
                        help='skip outputs already present in the selected output root')
    args = parser.parse_args(argv)
    if args.apply and not (args.output_root or args.promote_legacy_reserve):
        parser.error(
            '--apply requires --output-root for non-destructive generation or the '
            'explicit --promote-legacy-reserve escape hatch'
        )
    if not args.apply and (args.output_root or args.promote_legacy_reserve):
        parser.error('--output-root/--promote-legacy-reserve require --apply')
    return args


def canonical_conversion_ids(manifest_path, conversion_set):
    with open(manifest_path, encoding='utf-8') as stream:
        manifest = json.load(stream)
    entries = manifest['ground_conversion_table']['entries']
    if conversion_set == 'direct':
        entries = [entry for entry in entries if entry['conversion_type'] in (10, 11)]
    elif conversion_set == 'remaining':
        entries = [entry for entry in entries if entry['conversion_type'] not in (10, 11)]
    return {entry['stable_ground_id'] for entry in entries}


def load_authoritative_jobs(manifest_path, source_dir):
    with open(manifest_path, encoding='utf-8') as stream:
        manifest = json.load(stream)
    expected_rom = '0f9d125d513d9cba628d97e2c345382eba9ba73b402b24a8fdd81f604c14cbcd'
    actual_rom = manifest.get('authority', {}).get('rom', {}).get('sha256')
    if actual_rom != expected_rom or manifest.get('validation', {}).get('status') != 'pass':
        raise ValueError('manifest is not a passing authoritative EU ROM audit')

    resources = {entry['name']: entry for entry in manifest['ground_archive']['resources']}
    extension = {'bpl': '.bpl', 'bpc': '.bpc', 'bma': '.bma', 'bpa': '.bpa'}
    dependencies = []
    needed = set()
    for entry in manifest['map_files_table']['entries']:
        bpas = [entry['bpa_%d' % slot] for slot in range(4)]
        populated_bpas = [name for name in bpas if name is not None]
        names = (entry['bpl'], entry['bpc'], entry['bma'], *populated_bpas)
        value = {
            'bpl': entry['bpl'], 'bpc': entry['bpc'], 'bma': entry['bma'],
            'bpa': bpas,
            'source_hashes': {name: resources[name]['normalized_sha256'] for name in names},
        }
        dependencies.append(('EU map_file_id=%d' % entry['map_file_id'], value))
        needed.update((entry['bpl'], entry['bpc'], entry['bma'], *populated_bpas))

    for name in sorted(needed):
        record = resources[name]
        path = os.path.join(source_dir, name + extension[record['type']])
        if not os.path.isfile(path):
            raise FileNotFoundError('missing canonical extraction resource: ' + path)
        with open(path, 'rb') as stream:
            digest = hashlib.sha256(stream.read()).hexdigest()
        if digest != record['normalized_sha256']:
            raise ValueError('%s hash %s does not match EU manifest %s' %
                             (path, digest, record['normalized_sha256']))
    return dependencies


def main(argv=None):
    global APPLY, RED, OUT_G, OUT_T
    args = parse_args(argv)
    APPLY = args.apply
    RED = os.path.abspath(args.source_dir)
    if args.output_root:
        output_root = os.path.abspath(args.output_root)
        OUT_G = os.path.join(output_root, 'grounds')
        OUT_T = os.path.join(output_root, 'tiles')
    else:
        OUT_G = os.path.join(ROOT, 'RESERVE', 'red_grounds')
        OUT_T = os.path.join(ROOT, 'RESERVE', 'red_tiles')
    only = set(args.ids.split(',')) if args.ids else None
    canonical_ids = canonical_conversion_ids(args.manifest, args.conversion_set)
    if only is not None:
        outside_set = sorted(only - canonical_ids)
        if outside_set:
            raise ValueError(
                'IDs outside --conversion-set %s: %s' %
                (args.conversion_set, ', '.join(outside_set))
            )
        canonical_ids &= only
    jobs = [
        job for job in load_authoritative_jobs(args.manifest, RED)
        if job[1]['bpl'].lower() in canonical_ids
    ]
    found = {job[1]['bpl'].lower() for job in jobs}
    missing = sorted(canonical_ids - found)
    if missing:
        raise ValueError('canonical conversion IDs lack map dependencies: ' + ', '.join(missing))
    if args.resume:
        done = set(os.path.basename(path)[:-9]
                   for path in glob.glob(os.path.join(OUT_G, '*.rsground')))
        jobs = [job for job in jobs if job[1]['bpl'].lower() not in done]
    print('%s: %d' % ('à écrire' if APPLY else 'à valider (sans écriture)', len(jobs)), flush=True)
    report = []
    ok = fail = 0
    if args.serial:
        results = [_worker(job) for job in jobs]
    else:
        import multiprocessing as mp
        with mp.Pool(max(1, min(8, os.cpu_count() or 4))) as pool:
            results = pool.map(_worker, jobs, chunksize=1)
    for status, result in results:
        if status == 'OK':
            report.append(result)
            ok += 1
            print('OK  %-28s %-34s L=%4d anim=%s' % (
                result['asset'], (result['desc'][0][:32] if result['desc'] else '—'),
                result['L'], result['anim']), flush=True)
        else:
            print('ERR %-28s %s' % (result[0], result[1]), flush=True)
            fail += 1
    print('TERMINÉ : %d OK, %d échecs' % (ok, fail))
    deterministic_results = [
        {key: value for key, value in result.items() if key != 'time'}
        for result in report
    ]
    if APPLY and args.promote_legacy_reserve:
        legacy_report_path = os.path.join(ROOT, 'RESERVE', 'red_manifest.json')
        with open(legacy_report_path, 'w', encoding='utf-8') as stream:
            json.dump(deterministic_results, stream, indent=1, ensure_ascii=False)
            stream.write('\n')
    if args.report:
        with open(args.manifest, 'rb') as stream:
            manifest_bytes = stream.read()
        with open(__file__, 'rb') as stream:
            converter_sha256 = hashlib.sha256(stream.read()).hexdigest()
        report_document = {
            'schema': 'new-era.pmdred-eu-ground-conversion.v1',
            'converter': {
                'name': 'convert_red_all.py',
                'version': CONVERTER_VERSION,
                'sha256': converter_sha256,
            },
            'source_manifest_sha256': hashlib.sha256(manifest_bytes).hexdigest(),
            'source_directory': 'external normalized EU extraction',
            'apply': APPLY,
            'requested_ids': sorted(only) if only else None,
            'result_count': len(deterministic_results),
            'failure_count': fail,
            'results': deterministic_results,
        }
        os.makedirs(os.path.dirname(os.path.abspath(args.report)), exist_ok=True)
        with open(args.report, 'w', encoding='utf-8', newline='\n') as stream:
            json.dump(report_document, stream, ensure_ascii=False, sort_keys=True, indent=2)
            stream.write('\n')
    return 1 if fail else 0


if __name__ == '__main__':
    raise SystemExit(main())
