#!/usr/bin/env python3
"""Rendu PNG d'un .rsground New Era a partir de ses .tile packages.

Format .tile (documente dans tools/convert_pmdred_ground.py) :
  uint32 tileSize, uint32 tileCount,
  tileCount x (uint64 key=x|(y<<32), uint64 offset_absolu),
  a chaque offset : uint64 len + octets PNG.

Format .rsground (verifie terrain par terrain) :
  Object.Layers[i].Tiles[x][y].Layers[j].Frames[k] = {Sheet, TexLoc{x,y}}
  -> tuile package Sheet, cellule (x,y) de tileSize px, blit en (x*p, y*p)
  avec p = pas de grille = 8 * Object.TexSize pixels (verifie :
  entrance TexSize 1 / 81x63 cellules -> 648x504 px, la taille connue).

Usage : python3 tools/render_ground.py <nom_map> [couche] [sortie.png]
"""
import io, json, struct, sys, os
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

_pkg_cache = {}

def load_package(sheet):
    """Retourne (tileSize, dict (x,y)->Image)."""
    if sheet in _pkg_cache:
        return _pkg_cache[sheet]
    path = os.path.join(ROOT, 'Content', 'Tile', sheet + '.tile')
    with open(path, 'rb') as f:
        raw = f.read()
    tile_size, count = struct.unpack_from('<II', raw, 0)
    cells = {}
    recs = []
    for i in range(count):
        key, off = struct.unpack_from('<QQ', raw, 8 + i * 16)
        recs.append((key & 0xFFFFFFFF, key >> 32, off))
    for x, y, off in recs:
        if (x, y) in cells:
            continue
        ln = struct.unpack_from('<Q', raw, off)[0]
        png = raw[off + 8: off + 8 + ln]
        cells[(x, y)] = Image.open(io.BytesIO(png)).convert('RGBA')
    _pkg_cache[sheet] = (tile_size, cells)
    return _pkg_cache[sheet]


def load_map(name):
    with open(os.path.join(ROOT, 'Data', 'Ground', name + '.rsground'),
              encoding='utf-8-sig') as f:
        return json.load(f)['Object']


def render(name, layer_idx=None, out=None):
    obj = load_map(name)
    tex = obj.get('TexSize', 1)
    pitch = 8 * tex
    layers = obj['Layers']
    # ATTENTION : deux grilles differentes coexistent dans un .rsground.
    #   obstacles[][]      -> grille de collision, maille de 8 px fixe
    #   Layers[i].Tiles[][] -> grille graphique, maille de pitch = 8*TexSize
    # GroundMap.Width (GroundMap.cs:49) se lit sur Layers[0].Tiles, PAS sur
    # obstacles. Dimensionner le rendu sur obstacles produit une image
    # TexSize fois trop grande, avec le decor tasse dans le coin haut-gauche
    # et des bandes noires : un faux "probleme de cadrage" purement optique.
    W = len(layers[0]['Tiles'])
    H = len(layers[0]['Tiles'][0])
    img = Image.new('RGBA', (W * pitch, H * pitch), (0, 0, 0, 255))
    for li, layer in enumerate(layers):
        if layer_idx is not None and li != layer_idx:
            continue
        if not layer.get('Visible', True):
            continue
        tiles = layer['Tiles']
        for x in range(min(W, len(tiles))):
            col = tiles[x]
            for y in range(min(H, len(col))):
                cell = col[y]
                for tl in cell.get('Layers', []):
                    frames = tl.get('Frames', [])
                    if not frames:
                        continue
                    fr = frames[0]      # premiere frame (rendu statique)
                    sheet = fr.get('Sheet', '')
                    if not sheet:
                        continue
                    try:
                        tsize, cells = load_package(sheet)
                    except FileNotFoundError:
                        continue
                    loc = fr.get('TexLoc', {'X': 0, 'Y': 0})
                    t = cells.get((loc['X'], loc['Y']))
                    if t is None:
                        continue
                    # une frame de package recouvre tsize px ; la cellule de
                    # grille en fait pitch. On colle au coin haut-gauche.
                    img.alpha_composite(t, (x * pitch, y * pitch))
    if out is None:
        out = os.path.join(ROOT, 'docs', 'renders', name + '.png')
    os.makedirs(os.path.dirname(out), exist_ok=True)
    img.save(out)
    print(out, img.size)


def obstacles_report(name):
    obj = load_map(name)
    W = len(obj['obstacles'])
    H = len(obj['obstacles'][0])
    free = sum(1 for x in range(W) for y in range(H)
               if obj['obstacles'][x][y]['Tags'] == 0)
    print(f'{name}: {W}x{H} cellules, {free} libres '
          f'({100 * free // (W * H)}%), TexSize={obj.get("TexSize")}')


if __name__ == '__main__':
    name = sys.argv[1]
    layer = int(sys.argv[2]) if len(sys.argv) > 2 else None
    out = sys.argv[3] if len(sys.argv) > 3 else None
    obstacles_report(name)
    render(name, layer, out)
