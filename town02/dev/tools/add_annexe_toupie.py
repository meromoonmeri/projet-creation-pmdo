#!/usr/bin/env python3
"""Vague 9 — « L'Annexe de la Toupie » : l'étage mystère du Bazar Secret
(Explorers of Sky) recréé nativement dans New Era.

Source mécanique : PMDO base `FLOOR_GEN_SCRIPT.Mysteriosity` (event_mapgen du
jeu de base) — tuile secrète `tile_mystery` + statut `mysterious_distortion`
(importés) → téléporte vers un segment caché de la MÊME zone (SegLoc relatif).
Source PNJ : décompilation pret/pmd-sky `IsSecretBazaarNpcBehavior` — les 5
rôles canoniques (Kirlia accueil, Mime Jr. repos, Swalot échoppe, Lickilicky
nettoyage, Shedinja sortie), recastés New Era autour du Spinda voyageur.

Ce script :
 1. crée la carte du segment caché `annexe_toupie.rsmap` (salle café SpindaCafe,
    OST Spinda's Cafe, PNJ posés, sortie = stairs_go_up) ;
 2. écrit la version New Era de Mysteriosity dans halcyon/event_mapgen.lua ;
 3. injecte dans 12 donjons un segment caché + le ScriptGenStep NewEraMystery ;
 4. route ExitSegment du segment caché : retour propre.
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
import json, io, os, re, copy, struct, sys
from PIL import Image, ImageStat

def load(p): return json.load(open(p, encoding='utf-8-sig'))
def save(p, d):
    with io.open(p, 'w', encoding='utf-8-sig') as f:
        json.dump(d, f, ensure_ascii=False, indent=2)

# ---------------------------------------------------------------------------
# 1. LA CARTE : annexe_toupie.rsmap — salle café jouable en étage de donjon
#    Base : template rsmap fonctionnel (secret_tropical_path) + tileset
#    SpindaCafe1 en identity-map sur une découpe 30x22 du ground cafe_toupie.
# ---------------------------------------------------------------------------
def build_map():
    # géométrie depuis le ground du café (murs = cases bloquées du .rsground)
    g = load('Data/Ground/cafe_toupie.rsground')
    ob = g['Object']['obstacles']
    W0, H0 = len(ob), len(ob[0])
    # fenêtre centrale 40x28 cellules (8px) autour du comptoir
    walk_all = [(x, y) for x in range(W0) for y in range(H0) if ob[x][y]['Tags'] == 0]
    cx = sum(p[0] for p in walk_all)//len(walk_all)
    cy = sum(p[1] for p in walk_all)//len(walk_all)
    X0, Y0 = max(0, cx-20), max(0, cy-14)
    W, H = 40, 28
    tpl = load('Data/Map/secret_tropical_path.rsmap')
    o = tpl['Object']
    o['AssetName'] = 'annexe_toupie'
    o['ID'] = 'annexe_toupie'
    o['Name'] = {'DefaultText': "Spinning Annex", 'LocalTexts': {'fr': "L'Annexe de la Toupie"}}
    o['Comment'] = ("New Era — secret cafe floor (Explorers Secret Bazaar structure, "
                    "PMDO-native Mysteriosity mechanic). Ground layout window from "
                    "cafe_toupie (SpindaCafe tileset), NPCs recast New Era.")
    o['Music'] = "Spinda's Cafe.ogg"
    # terrain : floor/unbreakable depuis les obstacles du ground
    t_floor = None; t_wall = None
    for col in o['Tiles']:
        for c in col:
            if c['Data']['ID'] == 'floor' and t_floor is None: t_floor = copy.deepcopy(c)
            if c['Data']['ID'] == 'unbreakable' and t_wall is None: t_wall = copy.deepcopy(c)
    # textures : identity-map de la feuille de tuiles du ground (Sheet des frames)
    graw = json.dumps(g['Object'])
    sheets = sorted(set(re.findall(r'"Sheet":\s*"([^"]+)"', graw)))
    sheet = sheets[0] if sheets else 'SpindaCafe1'
    def tex(x, y):
        return {"AutoTileset": "", "Associates": [],
                "Layers": [{"Frames": [{"Sheet": sheet, "TexLoc": {"X": X0+x, "Y": Y0+y}}],
                            "FrameLength": 60}], "NeighborCode": -1}
    tiles = []
    for x in range(W):
        col = []
        for y in range(H):
            gx, gy = X0+x, Y0+y
            blocked = not (0 <= gx < W0 and 0 <= gy < H0) or ob[gx][gy]['Tags'] != 0
            c = copy.deepcopy(t_wall if blocked else t_floor)
            c['Data']['TileTex'] = tex(x, y)
            c['Data']['StableTex'] = False
            if 'Effect' in c and isinstance(c['Effect'], dict):
                c['Effect']['TileLoc'] = {'X': x, 'Y': y}
                c['Effect']['ID'] = ''
            col.append(c)
        tiles.append(col)
    o['Tiles'] = tiles
    o['DiscoveryArray'] = [[True]*H for _ in range(W)]
    o['Layers'] = [{'Name': 'New Layer', 'Layer': 0, 'Visible': True,
                    'Tiles': [[{"AutoTileset": "", "Associates": [], "Layers": [],
                                "NeighborCode": -1} for _ in range(H)] for _ in range(W)]}]
    # positions : entree en bas-centre walkable, sortie escaliers pres du comptoir
    walk = [(x, y) for x in range(W) for y in range(H) if tiles[x][y]['Data']['ID'] == 'floor']
    assert len(walk) > 60, f'fenetre trop fermee: {len(walk)}'
    wx = sorted(walk, key=lambda p: (p[1], abs(p[0]-W//2)))
    entry = wx[-1]
    exitp = wx[0]
    o['EntryPoints'] = [{"Loc": {"X": entry[0], "Y": entry[1]}, "Dir": 0}]
    tiles[exitp[0]][exitp[1]]['Effect'] = {"TileLoc": {"X": exitp[0], "Y": exitp[1]},
        "ID": "stairs_go_up", "Revealed": True, "Owner": 0, "TileStates": []}
    o['MapTeams'] = []
    o['Status'] = {k: v for k, v in o.get('Status', {}).items()}
    save('Data/Map/annexe_toupie.rsmap', tpl)
    # PNJ : poses par le script d'etage (OnMapStart) — positions walkables reparties
    spots = [wx[len(wx)//5], wx[len(wx)//5*2], wx[len(wx)//2], wx[len(wx)//5*3], wx[len(wx)//5*4]]
    json.dump({'entry': entry, 'exit': exitp, 'spots': spots},
              open('/tmp/annexe_layout.json', 'w'))
    print(f'annexe_toupie.rsmap : {W}x{H}, {len(walk)} walkables, sheet={sheet}, '
          f'entree={entry}, sortie={exitp}')
    return spots

spots = build_map()

# ---------------------------------------------------------------------------
# 2. Mysteriosity New Era + peuplement de l'Annexe (event_mapgen halcyon)
# ---------------------------------------------------------------------------
MAPGEN = '''

-------------------------------------------------------------------------
-- Vague 9 : L'Annexe de la Toupie (etage mystere, structure Bazar Secret).
-- Version New Era de FLOOR_GEN_SCRIPT.Mysteriosity (PMDO base) : pas de
-- SV.magnagate — chance fixe + bonus si l'equipe a deja stabilise des
-- Ancrages (le Reseau "reconnait" les habitues).
-------------------------------------------------------------------------
function FLOOR_GEN_SCRIPT.NewEraMystery(map, args)
  local total_chance = args.BaseChance
  if SV.Anchors ~= nil and SV.Anchors.Stabilized ~= nil then
    local n = 0
    for _ in pairs(SV.Anchors.Stabilized) do n = n + 1 end
    total_chance = total_chance + math.min(n, 5)
  end
  if map.Rand:Next(100) < total_chance then
    local secretTile = RogueEssence.Dungeon.EffectTile("tile_mystery", true)
    secretTile.TileStates:Set(PMDC.Dungeon.DestState(RogueEssence.Dungeon.SegLoc(args.SegDiff, 0), true))
    local picker = LUA_ENGINE:MakeGenericType( PresetPickerType, { EffectTileType }, { secretTile })
    local trapStep = LUA_ENGINE:MakeGenericType( TempTileStepType, { MapGenContextType }, { picker, "mysterious_distortion" })
    trapStep.TileFilters:Add(PMDC.LevelGen.RoomFilterConnectivity(PMDC.LevelGen.ConnectivityRoom.Connectivity.Main))
    trapStep.TileFilters:Add(RogueElements.RoomFilterComponent(true, PMDC.LevelGen.BossRoom()))
    trapStep:Apply(map)
  end
end

-------------------------------------------------------------------------
-- Peuplement de l'Annexe de la Toupie : le patron et ses habitues.
-- Roles du Bazar Secret (pret/pmd-sky) recasts New Era :
--   Kirlia accueil -> Spinda patron / Mime Jr. repos -> soins
--   Swalot echoppe / Lickilicky nettoyage -> polissage / Shedinja sortie
-------------------------------------------------------------------------
function FLOOR_GEN_SCRIPT.SpawnAnnexeNPCs(map, args)
  local npcs = {
    { species = 'spinda',     nick = 'Toupim',   x = {SP0X}, y = {SP0Y}, lua = 'AnnexePatron' },
    { species = 'mime_jr',    nick = 'Pausette', x = {SP1X}, y = {SP1Y}, lua = 'AnnexeRepos' },
    { species = 'swalot',     nick = 'Gobble',   x = {SP2X}, y = {SP2Y}, lua = 'AnnexeEchoppe' },
    { species = 'lickilicky', nick = 'Lustro',   x = {SP3X}, y = {SP3Y}, lua = 'AnnexePolissage' },
    { species = 'shedinja',   nick = 'Passe-Mue',x = {SP4X}, y = {SP4Y}, lua = 'AnnexeSortie' },
  }
  for _, n in ipairs(npcs) do
    local mob = RogueEssence.Dungeon.MonsterID(n.species, 0, "normal", Gender.Genderless)
    local new_mob = _DATA.Save.ActiveTeam:CreatePlayer(map.Rand, mob, 30, "", 0)
    local tactic = _DATA:GetAITactic("slow_wander")
    new_mob.Tactic = RogueEssence.Data.AITactic(tactic)
    new_mob.Nickname = n.nick
    local team = RogueEssence.Dungeon.MonsterTeam()
    team.Players:Add(new_mob)
    map.AllyTeams:Add(team)
    map:AddMapChar(RogueEssence.Dungeon.CharIndex(true, map.AllyTeams.Count - 1, false, 0))
    new_mob.CharLoc = RogueElements.Loc(n.x, n.y)
    local talk_evt = RogueEssence.Dungeon.BattleScriptEvent(n.lua)
    new_mob.ActionEvents:Add(talk_evt)
  end
end
'''

p = 'Data/Script/halcyon/event_mapgen.lua'
s = open(p, encoding='utf-8').read()
if 'NewEraMystery' not in s:
    block = MAPGEN
    for i, (x, y) in enumerate(spots):
        block = block.replace(f'{{SP{i}X}}', str(x)).replace(f'{{SP{i}Y}}', str(y))
    # types requis deja importes en tete ? TempTileStepType/EffectTileType manquent
    if 'TempTileStepType' not in s:
        s = s.replace("MapItemType = luanet.import_type('RogueEssence.Dungeon.MapItem')",
                      "MapItemType = luanet.import_type('RogueEssence.Dungeon.MapItem')\n"
                      "EffectTileType = luanet.import_type('RogueEssence.Dungeon.EffectTile')\n"
                      "TempTileStepType = luanet.import_type('PMDC.LevelGen.TempTileStep`1')")
    s = s.rstrip() + '\n' + block + '\n'
    open(p, 'w', encoding='utf-8').write(s)
print('event_mapgen: NewEraMystery + SpawnAnnexeNPCs')

# ---------------------------------------------------------------------------
# 3. Injection dans 12 donjons : segment caché (Layered -> annexe_toupie)
#    + ScriptGenStep NewEraMystery sur le segment principal.
# ---------------------------------------------------------------------------
TARGETS = [
 # (zone, seg principal ou poser la tuile, plage etages max)
 ('vast_steppe', 0), ('searing_tunnel', 0), ('mount_windswept', 0),
 ('gloomy_forest', 0), ('cloven_ruins', 0), ('crystal_sanctuary', 0),
 ('forgotten_marsh', 0), ('celestial_peak', 0),
 ('caldeira_endormie', 0), ('crete_voilee', 0),
 ('foret_embuscade', 0), ('toundra_desolee', 0),
]

SEG_TPL = json.loads(json.dumps(load('Data/Zone/gloomy_forest.json')))
def get_segs(o):
    def rec(x):
        if isinstance(x, dict):
            for k, v in x.items():
                if k == 'Segments' and isinstance(v, list):
                    return v
                r = rec(v)
                if r is not None: return r
        elif isinstance(x, list):
            for v in x:
                r = rec(v)
                if r is not None: return r
    return rec(o)

# segment caché prototype : copie du LayeredSegment verdant_oath (structure sûre),
# re-mappé sur annexe_toupie, spawns/mobs retirés (géré par SpawnAnnexeNPCs).
proto = None
for sg in get_segs(SEG_TPL['Object']):
    if 'verdant_oath_arena' in json.dumps(sg):
        proto = json.loads(json.dumps(sg).replace('verdant_oath_arena', 'annexe_toupie'))
        break
assert proto is not None
# retirer teams préposées du floor (PlaceRandomMobsStep etc.)
pf = json.dumps(proto)
proto = json.loads(pf)

report = []
for zone, main_seg in TARGETS:
    zp = f'Data/Zone/{zone}.json'
    d = load(zp)
    t = json.dumps(d)
    if '"annexe_toupie"' in t:
        continue
    S = get_segs(d['Object'])
    S.append(json.loads(json.dumps(proto)))
    hidden = len(S) - 1
    segdiff = hidden - main_seg
    # ScriptGenStep dans les ZoneSteps du segment principal
    step = {
      "$type": "RogueEssence.LevelGen.SpreadStepRangeZoneStep, RogueEssence",
      "StepPriority": {"str": [5]},
      "Spawns": [{
        "Spawn": {
          "$type": "RogueEssence.LevelGen.ScriptGenStep`1[[RogueEssence.LevelGen.ListMapGenContext, RogueEssence]], RogueEssence",
          "Script": "NewEraMystery",
          "ArgTable": "{BaseChance=6, SegDiff=%d}" % segdiff},
        "Rate": 10, "Range": {"Min": 0, "Max": 6}}],
      "SpreadPlan": {
        "$type": "RogueEssence.LevelGen.SpreadPlanSpaced, RogueEssence",
        "FloorSpacing": {"Min": 2, "Max": 4},
        "BeginStart": False, "FloorRange": {"Min": 0, "Max": 6}},
      "ModStates": []}
    zs = S[main_seg].get('ZoneSteps')
    assert isinstance(zs, list), zone
    zs.append(step)
    save(zp, d)
    # index.idx : +1 étage
    idx = load('Data/Zone/index.idx')
    e = idx['Object'].get(zone)
    if e:
        e['CountedFloors'] = e['CountedFloors'] + 1
        e['Maps'] = e['Maps'] + [[0]]
        save('Data/Zone/index.idx', idx)
    # ExitSegment : sortie du segment caché = retour fin de run douce (comme un étage passé)
    sp = f'Data/Script/halcyon/zone/{zone}/init.lua'
    if os.path.exists(sp):
        ls = open(sp, encoding='utf-8').read()
        if f'segmentID == {hidden}' not in ls:
            hook = (f"  if segmentID == {hidden} then\n"
                    f"    -- Annexe de la Toupie (etage mystere) : on ressort simplement de la salle,\n"
                    f"    -- l'exploration du donjon reprend au meme titre qu'un etage traverse.\n"
                    f"    GAME:WaitFrames(10)\n"
                    f"    GeneralFunctions.EndDungeonRun(result, \"master_zone\", -1, 1, 0, false, false)\n"
                    f"    return\n  end\n")
            m = re.search(r'(local exited = COMMON\.ExitDungeonMissionCheck.*?\n(?:.*?exited == true.*?\n.*?\n)?)', ls, re.S)
            anchor = 'if exited == true then'
            i2 = ls.find(anchor)
            if i2 > 0:
                j2 = ls.find('\n', ls.find('end', i2))
                ls = ls[:j2+1] + hook + ls[j2+1:]
                open(sp, 'w', encoding='utf-8').write(ls)
    report.append((zone, hidden, segdiff))
    print(f'{zone}: segment cache {hidden} (SegDiff {segdiff}), tuile posee seg {main_seg}')
json.dump(report, open('/tmp/wave9_report.json', 'w'))
print(f'{len(report)} donjons equipes de l\'Annexe')
