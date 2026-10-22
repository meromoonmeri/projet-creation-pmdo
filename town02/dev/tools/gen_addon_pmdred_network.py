#!/usr/bin/env python3
"""ADD-ON « Réseau des Anciens Chemins » — reconstruction INTÉGRALE de la
structure de progression des donjons du jeu d'origine (pret/pmd-red).

DIRECTIVE (2026-07-27) : add-on NEUTRE, préfixe new_era_zone_XX, rien n'écrase
l'existant. Source de vérité : décompilation pret/pmd-red —
  * étages : src/dungeon_info.c  sDungeonFloorCount[]  (extrait ci-dessous)
  * enchaînements multi-parties : paires <donjon>/<cime> du code
    (MT_THUNDER+PEAK, MT_BLAZE+PEAK, FROSTY_FOREST+GROTTO, MT_FREEZE+PEAK,
     MAGMA_CAVERN+PIT, SKY_TOWER+SUMMIT)
  * grounds d'entrée/fin : nos 32 imports 1:1 pmd-red (lots 2-3) réutilisés

Architecture par zone (modèle PMDO moderne) :
  Entrance Ground (statue Kangourex = « Terminal de Sauvegarde ») ->
  Segment(s) RangeDict (générateur PMDO, plus de tuiles GBA rigides) ->
  Relay Ground (« Station-Relais », sauvegarde + réserve via
  GeneralFunctions.Kangashkhan_Rock_Interact) -> segment cime -> fin.

Squelette : clone de petit_tunnel.json (zone fonctionnelle du dépôt),
avec : renommage FR, étages EXACTS du code, niveaux recalés sur la courbe,
espèces remplacées par des tables Gén. 4-9 thématiques, autotiles DumpAsset
thématiques, musiques existantes.
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
import json, io, os, re, copy, unicodedata

TEMPLATE_ZONE = 'Data/Zone/vast_steppe.json'
RELAY_GROUND = 'Data/Ground/searing_tunnel_midpoint.rsground'

# --- sDungeonFloorCount (copie exacte du code source, IDs 0..43) -------------
FLOORS = {
 0:4, 1:6, 2:10, 3:14, 4:10, 5:11, 6:4, 7:13, 8:15, 9:13, 10:4, 11:10, 12:6,
 13:16, 14:6, 15:24, 16:4, 17:26, 18:10, 19:41, 20:100, 21:21, 23:100,
 26:100, 27:100, 28:26, 29:26, 31:21, 32:51, 33:31, 34:31, 35:31, 36:21,
 37:31, 38:16, 39:13, 40:20, 41:31, 42:11, 43:16,
}
# paires (partie basse -> cime) fusionnées en UNE zone à relais
PAIRS = {5:6, 9:10, 11:12, 13:14, 15:16, 17:18}
SKIP = {6,10,12,14,16,18, 22,24,25,30}  # cimes fusionnées + doublons/BOSS internes

# tables Gén.4-9 par thème (14 espèces / thème, non-légendaires)
SPECIES = {
 'forest': ['starly','kricketot','combee','burmy','sewaddle','cottonee','phantump','rookidee','applin','smoliv','nymble','shroodle','fletchling','skiddo'],
 'electric': ['shinx','pachirisu','blitzle','joltik','helioptile','dedenne','togedemaru','yamper','morpeko','pawmi','tadbulb','wattrel','pincurchin','charjabug'],
 'mountain': ['cranidos','gible','drilbur','roggenrola','rockruff','mudbray','cufant','rolycoly','nacli','klawf','glimmet','orthworm','capsakid','silicobra'],
 'cave': ['bronzor','hippopotas','dwebble','ferroseed','carbink','mawile','sableye','wimpod','sandygast','toedscool','greavard','gimmighoul','deino','noibat'],
 'fire': ['heatmor','salandit','sizzlipede','turtonator','litleo','darumaka','charcadet','fuecoco_no','rolycoly','carkol','fletchinder','numel','torkoal','magby'],
 'ice': ['snover','vanillite','cubchoo','cryogonal','bergmite','snom','mrrime_no','cetoddle','frigibax','cetitan','eiscue','beartic','sneasler_no','glaceon'],
 'sea': ['finneon','buizel','tympole','frillish','skrelp','wishiwashi','dhelmise','arrokuda','clobbopus','veluza','finizen','tatsugiri','wiglett','dondozo'],
 'sky': ['drifloon','rufflet','vullaby','noibat','oricorio','flittle','bombirdier','espathra','duskull','sigilyph','swablu','emolga','gligar','hawlucha'],
 'relic': ['yamask','golett','honedge','sinistea','runerigus','bronzong','elgyem','baltoy','cofagrigus','falinks','varoom','tinkatink','cufant','dottler'],
 'psychic': ['chingling','munna','solosis','espurr','hatenna','indeedee','flittle','abra','ralts','gothita','beldum','natu','inkay','dottler'],
 'toxic': ['croagunk','skorupi','trubbish','mareanie','toxel','shroodle','varoom','salandit','stunky','foongus','glimmet','paldea_wooper','grimer','venipede'],
}
BAD = {'fuecoco_no','mrrime_no','sneasler_no','paldea_wooper'}
for k in SPECIES:
    SPECIES[k] = [s for s in SPECIES[k] if s not in BAD]

AT = {
 'forest': ('treeshroud_forest_1_floor','treeshroud_forest_1_wall'),
 'electric': ('lightning_field_floor','lightning_field_wall'),
 'mountain': ('mt_thunder_floor','mt_thunder_wall'),
 'cave': ('murky_cave_floor','murky_cave_wall'),
 'fire': ('deep_dark_crater_floor','deep_dark_crater_wall'),
 'ice': ('frosty_forest_floor','frosty_forest_wall'),
 'sea': ('stormy_sea_1_floor','stormy_sea_1_wall'),
 'sky': ('sky_tower_floor','sky_tower_wall'),
 'relic': ('buried_relic_1_floor','buried_relic_1_wall'),
 'psychic': ('spacial_rift_1_floor','spacial_rift_1_wall'),
 'toxic': ('dark_wasteland_floor','dark_wasteland_wall'),
}
MUSIC = {
 'forest':'Treeshroud Forest.ogg','electric':'Rising Fear.ogg',
 'mountain':'Mt. Travail.ogg','cave':'Mysterious Passage.ogg',
 'fire':'Deep Dark Crater.ogg','ice':'Snow Camp.ogg','sea':'Water Cave.ogg',
 'sky':'Sky Tower.ogg','relic':'Boulder Quarry.ogg','psychic':'Time Gear Remix.ogg',
 'toxic':'Growing Anxiety.ogg',
}

# ---------------------------------------------------------------------------
# MANIFESTE ID 0..43 — noms FR « New Era » (reskin textuel techno-mystique)
# (id, nom EN d'origine, nom FR New Era, thème, niveau cible, entrance pmd-red,
#  ground final pmd-red, nom FR du relais si zone à cime)
# ---------------------------------------------------------------------------
Z = [
 (0,'Tiny Woods','Lisière du Premier Signal','forest',5,'foret_tendre_oree',None,None),
 (1,'Thunderwave Cave','Conduit à Ondes Rémanentes','electric',6,'grotte_statique_seuil',None,None),
 (2,'Mt. Steel','Pylône du Vieux Fer','mountain',8,'pic_ferreux_pied',None,None),
 (3,'Sinister Woods','Taillis des Interférences','forest',10,'gloomy_forest_entrance',None,None),
 (4,'Silent Chasm','Faille du Silence Long','cave',12,'gouffre_muet_bord',None,None),
 (5,'Mt. Thunder (+Peak)','Antenne du Grand Orage','electric',14,'mont_grondant_pied',None,'Station de la Foudre Basse'),
 (7,'Great Canyon','Canyon des Voix Éteintes','mountain',16,'grand_canyon_porte',None,None),
 (8,'Lapis Cave','Veine d\'Azur Profond','cave',18,'grotte_lazuli_seuil','grotte_lazuli_fond',None),
 (9,'Mt. Blaze (+Peak)','Cheminée du Réacteur Rouge','fire',20,'mont_cendre_pied',None,'Station du Manteau Ardent'),
 (11,'Frosty Forest (+Grotto)','Forêt du Givre Statique','ice',22,'foret_givree_oree',None,'Station du Point de Rosée'),
 (13,'Mt. Freeze (+Peak)','Aiguille du Zéro Absolu','ice',24,'mont_gele_pied',None,'Station du Grand Blanc'),
 (15,'Magma Cavern (+Pit)','Cœur de la Fournaise-Mère','fire',28,'gorge_ardente_porte','fosse_ardente','Station de Contrôle du Noyau'),
 (17,'Sky Tower (+Summit)','Tour du Ciel Fracturé','sky',32,'parvis_celeste','autel_celeste','Station du Dernier Palier'),
 (19,'Stormy Sea','Mer des Tempêtes Sans Fin','sea',36,None,'abime_tempetes',None),
 (20,'Silver Trench','Fosse d\'Argent Abyssale','sea',45,None,'fosse_argentee',None),
 (21,'Meteor Cave','Berceau du Météore','psychic',40,None,None,None),
 (23,'Western Cave','Caverne du Silence Occidental','cave',50,None,'antre_occident',None),
 (26,'Wish Cave','Puits des Vœux Fossiles','psychic',48,None,'sanctuaire_voeu',None),
 (27,'Buried Relic','Relique Ensevelie','relic',46,None,None,None),
 (28,'Pitfall Valley','Vallée des Chutes Perdues','sky',38,'vallon_perdu',None,None),
 (29,'Northern Range','Crêtes de la Boussole Nord','sky',39,None,'cretes_boreales',None),
 (31,'Desert Region','Région des Sables Morts','mountain',37,None,None,None),
 (32,'Southern Cavern','Caverne du Méridien Sud','cave',42,None,None,None),
 (33,'Wyvern Hill','Colline des Vouivres','sky',43,None,None,None),
 (34,'Fiery Field','Champ de Cendres Vives','fire',44,None,'champ_braises',None),
 (35,'Northwind Field','Champ du Vent Polaire','ice',45,None,'champ_vent_boreal',None),
 (36,'Solar Cave','Grotte du Soleil Enfoui','psychic',41,None,None,None),
 (37,'Lightning Field','Champ des Cent Éclairs','electric',46,None,'champ_foudre',None),
 (38,'Darknight Relic','Relique de la Nuit Noire','relic',44,None,None,None),
 (39,'Wondrous Sea','Mer des Prodiges','sea',42,None,None,None),
 (40,'Murky Cave','Boyau des Eaux Troubles','toxic',47,None,'caverne_trouble_fond',None),
 (41,'Grand Sea','Grand Large Oublié','sea',48,None,None,None),
 (42,'Uproar Forest','Forêt du Vacarme','forest',40,None,None,None),
 (43,'Oddity Cave','Grotte des Anomalies','cave',49,None,None,None),
]

def load(p): return json.load(open(p, encoding='utf-8-sig'))
def save(p, d):
    with io.open(p, 'w', encoding='utf-8-sig') as f:
        json.dump(d, f, ensure_ascii=False, indent=2)

def retarget_floor_ranges(node, old_max, new_max):
    """Change récursivement toute Range {Min:0,Max:old} -> new (couvre
    node Range, SpreadPlan FloorRange, ZoneSteps ranges)."""
    if isinstance(node, dict):
        if node.get('Min') == 0 and node.get('Max') == old_max and len(node) == 2:
            node['Max'] = new_max
        for v in node.values():
            retarget_floor_ranges(v, old_max, new_max)
    elif isinstance(node, list):
        for it in node:
            retarget_floor_ranges(it, old_max, new_max)

def scale_levels(t, factor, max_lv):
    def rep(m):
        lo, hi = int(m.group(1)), int(m.group(2))
        nlo = max(3, min(round(lo*factor), max_lv))
        nhi = max(nlo, min(round(hi*factor), max_lv))
        return f'"Level": {{\n"Min": {nlo},\n"Max": {nhi}\n}}'
    return re.sub(r'"Level":\s*\{\s*"Min":\s*(\d+),\s*"Max":\s*(\d+)\s*\}', rep, t)

TPL_SPECIES = ['ekans','hoppip','kecleon','mightyena','miltank','minun','mudbray',
               'plusle','ponyta','poochyena','skiploom','stantler','tauros']

def build_zone(idn, nen, nfr, theme, level, entrance, endground, relay_name):
    zid = f'new_era_zone_{idn:02d}'
    d = load(TEMPLATE_ZONE)
    o = d['Object']
    o['Name'] = {'DefaultText': nen, 'LocalTexts': {'fr': nfr}}
    o['Level'] = level
    o['Released'] = True
    o['Comment'] = (f'New Era add-on — faithful progression of original dungeon id {idn} '
                    f'({nen}), floors from pret/pmd-red sDungeonFloorCount. '
                    f'PMDO generators, gen4-9 spawn tables ({theme}).')
    # segments
    def segs(x):
        if isinstance(x, dict):
            for k, v in x.items():
                if k == 'Segments': return v
                r = segs(v)
                if r is not None: return r
        elif isinstance(x, list):
            for v in x:
                r = segs(v)
                if r is not None: return r
    S = segs(o)
    del S[1:]                      # ne garder que le segment procédural 0
    base = S[0]
    old_max = base['Floors']['nodes'][0]['Range']['Max']
    n1 = FLOORS[idn]
    peak_id = PAIRS.get(idn)
    retarget_floor_ranges(base, old_max, n1)
    if peak_id is not None:
        peak = copy.deepcopy(base)
        retarget_floor_ranges(peak, n1, FLOORS[peak_id])
        S.append(peak)          # seg1 = cime
    # texte : niveaux, espèces, autotiles, musique
    t = json.dumps(d, ensure_ascii=False, indent=2)
    t = scale_levels(t, level/15.0, level+3)
    pool = SPECIES[theme]
    for i, sp in enumerate(TPL_SPECIES):
        t = t.replace(f'"{sp}"', f'"{pool[i % len(pool)]}"')
    t = t.replace('"lush_prairie_floor"', f'"{AT[theme][0]}"')
    t = t.replace('"lush_prairie_wall"', f'"{AT[theme][1]}"')
    t = t.replace('"lush_prairie_secondary"', f'"{AT[theme][0].replace("_floor","_secondary")}"')
    t = t.replace('"treeshroud_forest_1_wall"', f'"{AT[theme][1]}"')
    t = re.sub(r'"Music":\s*"[^"]*"', f'"Music": "{MUSIC[theme]}"', t)
    # GroundMaps : entrance/relais/fin
    d2 = json.loads(t)
    o2 = d2['Object']
    gmaps = []
    if entrance: gmaps.append(entrance)
    if peak_id is not None: gmaps.append(f'{zid}_relais')
    if endground: gmaps.append(endground)
    def set_gm(x):
        if isinstance(x, dict):
            for k in x:
                if k == 'GroundMaps':
                    x[k] = gmaps
                    return True
                if set_gm(x[k]): return True
        elif isinstance(x, list):
            for it in x:
                if set_gm(it): return True
        return False
    set_gm(o2)
    save(f'Data/Zone/{zid}.json', d2)
    return zid, (1 if peak_id is None else 2), n1, FLOORS.get(peak_id, 0), gmaps

def build_relay(zid, nfr_relay, theme):
    """Station-relais : clone du patron canonique Kangourex."""
    d = load(RELAY_GROUND)
    o = d['Object']
    o['AssetName'] = f'{zid}_relais'
    o['Name'] = {'DefaultText': 'Relay Station', 'LocalTexts': {'fr': nfr_relay}}
    o['Comment'] = (f'New Era add-on relay for {zid}. Canonical checkpoint pattern: '
                    'Kangaskhan save terminal + storage, North exit -> next segment, '
                    'South exit -> entrance.')
    o['Music'] = MUSIC[theme]
    save(f'Data/Ground/{zid}_relais.rsground', d)

ZONE_LUA = '''--[[ {nfr} — zone add-on (Réseau des Anciens Chemins, id origine {idn}).
     Progression fidèle pret/pmd-red : {n1} étages{peak_txt}.
     Aucun impact histoire : entrée/sortie via master_zone carte 1 (Metano). ]]
require 'origin.common'
require 'halcyon.GeneralFunctions'

local {zid} = {{}}

function {zid}.Init(zone)
  DEBUG.EnableDbgCoro()
  PrintInfo("=>> Init_{zid}")
end

function {zid}.EnterSegment(zone, rescuing, segmentID, mapID)
  GeneralFunctions.CheckAllowSetRescue(zone.ID)
  if rescuing ~= true then
    COMMON.BeginDungeon(zone.ID, segmentID, mapID)
  end
end

function {zid}.Rescued(zone, name, mail)
  COMMON.Rescued(zone, name, mail)
end

function {zid}.ExitSegment(zone, result, rescue, segmentID, mapID)
  GeneralFunctions.RestoreIdleAnim()
  DEBUG.EnableDbgCoro()
  local exited = COMMON.ExitDungeonMissionCheck(result, rescue, zone.ID, segmentID)
  SV.adventure.Thief = false
  if exited == true then return end
{relay_block}
  GeneralFunctions.EndDungeonRun(result, "master_zone", -1, 1, 0, false, false)
end

return {zid}
'''
RELAY_BLOCK = '''
  -- Segment 0 franchi : halte à la Station-Relais (Terminal de Sauvegarde).
  if segmentID == 0 and result == RogueEssence.Data.GameProgress.ResultType.Cleared then
    GAME:EnterGroundMap('{zid}_relais', 'Main_Entrance_Marker')
    return
  end
'''

RELAY_INIT_LUA = '''--[[ {nfr_relay} — Station-Relais de {zid} (add-on).
     Terminal de Sauvegarde (Kangourex) + réserve, patron canonique. ]]
require 'origin.common'
require 'halcyon.PartnerEssentials'
require 'halcyon.GeneralFunctions'

local {rid} = {{}}

function {rid}.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies(true)
  PartnerEssentials.InitializePartnerSpawn()
end

function {rid}.Enter(map)
  GAME:FadeIn(20)
end

function {rid}.Update(map) end

function {rid}.GameSave(map)
  PartnerEssentials.SaveGamePartnerPosition(CH('Teammate1'))
end

function {rid}.GameLoad(map)
  PartnerEssentials.LoadGamePartnerPosition(CH('Teammate1'))
  GAME:FadeIn(20)
end

-- Sortie Nord : reprendre l'ascension (segment cime).
function {rid}.North_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo("Reprendre l'ascension ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    GAME:FadeOut(false, 60)
    GAME:EnterDungeon("{zid}", 1, 0, 0, RogueEssence.Data.GameProgress.DungeonStakes.Risk, true, false)
  end
end

-- Sortie Sud : redescendre (fin de run propre, retour Metano).
function {rid}.South_Exit_Touch(obj, activator)
  DEBUG.EnableDbgCoro()
  UI:ResetSpeaker(false)
  UI:SetCenter(true)
  UI:ChoiceMenuYesNo("Redescendre et rentrer ?", true)
  UI:WaitForChoice()
  if UI:ChoiceResult() then
    SV.adventure.Thief = false
    SOUND:FadeOutBGM(60)
    GAME:FadeOut(false, 60)
    GeneralFunctions.EndDungeonRun(RogueEssence.Data.GameProgress.ResultType.Cleared, "master_zone", -1, 1, 0, true, true)
  end
end

-- Terminal de Sauvegarde (statue Kangourex) : sauvegarde + réserve natives.
function {rid}.Kangaskhan_Rock_Action(obj, activator)
  GeneralFunctions.Kangashkhan_Rock_Interact(obj, activator)
end

function {rid}.Teammate1_Action(chara, activator)
  DEBUG.EnableDbgCoro()
  PartnerEssentials.GetPartnerDialogue(CH('Teammate1'))
end

return {rid}
'''

if __name__ == '__main__':
    idx = load('Data/Zone/index.idx')
    made = []
    for idn, nen, nfr, theme, level, entrance, endg, relay in Z:
        zid, nsegs, n1, n2, gmaps = build_zone(idn, nen, nfr, theme, level, entrance, endg, relay)
        # script zone
        os.makedirs(f'Data/Script/halcyon/zone/{zid}', exist_ok=True)
        peak_txt = f' + relais + {n2} étages (cime)' if n2 else ''
        relay_block = RELAY_BLOCK.format(zid=zid) if n2 else ''
        open(f'Data/Script/halcyon/zone/{zid}/init.lua', 'w', encoding='utf-8').write(
            ZONE_LUA.format(zid=zid, nfr=nfr, idn=idn, n1=n1, peak_txt=peak_txt,
                            relay_block=relay_block))
        # relais
        if n2:
            build_relay(zid, relay, theme)
            rid = f'{zid}_relais'
            os.makedirs(f'Data/Script/halcyon/ground/{rid}', exist_ok=True)
            open(f'Data/Script/halcyon/ground/{rid}/init.lua', 'w', encoding='utf-8').write(
                RELAY_INIT_LUA.format(rid=rid, zid=zid, nfr_relay=relay))
        # index
        d2 = load(f'Data/Zone/{zid}.json')
        o2 = d2['Object']
        maps_arr = [[0]] * nsegs
        total = n1 + n2
        idx['Object'][zid] = {
            '$type': 'RogueEssence.Data.ZoneEntrySummary, RogueEssence',
            'ExpPercent': o2.get('ExpPercent', 100), 'Level': level,
            'LevelCap': False, 'KeepSkills': False, 'TeamRestrict': False,
            'TeamSize': -1, 'MoneyRestrict': False, 'BagRestrict': -1,
            'KeepTreasure': False, 'BagSize': -1, 'Rescues': 2,
            'CountedFloors': total, 'Rogue': 0, 'Grounds': gmaps,
            'Maps': maps_arr,
            'Name': {'DefaultText': nen, 'LocalTexts': {'fr': nfr}},
            'Released': True, 'SortOrder': 0,
        }
        made.append((zid, nfr, n1, n2, level))
        print(f'{zid}  {nfr:38s} {n1}{"+"+str(n2) if n2 else "":>4} ét. L{level}')
    save('Data/Zone/index.idx', idx)
    json.dump(made, open('/tmp/wave5_zones.json', 'w'))
    print(f'\n{len(made)} zones add-on générées')
