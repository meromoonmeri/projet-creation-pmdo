#!/usr/bin/env python3
# =============================================================================
# gen_relais.py — relais/points medians assortis au biome de leur donjon.
#
#   python3 tools/mapgen/gen_relais.py assortir --ground NOM [--zone ZONE]
#       Remplace EN PLACE les autotiles du ground par le triplet canonique
#       de son donjon (tools/mapgen/data/tilesets_donjons.json). Les cellules
#       gardent leur NeighborCode et le tri (floor<->floor, wall<->wall,
#       secondary<->secondary) : la topologie du camp n'est JAMAIS touchee,
#       ni les entites, ni la musique. Refus si le relais est deja coherent.
#
#   python3 tools/mapgen/gen_relais.py lister
#       Tableau de coherence relais <-> donjon (audit, aucune ecriture).
#
# Template de reference : searing_tunnel_midpoint (magma_cavern_2 <-> donjon
# searing_tunnel en magma_cavern_2 — le seul relais deja conforme par nature).
# vast_steppe_midpoint et crooked_cavern_midpoint : DEJA COHERENTS, NE PAS
# TOUCHER (CliffCamp<->steppe, CaveStop<->caverne — directive utilisateur).
# =============================================================================
import json, os, sys, argparse, copy

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, '..', '..'))

# Relais -> donjon de provenance (mesure par audit 2026-07-29)
RELAIS = {
    'celestial_peak_relay': 'celestial_peak',
    'cloven_ruins_midpoint': 'cloven_ruins',
    'crooked_cavern_midpoint': 'crooked_cavern',     # DEJA COHERENT (CaveStop)
    'crystal_sanctuary_relay': 'crystal_sanctuary',
    'forgotten_marsh_relay': 'forgotten_marsh',
    'gloomy_forest_midpoint': 'gloomy_forest',
    'mount_windswept_midpoint': 'mount_windswept',
    'searing_tunnel_midpoint': 'searing_tunnel',     # LE TEMPLATE (magma)
    'vast_steppe_midpoint': 'vast_steppe',           # DEJA COHERENT (CliffCamp)
}
PROTEGES = {'crooked_cavern_midpoint', 'vast_steppe_midpoint'}  # directive user

# Relais new_era_sky_detectes automatiquement : new_era_sky_XX_relais -> new_era_sky_XX
import glob as _glob
for _p in sorted(_glob.glob(os.path.join(
        os.path.normpath(os.path.join(HERE, '..', '..')),
        'Data', 'Ground', 'new_era_sky_*_relais.rsground'))):
    _g = os.path.basename(_p)[:-9]
    RELAIS[_g] = _g.replace('_relais', '')


def load_db():
    ts = json.load(open(os.path.join(HERE, 'data', 'tilesets_donjons.json'),
                       encoding='utf-8'))['tilesets']
    bio = json.load(open(os.path.join(HERE, 'data', 'biomes_zones.json'),
                        encoding='utf-8'))['zones']
    return ts, bio


def ground_path(nom):
    return os.path.join(ROOT, 'Data', 'Ground', f'{nom}.rsground')


def autotiles_du(o):
    compte = {}
    for lay in o.get('Layers', []):
        for col in lay.get('Tiles', []):
            for cell in col:
                a = cell.get('AutoTileset', '')
                if a:
                    compte[a] = compte.get(a, 0) + 1
    return compte


def triplets_de_zone(ts, bio, zone):
    """Tous les triplets valides du donjon (un par tileset de segment)."""
    out = []
    for seg in bio[zone]['segments']:
        for t in seg['tilesets']:
            d = ts.get(t)
            if d and d['wall']:
                tr = (t, d['wall'], d['water_wall'] or d['wall'])
                if tr not in out:
                    out.append(tr)
    if not out:
        sys.exit(f'Aucun triplet valide pour le donjon {zone}')
    return out


def triplet_de_zone(ts, bio, zone):
    """Triplet canonique = le 1er du donjon (ordre des segments)."""
    return triplets_de_zone(ts, bio, zone)[0]


def cmd_lister(a):
    ts, bio = load_db()
    print(f'{"relais":32s} {"autotiles actuels":38s} {"triplets du donjon":44s} verdict')
    for g, z in RELAIS.items():
        o = json.load(open(ground_path(g), encoding='utf-8-sig'))['Object']
        autos = set(autotiles_du(o))
        attendus = triplets_de_zone(ts, bio, z)
        canonique = attendus[0][0]
        if not autos:
            verdict = 'visuel dedie (feuilles Content/Tile) — hors swap'
        else:
            ok = any(autos <= set(tr) for tr in attendus)
            verdict = 'COHERENT' if ok else 'A CORRIGER -> ' + canonique
            if g in PROTEGES:
                verdict += ' (PROTEGE : ne pas toucher)'
        print(f'{g:32s} {",".join(sorted(autos)) or "(feuilles)":38s} '
              f'{"|".join(t[0] for t in attendus):44s} {verdict}')
    return 0


def cmd_assortir(a):
    ts, bio = load_db()
    zone = a.zone or RELAIS.get(a.ground)
    if not zone:
        sys.exit(f'{a.ground} n est pas un relais connu (voir lister) : '
                 f'preciser --zone')
    if a.ground in PROTEGES and not a.force:
        sys.exit(f'REFUS : {a.ground} est PROTEGE (deja coherent — directive '
                 f'utilisateur vast_steppe & crooked_cavern). --force pour forcer.')
    attendus = triplets_de_zone(ts, bio, zone)
    tir, mur, sec = attendus[0]
    p = ground_path(a.ground)
    root = json.load(open(p, encoding='utf-8-sig'))
    o = root['Object']
    autos = autotiles_du(o)
    if not autos:
        sys.exit(f'{a.ground} n utilise pas d autotiles (visuel dedie par '
                 f'feuilles) : rien a swapper.')
    if any(set(autos) <= set(tr) for tr in attendus):
        print(f'{a.ground} : DEJA coherent avec {zone} '
              f'({sorted(autos)}). Rien a faire.')
        return 0
    # famille detectee : suffixe _floor/_wall/_secondary
    correspondance = {}
    for name in autos:
        if name.endswith('_floor'):
            correspondance[name] = tir
        elif name.endswith('_wall'):
            correspondance[name] = mur
        elif name.endswith('_secondary'):
            correspondance[name] = sec or mur
        else:
            sys.exit(f'autotile sans suffixe connu : {name}')
    if all(ancien == nouveau for ancien, nouveau in correspondance.items()):
        print(f'{a.ground} : DEJA coherent avec {zone} ({tir}). Rien a faire.')
        return 0
    n = 0
    for lay in o.get('Layers', []):
        for col in lay.get('Tiles', []):
            for cell in col:
                av = cell.get('AutoTileset', '')
                if av in correspondance:
                    cell['AutoTileset'] = correspondance[av]
                    n += 1
    o['Comment'] = (o.get('Comment', '').rstrip() +
                    f' | gen_relais assortir {zone} : triplet {tir} '
                    f'(etait {sorted(autos)})').strip(' |')
    text = '\ufeff' + json.dumps(root, ensure_ascii=False, indent=0)
    if a.ecrire:
        open(p, 'w', encoding='utf-8').write(text)
        print(f'ecrit {p} : {n} cellules {sorted(set(correspondance))} -> '
              f'({tir}, {mur}, {sec}) [triplet de {zone}]')
        print('Puis : python3 tools/mapgen/gen_map.py check '
              f'--cible Data/Ground/{a.ground}.rsground')
    else:
        print(f'(--ecrire pour materialiser) {n} cellules a convertir :')
        for av, nv in correspondance.items():
            print(f'  {av:28s} -> {nv}')
    return 0


def main():
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    sp = p.add_subparsers(dest='cmd', required=True)
    sp.add_parser('lister').set_defaults(f=cmd_lister)
    g = sp.add_parser('assortir')
    g.add_argument('--ground', required=True)
    g.add_argument('--zone')
    g.add_argument('--force', action='store_true')
    g.add_argument('--ecrire', action='store_true')
    g.set_defaults(f=cmd_assortir)
    a = p.parse_args()
    sys.exit(a.f(a))


if __name__ == '__main__':
    main()
