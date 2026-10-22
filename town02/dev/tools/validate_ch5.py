#!/usr/bin/env python3
"""Validation de bout en bout de la chaîne du chapitre 5."""
import json, os, re, struct
import numpy as np

P = os.environ.get('MOD_ROOT', os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
S = os.path.join(P, 'Data/Script/halcyon')
issues = []

def ok(c, msg):
    print(('  ✅ ' if c else '  ❌ ') + msg)
    if not c:
        issues.append(msg)

print('=== 1. Cartes de cinématique (.rsground) ===')
ROOMS = ['vast_steppe_miniboss', 'vast_steppe_guardian', 'searing_tunnel_miniboss',
         'mount_windswept_miniboss', 'mount_windswept_guardian']
for r in ROOMS:
    ok(os.path.exists(os.path.join(P, 'Data/Ground', r + '.rsground')),
       '%s.rsground présent' % r)

print('=== 2. Étages de combat (.rsmap) ===')
for r in ROOMS:
    ok(os.path.exists(os.path.join(P, 'Data/Map', r + '.rsmap')),
       '%s.rsmap présent' % r)

print('=== 3. Tilesets référencés ===')
for r in ROOMS:
    d = json.load(open(os.path.join(P, 'Data/Ground', r + '.rsground'),
                       encoding='utf-8-sig'))['Object']
    ts = 8 * d.get('TexSize', 1)
    sheets = set()
    for lay in d['Layers']:
        for col in lay['Tiles']:
            for t in col:
                for tl in t.get('Layers', []):
                    for f in tl.get('Frames', []):
                        if f.get('Sheet'):
                            sheets.add(f['Sheet'])
    bad = []
    for s in sheets:
        fp = os.path.join(P, 'Content/Tile', s + '.tile')
        if not os.path.exists(fp):
            bad.append(s + '(absent)')
        else:
            tsz, _ = struct.unpack('<II', open(fp, 'rb').read(8))
            if tsz != ts:
                bad.append('%s(ts=%d≠%d)' % (s, tsz, ts))
    ok(not bad, '%s : %d tileset(s) cohérents %s' % (r, len(sheets), bad or ''))

print('=== 4. index.idx à jour ===')
T = os.path.join(P, 'Content/Tile')
disk = sorted(f[:-5] for f in os.listdir(T) if f.endswith('.tile'))
b = open(os.path.join(T, 'index.idx'), 'rb').read()
n, = struct.unpack_from('<I', b, 0)
off = 4
declared = []
for _ in range(n):
    ln = b[off]; off += 1
    nm = b[off:off + ln].decode('utf-8'); off += ln
    tsz, tc = struct.unpack_from('<II', b, off); off += 8 + tc * 16
    declared.append(nm)
ok(off == len(b), 'index.idx bien formé (%d octets)' % len(b))
ok(sorted(declared) == disk, 'index.idx couvre les %d tilesets du disque' % len(disk))

print('=== 5. Segments de zone ===')
EXPECT = {'vast_steppe': {1: 'vast_steppe_miniboss', 3: 'vast_steppe_guardian'},
          'mount_windswept': {1: 'mount_windswept_miniboss',
                              3: 'mount_windswept_guardian'},
          'searing_tunnel': {2: 'searing_crucible'},
          'gloomy_forest': {2: 'gloomy_forest_boss'}}
for zone, exp in EXPECT.items():
    d = json.load(open(os.path.join(P, 'Data/Zone', zone + '.json'),
                       encoding='utf-8-sig'))['Object']
    segs = d['Segments']
    for idx, mapid in exp.items():
        if idx >= len(segs):
            ok(False, '%s segment %d manquant' % (zone, idx)); continue
        fl = segs[idx].get('Floors')
        got = None
        if isinstance(fl, list) and fl and 'LoadGen' in str(fl[0].get('$type', '')):
            got = fl[0]['GenSteps'][0]['Value'].get('MapID')
        ok(got == mapid, '%s segment %d -> %s' % (zone, idx, got))

print('=== 6. Segments appelés par le code vs définis ===')
seg_ref = {}
for dp, dn, fn in os.walk(S):
    for f in fn:
        if not f.endswith('.lua'):
            continue
        for i, line in enumerate(open(os.path.join(dp, f), encoding='utf-8',
                                      errors='replace'), 1):
            if line.strip().startswith('--'):
                continue
            for m in re.finditer(r"GAME:(?:ContinueDungeon|EnterDungeon)\(\s*['\"](\w+)['\"]\s*,\s*(\d+)", line):
                seg_ref.setdefault(m.group(1), set()).add(int(m.group(2)))
for zone, segs_used in sorted(seg_ref.items()):
    zp = os.path.join(P, 'Data/Zone', zone + '.json')
    if not os.path.exists(zp):
        ok(False, 'zone %s introuvable' % zone); continue
    nseg = len(json.load(open(zp, encoding='utf-8-sig'))['Object']['Segments'])
    over = [s for s in segs_used if s >= nseg]
    ok(not over, '%s : segments %s (zone en a %d)'
       % (zone, sorted(segs_used), nseg))

print('=== 7. Espèces des cinématiques présentes au catalogue ===')
ce = open(os.path.join(S, 'CharacterEssentials.lua'), encoding='utf-8').read()
known = set(re.findall(r'^\t\t(\w+) = \{', ce, re.M))
missing = set()
for dp, dn, fn in os.walk(os.path.join(S, 'ground')):
    for f in fn:
        if not f.endswith('.lua'):
            continue
        src = open(os.path.join(dp, f), encoding='utf-8', errors='replace').read()
        for blk in re.finditer(r'MakeCharactersFromList\(\{(.*?)\}\)', src, re.S):
            for nm in re.findall(r"\{\s*'(\w+)'", blk.group(1)):
                if nm not in known:
                    missing.add((os.path.basename(f), nm))
ok(not missing, 'toutes les espèces invoquées existent %s'
   % (sorted(missing)[:6] if missing else ''))

print('=== 8. Syntaxe Lua ===')
try:
    import lupa
    L = lupa.LuaRuntime()
    ld = L.eval('function(s,n) local f,e=load(s,n) if f then return true else return e end end')
    bad = []
    tot = 0
    for dp, dn, fn in os.walk(S):
        for f in fn:
            if f.endswith('.lua'):
                tot += 1
                r = ld(open(os.path.join(dp, f), encoding='utf-8',
                            errors='replace').read(), f)
                if r is not True:
                    bad.append((f, str(r)))
    ok(not bad, '%d/%d fichiers Lua compilent %s' % (tot - len(bad), tot, bad[:3]))
except ImportError:
    print('  (lupa absent)')

print('=== 9. Cohérence require -> module appelé ===')
for r in ROOMS:
    ini = os.path.join(S, 'ground', r, 'init.lua')
    src = open(ini, encoding='utf-8').read()
    need = 'halcyon.ground.%s.%s_ch_5' % (r, r)
    calls_mod = ('%s_ch_5.FirstPreBossScene' % r) in src
    ok(need in src and calls_mod, '%s : require + appel _ch_5' % r)

print()
print('RÉSULTAT :', '✅ chaîne du chapitre 5 cohérente'
      if not issues else '❌ %d problème(s)' % len(issues))
for i in issues:
    print('   -', i)
