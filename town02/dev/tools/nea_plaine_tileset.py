#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Construit un tileset pixel-art « plaine » + compose l'entrée de donjon.

Produit une planche PNG (tuiles 24 px, style PMD2 Explorateurs) puis une
image de carte composée par répétition de ces tuiles (redondance saine),
prête à passer dans tools/png2tileset.py ground pour générer le .tile
et le .rsground réel.

  python3 tools/nea_plaine_tileset.py
  -> Content/Tile/NeaPlaineEntree_Base.png      (la planche, pour référence)
  -> /tmp/plaine_entrance_map.png               (la carte composée)
"""
import os
from PIL import Image

T = 24  # taille de tuile
OUT_TILESET = os.path.join('Content', 'Tile', 'NeaPlaineEntree_Base.png')
OUT_MAP = '/tmp/plaine_entrance_map.png'

# ------------------------------------------------------------------ palette
GRASS = [(110, 150, 72), (100, 140, 66), (118, 158, 76)]     # 3 variantes
DIRT  = [(196, 156, 96), (186, 146, 86), (206, 166, 106)]
EDGE  = [(150, 110, 60)]                                      # lisière terre
ROCK  = [(132, 132, 140), (108, 108, 116), (152, 152, 160)]
FLOWER = [(255, 250, 210), (235, 220, 160), (240, 240, 200)]
DARK  = (40, 40, 52)                                          # ouverture caverne
WALL  = [(88, 84, 96), (74, 70, 82)]                          # paroi rocheuse

import random
random.seed(7)


def new():
    return Image.new('RGBA', (T, T), (0, 0, 0, 0))


def px(im, x, y, c, a=255):
    im.putpixel((x, y), (c[0], c[1], c[2], a))


def speckle(im, cols, n=30, rng=(0, T), area=None):
    x0, x1 = area or (0, T)
    for _ in range(n):
        x, y = random.randint(x0, x1 - 1), random.randint(0, T - 1)
        px(im, x, y, random.choice(cols))


def grass(variant):
    im = new()
    for y in range(T):
        for x in range(T):
            c = GRASS[variant]
            px(im, x, y, c)
    # petites variations de ton -> rythme de sol lisible
    speckle(im, [GRASS[(variant + 1) % 3], GRASS[(variant + 2) % 3]], 26)
    speckle(im, [DIRT[1]], 4)  # brin de terre épars
    return im


def dirt(variant):
    im = new()
    for y in range(T):
        for x in range(T):
            px(im, x, y, DIRT[variant])
    speckle(im, [DIRT[(variant + 1) % 3], DIRT[(variant + 2) % 3]], 30)
    speckle(im, [EDGE[0]], 6)
    return im


def edge(side):
    """Lisière herbe/terre : side in N,S,E,W (terre au centre, herbe dehors)."""
    im = new()
    base = grass(0)
    im.paste(base, (0, 0))
    # peindre la moitié terre avec bord irrégulier
    if side == 'N':   # terre en bas, herbe en haut
        yy = range(11, T)
    elif side == 'S':
        yy = range(0, 13)
    elif side == 'E':
        pass
    elif side == 'W':
        pass
    for y in range(T):
        for x in range(T):
            inside = False
            if side == 'N':
                inside = y >= 11 + (x % 3)
            elif side == 'S':
                inside = y < 13 - (x % 3)
            elif side == 'E':
                inside = x >= 12 + (y % 3)
            elif side == 'W':
                inside = x < 12 - (y % 3)
            if inside:
                px(im, x, y, DIRT[0])
    speckle(im, [DIRT[1], DIRT[2]], 24)
    return im


def corner(nsew):
    """Coin herbe/terre : nsew = combinaison de lisières, ex 'NE'."""
    im = new()
    im.paste(grass(0), (0, 0))
    gx, gy = (0, 0)  # coin d'herbe
    for y in range(T):
        for x in range(T):
            # zone terre : plus loin du coin herbe
            d = (x - gx) if 'E' in nsew else (T - 1 - x - gx)
            dy = (y - gy) if 'S' in nsew else (T - 1 - y - gy)
            inside = (d >= 11 - 3 and dy >= 11 - 3)
            if inside:
                px(im, x, y, DIRT[0])
    speckle(im, [DIRT[1], DIRT[2]], 18)
    return im


def rock():
    im = new()
    im.paste(grass(1), (0, 0))
    for y in range(T):
        for x in range(T):
            if x in range(2, 21) and y in range(4, 22):
                px(im, x, y, ROCK[0])
    # ombrage / relief
    for x in range(2, 21):
        px(im, x, 21, ROCK[1])
    for y in range(4, 22):
        px(im, 20, y, ROCK[1])
    for x in range(5, 18):
        px(im, x, 6, ROCK[2])
    px(im, 10, 12, ROCK[2]); px(im, 12, 12, ROCK[2])
    return im


def flowers():
    im = grass(2)
    for cx, cy in [(6, 6), (16, 12), (10, 18)]:
        px(im, cx, cy, FLOWER[0]); px(im, cx + 1, cy, FLOWER[0])
        px(im, cx, cy + 1, FLOWER[0]); px(im, cx + 1, cy + 1, FLOWER[0])
        px(im, cx, cy - 1, FLOWER[2])
    return im


def tuft():
    im = grass(1)
    for cx, cy in [(7, 18), (8, 17), (9, 18), (8, 19), (15, 6), (16, 5)]:
        px(im, cx, cy, (70, 110, 44))
    return im


def cave_open():
    """Ouverture de caverne : sol sombre + arc rocheux."""
    im = new()
    im.paste(dirt(1), (0, 0))
    # fond sombre au centre
    for y in range(T):
        for x in range(T):
            if 3 <= x <= 20 and 4 <= y <= T - 1:
                px(im, x, y, DARK)
    # voûte rocheuse
    for x in range(0, 3):
        for y in range(T):
            px(im, x, y, WALL[0])
    for x in range(21, T):
        for y in range(T):
            px(im, x, y, WALL[0])
    for x in range(3, 21):
        for y in range(0, 5):
            px(im, x, y, WALL[1])
    speckle(im, [WALL[0], WALL[1]], 20, area=(0, T))
    return im


def cave_wall():
    """Paroi rocheuse pleine (côtés de l'entrée)."""
    im = new()
    for y in range(T):
        for x in range(T):
            px(im, x, y, WALL[0] if (x // 4 + y // 4) % 2 == 0 else WALL[1])
    speckle(im, [WALL[0], WALL[1], (60, 58, 70)], 40)
    return im


# ------------------------------------------------------ assemblage planche
TILES = {}
# rangée 0 : sols (herbe x3, terre x3)
TILES[0] = grass(0); TILES[1] = grass(1); TILES[2] = grass(2)
TILES[3] = dirt(0); TILES[4] = dirt(1); TILES[5] = dirt(2)
# rangée 1 : lisières herbe/terre
TILES[6] = edge('N'); TILES[7] = edge('S')
TILES[8] = edge('W'); TILES[9] = edge('E')
TILES[10] = corner('SE'); TILES[11] = corner('SW')
TILES[12] = corner('NE'); TILES[13] = corner('NW')
# rangée 2 : décor + caverne
TILES[14] = rock(); TILES[15] = flowers(); TILES[16] = tuft()
TILES[17] = cave_open(); TILES[18] = cave_wall()
TILES[19] = new()  # vide / trou (non marchable, affiché noir)

COLS = 10
ROWS = 2
sheet = Image.new('RGBA', (COLS * T, ROWS * T), (0, 0, 0, 0))
for i, im in TILES.items():
    sheet.paste(im, ((i % COLS) * T, (i // COLS) * T))
os.makedirs(os.path.dirname(OUT_TILESET), exist_ok=True)
sheet.save(OUT_TILESET)
print('planche:', OUT_TILESET, sheet.size)

# ------------------------------------------------------- composition carte
# Carte 26 x 20 tuiles (624 x 480 px, > 320x240 requis). Un chemin de terre
# monte de l'entrée (bas) vers une caverne (haut), bordé de rochers.
W, H = 26, 20
grid = [[None] * H for _ in range(W)]


def put(x, y, t):
    if 0 <= x < W and 0 <= y < H:
        grid[x][y] = t


# 1) herbe partout
for x in range(W):
    for y in range(H):
        put(x, y, (x + y) % 3)   # 0..2 variantes d'herbe

# 2) caverne : ouverture au centre-haut, parois de chaque côté
cavx0, cavx1 = 11, 14          # ouverture en colonnes 11..13
for x in range(W):
    if x >= cavx0 - 1 and x <= cavx1 + 1:
        put(x, 0, 18)          # linteau paroi au-dessus
    else:
        put(x, 0, 18)
for x in range(cavx0, cavx1 + 1):
    put(x, 0, 18)              # arc (on ouvre sur y>=1)
for x in range(cavx0 - 2, cavx1 + 3):
    for y in range(1, 3):
        put(x, y, 18 if (x < cavx0 or x > cavx1) else 17)
# ouverture réelle : colonnes cavx0..cavx1, y=1..2 en cave_open déjà posé
for x in range(cavx0, cavx1 + 1):
    for y in range(1, 4):
        put(x, y, 17)          # sol sombre dans la caverne

# 3) chemin de terre depuis le bas jusqu'à la caverne (largeur 4-5)
path_x0 = 10
for y in range(3, H):
    w = 5 if y < 8 else 4
    for x in range(path_x0, path_x0 + w):
        put(x, y, 4)           # terre variant
# variation de ton
for y in range(3, H):
    for x in range(path_x0, path_x0 + 5):
        if grid[x][y] == 4 and (x * 7 + y * 13) % 9 == 0:
            put(x, y, 5)

# 4) lisières herbe/terre autour du chemin
for y in range(3, H):
    lx = path_x0 - 1
    rx = path_x0 + (5 if y < 8 else 4)
    put(lx, y, 8)              # edge W
    put(rx, y, 9)              # edge E
# lisière entre le sol sombre de la caverne et l'herbe (bas de caverne)
for x in range(cavx0 - 2, cavx1 + 3):
    put(x, 3, 7)               # edge S (herbe en bas, terre en haut)

# 5) coins herbe/terre
put(path_x0 - 1, 3, 11)        # SW corner
put(path_x0 + 5, 3, 10)        # SE corner (approx)

# 6) décor : rochers et fleurs épars
deco = [14, 15, 16]
placed = set()
for _ in range(22):
    x, y = random.randint(1, W - 2), random.randint(4, H - 2)
    if (x, y) in placed or path_x0 - 1 <= x <= path_x0 + 5:
        continue
    placed.add((x, y))
    put(x, y, random.choice(deco))

# 7) bordure infranchissable (rochers) sur les bords, pour rester en carte
for x in range(W):
    put(x, 0, 18); put(x, H - 1, 18)
for y in range(H):
    put(0, y, 18); put(W - 1, y, 18)

# assemble l'image
img = Image.new('RGBA', (W * T, H * T), (0, 0, 0, 0))
for x in range(W):
    for y in range(H):
        t = grid[x][y]
        if t is not None:
            img.paste(TILES[t], (x * T, y * T))
img.save(OUT_MAP)
print('carte:', OUT_MAP, img.size, f'({W}x{H} tuiles)')


# ------------------------------------------------- export marchabilite
# Verite terrain : quelles tuiles sont marchables (sol) vs bloquantes.
WALKABLE = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15, 16, 17}
# 17 (cave_open) marchable pour que le joueur atteigne la bouche du donjon
import json
walk = [[int(grid[x][y] in WALKABLE) for y in range(H)] for x in range(W)]
json.dump({'grid': [[grid[x][y] for y in range(H)] for x in range(W)],
           'walkable': walk, 'W': W, 'H': H},
          open('/tmp/plaine_grid.json', 'w'))
print('grille de marchabilite exportee -> /tmp/plaine_grid.json')
