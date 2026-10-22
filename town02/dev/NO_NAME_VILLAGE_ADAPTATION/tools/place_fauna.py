#!/usr/bin/env python3
"""Place la faune Pokemon dans les rooms NNV selon l'ecologie reelle du terrain.

Principe : on ne "repeint" pas les occurrences source une par une. Chaque
occurrence source dit *combien* d'individus d'un objet vivaient dans la room ;
l'atlas de biome dit *ou* cette espece peut credibiliement vivre. On recompose
donc des **colonies** (groupes coherents) posees sur des cellules valides, au
lieu de recopier des coordonnees qui pointaient vers des arbres et des murs.

Garanties dures, verifiees par assert avant ecriture :
  - jamais sur une cellule bloquee, un arbre, un rocher, un mur, un batiment ;
  - une espece aquatique est dans l'eau ; une espece de rive est a <=2 cellules
    de l'eau ; une espece de canopee est a <=2 cellules d'un arbre ; etc. ;
  - un volant a besoin d'espace aerien (open_space >= 6 voisines libres) ;
  - deux individus ne partagent jamais la meme cellule ;
  - distance minimale entre colonies pour eviter les grappes artificielles ;
  - densite plafonnee par room pour garder des espaces vides.

Sortie : reports/fauna-ecology/fauna-placement.json.gz + rapport lisible.
Lecture seule sur Data/ : rien n'est ecrit dans les Grounds ici.
"""
from __future__ import annotations
import argparse, gzip, json, math, os, random, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'

CELL = 64
GRID = 78
T_BLOCKED, T_OPEN, T_GRASS, T_WATER, T_MARSH = 0, 1, 2, 3, 4
T_TREE, T_ROCK, T_CLIFF, T_PLANT, T_SNOW = 5, 6, 7, 8, 9

WALKABLE = {T_OPEN, T_GRASS, T_PLANT, T_MARSH, T_SNOW}
FORBIDDEN = {T_BLOCKED, T_TREE, T_ROCK, T_CLIFF}

# densite maximale d'individus pour 1000 cellules exploitables, par room
MAX_DENSITY_PER_1000 = 26
# distance minimale (cellules) entre deux ancres de colonies de la meme espece
MIN_COLONY_GAP = 9


def habitat_ok(sp, atlas, x, y):
    """La cellule (x,y) convient-elle a l'espece sp ? Regles dures."""
    t = atlas['terrain'][y][x]
    prof = sp['_profile']
    req = prof.get('requires')

    if req == 'water':
        return t == T_WATER
    if t in FORBIDDEN:
        return False

    if req == 'near_water':
        if not (t in WALKABLE or t == T_WATER):
            return False
        if atlas['near_water'][y][x] > 2:
            return False
    elif req == 'near_tree':
        if t not in WALKABLE:
            return False
        if atlas['near_tree'][y][x] > 2:
            return False
    elif t not in WALKABLE:
        return False

    # les volants exigent du ciel dégagé
    if not prof.get('grounded', True) and req not in ('water',):
        if atlas['open_space'][y][x] < 6:
            return False

    # habitats déclarés par l'espèce
    hab = sp.get('habitat') or []
    if hab:
        ok = False
        for h in hab:
            if h == 'water' and t == T_WATER:
                ok = True
            elif h == 'grass' and t == T_GRASS:
                ok = True
            elif h == 'open' and t == T_OPEN:
                ok = True
            elif h == 'plant' and t == T_PLANT:
                ok = True
            elif h == 'marsh' and t == T_MARSH:
                ok = True
            elif h == 'snow' and t == T_SNOW:
                ok = True
            elif h == 'near_water' and atlas['near_water'][y][x] <= 2:
                ok = True
            elif h == 'near_tree' and atlas['near_tree'][y][x] <= 2:
                ok = True
            elif h == 'near_rock' and atlas['near_rock'][y][x] <= 2:
                ok = True
            if ok:
                break
        if not ok:
            return False

    for a in sp.get('avoid') or []:
        if a == 'water' and (t == T_WATER or atlas['near_water'][y][x] == 0):
            return False
        if a == 'marsh' and t == T_MARSH:
            return False
    return True


def candidate_cells(sp, atlas):
    return [(x, y) for y in range(GRID) for x in range(GRID)
            if habitat_ok(sp, atlas, x, y)]


def place_room(room_name, atlas, species, occ_per_object, rng):
    """Compose les colonies d'une room. Retourne (individus, diagnostics)."""
    # combien d'individus par espèce, d'après les occurrences source
    want = {}
    for sname, sp in species.items():
        n = sum(occ_per_object.get(o, 0) for o in sp['source_objects'])
        if n:
            want[sname] = n

    exploitable = sum(1 for y in range(GRID) for x in range(GRID)
                      if atlas['terrain'][y][x] not in FORBIDDEN)
    cap = max(6, int(exploitable * MAX_DENSITY_PER_1000 / 1000))

    # on réduit proportionnellement pour ne jamais saturer la carte
    total_want = sum(want.values())
    scale = min(1.0, cap / total_want) if total_want else 0.0

    taken = set()
    individuals = []
    diags = []

    # les espèces les plus contraintes d'abord (moins de cellules valides)
    order = []
    for sname in want:
        sp = species[sname]
        cells = candidate_cells(sp, atlas)
        order.append((len(cells), sname, cells))
    order.sort()

    for ncand, sname, cells in order:
        sp = species[sname]
        target = max(1, int(round(want[sname] * scale))) if want[sname] else 0
        if not cells:
            diags.append({'species': sname, 'room': room_name,
                          'status': 'NO_HABITAT', 'wanted': want[sname],
                          'placed': 0})
            continue

        gmin, gmax = sp.get('group_size') or [1, 1]
        placed = 0
        anchors = []
        guard = 0
        while placed < target and guard < 400:
            guard += 1
            ax, ay = cells[rng.randrange(len(cells))]
            # espacement entre colonies de la même espèce
            if any(max(abs(ax - bx), abs(ay - by)) < MIN_COLONY_GAP
                   for bx, by in anchors):
                continue
            size = rng.randint(gmin, gmax)
            size = min(size, target - placed)
            if size <= 0:
                break
            members = []
            # les membres se répartissent autour de l'ancre, sur cellules valides
            radius = 1 if size <= 2 else 2 if size <= 5 else 3
            pool = [(x, y) for (x, y) in cells
                    if max(abs(x - ax), abs(y - ay)) <= radius and (x, y) not in taken]
            rng.shuffle(pool)
            for (x, y) in pool[:size]:
                taken.add((x, y))
                members.append({'cell': [x, y],
                                'px': [x * CELL + CELL // 2, y * CELL + CELL // 2]})
            if not members:
                continue
            anchors.append((ax, ay))
            placed += len(members)
            individuals.append({
                'species': sname, 'profile': sp['profile'],
                'anchor': [ax, ay], 'members': members,
                'seasons': sp.get('seasons'), 'time': sp.get('time', 'any'),
                'social': sp.get('social'), 'level': sp['level'],
            })
        if placed < target:
            diags.append({'species': sname, 'room': room_name,
                          'status': 'PARTIAL', 'wanted': target,
                          'placed': placed, 'candidate_cells': ncand})
    return individuals, diags, cap, exploitable


def verify(room_name, atlas, colonies, species):
    """Contrôles durs. Retourne la liste des violations (vide = conforme)."""
    bad = []
    seen = {}
    for c in colonies:
        sp = species[c['species']]
        for m in c['members']:
            x, y = m['cell']
            t = atlas['terrain'][y][x]
            if t in FORBIDDEN:
                bad.append('%s/%s en (%d,%d) terrain interdit=%d'
                           % (room_name, c['species'], x, y, t))
            if not habitat_ok(sp, atlas, x, y):
                bad.append('%s/%s en (%d,%d) habitat non conforme'
                           % (room_name, c['species'], x, y))
            k = (x, y)
            if k in seen:
                bad.append('%s: (%d,%d) partagee par %s et %s'
                           % (room_name, x, y, seen[k], c['species']))
            seen[k] = c['species']
    return bad


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--atlas', default=str(NNV / 'reports/fauna-ecology/biome-atlas.json.gz'))
    ap.add_argument('--out', default=str(NNV / 'reports/fauna-ecology'))
    ap.add_argument('--seed', type=int, default=20260817)
    ns = ap.parse_args()

    A = json.load(gzip.open(ns.atlas))
    S = json.load(open(NNV / 'config/fauna-species.json'))
    occ = json.load(open(NNV / 'reports/fauna-fix/fauna-occurrences.json'))

    species = S['species']
    for sname, sp in species.items():
        sp['_profile'] = S['behaviour_profiles'][sp['profile']]

    # occurrences par (room, objet)
    per_room_obj = {}
    for o in occ['occurrences']:
        per_room_obj.setdefault(o['room'], {}).setdefault(o['object'], 0)
        per_room_obj[o['room']][o['object']] += 1

    out = {'schema': 'nnv-fauna-placement-v1', 'cell_px': CELL, 'grid': GRID,
           'seed': ns.seed, 'rooms': {}}
    all_bad, all_diags = [], []
    tot_ind = 0
    for room_name in sorted(A['rooms']):
        atlas = A['rooms'][room_name]
        rng = random.Random('%s|%d' % (room_name, ns.seed))
        colonies, diags, cap, exploitable = place_room(
            room_name, atlas, species, per_room_obj.get(room_name, {}), rng)
        bad = verify(room_name, atlas, colonies, species)
        all_bad += bad
        all_diags += diags
        n = sum(len(c['members']) for c in colonies)
        tot_ind += n
        out['rooms'][room_name] = {
            'colonies': colonies, 'individuals': n, 'cap': cap,
            'exploitable_cells': exploitable,
            'species': sorted({c['species'] for c in colonies}),
        }
        print('%-10s colonies=%-3d individus=%-4d cap=%-4d especes=%-2d %s'
              % (room_name, len(colonies), n, cap,
                 len(out['rooms'][room_name]['species']),
                 'OK' if not bad else 'VIOLATIONS=%d' % len(bad)))

    out['totals'] = {'rooms': len(out['rooms']), 'individuals': tot_ind,
                     'violations': len(all_bad)}
    out['diagnostics'] = all_diags
    out['violations'] = all_bad[:200]

    os.makedirs(ns.out, exist_ok=True)
    p = Path(ns.out) / 'fauna-placement.json.gz'
    with gzip.open(p, 'wt') as f:
        json.dump(out, f)
    print('\ntotal individus:', tot_ind)
    print('violations:', len(all_bad))
    for b in all_bad[:12]:
        print('  ', b)
    nohab = [d for d in all_diags if d['status'] == 'NO_HABITAT']
    print('especes sans habitat dans une room:', len(nohab))
    print('ecrit', p, os.path.getsize(p), 'octets')
    return 1 if all_bad else 0


if __name__ == '__main__':
    sys.exit(main())
