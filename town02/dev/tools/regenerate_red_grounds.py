#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
regenerate_red_grounds.py — régénère les grounds PMD Red EN JEU (Data/Ground)
depuis l'extraction canonique du ROM européen, avec TOUTES les animations
natives (BPA + palette + couches multiples) et la collision BMA canonique, en
conservant les entités de scène, marqueurs et musiques du projet.

Usage : python3 tools/regenerate_red_grounds.py [--ids a,b] [--apply]
"""
import glob
import hashlib
import io
import json
import math
import os
import struct
import sys

from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
RED = os.environ.get('PMDRED_EU_GROUND', '/tmp/pmdred-eu-ground')
sys.path.insert(0, os.path.join(ROOT, 'tools'))
from convert_red_all import (DEFAULT_MANIFEST, Renderer, decode_bma,
                             decode_bma_collision, lcm, load_authoritative_jobs,
                             opaque, parse_bpa, parse_bpc, parse_bpl, png_bytes,
                             write_tile)

XSTRIDE = 128

# Live Ground -> canonical BPL/map identity clue.  BPC/BMA/all four BPA slots
# always come from the authoritative EU dependency table, never this map.
GROUNDS = {
    'a02p01': 'A02P01',
    'a02p02': 'A02P02',
    'a02p03': 'A02P03',
    'a02p04': 'A02P04',
    'a04p01': 'A04P01',
    'a05p03': 'A05P03',
    'arc_palier_celeste': 'D13P02',
    'arc_parvis_celeste': 'D13P01',
    'arc_tour_ciel_sommet': 'D13P03',
    'sinister_woods_clearing': 'D04P02',
    'gloomy_forest_entrance': 'D04P01',
    'd09p02': 'D09P02',
    'd09p03': 'D09P03',
    'd10p02': 'D10P02',
    'd10p03': 'D10P03',
    'd11p02': 'D11P02',
    'd11p03': 'D11P03',
    'foret_givree_oree': 'D10P01',
    'fosse_ardente': 'D12P04',
    'gorge_ardente_coeur': 'D12P02',
    'gorge_ardente_porte': 'D12P01',
    'grotte_lazuli_fond': 'D08P02',
    'grotte_lazuli_seuil': 'D08P01',
    'mont_cendre_pied': 'D09P01',
    'mont_gele_pied': 'D11P01',
    'mount_windswept_guardian': 'D18P01',
    'palier_celeste': 'D13P02',
    'parvis_celeste': 'D13P01',
    'pre_tonnerre': 'H17P01',
    'sanctuaire_voeu': 'D23P01',
    't01p01': 'T01P01',
    'tour_ciel_sommet': 'D13P03',
}

_CANONICAL_BY_BPL = None


def canonical_dependency(bpl_id):
    """Resolve a live-Ground clue through the hash-guarded EU dependency table."""
    global _CANONICAL_BY_BPL
    if _CANONICAL_BY_BPL is None:
        _CANONICAL_BY_BPL = {
            value['bpl']: (key, value)
            for key, value in load_authoritative_jobs(DEFAULT_MANIFEST, RED)
        }
    if bpl_id not in _CANONICAL_BY_BPL:
        raise ValueError('aucune dépendance EU canonique pour ' + bpl_id)
    return _CANONICAL_BY_BPL[bpl_id]


def minimal_period(seq, cap=512):
    n = len(seq)
    for p in range(1, min(n, cap + 1)):
        ok = all(seq[i] == seq[i % p] for i in range(n))
        if ok:
            return p
    return n


def regenerate(ground, apply=True):
    bpl_clue = GROUNDS[ground]
    dependency_key, dependency = canonical_dependency(bpl_clue)
    bpl_id = dependency['bpl']
    bpc_id = dependency['bpc']
    bma_id = dependency['bma']
    bpa_list = dependency['bpa']
    gpath = os.path.join(ROOT, 'Data', 'Ground', ground + '.rsground')
    with open(gpath, encoding='utf-8-sig') as stream:
        doc = json.load(stream)
    o = doc['Object']
    sheet = None
    for col in o['Layers'][0]['Tiles']:
        for t in col:
            for tl in t.get('Layers', []):
                for fr in tl.get('Frames', []):
                    if fr.get('Sheet'):
                        sheet = fr['Sheet']
                        break
                if sheet:
                    break
            if sheet:
                break
        if sheet:
            break
    if sheet is None:
        sheet = ground + '_Base'

    palettes, specs, anim_pals = parse_bpl(os.path.join(RED, bpl_id + '.bpl'))
    cw, chh, bpc_tiles, chunks = parse_bpc(os.path.join(RED, bpc_id + '.bpc'))
    Wt, Ht, Wc, Hc, nL, layers = decode_bma(os.path.join(RED, bma_id + '.bma'))
    old_grid = o['Layers'][0]['Tiles']
    old_width = len(old_grid)
    old_heights = {len(column) for column in old_grid}
    if len(old_heights) != 1:
        raise ValueError('%s a des colonnes live de hauteurs incohérentes' % ground)
    old_height = next(iter(old_heights))
    dimension_migration = 'exact'
    crop_x = crop_y = 0
    if (old_width, old_height) != (Wt, Ht):
        # Several old imports centered Red's camera image in a padded chunk
        # canvas.  Remove equal padding from both sides (the odd remainder is
        # on the right/bottom), and translate every preserved entity back into
        # canonical camera coordinates.
        if old_width < Wt or old_height < Ht:
            raise ValueError(
                '%s dimensions live %dx%d < EU %dx%d; translation spatiale requise' %
                (ground, old_width, old_height, Wt, Ht)
            )
        crop_x = ((old_width - Wt) // 2) * 8
        crop_y = ((old_height - Ht) // 2) * 8
        for entity_layer in o.get('Entities', []):
            for collection in ('MapChars', 'GroundObjects', 'Spawners', 'Markers'):
                for entity in entity_layer.get(collection, []):
                    bounds = entity.get('Collider')
                    if bounds is None:
                        continue
                    canonical_x = bounds['X'] - crop_x
                    canonical_y = bounds['Y'] - crop_y
                    if (canonical_x < 0 or canonical_y < 0 or
                            canonical_x + bounds['Width'] > Wt * 8 or
                            canonical_y + bounds['Height'] > Ht * 8):
                        raise ValueError(
                            '%s entité %s sort du cadre EU après recadrage; '
                            'translation dédiée requise' %
                            (ground, entity.get('EntName', '?'))
                        )
        dimension_migration = 'crop-centered-padding:%dx%d@%d,%d->%dx%d' % (
            old_width, old_height, crop_x // 8, crop_y // 8, Wt, Ht
        )
    bpa_slots = parse_bpa([
        os.path.join(RED, name + '.bpa') if name is not None else None
        for name in bpa_list
    ])
    populated_bpa_slots = [(index, slot) for index, slot in enumerate(bpa_slots)
                           if slot is not None]

    L = 1
    desc = []
    for i, (dur, nf) in enumerate(specs):
        if nf > 0:
            L = lcm(L, dur * nf)
            desc.append('P%d:%dx%d' % (i, dur, nf))
    if populated_bpa_slots:
        for _, slot in populated_bpa_slots:
            if slot['nf'] > 1 and slot['cycle'] > 0:
                L = lcm(L, slot['cycle'])
        desc.append('BPA:%s' % ','.join(
            'S%d=%d' % (index, slot['cycle'])
            for index, slot in populated_bpa_slots
        ))

    renderer = Renderer(bpc_tiles, bpa_slots, palettes, anim_pals, specs, chunks)

    nt = len(bpc_tiles)
    anim_pal_set = set(anim_pals.keys())

    def may_anim(cids):
        for cid in cids:
            if not (0 < cid < len(chunks)):
                continue
            if populated_bpa_slots and any((e & 0x3FF) >= nt for e in chunks[cid]):
                return True
            if anim_pal_set and any(((e >> 12) & 0xF) in anim_pal_set for e in chunks[cid]):
                return True
        return False

    n_cells = Wc * Hc
    cell_cids = [[layers[l][(ci // Wc) * 64 + ci % Wc] for l in range(nL)]
                 for ci in range(n_cells)]
    cell_anim = [may_anim(cids) for cids in cell_cids]

    # frames par tick (paresseux)
    cell_hashes = []
    static_imgs = {}
    for t in range(L):
        hs = []
        for ci in range(n_cells):
            if not cell_anim[ci]:
                if t == 0:
                    static_imgs[ci] = opaque(renderer.chunk_cell(cell_cids[ci], 0, cw, chh))
                hs.append(hashlib.md5(static_imgs[ci].tobytes()).digest())
            else:
                img = opaque(renderer.chunk_cell(cell_cids[ci], t, cw, chh))
                hs.append(hashlib.md5(img.tobytes()).digest())
        cell_hashes.append(hs)

    entries = []
    grid = [[None] * Ht for _ in range(Wt)]
    n_anim = 0
    for y in range(Hc):
        for x in range(Wc):
            ci = y * Wc + x
            seq = [cell_hashes[t][ci] for t in range(L)]
            if len(set(seq)) == 1:
                img = static_imgs.get(ci)
                if img is None:
                    img = opaque(renderer.chunk_cell(cell_cids[ci], 0, cw, chh))
                for i in range(cw):
                    for j in range(chh):
                        tx, ty = x * cw + i, y * chh + j
                        if tx >= Wt or ty >= Ht:
                            continue
                        t8 = img.crop((i * 8, j * 8, (i + 1) * 8, (j + 1) * 8))
                        png = png_bytes(t8)
                        entries.append((tx | (ty << 32), png))
                        grid[tx][ty] = {'AutoTileset': '', 'Associates': [],
                                        'NeighborCode': -1,
                                        'Layers': [{'Frames': [
                                            {'Sheet': sheet, 'TexLoc': {'X': tx, 'Y': ty}}],
                                            'FrameLength': 60}]}
            else:
                n_anim += 1
                p = minimal_period(seq)
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
                            img = opaque(renderer.chunk_cell(cell_cids[ci], t, cw, chh))
                            t8 = img.crop((i * 8, j * 8, (i + 1) * 8, (j + 1) * 8))
                            png = png_bytes(t8)
                            entries.append(((tx + v * XSTRIDE) | (ty << 32), png))
                            frs.append({'Sheet': sheet,
                                        'TexLoc': {'X': tx + v * XSTRIDE, 'Y': ty}})
                        grid[tx][ty] = {'AutoTileset': '', 'Associates': [],
                                        'NeighborCode': -1,
                                        'Layers': [{'Frames': frs, 'FrameLength': fl}]}

    collision_layers, collision_width, collision_height = decode_bma_collision(
        os.path.join(RED, bma_id + '.bma')
    )
    if len(collision_layers) > 1:
        raise ValueError('%s a %d couches collision; migration PMDO indéfinie' %
                         (bma_id, len(collision_layers)))
    if (collision_width, collision_height) != (Wt, Ht):
        raise ValueError('%s dimensions collision/caméra incompatibles' % bma_id)
    collision = collision_layers[0] if collision_layers else None
    obstacles = [[
        {'Bounds': {'X': x * 8, 'Y': y * 8, 'Width': 8, 'Height': 8},
         'Tags': 1 if collision is not None and collision[y * Wt + x] else 0}
        for y in range(Ht)
    ] for x in range(Wt)]
    result = {
        'ground': ground, 'dependency': dependency_key, 'L': L, 'desc': desc,
        'anim_cells': n_anim, 'dimension_migration': dimension_migration,
        'collision_layers': len(collision_layers),
        'solid_cells': sum(cell['Tags'] != 0 for column in obstacles for cell in column),
        'source_normalized_sha256': dependency['source_hashes'],
    }
    if not apply:
        return result

    if crop_x or crop_y:
        for entity_layer in o.get('Entities', []):
            for collection in ('MapChars', 'GroundObjects', 'Spawners', 'Markers'):
                for entity in entity_layer.get(collection, []):
                    bounds = entity.get('Collider')
                    if bounds is not None:
                        bounds['X'] -= crop_x
                        bounds['Y'] -= crop_y
        view_center = o.get('ViewCenter')
        if isinstance(view_center, dict):
            view_center['X'] -= crop_x
            view_center['Y'] -= crop_y

    write_tile(os.path.join(ROOT, 'Content', 'Tile', sheet + '.tile'), entries)
    o['Layers'] = [{'Name': 'Base', 'Layer': 0, 'Visible': True, 'Tiles': grid}]
    o['obstacles'] = obstacles
    o['Comment'] = (o.get('Comment', '').split(' | PMD Red EU ROM')[0] +
                    ' | PMD Red EU ROM %s; rendu graphique et collision BMA; '
                    '%d ticks : %s.' %
                    (dependency_key, L, '; '.join(desc) if desc else 'aucune'))
    with io.open(gpath, 'w', encoding='utf-8-sig') as f:
        json.dump(doc, f, ensure_ascii=False, separators=(',', ':'))
    result['sheet'] = sheet
    return result


def main():
    apply = '--apply' in sys.argv
    only = None
    if '--ids' in sys.argv:
        only = set(sys.argv[sys.argv.index('--ids') + 1].split(','))
    failures = 0
    for g in sorted(GROUNDS):
        if only and g not in only:
            continue
        try:
            r = regenerate(g, apply)
            print('%-26s L=%4d anim_cells=%-5d %-35s %s' % (
                g, r['L'], r['anim_cells'], r['dimension_migration'],
                '; '.join(r['desc']) if r['desc'] else '—'), flush=True)
        except Exception as e:
            import traceback
            failures += 1
            print('ERR %-26s %s' % (g, str(e)[:160]))
            traceback.print_exc()
    return 1 if failures else 0


if __name__ == '__main__':
    raise SystemExit(main())
