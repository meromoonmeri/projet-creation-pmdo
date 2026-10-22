#!/usr/bin/env python3
"""Reconstruit Data/Ground/songe_source.rsground : « jardins suspendus ».

Conception (audit 2026-07-30 + carte blanche) :
- bloc source (bassin, colonne de lumiere, gemmes, rive) CONSERVE a
  l'identique — ancres de la scene inchangees (glow (390,205), rive
  y~285-305, axe du heros col 16, marqueur d'entree (12,24)) ;
- flancs et coins = VIDE transparent : la parallaxe de reve apparait a
  travers, le jardin flotte ;
- ilots suspendus dans le vide (herbe + fleurs) ;
- toute case au contact du vide est fondue en alpha dans sa direction ;
- obstacles recalcules (eau/lumiere/arbres/conserves d'origine + vide
  bloque, herbe/rive/ilots/aire d'atterrissage libres) ; axe du heros et
  point d'ancre prouves libres.

Mecanique : les cellules pointent vers des frames du paquet
Content/Tile/LuminousSpring.tile. Le paquet est ETENDU (TexLoc x>=25) :
frame vide transparente + variantes fonduees. Les 625 frames d'origine
restent byte-identiques (luminous_spring est inchangee a la lecture).
IDEMPOTENT : refuse de tourner si le paquet a deja ete etendu.

Sortie : BOM UTF-8 + json.dumps(ensure_ascii=False, indent=0) (format
prouve par tools/make_songe_source.py).
"""
import json, struct, io, sys
from PIL import Image

TILE = 'Content/Tile/LuminousSpring.tile'
SRC_GROUND = 'Data/Ground/luminous_spring.rsground'
OUT_GROUND = 'Data/Ground/songe_source.rsground'
W = H = 25
VOID_KEY = (25, 0)

def load_tile_pkg(path):
    raw = open(path, 'rb').read()
    ts, n = struct.unpack_from('<II', raw, 0)
    keys, pngs = [], []
    for i in range(n):
        k, off = struct.unpack_from('<QQ', raw, 8 + i * 16)
        ln = struct.unpack_from('<Q', raw, off)[0]
        keys.append((k & 0xFFFFFFFF, k >> 32))
        pngs.append(raw[off + 8:off + 8 + ln])
    return ts, keys, pngs

def write_tile_pkg(path, ts, entries):
    uniq, order = {}, []
    for key, png in entries:
        if png not in uniq:
            uniq[png] = len(order)
            order.append(png)
    header = 8 + len(entries) * 16
    blobpos, pos = [], header
    for png in order:
        blobpos.append(pos)
        pos += 8 + len(png)
    out = bytearray()
    out += struct.pack('<II', ts, len(entries))
    for key, png in entries:
        out += struct.pack('<QQ', key[0] | (key[1] << 32), blobpos[uniq[png]])
    for png in order:
        out += struct.pack('<Q', len(png)) + png
    open(path, 'wb').write(bytes(out))

def img_of(png):
    return Image.open(io.BytesIO(png)).convert('RGBA')

def png_of(img):
    buf = io.BytesIO()
    img.save(buf, 'PNG')
    buf.seek(0)
    return buf.read()

def fade(img, dirs):
    out = img.copy()
    a = out.getchannel('A')
    px = a.load()
    for yy in range(24):
        for xx in range(24):
            ks = []
            if 'N' in dirs: ks.append(yy / 24)
            if 'S' in dirs: ks.append((23 - yy) / 24)
            if 'W' in dirs: ks.append(xx / 24)
            if 'E' in dirs: ks.append((23 - xx) / 24)
            if ks:
                px[xx, yy] = int(px[xx, yy] * min(ks))
    return out

ts, keys, pngs = load_tile_pkg(TILE)
if any(k[0] >= 25 for k in keys):
    sys.exit('paquet deja etendu — restaurer LuminousSpring.tile avant de rejouer')
print('paquet :', len(keys), 'frames, tileSize', ts)
orig = dict(zip(keys, pngs))

new_entries = list(zip(keys, pngs))
new_entries.append((VOID_KEY, png_of(Image.new('RGBA', (24, 24), (0, 0, 0, 0)))))
cache = {}
next_xy = [25, 1]

def add_frame(img):
    k = (next_xy[0], next_xy[1])
    next_xy[1] += 1
    if next_xy[1] > 63:
        next_xy[0] += 1
        next_xy[1] = 0
    new_entries.append((k, png_of(img)))
    return k

def faded_key(basekey, dirs):
    ck = (basekey, tuple(sorted(dirs)))
    if ck not in cache:
        cache[ck] = add_frame(fade(img_of(orig[basekey]), set(dirs)))
    return cache[ck]

# ---------------------------------------------------------------- plan
g = json.load(open(SRC_GROUND, encoding='utf-8-sig'))['Object']
L0 = g['Layers'][0]['Tiles']

# Patchs d'herbe AUTHENTIQUE, preleves tels quels sur la clairiere
# d'origine (motif cyclique mesure : la meme tuile revient en
# (10,14)/(10,18)/(10,22)) — coller des patchs, jamais une tuile
# unique repetee. P2 decale le point de lecture pour varier les ilots.
def make_patch(sx, sy):
    return {(dx, dy): (sx + dx, sy + dy) for dx in range(3) for dy in range(3)}
PATCH1 = make_patch(10, 13)   # porte la fleur (planche-contact verifiee)
PATCH2 = make_patch(11, 16)

plan = {}
for x in range(W):
    for y in range(H):
        plan[(x, y)] = 'c'         # conserver luminous

def rect(x0, y0, x1, y1, v):
    for xx in range(x0, x1 + 1):
        for yy in range(y0, y1 + 1):
            plan[(xx, yy)] = v

# flancs et coins -> vide (la parallaxe traverse)
rect(0, 8, 3, 21, 'v')             # flanc ouest
rect(21, 8, 24, 21, 'v')           # flanc est
rect(0, 22, 6, 24, 'v')            # coin sud-ouest
rect(17, 22, 24, 24, 'v')          # coin sud-est (aire d'att. conservee)
rect(0, 0, 2, 7, 'v')              # angle nord-ouest se dissout dans le ciel
rect(23, 0, 24, 7, 'v')            # angle nord-est idem

# ilots suspendus (composes, pas poses au hasard) — chaque case porte la
# case correspondante d'un patch d'herbe, et les coins sont RETIRES pour
# une silhouette en gouttiere flottante (jamais un pave rectangulaire).
def islet(x0, y0, w, h, patch, cut=()):
    for xx in range(w):
        for yy in range(h):
            if (xx, yy) in cut:
                continue
            plan[(x0 + xx, y0 + yy)] = ('p', patch[(xx % 3, yy % 3)])

CROIX = {(0, 0), (2, 0), (0, 2), (2, 2)}
islet(1, 12, 3, 3, PATCH1, cut=CROIX)          # ilot ouest (croix)
islet(1, 4, 2, 2, PATCH2)                      # ilot ouest haut
islet(21, 14, 3, 3, PATCH2, cut=CROIX)         # ilot est (croix)
islet(2, 19, 3, 2, PATCH1, cut={(0, 0), (2, 0)})   # ilot sud-ouest
islet(19, 22, 3, 2, PATCH2, cut={(0, 1), (2, 1)})  # ilot sud-est
islet(23, 3, 2, 2, PATCH1)                     # echo nord-est de l'ilot ouest haut

def base_of(xx, yy):
    fr = L0[xx][yy]['Layers']
    if fr and fr[0]['Frames']:
        f = fr[0]['Frames'][0]
        return (f['TexLoc']['X'], f['TexLoc']['Y'])
    return GRASS

def cell(key, nc=0):
    return {"AutoTileset": "", "Associates": [],
            "Layers": [{"Frames": [{"Sheet": "LuminousSpring",
                                    "TexLoc": {"X": key[0], "Y": key[1]}}],
                         "FrameLength": 60}], "NeighborCode": nc}

# ---------------------------------------------------------------- grille
grid = [[None] * H for _ in range(W)]
for x in range(W):
    for y in range(H):
        v = plan[(x, y)]
        if v == 'c':
            grid[x][y] = L0[x][y]
        elif v == 'v':
            grid[x][y] = cell(VOID_KEY)
        else:  # ('p', key) : case du patch d'herbe
            grid[x][y] = cell(v[1])

DIRS = {'N': (0, -1), 'S': (0, 1), 'W': (-1, 0), 'E': (1, 0)}
for x in range(W):
    for y in range(H):
        v = plan[(x, y)]
        if v == 'v':
            continue
        adj = [d for d, (dx, dy) in DIRS.items()
               if not (0 <= x + dx < W and 0 <= y + dy < H)]
        adj += [d for d, (dx, dy) in DIRS.items()
                if 0 <= x + dx < W and 0 <= y + dy < H and plan[(x + dx, y + dy)] == 'v']
        if not adj:
            continue
        if v == 'c':
            bk = base_of(x, y)
        else:
            bk = v[1]
        nc = grid[x][y].get('NeighborCode', 0)
        grid[x][y] = cell(faded_key(bk, adj), nc=nc)

# ---------------------------------------------------------------- obstacles
orig_obst = g['obstacles']
obst = [[None] * (H * 3) for _ in range(W * 3)]

def set_obst(x, y, blocked):
    t = 1 if blocked else 0
    for cx in range(3):
        for cy in range(3):
            obst[x * 3 + cx][y * 3 + cy] = {
                "Bounds": {"X": (x * 3 + cx) * 8, "Y": (y * 3 + cy) * 8,
                            "Width": 8, "Height": 8}, "Tags": t}

for x in range(W):
    for y in range(H):
        v = plan[(x, y)]
        if v == 'c':
            for cx in range(3):
                for cy in range(3):
                    obst[x * 3 + cx][y * 3 + cy] = orig_obst[x * 3 + cx][y * 3 + cy]
        elif v == 'v':
            set_obst(x, y, True)
        else:
            set_obst(x, y, False)

# filets : aire d'atterrissage (marqueur (12,24)), axe du heros, son ancre
for yy in range(22, 25):
    for xx in range(7, 17):
        set_obst(xx, yy, False)
for yy in range(11, 19):
    set_obst(16, yy, False)
set_obst(16, 12, False)

print('frames ajoutees :', len(new_entries) - len(keys),
      '(vide +', len(cache), 'variantes fondues)')
write_tile_pkg(TILE, ts, new_entries)

s_doc = json.load(open(OUT_GROUND, encoding='utf-8-sig'))
s = s_doc['Object']
s['Layers'][0]['Tiles'] = grid
s['obstacles'] = obst
s['Comment'] = ('Songe du heros, nuit de la veillee au Mont Venteux : la Source '
                'du souvenir en jardins suspendus au coeur du reve — le vide '
                'laisse voir la parallaxe onirique (personality_test). Made by Mad')
raw = '﻿' + json.dumps(s_doc, ensure_ascii=False, indent=0)
open(OUT_GROUND, 'w', encoding='utf-8').write(raw)
print('ecrit', OUT_GROUND)