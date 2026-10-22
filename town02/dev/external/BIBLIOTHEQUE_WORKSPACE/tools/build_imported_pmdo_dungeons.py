#!/usr/bin/env python3
"""Build staged PMDO/RogueElements dungeons for Reminiscencia and Relict."""
from __future__ import annotations
import argparse,copy,json,shutil
from pathlib import Path
from collections import Counter
from inventory_relict import sha256_file,write_json
DEFS=[
('reminiscencia','forest','Forêt des Réminiscences','gloomy_forest',24,'forest'),('reminiscencia','cave','Grotte des Réminiscences','crooked_cavern',24,'cave'),('reminiscencia','snow_forest','Forêt Enneigée','frosty_forest',22,'snow'),('reminiscencia','prison','Prison Gelée','cloven_ruins',22,'ruin'),('reminiscencia','deciduous_forest','Forêt Foliodoro','gloomy_forest',24,'forest'),('reminiscencia','justice','Palais de Justice','cloven_ruins',24,'ruin'),('reminiscencia','temple','Temple de Varuna','cloven_ruins',24,'ruin'),('reminiscencia','lake','Lac Caduque','illuminant_riverbed',22,'water'),('reminiscencia','volcano','Volcan Ardent','searing_tunnel',24,'fire'),('reminiscencia','cliff','Falaise des Vents','vast_steppe',24,'mountain'),('reminiscencia','tower','Tour Caduque','cloven_ruins',26,'ruin'),('reminiscencia','mine','Mine Ancienne','crooked_cavern',24,'cave'),('reminiscencia','wheat','Champs de Blé','vast_steppe',20,'plains'),('reminiscencia','bay','Baie du Souvenir','illuminant_riverbed',22,'water'),('reminiscencia','rift','Brèche Spatio-temporelle','cloven_ruins',26,'rift'),('reminiscencia','burned_tower','Tour Brûlée','searing_tunnel',24,'fire'),('reminiscencia','meteor_falls','Chutes Météore','crooked_cavern',26,'cave'),
('relict','destiny_tower','Tour du Destin','crooked_cavern',30,'rift'),('relict','alabaster_icelands','Terres Immaculées','frosty_forest',22,'snow'),('relict','mt_coronet','Mont Couronné','vast_steppe',26,'mountain'),('relict','ancient_retreat','Retraite Ancienne','gloomy_forest',20,'forest'),('relict','cobalt_coastlands','Côte Lazuli','illuminant_riverbed',22,'water')]
POOLS={
'forest':'caterpie metapod butterfree weedle kakuna beedrill oddish gloom vileplume bellsprout weepinbell victreebel paras parasect venonat venomoth hoothoot noctowl ledyba ledian spinarak hoppip skiploom jumpluff seedot nuzleaf shiftry shroomish roselia budew combee burmy sewaddle deerling foongus'.split(),
'cave':'zubat golbat geodude graveler onix diglett dugtrio machop machoke cubone marowak rhyhorn rhydon aron lairon nosepass sableye mawile whismur loudred makuhita hariyama roggenrola drilbur woobat dwebble axew gible carbink noibat sandshrew gligar shuckle'.split(),
'snow':'swinub piloswine snorunt glalie spheal sealeo snover abomasnow vanillite vanillish cubchoo beartic bergmite avalugg delibird sneasel weavile froslass cryogonal snom frosmoth eiscue vulpix ninetales lapras seel jynx amaura swinub bergmite spheal glaceon mamoswine piplup empoleon'.split(),
'ruin':'gastly haunter gengar duskull dusclops shuppet banette misdreavus mismagius bronzor bronzong baltoy claydol golett golurk honedge sableye spiritomb unown solosis duosion porygon porygon2 porygon_z rotom magnemite magneton klink yamask cofagrigus litwick lampent murkrow absol drifloon drifblim klefki dhelmise'.split(),
'water':'poliwag poliwhirl goldeen seaking staryu psyduck golduck tentacool horsea chinchou marill azumarill wooper quagsire wingull pelipper corphish crawdaunt feebas barboach buizel shellos finneon mantyke basculin frillish wimpod dewpider chewtle arrokuda clauncher skrelp pyukumuku clamperl huntail gorebyss wailmer qwilfish corsola lapras mantine lombre ludicolo'.split(),
'fire':'charmander charmeleon vulpix ninetales growlithe arcanine ponyta rapidash magmar magby slugma magcargo houndour houndoom numel torkoal chimchar monferno litwick lampent heatmor larvesta fletchinder litleo salandit turtonator rolycoly carkol charcadet capsakid flareon fennekin braixen charizard infernape coalossal flareon scorbunny'.split(),
'mountain':'geodude graveler onix rhyhorn rhydon aerodactyl larvitar pupitar aron lairon nosepass probopass roggenrola boldore drilbur excadrill dwebble crustle gible gabite axew rufflet hawlucha rockruff lycanroc mudbray silicobra nacli naclstack gligar skarmory swablu altaria machop machoke'.split(),
'plains':'rattata raticate sentret furret zigzagoon linoone poochyena mightyena bidoof patrat watchog lillipup starly staravia pidgey pidgeotto spearow doduo taillow swellow shinx electrike mareep flaaffy ponyta tauros miltank deerling mudbray yamper nickit skwovet wooloo hoppip sunkern'.split(),
'rift':'abra kadabra gastly haunter misdreavus unown baltoy claydol solrock lunatone duskull chimecho bronzor spiritomb porygon porygon2 rotom munna solosis duosion elgyem litwick golett honedge espurr inkay carbink pumpkaboo mimikyu dhelmise minior cosmog necrozma alakazam espeon umbreon clefairy clefable duskull drifloon drifblim absol deoxys ditto rayquaza'.split()}
# Keep only IDs already used by this PMDO quest/base-compatible data set.
def load_json(path):return json.loads(path.read_text(encoding='utf-8-sig'))
def types(x,c):
 if isinstance(x,dict):
  if '$type' in x:c[x['$type'].split('[[',1)[0].split(',')[0].rsplit('.',1)[-1]]+=1
  for v in x.values():types(v,c)
 elif isinstance(x,list):
  for v in x:types(v,c)
def find_type(x,needle):
 out=[]
 def walk(v):
  if isinstance(v,dict):
   if needle in v.get('$type',''):out.append(v)
   for q in v.values():walk(q)
  elif isinstance(v,list):
   for q in v:walk(q)
 walk(x);return out
def floor_total(segment):return max(n['Range']['Max'] for n in segment['Floors']['nodes'])
def scale_range_nodes(nodes,total):
 old=max(n['Range']['Max'] for n in nodes);split=max(1,total//2)
 if len(nodes)==1:nodes[0]['Range']={'Min':0,'Max':total}
 else:
  nodes[0]['Range']={'Min':0,'Max':split};nodes[1]['Range']={'Min':split,'Max':total}
  del nodes[2:]
 return old
def scale_zone_ranges(x,old,total):
 if isinstance(x,dict):
  if set(x.keys())=={'Item','Range'} and isinstance(x['Range'],dict):
   r=x['Range'];r['Min']=round(r.get('Min',0)*total/old);r['Max']=max(r['Min']+1,round(r.get('Max',old)*total/old));r['Max']=min(total,r['Max'])
  for v in x.values():scale_zone_ranges(v,old,total)
 elif isinstance(x,list):
  for v in x:scale_zone_ranges(v,old,total)
def replace_roster(segment,roster,total,level):
 steps=find_type(segment,'TeamSpawnZoneStep')
 if not steps:raise ValueError('reference has no TeamSpawnZoneStep')
 for step in steps:
  proto=copy.deepcopy(step['Spawns'][0]);spawns=[]
  for i,species in enumerate(roster):
   row=copy.deepcopy(proto);mob=row['Spawn']['Spawn'];mob['BaseForm']={'Species':species,'Form':0,'Skin':'','Gender':-1};mob['Level']={'Min':level+i%4,'Max':level+3+i%4};mob['SpecifiedSkills']=[];mob['Intrinsic']='';mob['Tactic']=['wander_dumb','wander_dumb_two_range','wander_normal'][i%3];mob['SpawnConditions']=[];mob['SpawnFeatures']=[{'$type':'PMDC.LevelGen.MobSpawnWeak, PMDC'}];row['Rate']=12 if i<20 else 5;row['Range']={'Min':0,'Max':total};spawns.append(row)
  step['Spawns']=spawns;step['TeamSizes']=[{'Spawn':1,'Rate':12,'Range':{'Min':0,'Max':total}},{'Spawn':2,'Rate':10,'Range':{'Min':0,'Max':total}},{'Spawn':3,'Rate':6,'Range':{'Min':0,'Max':total}},{'Spawn':4,'Rate':2,'Range':{'Min':total//2,'Max':total}}];step['SpecificSpawns']=[]
 for settings in find_type(segment,'MobSpawnSettingsStep'):
  settings['MaxFoes']=14;settings['RespawnTime']=20
  if isinstance(settings.get('Respawn'),dict):settings['Respawn']['MaxFoes']=14;settings['Respawn']['RespawnTime']=20
def build(repo,workspace):
 repo=repo.resolve();workspace=workspace.resolve();all_species=set()
 def collect(x):
  if isinstance(x,dict):
   b=x.get('BaseForm')
   if isinstance(b,dict) and isinstance(b.get('Species'),str):all_species.add(b['Species'])
   for v in x.values():collect(v)
  elif isinstance(x,list):
   for v in x:collect(v)
 for p in (repo/'Data/Zone').glob('*.json'):
  try:collect(load_json(p))
  except:pass
 complex_source=load_json(repo/'Data/Zone/crooked_cavern.json')['Object']['Segments'][0]
 house_prototype=copy.deepcopy(find_type(complex_source,'SpreadHouseZoneStep')[0])
 tunnel_prototype=None
 for node in complex_source['Floors']['nodes']:
  for entry in node['Item'].get('GenSteps',[]):
   if 'AddTunnelStep' in entry.get('Value',{}).get('$type',''):tunnel_prototype=copy.deepcopy(entry);break
  if tunnel_prototype:break
 rows=[]
 for index,(game,key,name,reference,floors,biome) in enumerate(DEFS):
  src=repo/f'Data/Zone/{reference}.json';base=load_json(src);obj=base['Object'];segment=copy.deepcopy(next(s for s in obj['Segments'] if 'RangeDictSegment' in s.get('$type','') and isinstance(s.get('Floors'),dict) and 'nodes' in s['Floors']));
  if not find_type(segment,'SpreadHouseZoneStep'):segment.setdefault('ZoneSteps',[]).append(copy.deepcopy(house_prototype))
  for node in segment['Floors']['nodes']:
   steps=node['Item'].setdefault('GenSteps',[])
   if not any('AddTunnelStep' in e.get('Value',{}).get('$type','') for e in steps):steps.append(copy.deepcopy(tunnel_prototype))
  old=scale_range_nodes(segment['Floors']['nodes'],floors);scale_zone_ranges(segment.get('ZoneSteps',[]),old,floors);pool=list(dict.fromkeys(x for x in POOLS[biome] if x in all_species))
  if len(pool)<30:raise ValueError(f'{biome}: only {len(pool)} verified species')
  offset=(index*7)%len(pool);roster=(pool[offset:]+pool[:offset])[:30];replace_roster(segment,roster,floors,18+(index%8));segment['IsRelevant']=True;segment['Comment']=f'{name} — structure complexe PMDO, escaliers RogueElements et roster étendu.'
  zone=copy.deepcopy(base);o=zone['Object'];asset=f'{game}_{key}_pmdo';o['Name']={'DefaultText':name,'LocalTexts':{'fr':name}};o['Released']=True;o['Comment']=f'Candidat BIBLIOTHEQUE {game}; basé sur {reference}, sans promotion runtime.';o['Segments']=[segment];o['GroundMaps']=[];o['Level']=18+(index%8);o['LevelCap']=False;o['TeamSize']=4;o['BagSize']=32
  out=workspace/f'games/{game}/conversion/pmdo_dungeons/zones/{asset}.json';out.parent.mkdir(parents=True,exist_ok=True);out.write_text('\ufeff'+json.dumps(zone,ensure_ascii=False,indent=1),encoding='utf-8')
  c=Counter();types(segment,c);rows.append({'game_id':game,'dungeon_id':asset,'source_family':key,'name_fr':name,'reference_zone':reference,'file':out.relative_to(workspace/f'games/{game}').as_posix(),'sha256':sha256_file(out),'floor_count':floors,'unique_species_count':len(set(roster)),'species':roster,'stairs_step_count':c['FloorStairsStep`3[[RogueEssence.LevelGen.MapGenContext'] if False else sum(v for k,v in c.items() if k.startswith('FloorStairsStep')),'generation_types':dict(sorted(c.items())),'max_foes':14,'respawn_time':20})
 for game in ('reminiscencia','relict'):
  selected=[x for x in rows if x['game_id']==game];root=workspace/f'games/{game}/conversion/pmdo_dungeons';manifest={'schema_version':'1.0.0','result':f'{game.upper()}_PMDO_DUNGEONS_PASS','game_id':game,'dungeon_count':len(selected),'total_floor_count':sum(x['floor_count'] for x in selected),'roster_entry_count':sum(x['unique_species_count'] for x in selected),'unique_species_count':len({s for x in selected for s in x['species']}),'stairs_authority':'RogueElements.FloorStairsStep','structure_authority':'PMDO 0.8.12 native RangeDictSegment/GridFloorGen','runtime_destination_written':False,'dungeons':selected};write_json(root/'manifest.json',manifest)
 return rows
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--repo',type=Path,required=True);p.add_argument('--workspace',type=Path,required=True);a=p.parse_args();r=build(a.repo,a.workspace);print(json.dumps({'result':'IMPORTED_PMDO_DUNGEONS_PASS','dungeons':len(r),'floors':sum(x['floor_count'] for x in r),'roster_entries':sum(x['unique_species_count'] for x in r)},sort_keys=True))
