#!/usr/bin/env python3
"""Réseau de pièces type Café Spinda (accueil central, escaliers N/S, étages
+1/0/-1, salons à l'est) texturé avec les tuiles NATIVES Halcyon
Metano_Town_Normal_Home_Base / _Objects (variante normale, jour).

Aucun pixel repeint : chaque tuile de 8 px placée est une référence
(sheet, TexLoc) copiée depuis Data/Ground/metano_normal_home.rsground
d'Halcyon (Palikadude/Halcyon, master). Les exports sont donc à la fois
des PNG composés et de vrais Grounds PMDO référençant ces tilesets.
art_approved / runtime : voir manifeste (non testé moteur).
"""
import base64, copy, io, json, struct, sys
from collections import deque
from pathlib import Path

import numpy as np
from PIL import Image

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[1]
REF = HERE / 'references'
sys.path.insert(0, str(ROOT / 'source/amp_plains_fleurie_v1'))
from inspect_references import decode  # noqa: E402

OUT = ROOT / 'renders/reseau_metano_normal_v1'
NEUTRAL = (58, 48, 40)
TW, TH = 75, 56  # tuiles de 8 px -> 600 x 448, comme les salles Spinda V7

# ---------------------------------------------------------------- référence
banks = {}
for p in REF.glob('*.tile'):
    size, bank = decode(p)
    assert size == 8
    banks[p.stem] = bank
ref_ground = json.loads((REF / 'metano_normal_home.rsground').read_text(encoding='utf-8-sig'))
ref_layers = ref_ground['Object']['Layers']


def ref_cell(layer_name, x, y):
    layer = next(l for l in ref_layers if l['Name'] == layer_name)
    return layer['Tiles'][x][y]


def ref_has(layer_name, x, y):
    return bool(ref_cell(layer_name, x, y)['Layers'])


# ------------------------------------------------------------- construction
class Room:
    def __init__(self, rid):
        self.id = rid
        self.base = {}   # (x, y) -> cellule rsground (calque Base)
        self.obj = {}    # (x, y) -> cellule rsground (calque Objects)
        self.blocked = set()
        self.access = {}

    def put(self, layer, sx, sy, dx, dy):
        cell = copy.deepcopy(ref_cell(layer, sx, sy))
        (self.base if layer == 'Base' else self.obj)[(dx, dy)] = cell

    def paste(self, layer, box, dx, dy, only_filled=False):
        x0, y0, x1, y1 = box
        for sx in range(x0, x1):
            for sy in range(y0, y1):
                if only_filled and not ref_has(layer, sx, sy):
                    continue
                self.put(layer, sx, sy, dx + sx - x0, dy + sy - y0)

    def tile_fill(self, layer, box, rect):
        x0, y0, x1, y1 = box
        rx0, ry0, rx1, ry1 = rect
        for dx in range(rx0, rx1):
            for dy in range(ry0, ry1):
                self.put(layer, x0 + (dx - rx0) % (x1 - x0), y0 + (dy - ry0) % (y1 - y0), dx, dy)


FLOOR = (12, 18, 20, 24)        # parquet plein (patch le plus uniforme de la reference, raccordable)
NORTH = (6, 2, 14, 14)          # bandeau nord (panneaux)
SIDE_W = (2, 14, 5, 26)
SIDE_E = (40, 14, 43, 26)
SOUTH = (12, 30, 20, 35)        # bandeau sud (calque Objects)
WINDOW = (14, 1, 31, 13)        # fenêtre ronde + arche + colonnes
CORN_NW = (1, 2, 9, 10)
CORN_NE = (36, 2, 44, 10)
CORN_SW = (0, 27, 8, 35)
CORN_SE = (37, 27, 45, 35)
RUG = (15, 13, 30, 21)          # tapis de paille
STEPS = (31, 17, 37, 23)        # escalier-échelle bois
TABLE = (16, 18, 28, 27)
CRATE = (6, 12, 10, 16)
BOWLS = (6, 16, 10, 20)
BASKET = (31, 19, 35, 24)
ROCK = (29, 12, 32, 16)

RX0, RY0, RX1, RY1 = 5, 3, 70, 53   # enveloppe de la pièce (tuiles)


def shell(room, window=True):
    room.tile_fill('Base', FLOOR, (RX0, RY0, RX1, RY1))
    room.tile_fill('Base', NORTH, (RX0, RY0, RX1, 15))
    room.paste('Base', CORN_NW, RX0, RY0)
    room.paste('Base', CORN_NE, RX1 - 8, RY0)
    if window:
        room.paste('Base', WINDOW, 29, RY0)
    room.tile_fill('Base', SIDE_W, (RX0, 15, RX0 + 3, 49))
    room.tile_fill('Base', SIDE_E, (RX1 - 3, 15, RX1, 49))
    room.tile_fill('Objects', SOUTH, (RX0, 48, RX1, 53))
    room.paste('Objects', CORN_SW, RX0, 45, only_filled=True)
    room.paste('Objects', CORN_SE, RX1 - 8, 45, only_filled=True)
    for x in range(RX0, RX1):
        for y in list(range(RY0, 15)) + list(range(48, RY1)):
            room.blocked.add((x, y))
    for y in range(15, 48):
        for x in list(range(RX0, RX0 + 3)) + list(range(RX1 - 3, RX1)):
            room.blocked.add((x, y))


def door(room, rect, name):
    x0, y0, x1, y1 = rect
    room.tile_fill('Base', FLOOR, rect)
    for x in range(x0, x1):
        for y in range(y0, y1):
            room.obj.pop((x, y), None)
            room.blocked.discard((x, y))
    room.access[name] = ((x0 + x1) // 2 * 8 + 4, (y0 + y1) // 2 * 8 + 4)


def stairs(room, dx, dy, name):
    room.paste('Base', STEPS, dx, dy)
    for x in range(dx, dx + 6):
        for y in range(dy, dy + 6):
            room.blocked.discard((x, y))
    room.access[name] = (dx * 8 + 24, dy * 8 + 24)


def furniture(room, box, layer, dx, dy, name):
    room.paste(layer, box, dx, dy, only_filled=(layer == 'Objects'))
    x0, y0, x1, y1 = box
    if layer == 'Objects':
        for sx in range(x0, x1):
            for sy in range(y0, y1):
                if ref_has('Objects', sx, sy):
                    room.blocked.add((dx + sx - x0, dy + sy - y0))


def build_rooms():
    rooms = {}

    r = Room('accueil'); shell(r)
    stairs(r, 35, 8, 'escalier_N_vers_cafe')
    for x in range(35, 41):  # palier entre le bas de l'escalier N et le sol
        r.blocked.discard((x, 14))
    stairs(r, 35, 45, 'escalier_S_vers_casino')
    r.paste('Base', RUG, 30, 26)
    furniture(r, TABLE, 'Objects', 48, 32, 'table')
    furniture(r, CRATE, 'Objects', 10, 18, 'caisse')
    furniture(r, BOWLS, 'Objects', 11, 42, 'bols')
    furniture(r, BASKET, 'Objects', 58, 19, 'panier')
    rooms['accueil'] = r

    r = Room('cafe'); shell(r)
    door(r, (33, 48, 41, 53), 'porte_S_vers_accueil')
    door(r, (67, 29, 70, 37), 'porte_E_vers_salon_haut')
    r.paste('Base', RUG, 30, 24)
    furniture(r, TABLE, 'Objects', 18, 32, 'table')
    furniture(r, BASKET, 'Objects', 58, 42, 'panier')
    furniture(r, CRATE, 'Objects', 10, 40, 'caisse')
    rooms['cafe'] = r

    r = Room('salon_haut'); shell(r)
    door(r, (5, 29, 8, 37), 'porte_W_vers_cafe')
    r.paste('Base', RUG, 34, 26)
    furniture(r, TABLE, 'Objects', 24, 38, 'table')
    furniture(r, CRATE, 'Objects', 58, 18, 'caisse')
    furniture(r, BOWLS, 'Objects', 10, 20, 'bols')
    furniture(r, ROCK, 'Objects', 58, 40, 'pierre')
    rooms['salon_haut'] = r

    r = Room('casino'); shell(r, window=False)
    door(r, (33, 3, 41, 15), 'porte_N_vers_accueil')
    door(r, (67, 29, 70, 37), 'porte_E_vers_salon_bas')
    r.paste('Base', RUG, 30, 26)
    furniture(r, TABLE, 'Objects', 20, 34, 'table')
    furniture(r, BASKET, 'Objects', 58, 20, 'panier')
    furniture(r, BOWLS, 'Objects', 52, 42, 'bols')
    rooms['casino'] = r

    r = Room('salon_bas'); shell(r, window=False)
    door(r, (5, 29, 8, 37), 'porte_W_vers_casino')
    r.paste('Base', RUG, 26, 36)
    furniture(r, TABLE, 'Objects', 40, 26, 'table')
    furniture(r, CRATE, 'Objects', 12, 18, 'caisse')
    furniture(r, BASKET, 'Objects', 12, 42, 'panier')
    rooms['salon_bas'] = r
    return rooms


LINKS = [['accueil', 'escalier_N', 'cafe', 'porte_S'],
         ['accueil', 'escalier_S', 'casino', 'porte_N'],
         ['casino', 'porte_E', 'salon_bas', 'porte_W'],
         ['cafe', 'porte_E', 'salon_haut', 'porte_W']]
FLOORS = {'accueil': 0, 'cafe': 1, 'salon_haut': 1, 'casino': -1, 'salon_bas': -1}


# ------------------------------------------------------------------ sorties
def cell_img(cell):
    im = Image.new('RGBA', (8, 8))
    for sub in cell['Layers']:
        f = sub['Frames'][0]
        sheet = banks.get(f['Sheet'])
        if sheet and (f['TexLoc']['X'], f['TexLoc']['Y']) in sheet:
            im.alpha_composite(sheet[f['TexLoc']['X'], f['TexLoc']['Y']])
    return im


def render(room, layer_names=('Base', 'Objects')):
    im = Image.new('RGBA', (TW * 8, TH * 8))
    grid = {'Base': room.base, 'Objects': room.obj}
    for name in layer_names:
        for (x, y), cell in grid[name].items():
            im.alpha_composite(cell_img(cell), (x * 8, y * 8))
    return im


def check_paths(room):
    def free(c):
        x, y = c
        return (RX0 <= x < RX1 and RY0 <= y < RY1 and c not in room.blocked)
    pts = {k: (v[0] // 8, v[1] // 8) for k, v in room.access.items()}
    start = next(iter(pts.values()))
    seen, dq = {start}, deque([start])
    while dq:
        x, y = dq.popleft()
        for nb in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
            if nb not in seen and free(nb):
                seen.add(nb); dq.append(nb)
    for k, p in pts.items():
        assert p in seen, (room.id, k, 'inaccessible')


def empty_cell():
    return {'AutoTileset': '', 'Associates': [], 'Layers': [], 'NeighborCode': -1}


def to_ground(room):
    obj = copy.deepcopy(ref_ground['Object'])
    obj['Name'] = 'dict'
    obj['AssetName'] = f'metano_reseau_{room.id}'
    obj['Comment'] = ('Reseau type Cafe Spinda, texture Halcyon Metano_Town_Normal_Home '
                      '(tuiles natives copiees de metano_normal_home). Non teste moteur.')
    for k in ('Entities', 'obstacles', 'Decorations'):
        if isinstance(obj.get(k), list):
            obj[k] = []
    grids = {'Base': room.base, 'Objects': room.obj}
    new_layers = []
    for li, layer in enumerate(obj['Layers'][:2]):
        tiles = [[copy.deepcopy(grids[layer['Name']][(x, y)]) if (x, y) in grids[layer['Name']]
                  else empty_cell() for y in range(TH)] for x in range(TW)]
        new_layers.append({'Name': layer['Name'], 'Layer': li, 'Visible': True, 'Tiles': tiles})
    obj['Layers'] = new_layers
    return {'Version': ref_ground.get('Version', '0.8.12'), 'Object': obj}


def b64(im):
    buf = io.BytesIO(); im.save(buf, 'PNG')
    return 'data:image/png;base64,' + base64.b64encode(buf.getvalue()).decode()


def main():
    rooms = build_rooms()
    for d in ('salles', 'calques', 'apercus', 'grounds'):
        (OUT / d).mkdir(parents=True, exist_ok=True)
    manifest = {
        'lot': 'reseau_metano_normal_v1',
        'disposition': 'identique au reseau Cafe Spinda V7 : accueil central (RDC) avec escalier '
                       'au nord vers le +1 et escalier au sud vers le -1 ; cafe et salon_haut au +1 ; '
                       'casino et salon_bas au -1 ; salons a l est.',
        'texture': 'Halcyon (Palikadude/Halcyon, master) : Metano_Town_Normal_Home_Base + '
                   'Metano_Town_Normal_Home_Objects, variante normale ; tuiles natives 8 px copiees '
                   'par reference (sheet, TexLoc) depuis metano_normal_home.rsground.',
        'liens': LINKS, 'rooms': [],
        'art_approved': False, 'runtime_tested': False, 'runtime_PMDO': 'NOT TESTED',
    }
    previews = {}
    for rid, room in rooms.items():
        check_paths(room)
        comp = render(room)
        arr = np.array(comp)
        assert not ((arr[..., 0] > 250) & (arr[..., 1] < 10) & (arr[..., 2] > 250) & (arr[..., 3] > 0)).any()
        comp.save(OUT / f'salles/MetanoNormal_{rid}.png')
        render(room, ('Base',)).save(OUT / f'calques/MetanoNormal_{rid}_base.png')
        render(room, ('Objects',)).save(OUT / f'calques/MetanoNormal_{rid}_objets.png')
        bg = Image.new('RGBA', comp.size, NEUTRAL + (255,)); bg.alpha_composite(comp)
        bg.convert('RGB').save(OUT / f'apercus/MetanoNormal_{rid}_fond_neutre.png')
        previews[rid] = bg.convert('RGB')
        (OUT / f'grounds/metano_reseau_{rid}.rsground').write_text(
            json.dumps(to_ground(room), ensure_ascii=False), encoding='utf-8')
        manifest['rooms'].append({'id': rid, 'etage': FLOORS[rid],
                                  'file': f'salles/MetanoNormal_{rid}.png',
                                  'ground': f'grounds/metano_reseau_{rid}.rsground',
                                  'acces': room.access})
    (OUT / 'manifest.json').write_text(json.dumps(manifest, ensure_ascii=False, indent=1), encoding='utf-8')

    cards = ''
    for floor, title in ((1, 'Étage +1'), (0, 'Rez-de-chaussée'), (-1, 'Étage −1')):
        rs = [r for r in manifest['rooms'] if r['etage'] == floor]
        cards += f'<h2>{title}</h2><div class="row">' + ''.join(
            f'<figure><img src="{b64(previews[r["id"]])}"><figcaption><b>{r["id"]}</b> — '
            + ', '.join(r['acces'].keys()) + '</figcaption></figure>' for r in rs) + '</div>'
    html = ('<!doctype html><html lang="fr"><meta charset="utf-8">'
            '<title>Réseau Métano Normal — disposition Café Spinda</title>'
            '<style>body{font:16px system-ui;background:#241f1a;color:#efe6da;margin:0 auto;'
            'max-width:1500px;padding:24px}h1{font-size:30px}h2{margin-top:34px;color:#f1d69d}'
            '.row{display:flex;gap:20px;flex-wrap:wrap}figure{margin:0}img{width:600px;max-width:44vw;'
            'image-rendering:pixelated;background:#3a3028}figcaption{margin-top:6px;color:#cbb9a0}'
            'p{line-height:1.55;color:#d8c9b4}.tag{color:#f1d69d}</style>'
            '<h1>Réseau de pièces « Métano Normal » — disposition Café Spinda</h1>'
            '<p>Même disposition que le Café Spinda V7 : <b>accueil</b> central avec escalier au '
            '<b>nord</b> (vers le café, +1) et escalier au <b>sud</b> (vers le casino, −1) ; '
            'salons à l’est à chaque étage. Texture : tuiles <span class="tag">natives 8 px</span> '
            'd’Halcyon <i>Metano_Town_Normal_Home</i> (variante normale), réassemblées par références '
            '— aucun pixel repeint ni mis à l’échelle. Chaque pièce est aussi exportée en Ground PMDO '
            '(.rsground) référençant ces tilesets. Warps/collisions non testés moteur.</p>'
            + cards + '</html>')
    (ROOT / 'apercu_reseau_metano_normal_v1.html').write_text(html, encoding='utf-8')
    print({r: 'ok' for r in rooms})
    print('liens:', LINKS)


if __name__ == '__main__':
    main()
