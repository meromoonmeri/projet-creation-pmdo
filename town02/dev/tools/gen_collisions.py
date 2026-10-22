#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Reconstruit la grille d'obstacles d'un ground A PARTIR DE SON PROPRE DECOR.

Le probleme
-----------
Un .rsground porte deux grilles independantes :

  Layers[i].Tiles[x][y]   grille graphique, maille pitch = 8 * TexSize
  obstacles[x][y].Tags    grille de collision, maille 8 px fixe

  (GroundMap.cs:49 lit Width sur Layers[0].Tiles ; GroundMap.cs:287
   dimensionne obstacles en width*TexSize.)

Rien dans le moteur ne les synchronise. Un decor importe en tuiles sans
grille en face donne une carte ou l'on traverse les falaises : le relief
est dessine mais n'existe pas pour la physique. 63 grounds du depot sont
dans cet etat, dont 15 arenes de boss.

La methode
----------
On ne devine pas : on REGARDE le decor tel que le moteur l'affiche.
1. On rend le ground en PNG (memes tuiles, meme assemblage que le jeu).
2. On classe les pixels avec `png2tileset.collisions`, qui choisit tout
   seul entre analyse de teinte (decor colore) et seuil d'Otsu
   (decor gris).
3. On agrege en cellules de 8 px — exactement la maille du moteur.

Garde-fous refusant l'ecriture
------------------------------
- moins de 20 % de sol praticable : la carte deviendrait injouable ;
- une entite existante se retrouverait muree ;
- le marqueur d'entree serait coupe du reste de la carte.

Un mauvais jeu de collisions est PIRE qu'une grille vide : la grille vide
laisse au moins passer. On preferera donc ne rien ecrire.
"""
import json
import pathlib
import sys
from collections import deque

sys.path.insert(0, str(pathlib.Path(__file__).parent))
import png2tileset as P
from render_ground import render, load_map
from audit_spatial import cases_couvertes, TEX, CLES_ENTITES, NOMS_ENTREE

from PIL import Image


def rendu(nom, cache='/tmp/gencol'):
    pathlib.Path(cache).mkdir(parents=True, exist_ok=True)
    out = f'{cache}/{nom}.png'
    if not pathlib.Path(out).exists():
        render(nom, None, out)
    return Image.open(out).convert('RGB')


def entites_de(obj):
    for couche in obj.get('Entities', []):
        for cle in CLES_ENTITES:
            for e in couche.get(cle, []) or []:
                c = e.get('Collider') or {}
                yield (cle, e.get('EntName', '?'), c.get('X', 0), c.get('Y', 0),
                       c.get('Width', TEX), c.get('Height', TEX))


def accessible(bloque, W, H, depart):
    vus = [[False] * H for _ in range(W)]
    q = deque([depart])
    vus[depart[0]][depart[1]] = True
    n = 1
    while q:
        cx, cy = q.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = cx + dx, cy + dy
            if 0 <= nx < W and 0 <= ny < H and not bloque[nx][ny] and not vus[nx][ny]:
                vus[nx][ny] = True
                n += 1
                q.append((nx, ny))
    return vus, n


def traiter(nom, appliquer=False, seuil=0.45, amas=3, mini=0.20, mode='auto', min_couv=0.60):
    chemin = pathlib.Path('Data/Ground') / (nom + '.rsground')
    octets = chemin.read_bytes()
    doc = json.loads(octets.decode('utf-8-sig'))
    obj = doc['Object']

    obs = obj['obstacles']
    W, H = len(obs), len(obs[0])
    deja = sum(1 for x in range(W) for y in range(H) if obs[x][y]['Tags'])

    img = rendu(nom)
    if img.size != (W * TEX, H * TEX):
        return (nom, 'REFUS', f"rendu {img.size} != grille {(W*TEX, H*TEX)}")

    # bloque_yx est indexe [y][x] cote png2tileset.
    # `nuage` sert, lors d'une conversion depuis un PNG source, a marquer
    # les blocs de ciel reperes a la main. Ici on repart du rendu du jeu :
    # il n'y a pas de ciel a exclure, on passe donc un masque vide plutot
    # que None (le `vide |= nuage` interne exige un tableau booleen).
    import numpy as np
    vide_nuage = np.zeros((img.size[1], img.size[0]), dtype=bool)
    bloque_yx, stats = P.collisions(img, vide_nuage, TEX, seuil=seuil,
                                    amas=amas, verbeux=False, mode=mode)
    bloque = [[bool(bloque_yx[y][x]) for y in range(H)] for x in range(W)]

    murs = sum(1 for x in range(W) for y in range(H) if bloque[x][y])
    libre = W * H - murs
    pct = libre / (W * H)
    if pct < mini:
        return (nom, 'REFUS', f"seulement {100*pct:.0f} % praticable")

    ents = list(entites_de(obj))

    # Garde-fou 1 : aucune entite personnage/marqueur ne doit finir muree.
    # Les GroundObjects sont exclus : un arbre EST le mur.
    mures = []
    for cat, en, x, y, w, h in ents:
        if cat == 'GroundObjects':
            continue
        cs = list(cases_couvertes(x, y, w, h, W, H))
        if cs and all(bloque[a][b] for a, b in cs):
            mures.append(en)
    if mures:
        return (nom, 'REFUS', f"murerait {len(mures)} entite(s) : "
                              f"{', '.join(mures[:4])}")

    # Garde-fou 2 : le point d'arrivee doit desservir l'essentiel de la carte.
    depart = None
    for cat, en, x, y, w, h in ents:
        if en in NOMS_ENTREE:
            for a, b in cases_couvertes(x, y, w, h, W, H):
                if not bloque[a][b]:
                    depart = (a, b)
                    break
        if depart:
            break
    couv = None
    if depart:
        vus, n = accessible(bloque, W, H, depart)
        couv = n / libre if libre else 0
        if couv < min_couv:
            return (nom, 'REFUS',
                    f"depuis l'entree, {100*couv:.0f} % du sol seulement")
        # les entites doivent etre atteignables
        perdues = []
        for cat, en, x, y, w, h in ents:
            if cat == 'GroundObjects':
                continue
            cs = [(a, b) for a, b in cases_couvertes(x, y, w, h, W, H)
                  if not bloque[a][b]]
            if cs and not any(vus[a][b] for a, b in cs):
                perdues.append(en)
        if perdues:
            return (nom, 'REFUS', f"isolerait {len(perdues)} entite(s) : "
                                  f"{', '.join(perdues[:4])}")

    detail = (f"{100*pct:.0f} % praticable, {murs} murs"
              + (f", couverture {100*couv:.0f} %" if couv is not None else "")
              + (f" (avait {deja} murs)" if deja else ""))

    if appliquer:
        for x in range(W):
            for y in range(H):
                obs[x][y]['Tags'] = 1 if bloque[x][y] else 0
        # on rend au fichier son style d'origine (cf. tools/fix_spatial.py)
        avant = json.loads(octets.decode('utf-8-sig'))
        ind = None
        for cand in (1, 0, 2, 4):
            t = '\ufeff' + json.dumps(avant, ensure_ascii=False, indent=cand,
                                      separators=(',', ': '))
            if t.encode('utf-8') == octets:
                ind = cand
                break
        if ind is None:
            return (nom, 'REFUS', 'style de serialisation non reproductible')
        chemin.write_bytes(('\ufeff' + json.dumps(
            doc, ensure_ascii=False, indent=ind,
            separators=(',', ': '))).encode('utf-8'))
    return (nom, 'OK', detail)


def main():
    appliquer = '--appliquer' in sys.argv
    
    # Parse mode
    mode = 'auto'
    if '--mode' in sys.argv:
        idx = sys.argv.index('--mode')
        if idx + 1 < len(sys.argv):
            mode = sys.argv[idx + 1]
            
    # Parse min_couv
    min_couv = 0.60
    if '--min-couv' in sys.argv:
        idx = sys.argv.index('--min-couv')
        if idx + 1 < len(sys.argv):
            min_couv = float(sys.argv[idx + 1])

    noms = []
    skip = False
    for a in sys.argv[1:]:
        if skip:
            skip = False
            continue
        if a in ('--mode', '--min-couv'):
            skip = True
            continue
        if a.startswith('-'):
            continue
        noms.append(a)

    if not noms:
        print("usage: gen_collisions.py <ground> [...] [--appliquer] [--mode luminance|teinte|auto] [--min-couv 0.60]")
        return 1
    ok = ref = 0
    for n in noms:
        try:
            nom, etat, msg = traiter(n, appliquer, mode=mode, min_couv=min_couv)
        except Exception as e:
            print(f"  ERREUR {n:34s} {type(e).__name__}: {str(e)[:70]}")
            ref += 1
            continue
        marque = '  OK  ' if etat == 'OK' else ' REFUS'
        print(f"{marque} {nom:34s} {msg}")
        ok += etat == 'OK'
        ref += etat != 'OK'
    print(f"\n{ok} acceptes, {ref} refuses"
          f"{' (APPLIQUE)' if appliquer else ' (SIMULATION)'}")
    return 0


if __name__ == '__main__':
    sys.exit(main())
