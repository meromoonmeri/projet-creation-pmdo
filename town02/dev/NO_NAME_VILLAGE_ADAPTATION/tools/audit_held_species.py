#!/usr/bin/env python3
"""Audit exhaustif des entites HELD. Fail-closed, aucune promotion.

Pour chaque individu retenu, produit la fiche demandee :
  espece, rooms candidates, biome, saisons possibles, jour/nuit, meteo,
  preuve de terrain disponible, position candidate, comportement,
  interactions possibles, statut READY/HELD/NO_PROOF et la raison exacte.

REGLE DE PROMOTION (une seule, stricte) :
  Une entite ne peut passer READY que si la variante de Ground correspondant
  a sa saison a ETE CONVERTIE ET RENDUE. Sans rendu 4992x4992 + collision pour
  cette saison, le terrain saisonnier est inconnu : le placement d'ete ne
  prouve rien pour l'automne ou l'hiver (la neige recouvre l'eau, les feuilles
  tombent, les zones praticables changent). -> HELD.
"""
from __future__ import annotations
import argparse, glob, gzip, json, os, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'
ECO = NNV / 'reports/fauna-ecology'

T_NAMES = {0: 'blocked', 1: 'open', 2: 'grass', 3: 'water', 4: 'marsh',
           5: 'tree', 6: 'rock', 7: 'cliff', 8: 'plant', 9: 'snow'}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--reconv', default='/tmp/reconv')
    ap.add_argument('--out', default=str(ECO / 'held-audit.json'))
    ns = ap.parse_args()

    ev = json.load(open(ECO / 'evidence-classification.json'))
    place = json.load(gzip.open(ECO / 'fauna-placement.json.gz'))['rooms']
    atlas = json.load(gzip.open(ECO / 'biome-atlas.json.gz'))['rooms']
    spec = json.load(open(NNV / 'config/fauna-species.json'))
    ctx = json.load(open(NNV / 'config/fauna-context.json'))
    species, profiles = spec['species'], spec['behaviour_profiles']
    relations_src = (ROOT / 'Data/Script/halcyon/NNVEcology.lua').read_text(encoding='utf-8')

    proven = set(ev['rooms_by_evidence']['PROVEN'])
    noproof = set(ev['rooms_by_evidence']['NO_PROOF'])
    held_species = set(ev['held_species'])

    # quelles variantes de Ground existent reellement ?
    available = {}
    for gp in glob.glob('%s/*/Data/Ground/*.rsground' % ns.reconv):
        stem = Path(gp).stem                     # nnv_<room>_<season>
        parts = stem.split('_')
        room, season = parts[1], parts[2]
        rp = Path(ns.reconv) / room / 'validation/source_normalized_tick0.png'
        available.setdefault(room, {})[season] = {
            'ground': gp, 'render': rp.exists()}

    # relations declarees dans NNVEcology
    import re
    rel_block = relations_src[relations_src.index('E.RELATIONS'):
                              relations_src.index('E.DUEL_PAIRS')]
    duel_block = relations_src[relations_src.index('E.DUEL_PAIRS'):
                               relations_src.index('E.DUEL_PAIRS') + 600]
    duel_pairs = set(re.findall(r'(\w+)_(\w+)\s*=\s*true', duel_block))

    def relations_of(sp):
        m = re.search(r'^\s{2}%s\s*=\s*\{(.*?)\},?\s*$' % re.escape(sp),
                      rel_block, re.S | re.M)
        if not m:
            return {}
        return dict(re.findall(r"(\w+)='(\w+)'", m.group(1)))

    entries = []
    for room, rd in sorted(place.items()):
        a = atlas.get(room, {})
        terr = a.get('terrain')
        for ci, col in enumerate(rd['colonies']):
            sp = col['species']
            seasons = col.get('seasons') or []
            is_offseason = 'summer' not in seasons
            is_held_sp = sp in held_species
            is_noproof = room in noproof
            if not (is_offseason or is_held_sp or is_noproof):
                continue

            sdef = species.get(sp, {})
            prof = profiles.get(sdef.get('profile'), {})
            cdef = ctx['species_context'].get(sp, {})

            # preuve de terrain pour CETTE saison
            have = available.get(room, {})
            season_proof = {s: (s in have and have[s]['render']) for s in seasons}
            any_proof = any(season_proof.values())

            if is_noproof:
                status, reason = 'NO_PROOF', (
                    'room %s sans rendu ni collision : le Ground reconverti '
                    'n existe pas' % room)
            elif is_held_sp:
                status, reason = 'HELD', (
                    'espece en attente : toutes ses occurrences source sont '
                    'dans des rooms NO_PROOF (rmcave1*)')
            elif not any_proof:
                status, reason = 'HELD', (
                    'variante(s) %s de %s non convertie(s)/non rendue(s) : le '
                    'terrain saisonnier est inconnu, le placement d ete ne '
                    'prouve rien pour cette saison'
                    % ('/'.join(seasons), room))
            else:
                status, reason = 'READY', ''

            cells, biomes = [], {}
            for m in col['members']:
                x, y = m['cell']
                cells.append({'cell': [x, y], 'px': m['px']})
                if terr:
                    b = T_NAMES[terr[y][x]]
                    biomes[b] = biomes.get(b, 0) + 1

            rels = relations_of(sp)
            can_duel = any(sp in p for p in duel_pairs)

            entries.append({
                'species': sp, 'room': room, 'colony': ci,
                'individuals': len(col['members']),
                'biome_summer_reference': biomes,
                'habitat_declared': sdef.get('habitat'),
                'seasons': seasons,
                'season_density': cdef.get('seasons'),
                'time_of_day': cdef.get('time'),
                'weather': cdef.get('weather'),
                'terrain_proof_by_season': season_proof,
                'candidate_positions': cells[:4],
                'candidate_count': len(cells),
                'behaviour_profile': sdef.get('profile'),
                'behaviour_desc': prof.get('desc'),
                'interactions': rels,
                'can_wild_duel': can_duel,
                'status': status, 'reason': reason,
                'context_note': cdef.get('note'),
            })

    by_status = {}
    for e in entries:
        by_status.setdefault(e['status'], []).append(e)
    totals = {k: sum(x['individuals'] for x in v) for k, v in by_status.items()}

    out = {
        'schema': 'nnv-held-audit-v1',
        'policy': ('fail-closed : une entite ne devient READY que si la variante '
                   'de Ground de SA saison est convertie ET rendue'),
        'ground_variants_available': {r: sorted(s) for r, s in sorted(available.items())},
        'totals_individuals': totals,
        'totals_entries': {k: len(v) for k, v in by_status.items()},
        'entries': entries,
    }
    Path(ns.out).write_text(json.dumps(out, indent=1, ensure_ascii=False) + '\n')

    print('=== AUDIT DES HELD ===')
    if not available:
        print('AUCUNE variante de Ground disponible (%s absent)' % ns.reconv)
    for st in ('READY', 'HELD', 'NO_PROOF'):
        n = totals.get(st, 0)
        print('%-9s %4d individus / %3d colonies'
              % (st, n, len(by_status.get(st, []))))
    print()
    agg = {}
    for e in entries:
        k = (e['species'], e['status'])
        agg[k] = agg.get(k, 0) + e['individuals']
    for (sp, st), n in sorted(agg.items(), key=lambda kv: (-kv[1], kv[0])):
        print('  %-12s %-9s %3d' % (sp, st, n))
    print('\necrit', ns.out)
    return 0


if __name__ == '__main__':
    sys.exit(main())
