#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
verify_scene_positions.py — les entites des cinematiques tiennent-elles
dans leur carte ?

POURQUOI CET OUTIL
------------------
Plusieurs scenes ont ete ecrites en posant les coordonnees "d'apres les
conventions des autres cartes", sans ouvrir le .rsground correspondant.
Resultat mesure sur grand_canyon_porte : la carte fait 240x456 px, or le
partenaire etait teleporte a x=192 alors que son spawner officiel est a
x=256, et le PNJ de la scene a x=208 sur une carte large de 240.

Rien ne plante : le moteur accepte des coordonnees hors bornes. Le bug est
SILENCIEUX — un personnage invisible, ou colle au bord, ou une camera qui
cadre le vide. C'est exactement le genre de defaut qu'on ne voit qu'en jeu,
donc autant le detecter ici.

CE QUE FAIT L'OUTIL
-------------------
1. Lit la taille reelle de chaque carte (Layers[0].Tiles, 8 px par tuile).
2. Extrait des scripts tous les GROUND:TeleportTo(...), GAME:MoveCamera(...)
   et MakeCharactersFromList({{'X', x, y, ...}}).
3. Signale toute coordonnee hors bornes, et toute camera dont le cadre
   (320x240 centre sur le point) sort largement de la carte.
4. Rappelle les positions officielles du .rsground (marqueurs, spawners)
   pour donner tout de suite la bonne valeur.

USAGE
    python3 tools/verify_scene_positions.py .
"""
import glob
import json
import os
import re
import sys

VIEW_W, VIEW_H = 320, 240


def map_size(path):
    """Taille reelle de la carte en pixels, ou None.

    PIEGE VERIFIE : ce n'est PAS Layers[0].Tiles. Le champ `obstacles` est la
    grille de collision, en cases de 8 px, et c'est LUI qui donne la taille
    jouable. Sur les cartes a TexSize=3, la grille de tuiles est trois fois
    plus petite que la grille d'obstacles :

        vast_steppe_midpoint   tuiles 22x33   obstacles 66x99   -> 528x792 px

    Se fier a Layers donnait 176x264, soit un quart de la vraie surface, et
    faisait passer pour "hors carte" des positions parfaitement valides —
    y compris celles du .rsground lui-meme.
    """
    try:
        obj = json.load(open(path, encoding='utf-8-sig'))['Object']
        ob = obj.get('obstacles')
        if isinstance(ob, list) and ob and isinstance(ob[0], list):
            # ATTENTION : la grille est indexee [x][y], pas [y][x].
            # Verifie sur les 269 cartes du depot en confrontant les ancrages
            # du .rsground a leur propre carte :
            #     lecture [x][y] :   5 ancrages hors carte
            #     lecture [y][x] : 147 ancrages hors carte
            # La premiere est donc la bonne. Exemple mount_windswept_midpoint :
            # entrance_east est a x=1132, ce que seule la lecture [x][y]
            # (1152 px de large) peut contenir.
            return len(ob) * 8, len(ob[0]) * 8
        tiles = obj['Layers'][0]['Tiles']
        return len(tiles) * 8, len(tiles[0]) * 8
    except Exception:
        return None


def map_anchors(path):
    """Positions officielles : marqueurs et spawners."""
    out = []
    try:
        obj = json.load(open(path, encoding='utf-8-sig'))['Object']
        ent = obj['Entities'][0]
        for key in ('Markers', 'Spawners', 'GroundObjects'):
            for o in ent.get(key, []):
                col = o.get('Collider') or {}
                if 'X' in col:
                    out.append((o.get('EntName', '?'), col['X'], col['Y']))
    except Exception:
        pass
    return out


def main(root):
    grounds = {}
    for f in glob.glob(os.path.join(root, 'Data/Ground/*.rsground')):
        name = os.path.basename(f)[:-9]
        size = map_size(f)
        if size:
            grounds[name] = (size, f)

    pat_tp = re.compile(r'GROUND:TeleportTo\(\s*[A-Za-z_0-9]+\s*,\s*(\d+)\s*,\s*(\d+)')
    pat_cam = re.compile(r'GAME:MoveCamera\(\s*(\d+)\s*,\s*(\d+)')
    pat_mk = re.compile(r"MakeCharactersFromList\(\{\{'([^']+)'\s*,\s*(\d+)\s*,\s*(\d+)")

    problems = []
    checked = 0
    for lua in glob.glob(os.path.join(root, 'Data/Script/**/*.lua'), recursive=True):
        # Le nom du dossier donne la carte ; sinon on ne sait pas rattacher.
        ground = os.path.basename(os.path.dirname(lua))
        if ground not in grounds:
            continue
        (w, h), _src = grounds[ground]
        text = open(lua, encoding='utf-8').read()
        text = re.sub(r'--\[\[.*?\]\]', '', text, flags=re.S)
        text = '\n'.join(l.split('--')[0] for l in text.split('\n'))
        rel = os.path.relpath(lua, root)
        checked += 1

        # Marge d'un ecran : sortir LEGEREMENT des bornes est un usage
        # VOLONTAIRE et repandu (un personnage entre ou sort du champ). Le
        # contenu Halcyon d'origine, teste et jouable, en contient partout.
        # Au-dela d'un ecran en revanche, le sprite ne reviendra jamais dans
        # le cadre : c'est une vraie aberration.
        mx, my = w + VIEW_W, h + VIEW_H
        for m in pat_tp.finditer(text):
            x, y = int(m.group(1)), int(m.group(2))
            if x > mx or y > my:
                problems.append((rel, ground, '%dx%d' % (w, h),
                                 'TeleportTo (%d,%d) HORS CARTE' % (x, y)))
        for m in pat_mk.finditer(text):
            who, x, y = m.group(1), int(m.group(2)), int(m.group(3))
            if x > mx or y > my:
                problems.append((rel, ground, '%dx%d' % (w, h),
                                 '%s pose en (%d,%d) HORS CARTE' % (who, x, y)))
        for m in pat_cam.finditer(text):
            x, y = int(m.group(1)), int(m.group(2))
            # Une camera peut sortir un peu (le moteur clampe), mais un centre
            # a plus d'un ecran hors carte cadre forcement le vide.
            if x > mx or y > my:
                problems.append((rel, ground, '%dx%d' % (w, h),
                                 'MoveCamera centre (%d,%d) HORS CARTE' % (x, y)))

    print('%d fichier(s) de scene rattache(s) a une carte.' % checked)
    if not problems:
        print('RESULTAT : AUCUNE ENTITE A PLUS D UN ECRAN HORS CARTE')
        return 0

    print()
    seen = set()
    for rel, ground, size, why in problems:
        print('  %-46s [%s %s]' % (rel, ground, size))
        print('      %s' % why)
        if ground not in seen:
            seen.add(ground)
            anchors = map_anchors(grounds[ground][1])
            if anchors:
                print('      positions officielles du .rsground :')
                for n, x, y in anchors:
                    print('         %-22s (%d, %d)' % (n, x, y))
    print()
    print('RESULTAT : %d position(s) hors carte' % len(problems))
    return 1


if __name__ == '__main__':
    sys.exit(main(sys.argv[1] if len(sys.argv) > 1 else '.'))
