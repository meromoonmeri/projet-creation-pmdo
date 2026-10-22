#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
audit_grounds_correlation.py — AUDIT EXHAUSTIF : CORRÉLATION & UNICITÉ DES GROUNDS (.rsground)

Périmètre
---------
Tout l'écosystème d'une carte Ground dans un mod PMDO :
  1. le fichier Data/Ground/<nom>.rsground
  2. son enregistrement dans Data/Zone/index.idx  (liste `Grounds` par zone —
     c'est l'index compilé interrogé par GameManager.MoveToGround:710-715)
  3. son enregistrement dans Data/Zone/<zone>.json (liste `GroundMaps` —
     résolution de l'index réel, GameManager.MoveToGround:729-731)
  4. les références Lua  GAME:EnterGroundMap(...)  (ScriptGame.cs:104 / :116)
  5. les marqueurs d'entrée cités dans le 2e argument de EnterGroundMap
     (GetEntryPointIdx -> KeyNotFoundException si absent, GroundMap.cs:947)
  6. les scripts de carte Data/Script/halcyon/ground/<nom>/
  7. l'asset musique (Content/Music/<Music>)

Contrôles d'UNICITÉ
-------------------
  U1  doublons de nom interne (Name.DefaultText) entre fichiers
  U2  doublons de contenu (md5) entre fichiers
  U3  candidats quasi-doublons (même taille ±2 o, même musique, mêmes dims)
  U4  doublons d'enregistrement dans une liste Grounds/GroundMaps
      (décale tous les index codés en dur : cf. verify_ground_targets.py)
  U5  AssetName incohérent avec le nom de fichier
  U6  EntName en double au sein d'une même carte (marqueurs/spawners/objets)

Contrôles de CORRÉLATION
------------------------
  C1  déclaré dans index.idx mais fichier absent du disque
  C2  divergence entre index.idx et Data/Zone/<zone>.json (GroundMaps)
  C3  fichier .rsground présent mais déclaré dans AUCUNE zone
  C4  cible de EnterGroundMap : fichier absent / non déclarée dans la zone
      visée / marqueur d'entrée absent de la carte cible
  C5  cartes dormantes : ni déclarées, ni référencées, ni scriptées
  C6  dossier de script sans carte, carte avec script sans init.lua
  C7  musique référencée absente de Content/Music
  C8  EnterZone(zone, -1, N) : index de ground codé en dur, hors bornes ou
      incohérent avec la zone (extension de verify_ground_targets.py)

Usage : python3 tools/audit_grounds_correlation.py [racine] [--json out.json]
Sortie : code 2 = anomalies bloquantes, 1 = avertissements, 0 = vert.
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
import hashlib
import io
import json
import os
import re
import sys

ROOT = sys.argv[1] if len(sys.argv) > 1 and not sys.argv[1].startswith('--') else '.'
GROUND_DIR = os.path.join(ROOT, 'Data', 'Ground')
ZONE_DIR = os.path.join(ROOT, 'Data', 'Zone')
SCRIPT_DIR = os.path.join(ROOT, 'Data', 'Script')
GSCRIPT_DIR = os.path.join(SCRIPT_DIR, 'halcyon', 'ground')
MUSIC_DIR = os.path.join(ROOT, 'Content', 'Music')

BLOCK = 'BLOQUANT'
WARN = 'AVERTISSEMENT'
INFO = 'info'


def load(path):
    with io.open(path, encoding='utf-8-sig') as f:
        return json.load(f)


# --------------------------------------------------------------------------
# 0. Lecture des cartes
# --------------------------------------------------------------------------
def parse_grounds():
    """Retourne {nom: {summary}}. Résumé compact + entités."""
    out = {}
    files = sorted(f for f in os.listdir(GROUND_DIR) if f.endswith('.rsground'))
    for f in files:
        name = f[:-9]
        p = os.path.join(GROUND_DIR, f)
        st = os.stat(p)
        h = hashlib.md5(open(p, 'rb').read()).hexdigest()
        try:
            obj = load(p)['Object']
            ents = obj.get('Entities', [])
            ent0 = ents[0] if ents else {}
            markers = [m.get('EntName', '') for m in ent0.get('Markers', [])]
            spawners = [s.get('EntName', '') for s in ent0.get('Spawners', [])]
            gobjs, chars = [], []
            per_layer = []  # (nom_couche, gobjs, chars) pour le contrôle U6 intra-couche
            for e in ents:
                gl = [g.get('EntName', '') for g in e.get('GroundObjects', [])]
                cl = [c.get('EntName', '') for c in e.get('MapChars', [])]
                gobjs += gl
                chars += cl
                per_layer.append((e.get('Name', '?'), gl, cl))
            layers = obj.get('Layers', [])
            tiles = layers[0]['Tiles'] if layers else []
            out[name] = {
                'asset': obj.get('AssetName'),
                'name': obj.get('Name', {}).get('DefaultText', ''),
                'released': obj.get('Released'),
                'comment': obj.get('Comment', ''),
                'music': obj.get('Music', ''),
                'w': len(tiles) if tiles else 0,
                'h': len(tiles[0]) if tiles and tiles[0] else 0,
                'entities': len(ents),
                'markers': markers,
                'spawners': spawners,
                'gobjs': gobjs,
                'chars': chars,
                'per_layer': per_layer,
                'size': st.st_size,
                'md5': h,
            }
        except Exception as e:
            out[name] = {'error': str(e), 'size': st.st_size, 'md5': h}
    return out


# --------------------------------------------------------------------------
# 1. Registres de zones
# --------------------------------------------------------------------------
def read_registers():
    idx = load(os.path.join(ZONE_DIR, 'index.idx'))['Object']
    zones_idx = {}
    for z, v in idx.items():
        if z == '$type' or not isinstance(v, dict):
            continue
        zones_idx[z] = list(v.get('Grounds', []))
    zones_json = {}
    for f in sorted(x for x in os.listdir(ZONE_DIR) if x.endswith('.json')):
        z = f[:-5]
        try:
            d = load(os.path.join(ZONE_DIR, f))
        except Exception:
            continue

        def walk(o, acc):
            if isinstance(o, dict):
                for k, v in o.items():
                    if k == 'GroundMaps':
                        acc.extend(v if isinstance(v, list) else [])
                    else:
                        walk(v, acc)
            elif isinstance(o, list):
                for v in o:
                    walk(v, acc)
        acc = []
        walk(d, acc)
        zones_json[z] = acc
    return zones_idx, zones_json


# --------------------------------------------------------------------------
# 2. Références Lua
# --------------------------------------------------------------------------
# Les noms de ZONES et de CARTES sont en minuscules ; les noms de MARQUEURS
# d'entrée sont en casse mixte (Main_Entrance_Marker, Guild_Entrance_Marker...).
EGM2 = re.compile(r"EnterGroundMap\s*\(\s*['\"]([a-z0-9_]+)['\"]\s*,\s*['\"]([A-Za-z0-9_]+)['\"]")
EGM3 = re.compile(r"EnterGroundMap\s*\(\s*['\"]([a-z0-9_]+)['\"]\s*,\s*['\"]([a-z0-9_]+)['\"]\s*,\s*['\"]([A-Za-z0-9_]+)['\"]")
EZONE = re.compile(r"EnterZone\s*\(\s*['\"]([a-z0-9_]+)['\"]\s*,\s*-1\s*,\s*(\d+)")


def lua_refs():
    """Toutes les références EnterGroundMap / EnterZone indexées par fichier."""
    refs = []  # (fichier, namespace, type, args)
    for f in sorted(
            os.path.join(dp, fn) for dp, _, fns in os.walk(SCRIPT_DIR) for fn in fns
            if fn.endswith('.lua')):
        src = open(f, encoding='utf-8', errors='replace').read()
        src_nc = re.sub(r'--\[(=*)\[.*?\]\1\]', '', src, flags=re.S)
        src_nc = '\n'.join(re.sub(r'--.*$', '', l) for l in src_nc.split('\n'))
        rel = os.path.relpath(f, ROOT)
        # d'abord les appels à 3 chaînes (zone, carte, entrée)…
        egm3 = [(m, m.span()) for m in EGM3.finditer(src_nc)]
        for m, _ in egm3:
            refs.append((rel, 'egm3', (m.group(1), m.group(2), m.group(3))))
        # …puis les appels à 2 chaînes (carte, entrée) hors des spans 3-args
        for m in EGM2.finditer(src_nc):
            if any(s <= m.start() < e for _, (s, e) in egm3):
                continue
            refs.append((rel, 'egm2', (m.group(1), m.group(2))))
        for m in EZONE.finditer(src_nc):
            refs.append((rel, 'ezone', (m.group(1), int(m.group(2)))))
    return refs


def ground_script_dir_for(lua_file):
    """Dossier de carte auquel appartient un fichier Lua (si ground/<carte>/...)."""
    m = re.match(r'Data/Script/[^/]+/ground/([^/]+)/', lua_file.replace('\\', '/'))
    return m.group(1) if m else None


def zone_of_map(grounds_idx, mapname):
    return [z for z, gs in grounds_idx.items() if mapname in gs]


def main():
    print('Lecture des %s cartes .rsground...' %
          len([f for f in os.listdir(GROUND_DIR) if f.endswith('.rsground')]))
    grounds = parse_grounds()
    zones_idx, zones_json = read_registers()
    refs = lua_refs()
    files = set(grounds)

    problems, warns, infos = [], [], []
    P = problems.append
    W = warns.append
    I = infos.append

    # ======================================================================
    # A. UNICITÉ
    # ======================================================================
    print('A. Unicité...')
    # U1 doublons de nom interne — une famille de >5 cartes est un nom de
    # template générique volontaire (relais procéduraux) ; 2-5 cartes = doublon
    # accidentel probable.
    by_name = {}
    for n, g in grounds.items():
        if 'error' in g:
            continue
        by_name.setdefault(g['name'].strip(), []).append(n)
    for nm, lst in sorted(by_name.items()):
        if len(lst) > 1:
            msg = 'nom interne dupliqué: %r porté par %s' % (nm, ', '.join(lst))
            if len(lst) <= 5:
                W(('U1', msg))
            else:
                I(('U1', msg + ' (famille générique volontaire — template)'))

    # U2 doublons de contenu
    by_md5 = {}
    for n, g in grounds.items():
        by_md5.setdefault(g['md5'], []).append(n)
    for h, lst in sorted(by_md5.items()):
        if len(lst) > 1:
            P(('U2', 'contenu identique (md5 %s) : %s' % (h[:12], ', '.join(lst))))

    # U3 quasi-doublons (même taille, musique et dims, fichiers distincts)
    # Les PLACEHOLDER de débogage (tools/materialise_phantoms.py) sont
    # identiques par construction : on les exclut du signal.
    def _is_placeholder(g):
        try:
            with io.open(os.path.join(GROUND_DIR, g + '.rsground'),
                         encoding='utf-8-sig') as fh:
                return 'PLACEHOLDER DE DÉBOGAGE' in fh.read(2000)
        except Exception:
            return False

    seen = set()
    for a in sorted(grounds):
        if 'error' in grounds[a] or _is_placeholder(a):
            continue
        for b in sorted(grounds):
            if b <= a or (a, b) in seen:
                continue
            ga, gb = grounds[a], grounds[b]
            if 'error' in ga or 'error' in gb:
                continue
            if (abs(ga['size'] - gb['size']) <= 2 and ga['music'] == gb['music']
                    and ga['w'] == gb['w'] and ga['h'] == gb['h'] and ga['md5'] != gb['md5']):
                seen.add((a, b))
                W(('U3', 'quasi-doublon potentiel %s (%d o, %sx%s) <-> %s (%d o)' %
                   (a, ga['size'], ga['w'], ga['h'], b, gb['size'])))

    # U4 doublons d'enregistrement
    for z, gs in zones_idx.items():
        dup = sorted({g for g in gs if gs.count(g) > 1})
        if dup:
            W(('U4', 'index.idx[%s] : entrées en double %s' % (z, dup)))
    for z, gs in zones_json.items():
        dup = sorted({g for g in gs if gs.count(g) > 1})
        if dup:
            W(('U4', '%s.json GroundMaps : entrées en double %s' % (z, dup)))

    # U5 AssetName
    for n, g in grounds.items():
        if 'error' not in g and g['asset'] != n:
            P(('U5', '%s : AssetName=%r != nom de fichier' % (n, g['asset'])))

    # U6 EntName dupliqués dans une carte
    #  - intra-couche (même Entities layer) : vrai doublon, bloquant pour
    #    les handlers (le moteur ne sait pas lequel déclencher)
    #  - inter-couches : redondance, généralement variantes jour/nuit
    for n, g in grounds.items():
        if 'error' in g:
            continue
        for cat in ('markers', 'spawners'):
            lst = g[cat]
            dup = sorted({x for x in lst if x and lst.count(x) > 1})
            if dup:
                W(('U6', '%s : %s dupliqués %s' % (n, cat, dup)))
        for lname, gl, cl in g['per_layer']:
            for cat, lst in (('gobjs', gl), ('chars', cl)):
                dup = sorted({x for x in lst if x and lst.count(x) > 1})
                if dup:
                    W(('U6', '%s : %s dupliqués intra-couche %r : %s' %
                       (n, cat, lname, dup)))
        gdup = sorted({x for x in g['gobjs'] if x and g['gobjs'].count(x) > 1})
        cdup = sorted({x for x in g['chars'] if x and g['chars'].count(x) > 1})
        if gdup:
            I(('U6', '%s : %s dupliqués INTER-couches (variante jour/nuit ?) : %s' %
               (n, 'gobjs', gdup)))
        if cdup:
            I(('U6', '%s : %s dupliqués INTER-couches (variante jour/nuit ?) : %s' %
               (n, 'chars', cdup)))

    # ======================================================================
    # B. CORRÉLATION registres
    # ======================================================================
    print('B. Registres...')
    declared = {}
    for z, gs in zones_idx.items():
        for g in gs:
            declared.setdefault(g, []).append(z)

    # C1 déclarés sans fichier
    for g in sorted(declared):
        if g not in files:
            P(('C1', 'déclaré dans index.idx (%s) mais AUCUN fichier %s.rsground'
               % (', '.join(declared[g]), g)))

    # C2 divergence index.idx <-> <zone>.json
    for z in sorted(set(zones_idx) | set(zones_json)):
        a = set(zones_idx.get(z, []))
        b = set(zones_json.get(z, []))
        if a != b:
            only_a = sorted(a - b)
            only_b = sorted(b - a)
            if only_a or only_b:
                W(('C2', 'zone %s : index.idx et %s.json divergent — dans index seul: %s | '
                   'dans json seul: %s' % (z, z, only_a, only_b)))

    # C3 fichiers non déclarés
    not_declared = sorted(files - set(declared))
    I(('C3', '%d cartes non déclarées dans AUCUNE zone : %s' %
       (len(not_declared), ', '.join(not_declared) or '-')))

    # ======================================================================
    # C. CORRÉLATION références Lua
    # ======================================================================
    print('C. Références Lua (%d)...' % len(refs))

    def ctx_zones(rel):
        """Zone(s) probable(s) du code appelant :
        zone/<z>/... -> [z] ; ground/<m>/... -> zones contenant m ;
        partagé (TownNight...) -> toutes les zones (None = inconnu)."""
        m = re.match(r'Data/Script/[^/]+/zone/([^/]+)/', rel.replace('\\', '/'))
        if m:
            return [m.group(1)]
        m = re.match(r'Data/Script/[^/]+/ground/([^/]+)/', rel.replace('\\', '/'))
        if m:
            zs = zone_of_map(zones_idx, m.group(1))
            return zs if zs else None
        return None

    def check_target(rel, kind, zone_ctx, mapname, entry):
        """Vérifie la chaîne complète pour une cible EnterGroundMap."""
        caller_zones = ctx_zones(rel)
        if kind == 'egm2' and caller_zones:
            zone_list = caller_zones
        elif kind == 'egm3':
            zone_list = [zone_ctx]
        else:
            zone_list = None  # fichier partagé : contexte zone inconnu
        if mapname not in files:
            P(('C4', '%s -> EnterGroundMap(%r) : AUCUN fichier .rsground' % (rel, mapname)))
            return
        if zone_list is None:
            zones = zone_of_map(zones_idx, mapname)
            if not zones:
                P(('C4', '%s -> EnterGroundMap(%r) : carte déclarée dans AUCUNE zone '
                   '(Invalid Ground Map Name)' % (rel, mapname)))
        else:
            # b. présence dans l'index de la zone d'exécution (GroundValid)
            ok_idx = [z for z in zone_list if mapname in zones_idx.get(z, [])]
            if not ok_idx:
                P(('C4', '%s (zone %s) -> EnterGroundMap(%r) : cible absente des Grounds '
                   'de la zone (Invalid Ground Map Name)' % (rel, zone_list, mapname)))
            # c. présence dans la liste GroundMaps du json de zone (FindIndex)
            ok_json = [z for z in zone_list if mapname in zones_json.get(z, [])]
            if not ok_json:
                P(('C4', '%s -> EnterGroundMap(%r) : cible ABSENTE de GroundMaps de %s '
                   '(Cannot find ground map -> exception moteur)' %
                   (rel, mapname, zone_list)))
        # d. marqueur d'entrée
        if entry and mapname in grounds and 'error' not in grounds[mapname]:
            if entry not in grounds[mapname]['markers']:
                P(('C4', '%s -> EnterGroundMap(%r, %r) : marqueur d entrée %r ABSENT '
                   'de la carte cible (KeyNotFoundException)' %
                   (rel, mapname, entry, entry)))

    egm_targets = {}
    for rel, kind, args in refs:
        if kind == 'egm2':
            mapname, entry = args
            egm_targets.setdefault(mapname, set()).add(rel)
            check_target(rel, 'egm2', None, mapname, entry)
        elif kind == 'egm3':
            zone, mapname, entry = args
            egm_targets.setdefault(mapname, set()).add(rel)
            check_target(rel, 'egm3', zone, mapname, entry)
        elif kind == 'ezone':
            zone, idx = args
            idx_list = zones_idx.get(zone, [])
            json_list = zones_json.get(zone, idx_list)
            if idx >= len(idx_list):
                P(('C8', '%s -> EnterZone(%r, -1, %d) : index HORS BORNES index.idx '
                   '(%d grounds)' % (rel, zone, idx, len(idx_list))))
            elif idx >= len(json_list):
                P(('C8', '%s -> EnterZone(%r, -1, %d) : index HORS BORNES %s.json '
                   'GroundMaps (%d entrées)' % (rel, zone, idx, zone, len(json_list))))
            else:
                got = json_list[idx]
                if got not in files:
                    P(('C8', '%s -> EnterZone(%r, -1, %d) : GroundMaps[%d]=%r '
                       'déclaré mais AUCUN fichier .rsground (crash au transfert)' %
                       (rel, zone, idx, idx, got)))
                elif not got.startswith(zone.split('_')[0]) and got not in (
                        'metano_town', 'metano_town_nuit', 'guild_heros_room', 'metano_cafe',
                        'metano_inn', 'guild_main_hall'):
                    I(('C8', '%s -> EnterZone(%r, -1, %d) : GroundMaps[%d]=%r sans rapport '
                       'apparent avec la zone (retour volontaire probable)' %
                       (rel, zone, idx, idx, got)))

    # C9 dungeon_entrance_mapping (table Lua de metano_town) : index résolus
    # contre master_zone.json GroundMaps.
    DEM = re.compile(r"dungeon_entrance_mapping\[\s*['\"]([a-z0-9_]+)['\"]\s*\]\s*=\s*(\d+)")
    mz_json = zones_json.get('master_zone', [])
    for rel, kind, args in refs:
        pass
    for dp, _, fns in os.walk(SCRIPT_DIR):
        for fn in fns:
            if not fn.endswith('.lua'):
                continue
            p = os.path.join(dp, fn)
            src = open(p, encoding='utf-8', errors='replace').read()
            for m in DEM.finditer(src):
                dungeon, n = m.group(1), int(m.group(2))
                got = mz_json[n] if n < len(mz_json) else 'HORS BORNES'
                if n >= len(mz_json):
                    W(('C9', '%s : dungeon_entrance_mapping[%r]=%d HORS BORNES '
                       '(%d entrées master_zone.json)' % (p, dungeon, n, len(mz_json))))
                elif got not in files:
                    P(('C9', '%s : dungeon_entrance_mapping[%r]=%d -> GroundMaps[%d]=%r '
                       'AUCUN fichier (menu destination -> crash)' %
                       (p, dungeon, n, n, got)))
                elif not got.startswith(dungeon.split('_')[0]) and got != 'parvis_celeste':
                    W(('C9', '%s : dungeon_entrance_mapping[%r]=%d -> %r sans rapport '
                       'avec le donjon (index glissé ?)' % (p, dungeon, n, got)))

    # C5 dormantes : ni déclarées, ni référencées, ni script
    scripted = set()
    if os.path.isdir(GSCRIPT_DIR):
        scripted = {d for d in os.listdir(GSCRIPT_DIR)
                    if os.path.isdir(os.path.join(GSCRIPT_DIR, d))}
    dormant = sorted(files - set(declared) - set(egm_targets) - scripted)
    I(('C5', '%d cartes dormantes (aucune zone, aucun EnterGroundMap, aucun script) : %s' %
       (len(dormant), ', '.join(dormant) or '-')))

    # C6 scripts
    for d in sorted(scripted - files):
        W(('C6', 'dossier de script ground/%s sans carte .rsground' % d))
    for n in sorted(files - scripted):
        if grounds[n].get('released') and n in egm_targets:
            I(('C6', '%s : carte atteignable sans dossier de script (init par défaut)' % n))

    # C7 musiques — comparaison à la liste réelle, casse signalée à part
    music_files = set()
    if os.path.isdir(MUSIC_DIR):
        music_files = {f for f in os.listdir(MUSIC_DIR)}
    missing_music, case_music = {}, {}
    for n, g in grounds.items():
        if 'error' in g or not g['music']:
            continue
        m = g['music']
        if m not in music_files:
            if m.lower() in {f.lower() for f in music_files}:
                case_music.setdefault(m, []).append(n)
            else:
                missing_music.setdefault(m, []).append(n)
    for m, lst in sorted(missing_music.items()):
        W(('C7', 'musique %r ABSENTE de Content/Music — %d carte(s) : %s' %
           (m, len(lst), ', '.join(lst))))
    for m, lst in sorted(case_music.items()):
        W(('C7', 'musique %r : casse différente du fichier réel (silence sur '
           'systèmes sensibles) — %d carte(s) : %s' %
           (m, len(lst), ', '.join(lst))))

    # ======================================================================
    # Rapport
    # ======================================================================
    lines = []
    ap = lines.append
    ap('=' * 90)
    ap(' AUDIT EXHAUSTIF — CORRÉLATION & UNICITÉ DES GROUNDS (.rsground)')
    ap('=' * 90)
    ap('')
    ap('Fichiers .rsground ................ %d' % len(files))
    ap('Grounds déclarés index.idx ........ %d (toutes zones, uniques)' % len(declared))
    ap('Zones dans index.idx .............. %d' % len(zones_idx))
    ap('Fichiers zone .json ............... %d' % len(zones_json))
    ap('Références Lua EnterGroundMap ..... %d' %
       sum(1 for r in refs if r[1] in ('egm2', 'egm3')))
    ap('Cartes distinctes visées .......... %d' % len(egm_targets))
    ap('')
    ap('--- UNICITÉ ---')
    u = [x for x in problems if x[0].startswith('U')]
    uw = [x for x in warns if x[0].startswith('U')]
    ap('  U1 nom interne dupliqué .......... %d' % len([x for x in u if x[0] == 'U1']))
    ap('  U2 contenu identique (md5) ....... %d' % len([x for x in u if x[0] == 'U2']))
    ap('  U3 quasi-doublons ................ %d' % len([x for x in uw if x[0] == 'U3']))
    ap('  U4 enregistrements en double ..... %d' % len([x for x in uw if x[0] == 'U4']))
    ap('  U5 AssetName incohérent ......... %d' % len([x for x in u if x[0] == 'U5']))
    ap('  U6 EntName dupliqués intra-carte . %d' % len([x for x in uw if x[0] == 'U6']))
    ap('')
    ap('--- CORRÉLATION ---')
    ap('  C1 déclarés sans fichier ......... %d' % len([x for x in problems if x[0] == 'C1']))
    ap('  C2 index vs zone.json ........... %d' % len([x for x in uw if x[0] == 'C2']))
    ap('  C4 cibles EnterGroundMap ......... %d' % len([x for x in problems if x[0] == 'C4']))
    ap('  C8 EnterZone index codés en dur .. %d' % len([x for x in problems + warns if x[0] == 'C8']))
    ap('  C7 musiques manquantes ........... %d' % len([x for x in uw if x[0] == 'C7']))
    ap('  C6 scripts orphelins ............. %d' % len([x for x in uw if x[0] == 'C6']))
    ap('')

    def dump(kind, lst, title):
        if not lst:
            return
        ap('--- %s : %d ---' % (title, len(lst)))
        for code, msg in lst:
            ap('  [%s] %s' % (code, msg))
        ap('')

    dump('P', problems, 'ANOMALIES BLOQUANTES')
    dump('W', warns, 'AVERTISSEMENTS')
    dump('I', infos, 'INFORMATIONS')

    # détail C3
    if not_declared:
        ap('--- Détail C3 : %d cartes non déclarées (dont %d référencées par Lua) ---' %
           (len(not_declared), len([n for n in not_declared if n in egm_targets])))
        for n in not_declared:
            ref = 'REFERENCEE' if n in egm_targets else ''
            scr = 'script' if n in scripted else ''
            ap('  %-34s %s %s' % (n, ref, scr))
        ap('')

    report = '\n'.join(lines)
    print(report)

    if '--json' in sys.argv:
        jp = sys.argv[sys.argv.index('--json') + 1]
        with open(jp, 'w', encoding='utf-8') as f:
            json.dump({
                'grounds': grounds, 'zones_idx': zones_idx, 'zones_json': zones_json,
                'problems': problems, 'warns': warns, 'infos': infos,
                'not_declared': not_declared, 'egm_targets': {k: sorted(v) for k, v in egm_targets.items()},
            }, f, ensure_ascii=False, indent=1)
        print('JSON -> %s' % jp)

    print('-' * 90)
    print('RESULTAT : %d bloquant(s), %d avertissement(s)' % (len(problems), len(warns)))
    print('-' * 90)
    return 2 if problems else (1 if warns else 0)


if __name__ == '__main__':
    sys.exit(main())
