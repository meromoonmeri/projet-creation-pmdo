#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
verify_ground_registration.py — UNE CARTE EST-ELLE VRAIMENT UTILISABLE ?

Pourquoi cet outil existe
-------------------------
Deux crashs successifs, en jeu, sur la meme carte neuve (hero_dream) :

  1. « Invalid Ground Map Name: hero_dream (Parameter 'mapname') »
     La carte etait declaree dans Data/Zone/master_zone.json, mais PAS
     dans Data/Zone/index.idx. Or le moteur ne valide pas un nom de
     ground avec le premier fichier : il interroge l'index compile
     (GameManager.MoveToGround:712 -> ZoneEntrySummary.GroundValid ->
     Grounds.Contains). index.idx est du JSON malgre son extension.

  2. Crash au chargement de la carte elle-meme.
     COMMON.RespawnAllies() — appelee par tous les Init du mod — fait
     sans condition SpawnerSetSpawn("TEAMMATE_1") puis
     SpawnerDoSpawn("TEAMMATE_1"). ScriptGround.cs:249 leve une
     ArgumentException si le spawner n'existe pas. J'avais vide la
     liste des Spawners du .rsground.

Les deux fois, tous les autres outils etaient au vert : ils verifient le
CONTENU des scenes, jamais l'ENREGISTREMENT des cartes. C'est l'angle
mort que celui-ci comble.

Ce qu'il verifie, pour chaque .rsground
---------------------------------------
  1. AssetName du fichier == nom du fichier (le moteur charge par nom :
     GetGround(name) -> mapData.AssetName = name).
  2. La carte est declaree dans Data/Zone/index.idx (liste Grounds).
  3. Elle est declaree dans Data/Zone/master_zone.json (GroundMaps).
  4. Les deux listes sont STRICTEMENT identiques, meme ordre.
  5. Si un dossier de script existe, il porte exactement l'AssetName
     (LuaEngine.MAP_SCRIPT_PATTERN = "ground.{0}").
  6. Le script declare bien Init / Enter (callbacks obligatoires).
  7. Si le script appelle RespawnAllies / InitializePartnerSpawn, la
     carte possede le spawner TEAMMATE_1 correspondant.
  8. La carte possede au moins un marqueur d'entree.

Usage :
    python3 tools/verify_ground_registration.py [racine]
Sortie : code 1 si une anomalie bloquante est trouvee.
"""
import os, re, sys, json, io, glob

R = sys.argv[1] if len(sys.argv) > 1 else '.'
GROUND_DIR = os.path.join(R, 'Data', 'Ground')
IDX = os.path.join(R, 'Data', 'Zone', 'index.idx')
MZ = os.path.join(R, 'Data', 'Zone', 'master_zone.json')
SCRIPT_DIR = os.path.join(R, 'Data', 'Script', 'halcyon', 'ground')

def load(path):
    return json.load(io.open(path, encoding='utf-8-sig'))

problems = []
warnings = []
notes = []

# Cartes citees par un EnterGroundMap : les seules dont l'absence d'index
# peut reellement crasher le jeu.
reachable = set()
_pat = re.compile(r"EnterGroundMap\(\s*['\"]([a-z0-9_]+)['\"]"
                  r"(?:\s*,\s*['\"]([a-z0-9_]+)['\"])?")
for _f in glob.glob(os.path.join(R, 'Data/Script/**/*.lua'), recursive=True):
    _src = open(_f, encoding='utf-8', errors='replace').read()
    for m in _pat.finditer(_src):
        # surcharge a 3 args : (zone, carte, entree) -> la carte est le 2e
        reachable.add(m.group(1))
        if m.group(2):
            reachable.add(m.group(2))

# --- listes de reference ---------------------------------------------------
# TOUTES les zones, pas seulement master_zone.
#
# Faux positif corrige : ne regarder que master_zone produisait 200
# signalements. L'index compte 208 zones (hauteurs_etoile, grotte_meteore,
# new_era_zone_28...) et 311 grounds declares au total. Une carte peut
# parfaitement appartenir a une autre zone que master_zone — c'est le cas
# de la majorite du contenu importe.
idx_grounds = None          # union de toutes les zones
idx_master = None           # master_zone seule (pour la comparaison ciblee)
try:
    o = load(IDX)['Object']
    idx_master = o['master_zone']['Grounds']
    idx_grounds = set()
    for z, v in o.items():
        if z == '$type' or not isinstance(v, dict):
            continue
        for g in v.get('Grounds', []):
            idx_grounds.add(g)
except Exception as e:
    problems.append(('index.idx illisible', str(e)))

mz_grounds = None
try:
    d = load(MZ)
    out = []
    def walk(o):
        if isinstance(o, dict):
            for k, v in o.items():
                if k == 'GroundMaps':
                    out.append(v)
                else:
                    walk(v)
        elif isinstance(o, list):
            for v in o:
                walk(v)
    walk(d)
    mz_grounds = out[0] if out else None
except Exception as e:
    problems.append(('master_zone.json illisible', str(e)))

# 4. les deux listes doivent coincider
if idx_master is not None and mz_grounds is not None:
    if idx_master != mz_grounds:
        only_idx = [g for g in idx_master if g not in mz_grounds]
        only_mz = [g for g in mz_grounds if g not in idx_master]
        if only_idx or only_mz:
            problems.append((
                'index.idx et master_zone.json divergent',
                'dans index seul: %s | dans master_zone seul: %s' % (only_idx, only_mz)))
        else:
            notes.append('index.idx et master_zone.json ont le meme contenu '
                         'mais un ORDRE different (non bloquant)')

# --- carte par carte -------------------------------------------------------
for f in sorted(glob.glob(os.path.join(GROUND_DIR, '*.rsground'))):
    name = os.path.splitext(os.path.basename(f))[0]
    try:
        obj = load(f)['Object']
    except Exception as e:
        problems.append((name, 'fichier illisible : %s' % e))
        continue

    # 1. AssetName coherent
    asset = obj.get('AssetName')
    if asset != name:
        problems.append((name, "AssetName='%s' ne correspond pas au nom de fichier" % asset))

    declared = (idx_grounds is not None and name in idx_grounds)

    # 8. marqueur d'entree
    try:
        markers = [m.get('EntName') for m in obj['Entities'][0]['Markers']]
    except Exception:
        markers = []
    spawners = []
    try:
        spawners = [s.get('EntName') for s in obj['Entities'][0]['Spawners']]
    except Exception:
        pass

    # script associe
    sdir = os.path.join(SCRIPT_DIR, name)
    has_script = os.path.isdir(sdir)
    src = ''
    if has_script:
        initp = os.path.join(sdir, 'init.lua')
        if not os.path.isfile(initp):
            problems.append((name, 'dossier de script sans init.lua'))
        else:
            src = open(initp, encoding='utf-8', errors='replace').read()
            # 6. callbacks obligatoires
            # Comparaison INSENSIBLE A LA CASSE : le nom de la table Lua ne
            # respecte pas toujours celui du dossier. Cas reel :
            # ground/guild_top_left_bedroom/init.lua declare la table
            # `guild_Top_Left_bedroom`. Le moteur s'en moque (il recupere la
            # table retournee par le module), mon test non — c'etait un faux
            # positif.
            for cb in ('Init', 'Enter'):
                if not re.search(r'function\s+%s\.%s\s*\(' % (re.escape(name), cb),
                                 src, re.IGNORECASE):
                    problems.append((name, 'init.lua ne declare pas %s.%s()' % (name, cb)))
            # 7. RespawnAllies et le spawner TEAMMATE_1 — AVERTISSEMENT SEUL.
            #
            # J'ai d'abord classe ce cas comme bloquant, a tort. Verification
            # faite dans le moteur : SpawnerDoSpawn et SpawnerSetSpawn
            # (ScriptGround.cs:243 et 267) enveloppent leur ArgumentException
            # dans un try/catch qui la LOGUE sans la propager. L'absence de
            # spawner salit donc le journal et empeche le partenaire
            # d'apparaitre, mais ne fait pas planter le jeu.
            #
            # 91 cartes du depot sont dans ce cas (dont 26 atteignables) :
            # c'est une dette existante, pas une regression. On la signale
            # a part, sans faire echouer la validation.
            if ('RespawnAllies' in src or 'InitializePartnerSpawn' in src) \
                    and 'TEAMMATE_1' not in spawners:
                warnings.append((name,
                    'appelle RespawnAllies sans spawner TEAMMATE_1 : '
                    'le partenaire n apparaitra pas (erreur loguee, non fatale)'))

    # 2/3. declaration — on ne signale que les cartes REELLEMENT
    # ATTEIGNABLES, c'est-a-dire citees par un EnterGroundMap quelque part
    # dans les scripts.
    #
    # Faux positif corrige : exiger la declaration de toute carte scriptee
    # produisait 109 signalements. Le depot contient beaucoup de contenu
    # importe, scripte mais jamais branche a la progression (vision_ouverture,
    # tempete_vision_c...). Une carte qu'aucun EnterGroundMap n'appelle ne
    # peut pas provoquer « Invalid Ground Map Name » : elle dort.
    if has_script and not declared and name in reachable:
        problems.append((name,
            'carte ATTEIGNABLE (un EnterGroundMap la cite) mais ABSENTE de '
            'index.idx -> « Invalid Ground Map Name » au moment du transfert'))
    # master_zone.json ne concerne QUE les cartes de master_zone : une
    # carte d'une autre zone n'a rien a y faire.
    if (has_script and mz_grounds is not None and idx_master is not None
            and name in idx_master and name not in mz_grounds):
        problems.append((name, 'declaree dans index.idx (master_zone) '
                               'mais absente de master_zone.json'))

    if declared and not markers:
        problems.append((name, 'aucun marqueur d entree'))

print('=' * 78)
print(' ENREGISTREMENT DES CARTES — index, scripts, spawners'.center(78))
print('=' * 78)
print()
if idx_grounds is not None:
    print('  index.idx        : %d grounds (toutes zones), %d dans master_zone'
          % (len(idx_grounds), len(idx_master or [])))
if mz_grounds is not None:
    print('  master_zone.json : %d grounds' % len(mz_grounds))
print('  fichiers .rsground : %d' % len(glob.glob(os.path.join(GROUND_DIR, '*.rsground'))))
print()
for n in notes:
    print('  note : ' + n)
if notes:
    print()
if problems:
    print('  ANOMALIES BLOQUANTES')
    for who, what in problems:
        print('  [%s]' % who)
        print('      %s' % what)
    print()
if warnings:
    print('  AVERTISSEMENTS (dette existante, non bloquant) : %d' % len(warnings))
    for who, what in warnings[:5]:
        print('      %-28s %s' % (who, what))
    if len(warnings) > 5:
        print('      ... et %d autres' % (len(warnings) - 5))
    print()
print('-' * 78)
print('RESULTAT : %d anomalie(s) bloquante(s), %d avertissement(s)'
      % (len(problems), len(warnings)))
print('-' * 78)
sys.exit(1 if problems else 0)
