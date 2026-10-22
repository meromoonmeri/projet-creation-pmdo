#!/usr/bin/env python3
"""Rejoue les 3 scénarios demandés en EXÉCUTANT le vrai code Lua du mod."""
import os, re, sys
sys.path.insert(0, '/home/user')
from simulate import build, S

ROOT = os.environ.get('MOD_ROOT', os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RES = {'Downed': 0, 'Failed': 1, 'Cleared': 2, 'Escaped': 3}


def load_zone(L, zone):
    """Charge un zone/<z>/init.lua et expose le module retourné en global."""
    p = os.path.join(S, 'zone', zone, 'init.lua')
    src = open(p, encoding='utf-8').read()
    src = re.sub(r"^\s*require .*$", "", src, flags=re.M)
    mod = L.execute(src)          # les init.lua terminent par `return <zone>`
    if mod is not None:
        L.globals()[zone] = mod
    return mod


def load_ground(L, name):
    p = os.path.join(S, 'ground', name, 'init.lua')
    src = open(p, encoding='utf-8').read()
    src = re.sub(r"^\s*require .*$", "", src, flags=re.M)
    mod = L.execute(src)
    if mod is not None:
        L.globals()[name] = mod
    return mod


def show(eng, keep=('GAME.', 'COMMON.')):
    out = []
    for k, a in eng.log:
        if any(k.startswith(p) for p in keep):
            args = ', '.join(str(x) for x in a if not hasattr(x, 'keys'))
            out.append('%s(%s)' % (k, args[:70]))
    return out


def flags(L):
    tf = L.globals().SV.TemporaryFlags
    return {k: tf[k] for k in ('Dinnertime', 'Bedtime', 'MorningWakeup', 'MorningAddress')}


print('=' * 78)
print('SCÉNARIO 2 — Défaite dans la Forêt Lugubre (le bug d\'origine)')
print('=' * 78)
for seg, label in [(0, 'étages normaux'), (1, 'profondeurs'), (2, 'salle de Zarude')]:
    L, eng = build(lambda l, e: None)
    g = L.globals()
    g.SV.ChapterProgression.Chapter = 6
    g.SV.Chapter6.MissionAccepted = True
    for k in ('Dinnertime', 'Bedtime', 'MorningWakeup', 'MorningAddress'):
        g.SV.TemporaryFlags[k] = False
    load_zone(L, 'gloomy_forest')
    zone = L.eval('{ID="gloomy_forest"}')
    L.globals().gloomy_forest.ExitSegment(zone, RES['Downed'], False, seg, 0)
    f = flags(L)
    dest = [x for x in show(eng) if 'EndDungeonRun' in x or 'EnterZone' in x]
    joined = ' '.join(dest)
    to_relay = ', 61,' in joined          # relais de mi-donjon (V4)
    to_guild = ', 6,' in joined or ', 22,' in joined
    to_town  = ', 1,' in joined and not to_relay
    print('\n  Défaite au segment %d (%s)' % (seg, label))
    print('    drapeaux : %s' % f)
    print('    sortie   : %s' % (dest[:2] or 'AUCUNE'))
    if to_relay:
        # comportement voulu par le checkpoint V4 : on repart du relais,
        # la journée ne se termine donc pas.
        print('    -> ✅ réapparition au relais de mi-donjon (carte 61), pas de nuit — attendu')
    elif to_guild and all(f.values()):
        print('    -> ✅ retour guilde + dîner/nuit/lendemain armés')
    elif to_town:
        print('    -> ❌ RÉGRESSION : retour en ville de jour sans séquence de nuit')
    else:
        print('    -> ❌ sortie inattendue')

print()
print('=' * 78)
print('SCÉNARIO 3 — Retour sur la carte de Zarude après défaite')
print('=' * 78)
L, eng = build(lambda l, e: None)
g = L.globals()
g.SV.ChapterProgression.Chapter = 6
g.SV.Chapter6.GloomyBossEncountered = True   # déjà rencontré
g.SV.Chapter6.DefeatedGloomyBoss = False     # mais pas vaincu
L.execute("gloomy_forest_boss_ch_6 = { FirstBossScene = function() PYREC('CH6.FirstBossScene') end }")
load_ground(L, 'gloomy_forest_boss')
L.globals().gloomy_forest_boss.PlotScripting()
acts = show(eng, keep=('GAME.', 'COMMON.', 'CH6.'))
relance = any('ContinueDungeon' in a for a in acts)
print('\n  Actions : %s' % acts)
print('  -> %s' % ('✅ le combat se relance, plus de blocage'
                   if relance else '❌ aucune sortie : joueur bloqué'))

print()
print('=' * 78)
print('SCÉNARIO 1 — Chaîne du chapitre 5 (Steppe / Tunnel / Mont)')
print('=' * 78)
CASES = [
    ('vast_steppe',     0, 'Cleared', 'vast_steppe_miniboss'),
    ('vast_steppe',     2, 'Cleared', 'vast_steppe_guardian'),
    ('mount_windswept', 0, 'Cleared', 'mount_windswept_miniboss'),
    ('mount_windswept', 2, 'Cleared', 'mount_windswept_guardian'),
    ('searing_tunnel',  0, 'Cleared', 'searing_tunnel_miniboss'),
]
for zone, seg, res, expect in CASES:
    L, eng = build(lambda l, e: None)
    g = L.globals()
    g.SV.ChapterProgression.Chapter = 5
    if zone == 'searing_tunnel':
        g.SV.Chapter5.TunnelMiniBossSeen = False
    load_zone(L, zone)
    z = L.eval('{ID="%s"}' % zone)
    getattr(L.globals(), zone).ExitSegment(z, RES[res], False, seg, 0)
    acts = show(eng)
    hit = [a for a in acts if expect in a]
    print('\n  %s segment %d réussi' % (zone, seg))
    print('    -> %s' % (hit[0] if hit else ('AUCUN appel vers %s | %s' % (expect, acts[:3]))))
    print('    %s' % ('✅' if hit else '❌'))

print()
print('=' * 78)
print('SCÉNARIO 1b — Défaite en donjon du chapitre 5')
print('=' * 78)
for zone in ['vast_steppe', 'mount_windswept']:
    L, eng = build(lambda l, e: None)
    g = L.globals()
    g.SV.ChapterProgression.Chapter = 5
    for k in ('Dinnertime', 'Bedtime', 'MorningWakeup', 'MorningAddress'):
        g.SV.TemporaryFlags[k] = False
    load_zone(L, zone)
    z = L.eval('{ID="%s"}' % zone)
    getattr(L.globals(), zone).ExitSegment(z, RES['Downed'], False, 0, 0)
    acts = show(eng)
    has_exit = any(('EndDungeonRun' in a) or ('EnterZone' in a) or ('EnterGroundMap' in a)
                   for a in acts)
    print('\n  %s : sortie=%s | drapeaux=%s' % (zone, has_exit, flags(L)))
    print('    %s' % ('✅ pas d\'écran noir' if has_exit else '❌ ÉCRAN NOIR'))
