#!/usr/bin/env python3
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
# =============================================================================
# gen_map.py — generateur/verificateur de maps a tileset coherent (New Era).
#
#   python3 tools/mapgen/gen_map.py tilesets <requete> [--element EL]
#       Recherche un triplet d'autotiles VALIDE (utilise par une zone du
#       depot). Aucune correspondance -> refus explicite (jamais d'approx).
#
#   python3 tools/mapgen/gen_map.py gen-etages --zone ID --nom-fr "Nom"
#       --etages N --tileset FLOOR [--element EL] [--musique F.ogg]
#       [--donneur ZONE] [--ecrire]
#       Genere Data/Zone/ID.json : 1 RangeDictSegment de N etages, en CLONANT
#       les GenSteps eprouves du donneur (on ne reinvente pas RogueElements,
#       on reparametre). Sans --ecrire : apercu seul.
#
#   python3 tools/mapgen/gen_map.py check --cible FICHIER
#       Validation avant sortie (zone .json OU ground .rsground) :
#       coherence tileset/biome, continuite des plages d'etages, gradient
#       d'elements entre segments, Bounds d'obstacles, bords bloques,
#       feuilles sans espaces et existantes, connexite de la zone marchable.
#
# Regles projet appliquees : preuve avant hypothese (tout est clone de ce qui
# existe), jamais de nom d'asset avec espaces, rien sans sortie verifiable.
# =============================================================================
import json, os, sys, copy, glob, argparse

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.normpath(os.path.join(HERE, '..', '..'))
DB_TS = os.path.join(HERE, 'data', 'tilesets_donjons.json')
DB_BIO = os.path.join(HERE, 'data', 'biomes_zones.json')
CONCEPTION = os.path.join(ROOT, 'docs', 'conception_donjons_segmentes.md')

ELEMENTS = ['normal', 'fire', 'water', 'electric', 'grass', 'ice', 'fighting',
            'poison', 'ground', 'flying', 'psychic', 'bug', 'rock', 'ghost',
            'dragon', 'dark', 'steel', 'fairy', 'none']
# Groupes de biome DERIVES des usages du depot (heuristique documentee,
# a remplacer par les fiches de conception_donjons_segmentes.md quand dispo).
GROUPES = {
    'feu': ['fire'],
    'eau': ['water', 'ice'],
    'plante': ['grass', 'bug'],
    'foudre': ['electric'],
    'sol': ['rock', 'ground', 'steel', 'fighting'],
    'tenebres': ['dark', 'ghost', 'poison', 'psychic'],
    'air': ['flying', 'dragon'],
    'lumiere': ['fairy', 'normal', 'none'],
}
ADJACENTS = {   # transitions de biome "lisibles" entre segments voisins
    'feu': ['sol', 'foudre'], 'eau': ['plante', 'lumiere'],
    'plante': ['eau', 'air', 'lumiere', 'sol'], 'foudre': ['feu', 'air', 'sol'],
    'sol': ['feu', 'plante', 'foudre', 'tenebres', 'air'],
    'tenebres': ['sol', 'plante'],
    'air': ['plante', 'foudre', 'sol', 'lumiere'],
    'lumiere': ['eau', 'plante', 'air'],
}


def load_db():
    if not os.path.exists(DB_TS):
        sys.exit('Base absente : lancer python3 tools/mapgen/extract_tileset_db.py')
    ts = json.load(open(DB_TS, encoding='utf-8'))['tilesets']
    bio = json.load(open(DB_BIO, encoding='utf-8'))['zones']
    return ts, bio


def groupe_of(el):
    for g, els in GROUPES.items():
        if el in els:
            return g
    return 'lumiere'


def note_conception():
    if not os.path.exists(CONCEPTION):
        print('NOTE : docs/conception_donjons_segmentes.md absent du depot — '
              'biomes INFERS des usages reels (tools/mapgen/data). '
              'Le jour ou la fiche arrive, elle prime.', file=sys.stderr)


# --------------------------------------------------------------------- tilesets
def cmd_tilesets(a):
    ts, _ = load_db()
    q = (a.requete or '').lower()
    hits = []
    for name, t in ts.items():
        hay = ' '.join([name, t['wall'], t['water_wall'], ' '.join(t['zones']),
                        ' '.join(t['elements'])]).lower()
        if q and not all(m in hay for m in q.split()):
            continue
        if a.element and a.element not in t['elements']:
            continue
        hits.append((name, t))
    print(f'{len(hits)} triplet(s) valide(s) pour "{a.requete}"'
          + (f' (element {a.element})' if a.element else ''))
    for name, t in hits[:12]:
        print(f'\n  {name}\n    mur: {t["wall"]} | secondaire: {t["water_wall"]}')
        print(f'    elements vus: {", ".join(t["elements"])} | zones: {", ".join(t["zones"])}')
        print(f'    musiques vues: {", ".join(t["musiques"][:3])}')
    if not hits:
        print('\nREFUS EXPLICITE : aucun tileset valide du projet ne correspond '
              'a ce biome. Ne pas forcer un tileset approximant — soit la fiche '
              'de biome change, soit un tileset legitime (DumpAsset/RawAsset) '
              'doit etre importe puis re-extrait.', file=sys.stderr)
        return 2
    return 0


# ------------------------------------------------------------------- gen-etages
def premier_noeud_rangedict(zone):
    z = json.load(open(os.path.join(ROOT, 'Data', 'Zone', f'{zone}.json'),
                       encoding='utf-8-sig'))['Object']
    for seg in z['Segments']:
        if seg.get('$type', '').endswith('RangeDictSegment, RogueEssence'):
            nodes = seg['Floors']['nodes']
            if nodes:
                return z, seg, nodes[0]
    sys.exit(f'Aucun RangeDictSegment dans {zone}.json')


def patch_texture(o, triplet, element, musique):
    """Remplace MapTextureStep (triplet+element) et Music, en place."""
    if isinstance(o, dict):
        t = o.get('$type', '')
        if 'MapTextureStep' in t:
            o['GroundTileset'] = triplet[0]
            o['BlockTileset'] = triplet[1]
            o['WaterTileset'] = triplet[2]
            if element:
                o['GroundElement'] = element
        if 'MapDataStep' in t and musique:
            o['Music'] = musique
        for v in o.values():
            patch_texture(v, triplet, element, musique)
    elif isinstance(o, list):
        for v in o:
            patch_texture(v, triplet, element, musique)


def cmd_gen_etages(a):
    ts, _ = load_db()
    note_conception()
    if a.tileset not in ts:
        sys.exit(f'REFUS : "{a.tileset}" n est pas un tileset valide du projet. '
                 f'Voir : python3 tools/mapgen/gen_map.py tilesets <requete>')
    t = ts[a.tileset]
    triplet = (a.tileset, t['wall'], t['water_wall'])
    element = a.element or (t['elements'][0] if t['elements'] else 'normal')
    musique = a.musique or (t['musiques'][0] if t['musiques'] else None)
    _, seg, node0 = premier_noeud_rangedict(a.donneur)
    seg = copy.deepcopy(seg)
    node0 = copy.deepcopy(node0)

    floor_gen = copy.deepcopy(node0['Item'])
    patch_texture(floor_gen, triplet, element, musique)
    node = {'Item': floor_gen, 'Range': {'Min': 0, 'Max': a.etages}}
    seg['Floors'] = {'nodes': [node]}
    seg['Comment'] = (f'{a.nom_fr} : {a.etages} etages generes par gen_map '
                      f'(tileset {a.tileset}, donneur {a.donneur})')
    # ZoneSteps du donneur : on NE clone PAS (spreads scriptes propres a sa quete)
    seg.pop('ZoneSteps', None)

    zout = {
        '$type': 'RogueEssence.Data.ZoneData, RogueEssence',
        'Name': {'DefaultText': a.nom_fr, 'LocalTexts': {'fr': a.nom_fr}},
        'Released': False,
        'Comment': (f'Zone generee par tools/mapgen/gen_map.py. '
                    f'Tileset valide {a.tileset} ({triplet[1]}/{triplet[2]}), '
                    f'element {element}. ATTENTION : les pools de spawns sont '
                    f'HERITIS du donneur {a.donneur} — a remplacer selon les '
                    f'pools du biome (conception_donjons_segmentes.md).'),
        'NoEXP': False, 'ExpPercent': 100, 'Level': 1, 'LevelCap': 0,
        'KeepSkills': False, 'TeamRestrict': 0, 'TeamSize': 4,
        'MoneyRestrict': False, 'BagRestrict': 0, 'KeepTreasure': False,
        'BagSize': 0, 'Persistent': False, 'Rescues': 0, 'Rogue': 0,
        'Segments': [seg], 'GroundMaps': [],
    }
    text = '\ufeff' + json.dumps({'Version': '0.8.9.0', 'Object': zout},
                                 ensure_ascii=False, indent=1)
    n_spawns = json.dumps(floor_gen).count('"MobSpawn') + json.dumps(floor_gen).count('"PlaceRandomMobs')
    print(f'zone "{a.zone}" : 1 RangeDictSegment, etages 0..{a.etages}, '
          f'tileset {a.tileset} (element {element}), musique {musique}')
    print(f'AVERTISSEMENT : pools de spawns herites du donneur {a.donneur} '
          f'({n_spawns} etapes de spawn) — a retravailler pour le biome vise.')
    if a.ecrire:
        out = os.path.join(ROOT, 'Data', 'Zone', f'{a.zone}.json')
        if os.path.exists(out):
            sys.exit(f'REFUS : {out} existe deja (jamais d ecrasement).')
        open(out, 'w', encoding='utf-8').write(text)
        print(f'ecrit {out} ({len(text)} octets, BOM UTF-8).')
        print('RAPPEL : enregistrement manuel dans master_zone.json/index.idx '
              '+ boucle de validation (voir docs/outil_generation_maps.md).')
    else:
        print('(--ecrire pour materialiser le fichier)')
    return 0


# ------------------------------------------------------------------------ check
def c_ok(msg): print('  [OK]   ' + msg)
def c_warn(msg): print('  [WARN] ' + msg)
def c_fail(msg): print('  [FAIL] ' + msg)


def check_zone(path):
    ts, _ = load_db()
    z = json.load(open(path, encoding='utf-8-sig'))['Object']
    name = z.get('Name', {}).get('DefaultText', os.path.basename(path))
    print(f'ZONE {os.path.basename(path)} — "{name}"')
    rc = 0
    seg_types = [s.get('$type', '').split('.')[-1].split(',')[0]
                 for s in z['Segments']]
    c_ok(f'{len(seg_types)} segments : {", ".join(seg_types)}')
    # 1) tilesets valides + triplet complet
    import re
    for i, seg in enumerate(z['Segments']):
        txt = json.dumps(seg, ensure_ascii=False)
        floors = set(re.findall(r'"GroundTileset":\s*"([^"]*)"', txt))
        for v in sorted(floors):
            if v not in ts:
                c_fail(f'seg {i} : tileset inconnu/non valide "{v}"'); rc = 1
                continue
            t = ts[v]
            mur_ok = not t['wall'] or f'"{t["wall"]}"' in txt
            sec_ok = not t['water_wall'] or f'"{t["water_wall"]}"' in txt
            if mur_ok and sec_ok:
                c_ok(f'seg {i} : tileset valide "{v}" (triplet complet)')
            else:
                c_warn(f'seg {i} : "{v}" sans mur/secondaire canonique '
                       f'(attendu {t["wall"]}/{t["water_wall"]})')
    # 2) continuite des plages
    for i, seg in enumerate(z['Segments']):
        nodes = (seg.get('Floors') or {})
        nodes = nodes.get('nodes', []) if isinstance(nodes, dict) else []
        if not nodes:
            continue
        plages = sorted((n['Range']['Min'], n['Range']['Max']) for n in nodes)
        cursor, ok_ranges = 0, True
        for lo, hi in plages:
            if lo != cursor:
                ok_ranges = False; break
            cursor = hi
        (c_ok if ok_ranges else c_fail)(
            f'seg {i} : plages {[list(p) for p in plages]} '
            + ('continues depuis 0' if ok_ranges else 'TROU/CHEVAUCHEMENT'))
        rc |= 0 if ok_ranges else 1
    # 3) gradient d'elements entre segments proceduraux voisins
    els_seq = []
    for seg in z['Segments']:
        els = set(re.findall(r'"GroundElement":\s*"([^"]*)"', json.dumps(seg)))
        els_seq.append(sorted(els))
    for i in range(1, len(els_seq)):
        if not els_seq[i] or not els_seq[i - 1]:
            continue
        ga = {groupe_of(e) for e in els_seq[i - 1]}
        gb = {groupe_of(e) for e in els_seq[i]}
        saut = all(b not in ADJACENTS.get(a, []) and b != a
                   for a in ga for b in gb)
        if saut:
            c_warn(f'segments {i-1}->{i} : saut de biome {els_seq[i-1]} -> '
                   f'{els_seq[i]} (gradient a justifier narrativement)')
    # 4) spawns : presence
    n = json.dumps(z).count('PlaceRandomMobsStep')
    (c_ok if n else c_warn)(f'{n} etape(s) de spawn de monstres')
    return rc


def check_ground(path):
    root = json.load(open(path, encoding='utf-8-sig'))['Object']
    print(f'GROUND {os.path.basename(path)} — '
          f'"{root.get("Name", {}).get("DefaultText", "")}"')
    rc = 0
    ts = root['TexSize'] * 8          # TexSize 1->8px, 2->16px, 3->24px (prouve)
    W, H = len(root['obstacles']), len(root['obstacles'][0])
    c_ok(f'{W}x{H} cellules @{ts}px = {W*ts}x{H*ts}px, TexSize {root["TexSize"]}')
    # 1) feuilles : sans espaces + existantes ; autotiles : repertories
    sheets = set()
    autos = {}
    for lay in root['Layers']:
        for col in lay['Tiles']:
            for cell in col:
                a = cell.get('AutoTileset', '')
                if a:
                    autos[a] = autos.get(a, 0) + 1
                for L in cell['Layers']:
                    for fr in L['Frames']:
                        sheets.add(fr['Sheet'])
    for s in sorted(sheets):
        if ' ' in s:
            c_fail(f'feuille avec ESPACES (jamais chargee en jeu) : "{s}"'); rc = 1
        elif not os.path.exists(os.path.join(ROOT, 'Content', 'Tile', f'{s}.tile')):
            c_fail(f'feuille absente de Content/Tile : "{s}"'); rc = 1
    c_ok(f'{len(sheets)} feuille(s) : {", ".join(sorted(sheets)) or "aucune"}')
    if autos:
        try:
            ts_db, _ = load_db()
            valides = set(ts_db)
            for t in ts_db.values():
                valides.add(t['wall']); valides.add(t['water_wall'])
            valides.discard('')
            for nom, nb in sorted(autos.items()):
                if nom in valides:
                    c_ok(f'autotile valide "{nom}" x{nb}')
                else:
                    c_fail(f'autotile INCONNU des triplets valides : '
                           f'"{nom}" x{nb}'); rc = 1
        except SystemExit:
            c_warn('base tilesets absente — autotiles non verifies')
    # 2) Bounds — taille de cellule deduite du 1er obstacle (peut etre < TS,
    #    ex. relais autotiles : grille d'obstacles 8px sur tuiles 24px)
    tso = root['obstacles'][0][0]['Bounds']['Width']
    bad = sum(1 for x in range(W) for y in range(H)
              if root['obstacles'][x][y]['Bounds'] != {
                  'X': x * tso, 'Y': y * tso, 'Width': tso, 'Height': tso})
    (c_ok if bad == 0 else c_fail)(
        f'Bounds @{tso}px : {bad} cellule(s) incoherente(s)')
    rc |= bad != 0
    ts = tso   # la connectivite se raisonne sur la grille d'obstacles
    # 3) bords : test applique a la composante du joueur (voir plus bas)
    # 4) connexite : flood-fill depuis le 1er point marchable
    walk = [[root['obstacles'][x][y]['Tags'] == 0 for y in range(H)]
            for x in range(W)]
    ents = root['Entities'][0]
    def cell_of(c): return int(c['X']) // ts, int(c['Y']) // ts
    mk = next((m for m in ents['Markers'] if m['EntName'] == 'Main_Entrance_Marker'), None)
    start = cell_of(mk['Collider']) if mk else None
    if not start or not walk[start[0]][start[1]]:
        start = next(((x, y) for x in range(W) for y in range(H) if walk[x][y]), None)
    seen = {start}; stack = [start]
    while stack:
        x, y = stack.pop()
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            nx, ny = x + dx, y + dy
            if 0 <= nx < W and 0 <= ny < H and walk[nx][ny] and (nx, ny) not in seen:
                seen.add((nx, ny)); stack.append((nx, ny))
    nwalk = sum(walk[x][y] and 1 or 0 for x in range(W) for y in range(H))
    c_ok(f'zone marchable : {len(seen)}/{nwalk} cellules atteignables '
         f'({round(100 * len(seen) / max(nwalk, 1))}%)')
    if len(seen) < nwalk:
        print(f'  [INFO] {nwalk - len(seen)} cellules marchables hors reseau '
              f'(exterieur de camp autotile = normal si aucun objet ne les vise)')
    bord = any((x in (0, W - 1) or y in (0, H - 1)) for (x, y) in seen)
    (c_ok if not bord else c_warn)(
        'bordure de carte ' + ('MARCHABLE dans la zone du joueur (pre-existant si topologie heritee)'
                               if bord else 'bloquee autour de la zone du joueur'))
    def joignable(c):
        cx, cy = cell_of(c)
        return any(0 <= x < W and 0 <= y < H and (x, y) in seen
                   for x in range(cx - 1, cx + 2) for y in range(cy - 1, cy + 2))
    for coll_name in ('Markers', 'Spawners'):
        for e in ents[coll_name]:
            if not joignable(e['Collider']):
                c_fail(f'{e["EntName"]} ({coll_name}) HORS de la zone atteignable')
                rc = 1
    for e in ents['GroundObjects']:
        trig = e.get('triggerType', 0)
        okk = joignable(e['Collider']) if trig != 2 else \
            cell_of(e['Collider']) in seen or joignable(e['Collider'])
        (c_ok if okk else c_fail)(
            f'objet {e["EntName"]} triggerType {trig} : '
            + ('atteignable' if okk else 'INATTEIGNABLE — trigger mort'))
        rc |= 0 if okk else 1
    return rc


def cmd_check(a):
    cible = a.cible
    if not os.path.isabs(cible):
        cible = os.path.join(ROOT, cible)
    print(f'CHECK {os.path.relpath(cible, ROOT)}')
    if cible.endswith('.rsground'):
        rc = check_ground(cible)
    elif cible.endswith('.json') and '/Zone/' in cible.replace(os.sep, '/'):
        rc = check_zone(cible)
    else:
        sys.exit('Type non gere (attendu : Data/Zone/*.json ou Data/Ground/*.rsground)')
    print('\nPipeline a rejouer apres modification : audit_bugs, audit_integrite, '
          'verify_scene_positions, validate_all, verify_ground_registration.')
    sys.exit(rc)


def main():
    p = argparse.ArgumentParser(description=__doc__,
                                formatter_class=argparse.RawDescriptionHelpFormatter)
    sp = p.add_subparsers(dest='cmd', required=True)
    t = sp.add_parser('tilesets', help='recherche un tileset valide')
    t.add_argument('requete'); t.add_argument('--element', choices=ELEMENTS)
    t.set_defaults(f=cmd_tilesets)
    g = sp.add_parser('gen-etages', help='genere une zone d etages proceduraux')
    g.add_argument('--zone', required=True); g.add_argument('--nom-fr', required=True)
    g.add_argument('--etages', type=int, required=True)
    g.add_argument('--tileset', required=True)
    g.add_argument('--element', choices=ELEMENTS)
    g.add_argument('--musique'); g.add_argument('--donneur', default='cloven_ruins')
    g.add_argument('--ecrire', action='store_true')
    g.set_defaults(f=cmd_gen_etages)
    c = sp.add_parser('check', help='validation avant sortie')
    c.add_argument('--cible', required=True)
    c.set_defaults(f=cmd_check)
    a = p.parse_args()
    sys.exit(a.f(a))


if __name__ == '__main__':
    main()
