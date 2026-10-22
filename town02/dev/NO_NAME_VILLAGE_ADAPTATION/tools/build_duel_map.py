#!/usr/bin/env python3
"""Construit une .rsmap de duel qui EST le lieu du Ground, plein écran.

Principe (voir reports/fauna-ecology/DUEL_EMPRISE_ECRAN.md) :

  Le ViewRect du moteur est en PIXELS et identique en Ground et en donjon
  (BaseGroundScene.cs l.155 / BaseDungeonScene.cs l.167). Il suffit donc que la
  .rsmap couvre la surface visible + marge, remplie avec le décor EXACT du
  Ground à cet endroit. Couvrir les 4992x4992 px du Ground coûterait ~139 Mo
  par duel pour des pixels que le joueur ne peut pas voir.

Méthode :
  1. On découpe une fenêtre de WIN_W x WIN_H tuiles de 24 px dans le RENDU du
     Ground source, centrée sur le lieu du duel, clampée aux bords.
  2. Chaque tuile de 24x24 px est extraite telle quelle -- aucun
     rééchantillonnage, aucune interpolation : copie pixel à pixel.
  3. Les tuiles identiques sont dédupliquées et écrites dans une planche .tile,
     puis INJECTÉES dans Content/Tile/index.idx (sans ça : damier mauve/noir,
     cf. docs/DIAGNOSTIC_DAMIER_DUEL_METANO_2026-08-05.md).
  4. La collision de la .rsmap est reprise de la collision du Ground, agrégée
     de 8 px vers 24 px par règle MAJORITÉ (cohérent avec la normalisation).
  5. On re-rend la .rsmap et on la compare pixel à pixel à la fenêtre source.
     Attendu : identité stricte.

Sortie par défaut dans reports/fauna-ecology/duel-maps/ (rien n'est écrit dans
Data/ tant que --install n'est pas passé).
"""
from __future__ import annotations
import argparse, binascii, hashlib, json, os, struct, sys, zlib
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'
sys.path.insert(0, str(ROOT / '.runtime-cache/pyenv'))
from PIL import Image  # noqa: E402

TILE = 24          # px par tuile de donjon
WIN_W, WIN_H = 26, 14      # 624 x 336 px : > 1 écran de 480x270, marge de scroll
GROUND_PX = 4992
COLL_CELL = 8      # px par cellule de collision du Ground


def png_bytes(im: Image.Image) -> bytes:
    w, h = im.size
    raw = im.convert('RGBA').tobytes()
    rows = b''.join(b'\0' + raw[y * w * 4:(y + 1) * w * 4] for y in range(h))

    def chunk(tag, data):
        return (struct.pack('>I', len(data)) + tag + data
                + struct.pack('>I', binascii.crc32(tag + data) & 0xffffffff))
    return (b'\x89PNG\r\n\x1a\n'
            + chunk(b'IHDR', struct.pack('>IIBBBBB', w, h, 8, 6, 0, 0, 0))
            + chunk(b'IDAT', zlib.compress(rows, 9))
            + chunk(b'IEND', b''))


def write_tile_sheet(path: Path, tiles: dict, tile_size: int = TILE):
    """Écrit une planche .tile : header + table clé->offset + PNG concaténés.

    Format (cf. docs/DIAGNOSTIC_DAMIER_DUEL_METANO_2026-08-05.md) :
      uint32 tileSize, uint32 count,
      count * (uint64 key = x | (y<<32), uint64 offset_absolu),
      puis à chaque offset : int64 len + octets PNG.
    """
    keys = sorted(tiles)
    header = struct.pack('<II', tile_size, len(keys))
    table_size = len(keys) * 16
    body = b''
    offsets = {}
    base = len(header) + table_size
    for k in keys:
        data = png_bytes(tiles[k])
        offsets[k] = base + len(body)
        body += struct.pack('<q', len(data)) + data
    table = b''
    for (x, y) in keys:
        table += struct.pack('<QQ', (x & 0xffffffff) | ((y & 0xffffffff) << 32),
                             offsets[(x, y)])
    path.write_bytes(header + table + body)
    return {'count': len(keys), 'bytes': path.stat().st_size,
            'table': {f'{x},{y}': offsets[(x, y)] for (x, y) in keys}}


def load_index(path: Path):
    """Lit Content/Tile/index.idx -> liste de tilesets."""
    if not path.exists():
        return []
    d = path.read_bytes()
    off = 0
    n = struct.unpack_from('<I', d, off)[0]; off += 4
    out = []
    for _ in range(n):
        ln = d[off]; off += 1
        name = d[off:off + ln].decode('utf-8'); off += ln
        tsize, count = struct.unpack_from('<II', d, off); off += 8
        entries = []
        for _ in range(count):
            key, o = struct.unpack_from('<QQ', d, off); off += 16
            entries.append((key, o))
        out.append({'name': name, 'tile_size': tsize, 'entries': entries})
    return out


def save_index(path: Path, tilesets):
    buf = struct.pack('<I', len(tilesets))
    for ts in tilesets:
        nb = ts['name'].encode('utf-8')
        buf += bytes([len(nb)]) + nb
        buf += struct.pack('<II', ts['tile_size'], len(ts['entries']))
        for key, o in ts['entries']:
            buf += struct.pack('<QQ', key, o)
    path.write_bytes(buf)


def majority_collision(ground, x0_px, y0_px, w_t, h_t):
    """Collision Ground (8 px) -> tuiles 24 px, règle MAJORITÉ."""
    ob = ground['Object']['obstacles']
    W, H = len(ob), len(ob[0])
    per = TILE // COLL_CELL          # 3
    grid = []
    for tx in range(w_t):
        col = []
        for ty in range(h_t):
            cx0 = (x0_px + tx * TILE) // COLL_CELL
            cy0 = (y0_px + ty * TILE) // COLL_CELL
            blocked = 0
            total = 0
            for dx in range(per):
                for dy in range(per):
                    cx, cy = cx0 + dx, cy0 + dy
                    if 0 <= cx < W and 0 <= cy < H:
                        total += 1
                        if ob[cx][cy].get('Tags', 0):
                            blocked += 1
            col.append(1 if total and blocked * 2 > total else 0)
        grid.append(col)
    return grid


def build(room, season, center_px, out_dir, ground_path, render_path, sheet_name):
    img = Image.open(render_path).convert('RGBA')
    assert img.size == (GROUND_PX, GROUND_PX), f'rendu inattendu {img.size}'

    win_px_w, win_px_h = WIN_W * TILE, WIN_H * TILE
    x0 = int(center_px[0]) - win_px_w // 2
    y0 = int(center_px[1]) - win_px_h // 2
    x0 = max(0, min(x0, GROUND_PX - win_px_w))
    y0 = max(0, min(y0, GROUND_PX - win_px_h))
    x0 -= x0 % TILE
    y0 -= y0 % TILE

    window = img.crop((x0, y0, x0 + win_px_w, y0 + win_px_h))

    # --- découpe en tuiles 24x24, déduplication sur les pixels bruts ---
    tiles, tex_of = {}, {}
    nxt = [0, 0]
    for ty in range(WIN_H):
        for tx in range(WIN_W):
            t = window.crop((tx * TILE, ty * TILE, (tx + 1) * TILE, (ty + 1) * TILE))
            key = t.tobytes()
            if key not in tex_of:
                loc = (nxt[0], nxt[1])
                tiles[loc] = t
                tex_of[key] = loc
                nxt[0] += 1
                if nxt[0] >= 16:
                    nxt[0] = 0
                    nxt[1] += 1
            tex_of.setdefault(key, tex_of[key])

    grid_tex = [[None] * WIN_H for _ in range(WIN_W)]
    for ty in range(WIN_H):
        for tx in range(WIN_W):
            t = window.crop((tx * TILE, ty * TILE, (tx + 1) * TILE, (ty + 1) * TILE))
            grid_tex[tx][ty] = tex_of[t.tobytes()]

    ground = json.load(open(ground_path, encoding='utf-8-sig'))
    coll = majority_collision(ground, x0, y0, WIN_W, WIN_H)

    def tiletex(loc):
        return {'AutoTileset': '', 'Associates': [], 'NeighborCode': -1,
                'Layers': [{'Frames': [{'Sheet': sheet_name,
                                        'TexLoc': {'X': loc[0], 'Y': loc[1]}}],
                            'FrameLength': 60}]}

    base_tiles = []
    for tx in range(WIN_W):
        col = []
        for ty in range(WIN_H):
            col.append({
                'Data': {'ID': 'unbreakable' if coll[tx][ty] else 'floor',
                         'TileTex': {'AutoTileset': '', 'Associates': [],
                                     'NeighborCode': -1, 'Layers': []},
                         'StableTex': False},
                'Effect': {'TileLoc': {'X': tx, 'Y': ty}, 'ID': '',
                           'Revealed': False, 'Owner': 0, 'TileStates': []},
            })
        base_tiles.append(col)

    layer = {'Name': 'Ground', 'Layer': 0, 'Visible': True,
             'Tiles': [[tiletex(grid_tex[tx][ty]) for ty in range(WIN_H)]
                       for tx in range(WIN_W)]}

    # points d'entrée : au centre, sur des cases libres
    def free_near(cx, cy):
        for r in range(0, 8):
            for dx in range(-r, r + 1):
                for dy in range(-r, r + 1):
                    x, y = cx + dx, cy + dy
                    if 0 <= x < WIN_W and 0 <= y < WIN_H and not coll[x][y]:
                        return x, y
        return cx, cy
    e1 = free_near(WIN_W // 2 - 2, WIN_H // 2)
    e2 = free_near(WIN_W // 2 - 3, WIN_H // 2)

    rsmap = {'Version': '0.8.9.0', 'Object': {
        '$type': 'RogueEssence.Dungeon.Map, RogueEssence',
        'Name': {'DefaultText': f'{room} {season}',
                 'LocalTexts': {'fr': f'{room} ({season})'}},
        'Comment': f'Duel sauvage NNV : fenetre {WIN_W}x{WIN_H} tuiles '
                   f'({win_px_w}x{win_px_h} px) decoupee dans le rendu de '
                   f'{room} {season} a partir du pixel ({x0},{y0}).',
        'Tiles': base_tiles,
        'Layers': [layer],
        'EntryPoints': [{'Loc': {'X': e1[0], 'Y': e1[1]}, 'Dir': 4},
                        {'Loc': {'X': e2[0], 'Y': e2[1]}, 'Dir': 4}],
        'MapTeams': [], 'AllyTeams': [],
    }}

    os.makedirs(out_dir, exist_ok=True)
    stem = f'nnv_duel_{room}_{season}'
    map_path = Path(out_dir) / f'{stem}.rsmap'
    map_path.write_text(json.dumps(rsmap, ensure_ascii=False), encoding='utf-8-sig')
    sheet_path = Path(out_dir) / f'{sheet_name}.tile'
    sheet_info = write_tile_sheet(sheet_path, tiles)

    # --- PREUVE : reconstruire l'image depuis les tuiles écrites ---
    rebuilt = Image.new('RGBA', (win_px_w, win_px_h))
    for ty in range(WIN_H):
        for tx in range(WIN_W):
            rebuilt.paste(tiles[grid_tex[tx][ty]], (tx * TILE, ty * TILE))
    same = list(rebuilt.getdata()) == list(window.getdata())
    diff = 0 if same else sum(1 for a, b in zip(rebuilt.getdata(), window.getdata()) if a != b)

    window.save(Path(out_dir) / f'{stem}_source_window.png')
    rebuilt.save(Path(out_dir) / f'{stem}_rebuilt.png')

    proof = {
        'room': room, 'season': season,
        'window_tiles': [WIN_W, WIN_H],
        'window_px': [win_px_w, win_px_h],
        'origin_px': [x0, y0],
        'center_requested_px': list(center_px),
        'distinct_tiles': sheet_info['count'],
        'sheet_bytes': sheet_info['bytes'],
        'map_bytes': map_path.stat().st_size,
        'blocked_tiles': sum(sum(c) for c in coll),
        'pixel_identical': same,
        'differing_pixels': diff,
        'entry_points': [list(e1), list(e2)],
        'source_window_sha256': hashlib.sha256(window.tobytes()).hexdigest(),
        'rebuilt_sha256': hashlib.sha256(rebuilt.tobytes()).hexdigest(),
    }
    (Path(out_dir) / f'{stem}_proof.json').write_text(
        json.dumps(proof, indent=1) + '\n')
    return proof


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--room', required=True)
    ap.add_argument('--season', default='summer')
    ap.add_argument('--center', default='2496,2496', help='px du Ground, "x,y"')
    ap.add_argument('--reconv', default='/tmp/reconv')
    ap.add_argument('--out', default=str(NNV / 'reports/fauna-ecology/duel-maps'))
    ns = ap.parse_args()

    cx, cy = (int(v) for v in ns.center.split(','))
    gp = f'{ns.reconv}/{ns.room}/Data/Ground/nnv_{ns.room}_{ns.season}.rsground'
    rp = f'{ns.reconv}/{ns.room}/validation/source_normalized_tick0.png'
    if not os.path.exists(gp):
        print('Ground absent:', gp); return 2
    if not os.path.exists(rp):
        print('rendu absent:', rp); return 2

    sheet = f'NNV_Duel_{ns.room.capitalize()}_{ns.season.capitalize()}'
    p = build(ns.room, ns.season, (cx, cy), ns.out, gp, rp, sheet)
    print(json.dumps(p, indent=1))
    print('\nPIXEL-IDENTICAL:', p['pixel_identical'],
          '| tuiles distinctes:', p['distinct_tiles'],
          '| map %.0f Ko + planche %.0f Ko'
          % (p['map_bytes'] / 1024, p['sheet_bytes'] / 1024))
    return 0 if p['pixel_identical'] else 1


if __name__ == '__main__':
    sys.exit(main())
