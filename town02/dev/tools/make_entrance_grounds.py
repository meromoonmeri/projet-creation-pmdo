#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""make_entrance_grounds.py — pose les deux visuels d'entrance fournis
comme grounds jouables, avec une geometrie de collision tiree de l'ART
lui-meme et non d'une heuristique generique.

POURQUOI CE FICHIER PLUTOT QUE png2tileset SEUL
------------------------------------------------
`png2tileset.py ground` sait convertir le decor et regenerer l'index,
et c'est lui qui fait ce travail ici. En revanche sa detection
automatique du sol (`couleurs_sol`) raisonne sur les couleurs dominantes
d'un tileset de donjon. Sur ces deux illustrations d'entrance, elle
classe la falaise sculptee comme praticable et le sable comme bloquant :
mesure sur Celestial Peak, 45 % de cases libres reparties en damier sur
toute la hauteur, y compris dans le ciel.

On calcule donc la marchabilite ici, par une regle explicite propre a
chaque image, puis on la controle : couloir continu, entree reliee a la
porte du donjon, aucune entite dans un mur, aucune superposition.

CELESTIAL PEAK  (552x360 -> 69x45 cellules de 8 px)
    Le sable occupe une bande horizontale au milieu de l'image. Au-dessus
    le ciel puis la falaise ; en dessous, les rochers du premier plan.
    La grotte (entree du donjon) s'ouvre en haut au centre-droit, et un
    escalier de pierre y descend jusqu'au sable.

FORET LUGUBRE   (600x312 -> 75x39 cellules de 8 px)
    Clairiere herbeuse au centre, ceinturee d'arbres au nord et de
    buissons au sud. La grotte s'ouvre a l'est, dans la paroi rocheuse.

Les bandes sont exprimees en CELLULES, mesurees sur l'image (voir le
releve en commentaire de chaque fonction). Elles ne sont pas devinees.
"""
import json
import os
import subprocess
import sys
from collections import deque

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


# ------------------------------------------------------------------ util
def bfs(ob, depart):
    """Cases atteignables a pied depuis `depart`."""
    W, H = len(ob), len(ob[0])
    if not (0 <= depart[0] < W and 0 <= depart[1] < H):
        return set()
    if ob[depart[0]][depart[1]]['Tags'] != 0:
        return set()
    vus = {depart}
    q = deque([depart])
    while q:
        x, y = q.popleft()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            n = (x + dx, y + dy)
            if (0 <= n[0] < W and 0 <= n[1] < H and n not in vus
                    and ob[n[0]][n[1]]['Tags'] == 0):
                vus.add(n)
                q.append(n)
    return vus


def poser(ob, libres):
    """Applique un ensemble de cellules libres sur la grille d'obstacles."""
    W, H = len(ob), len(ob[0])
    for x in range(W):
        for y in range(H):
            ob[x][y]['Tags'] = 0 if (x, y) in libres else 1


# ------------------------------------------------- geometries par image
def sol_celestial_peak(W, H):
    """Releve sur l'image (bandes de 16 px, cf. analyse colorimetrique) :

        y 0..~168   ciel puis falaise sculptee      -> bloque
        y ~176..232 bande de sable continue          -> praticable
        y ~240..    rochers du premier plan          -> bloque

    La grotte est en haut, colonne ~41..46 : on ouvre un escalier
    vertical qui relie le sable au seuil, sinon la porte du donjon est
    posee sur une case injoignable.
    """
    libres = set()
    for x in range(W):
        for y in range(22, 30):          # 176..239 px : le sable
            libres.add((x, y))
    # marge basse praticable devant les rochers, pour que l'equipe puisse
    # se deployer sans etre collee au bord
    for x in range(0, W):
        libres.add((x, 30))
    # escalier vers la grotte : colonnes 42..45, de la bande de sable
    # jusqu'au seuil (y=14)
    for x in range(42, 46):
        for y in range(14, 22):
            libres.add((x, y))
    return libres


def sol_gloomy_forest(W, H):
    """Releve cellule par cellule sur l'image (analyse colorimetrique :
    herbe claire vs feuillage sombre vs roche gris-blanc) :

        y 0..14     cimes d'arbres au nord, paroi rocheuse au nord-est
        y 15..24    CLAIRIERE herbeuse                    -> praticable
        y 25..28    buissons du premier plan
        y 29..38    bande noire de bas d'image (hors jeu)

    En x, la clairiere s'etend de 0 a ~60 ; au-dela commence la roche.
    La bouche de la grotte se lit vers x 63..70, y 17..23 : on ouvre un
    court couloir depuis la clairiere jusqu'a son seuil, sinon la porte
    du donjon repose sur une case injoignable.

    On garde une marge d'une cellule sur les bords lateraux : les
    colonnes extremes sont a demi couvertes par le feuillage.
    """
    libres = set()
    for x in range(1, 60):
        for y in range(16, 25):
            libres.add((x, y))
    # couloir est vers la grotte, dans la trouee de roche
    for x in range(60, 68):
        for y in range(18, 23):
            libres.add((x, y))
    return libres


PLANS = {
    'celestial_peak_entrance': {
        'png': 'Entrance - Celestial Peak.png',
        'planche': 'Celestial_Peak_Entrance_Art',
        'sol': sol_celestial_peak,
        # (nom d'entite -> cellule voulue). Cellules choisies DANS la zone
        # praticable, verifiees ensuite par le controle d'accessibilite.
        'entites': {
            'Main_Entrance_Marker': (30, 28),
            'TEAMMATE_1':           (28, 28),
            'TEAMMATE_2':           (32, 28),
            'TEAMMATE_3':           (30, 29),
            'Dungeon_Entrance':     (43, 15),
            'Kangaskhan_Rock':      (12, 24),
        },
    },
    'gloomy_forest_entrance': {
        'png': 'Entrance - Forêt Lugubre ch6.png',
        'planche': 'Gloomy_Forest_Entrance_Art',
        'sol': sol_gloomy_forest,
        'entites': {
            'Main_Entrance_Marker': (8, 21),
            'TEAMMATE_1':           (6, 21),
            'TEAMMATE_2':           (10, 21),
            'TEAMMATE_3':           (8, 23),
            'Dungeon_Entrance':     (65, 20),
            'Kangaskhan_Rock':      (20, 17),
        },
    },
}


# ------------------------------------------------------------------ main
def traiter(nom, appliquer):
    plan = PLANS[nom]
    png = os.path.join('/home/user/uploads', plan['png'])
    sortie = os.path.join(ROOT, 'Data', 'Ground', nom + '.rsground')

    print('=' * 70)
    print(nom)
    print('=' * 70)

    # 1. conversion du decor par l'outil du projet (tileset + index + tuiles)
    cmd = [sys.executable, os.path.join(ROOT, 'tools', 'png2tileset.py'),
           'ground', png, plan['planche'], sortie,
           '--grid', '8', '--herite', nom]
    if appliquer:
        cmd.append('--apply')
    r = subprocess.run(cmd, capture_output=True, text=True)
    for l in (r.stdout or '').strip().split('\n')[:3]:
        print('  ' + l)
    if r.returncode != 0:
        print('  ECHEC de la conversion :')
        print((r.stderr or '')[-600:])
        return False
    if not appliquer:
        print('  (essai a blanc)')
        return True

    # 2. geometrie de collision tiree de l'art
    raw = open(sortie, encoding='utf-8-sig').read()
    doc = json.loads(raw)
    obj = doc['Object']
    ob = obj['obstacles']
    W, H = len(ob), len(ob[0])
    libres = {c for c in plan['sol'](W, H)
              if 0 <= c[0] < W and 0 <= c[1] < H}
    poser(ob, libres)
    print(f'  geometrie : {W}x{H} cellules, {len(libres)} praticables '
          f'({100 * len(libres) // (W * H)} %)')

    # 3. repositionnement des entites sur des cellules voulues
    index = {}
    for couche in obj.get('Entities', []):
        for cle in ('MapChars', 'GroundObjects', 'Markers', 'Spawners'):
            for e in (couche.get(cle) or []):
                index[e.get('EntName')] = e

    for ent, (cx, cy) in plan['entites'].items():
        e = index.get(ent)
        if e is None:
            print(f'  - {ent} : absent de ce ground (ignore)')
            continue
        c = e['Collider']
        c['X'], c['Y'] = cx * 8, cy * 8
        if e.get('serializationLoc'):
            e['serializationLoc'] = {'X': c['X'], 'Y': c['Y']}
        print(f'  - {ent:22s} -> cellule ({cx},{cy}) px ({c["X"]},{c["Y"]})')

    # 4. controles avant ecriture
    depart = plan['entites']['Main_Entrance_Marker']
    joignables = bfs(ob, depart)
    print(f'  accessibles depuis l entree : {len(joignables)}/{len(libres)}')

    souci = []
    for ent, (cx, cy) in plan['entites'].items():
        if ent not in index:
            continue
        for dx in (0, 8):
            for dy in (0, 8):
                t = ((cx * 8 + dx) // 8, (cy * 8 + dy) // 8)
                if t not in joignables:
                    souci.append(f'{ent} : cellule {t} hors zone accessible')
    # superpositions
    vus = {}
    for ent, cell in plan['entites'].items():
        if ent in index:
            vus.setdefault(cell, []).append(ent)
    for cell, noms in vus.items():
        if len(noms) > 1:
            souci.append(f'superposition en {cell} : {", ".join(noms)}')

    if souci:
        print('  ABANDON, la geometrie ne tient pas :')
        for s in souci:
            print('     ' + s)
        return False
    print('  controles : couloir continu, entites libres, aucune superposition')

    out = json.dumps(doc, ensure_ascii=False, indent=2)
    with open(sortie, 'w', encoding='utf-8') as f:
        f.write('\ufeff' + out)
    print(f'  ecrit : {sortie}')
    return True


if __name__ == '__main__':
    appliquer = '--apply' in sys.argv
    cibles = [n for n in PLANS if n in sys.argv] or list(PLANS)
    ok = all(traiter(n, appliquer) for n in cibles)
    sys.exit(0 if ok else 1)
