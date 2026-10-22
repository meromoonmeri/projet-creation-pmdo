#!/usr/bin/env python3
"""Construit l'atlas écologique des rooms NNV portant de la faune.

Autorités utilisées, par ordre de confiance :

1. **Le rendu réel** (`/tmp/reconv/<room>/validation/source_normalized_tick0.png`,
   4992x4992). C'est ce que le joueur voit. Les identifiants de tuiles mentent :
   les couches `water`/`endwater`/`marsh` sont des **fonds pleins 39x39** qui,
   selon la room, sont soit visibles soit intégralement recouverts par
   `ground`/`grass`. rmvillage a une couche `endwater` pleine et pas une seule
   goutte d'eau à l'écran. On classe donc l'eau par **colorimétrie du rendu**.
2. **La grille de collision du Ground reconverti** (624x624 cellules de 8 px,
   agrégée en 78x78) : autorité sur la praticabilité.
3. **Les GameObjects source** (Rooms.json) avec leurs vrais préfixes
   saisonniers : objtree/objsmtree/objautree/objwntree, objauplant/objsmplant/
   objwnplant/objspplant, objboulder/objwnrock, objwaterfall, objsnowpile...

Sortie : reports/fauna-ecology/biome-atlas.json.gz

Lecture seule : aucune écriture dans Data/ ni dans les Grounds.
"""
from __future__ import annotations
import argparse, gzip, json, os, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'
STRUCT = ROOT / '.runtime-cache/nnv-official-structured/inventory'
sys.path.insert(0, str(ROOT / '.runtime-cache/pyenv'))
from PIL import Image  # noqa: E402

CELL = 64
GRID = 78
COLL_PER_CELL = 8
SUBSAMPLE = 8          # échantillons par cellule 64 px pour la colorimétrie

TREE_PREFIXES = ('objtree', 'objsmtree', 'objautree', 'objwntree', 'objsptree',
                 'objtreecol', 'objbf')
ROCK_PREFIXES = ('objboulder', 'objwnrock', 'objbfrock', 'objrock')
PLANT_PREFIXES = ('objauplant', 'objsmplant', 'objwnplant', 'objspplant',
                  'objsmbplant', 'objaubmush', 'objsmcrop', 'objplant')
WALL_PREFIXES = ('objcolwall', 'objbwall', 'objbcwall', 'objcolwallr', 'objcol')
SLOPE_PREFIXES = ('objcolslope', 'objbslope', 'objbcslope')
WATERFALL_PREFIXES = ('objwaterfall', 'objwf', 'objwfs', 'objwaterfalldiag',
                      'objwaterfallside')
SNOW_PREFIXES = ('objsnowpile',)
BUILDING_PREFIXES = ('objplayerhouse', 'objloggerhouse', 'objhunterhouse',
                     'objcarpenterhouse', 'objlh', 'objdoor', 'objcave')

T_BLOCKED, T_OPEN, T_GRASS, T_WATER, T_MARSH = 0, 1, 2, 3, 4
T_TREE, T_ROCK, T_CLIFF, T_PLANT, T_SNOW = 5, 6, 7, 8, 9
NAMES = {0: 'blocked', 1: 'open', 2: 'grass', 3: 'water', 4: 'marsh',
         5: 'tree', 6: 'rock', 7: 'cliff', 8: 'plant', 9: 'snow'}


def is_water_rgb(r, g, b):
    """L'eau NNV est un cyan saturé, pas un bleu quelconque.

    Piège vérifié sur rm59 : le feuillage lavande des arbres (180,185,227) passe
    tous les tests "bleu" naïfs. L'eau réelle (63,172,240 / 49,162,242 /
    14,132,219) s'en distingue par un vert nettement supérieur au rouge --
    c'est du cyan. Discriminateur validé sur 14 couleurs témoins
    (eaux des 3 rooms, 4 nuances de lavande, herbes, terre, sable, ombres).
    """
    return b >= 150 and (b - r) >= 90 and g > r + 40


def is_snow_rgb(r, g, b):
    """La neige NNV est un lavande clair, pas un blanc pur.

    L'ancien seuil (r>200, g>205, b>210) ne reconnaissait que le blanc franc.
    Or les deux couleurs qui couvrent le sol des rooms d'hiver sont
    (197,211,232) et (180,185,227) : trop bleutees pour ce test, et pas assez
    vertes pour is_green_rgb. Elles retombaient donc en `open` cote rendu
    tandis que l'atlas les comptait en `grass` -- 2 708 cellules sur rm58, avec
    un atlas annoncant 2 711 `grass` pour 62 `snow` sur une room enneigee.
    C'est exactement le risque decrit dans PREUVE_SAISONNIERE.md : un Pokemon
    place sur une cellule `grass` qui n'est pas de l'herbe.

    Discriminateur : clair, bleute mais pas cyan (sinon c'est l'eau), et de
    faible saturation. Mesure sur les 34 rendus versionnes -- les 5 rooms
    d'hiver sortent entre 61,3 % et 69,7 % de neige, les 29 autres plafonnent a
    6,5 %. La separation est nette, aucun arbitrage n'est necessaire.
    """
    if b < 195 or r < 150 or b <= r:
        return False
    if g > r + 40:            # vert nettement au-dessus du rouge = cyan = eau
        return False
    return (b - r) <= 90 and max(r, g, b) - min(r, g, b) <= 90


def is_marsh_rgb(r, g, b):
    """Brun-vert saturé, sombre et terne : boue et tourbe."""
    return 55 <= r <= 150 and 45 <= g <= 130 and b < 95 and abs(r - g) < 45 and r >= g - 12


def is_green_rgb(r, g, b):
    return g > r + 12 and g > b + 12


def render_classes(png_path):
    """Classe chaque cellule 78x78 par la couleur majoritaire du rendu."""
    im = Image.open(png_path).convert('RGB')
    px = im.load()
    W, H = im.size
    step = max(1, (W // GRID) // SUBSAMPLE)
    out = [[T_OPEN] * GRID for _ in range(GRID)]
    for cy in range(GRID):
        y0 = cy * H // GRID
        y1 = (cy + 1) * H // GRID
        for cx in range(GRID):
            x0 = cx * W // GRID
            x1 = (cx + 1) * W // GRID
            w = s = m = g = n = 0
            for y in range(y0, y1, step):
                for x in range(x0, x1, step):
                    r, gg, b = px[x, y]
                    n += 1
                    if is_water_rgb(r, gg, b):
                        w += 1
                    elif is_snow_rgb(r, gg, b):
                        s += 1
                    elif is_marsh_rgb(r, gg, b):
                        m += 1
                    elif is_green_rgb(r, gg, b):
                        g += 1
            if not n:
                continue
            if w * 2 >= n:
                out[cy][cx] = T_WATER
            elif s * 2 >= n:
                out[cy][cx] = T_SNOW
            elif m * 2 >= n:
                out[cy][cx] = T_MARSH
            elif g * 2 >= n:
                out[cy][cx] = T_GRASS
            else:
                out[cy][cx] = T_OPEN
    return out


def object_cells(room):
    cats = {'tree': {}, 'rock': {}, 'plant': {}, 'wall': {}, 'slope': {},
            'waterfall': {}, 'snow': {}, 'building': {}}
    for go in room.get('GameObjects') or []:
        ref = (go.get('ObjectDefinition') or {}).get('$resourceRef') or {}
        name = (ref.get('name') or '').lower()
        if not name:
            continue
        cx, cy = go.get('X', 0) // CELL, go.get('Y', 0) // CELL
        if not (0 <= cx < GRID and 0 <= cy < GRID):
            continue
        k = (cx, cy)
        if name.startswith(BUILDING_PREFIXES):
            cats['building'][k] = name
        elif name.startswith(WATERFALL_PREFIXES):
            cats['waterfall'][k] = name
        elif name.startswith(TREE_PREFIXES):
            cats['tree'][k] = name
        elif name.startswith(ROCK_PREFIXES):
            cats['rock'][k] = name
        elif name.startswith(SNOW_PREFIXES):
            cats['snow'][k] = name
        elif name.startswith(PLANT_PREFIXES):
            cats['plant'][k] = name
        elif name.startswith(WALL_PREFIXES):
            cats['wall'][k] = name
        elif name.startswith(SLOPE_PREFIXES):
            cats['slope'][k] = name
    return cats


def collision_grid(ground_path):
    d = json.load(open(ground_path, encoding='utf-8-sig'))
    ob = d['Object']['obstacles']
    w, h = len(ob), len(ob[0])
    g = [[0] * GRID for _ in range(GRID)]
    for cy in range(GRID):
        y0, y1 = cy * COLL_PER_CELL, min((cy + 1) * COLL_PER_CELL, h)
        for cx in range(GRID):
            x0, x1 = cx * COLL_PER_CELL, min((cx + 1) * COLL_PER_CELL, w)
            b = 0
            for ox in range(x0, x1):
                col = ob[ox]
                for oy in range(y0, y1):
                    if col[oy].get('Tags', 0):
                        b += 1
            g[cy][cx] = b
    return g


def dist_map(pred, maxd=4):
    d = [[99] * GRID for _ in range(GRID)]
    cur = []
    for y in range(GRID):
        for x in range(GRID):
            if pred(x, y):
                d[y][x] = 0
                cur.append((x, y))
    for step in range(1, maxd + 1):
        nxt = []
        for (x, y) in cur:
            for dy in (-1, 0, 1):
                for dx in (-1, 0, 1):
                    nx, ny = x + dx, y + dy
                    if 0 <= nx < GRID and 0 <= ny < GRID and d[ny][nx] == 99:
                        d[ny][nx] = step
                        nxt.append((nx, ny))
        cur = nxt
    return d


def build_room(room, ground_path, render_path):
    vis = render_classes(render_path) if render_path and os.path.exists(render_path) \
        else [[T_OPEN] * GRID for _ in range(GRID)]
    cats = object_cells(room)
    coll = collision_grid(ground_path) if ground_path and os.path.exists(ground_path) else None
    half = COLL_PER_CELL * COLL_PER_CELL // 2

    terrain = [[T_OPEN] * GRID for _ in range(GRID)]
    for y in range(GRID):
        for x in range(GRID):
            k = (x, y)
            if k in cats['tree']:
                terrain[y][x] = T_TREE
            elif k in cats['rock']:
                terrain[y][x] = T_ROCK
            elif k in cats['building'] or k in cats['wall']:
                terrain[y][x] = T_BLOCKED
            elif k in cats['waterfall']:
                terrain[y][x] = T_WATER
            elif k in cats['plant'] and vis[y][x] not in (T_WATER, T_MARSH):
                terrain[y][x] = T_PLANT
            else:
                terrain[y][x] = vis[y][x]

    if coll:
        for y in range(GRID):
            for x in range(GRID):
                if terrain[y][x] in (T_OPEN, T_GRASS, T_PLANT, T_MARSH, T_SNOW) \
                        and coll[y][x] > half:
                    terrain[y][x] = T_BLOCKED

    walkable = [[1 if terrain[y][x] in (T_OPEN, T_GRASS, T_PLANT, T_MARSH, T_SNOW) else 0
                 for x in range(GRID)] for y in range(GRID)]
    swimmable = [[1 if terrain[y][x] == T_WATER else 0
                  for x in range(GRID)] for y in range(GRID)]

    near_tree = dist_map(lambda x, y: terrain[y][x] == T_TREE)
    near_water = dist_map(lambda x, y: terrain[y][x] in (T_WATER, T_MARSH))
    near_rock = dist_map(lambda x, y: terrain[y][x] in (T_ROCK, T_CLIFF))
    near_plant = dist_map(lambda x, y: terrain[y][x] == T_PLANT)

    def openness(x, y):
        n = 0
        for dy in (-1, 0, 1):
            for dx in (-1, 0, 1):
                nx, ny = x + dx, y + dy
                if 0 <= nx < GRID and 0 <= ny < GRID and terrain[ny][nx] != T_BLOCKED:
                    n += 1
        return n
    open_space = [[openness(x, y) for x in range(GRID)] for y in range(GRID)]

    counts = {}
    for y in range(GRID):
        for x in range(GRID):
            k = NAMES[terrain[y][x]]
            counts[k] = counts.get(k, 0) + 1

    return {
        'terrain': terrain, 'walkable': walkable, 'swimmable': swimmable,
        'near_tree': near_tree, 'near_water': near_water,
        'near_rock': near_rock, 'near_plant': near_plant,
        'open_space': open_space,
        'objects': {k: len(v) for k, v in cats.items()},
        'counts': counts, 'has_collision': coll is not None,
        'has_render': bool(render_path and os.path.exists(render_path)),
    }


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--reconv', default='/tmp/reconv')
    ap.add_argument('--out', default=str(NNV / 'reports/fauna-ecology'))
    ap.add_argument('--rooms', default='')
    ns = ap.parse_args()

    occ = json.load(open(NNV / 'reports/fauna-fix/fauna-occurrences.json'))
    targets = ns.rooms.split(',') if ns.rooms else list(occ['per_room'])
    rooms = {r['Name']: r for r in json.load(open(STRUCT / 'Rooms.json')) if r.get('Name')}

    out = {'schema': 'nnv-biome-atlas-v3', 'cell_px': CELL, 'grid': GRID,
           'terrain_names': NAMES, 'rooms': {}}
    for name in sorted(targets):
        room = rooms.get(name)
        if not room:
            print('SKIP (absent de Rooms.json):', name)
            continue
        gp = None
        for season in ('summer', 'spring', 'autumn', 'winter'):
            p = f'{ns.reconv}/{name}/Data/Ground/nnv_{name}_{season}.rsground'
            if os.path.exists(p):
                gp = p
                break
        rp = f'{ns.reconv}/{name}/validation/source_normalized_tick0.png'
        data = build_room(room, gp, rp)
        out['rooms'][name] = data
        c, o = data['counts'], data['objects']
        print('%-10s tree=%-4d rock=%-3d plant=%-4d | water=%-4d marsh=%-4d '
              'grass=%-4d snow=%-4d open=%-4d blocked=%-4d | coll=%s rend=%s'
              % (name, o['tree'], o['rock'], o['plant'], c.get('water', 0),
                 c.get('marsh', 0), c.get('grass', 0), c.get('snow', 0),
                 c.get('open', 0), c.get('blocked', 0),
                 data['has_collision'], data['has_render']))

    os.makedirs(ns.out, exist_ok=True)
    p = Path(ns.out) / 'biome-atlas.json.gz'
    with gzip.open(p, 'wt') as f:
        json.dump(out, f)
    print('ecrit', p, os.path.getsize(p), 'octets,', len(out['rooms']), 'rooms')


if __name__ == '__main__':
    main()
