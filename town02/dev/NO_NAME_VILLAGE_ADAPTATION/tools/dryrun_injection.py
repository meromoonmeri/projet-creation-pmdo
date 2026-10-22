#!/usr/bin/env python3
"""DRY-RUN de l'injection de la faune. N'ECRIT RIEN dans Data/ ni Content/.

Produit le plan d'injection exhaustif :
  - liste exacte des fichiers qui seraient crees/modifies, avec taille estimee
  - nombre de Pokemon par room, especes, placements
  - rooms promues / retenues / sans preuve
  - especes en attente (Cradily, ...)
  - .rsmap de duel concernees et leur planche .tile
  - modifications NNVLife / index.idx
  - plan de sauvegarde et de rollback
  - resultat des gardes anti-regression et des validations pixel-perfect

Le seul effet de bord autorise : ecrire le rapport dans reports/.
"""
from __future__ import annotations
import argparse, glob, gzip, hashlib, json, os, subprocess, sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
NNV = ROOT / 'NO_NAME_VILLAGE_ADAPTATION'
ECO = NNV / 'reports/fauna-ecology'

# poids mesures sur les artefacts reellement produits
BYTES_PER_ENTITY = 2650      # une entree GroundChar serialisee dans un .rsground
DUEL_MAP_BYTES = 146_913     # mesure : nnv_duel_rm83_summer.rsmap
DUEL_TILE_BYTES = 46_999     # mesure : NNV_Duel_Rm83_Summer.tile
SEASONS = ('spring', 'summer', 'autumn', 'winter')


def sh(cmd):
    p = subprocess.run(cmd, shell=True, capture_output=True, text=True, cwd=str(ROOT))
    return p.returncode, (p.stdout + p.stderr).strip()


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--reconv', default='/tmp/reconv')
    ap.add_argument('--candidates', default='/tmp/duelcand')
    ap.add_argument('--out', default=str(ECO / 'dryrun-injection.json'))
    ap.add_argument('--skip-guards', action='store_true')
    ns = ap.parse_args()

    ev = json.load(open(ECO / 'evidence-classification.json'))
    place = json.load(gzip.open(ECO / 'fauna-placement.json.gz'))
    spec = json.load(open(NNV / 'config/fauna-species.json'))

    proven = set(ev['rooms_by_evidence']['PROVEN'])
    noproof = set(ev['rooms_by_evidence']['NO_PROOF'])
    partial = set(ev['rooms_by_evidence']['PARTIAL'])

    # ---------------- fichiers Ground qui seraient modifies ----------------
    ground_plan = []
    total_entities = 0
    for room in sorted(proven):
        rd = place['rooms'].get(room)
        if not rd or not rd['individuals']:
            continue
        by_species = {}
        for c in rd['colonies']:
            by_species[c['species']] = by_species.get(c['species'], 0) + len(c['members'])
        # une room a jusqu'a 4 variantes saisonnieres ; on ne touche que celles
        # qui existent reellement dans /tmp/reconv
        for season in SEASONS:
            p = Path(ns.reconv) / room / 'Data/Ground' / f'nnv_{room}_{season}.rsground'
            if not p.exists():
                continue
            # combien d'individus sont presents a cette saison
            n = 0
            for c in rd['colonies']:
                seasons = c.get('seasons') or list(SEASONS)
                if season in seasons:
                    n += len(c['members'])
            if n == 0:
                continue
            total_entities += n
            ground_plan.append({
                'file': str(p.relative_to(Path(ns.reconv))),
                'absolute': str(p),
                'room': room, 'season': season,
                'action': 'MODIFY (ajout d entites GroundChar)',
                'current_bytes': p.stat().st_size,
                'entities_added': n,
                'estimated_delta_bytes': n * BYTES_PER_ENTITY,
                'species': dict(sorted(by_species.items())),
            })

    # ---------------- scripts Lua ----------------
    lua_plan = [
        {'file': 'Data/Script/halcyon/NNVEcology.lua', 'action': 'CREATE',
         'source': 'NO_NAME_VILLAGE_ADAPTATION/generated/fauna/NNVEcology.lua',
         'bytes': (NNV / 'generated/fauna/NNVEcology.lua').stat().st_size,
         'why': 'moteur de vie autonome (profils, relations, budget CPU)'},
        {'file': 'Data/Script/halcyon/NNVDuel.lua', 'action': 'CREATE',
         'source': 'NO_NAME_VILLAGE_ADAPTATION/generated/fauna/NNVDuel.lua',
         'bytes': (NNV / 'generated/fauna/NNVDuel.lua').stat().st_size,
         'why': 'bascule Ground -> .rsmap de duel et retour'},
    ]
    nnvlife = NNV / 'generated/rmvillage/life/NNVLife.lua'
    if nnvlife.exists():
        lua_plan.append({
            'file': 'Data/Script/halcyon/NNVLife.lua',
            'action': 'MODIFY (appel de NNVEcology depuis Update/Setup)',
            'bytes': nnvlife.stat().st_size,
            'estimated_delta_bytes': 420,
            'why': ('NNVLife gere deja les PNJ sociaux et les 12 objbird0 / 19 '
                    'objbutterfly1 de rmvillage ; ces groupes doivent passer sous '
                    'NNVEcology pour ne pas etre pilotes deux fois'),
            'conflict': ('NNVLife.GROUPS contient source_birds (12) et '
                         'source_butterflies (19) qui recouvrent exactement les '
                         'occurrences objbird0/objbutterfly1 de rmvillage : '
                         'a retirer de NNVLife lors de l injection'),
        })

    # ---------------- maps de duel ----------------
    duel_plan = []
    cand = Path(ns.candidates)
    if cand.exists():
        for m in sorted(cand.glob('nnv_duel_*.rsmap')):
            stem = m.stem
            room = stem.split('_')[2]
            proof_p = m.with_name(stem + '_proof.json')
            proof = json.load(open(proof_p)) if proof_p.exists() else {}
            sheet = 'NNV_Duel_%s_%s' % (room.capitalize(),
                                        stem.split('_')[3].capitalize())
            duel_plan.append({
                'map_file': 'Data/Map/%s.rsmap' % stem,
                'action': 'CREATE',
                'bytes': m.stat().st_size,
                'tile_sheet_file': 'Content/Tile/%s.tile' % sheet,
                'tile_sheet_bytes': (cand / (sheet + '.tile')).stat().st_size
                                    if (cand / (sheet + '.tile')).exists() else 0,
                'room': room,
                'window_px': proof.get('window_px'),
                'origin_px': proof.get('origin_px'),
                'distinct_tiles': proof.get('distinct_tiles'),
                'pixel_identical': proof.get('pixel_identical'),
                'index_idx': ('AJOUT OBLIGATOIRE de la planche %s dans '
                              'Content/Tile/index.idx, sinon damier mauve '
                              '(GraphicsManager.GetTile: tilePos==0 -> '
                              'BaseSheet.LoadError)' % sheet),
            })

    # ---------------- index.idx ----------------
    idx_path = ROOT / 'Content/Tile/index.idx'
    index_plan = {
        'file': 'Content/Tile/index.idx',
        'action': 'MODIFY (ajout de %d planche(s))' % len(duel_plan),
        'current_bytes': idx_path.stat().st_size if idx_path.exists() else 0,
        'estimated_delta_bytes': sum(
            1 + len('NNV_Duel_Xxxx_Summer') + 8 + (d.get('distinct_tiles') or 0) * 16
            for d in duel_plan),
        'why': ('GraphicsManager.GetTile (l.1152) appelle '
                'TileIndex.GetPosition(Sheet, TexLoc) ; TileGuide.GetPosition '
                'renvoie 0 si la planche est inconnue et TileIndexNode.GetPosition '
                'renvoie 0 si le TexLoc est inconnu. tilePos==0 => '
                'BaseSheet.LoadError() => damier mauve/noir.'),
        'guard': 'NO_NAME_VILLAGE_ADAPTATION/tools/verify_tile_index.py',
    }

    # ---------------- zone de duel ----------------
    zone_plan = [{
        'file': 'Data/Zone/nnv_wild.json', 'action': 'CREATE',
        'why': 'zone hote des duels sauvages, segments IsRelevant=false',
        'segments': len(duel_plan),
        'estimated_bytes': 1200 + 600 * len(duel_plan),
    }, {
        'file': 'Data/Zone/index.idx', 'action': 'MODIFY (resynchronisation)',
        'why': 'toute nouvelle zone doit etre declaree dans l index des zones',
        'estimated_delta_bytes': 260,
    }]

    # ---------------- gardes ----------------
    guards = {}
    if not ns.skip_guards:
        rc, out = sh('python3 NO_NAME_VILLAGE_ADAPTATION/test_fauna_ecology.py')
        guards['ecology_suite'] = {'exit': rc, 'tail': out.splitlines()[-3:]}
        rc, out = sh('python3 NO_NAME_VILLAGE_ADAPTATION/tools/verify_duel_pixel_identity.py '
                     '--candidates %s' % ns.candidates)
        guards['duel_pixel_identity'] = {'exit': rc, 'tail': out.splitlines()[-3:]}
        rc, out = sh('python3 NO_NAME_VILLAGE_ADAPTATION/tools/verify_tile_index.py '
                     'Data/Map/metano_raid_1.rsmap')
        guards['tile_index_damier'] = {'exit': rc, 'tail': out.splitlines()[-2:]}

    # ---------------- totaux ----------------
    ground_bytes = sum(g['estimated_delta_bytes'] for g in ground_plan)
    duel_bytes = sum(d['bytes'] + d['tile_sheet_bytes'] for d in duel_plan)
    lua_bytes = sum(l.get('bytes', 0) for l in lua_plan)
    zone_bytes = sum(z.get('estimated_bytes', 0) + z.get('estimated_delta_bytes', 0)
                     for z in zone_plan)
    idx_bytes = index_plan['estimated_delta_bytes']

    # ---------------- couverture saisonniere ----------------
    seasons_present = sorted({g['season'] for g in ground_plan})
    seasonal_gap = {}
    for room in sorted(proven):
        rd = place['rooms'].get(room)
        if not rd:
            continue
        for c in rd['colonies']:
            cs = c.get('seasons') or list(SEASONS)
            if not (set(cs) & set(seasons_present)):
                seasonal_gap[c['species']] = seasonal_gap.get(c['species'], 0) \
                    + len(c['members'])

    # ---------------- reconciliation exhaustive ----------------
    T_NAMES = {0:'blocked',1:'open',2:'grass',3:'water',4:'marsh',
               5:'tree',6:'rock',7:'cliff',8:'plant',9:'snow'}
    atlas = json.load(gzip.open(ECO / 'biome-atlas.json.gz'))['rooms']

    per_room, per_species, per_season, per_biome = {}, {}, {}, {}
    injected_names = set()
    for room in sorted(proven):
        rd = place['rooms'].get(room)
        if not rd:
            continue
        terr = atlas[room]['terrain']
        for c in rd['colonies']:
            cs = c.get('seasons') or list(SEASONS)
            active = sorted(set(cs) & set(seasons_present))
            n = len(c['members'])
            if not active:
                continue
            per_room[room] = per_room.get(room, 0) + n
            per_species[c['species']] = per_species.get(c['species'], 0) + n
            for s in active:
                per_season[s] = per_season.get(s, 0) + n
            for m in c['members']:
                x, y = m['cell']
                b = T_NAMES[terr[y][x]]
                per_biome[b] = per_biome.get(b, 0) + 1
                injected_names.add('%s:%d,%d' % (room, x, y))

    # double pilotage : NNVLife ne doit plus posseder d'individus de NNVEcology
    import re as _re
    dual = []
    for lf in glob.glob(str(NNV / 'generated/**/NNVLife.lua'), recursive=True):
        t = open(lf, encoding='utf-8').read()
        if _re.search(r'source_(birds|butterflies)\s*=', t):
            dual.append(os.path.relpath(lf, NNV))
        for ent in ('NNV_SourceBird_', 'NNV_SourceButterfly_'):
            if ent in t:
                dual.append('%s contient %s' % (os.path.relpath(lf, NNV), ent))

    reconciliation = {
        'individuals_placed_total': ev['totals']['individuals_placed'],
        'promotable': ev['totals']['individuals_promotable'],
        'injected': sum(per_room.values()),
        'held_no_proof': ev['totals']['individuals_withheld'],
        'held_missing_season': sum(seasonal_gap.values()),
        'held_species': {s: ev['species'][s]['placed_total'] for s in ev['held_species']},
        'by_room': dict(sorted(per_room.items(), key=lambda kv: -kv[1])),
        'by_species': dict(sorted(per_species.items(), key=lambda kv: -kv[1])),
        'by_season': per_season,
        'by_biome': dict(sorted(per_biome.items(), key=lambda kv: -kv[1])),
        'unique_cells': len(injected_names),
        'dual_control_violations': dual,
        'balance_check': (sum(per_room.values()) + sum(seasonal_gap.values())
                          + ev['totals']['individuals_withheld']
                          == ev['totals']['individuals_placed']),
    }

    out = {
        'schema': 'nnv-fauna-dryrun-v1',
        'mode': 'DRY-RUN — aucune ecriture dans Data/ ni Content/',
        'evidence_policy': ev['policy'],
        'seasonal_coverage': {
            'variants_available_in_reconv': seasons_present,
            'note': ('Seules les variantes de Ground reellement presentes dans '
                     '/tmp/reconv peuvent recevoir des entites. Les especes dont '
                     'aucune saison declaree n est disponible ne sont PAS '
                     'injectees : elles ne sont ni perdues ni deplacees, elles '
                     'attendent la reconversion des variantes manquantes.'),
            'withheld_for_missing_season': dict(sorted(seasonal_gap.items())),
            'withheld_total': sum(seasonal_gap.values()),
        },
        'rooms': {
            'proven_injectable': sorted(proven),
            'partial_blocked': sorted(partial),
            'no_proof_failclosed': sorted(noproof),
        },
        'held_species': {
            s: ev['species'][s] for s in ev['held_species']
        },
        'files': {
            'grounds': ground_plan,
            'lua': lua_plan,
            'duel_maps': duel_plan,
            'tile_index': index_plan,
            'zones': zone_plan,
        },
        'totals': {
            'ground_files_modified': len(ground_plan),
            'entities_injected': total_entities,
            'individuals_promotable': ev['totals']['individuals_promotable'],
            'individuals_withheld': ev['totals']['individuals_withheld'],
            'lua_files': len(lua_plan),
            'duel_maps': len(duel_plan),
            'zone_files': len(zone_plan),
            'estimated_bytes': {
                'grounds_delta': ground_bytes,
                'duel_maps_and_sheets': duel_bytes,
                'lua': lua_bytes,
                'zones': zone_bytes,
                'tile_index_delta': idx_bytes,
                'total': ground_bytes + duel_bytes + lua_bytes + zone_bytes + idx_bytes,
            },
        },
        'backup_rollback': {
            'strategy': [
                'Les Grounds reconvertis vivent dans /tmp/reconv (hors depot) : '
                'l injection ecrit des copies, l original reste intact.',
                'Avant toute ecriture dans le depot : git tag pre-fauna-injection '
                'sur le HEAD courant.',
                'Chaque fichier modifie est copie en <fichier>.pre-fauna.bak et '
                'son sha256 consigne dans reports/fauna-ecology/rollback-manifest.json.',
                'Content/Tile/index.idx est sauvegarde entier avant modification '
                '(23,5 Mo) : c est le seul fichier partage a risque.',
                'Rollback : git checkout <tag> -- Data/ Content/ , puis '
                'verify_tile_index.py pour confirmer l absence de damier.',
            ],
            'irreversible_without_backup': ['Content/Tile/index.idx',
                                            'Data/Zone/index.idx'],
        },
        'reconciliation': reconciliation,
        'guards': guards,
    }

    os.makedirs(os.path.dirname(ns.out), exist_ok=True)
    open(ns.out, 'w').write(json.dumps(out, indent=1, ensure_ascii=False) + '\n')

    t = out['totals']
    print('=== DRY-RUN INJECTION FAUNE ===')
    print('rooms injectables : %d | bloquees PARTIAL : %d | FAIL-CLOSED : %d'
          % (len(proven), len(partial), len(noproof)))
    print('entites injectees : %d (sur %d individus promouvables)'
          % (t['entities_injected'], t['individuals_promotable']))
    print('individus retenus : %d' % t['individuals_withheld'])
    print('especes en attente : %s' % ', '.join(ev['held_species']))
    sc = out['seasonal_coverage']
    print('variantes de Ground disponibles : %s' % ', '.join(sc['variants_available_in_reconv']))
    print('individus differes faute de variante saisonniere : %d %s'
          % (sc['withheld_total'], sc['withheld_for_missing_season']))
    print('fichiers Ground modifies : %d' % t['ground_files_modified'])
    print('maps de duel creees : %d' % t['duel_maps'])
    print('poids total estime : %.1f Mo'
          % (t['estimated_bytes']['total'] / 1e6))
    r = out['reconciliation']
    print('--- reconciliation ---')
    print('places %d = injectes %d + hors-saison %d + sans-preuve %d  -> %s'
          % (r['individuals_placed_total'], r['injected'],
             r['held_missing_season'], r['held_no_proof'],
             'COHERENT' if r['balance_check'] else 'INCOHERENT'))
    print('cellules uniques : %d (doublon = %s)'
          % (r['unique_cells'], 'OUI' if r['unique_cells'] != r['injected'] else 'aucun'))
    print('par saison : %s' % r['by_season'])
    print('par biome  : %s' % r['by_biome'])
    print('especes injectees : %d | rooms : %d'
          % (len(r['by_species']), len(r['by_room'])))
    print('double pilotage : %s'
          % ('AUCUN' if not r['dual_control_violations'] else r['dual_control_violations']))
    for k, v in guards.items():
        print('garde %-22s exit=%d  %s' % (k, v['exit'], v['tail'][-1] if v['tail'] else ''))
    print('ecrit', ns.out)
    return 0


if __name__ == '__main__':
    sys.exit(main())
