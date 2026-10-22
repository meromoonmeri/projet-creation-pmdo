#!/usr/bin/env python3
"""Repare la couche d'entites de colline_anciens.rsground.

DIAGNOSTIC (preuve dans docs/audit_colline_anciens_2026-08-02.md)
----------------------------------------------------------------
Le commit 5a5b4e4 a importe la GEOMETRIE de la Colline des Anciens
(tuiles + obstacles : un plateau de 252 cases et un eperon rocheux isole
de 19 cases, conforme au script) mais a conserve la COUCHE D ENTITES de
guild_heros_room, la chambre du heros a la Guilde :

  Bedroom_Exit  (0,184)   sortie de chambre        -> hors carte (H=160)
  Save_Point    (172,148) point de sauvegarde      -> mobilier de chambre
  Book          (288,208) livre a lire             -> hors carte (W=240)
  Hero_Bed      (172,148) lit du heros             -> mobilier de chambre
  Partner_Bed   (228,148) lit du partenaire        -> mobilier de chambre
  entrance_1    (0,216)   entree                   -> hors carte
  Main_Entrance_Marker (40,200)                    -> HORS CARTE
  TEAMMATE_1    (8,200)   spawner partenaire       -> HORS CARTE

Consequences reelles :
  * les 3 objets sans handler sont signales par audit_bugs.py section E ;
  * le marqueur d entree et le spawner du partenaire sont hors des bornes
    de la carte : c est exactement la classe de defaut corrigee par b526a68
    sur le relais du Mont Windsep (ecran noir a l arrivee) ;
  * la carte porte encore le nom « Your Room » et la musique de la Guilde.

CORRECTIF
---------
  * suppression des 5 entites de mobilier de chambre ;
  * Main_Entrance_Marker replace en bas du plateau, face au nord
    (le joueur arrive par le sentier et fait face a l eperon) ;
  * spawner TEAMMATE_1 place a cote, sur une case libre du meme plateau ;
  * Name et Music corriges.

Les tuiles et les obstacles ne sont PAS touches : la geometrie importee
est correcte et doit rester fidele a la source.

Idempotent. Round-trip JSON prouve avant ecriture (indent=2 pour ce fichier).
"""
import json
import sys
from collections import deque

PATH = 'Data/Ground/colline_anciens.rsground'
DROP = {'Bedroom_Exit', 'Save_Point', 'Book', 'Hero_Bed', 'Partner_Bed'}

# Valides par tools/_map_colline.py : plateau principal, rangee basse centrale.
ENTRY_X, ENTRY_Y = 112, 144     # tile (14,18)-(14,19), plateau, bord bas
MATE_X, MATE_Y = 96, 144        # tile (12,18)-(12,19)
DIR_UP = 4                      # Dir8.Up : le joueur regarde vers l eperon


def main():
    raw = open(PATH, encoding='utf-8-sig').read()
    doc = json.loads(raw)
    if json.dumps(doc, ensure_ascii=False, indent=2) != raw:
        sys.exit('ABANDON : round-trip indent=2 non conforme sur %s' % PATH)

    o = doc['Object']
    ob = o['obstacles']
    W, H = len(ob), len(ob[0])

    # composante accessible autour du point d arrivee
    sx, sy = ENTRY_X // 8, ENTRY_Y // 8
    if ob[sx][sy]['Tags'] != 0:
        sys.exit('ABANDON : la case d arrivee (%d,%d) est un mur' % (sx, sy))
    seen = {(sx, sy)}
    q = deque([(sx, sy)])
    while q:
        x, y = q.popleft()
        for dx, dy in ((1,0),(-1,0),(0,1),(0,-1)):
            n = (x+dx, y+dy)
            if 0 <= n[0] < W and 0 <= n[1] < H and n not in seen \
                    and ob[n[0]][n[1]]['Tags'] == 0:
                seen.add(n); q.append(n)

    for lbl, px, py in (('entree', ENTRY_X, ENTRY_Y), ('partenaire', MATE_X, MATE_Y)):
        for dx in (0, 8):
            for dy in (0, 8):
                t = ((px+dx)//8, (py+dy)//8)
                if t not in seen:
                    sys.exit('ABANDON : %s (%d,%d) case %s inaccessible'
                             % (lbl, px, py, t))

    L = o['Entities'][0]
    before = (len(L['GroundObjects']), len(L['Markers']), len(L['Spawners']))

    L['GroundObjects'] = [e for e in L['GroundObjects'] if e['EntName'] not in DROP]
    L['Markers'] = [e for e in L['Markers'] if e['EntName'] not in DROP]

    entry = next((m for m in L['Markers'] if m['EntName'] == 'Main_Entrance_Marker'), None)
    if entry is None:
        sys.exit('ABANDON : Main_Entrance_Marker introuvable')
    entry['Collider']['X'], entry['Collider']['Y'] = ENTRY_X, ENTRY_Y
    entry['Direction'] = DIR_UP

    e1 = next((m for m in L['Markers'] if m['EntName'] == 'entrance_1'), None)
    if e1 is not None:
        e1['Collider']['X'], e1['Collider']['Y'] = ENTRY_X, ENTRY_Y
        e1['Direction'] = DIR_UP

    sp = next((s for s in L['Spawners'] if s['EntName'] == 'TEAMMATE_1'), None)
    if sp is not None:
        sp['Collider']['X'], sp['Collider']['Y'] = MATE_X, MATE_Y
        sp['Direction'] = DIR_UP
        if 'serializationLoc' in sp:
            sp['serializationLoc'] = {'X': MATE_X, 'Y': MATE_Y}
        if 'serializationDir' in sp:
            sp['serializationDir'] = DIR_UP

    o['Name'] = {'DefaultText': 'Hill of the Ancients', 'LocalTexts': {}}
    o['Music'] = 'Sky Peak Prairie.ogg'  # atteste dans Content/Music

    out = json.dumps(doc, ensure_ascii=False, indent=2)
    with open(PATH, 'w', encoding='utf-8') as f:
        f.write('\ufeff' + out)

    after = (len(L['GroundObjects']), len(L['Markers']), len(L['Spawners']))
    print('GroundObjects %d -> %d | Markers %d -> %d | Spawners %d -> %d'
          % (before[0], after[0], before[1], after[1], before[2], after[2]))
    print('entree (%d,%d) Dir=%d | partenaire (%d,%d)'
          % (ENTRY_X, ENTRY_Y, DIR_UP, MATE_X, MATE_Y))


if __name__ == '__main__':
    main()
