#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
gen_season_particles.py — genere les feuilles de particules saisonnieres
=======================================================================
POURQUOI CES TEXTURES SONT ORIGINALES
-----------------------------------------------------------------------
Les sprites de Pokemon Noir/Blanc 2 appartiennent a Nintendo/Game Freak.
Les reproduire dans un mod distribue exposerait le projet. Ce script
DESSINE donc des particules originales, inspirees du principe (petale,
feuille, flocon) sans copier aucun pixel d'origine.

FORMAT .dir — DECODE ET VERIFIE DANS CE DEPOT
-----------------------------------------------------------------------
Releve sur Content/Particle/Ash_Fall.dir (relecture octet par octet) :

    [uint32 taillePNG][uint32 padding=0][PNG][frameW][frameH][LocHeight][frameCount]

    Les 4 derniers champs sont des uint32 little-endian.
    Ash_Fall : PNG de 192x16, frameW=16, frameH=16, LocHeight=0, 12 frames.

Les frames sont posees HORIZONTALEMENT : la feuille fait
(frameW * frameCount) x frameH.

CONVENTION ScreenRainEmitter (relevee sur falling_ash.json)
-----------------------------------------------------------------------
L'emetteur lit DEUX plages dans la MEME feuille :
    Anim       StartFrame..EndFrame  -> la chute (boucle)
    ResultAnim StartFrame..EndFrame  -> l'impact au sol (une fois)

On garde donc la meme structure : 8 frames de chute + 4 d'impact = 12.
"""
import io
import math
import os
import struct

from PIL import Image, ImageDraw

FRAME = 16          # cote d'une frame, en pixels (comme Ash_Fall)
N_FALL = 8          # frames de chute
N_LAND = 4          # frames d'impact
N_TOTAL = N_FALL + N_LAND


def new_frame():
    return Image.new('RGBA', (FRAME, FRAME), (0, 0, 0, 0))


# ---------------------------------------------------------------------
# PRINTEMPS — petale de sakura
# ---------------------------------------------------------------------
# Le petale TOURNE sur lui-meme pendant sa chute : on simule la rotation
# en faisant varier sa largeur (vu de face -> vu de profil -> de face).
# C'est le truc classique de la 5G, et ca coute 8 frames.
def sakura_frames():
    frames = []
    for i in range(N_FALL):
        img = new_frame()
        d = ImageDraw.Draw(img)
        phase = i / N_FALL * 2 * math.pi
        w = 1.0 + 3.0 * abs(math.cos(phase))      # 1 px de profil, 4 de face
        cx, cy = 8, 8
        # corps du petale
        d.ellipse([cx - w, cy - 3, cx + w, cy + 3], fill=(255, 183, 213, 235))
        # coeur plus clair, donne du volume
        if w > 2:
            d.ellipse([cx - w + 1, cy - 2, cx + w - 1, cy + 1], fill=(255, 214, 232, 245))
        # echancrure du sakura : deux pointes en bas
        if w >= 3:
            d.point((int(cx), cy + 3), fill=(0, 0, 0, 0))
        frames.append(img)

    # impact : le petale se pose et s'efface
    for i in range(N_LAND):
        img = new_frame()
        d = ImageDraw.Draw(img)
        a = int(220 * (1 - i / N_LAND))
        spread = 3 + i
        d.ellipse([8 - spread, 10, 8 + spread, 12], fill=(255, 199, 222, a))
        frames.append(img)
    return frames


# ---------------------------------------------------------------------
# AUTOMNE — feuille rousse
# ---------------------------------------------------------------------
# La feuille est plus grande et bascule franchement : elle montre son
# recto puis son verso (teinte plus sombre). C'est ce basculement qui
# donne l'oscillation gauche-droite caracteristique.
def leaf_frames():
    RECTO = (214, 116, 46, 240)
    VERSO = (156, 74, 30, 240)
    NERV = (120, 58, 24, 200)
    frames = []
    for i in range(N_FALL):
        img = new_frame()
        d = ImageDraw.Draw(img)
        phase = i / N_FALL * 2 * math.pi
        c = math.cos(phase)
        w = max(1.0, 4.5 * abs(c))
        col = RECTO if c >= 0 else VERSO
        cx, cy = 8, 8
        d.polygon([(cx, cy - 5), (cx + w, cy), (cx, cy + 5), (cx - w, cy)], fill=col)
        if w >= 3:
            d.line([(cx, cy - 4), (cx, cy + 4)], fill=NERV)     # nervure centrale
            d.line([(cx, cy), (cx + w - 1, cy - 2)], fill=NERV)
            d.line([(cx, cy), (cx - w + 1, cy - 2)], fill=NERV)
        frames.append(img)

    # impact : la feuille glisse au sol
    for i in range(N_LAND):
        img = new_frame()
        d = ImageDraw.Draw(img)
        a = int(230 * (1 - i / N_LAND))
        w = 4 + i
        d.polygon([(8, 11), (8 + w, 12), (8, 13), (8 - w, 12)],
                  fill=(196, 104, 40, a))
        frames.append(img)
    return frames


# ---------------------------------------------------------------------
# HIVER — flocon
# ---------------------------------------------------------------------
# Le flocon SCINTILLE au lieu de tourner : sa taille pulse legerement.
# Il tombe droit, donc pas besoin de simuler une rotation.
def snow_frames():
    frames = []
    for i in range(N_FALL):
        img = new_frame()
        d = ImageDraw.Draw(img)
        phase = i / N_FALL * 2 * math.pi
        r = 2.0 + 0.9 * math.sin(phase)
        cx, cy = 8, 8
        d.ellipse([cx - r, cy - r, cx + r, cy + r], fill=(255, 255, 255, 240))
        # halo : rend le flocon lisible sur un fond clair
        d.ellipse([cx - r - 1, cy - r - 1, cx + r + 1, cy + r + 1],
                  outline=(214, 236, 255, 120))
        # branches, seulement quand le flocon est au plus large
        if r > 2.5:
            d.point((cx, int(cy - r - 1)), fill=(255, 255, 255, 200))
            d.point((cx, int(cy + r + 1)), fill=(255, 255, 255, 200))
            d.point((int(cx - r - 1), cy), fill=(255, 255, 255, 200))
            d.point((int(cx + r + 1), cy), fill=(255, 255, 255, 200))
        frames.append(img)

    # impact : le flocon s'ecrase en petit tas
    for i in range(N_LAND):
        img = new_frame()
        d = ImageDraw.Draw(img)
        a = int(235 * (1 - i / N_LAND))
        w = 2 + i
        d.ellipse([8 - w, 11, 8 + w, 13], fill=(245, 250, 255, a))
        frames.append(img)
    return frames


# ---------------------------------------------------------------------
# ECRITURE DU .dir
# ---------------------------------------------------------------------
def write_dir(path, frames, loc_height=0):
    sheet = Image.new('RGBA', (FRAME * len(frames), FRAME), (0, 0, 0, 0))
    for i, f in enumerate(frames):
        sheet.paste(f, (i * FRAME, 0))

    buf = io.BytesIO()
    sheet.save(buf, format='PNG', optimize=True)
    png = buf.getvalue()

    with open(path, 'wb') as fh:
        fh.write(struct.pack('<I', len(png)))   # taille du PNG
        fh.write(struct.pack('<I', 0))          # padding
        fh.write(png)
        fh.write(struct.pack('<I', FRAME))      # frameW
        fh.write(struct.pack('<I', FRAME))      # frameH
        fh.write(struct.pack('<I', loc_height))  # LocHeight
        fh.write(struct.pack('<I', len(frames)))  # frameCount
    return len(png), sheet.size


def verify(path):
    """Relit le fichier et confirme qu'il se decode comme Ash_Fall."""
    b = open(path, 'rb').read()
    n = struct.unpack('<I', b[0:4])[0]
    png = b[8:8 + n]
    tail = struct.unpack('<4I', b[8 + n:])
    im = Image.open(io.BytesIO(png))
    ok = (png[:8] == b'\x89PNG\r\n\x1a\n'
          and tail[0] == FRAME and tail[1] == FRAME
          and im.size == (FRAME * tail[3], FRAME))
    return ok, im.size, tail


if __name__ == '__main__':
    out = 'Content/Particle'
    os.makedirs(out, exist_ok=True)
    jobs = [
        ('Sakura_Fall.dir', sakura_frames()),
        ('Leaf_Fall.dir', leaf_frames()),
        ('Snow_Fall.dir', snow_frames()),
    ]
    for name, frames in jobs:
        p = os.path.join(out, name)
        size, dims = write_dir(p, frames)
        ok, imsize, tail = verify(p)
        state = 'OK ' if ok else 'KO '
        print(f"{state}{name:18s} PNG={size:5d}o  feuille={imsize}  "
              f"frameW/H={tail[0]}/{tail[1]} LocHeight={tail[2]} frames={tail[3]}")
