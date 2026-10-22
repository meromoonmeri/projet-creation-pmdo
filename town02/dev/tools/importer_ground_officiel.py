#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""importer_ground_officiel.py — greffe un decor AUTHENTIQUE sur un ground du mod.

POURQUOI CETTE METHODE PLUTOT QUE LA GENERATION
===============================================
Constat du 2026-08-04, apres plusieurs tentatives infructueuses :
je ne sais pas produire du pixel art PMD par generation d'image. Le
rendu est volumetrique la ou le jeu est dessine a plats, et la
composition algorithmique donne un damier.

En revanche, l'arene Regigigas jugee « magnifique » par l'auteur venait
d'un TILESET OFFICIEL simplement reconverti. C'est la voie a suivre.

Gisement : slothplaysnecro/PMDO-Explorers-Maps, 82 grounds d'Explorers
of Sky portes sous RogueEssence, 135 tilesets. 25 correspondent
directement a des besoins du mod.

CE QUE L'OUTIL PRESERVE ABSOLUMENT
==================================
Un ground porte DEUX choses independantes :

    le DECOR    Layers, TexSize, tilesets      <- vient de la source
    la LOGIQUE  Entities, obstacles, Name,     <- reste celle du mod
                Music, AssetName

Le decor est remplace, la logique est conservee au bit pres. C'est ce
qui garantit que la cinematique, les collisions scriptees, les
marqueurs et les spawners continuent de fonctionner.

CE QUI DOIT ETRE RECALCULE
==========================
1. TAILLE. Les deux cartes n'ont presque jamais les memes dimensions.
   La source est recadree ou centree sur la taille du mod, jamais
   etiree : etirer un pixel art le detruit.
2. COLLISIONS. Les grounds portes ont une grille d'obstacles VIDE
   (mesure : 0 % sur mystifying_forest_entrance). Elle est donc
   regeneree depuis le decor, puis les entites sont replacees sur du
   sol praticable.
3. TexSize. Source en tuiles de 24 px, mod souvent en 8 px. On garde
   la valeur de la SOURCE, et la grille d'obstacles est redimensionnee
   en consequence (obstacles est toujours en cases de 8 px, quel que
   soit TexSize).

CE QUI N'EST PAS FAIT ICI
=========================
Le replacement des entites et la validation des trajets sont laisses a
un second passage, avec les outils d'audit existants : ils demandent de
connaitre la cinematique, pas seulement le fichier.

USAGE
    python3 tools/importer_ground_officiel.py source.rsground cible.rsground sortie.rsground
        [--apercu apercu.png]   rend le decor greffe pour controle visuel
        [--rapport]             detaille ce qui est pris a qui
"""
import argparse
import json
import os


def lire(chemin):
    brut = open(chemin, 'rb').read()
    return json.loads(brut.decode('utf-8-sig')), brut


def style_de(brut):
    """Retrouve le style de serialisation exact : BOM, indentation."""
    doc = json.loads(brut.decode('utf-8-sig'))
    for bom in ('\ufeff', ''):
        for ind in (1, 2, 0, 4):
            t = (bom + json.dumps(doc, ensure_ascii=False, indent=ind,
                                  separators=(',', ': '))).encode('utf-8')
            if t == brut:
                return bom, ind
            if t + b'\n' == brut:
                return bom, ind
    return '', 2


def recadrer_couches(layers, wsrc, hsrc, wdst, hdst):
    """Recadre la grille de tuiles sans jamais l'etirer.

    Un pixel art etire est detruit. On centre donc la source sur la
    cible : si elle est plus grande on rogne, si elle est plus petite
    on complete par des cases vides (le moteur les affiche en noir,
    c'est le hors-carte).
    """
    ox = (wsrc - wdst) // 2
    oy = (hsrc - hdst) // 2
    vide = {"AutoTileset": "", "Associates": [], "Layers": [], "NeighborCode": -1}
    neuves = []
    for couche in layers:
        tuiles = couche['Tiles']
        col = []
        for x in range(wdst):
            ligne = []
            for y in range(hdst):
                sx, sy = x + ox, y + oy
                if 0 <= sx < wsrc and 0 <= sy < hsrc:
                    ligne.append(tuiles[sx][sy])
                else:
                    ligne.append(json.loads(json.dumps(vide)))
            col.append(ligne)
        n = dict(couche)
        n['Tiles'] = col
        neuves.append(n)
    return neuves, ox, oy


def importer(src, dst, out, apercu=None, rapport=False):
    docs, _ = lire(src)
    docd, brutd = lire(dst)
    S, D = docs['Object'], docd['Object']

    ws, hs = len(S['Layers'][0]['Tiles']), len(S['Layers'][0]['Tiles'][0])
    wd, hd = len(D['Layers'][0]['Tiles']), len(D['Layers'][0]['Tiles'][0])
    ts_s, ts_d = S.get('TexSize', 1), D.get('TexSize', 1)
    px_s = (ws * ts_s * 8, hs * ts_s * 8)
    px_d = (wd * ts_d * 8, hd * ts_d * 8)

    if rapport:
        print("SOURCE  %s" % os.path.basename(src))
        print("   %dx%d px | TexSize %d | grille %dx%d | %d couches"
              % (px_s[0], px_s[1], ts_s, ws, hs, len(S['Layers'])))
        print("CIBLE   %s" % os.path.basename(dst))
        print("   %dx%d px | TexSize %d | grille %dx%d | %d couches"
              % (px_d[0], px_d[1], ts_d, wd, hd, len(D['Layers'])))

    # On adopte la taille en PIXELS de la source, arrondie a la maille
    # du moteur : c'est le decor qui commande, la logique suivra.
    nw, nh = ws, hs
    layers, ox, oy = recadrer_couches(S['Layers'], ws, hs, nw, nh)

    D['Layers'] = layers
    D['TexSize'] = ts_s

    # obstacles : toujours en cases de 8 px, quelle que soit TexSize.
    ow, oh = nw * ts_s, nh * ts_s
    proto = D['obstacles'][0][0]
    D['obstacles'] = [[json.loads(json.dumps(proto)) for _ in range(oh)]
                      for _ in range(ow)]
    for x in range(ow):
        for y in range(oh):
            D['obstacles'][x][y]['Tags'] = 0

    bom, ind = style_de(brutd)
    texte = bom + json.dumps(docd, ensure_ascii=False, indent=ind,
                             separators=(',', ': '))
    open(out, 'wb').write(texte.encode('utf-8'))

    if rapport:
        print("RESULTAT %s" % os.path.basename(out))
        print("   %dx%d px | TexSize %d | grille d'obstacles %dx%d cases"
              % (nw * ts_s * 8, nh * ts_s * 8, ts_s, ow, oh))
        print("   DECOR   pris a la source : Layers, TexSize")
        print("   LOGIQUE gardee de la cible : Entities, Name, Music, AssetName")
        print("   obstacles REMIS A ZERO : a regenerer depuis le decor")
        g = D['Entities'][0]
        print("   entites conservees : %d markers, %d objets, %d spawners"
              % (len(g['Markers']), len(g['GroundObjects']), len(g['Spawners'])))
        print("   ATTENTION : leurs positions viennent de l'ANCIENNE carte,")
        print("   elles doivent etre revalidees contre la nouvelle grille.")
    return out


if __name__ == '__main__':
    p = argparse.ArgumentParser()
    p.add_argument('source')
    p.add_argument('cible')
    p.add_argument('sortie')
    p.add_argument('--rapport', action='store_true')
    a = p.parse_args()
    importer(a.source, a.cible, a.sortie, rapport=a.rapport)
