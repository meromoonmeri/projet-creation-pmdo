#!/usr/bin/env python3
# =============================================================================
# gen_tornadus_arene.py — arene du boss Tornadus (ch5), methode des relais
# transposee aux boss : patron eprouve + MATIERE OFFICIELLE, cablage intact.
#
#   v1 (ecartee) : composition algorithmique depuis mount_windswept_entrance
#                  -> resultat juge "horrible" (pavage patchwork).
#   v2 (active)  : plan officiel EoS mt_travail_peak porte sous RogueEssence
#                  par slothplaysnecro/PMDO-Explorers-Maps (meme voie que
#                  l'arene Regigigas, validee "magnifique"). La vue d'horizon
#                  degagee sert un boss VOLANT : Tornadus plane ciel derriere.
#
#   Patron structurel : crooked_den (salle a feuille dediee 8px, spawners
#                        TEAMMATE, Main_Entrance_Marker, une couche).
#   Cible ecrasee     : Data/Ground/mount_windswept_guardian.rsground
#   Feuille ecrasee   : Content/Tile/Mount_Windswept_Guardian_Base.tile
#                       (meme nom : l'entree index.idx est MISE A JOUR en
#                       place, les 541 autres entries byte-exactes)
#
# Invariants : AssetName, Name FR, Music Sky Tower.ogg, .rsmap de combat 19x19
# craggy_peak, zone, master_zone, scripts. La choregraphie ch_5.lua vit dans
# 432x432 px (x 168-264, y 24-392, cams (216,216)) -> arene 54x54 cellules 8px.
# Perchoir (216,24) tombe dans la bande CIEL : free d'obstacles, Tornadus y
# plane avec l'horizon derriere lui.
#
# Provenance source : https://github.com/slothplaysnecro/PMDO-Explorers-Maps
# (Data/Ground/mt_travail_peak.rsground, art Expeditions du Ciel / Explorers
# of Sky). Rendu vendored : tools/mapgen/data/mt_travail_peak_source.png
# (504x480 px) — le generateur est deterministe sans acces reseau.
#
#   python3 tools/mapgen/gen_tornadus_arene.py          # dry-run, previews
#   python3 tools/mapgen/gen_tornadus_arene.py --ecrire # materialise tout
# =============================================================================
import io
import json
import os
import struct
import sys
from collections import deque

import numpy as np
from PIL import Image, ImageDraw

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, '..', '..'))
TILEDIR = os.path.join(ROOT, 'Content', 'Tile')

PATRON = os.path.join(ROOT, 'Data', 'Ground', 'crooked_den.rsground')
CIBLE = os.path.join(ROOT, 'Data', 'Ground', 'mount_windswept_guardian.rsground')
SRC_PNG = os.path.join(HERE, 'data', 'mt_travail_peak_source.png')
FEUILLE = 'Mount_Windswept_Guardian_Base'

CELL = 8
ARENA_W = ARENA_H = 54          # cellules ; 54x8 = 432 px
CROP_X, CROP_Y = 36, 24         # fenetre dans la source 504x480 (centree)

# Positions durcies de mount_windswept_guardian_ch_5.lua (px) — libres.
LUA_POINTS = [
    (216, 376), (168, 376), (264, 376), (216, 392),
    (216, 360), (168, 360), (264, 360),
    (216, 380), (216, 340), (216, 320), (216, 220),
    (216, 24),                                        # perchoir (bande ciel)
]
SUD_ZONE = (21, 46, 32, 50)     # arrivee de l'equipe (cellules, inclus)
COULOIR = (20, 6, 33, 45)       # scene centrale deplacee : rien ne bloque
CIEL_YMAX = 104                 # px ; bande ciel/perchoir = toujours libre
                                # (hormis falaises sombres des flancs)


# ---------------------------------------------------------------------------
def mean_color(arr, cx, cy):
    return arr[cy * CELL:(cy + 1) * CELL,
               cx * CELL:(cx + 1) * CELL, :3].reshape(-1, 3).mean(axis=0)


def build_arena():
    """Recadre le plan officiel + obstacles generes par classification."""
    img = Image.open(SRC_PNG).convert('RGBA')
    W, H = img.size
    assert (W, H) == (504, 480), f'source inattendue {W}x{H}'
    full = np.asarray(img)
    arena = full[CROP_Y:CROP_Y + ARENA_H * CELL,
                 CROP_X:CROP_X + ARENA_W * CELL].copy()
    assert arena.shape == (ARENA_H * CELL, ARENA_W * CELL, 4)

    blocked = np.zeros((ARENA_W, ARENA_H), dtype=bool)
    for cx in range(ARENA_W):
        for cy in range(ARENA_H):
            zone = arena[cy * CELL:(cy + 1) * CELL,
                         cx * CELL:(cx + 1) * CELL, :3]
            px = zone.reshape(-1, 3)
            r, g, b = px.mean(axis=0)
            std = px.std(axis=0).mean()
            mean = (r + g + b) / 3.0
            ypx = cy * CELL + CELL // 2
            sky = (b > 150 and b > r + 20)
            tan = (r >= g >= b - 6 and r > 150 and r - b > 12 and b < 175)
            if ypx < CIEL_YMAX:
                # bande ciel/perchoir : libre, sauf rochers (falaise meme
                # claire = texture bruitée, std eleve) — on ne marche pas
                # sur les coiffes des falaises.
                blocked[cx, cy] = not (
                    (sky or tan or mean > 150) and std < 32)
            else:
                # platforme : seul le sol tan clair est practicable
                blocked[cx, cy] = not tan

    # zones sceniques forcees libres + garde-fou Lua (boite 3x3)
    for x0, y0, x1, y1 in (SUD_ZONE, COULOIR):
        blocked[x0:x1 + 1, y0:y1 + 1] = False
    for (px, py) in LUA_POINTS:
        cx, cy = px // CELL, py // CELL
        for dx in (-1, 0, 1):
            for dy in (-1, 0, 1):
                blocked[cx + dx, cy + dy] = False

    # connexite : BFS depuis l'entree sud (27,50), poches bouchees
    start = (ARENA_W // 2, ARENA_H - 4)
    seen = np.zeros_like(blocked)
    q = deque([start])
    seen[start] = True
    while q:
        cx, cy = q.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = cx + dx, cy + dy
            if 0 <= nx < ARENA_W and 0 <= ny < ARENA_H \
                    and not blocked[nx, ny] and not seen[nx, ny]:
                seen[nx, ny] = True
                q.append((nx, ny))
    pockets = (~blocked & ~seen)
    blocked |= pockets
    # le perchoir (ciel) est hors reseau par construction : on le degage
    for (px, py) in LUA_POINTS:
        blocked[px // CELL, py // CELL] = False
    # nettoyage des 1-cellules libres isolees dans les falaises (bruit)
    again = (~blocked & ~seen)
    for cx in range(ARENA_W):
        for cy in range(ARENA_H):
            ypx = cy * CELL + CELL // 2
            if again[cx, cy] and ypx >= CIEL_YMAX:
                # libre isole hors couloir/ciel -> mur
                if not (SUD_ZONE[0] <= cx <= SUD_ZONE[2]
                        or COULOIR[0] <= cx <= COULOIR[2]):
                    blocked[cx, cy] = True
    n_free = int((~blocked).sum())
    print(f'recadrage source : ({CROP_X},{CROP_Y}) -> '
          f'{ARENA_W * CELL}x{ARENA_H * CELL}px')
    print(f'marchable : {n_free}/{ARENA_W * ARENA_H} '
          f'({100 * n_free // (ARENA_W * ARENA_H)}%)')
    for (px, py) in LUA_POINTS:
        assert not blocked[px // CELL, py // CELL], \
            f'position Lua ({px},{py}) bloquee'
    print('positions Lua : toutes libres')
    return arena, blocked


# ---------------------------------------------------------------------------
def write_package(path, grid_cells):
    keys = sorted(grid_cells, key=lambda c: (c[1], c[0]))
    blobs, order, pngs = {}, [], {}
    for x, y, arr in keys:
        buf = io.BytesIO()
        Image.fromarray(arr, 'RGBA').save(buf, format='PNG')
        png = buf.getvalue()
        pngs[(x, y)] = png
        if png not in blobs:
            blobs[png] = None
            order.append(png)
    header = 8 + len(keys) * 16
    off = header
    for png in order:
        blobs[png] = off
        off += 8 + len(png)
    out = bytearray(struct.pack('<II', CELL, len(keys)))
    table = []
    for x, y, _a in keys:
        k = x | (y << 32)
        table.append((k, blobs[pngs[(x, y)]]))
        out += struct.pack('<QQ', k, blobs[pngs[(x, y)]])
    for png in order:
        out += struct.pack('<q', len(png)) + png
    with open(path, 'wb') as f:
        f.write(bytes(out))
    return table, len(out)


def index_upsert(nom, tile_size, table):
    """Met a jour (ou ajoute) l'entree `nom` dans Content/Tile/index.idx en
    preservant byte-exactement toutes les autres entrees, dans leur ordre."""
    idx_path = os.path.join(TILEDIR, 'index.idx')
    raw = open(idx_path, 'rb').read()
    n, = struct.unpack_from('<I', raw, 0)
    pos = 4
    spans = []                    # (name, ts, table, span_bytes)
    for _ in range(n):
        start = pos
        ln, = struct.unpack_from('<B', raw, pos)
        pos += 1
        name = raw[pos:pos + ln].decode('utf-8')
        pos += ln
        ts, cnt = struct.unpack_from('<II', raw, pos)
        pos += 8
        table0 = {}
        for i in range(cnt):
            k, o = struct.unpack_from('<QQ', raw, pos + i * 16)
            table0[k] = o
        pos += cnt * 16
        spans.append((name, ts, table0, start, pos))
    assert pos == len(raw), 'index.idx malforme'
    out = bytearray(struct.pack('<I', n))
    done = False
    for name, ts, table0, s, e in spans:
        if name == nom:
            nb = nom.encode('utf-8')
            out += struct.pack('<B', len(nb)) + nb
            out += struct.pack('<II', tile_size, len(table))
            for k, o in table:
                out += struct.pack('<QQ', k, o)
            done = True
        else:
            out += raw[s:e]       # bytes d'origine INTACTS
    if not done:
        out2 = bytearray(struct.pack('<I', n + 1))
        out2 += out[4:]
        nb = nom.encode('utf-8')
        out2 += struct.pack('<B', len(nb)) + nb
        out2 += struct.pack('<II', tile_size, len(table))
        for k, o in table:
            out2 += struct.pack('<QQ', k, o)
        out = out2
    open(idx_path, 'wb').write(bytes(out))
    print(f'index.idx : entree {nom} {"mise a jour" if done else "ajoutee"} '
          f'({len(table)} cles)')


def cell_identity(sheet, x, y):
    return {'AutoTileset': '', 'Associates': [],
            'Layers': [{'Frames': [{'Sheet': sheet,
                                    'TexLoc': {'X': x, 'Y': y}}],
                        'FrameLength': 60}],
            'NeighborCode': -1}


def write_ground(blocked):
    """Reecrit le ground depuis le patron crooked_den (idempotent)."""
    patron = json.load(open(PATRON, encoding='utf-8-sig'))
    ancien = json.load(open(CIBLE, encoding='utf-8-sig'))['Object']
    o = patron['Object']
    o['AssetName'] = 'mount_windswept_guardian'
    o['Name'] = ancien.get('Name', {'DefaultText': 'Windswept Summit',
                                    'LocalTexts': {'fr': 'Sommet Venteux'}})
    o['Music'] = ancien.get('Music', 'Sky Tower.ogg')
    o['Comment'] = (
        'gen_tornadus_arene v2 (2026-08-05) : salle 54x54 (432x432 px) au '
        'patron crooked_den, plan officiel EoS mt_travail_peak porte par '
        'slothplaysnecro/PMDO-Explorers-Maps (recadre 36,24), obstacles '
        'regeneres par classification + gardes sceniques ; perchoir Tornadus '
        '(216,24) en bande ciel libre. Remplace l ancienne feuille 24px sur '
        'grille 8px (rendu casse) et la composition algorithmique v1.').strip()
    o['obstacles'] = [
        [{'Bounds': {'X': x * CELL, 'Y': y * CELL,
                     'Width': CELL, 'Height': CELL},
          'Tags': 1 if blocked[x, y] else 0}
         for y in range(ARENA_H)] for x in range(ARENA_W)]
    o['Layers'] = [{'Name': 'Base', 'Layer': 0, 'Visible': True,
                    'Tiles': [[cell_identity(FEUILLE, x, y)
                               for y in range(ARENA_H)]
                              for x in range(ARENA_W)]}]
    spots = {'Teammate1': (168, 376), 'Teammate2': (264, 376),
             'Teammate3': (216, 392)}
    for sp in o['Entities'][0]['Spawners']:
        nm = sp.get('NPCName')
        if nm in spots:
            x, y = spots[nm]
            sp['Collider'] = {'X': x, 'Y': y, 'Width': 16, 'Height': 16}
    ent = o['Entities'][0]
    seen_main = False
    for mk in ent.get('Markers', []):
        if mk.get('EntName') == 'Main_Entrance_Marker':
            mk['Collider'] = {'X': 216, 'Y': 408, 'Width': 16, 'Height': 16}
            seen_main = True
    assert seen_main, 'Main_Entrance_Marker absent du patron'
    for mk in (ancien['Entities'][0].get('Markers') or []):
        if mk.get('EntName') == 'entrance':
            mk = dict(mk)
            mk['Collider'] = {'X': 216, 'Y': 408, 'Width': 16, 'Height': 16}
            ent.setdefault('Markers', []).append(mk)
    text = json.dumps(patron, ensure_ascii=False, indent=0)
    open(CIBLE, 'w', encoding='utf-8-sig').write(text)
    print(f'{os.path.relpath(CIBLE, ROOT)} : 54x54 -> {FEUILLE}')


# ---------------------------------------------------------------------------
def preview(arena, blocked, out):
    img = Image.fromarray(arena).resize((ARENA_W * CELL * 2,
                                         ARENA_H * CELL * 2), Image.NEAREST)
    d = ImageDraw.Draw(img)
    for (px, py) in LUA_POINTS:
        d.ellipse([px * 2 - 5, py * 2 - 5, px * 2 + 5, py * 2 + 5],
                  outline=(255, 60, 60, 255), width=2)
    d.rectangle([24 * 16, 51 * 16, 30 * 16 - 1, 54 * 16 - 1],
                outline=(60, 255, 60, 255), width=2)
    img.save(out)
    print('preview ->', out)


def preview_mask(blocked, out):
    m = np.zeros((ARENA_H * CELL, ARENA_W * CELL, 3), dtype=np.uint8)
    for cx in range(ARENA_W):
        for cy in range(ARENA_H):
            if blocked[cx, cy]:
                m[cy * CELL:(cy + 1) * CELL, cx * CELL:(cx + 1) * CELL] = \
                    (90, 20, 120)
            else:
                m[cy * CELL:(cy + 1) * CELL, cx * CELL:(cx + 1) * CELL] = \
                    (20, 120, 60)
    Image.fromarray(m).resize((ARENA_W * 16, ARENA_H * 16),
                              Image.NEAREST).save(out)
    print('masque ->', out)


def main():
    ecrire = '--ecrire' in sys.argv
    arena, blocked = build_arena()
    os.makedirs(os.path.join(ROOT, 'docs', 'renders'), exist_ok=True)
    preview(arena, blocked, os.path.join(
        ROOT, 'docs', 'renders', 'mount_windswept_guardian_nouveau.png'))
    preview_mask(blocked, os.path.join(
        ROOT, 'docs', 'renders', 'mount_windswept_guardian_masque.png'))
    if not ecrire:
        print('(--ecrire pour materialiser feuille + index + ground)')
        return 0
    cells = [(x, y, arena[y * CELL:(y + 1) * CELL,
                          x * CELL:(x + 1) * CELL])
             for x in range(ARENA_W) for y in range(ARENA_H)]
    path = os.path.join(TILEDIR, FEUILLE + '.tile')
    table, sz = write_package(path, cells)
    print(f'{FEUILLE}.tile : {len(table)} cellules, {sz} octets')
    index_upsert(FEUILLE, CELL, table)
    write_ground(blocked)
    print('OK. Verifications suivantes :')
    print('  python3 tools/verify_tile_index.py --quiet')
    print('  python3 tools/render_ground.py mount_windswept_guardian')
    print('  python3 tools/validate_all.py')
    return 0


if __name__ == '__main__':
    sys.exit(main())
