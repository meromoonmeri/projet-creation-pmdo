#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
reduire_base.py — Réduction de la base aux donjons d'histoire + secondaires.

CONSERVE (44 zones) : master_zone, 12 donjons d'histoire, 9 dojo/mazes, 22 secondaires.
TOUT LE RESTE part en RESERVE/ (aucune suppression définitive) :
  RESERVE/zones/ · RESERVE/scripts_zone/ · RESERVE/grounds/ ·
  RESERVE/scripts_ground/ · RESERVE/maps/

Actions :
  1. GroundMaps des zones conservées nettoyés (fichiers existants uniquement) ;
     corrections ciblées : waterfall_pond -> [sanctuaire_voeu],
     poisonous_forest -> [poisonous_forest_*], sky_tower -> [parvis_celeste,
     palier_celeste, tour_ciel_sommet], mazes -> [].
  2. master_zone rebâti : ville + entrées d'histoire + cibles des index codés
     en dur (résolution par nom) + closure des EnterGroundMap des scripts vivants.
  3. index.idx : 44 zones, Grounds alignés.
  4. Migration des index numériques "master_zone" (-1, N) dans les scripts
     vivants (ancien nom -> nouveau index ; fallback metano_town documenté).
  5. Corrections EnterGroundMap cibles inexistantes (sky_tower, waterfall_pond)
     + GROUND_IDX('...') par remplacement de chaînes.
  6. Réécriture du dungeon_entrance_mapping de metano_town (noms exacts).
  7. Déplacement en réserve : zones retirées, scripts de zone retirés, grounds
     morts + leurs scripts, arènes .rsmap non référencées (MapID).

Usage : python3 tools/reduire_base.py [--apply]
"""
# --- Verrou d'exclusivite Ch.6-32 (tools/perimeter_guard.py) ---
import sys as _sys, pathlib as _pathlib
for _anc in _pathlib.Path(__file__).resolve().parents:
    if (_anc / 'tools' / 'perimeter_guard.py').is_file():
        _sys.path.insert(0, str(_anc / 'tools'))
        break
from perimeter_guard import install as _install_perimeter_guard
_install_perimeter_guard()
# --- fin du verrou ---
import json
import io
import os
import re
import shutil
import sys

ROOT = '.'
APPLY = '--apply' in sys.argv

HISTOIRE = ['relic_forest', 'illuminant_riverbed', 'crooked_cavern', 'apricorn_grove',
            'vast_steppe', 'searing_tunnel', 'mount_windswept', 'gloomy_forest',
            'cloven_ruins', 'waterfall_pond', 'poisonous_forest', 'sky_tower']
DOJO = ['beginner_lesson', 'normal_maze', 'bug_maze', 'electric_maze', 'fire_maze',
        'flying_maze', 'grass_maze', 'rock_maze', 'water_maze']
SECONDAIRES = ['petit_tunnel', 'bosquet_voile', 'grotte_mystere', 'vallee_fertile',
               'grotte_repos', 'bois_ronces', 'carriere_cuivre', 'antre_enigme',
               'grotte_echoue', 'halles_royales', 'jardin_secret', 'bois_filou',
               'foret_embuscade', 'crevasse_geode', 'desert_oublies', 'jardin_energie',
               'toundra_desolee', 'bassin_tari', 'marais_errants', 'col_foudre',
               'falaises_envol', 'sentier_enneige']
GARDER = set(HISTOIRE + DOJO + SECONDAIRES + ['master_zone'])

VILLE = ['relic_forest', 'metano_town', 'guild_heros_room', 'guild_bedroom_hallway',
         'guild_bottom_left_bedroom', 'guild_bottom_right_bedroom', 'guild_dining_room',
         'guild_first_floor', 'guild_guildmasters_bedroom', 'guild_guildmasters_room',
         'guild_second_floor', 'guild_storage_hallway', 'guild_storage_room',
         'guild_third_floor_lobby', 'guild_top_left_bedroom', 'guild_top_right_bedroom',
         'metano_altere_transition', 'metano_cafe', 'metano_cave', 'metano_electric_home',
         'metano_fire_home', 'metano_grass_home', 'metano_inn', 'metano_normal_home',
         'metano_rock_home', 'metano_water_home', 'post_office', 'personality_test',
         'ledian_dojo', 'testmap', 'ecran_titre_v2', 'carte_chapitre_v2',
         'luminous_spring', 'altere_pond', 'genesis_vision', 'hero_dream',
         'first_core_location', 'metano_town_nuit', 'colline_sans_lumiere', 'bourg_comptoir']
ENTREES_HISTOIRE = ['illuminant_riverbed_entrance', 'crooked_cavern_entrance',
                    'apricorn_grove_entrance', 'vast_steppe_entrance',
                    'searing_tunnel_entrance', 'mount_windswept_entrance',
                    'gloomy_forest_entrance', 'cloven_ruins_entrance',
                    'poisonous_forest_entrance', 'parvis_celeste', 'sanctuaire_voeu']

FIX_GROUNDMAPS = {
    'waterfall_pond': ['sanctuaire_voeu'],
    'poisonous_forest': ['poisonous_forest_entrance', 'poisonous_forest_relay',
                         'poisonous_forest_miniboss', 'poisonous_forest_boss'],
    'sky_tower': ['parvis_celeste', 'palier_celeste', 'tour_ciel_sommet'],
}
for z in DOJO:
    FIX_GROUNDMAPS[z] = []

# remplacements de noms de grounds dans les scripts vivants (corrections câblage)
FIX_NAME = {
    'sky_tower_relay': 'palier_celeste',
    'sky_tower_fulgur': 'parvis_celeste',
    'sky_tower_entrance': 'parvis_celeste',
    'waterfall_pond_relay': 'sanctuaire_voeu',
    'waterfall_pond_miniboss': 'sanctuaire_voeu',
}

# dungeon_entrance_mapping : donjon -> ground d'entrée (noms, résolus par index)
ENTRANCE_MAPPING = {
    'illuminant_riverbed': 'illuminant_riverbed_entrance',
    'crooked_cavern': 'crooked_cavern_entrance',
    'apricorn_grove': 'apricorn_grove_entrance',
    'vast_steppe': 'vast_steppe_entrance',
    'searing_tunnel': 'searing_tunnel_entrance',
    'mount_windswept': 'mount_windswept_entrance',
    'gloomy_forest': 'gloomy_forest_entrance',
    'cloven_ruins': 'cloven_ruins_entrance',
    'waterfall_pond': 'sanctuaire_voeu',
    'poisonous_forest': 'poisonous_forest_entrance',
}

EGM2 = re.compile(r"EnterGroundMap\s*\(\s*['\"]([a-z0-9_]+)['\"]\s*,\s*['\"]([A-Za-z0-9_]+)['\"]")
EGM3 = re.compile(r"EnterGroundMap\s*\(\s*['\"]([a-z0-9_]+)['\"]\s*,\s*['\"]([a-z0-9_]+)['\"]\s*,\s*['\"]([A-Za-z0-9_]+)['\"]")
ZIDX = re.compile(r"((?:EnterZone|EndDungeonRun|EndSession|EndDungeonDay)\s*\(\s*[^,]*?['\"]master_zone['\"]\s*,\s*-1\s*,\s*)(\d+)")


def load(p):
    return json.load(io.open(p, encoding='utf-8-sig'))


def save(p, d):
    with io.open(p, 'w', encoding='utf-8-sig') as f:
        json.dump(d, f, ensure_ascii=False, indent=2)


def lua_files(d):
    out = []
    if os.path.isdir(d):
        for f in sorted(os.listdir(d)):
            if f.endswith('.lua'):
                out.append(os.path.join(d, f))
    return out


def live_scripts():
    """Scripts des zones conservées + modules globaux + services + megastones/source_duns_imbi
    (ces derniers peuvent référencer des zones retirées via les grounds officiels)."""
    paths = []
    for z in GARDER:
        paths += lua_files('Data/Script/halcyon/zone/%s' % z)
    for root in ['Data/Script/halcyon', 'Data/Script/megastones', 'Data/Script/source_duns_imbi',
                 'Data/Script/origin']:
        if os.path.isdir(root):
            for dp, _, fns in os.walk(root):
                for fn in fns:
                    if fn.endswith('.lua'):
                        paths.append(os.path.join(dp, fn))
    return sorted(set(paths))


def main():
    # ------------------------------------------------------------------
    # 1. Inventaire
    # ------------------------------------------------------------------
    all_zones = sorted(f[:-5] for f in os.listdir('Data/Zone') if f.endswith('.json'))
    retirer = [z for z in all_zones if z not in GARDER]
    all_grounds = sorted(f[:-9] for f in os.listdir('Data/Ground') if f.endswith('.rsground'))
    all_maps = sorted(f[:-6] for f in os.listdir('Data/Map') if f.endswith('.rsmap'))

    # ancienne liste master_zone (pour résolution des index)
    old_mz = load('Data/Zone/master_zone.json')['Object'].get('GroundMaps', [])

    # ------------------------------------------------------------------
    # 2. GroundMaps des zones conservées
    # ------------------------------------------------------------------
    zone_gm = {}
    for z in GARDER:
        p = 'Data/Zone/%s.json' % z
        if not os.path.exists(p):
            continue
        gm = list(load(p)['Object'].get('GroundMaps', []))
        if z in FIX_GROUNDMAPS:
            gm = FIX_GROUNDMAPS[z]
        zone_gm[z] = [g for g in gm if os.path.exists('Data/Ground/%s.rsground' % g)]

    # ------------------------------------------------------------------
    # 3. master_zone rebâti
    # ------------------------------------------------------------------
    mz = [v for v in VILLE if os.path.exists('Data/Ground/%s.rsground' % v)]
    for e in ENTREES_HISTOIRE:
        if os.path.exists('Data/Ground/%s.rsground' % e) and e not in mz:
            mz.append(e)

    # cibles des index codés en dur (EnterZone/EndDungeonRun master_zone -1 N)
    for pth in live_scripts():
        src = open(pth, encoding='utf-8', errors='replace').read()
        for m in ZIDX.finditer(src):
            n = int(m.group(2))
            if n < len(old_mz):
                g = old_mz[n]
                if os.path.exists('Data/Ground/%s.rsground' % g) and g not in mz:
                    mz.append(g)

    # toutes les cibles EGM2 des scripts vivants doivent être déclarées
    # (master_zone = hub déclaratif ; les zones donjon gardent leurs listes)
    for pth in live_scripts():
        src = open(pth, encoding='utf-8', errors='replace').read()
        spans3 = [m.span() for m in EGM3.finditer(src)]
        for m in EGM2.finditer(src):
            if any(s <= m.start() < e for s, e in spans3):
                continue
            t = m.group(2)
            if t not in mz and os.path.exists('Data/Ground/%s.rsground' % t):
                mz.append(t)

    # closure EnterGroundMap depuis les scripts des grounds de master_zone
    changed = True
    guard = 0
    while changed and guard < 8:
        changed = False
        guard += 1
        for g in list(mz):
            for pth in lua_files('Data/Script/halcyon/ground/%s' % g):
                src = open(pth, encoding='utf-8', errors='replace').read()
                for m in EGM2.finditer(src):
                    t = m.group(2)
                    if t not in mz and os.path.exists('Data/Ground/%s.rsground' % t):
                        mz.append(t)
                        changed = True
    zone_gm['master_zone'] = mz

    # ------------------------------------------------------------------
    # 4. Grounds vivants / morts
    # ------------------------------------------------------------------
    alive = set()
    for gm in zone_gm.values():
        alive.update(gm)
    for pth in live_scripts():
        src = open(pth, encoding='utf-8', errors='replace').read()
        for m in EGM2.finditer(src):
            t = m.group(2)
            if os.path.exists('Data/Ground/%s.rsground' % t):
                alive.add(t)
    dead = [g for g in all_grounds if g not in alive]

    # ------------------------------------------------------------------
    # 5. Arènes .rsmap référencées (MapID) par les zones conservées
    # ------------------------------------------------------------------
    kept_maps = set()
    for z in GARDER:
        p = 'Data/Zone/%s.json' % z
        if os.path.exists(p):
            s = json.dumps(load(p))
            for m in re.finditer(r'"MapID"\s*:\s*"([a-z0-9_]+)"', s):
                kept_maps.add(m.group(1))
    dead_maps = [m for m in all_maps if m not in kept_maps]

    # ------------------------------------------------------------------
    # 6. Rapport
    # ------------------------------------------------------------------
    print('=' * 78)
    print(' RÉDUCTION DE LA BASE' + (' — APPLICATION' if APPLY else ' — DRY-RUN'))
    print('=' * 78)
    print('Zones conservées : %d | retirées : %d' % (len(GARDER), len(retirer)))
    print('master_zone : %d grounds' % len(mz))
    print('Grounds vivants : %d | morts : %d' % (len(alive), len(dead)))
    print('Arènes conservées : %d | mortes : %d' % (len(kept_maps), len(dead_maps)))
    print()
    for z in sorted(GARDER):
        print('  %-24s %2d : %s' % (z, len(zone_gm[z]), zone_gm[z][:6]))
    print()
    print('Morts -> RESERVE (%d) :' % len(dead))
    print('  ' + ', '.join(dead[:40]) + ('...' if len(dead) > 40 else ''))
    print()
    print('Zones retirées (%d) :' % len(retirer))
    print('  ' + ', '.join(retirer[:40]) + ('...' if len(retirer) > 40 else ''))

    if not APPLY:
        print()
        print('(dry-run — relancer avec --apply)')
        return 0

    # ------------------------------------------------------------------
    # 7. Application
    # ------------------------------------------------------------------
    for d in ['RESERVE/zones', 'RESERVE/scripts_zone', 'RESERVE/grounds',
              'RESERVE/scripts_ground', 'RESERVE/maps']:
        os.makedirs(d, exist_ok=True)

    moved_zones = moved_scripts = moved_grounds = moved_gscripts = moved_maps = 0
    for z in retirer:
        p = 'Data/Zone/%s.json' % z
        if os.path.exists(p):
            shutil.move(p, 'RESERVE/zones/%s.json' % z)
            moved_zones += 1
        sp = 'Data/Script/halcyon/zone/%s' % z
        if os.path.isdir(sp):
            shutil.move(sp, 'RESERVE/scripts_zone/%s' % z)
            moved_scripts += 1
    for g in dead:
        shutil.move('Data/Ground/%s.rsground' % g, 'RESERVE/grounds/%s.rsground' % g)
        moved_grounds += 1
        sg = 'Data/Script/halcyon/ground/%s' % g
        if os.path.isdir(sg):
            shutil.move(sg, 'RESERVE/scripts_ground/%s' % g)
            moved_gscripts += 1
    for m in dead_maps:
        shutil.move('Data/Map/%s.rsmap' % m, 'RESERVE/maps/%s.rsmap' % m)
        moved_maps += 1
    print('Déplacés : %d zones, %d scripts_zone, %d grounds, %d scripts_ground, %d maps'
          % (moved_zones, moved_scripts, moved_grounds, moved_gscripts, moved_maps))

    # 7.2 JSON des zones conservées
    for z in GARDER:
        p = 'Data/Zone/%s.json' % z
        if os.path.exists(p):
            d = load(p)
            d['GroundMaps'] = zone_gm[z]
            save(p, d)
    print('JSON des %d zones conservées réécrits (GroundMaps nets)' % len(GARDER))

    # 7.3 index.idx
    idx = load('Data/Zone/index.idx')
    obj = idx['Object']
    nz = 0
    for z in list(obj.keys()):
        if z == '$type':
            continue
        if z not in GARDER:
            del obj[z]
            nz += 1
        else:
            obj[z]['Grounds'] = zone_gm.get(z, [])
    save('Data/Zone/index.idx', idx)
    print('index.idx : %d zones retirées, Grounds alignés' % nz)

    # 7.4 migration des index master_zone
    new_mz = zone_gm['master_zone']
    migrated, dropped = 0, []
    for pth in live_scripts():
        src = open(pth, encoding='utf-8', errors='replace').read()
        new_src, n = ZIDX.subn(
            lambda m: _mig(m, old_mz, new_mz, dropped), src)
        if n:
            migrated += n
            open(pth, 'w', encoding='utf-8').write(new_src)
    print('Index migrés : %d (dont %d retombés sur metano_town)' % (migrated, len(dropped)))
    for d in dropped:
        print('   ! %s' % d)

    # 7.5 corrections de noms (EnterGroundMap + GROUND_IDX)
    fixed = 0
    for pth in live_scripts():
        src = open(pth, encoding='utf-8', errors='replace').read()
        new_src = src
        for old, new in FIX_NAME.items():
            new_src = new_src.replace("'%s'" % old, "'%s'" % new)
            new_src = new_src.replace('"%s"' % old, '"%s"' % new)
        if new_src != src:
            fixed += 1
            open(pth, 'w', encoding='utf-8').write(new_src)
    print('Fichiers avec noms de grounds corrigés (sky_tower/waterfall_pond) : %d' % fixed)

    # 7.6 dungeon_entrance_mapping (metano_town)
    p = 'Data/Script/halcyon/ground/metano_town/init.lua'
    if os.path.exists(p):
        src = open(p, encoding='utf-8', errors='replace').read()
        def repl(m):
            dg = m.group(1)
            if dg in ENTRANCE_MAPPING:
                g = ENTRANCE_MAPPING[dg]
                idx = new_mz.index(g) if g in new_mz else 1
                return 'dungeon_entrance_mapping["%s"] = %d' % (dg, idx)
            return m.group(0)
        src2 = re.sub(r'dungeon_entrance_mapping\["([a-z0-9_]+)"\]\s*=\s*\d+', repl, src)
        # retirer celestial_peak du menu et du mapping
        src2 = re.sub(r'(?m)^\s*"celestial_peak"\s*,?\s*$', '', src2)
        src2 = re.sub(r'(?m)^\s*"tornadus_arena"\s*,?\s*$', '', src2)
        src2 = re.sub(r'(?m)^\s*dungeon_entrance_mapping\["celestial_peak"\]\s*=.*$\n?', '', src2)
        if src2 != src:
            open(p, 'w', encoding='utf-8').write(src2)
            print('metano_town/init.lua : dungeon_entrance_mapping réécrit, celestial_peak/tornadus_arena retirés')

    # 7.7 purges des modules globaux
    purge_legend_zones(retirer)
    purge_mission_gen(retirer)
    purge_debug_tools(retirer)
    purge_secondary_jobs(retirer)
    purge_side_quests(retirer)
    purge_veilleur(retirer)

    print()
    print('Terminé — relancer les audits.')


def _mig(m, old_mz, new_mz, dropped):
    n = int(m.group(2))
    name = old_mz[n] if n < len(old_mz) else None
    if name and name in new_mz:
        return m.group(1) + str(new_mz.index(name))
    dropped.append('%s (ancien %s -> %s)' % (m.group(0)[:50], n, name))
    fb = new_mz.index('metano_town') if 'metano_town' in new_mz else 0
    return m.group(1) + str(fb)


def purge_legend_zones(retirer):
    """Supprime les contrats dont la zone est retirée (blocs { ... zone='X' ... })."""
    ret = set(retirer)
    p = 'Data/Script/halcyon/LegendZones.lua'
    if not os.path.exists(p):
        return
    src = open(p, encoding='utf-8', errors='replace').read()
    # un contrat = bloc indenté de 4 espaces commençant par { et finissant par },
    bloc = re.compile(r'    \{[^{}]*?zone\s*=\s*[^\n]*\n(?:.*?\n)*?    \},', re.M)
    out_lines = []
    i = 0
    lines = src.split('\n')
    n = 0
    while i < len(lines):
        line = lines[i]
        mz = re.search(r"zone\s*=\s*'([a-z0-9_]+)'", line)
        if mz and mz.group(1) in ret:
            # remonter jusqu'au début du bloc (ligne "    {")
            j = i
            while j >= 0 and not re.match(r'^    \{', lines[j]):
                j -= 1
            # descendre jusqu'à la fin du bloc (ligne "    },")
            k = i
            while k < len(lines) and not re.match(r'^    \},$', lines[k]):
                k += 1
            # supprimer aussi les commentaires immédiatement avant le bloc
            while j > 0 and (lines[j-1].strip().startswith('--') or lines[j-1].strip() == ''):
                j -= 1
            # reconstruire : on coupe out_lines à la position du bloc
            start_idx = len(out_lines)
            # on supprime les lignes du bloc dans out_lines en remontant
            for _ in range(i - j):
                if out_lines and (out_lines[-1].strip().startswith('--') or out_lines[-1].strip() == '' or re.match(r'^    \{', out_lines[-1])):
                    out_lines.pop()
            i = k + 1
            n += 1
            continue
        out_lines.append(line)
        i += 1
    open(p, 'w', encoding='utf-8').write('\n'.join(out_lines))
    print('LegendZones.lua : %d contrats retirés' % n)


def purge_mission_gen(retirer):
    ret = set(retirer)
    p = 'Data/Script/halcyon/mission_gen.lua'
    if not os.path.exists(p):
        return
    src = open(p, encoding='utf-8', errors='replace').read()
    n = 0
    for z in ret:
        for pat in [r'^\s*MISSION_GEN\.DUNGEON_DIFFICULTY\["%s"\]\s*=.*$' % re.escape(z),
                    r'^\s*MISSION_GEN\.EXPECTED_LEVEL\["%s"\]\s*=.*$' % re.escape(z)]:
            src, c = re.subn(pat, '', src, flags=re.M)
            n += c
    open(p, 'w', encoding='utf-8').write(src)
    print('mission_gen.lua : %d entrées retirées' % n)


def purge_debug_tools(retirer):
    ret = set(retirer)
    p = 'Data/Script/halcyon/services/debug_tools/init.lua'
    if not os.path.exists(p):
        return
    src = open(p, encoding='utf-8', errors='replace').read()
    lines = src.split('\n')
    out = []
    n = 0
    for line in lines:
        hit = any(re.search(r'["\']%s["\']' % re.escape(z), line) for z in ret)
        if hit:
            n += 1
            continue
        out.append(line)
    open(p, 'w', encoding='utf-8').write('\n'.join(out))
    print('debug_tools/init.lua : %d lignes retirées' % n)


def purge_secondary_jobs(retirer):
    ret = set(retirer)
    p = 'Data/Script/halcyon/SecondaryJobs.lua'
    if not os.path.exists(p):
        return
    src = open(p, encoding='utf-8', errors='replace').read()
    lines = src.split('\n')
    out = []
    n = 0
    for line in lines:
        m = re.search(r"zone\s*=\s*'([a-z0-9_]+)'", line)
        if m and m.group(1) in ret:
            n += 1
            continue
        out.append(line)
    open(p, 'w', encoding='utf-8').write('\n'.join(out))
    print('SecondaryJobs.lua : %d entrées retirées' % n)


def purge_side_quests(retirer):
    ret = set(retirer)
    p = 'Data/Script/halcyon/SideQuests.lua'
    if not os.path.exists(p):
        return
    src = open(p, encoding='utf-8', errors='replace').read()
    # blocs de quêtes : { ... unlock_dungeon = 'X' ... } — suppression par bloc indenté
    lines = src.split('\n')
    out = []
    i = 0
    n = 0
    while i < len(lines):
        line = lines[i]
        m = re.search(r"unlock_dungeon\s*=\s*'([a-z0-9_]+)'", line)
        if m and m.group(1) in ret:
            j = i
            while j >= 0 and not re.match(r'^\s*\{', lines[j]):
                j -= 1
            k = i
            while k < len(lines) and not re.match(r'^\s*\},?\s*$', lines[k]):
                k += 1
            # retirer les lignes j..k de out si elles y sont encore
            # (out contient déjà les lignes < i) : remonter
            remove = i - j
            for _ in range(remove):
                if out and (re.match(r'^\s*\{', out[-1]) or out[-1].strip() == '' or out[-1].strip().startswith('--')):
                    out.pop()
            i = k + 1
            n += 1
            continue
        out.append(line)
        i += 1
    open(p, 'w', encoding='utf-8').write('\n'.join(out))
    print('SideQuests.lua : %d blocs retirés' % n)


def purge_veilleur(retirer):
    ret = set(retirer)
    p = 'Data/Script/halcyon/VeilleurArc.lua'
    if not os.path.exists(p):
        return
    src = open(p, encoding='utf-8', errors='replace').read()
    lines = src.split('\n')
    out = []
    i = 0
    n = 0
    while i < len(lines):
        line = lines[i]
        m = re.search(r"zone\s*=\s*'([a-z0-9_]+)'", line)
        if m and m.group(1) in ret:
            j = i
            while j >= 0 and not re.match(r'^\s*\{', lines[j]):
                j -= 1
            k = i
            while k < len(lines) and not re.match(r'^\s*\},?\s*$', lines[k]):
                k += 1
            for _ in range(i - j):
                if out and (re.match(r'^\s*\{', out[-1]) or out[-1].strip() == '' or out[-1].strip().startswith('--')):
                    out.pop()
            i = k + 1
            n += 1
            continue
        out.append(line)
        i += 1
    open(p, 'w', encoding='utf-8').write('\n'.join(out))
    print('VeilleurArc.lua : %d contrats retirés' % n)


if __name__ == '__main__':
    sys.exit(main())
