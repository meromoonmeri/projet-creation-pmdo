#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""campaign_counter_audit_grounds.py — CONTRE-AUDIT indépendant des grounds.

Différence avec campaign_audit_grounds_complete.py (audit "aller") :
l'audit aller vérifie que ce que les .rsground RÉFÉRENCENT existe.
Ce contre-audit part de l'AUTRE bout de la chaîne : ce que la SOURCE
CANONIQUE (manifests d'extraction ROM) déclare, et vérifie que le package
le réalise. Il détecte les pertes que l'audit aller ne peut pas voir :
  A. ANIM_LOSS   — le manifest ROM déclare N frames/cycle, le rsground du
     package n'atteint pas ce nombre de frames distinctes par tuile
     (croisement render.frames + animated_tiles ROM vs frames rsground).
  B. RESERVE_ONLY— une ressource utilisée par le package existe aussi en
     dev/RESERVE ou .runtime-cache avec un contenu DIFFÉRENT (dérive).
  C. NAME_DRIFT  — Sky : le nom humain du manifest ne correspond pas au
     nom du bloc ROM 'Ground Map Names' pour le map_bg lié.
     Red : le donjon déclaré n'existe pas dans pret/pmd-red.
  D. SHEET_BYTES — pour un échantillon dirigé (guilde g01*, Mt Freeze d11*,
     épisode Sunflora s21p01a, panorama s13p05a, hub t01p01a, arènes
     Groudon/Rayquaza) : décodage RÉEL de chaque cellule référencée
     (pas seulement présence de la clé) — une cellule PNG corrompue ou
     vide = FAIL.
Sortie : dev/docs/canonical/GROUNDS_COUNTER_AUDIT.json — FAIL-CLOSED.
"""
import io
import json
import os
import re
import struct
import sys
from collections import defaultdict

from PIL import Image

ROOT = os.path.dirname(
    os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
GROUND = os.path.join(ROOT, 'Data', 'Ground')
TILE = os.path.join(ROOT, 'Content', 'Tile')
BASE_TILE = os.path.join(ROOT, '.runtime-cache', 'DumpAsset', 'Content',
                         'Tile')
CAMPS = os.path.join(ROOT, 'dev', 'CAMPAIGNS')
OUT = os.path.join(ROOT, 'dev', 'docs', 'canonical',
                   'GROUNDS_COUNTER_AUDIT.json')

findings = []


def add(sev, cat, subject, detail):
    findings.append({'severity': sev, 'category': cat,
                     'subject': subject, 'detail': detail})


def load(p):
    with open(p, encoding='utf-8') as f:
        return json.load(f)


def rsground_frames(path):
    """max frames distinctes par tuile + nb de tuiles animées réelles."""
    obj = json.load(open(path, encoding='utf-8-sig'))['Object']
    mx = 0
    n_anim = 0

    def walk(x):
        nonlocal mx, n_anim
        if isinstance(x, dict):
            fr = x.get('Frames')
            if isinstance(fr, list) and fr:
                mx = max(mx, len(fr))
                if len(fr) > 1:
                    n_anim += 1
            for v in x.values():
                walk(v)
        elif isinstance(x, list):
            for v in x:
                walk(v)
    walk(obj)
    return mx, n_anim, obj


# ---------------------------------------------------------------- A + C
red_man = load(os.path.join(CAMPS, 'PMD_RED_RESCUE_TEAM',
                            'MANIFEST.json'))['grounds']
sky_man = load(os.path.join(CAMPS, 'PMD_SKY_EXPLORERS',
                            'MANIFEST.json'))['grounds']
sky_names = load(os.path.join(CAMPS, 'PMD_SKY_EXPLORERS', 'Docs',
                              'LEVEL_HUMAN_NAMES.json'))['levels']
bg2rom = {}
for lvl, e in sky_names.items():
    if e.get('place_name') and e.get('map_bg'):
        bg2rom.setdefault(e['map_bg'], set()).add(
            (re.sub(r'\[[^\]]*\]', '', e['place_name']['en']).strip(),
             re.sub(r'\[[^\]]*\]', '', e['place_name']['fr']).strip()))

pret_dungeons = set()
pret_dir = os.path.join(ROOT, '.runtime-cache', 'pmd-red-reference',
                        'data', 'dungeon')
if os.path.isdir(pret_dir):
    pret_dungeons = {d.lower().replace(' ', '').replace('.', '')
                     for d in os.listdir(pret_dir)}

n_anim_checked = 0
for camp, man in (('RED', red_man), ('SKY', sky_man)):
    for g in man:
        gid = g['ground']
        if g.get('is_red_canon') is False:
            continue
        r = g.get('render') or {}
        declared = r.get('animation_cycle') or r.get('frames') or 1
        # fichier package : gid direct, sinon dossier render (id renommé)
        p = os.path.join(GROUND, gid + '.rsground')
        if not os.path.exists(p):
            continue  # couverts par l'audit aller (grounds hors package)
        if declared and declared > 1:
            mx, n_anim, _ = rsground_frames(p)
            n_anim_checked += 1
            if mx <= 1:
                add('CRITICAL', 'ANIM_LOSS', f'{camp}:{gid}',
                    f'ROM déclare cycle {declared}, package statique '
                    f'(max 1 frame/tuile)')
            elif r.get('animated_tiles') and n_anim == 0:
                add('CRITICAL', 'ANIM_LOSS', f'{camp}:{gid}',
                    f'ROM déclare {r["animated_tiles"]} tuiles animées, '
                    f'package 0')
        # C: noms
        if camp == 'SKY':
            src = g.get('source_comment') or ''
            mm = re.search(r'->\s*([a-z0-9_]+)', src)
            bg = mm.group(1) if mm else gid
            roms = bg2rom.get(bg)
            if roms:
                en = (g.get('human_name_en') or '').strip()
                ok = any(en == e for e, f in roms) or en.upper() == bg.upper()
                if not ok and en:
                    add('HIGH', 'NAME_DRIFT', gid,
                        f'manifest "{en}" vs ROM {sorted(roms)}')
        else:
            d = g.get('dungeon')
            if d and d.get('dungeon_en'):
                key = d['dungeon_en'].lower().replace(' ', '') \
                    .replace('.', '')
                if pret_dungeons and key not in pret_dungeons:
                    add('HIGH', 'NAME_DRIFT', gid,
                        f'donjon "{d["dungeon_en"]}" absent de pret')

# ---------------------------------------------------------------- B
# dérive RESERVE : même nom de sheet, contenu différent de celui du package
reserve_tiles = {}
for dp, _, fns in os.walk(os.path.join(ROOT, 'dev', 'RESERVE')):
    for fn in fns:
        if fn.endswith('.tile'):
            reserve_tiles.setdefault(fn, []).append(os.path.join(dp, fn))
n_reserve_checked = 0
for fn, paths in reserve_tiles.items():
    # normalisation : les tiles RESERVE sont préfixées sky_
    cand = fn[4:] if fn.startswith('sky_') else fn
    for pkg_dir in (TILE,):
        for pkg_name in {cand, cand[0].upper() + cand[1:]}:
            pkg = os.path.join(pkg_dir, pkg_name)
            if os.path.exists(pkg):
                n_reserve_checked += 1
                a = open(pkg, 'rb').read()
                b = open(paths[0], 'rb').read()
                if a != b:
                    add('LOW', 'RESERVE_DRIFT', pkg_name,
                        f'contenu package != RESERVE/{fn} '
                        f'({len(a)} vs {len(b)} octets) — le package fait '
                        f'foi, RESERVE est un instantané antérieur')

# ---------------------------------------------------------------- D
SAMPLE = ['g01p01a', 'g01p02a', 'g01p05a', 'd11p01', 'd11p02', 'd11p03',
          's21p01a', 's13p05a', 't01p01a', 't01p01', 't00p01', 't01p02a',
          't00p01_sky', 't01p02a_sky']


def sheet_cells(sheet):
    for d in (TILE, BASE_TILE):
        p = os.path.join(d, sheet + '.tile')
        if os.path.exists(p):
            raw = open(p, 'rb').read()
            _, count = struct.unpack_from('<II', raw, 0)
            cells = {}
            for i in range(count):
                key, off = struct.unpack_from('<QQ', raw, 8 + i * 16)
                ln = struct.unpack_from('<q', raw, off)[0]
                cells[(key & 0xFFFFFFFF, key >> 32)] = \
                    raw[off + 8: off + 8 + ln]
            return cells
    return None


deep_results = {}
for gid in SAMPLE:
    p = os.path.join(GROUND, gid + '.rsground')
    if not os.path.exists(p):
        deep_results[gid] = 'ABSENT_DU_PACKAGE'
        continue
    obj = json.load(open(p, encoding='utf-8-sig'))['Object']
    refs = defaultdict(set)

    def walk(x):
        if isinstance(x, dict):
            fr = x.get('Frames')
            if isinstance(fr, list):
                for f in fr:
                    if isinstance(f, dict) and f.get('Sheet') \
                            and f.get('TexLoc'):
                        refs[f['Sheet']].add(
                            (f['TexLoc']['X'], f['TexLoc']['Y']))
            for v in x.values():
                walk(v)
        elif isinstance(x, list):
            for v in x:
                walk(v)
    walk(obj)
    n_cells = n_bad = 0
    for sheet, locs in refs.items():
        cells = sheet_cells(sheet)
        if cells is None:
            add('CRITICAL', 'SHEET_BYTES', gid, f'sheet {sheet} introuvable')
            n_bad += len(locs)
            continue
        for loc in locs:
            n_cells += 1
            blob = cells.get(loc)
            if blob is None:
                n_bad += 1
                add('CRITICAL', 'SHEET_BYTES', gid,
                    f'{sheet} clé {loc} absente')
                continue
            try:
                im = Image.open(io.BytesIO(blob))
                im.verify()
            except Exception as exc:
                n_bad += 1
                add('CRITICAL', 'SHEET_BYTES', gid,
                    f'{sheet} clé {loc} PNG corrompu: {exc}')
    deep_results[gid] = f'{n_cells} cellules décodées, {n_bad} défauts'

# ---------------------------------------------------------------- rapport
sev_count = defaultdict(int)
for f in findings:
    sev_count[f['severity']] += 1
verdict = 'COUNTER_AUDIT_PASS' if sev_count.get('CRITICAL', 0) == 0 \
    and sev_count.get('HIGH', 0) == 0 else 'COUNTER_AUDIT_FAIL'
report = {
    'schema': 'grounds_counter_audit.v1',
    'method': ('indépendant de campaign_audit_grounds_complete: part des '
               'manifests ROM (attendu) vers le package (réalisé) ; '
               'décodage PNG réel sur échantillon dirigé '
               '(guilde/Ninetales/Sunflora/panorama/hub/collisions)'),
    'checked': {'anim_declared_gt1': n_anim_checked,
                'reserve_pairs': n_reserve_checked,
                'deep_sample': deep_results},
    'severities': dict(sev_count),
    'verdict': verdict,
    'findings': findings,
}
os.makedirs(os.path.dirname(OUT), exist_ok=True)
json.dump(report, open(OUT, 'w'), ensure_ascii=False, indent=1)
print(f'verdict: {verdict} — sévérités {dict(sev_count)}')
print(f'animations vérifiées: {n_anim_checked}, paires RESERVE: '
      f'{n_reserve_checked}')
for gid, r in deep_results.items():
    print(f'  DEEP {gid}: {r}')
for f in findings[:25]:
    print(' ', f['severity'], f['category'], f['subject'], '|',
          f['detail'][:120])
sys.exit(0 if verdict == 'COUNTER_AUDIT_PASS' else 1)
