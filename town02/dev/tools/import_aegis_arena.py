#!/usr/bin/env python3
"""Sanctuaire des Titans — nouvelle arène Regigigas (ch7), importée 1:1.

DIRECTIVE UTILISATEUR 2026-07-27 (annule l'exclusion précédente d'Aegis Cave) :
« Regigigas -> Aegis Cave (PMD Sky), importée 1:1 dans New Era, avec le trio
Regirock/Regice/Registeel dedans. »

Source : tilesets convertis PMDO du dépôt Minemaker0430/ExplorersOfSkyOrigins
(Content/Tile/"Deep Aegis Cave Regigigas Boss Arena.tile", 24px, 25x27 tuiles),
renommé Titans_Arena_Base (aucune trace du nom source dans les assets).

Méthode 1:1 :
- géométrie dérivée du visuel d'origine (intérieur sombre = sol, briques
  claires = mur), identity-mapped : tuile (x,y) -> TexLoc{X:x,Y:y}
- AUCUN redessin ; l'arène est celle du jeu d'origine, seule l'indexation change
- combat : Regigigas 28 (niveau barème inchangé) + trio Regirock/Regice/
  Registeel 26 (demande explicite), mysterious_force conservé
- la zone cloven_ruins seg3 pointe vers cette carte ; l'ancienne
  cloven_ruins_boss.rsmap est conservée en secours (non référencée)

Justification narrative déjà en place : légende ch5 « Les Trois Serviteurs et
le Colosse » (Rubble, LegendTitansHeard) annonce exactement ce quatuor.
"""
import json, io, struct, copy
from PIL import Image, ImageStat

SHEET = 'Titans_Arena_Base'
TILE = f'Content/Tile/{SHEET}.tile'
TEMPLATE = 'Data/Map/cloven_ruins_boss.rsmap'
OUT = 'Data/Map/sanctuaire_titans.rsmap'

# --- 1. géométrie 1:1 depuis le visuel -------------------------------------
with open(TILE, 'rb') as f:
    ts, tc = struct.unpack('<II', f.read(8))
    entries = [struct.unpack('<QQ', f.read(16)) for _ in range(tc)]
W = max(e[0] & 0xffffffff for e in entries) + 1
H = max(e[0] >> 32 for e in entries) + 1
tiles = {}
with open(TILE, 'rb') as f:
    for key, off in entries:
        x, y = key & 0xffffffff, key >> 32
        f.seek(off)
        ln = struct.unpack('<Q', f.read(8))[0]
        import io as _io
        tiles[(x, y)] = Image.open(_io.BytesIO(f.read(ln))).convert('RGB')

def walkable(x, y):
    t = tiles.get((x, y))
    if t is None:
        return False
    r, g, b = ImageStat.Stat(t).mean
    return (r + g + b) / 3 < 120     # intérieur sombre = sol

grid = [[walkable(x, y) for y in range(H)] for x in range(W)]

# --- 2. carte à partir du patron fonctionnel --------------------------------
d = json.load(open(TEMPLATE, encoding='utf-8-sig'))
o = d['Object']
o['AssetName'] = 'sanctuaire_titans'
o['ID'] = 'sanctuaire_titans'
o['Name'] = {'DefaultText': 'Titans Sanctum', 'LocalTexts': {'fr': 'Sanctuaire des Titans'}}
o['Comment'] = ('New Era ch7 - Regigigas boss arena imported 1:1 (24px sheet '
                'Titans_Arena_Base, geometry derived from the original visual). '
                'Trio Regirock/Regice/Registeel added per 2026-07-27 directive. '
                'Foreshadowed by the ch5 legend LegendTitansHeard.')

def tex(x, y):
    return {"AutoTileset": "", "Associates": [],
            "Layers": [{"Frames": [{"Sheet": SHEET, "TexLoc": {"X": x, "Y": y}}],
                        "FrameLength": 60}],
            "NeighborCode": -1}

tpl_floor = None
tpl_wall = None
T0 = o['Tiles']
for col in T0:
    for c in col:
        if c['Data']['ID'] == 'floor' and tpl_floor is None:
            tpl_floor = copy.deepcopy(c)
        if c['Data']['ID'] == 'unbreakable' and tpl_wall is None:
            tpl_wall = copy.deepcopy(c)
assert tpl_floor and tpl_wall

new_tiles = []
for x in range(W):
    col = []
    for y in range(H):
        c = copy.deepcopy(tpl_floor if grid[x][y] else tpl_wall)
        c['Data']['TileTex'] = tex(x, y)
        c['Data']['StableTex'] = False
        if 'Effect' in c:
            eff = c['Effect']
            if isinstance(eff, dict) and 'TileLoc' in eff:
                eff['TileLoc'] = {'X': x, 'Y': y}
        col.append(c)
    new_tiles.append(col)
o['Tiles'] = new_tiles
o['DiscoveryArray'] = [[False for _ in range(H)] for _ in range(W)]
o['Layers'] = [{'Name': 'New Layer', 'Layer': 0, 'Visible': True,
                'Tiles': [[{"AutoTileset": "", "Associates": [], "Layers": [],
                            "NeighborCode": -1} for _ in range(H)] for _ in range(W)]}]
o['BlankBG'] = tex(0, 0)

# --- 3. entrées + équipe boss ------------------------------------------------
# bas de l'arène (rangée 21) : centre
o['EntryPoints'] = [{"Loc": {"X": 12, "Y": 20}, "Dir": 4},
                    {"Loc": {"X": 11, "Y": 20}, "Dir": 4}]
for e in o['EntryPoints']:
    assert grid[e['Loc']['X']][e['Loc']['Y']], 'entree sur mur'

players = o['MapTeams'][0]['Players']
regigigas = players[0]
assert regigigas['BaseForm']['Species'] == 'regigigas'
regigigas['serializationLoc'] = {'X': 12, 'Y': 7}

TRIO = [
    ('regirock', 'Regirock', (7, 10),
     [('rock_slide', 10), ('curse', 10), ('stomp', 20), ('superpower', 5)]),
    ('regice', 'Regice', (17, 10),
     [('icy_wind', 15), ('amnesia', 20), ('stomp', 20), ('ancient_power', 5)]),
    ('registeel', 'Registeel', (12, 12),
     [('metal_claw', 35), ('curse', 10), ('stomp', 20), ('ancient_power', 5)]),
]
for species, nick, (px, py), skills in TRIO:
    p = copy.deepcopy(regigigas)
    p['BaseForm'] = {'Species': species, 'Form': 0, 'Skin': 'normal', 'Gender': 0}
    p['Nickname'] = nick
    p['Level'] = 26
    p['serializationLoc'] = {'X': px, 'Y': py}
    p['BaseIntrinsics'] = ['clear_body']
    p['BaseSkills'] = [{'SkillNum': s, 'Charges': ch, 'CanForget': False}
                       for s, ch in skills]
    assert grid[px][py], f'{species} sur mur'
    players.append(p)

with io.open(OUT, 'w', encoding='utf-8-sig') as f:
    json.dump(d, f, ensure_ascii=False, indent=2)
print(f'{OUT} : {W}x{H} (24px), sol={sum(sum(1 for v in col if v) for col in grid)} cases, '
      f'{len(players)} combattants (Regigigas 28 + trio 26)')
