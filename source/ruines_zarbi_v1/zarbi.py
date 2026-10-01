"""Zarbi (Unown) calculés en pixel art — pas de sprites natifs.

Chaque glyphe est tracé à 4x (traits épais, arcs) sur une grille 18 x 18 mise à l'échelle, réduit en 24 x 24 par seuil, puis ombré : contour sombre, corps
noir bleuté, reflet haut-gauche, œil blanc à pupille. Lettres : Z A R B I ! ?  (le mot « ZARBI », plus ! et ?).
"""
import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as nd

SIZE = 24
UNIT = 18                   # les tracés sont écrits sur une grille 18 x 18, mis à l'échelle SIZE
UP = 4
OUTLINE, BODY, LIGHT, EYE_W, PUPIL = (20, 16, 30), (52, 50, 64), (104, 102, 122), (244, 244, 248), (16, 12, 22)
TONES = [OUTLINE, BODY, LIGHT, EYE_W, PUPIL]
LETTERS = ['Z', 'A', 'R', 'B', 'I', '!', '?']


def _strokes(letter):
    """Tracés en coordonnées 0-18 : ('l', x0, y0, x1, y1) segments, ('a', cx, cy, r, a0, a1) arcs, ('d', cx, cy, r) disques.
    eye : (cx, cy) centre de l'œil."""
    if letter == 'Z':
        return [('l', 3, 3.5, 15, 3.5), ('l', 15, 3.5, 3, 14.5), ('l', 3, 14.5, 15, 14.5)], (9, 9)
    if letter == 'A':
        return [('l', 9, 2, 2.5, 16), ('l', 9, 2, 15.5, 16), ('l', 5, 11.5, 13, 11.5)], (9, 8.6)
    if letter == 'R':
        return [('l', 4, 2.5, 4, 16), ('a', 8.5, 6.5, 4.3, -90, 90), ('l', 4, 2.5, 8.5, 2.5), ('l', 4, 10.8, 8.5, 10.8),
                ('l', 8, 10.8, 14.5, 16)], (8.6, 6.6)
    if letter == 'B':
        return [('l', 4, 2.5, 4, 15.5), ('a', 8.5, 6, 3.6, -90, 90), ('a', 8.8, 12, 3.6, -90, 90), ('l', 4, 2.5, 8.5, 2.5),
                ('l', 4, 9.3, 9, 9.3), ('l', 4, 15.5, 9, 15.5)], (8.3, 12)
    if letter == 'I':
        return [('l', 9, 2, 9, 16), ('l', 6, 2.5, 12, 2.5), ('l', 6, 15.5, 12, 15.5)], (9, 9)
    if letter == '!':
        return [('l', 9, 2, 9, 11), ('d', 9, 15, 2.2)], (9, 5.5)
    if letter == '?':
        return [('a', 9, 6.2, 5.2, 160, 420), ('l', 11.2, 10.8, 9, 12.2), ('d', 9, 16, 1.7)], (9, 6.2)
    raise KeyError(letter)


def glyph(letter):
    """(masque corps, image RGBA 18 x 18) d'un Zarbi."""
    strokes, (ex, ey) = _strokes(letter)
    k = SIZE / UNIT
    strokes = [(s[0],) + tuple(v * k if i < 3 or s[0] != 'a' else v for i, v in enumerate(s[1:])) for s in strokes]
    ex, ey = ex * k, ey * k
    im = Image.new('L', (SIZE * UP, SIZE * UP), 0); d = ImageDraw.Draw(im); w = int(2.6 * k * UP)
    for s in strokes:
        if s[0] == 'l':
            _, x0, y0, x1, y1 = s
            d.line([(x0 * UP, y0 * UP), (x1 * UP, y1 * UP)], fill=255, width=w)
            for x, y in ((x0, y0), (x1, y1)):
                d.ellipse([x * UP - w / 2, y * UP - w / 2, x * UP + w / 2, y * UP + w / 2], fill=255)
        elif s[0] == 'a':
            _, cx, cy, r, a0, a1 = s
            d.arc([(cx - r) * UP, (cy - r) * UP, (cx + r) * UP, (cy + r) * UP], a0, a1, fill=255, width=w)
        else:
            _, cx, cy, r = s
            d.ellipse([(cx - r) * UP, (cy - r) * UP, (cx + r) * UP, (cy + r) * UP], fill=255)
    er = {'?': 2.4, '!': 2.8}.get(letter, 3.3) * k                                                                  # œil : disque plein (le corps l'entoure)
    pad = (1.0 if letter == '?' else 1.2) * k
    d.ellipse([(ex - er - pad) * UP, (ey - er - pad) * UP, (ex + er + pad) * UP, (ey + er + pad) * UP], fill=255)
    m = np.array(im.resize((SIZE, SIZE), Image.BOX)) > 110
    yy, xx = np.mgrid[:SIZE, :SIZE]
    eye = np.hypot(xx + 0.5 - ex, yy + 0.5 - ey) <= er - 0.4
    px, py = int(round(ex)), int(round(ey - 0.5))                                 # pupille 2 x 2, regard vers la droite
    pupil = (xx >= px) & (xx <= px + (1 if er < 4 else 2)) & (yy >= py) & (yy <= py + 1 + (er >= 4))
    lvl = np.full((SIZE, SIZE), -1)
    lvl[m] = 1
    edge = m & ~nd.binary_erosion(m, border_value=0)
    lit = m & ~edge & np.roll(edge, 1, 0) | m & ~edge & np.roll(edge, 1, 1)       # reflet sous le bord haut-gauche
    lvl[lit] = 2
    lvl[edge] = 0
    lvl[eye] = 3; lvl[pupil] = 4
    ring = nd.binary_dilation(eye) & ~eye & m                                     # cerne sombre autour de l'œil
    lvl[ring] = 0
    rgba = np.zeros((SIZE, SIZE, 4), 'uint8')
    for k, c in enumerate(TONES):
        rgba[lvl == k, :3] = c; rgba[lvl == k, 3] = 255
    return m | eye, rgba


def scaled(rgba, f):
    """Réduction au plus proche (apparition hors de la faille)."""
    if f >= 1:
        return rgba
    n = max(2, int(round(SIZE * f)))
    return np.array(Image.fromarray(rgba).resize((n, n), Image.NEAREST))
