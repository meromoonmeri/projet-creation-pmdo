#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
make_chapter_bg.py
Genere un fond d'ecran-titre de chapitre au format attendu par le moteur.

DIRECTION ARTISTIQUE — constat, pas supposition.
Les fonds Chapter_1 a Chapter_4 ont ete extraits et observes : ce ne sont
PAS des illustrations peintes, ce sont des RENDUS DE MAP EN VUE DE DESSUS,
faits avec les tilesets du jeu, puis assombris. C'est exactement la DA
d'Explorateurs du Ciel : un paysage simple, lisible, en tuiles.
On reproduit donc ce procede au lieu de fabriquer une illustration qui
jurerait avec les quatre existantes.

FORMAT .dir (decode octet par octet sur les 4 fichiers existants) :
    uint32  little-endian : taille du PNG (sans le pied de page)
    uint32  little-endian : 0
    ...     le PNG brut, 320x240
    uint32 x4             : PIED DE PAGE = frameW, frameH, 0, frameCount
                            soit (320, 240, 0, 1) sur les 4 fichiers

Le pied de page est ce qui explique la relation hdr[0] == len(bloc) - 16 :
les 16 octets de queue ne sont pas comptes dans l'entete. Il decrit le
decoupage en frames de l'animation de fond ; un ecran-titre fixe vaut
donc (320, 240, 0, 1). Sans lui, verify_bg_format.py rend « illisible »
et le moteur ne saurait pas decouper l'image.

CALIBRAGE DE L'ASSOMBRISSEMENT — mesure sur les fonds existants :
    Chapter_1 luminance moyenne (41, 64, 44)
    Chapter_2                   (25, 64, 56)
    Chapter_3                   (82, 69, 49)
    Chapter_4                   (65, 73, 36)
Soit une plage de ~40 a ~75. Un rendu brut de map sort vers 90-120 : le
facteur est donc calcule pour retomber dans cette plage, et non fixe au
hasard.

Usage :
    python3 tools/make_chapter_bg.py <map_source> <Chapter_N> [--apply]
Sans --apply : ecrit un apercu dans /tmp, ne touche pas a Content/BG.
"""
import os
import struct
import sys

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from PIL import Image, ImageStat, ImageEnhance   # noqa: E402
import render_ground                              # noqa: E402

RACINE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

LARGEUR, HAUTEUR = 320, 240
# Cible de luminance moyenne, au centre de la plage des fonds existants.
CIBLE_LUMINANCE = 58.0


def cadrer(im):
    """Recadre au centre en 320x240 sans deformer.

    On prend la plus grande fenetre 4:3 possible puis on reduit : garder le
    ratio evite d'etirer les tuiles, ce qui se verrait immediatement.
    """
    im = im.convert('RGB')
    w, h = im.size
    ratio = LARGEUR / HAUTEUR
    if w / h > ratio:
        nw = int(h * ratio)
        box = ((w - nw) // 2, 0, (w - nw) // 2 + nw, h)
    else:
        nh = int(w / ratio)
        box = (0, (h - nh) // 2, w, (h - nh) // 2 + nh)
    return im.crop(box).resize((LARGEUR, HAUTEUR), Image.LANCZOS)


def assombrir(im):
    """Amene la luminance moyenne sur la cible mesuree."""
    moy = sum(ImageStat.Stat(im).mean) / 3.0
    if moy <= 0:
        return im
    facteur = min(1.0, CIBLE_LUMINANCE / moy)
    return ImageEnhance.Brightness(im).enhance(facteur)


def ecrire_dir(png_octets, chemin):
    """Enveloppe le PNG : entete + PNG + pied de page de decoupage."""
    pied = struct.pack('<4I', LARGEUR, HAUTEUR, 0, 1)   # une seule frame
    with open(chemin, 'wb') as f:
        f.write(struct.pack('<II', len(png_octets), 0))
        f.write(png_octets)
        f.write(pied)


def main():
    if len(sys.argv) < 3:
        print(__doc__)
        return 1
    source, cible = sys.argv[1], sys.argv[2]
    apply_ = '--apply' in sys.argv

    brut = '/tmp/_bg_src.png'
    render_ground.render(source, None, brut)

    im = assombrir(cadrer(Image.open(brut)))
    apercu = '/tmp/%s.png' % cible
    im.save(apercu)

    moy = [round(x) for x in ImageStat.Stat(im).mean]
    print('source      : %s' % source)
    print('apercu      : %s  (%dx%d)' % (apercu, im.size[0], im.size[1]))
    print('luminance   : %s   (fonds existants : 40 a 75)' % moy)

    if apply_:
        octets = open(apercu, 'rb').read()
        dest = os.path.join(RACINE, 'Content/BG/%s.dir' % cible)
        ecrire_dir(octets, dest)
        print('ecrit       : Content/BG/%s.dir (%d octets)'
              % (cible, os.path.getsize(dest)))
    else:
        print('SIMULATION — relancer avec --apply pour ecrire dans Content/BG.')
    return 0


if __name__ == '__main__':
    sys.exit(main())
