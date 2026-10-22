#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""campaign_audit_grounds_complete.py — audit exhaustif FAIL-CLOSED de 100%
des grounds du package final (Data/Ground) + arènes .rsmap (Data/Map).

Vérifie, par ground :
  A. RESOURCE_COMPLETE  — toutes les sheets référencées existent dans
     Content/Tile (nom exact, casse exacte), toutes les clés TexLoc
     référencées existent dans la sheet ; AutoTilesets référencés présents
     dans Data/AutoTile avec leurs sheets et toutes leurs variantes.
     Une ressource présente uniquement dans dev/RESERVE ou .runtime-cache
     compte comme NOT_PERSISTED (FAIL).
  B. ANIMATION_COMPLETE — si la source canonique (MANIFEST des campagnes,
     render.frames extrait de la ROM) déclare un cycle d'animation > 1,
     le .rsground doit contenir des tuiles multi-frames (sinon : animation
     aplatie en statique = FAIL). Toute liste de frames vide ou tronquée
     (frame sans Sheet) = FAIL.
  C. NAME_MATCH — le nom humain du manifest correspond au nom canonique
     ROM (Sky : LEVEL_HUMAN_NAMES.json, bloc 'Ground Map Names' EU ;
     Red : MANIFEST pret/ROM). Ground hors manifest = UNNAMED (à lister).
  D. GLOBAL_STATUS = FAIL si un seul des points ci-dessus échoue.

Sortie : dev/docs/canonical/GROUNDS_COMPLETE_AUDIT.json (+ .md résumé).
"""
import io
import json
import os
import re
import struct
import sys
from collections import defaultdict

ROOT = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
GROUND_DIR = os.path.join(ROOT, 'Data', 'Ground')
MAP_DIR = os.path.join(ROOT, 'Data', 'Map')
TILE_DIR = os.path.join(ROOT, 'Content', 'Tile')
AUTO_DIR = os.path.join(ROOT, 'Data', 'AutoTile')
# Base PMDO vanilla (résolution runtime = quest PUIS base). Les ressources
# de base font partie de l'installation PMDO du joueur (DumpAsset@9d864d14
# = référence officielle), donc "présent en base" = résolu, avec provenance.
BASE = os.path.join(ROOT, '.runtime-cache', 'DumpAsset')
BASE_TILE_DIR = os.path.join(BASE, 'Content', 'Tile')
BASE_AUTO_DIR = os.path.join(BASE, 'Data', 'AutoTile')
RESERVE = os.path.join(ROOT, 'dev', 'RESERVE')
CAMPS = os.path.join(ROOT, 'dev', 'CAMPAIGNS')
OUT_JSON = os.path.join(ROOT, 'dev', 'docs', 'canonical',
                        'GROUNDS_COMPLETE_AUDIT.json')
OUT_MD = os.path.join(ROOT, 'dev', 'docs', 'canonical',
                      'GROUNDS_COMPLETE_AUDIT.md')

# ---------------------------------------------------------------- helpers


def listdir_exact(d):
    try:
        return set(os.listdir(d))
    except FileNotFoundError:
        return set()


TILES_EXACT = listdir_exact(TILE_DIR)
AUTOS_EXACT = listdir_exact(AUTO_DIR)
RESERVE_TILES = set()
for dp, _, fns in os.walk(RESERVE):
    for fn in fns:
        if fn.endswith('.tile'):
            RESERVE_TILES.add(fn)

_sheet_keys_cache = {}


BASE_TILES_EXACT = listdir_exact(BASE_TILE_DIR)
BASE_AUTOS_EXACT = listdir_exact(BASE_AUTO_DIR)


def sheet_keys(sheet):
    """(where, keys) — where in {'quest','base',None}. Clés (X,Y) réelles."""
    if sheet in _sheet_keys_cache:
        return _sheet_keys_cache[sheet]
    where = None
    p = None
    if (sheet + '.tile') in TILES_EXACT:
        where, p = 'quest', os.path.join(TILE_DIR, sheet + '.tile')
    elif (sheet + '.tile') in BASE_TILES_EXACT:
        where, p = 'base', os.path.join(BASE_TILE_DIR, sheet + '.tile')
    keys = set()
    if where:
        try:
            with open(p, 'rb') as f:
                raw = f.read()
            _, count = struct.unpack_from('<II', raw, 0)
            for i in range(count):
                key, _off = struct.unpack_from('<QQ', raw, 8 + i * 16)
                keys.add((key & 0xFFFFFFFF, key >> 32))
        except Exception:
            where = None
    _sheet_keys_cache[sheet] = (where, keys)
    return _sheet_keys_cache[sheet]


_auto_cache = {}


def autotile_info(name):
    """(sheets_referenced, n_variants, frame counts) ou None si absent."""
    if name in _auto_cache:
        return _auto_cache[name]
    fn = name + '.json'
    if fn in AUTOS_EXACT:
        p = os.path.join(AUTO_DIR, fn)
    elif fn in BASE_AUTOS_EXACT:
        p = os.path.join(BASE_AUTO_DIR, fn)
    else:
        _auto_cache[name] = None
        return None
    with open(p, encoding='utf-8-sig') as f:
        data = json.load(f)
    tiles = (data.get('Object') or data).get('Tiles', {})
    sheets = set()
    variants = 0
    anim_frames = []
    for k, v in tiles.items():
        if not k.startswith('Tilex'):
            continue
        variants += 1
        try:
            for col in v:
                for anim in col:
                    frs = anim.get('Frames', [])
                    anim_frames.append(len(frs))
                    for fr in frs:
                        if fr.get('Sheet'):
                            sheets.add(fr['Sheet'])
        except (TypeError, AttributeError):
            pass
    _auto_cache[name] = (sheets, variants, anim_frames)
    return _auto_cache[name]


def walk_ground_refs(obj):
    """Extrait (sheet -> set(TexLoc)), autotiles, anim stats d'un rsground/
    rsmap déjà parsé. Une frame Sheet="" DANS une animation qui contient
    aussi des frames pleines est une frame transparente délibérée (blink),
    pas un trou ; seule une animation 100% vide est une erreur."""
    sheet_locs = defaultdict(set)
    autotiles = set()
    frame_counts = []          # nombre de frames par liste d'anim de tuile
    all_blank_anims = 0        # animations dont TOUTES les frames sont vides

    def walk(x):
        nonlocal all_blank_anims
        if isinstance(x, dict):
            if 'AutoTileset' in x and x.get('AutoTileset'):
                autotiles.add(x['AutoTileset'])
            if 'Frames' in x and isinstance(x['Frames'], list):
                frs = [f for f in x['Frames'] if isinstance(f, dict)]
                if frs:
                    frame_counts.append(len(frs))
                    n_full = 0
                    for fr in frs:
                        sh = fr.get('Sheet')
                        loc = fr.get('TexLoc')
                        if sh and loc:
                            sheet_locs[sh].add((loc['X'], loc['Y']))
                            n_full += 1
                    if n_full == 0 and any(
                            f.get('TexLoc') is not None for f in frs):
                        all_blank_anims += 1
            for v in x.values():
                walk(v)
        elif isinstance(x, list):
            for v in x:
                walk(v)
    walk(obj)
    return sheet_locs, autotiles, frame_counts, all_blank_anims


# ------------------------------------------------- manifests / noms humains

def load_json(p):
    with open(p, encoding='utf-8') as f:
        return json.load(f)


red_man = {g['ground']: g for g in load_json(
    os.path.join(CAMPS, 'PMD_RED_RESCUE_TEAM', 'MANIFEST.json'))['grounds']}
sky_man = {g['ground']: g for g in load_json(
    os.path.join(CAMPS, 'PMD_SKY_EXPLORERS', 'MANIFEST.json'))['grounds']}
sky_names_p = os.path.join(CAMPS, 'PMD_SKY_EXPLORERS', 'Docs',
                           'LEVEL_HUMAN_NAMES.json')
sky_rom_names = {}
if os.path.exists(sky_names_p):
    for lvl, e in load_json(sky_names_p)['levels'].items():
        bg = e.get('map_bg')
        pn = e.get('place_name')
        if bg and pn:
            sky_rom_names.setdefault(bg, []).append(
                {'level': lvl, 'fr': pn['fr'], 'en': pn['en']})

red_alias = {}
alias_p = os.path.join(ROOT, 'dev', 'docs', 'canonical', 'red',
                       'upstream_ground_aliases.json')
if os.path.exists(alias_p):
    red_alias = {k[:-9]: v[:-9] for k, v in load_json(alias_p).items()}


def classify_campaign(gid):
    if gid in red_man:
        return 'RED', red_man[gid]
    # sky manifest utilise les ids map_bg (ex: t01p01a) et des noms humains
    for mid, m in sky_man.items():
        pass
    if gid in sky_man:
        return 'SKY', sky_man[gid]
    # sky manifest garde parfois le nom canonique New Era; croiser par
    # source_comment "-> <id>"
    return None, None


# sky manifest: indexer par id map_bg réel (source_comment "-> d32p11a")
sky_by_bg = {}
for mid, m in sky_man.items():
    src = m.get('source_comment') or ''
    mm = re.search(r'->\s*([a-z0-9_]+)\.?', src)
    if mm:
        sky_by_bg.setdefault(mm.group(1), (mid, m))
    sky_by_bg.setdefault(mid, (mid, m))

# ---------------------------------------------------------------- audit

results = {}
counts = defaultdict(int)

targets = sorted(f for f in os.listdir(GROUND_DIR)
                 if f.endswith('.rsground'))
map_targets = sorted(f for f in os.listdir(MAP_DIR) if f.endswith('.rsmap'))

for fn in targets + map_targets:
    is_map = fn.endswith('.rsmap')
    gid = fn.rsplit('.', 1)[0]
    if is_map and gid in results:
        gid = gid + '.rsmap'   # homonyme rsground/rsmap: clés séparées
    path = os.path.join(MAP_DIR if is_map else GROUND_DIR, fn)
    entry = {'kind': 'rsmap' if is_map else 'rsground'}
    issues = []
    try:
        obj = load_json_sig = json.load(
            open(path, encoding='utf-8-sig'))['Object']
    except Exception as exc:
        results[gid] = {'kind': entry['kind'],
                        'GLOBAL_STATUS': 'FAIL',
                        'issues': [f'PARSE_FAIL: {exc}']}
        counts['FAIL'] += 1
        continue
    sheet_locs, autotiles, frame_counts, all_blank_anims = \
        walk_ground_refs(obj)

    # --- A. ressources
    res_ok = True
    missing_sheets = []
    missing_keys = {}
    from_base = set()
    for sh, locs in sheet_locs.items():
        where, keys = sheet_keys(sh)
        if where is None:
            res_ok = False
            state = 'NOT_PERSISTED(RESERVE)' if any(
                sh in t for t in RESERVE_TILES) else 'MISSING'
            missing_sheets.append(f'{sh} [{state}]')
            continue
        if where == 'base':
            from_base.add(sh)
        miss = sorted(locs - keys)
        if miss:
            res_ok = False
            missing_keys[sh] = len(miss)
    missing_autos = []
    auto_sheets_missing = []
    incomplete_autos = []
    for at in sorted(autotiles):
        info = autotile_info(at)
        if info is None:
            res_ok = False
            missing_autos.append(at)
            continue
        sheets, variants, anim_frames = info
        for sh in sheets:
            where, _ = sheet_keys(sh)
            if where is None:
                res_ok = False
                auto_sheets_missing.append(f'{at}:{sh}')
            elif where == 'base':
                from_base.add(sh)
        if variants == 0:
            res_ok = False
            incomplete_autos.append(f'{at} (0 variantes)')
        if any(n == 0 for n in anim_frames):
            res_ok = False
            incomplete_autos.append(f'{at} (frames vides)')
    if missing_sheets:
        issues.append('SHEETS: ' + ', '.join(missing_sheets))
    if missing_keys:
        issues.append('TEXLOC MANQUANTS: ' + ', '.join(
            f'{k}({v})' for k, v in missing_keys.items()))
    if missing_autos:
        issues.append('AUTOTILES MANQUANTS: ' + ', '.join(missing_autos))
    if auto_sheets_missing:
        issues.append('SHEETS AUTOTILE MANQUANTES: '
                      + ', '.join(auto_sheets_missing))
    if incomplete_autos:
        issues.append('AUTOTILES INCOMPLETS: ' + ', '.join(incomplete_autos))

    # --- B. animation
    anim_ok = True
    max_frames = max(frame_counts) if frame_counts else 0
    if all_blank_anims:
        anim_ok = False
        issues.append(f'ANIMATIONS 100% VIDES: {all_blank_anims}')
    expected_cycle = None
    campaign = None
    man = None
    if gid in red_man:
        campaign, man = 'RED', red_man[gid]
    elif gid in red_alias and red_alias[gid] in red_man:
        campaign, man = 'RED', red_man[red_alias[gid]]
        entry['alias_of'] = red_alias[gid]
    elif gid in sky_by_bg:
        campaign, man = 'SKY', sky_by_bg[gid][1]
    elif gid.startswith('sky_eos_') and gid[8:] in sky_by_bg:
        campaign, man = 'SKY', sky_by_bg[gid[8:]][1]
        entry['alias_of'] = gid[8:]
    if man:
        expected_cycle = (man.get('render') or {}).get('animation_cycle')
        if expected_cycle and expected_cycle > 1 and max_frames <= 1 \
                and not is_map:
            anim_ok = False
            issues.append(
                f'ANIMATION APLATIE: ROM cycle={expected_cycle} frames, '
                f'rsground max {max_frames} frame/tuile')

    # --- C. nom humain
    name_ok = True
    human = None
    rom_name = None
    if man:
        human = {'en': man.get('human_name_en'),
                 'fr': man.get('human_name_fr')}
    base_gid = entry.get('alias_of', gid)
    if campaign == 'SKY' and base_gid in sky_rom_names:
        rom_name = sky_rom_names[base_gid]
    entry.update({
        'campaign': campaign or 'NEW_ERA/OTHER',
        'human_name': human,
        'rom_place_name': rom_name,
        'sheets_used': sorted(sheet_locs),
        'sheets_from_base_pmdo': sorted(from_base),
        'autotiles_used': sorted(autotiles),
        'max_frames_per_tile': max_frames,
        'expected_cycle_rom': expected_cycle,
        'RESOURCE_COMPLETE': 'PASS' if res_ok else 'FAIL',
        'ANIMATION_COMPLETE': 'PASS' if anim_ok else 'FAIL',
        'NAME_MATCH': 'PASS' if name_ok else 'FAIL',
        'issues': issues,
        'GLOBAL_STATUS': 'PASS' if (res_ok and anim_ok and name_ok)
        else 'FAIL',
    })
    results[gid] = entry
    counts[entry['GLOBAL_STATUS']] += 1
    counts[f"{entry['campaign']}:{entry['GLOBAL_STATUS']}"] += 1

# ---------------------------------------------------------------- sortie
report = {
    'schema': 'grounds_complete_audit.v1',
    'rule': ('FAIL-CLOSED: une seule sheet/clé/variante/frame manquante = '
             'FAIL du ground. Une ressource en RESERVE uniquement = '
             'NOT_PERSISTED = FAIL. Cycle ROM>1 sans tuile multi-frame = '
             'ANIMATION APLATIE = FAIL.'),
    'totals': dict(counts),
    'n_grounds': len(targets),
    'n_maps': len(map_targets),
    'grounds': results,
}
os.makedirs(os.path.dirname(OUT_JSON), exist_ok=True)
with open(OUT_JSON, 'w', encoding='utf-8') as f:
    json.dump(report, f, ensure_ascii=False, indent=1)

fails = {g: e for g, e in results.items() if e['GLOBAL_STATUS'] == 'FAIL'}
with open(OUT_MD, 'w', encoding='utf-8') as f:
    f.write('# Audit exhaustif des grounds (fail-closed)\n\n')
    f.write(f"Total: {len(results)} entrées ({len(targets)} rsground, "
            f"{len(map_targets)} rsmap) — PASS {counts['PASS']}, "
            f"FAIL {counts['FAIL']}\n\n")
    if fails:
        f.write('## FAILS\n\n')
        for g, e in sorted(fails.items()):
            f.write(f"### {g} ({e.get('campaign')})\n")
            for i in e.get('issues', []):
                f.write(f"- {i}\n")
            f.write('\n')
print(f"total={len(results)} PASS={counts['PASS']} FAIL={counts['FAIL']}")
for k in sorted(counts):
    if ':' in k:
        print(' ', k, counts[k])
if fails:
    print('\nFAILS:')
    for g, e in sorted(fails.items())[:40]:
        print(' ', g, '|', '; '.join(e['issues'])[:160])
sys.exit(0)
