#!/usr/bin/env python3
"""Classe chaque room et chaque individu par NIVEAU DE PREUVE, fail-closed.

Trois niveaux, sans zone grise :

  PROVEN   : rendu 4992x4992 du Ground reconverti ET grille de collision
             disponibles. Le terrain est verifie par ce que le joueur voit et
             par ce que le moteur bloque. -> injectable.

  PARTIAL  : une seule des deux preuves est disponible. Le placement reste
             possible mais doit etre signale et re-verifie. -> NON injectable
             sans validation explicite.

  NO_PROOF : ni rendu ni collision. Seuls les GameObjects source existent, ce
             qui ne dit rien de la praticabilite reelle ni de l'eau.
             -> FAIL-CLOSED : aucun individu promu, rien n'est devine.

En plus des rooms, on classe les ESPECES : une espece dont toutes les
occurrences source tombent dans des rooms NO_PROOF est mise en attente
(status HELD), et surtout pas placee ailleurs "pour qu'elle existe".

Sortie : reports/fauna-ecology/evidence-classification.json
"""
from __future__ import annotations
import argparse, gzip, json, os, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'
ECO = NNV / 'reports/fauna-ecology'

PROVEN, PARTIAL, NO_PROOF = 'PROVEN', 'PARTIAL', 'NO_PROOF'


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--out', default=str(ECO / 'evidence-classification.json'))
    ns = ap.parse_args()

    A = json.load(gzip.open(ECO / 'biome-atlas.json.gz'))['rooms']
    P = json.load(gzip.open(ECO / 'fauna-placement.json.gz'))['rooms']
    S = json.load(open(NNV / 'config/fauna-species.json'))['species']
    occ = json.load(open(NNV / 'reports/fauna-fix/fauna-occurrences.json'))

    rooms = {}
    for name, a in A.items():
        r, c = a.get('has_render', False), a.get('has_collision', False)
        if r and c:
            level, why = PROVEN, 'rendu 4992x4992 + grille de collision presents'
        elif r or c:
            level, why = PARTIAL, ('rendu present, collision absente' if r
                                   else 'collision presente, rendu absent')
        else:
            level, why = NO_PROOF, ('ni rendu ni collision : le Ground reconverti '
                                    'de cette room n existe pas')
        placed = P.get(name, {}).get('individuals', 0)
        rooms[name] = {
            'evidence': level, 'reason': why,
            'has_render': r, 'has_collision': c,
            'placed_individuals': placed,
            'promotable_individuals': placed if level == PROVEN else 0,
            'species': P.get(name, {}).get('species', []),
            'source_occurrences': occ['per_room'].get(name, 0),
        }

    # --- especes ---------------------------------------------------------
    obj_room = {}
    for o in occ['occurrences']:
        obj_room.setdefault(o['object'], {}).setdefault(o['room'], 0)
        obj_room[o['object']][o['room']] += 1

    species = {}
    for sname, sp in S.items():
        srooms = {}
        for o in sp['source_objects']:
            for rm, n in obj_room.get(o, {}).items():
                srooms[rm] = srooms.get(rm, 0) + n
        lv = {PROVEN: 0, PARTIAL: 0, NO_PROOF: 0}
        for rm, n in srooms.items():
            lv[rooms.get(rm, {}).get('evidence', NO_PROOF)] += n
        placed = sum(
            len(c['members'])
            for rd in json.load(gzip.open(ECO / 'fauna-placement.json.gz'))['rooms'].values()
            for c in rd['colonies'] if c['species'] == sname)
        promotable = sum(
            len(c['members'])
            for rn, rd in json.load(gzip.open(ECO / 'fauna-placement.json.gz'))['rooms'].items()
            for c in rd['colonies']
            if c['species'] == sname and rooms.get(rn, {}).get('evidence') == PROVEN)
        if lv[PROVEN] == 0 and (lv[NO_PROOF] or lv[PARTIAL]):
            status = 'HELD'
            note = ('toutes les occurrences source tombent dans des rooms sans '
                    'preuve de terrain : espece mise en attente, jamais deplacee '
                    'ailleurs pour la faire exister')
        elif promotable == 0:
            status = 'HELD'
            note = 'aucun individu dans une room PROVEN'
        else:
            status = 'PROMOTABLE'
            note = ''
        species[sname] = {
            'status': status, 'note': note,
            'source_by_evidence': lv,
            'rooms': sorted(srooms),
            'placed_total': placed,
            'promotable': promotable,
        }

    by = {PROVEN: [], PARTIAL: [], NO_PROOF: []}
    for n, r in rooms.items():
        by[r['evidence']].append(n)
    held = sorted(n for n, s in species.items() if s['status'] == 'HELD')

    out = {
        'schema': 'nnv-fauna-evidence-v1',
        'policy': 'fail-closed : rien n est devine, rien n est promu sans preuve',
        'levels': {
            PROVEN: 'rendu + collision : injectable',
            PARTIAL: 'une seule preuve : non injectable sans validation explicite',
            NO_PROOF: 'aucune preuve : FAIL-CLOSED, aucun individu promu',
        },
        'rooms_by_evidence': {k: sorted(v) for k, v in by.items()},
        'rooms': rooms,
        'species': species,
        'held_species': held,
        'totals': {
            'rooms': len(rooms),
            'rooms_proven': len(by[PROVEN]),
            'rooms_partial': len(by[PARTIAL]),
            'rooms_no_proof': len(by[NO_PROOF]),
            'individuals_placed': sum(r['placed_individuals'] for r in rooms.values()),
            'individuals_promotable': sum(r['promotable_individuals'] for r in rooms.values()),
            'individuals_withheld': sum(r['placed_individuals'] - r['promotable_individuals']
                                        for r in rooms.values()),
            'species_promotable': sum(1 for s in species.values() if s['status'] == 'PROMOTABLE'),
            'species_held': len(held),
        },
    }
    os.makedirs(os.path.dirname(ns.out), exist_ok=True)
    open(ns.out, 'w').write(json.dumps(out, indent=1, ensure_ascii=False) + '\n')

    t = out['totals']
    print('rooms : %d PROVEN, %d PARTIAL, %d NO_PROOF'
          % (t['rooms_proven'], t['rooms_partial'], t['rooms_no_proof']))
    print('individus : %d places, %d promouvables, %d retenus'
          % (t['individuals_placed'], t['individuals_promotable'],
             t['individuals_withheld']))
    print('especes : %d promouvables, %d en attente %s'
          % (t['species_promotable'], t['species_held'], held))
    print('NO_PROOF :', ', '.join(by[NO_PROOF]))
    print('ecrit', ns.out)
    return 0


if __name__ == '__main__':
    sys.exit(main())
