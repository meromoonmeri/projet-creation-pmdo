#!/usr/bin/env python3
"""Construit la cutscene PMDO Pichu × Team Dazzling (carte cliffdaytest).
Le joueur HTML est une prévisualisation ; le mod livré contient les vrais .rsground et scripts Halcyon.
"""
from __future__ import annotations
import base64, copy, gzip, hashlib, io, json, re, struct, uuid, zipfile
import xml.etree.ElementTree as ET
from pathlib import Path
import numpy as np
from PIL import Image

ROOT=Path(__file__).resolve().parents[2]
SRC=Path(__file__).resolve().parent
ASSETS=SRC/'assets'
MOD=SRC/'mod_pmdo'
OUT=ROOT/'livrables_cutscene_pichu_dazzling_pmdo'
HTML=ROOT/'apercu_cine_pichu_team_dazzling.html'
CANONICAL_SHA='6567e19df7a073758d8d52ad1491460067a2dccc1c0d03aa0d1c72b5592e4d2f'
PIN='3609a86be2a4c8ad7cf255bd2255f044daafe24f'

CHARACTERS={
 'pichu':{'id':'0172','name':'Pichu','species':'pichu','gender':0,'portrait':'Pichu'},
 'adagio':{'id':'0763','name':'Adagio','species':'tsareena','gender':1,'portrait':'Adagio'},
 'sonata':{'id':'0428','name':'Sonata','species':'lopunny','gender':1,'portrait':'Sonata'},
 'aria':{'id':'0303','name':'Aria','species':'mawile','gender':1,'portrait':'Aria'},
}

# États de scène du lecteur : coordonnées en pixels dans le monde de cliffdaytest.
ACTORS={
 'pichu':{'x':608,'y':476,'anim':'Idle','dir':0,'visible':True,'emote':None},
 'adagio':{'x':739,'y':770,'anim':'Walk','dir':4,'visible':True,'emote':None},
 'sonata':{'x':717,'y':772,'anim':'Walk','dir':4,'visible':True,'emote':None},
 'aria':{'x':765,'y':773,'anim':'Walk','dir':4,'visible':True,'emote':None},
}
STEPS=[]
def step(act,title,speaker,emotion,text,camera,changes=None,duration=2300,transition=650):
    global ACTORS
    if changes:
        for key,values in changes.items(): ACTORS[key].update(values)
    STEPS.append({'act':act,'title':title,'speaker':speaker,'emotion':emotion,'text':text,
      'camera':{'x':camera[0],'y':camera[1]},'actors':copy.deepcopy(ACTORS),
      'duration':duration,'transition':transition})

step('I · Le matin','Un matin au bord de la mer','pichu','Happy','Ouah… Quel bon vent marin ce matin !',(608,476),{'pichu':{'anim':'Idle','dir':0}},2500)
step('I · Le matin','Devant sa maison','pichu','Joyous','On entend les vagues jusque devant la porte !',(608,476),{'pichu':{'x':608,'y':476,'anim':'Walk','dir':0}},2300,900)
step('I · Le matin','Le reflet dans la mare','pichu','Inspired','Un jour, je partirai explorer des endroits dont personne ne connaît encore le nom.',(590,476),{'pichu':{'x':556,'y':476,'anim':'Walk','dir':6}},2800,1000)
step('II · Le rêve','Le chemin de la Guilde','pichu','Inspired','La Guilde… C’est là que commencent les grandes aventures !',(620,500),{'pichu':{'x':612,'y':476,'anim':'Walk','dir':2}},2300,700)
step('II · Le rêve','Au carrefour','pichu','Determined','Je vais leur montrer que moi aussi, je peux devenir explorateur !',(640,526),{'pichu':{'x':640,'y':526,'anim':'Idle','dir':0}},2400,1000)
step('III · La rencontre','Des pas sur le sentier','pichu','Surprised','Hein ? Quelqu’un arrive par le chemin…',(700,600),{'pichu':{'anim':'Idle','dir':4},'adagio':{'anim':'Walk','dir':4},'sonata':{'anim':'Walk','dir':4},'aria':{'anim':'Walk','dir':4}},2300,900)
step('III · La rencontre','La Team Dazzling','sonata','Happy','Ohhh, regardez-moi ce tout petit bout de chou !',(680,530),{'adagio':{'x':674,'y':524,'anim':'Idle','dir':4},'sonata':{'x':692,'y':506,'anim':'Appeal','dir':4},'aria':{'x':694,'y':542,'anim':'Idle','dir':4}},2600,950)
step('III · La rencontre','Pichu se présente','pichu','Shouting','Je ne suis pas un bébé ! Je vais rejoindre la Guilde et devenir explorateur !',(660,526),{'pichu':{'anim':'Hop','dir':2,'emote':'!'}},2900)
step('IV · Les moqueries','Aria ricane','aria','Happy','Au premier coup de vent dans un donjon, tu risques de t’envoler avant le premier étage !',(660,526),{'aria':{'anim':'Attack','dir':6}},3000)
step('IV · Les moqueries','Sonata en rajoute','sonata','Joyous','Et tes joues, elles crépitent toujours quand tu te donnes de grands airs ?',(660,526),{'sonata':{'anim':'Appeal','dir':6}},2700)
step('IV · Les moqueries','Pichu relève le défi','pichu','Determined','Je peux me débrouiller ! Regardez bien !',(660,526),{'pichu':{'anim':'Charge','dir':2,'emote':'!'}},2200)
step('IV · Les moqueries','Une étincelle… ratée','pichu','Surprised','Je vais vous montrer… !',(660,526),{'pichu':{'anim':'Shock','dir':2,'emote':'⚡'}},1600)
step('IV · Les moqueries','Le choc','pichu','Pain','Bzzzt ! Aïe… mes joues !',(660,526),{'pichu':{'anim':'Pain','dir':2,'emote':'💧'}},2300)
step('IV · Les moqueries','Adagio tranche','adagio','Angry','La Guilde, ce n’est pas une garderie pour bébés Pokémon en quête d’histoires !',(660,526),{'adagio':{'anim':'Kick','dir':6}},3100)
step('IV · Les moqueries','Aria ricane encore','aria','Happy','Commence par maîtriser tes étincelles avant de rêver aux donjons !',(660,526),{'aria':{'anim':'Rotate','dir':6}},2700)
step('IV · Les moqueries','Pichu encaisse','pichu','Worried','Je… je vais m’entraîner. Je ne laisserai pas ça m’arrêter.',(660,526),{'pichu':{'anim':'Hurt','dir':2,'emote':None}},2700)
step('IV · Les moqueries','Elles reprennent leur route','adagio','Happy','Allez, les filles. On n’a pas toute la journée.',(700,500),{'adagio':{'anim':'Rotate','dir':2},'sonata':{'anim':'Rotate','dir':2},'aria':{'anim':'Rotate','dir':2}},2400)
step('V · La promesse','La Team Dazzling s’éloigne','pichu','Sad','Même pas un au revoir…',(820,468),{'adagio':{'x':968,'y':468,'anim':'Walk','dir':2},'sonata':{'x':960,'y':468,'anim':'Walk','dir':2},'aria':{'x':952,'y':468,'anim':'Walk','dir':2},'pichu':{'anim':'Idle','dir':2}},2900,1100)
step('V · La promesse','Un instant de doute','pichu','Teary-Eyed','Peut-être qu’elles ont raison… Je n’ai même pas réussi à lancer une étincelle.',(640,526),{'adagio':{'visible':False},'sonata':{'visible':False},'aria':{'visible':False},'pichu':{'anim':'Sit','dir':0,'emote':'…'}},3000,850)
step('V · La promesse','Pichu relève la tête','pichu','Determined','Non. Leur rire ne décidera pas de ce que je vaux.',(640,526),{'pichu':{'anim':'DeepBreath','dir':0,'emote':None}},2800)
step('V · La promesse','Une détermination neuve','pichu','Shouting','Je rejoindrai la Guilde. Et je deviendrai explorateur, quoi qu’il arrive !',(640,540),{'pichu':{'anim':'Pose','dir':0,'emote':'!'}},2900)
step('V · La promesse','En route vers la Guilde','pichu','Determined','Cette fois, je ne reculerai pas !',(716,650),{'pichu':{'x':708,'y':556,'anim':'Walk','dir':3}},2300,900)
step('V · La promesse','Le premier pas','pichu','Determined','Attends-moi, Guilde ! J’arrive !',(736,770),{'pichu':{'x':736,'y':770,'anim':'Walk','dir':4}},2600,1200)


def data_uri(path:Path)->str:
    return 'data:image/png;base64,'+base64.b64encode(path.read_bytes()).decode('ascii')

def png_dims(raw:bytes)->tuple[int,int]:
    if raw[:8]!=b'\x89PNG\r\n\x1a\n': raise ValueError('PNG invalide')
    return struct.unpack('>II',raw[16:24])

def canonical_ground_bytes()->bytes:
    raw=gzip.decompress((ASSETS/'map/cliffdaytest_source.rsground.gz').read_bytes())
    if hashlib.sha256(raw).hexdigest()!=CANONICAL_SHA:raise RuntimeError('La carte canonique embarquée est invalide.')
    return raw

def extract_viewer_layers():
    """Charge les captures intégrées au paquet; l'aperçu externe n'est qu'un fallback de reconstruction."""
    files={
      'day_sky':'viewer_layers_1x/cliffdaytest_nuit_sky_jour.png',
      'day_canopy':'viewer_layers_1x/cliffdaytest_nuit_canopy_jour.png',
      'night_canopy':'viewer_layers_1x/cliffdaytest_nuit_canopy_nuit.png',
      'day_cloud_horizon':'viewer_layers_1x/nuages_jour_horizon_1440.png',
      'day_cloud_mid':'viewer_layers_1x/nuages_jour_milieu_1440.png',
      'day_cloud_high':'viewer_layers_1x/nuages_jour_haut_1440.png',
    }
    for phase in range(8):
        files[f'day_sea_{phase}']=f'viewer_layers_1x/cliffdaytest_nuit_sea_jour_{phase}.png'
        files[f'night_sea_{phase}']=f'viewer_layers_1x/cliffdaytest_nuit_sea_nuit_{phase}.png'
    for phase in range(4):
        files[f'day_terrain_{phase}']=f'viewer_layers_1x/cliffdaytest_nuit_terrain_jour_{phase}.png'
        files[f'night_terrain_{phase}']=f'viewer_layers_1x/cliffdaytest_nuit_terrain_nuit_{phase}.png'
    target=ASSETS/'engine_layers';target.mkdir(parents=True,exist_ok=True)
    def expected_size(key):
        if key=='day_cloud_horizon':return (1440,64)
        if key in ('day_cloud_mid','day_cloud_high'):return (1440,96)
        return (984,792)
    bundled={key:target/f'{key}.png' for key in files}
    if all(path.is_file() for path in bundled.values()):
        for key,path in bundled.items():
            if png_dims(path.read_bytes())!=expected_size(key):raise ValueError(f'Couche PNG locale invalide : {path.name}')
        return bundled
    viewer=(ROOT/'apercu_cliff_nord_nuit_pmdo.html').read_text(encoding='utf-8')
    match=re.search(r'const EMBEDDED_PNGS = (\{.*?\});\s*\(\(\) =>',viewer,re.S)
    if not match:raise RuntimeError('Couches intégrées absentes du viewer Cliffdaytest.')
    embedded=json.loads(match.group(1))
    for key,tail in files.items():
        entry=next((k for k in embedded if k.endswith('/'+tail)),None)
        if entry is None:raise FileNotFoundError(f'Couche PNG absente : {tail}')
        raw=base64.b64decode(embedded[entry].split(',',1)[1])
        if png_dims(raw)!=expected_size(key):raise ValueError(f'Dimension invalide pour {tail}: {png_dims(raw)}')
        dest=bundled[key];dest.write_bytes(raw)
    return bundled


def premultiplied_tile_png(image:Image.Image)->bytes:
    import zlib
    arr=np.asarray(image.convert('RGBA'),dtype=np.uint16).copy()
    arr[:,:,:3]=(arr[:,:,:3]*arr[:,:,3:4]+127)//255
    im=Image.fromarray(arr.astype('uint8'),'RGBA');out=io.BytesIO()
    im.save(out,format='PNG',optimize=True,compress_level=9)
    return out.getvalue()


def write_animated_tile_sheet(frames:list[Image.Image],name:str,path:Path)->None:
    """Packe des captures de couches (984×792) dans un atlas 8px PMDO animé, une tranche par frame."""
    if not frames:raise ValueError('Atlas sans image')
    if any(im.size!=(984,792) for im in frames):raise ValueError('Toutes les frames doivent mesurer 984×792')
    tile_images=[];unique={};entries=[]
    for fi,image in enumerate(frames):
        rgba=image.convert('RGBA')
        for x in range(123):
            for y in range(99):
                tile=rgba.crop((x*8,y*8,(x+1)*8,(y+1)*8))
                blob=premultiplied_tile_png(tile)
                if blob not in unique:unique[blob]=None;tile_images.append(blob)
                entries.append((x,y+fi*99,blob))
    offset=8+len(entries)*16;offsets={}
    for blob in tile_images:offsets[blob]=offset;offset+=8+len(blob)
    raw=bytearray(struct.pack('<ii',8,len(entries)))
    for x,y,blob in entries:raw.extend(struct.pack('<iiq',x,y,offsets[blob]))
    for blob in tile_images:raw.extend(struct.pack('<q',len(blob)));raw.extend(blob)
    path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(raw)


def make_tilemap_layer(template:dict,name:str,depth:int,sheet:str,frame_count:int,frame_length:int):
    blank=copy.deepcopy(template['Tiles'][0][0]);blank['Layers']=[]
    layer=copy.deepcopy(template);layer['Name']=name;layer['Layer']=depth;layer['Visible']=True
    layer['Tiles']=[[copy.deepcopy(blank) for _ in range(99)] for _ in range(123)]
    for x in range(123):
        for y in range(99):
            if frame_count==1:
                frames=[{'Sheet':sheet,'TexLoc':{'X':x,'Y':y}}]
            else:
                frames=[{'Sheet':sheet,'TexLoc':{'X':x,'Y':y+i*99}} for i in range(frame_count)]
            layer['Tiles'][x][y]=copy.deepcopy(blank)
            layer['Tiles'][x][y]['Layers']=[{'Frames':frames,'FrameLength':frame_length}]
    return layer


def write_tile_index_idx(tile_paths:list[Path],path:Path)->None:
    def dotnet_string(value:str)->bytes:
        data=value.encode('utf-8');length=len(data);prefix=bytearray()
        while length>=128:prefix.append((length&127)|128);length>>=7
        prefix.append(length);return bytes(prefix)+data
    nodes=[]
    for tile in sorted(tile_paths,key=lambda p:p.stem):
        raw=tile.read_bytes();_,count=struct.unpack_from('<ii',raw,0)
        nodes.append((tile.stem,raw[:8+count*16]))
    out=bytearray(struct.pack('<i',len(nodes)))
    for name,node in nodes:out.extend(dotnet_string(name));out.extend(node)
    path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(out)


def transparent_png(w:int,h:int)->bytes:
    import zlib
    def chunk(typ,data):return struct.pack('>I',len(data))+typ+data+struct.pack('>I',zlib.crc32(typ+data)&0xffffffff)
    scan=b'\0'+b'\0'*(w*4)
    raw=scan*h
    return b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>2I5B',w,h,8,6,0,0,0))+chunk(b'IDAT',zlib.compress(raw,9))+chunk(b'IEND',b'')

def write_dir(path:Path,png:bytes)->None:
    image=Image.open(io.BytesIO(png)).convert('RGBA');w,h=image.size
    encoded=premultiplied_tile_png(image)
    path.parent.mkdir(parents=True,exist_ok=True)
    path.write_bytes(struct.pack('<q',len(encoded))+encoded+struct.pack('<4i',w,h,0,1))

def make_map_bg(name:str,offset:int=0,speed:int=0,repeat:bool=False):
    return {'$type':'RogueEssence.Dungeon.MapBG, RogueEssence','MapLoc':{'X':0,'Y':offset},
      'BGAnim':{'AnimIndex':name,'FrameTime':1,'StartFrame':-1,'EndFrame':-1,'AnimDir':-1,'Alpha':255,'AnimFlip':0},
      'BGMovement':{'X':speed,'Y':0},'Parallax':'1, 1','RepeatX':repeat,'RepeatY':False}

def char_data(species:str,nickname:str,gender:int):
    return {'Nickname':nickname,'OriginalUUID':'','OriginalTeam':'','BaseForm':{'Species':species,'Form':0,'Skin':'normal','Gender':gender},
      'Level':5,'EXP':0,'MaxHPBonus':0,'AtkBonus':0,'DefBonus':0,'MAtkBonus':0,'MDefBonus':0,'SpeedBonus':0,
      'BaseSkills':[{'SkillNum':'','Charges':0,'CanForget':True} for _ in range(4)],'BaseIntrinsics':['none'],'FormIntrinsicSlot':-1,'Relearnables':{},
      'Discriminator':0,'MetAt':'','MetLoc':{'ID':'','StructID':{'Segment':-1,'ID':-1},'EntryPoint':-1},'DefeatAt':'',
      'DefeatLoc':{'ID':'','StructID':{'Segment':-1,'ID':-1},'EntryPoint':-1},'IsFounder':False,'IsPartner':False,'NameLocked':True,
      'IsFavorite':False,'Unrecruitable':True,'ActionEvents':[],'ScriptVars':None}

def build_ground_files(viewer_layers):
    raw=canonical_ground_bytes()
    day=json.loads(raw.decode('utf-8-sig'));obj=day['Object'];ent=obj['Entities'][0]
    # Le Ground est reconstruit avec des atlases locaux issus des couches de rendu jour/nuit : plus de références .tile manquantes.
    template=copy.deepcopy(obj['Layers'][0])
    sheets={
      'day_sky':'PICHU_CLIFF_DAY_SKY','day_sea':'PICHU_CLIFF_DAY_SEA','day_terrain':'PICHU_CLIFF_DAY_TERRAIN','day_canopy':'PICHU_CLIFF_DAY_CANOPY',
      'night_sea':'PICHU_CLIFF_NIGHT_SEA','night_terrain':'PICHU_CLIFF_NIGHT_TERRAIN','night_canopy':'PICHU_CLIFF_NIGHT_CANOPY'}
    def open_frames(prefix,count):
        return [Image.open(viewer_layers[f'{prefix}_{i}']).convert('RGBA') for i in range(count)]
    frame_images={
      'day_sky':[Image.open(viewer_layers['day_sky']).convert('RGBA')],
      'day_sea':open_frames('day_sea',8),'day_terrain':open_frames('day_terrain',4),
      'day_canopy':[Image.open(viewer_layers['day_canopy']).convert('RGBA')],
      'night_sea':open_frames('night_sea',8),'night_terrain':open_frames('night_terrain',4),
      'night_canopy':[Image.open(viewer_layers['night_canopy']).convert('RGBA')],
    }
    tile_dir=MOD/'Content/Tile';tile_dir.mkdir(parents=True,exist_ok=True);tile_paths=[]
    for key,name in sheets.items():
        path=tile_dir/f'{name}.tile';write_animated_tile_sheet(frame_images[key],name,path);tile_paths.append(path)
    def make_layers(keys):
        result=[]
        for key,name,depth,framelen,label in keys:
            result.append(make_tilemap_layer(template,label,depth,sheets[key],len(frame_images[key]),framelen))
        return result
    day_layers=make_layers([
      ('day_sky','',0,60,'Ciel — jour'),('day_sea','',0,10,'Mer — animation 8 phases'),
      ('day_terrain','',0,10,'Terrain — animation 4 phases'),('day_canopy','',4,60,'Canopée — avant-plan'),
    ])
    day['Object']['Layers']=day_layers;day['Object']['AssetName']='cliffdaytest'
    day['Object']['BlankBG']['Layers']=[{'Frames':[{'Sheet':sheets['day_sky'],'TexLoc':{'X':0,'Y':0}}],'FrameLength':60}]
    day['Object']['Background']={'$type':'RogueEssence.Dungeon.LayeredBG, RogueEssence','Layers':[
      {'BG':make_map_bg('CLIFF_PICHU_DAY_CLOUD_HORIZON',240,-5,True)},
      {'BG':make_map_bg('CLIFF_PICHU_DAY_CLOUD_MID',134,-9,True)},
      {'BG':make_map_bg('CLIFF_PICHU_DAY_CLOUD_HIGH',26,-14,True)},
    ]}
    # Actor Pichu starts directly below the house door on a tested walkable tile (the roof cell at y=450 is blocked).
    ent=day['Object']['Entities'][0]
    pichu_template=json.loads((ROOT/'source/antre_harmonie_v3/references/altere_pond.rsground').read_text(encoding='utf-8-sig'))['Object']['Entities'][0]['MapChars'][0]
    pichu=copy.deepcopy(pichu_template);pichu.update({'Direction':0,'IsInteracting':False,'AIEnabled':False,'EntName':'Pichu','EntEnabled':True,'EntOrder':0,'InteractOrder':0,'serializationLoc':{'X':608,'Y':476},'serializationHeight':0,'serializationDir':0,'triggerType':1,'CollisionDisabled':False,'Collider':{'X':608,'Y':476,'Width':16,'Height':16}})
    pichu['Data']=char_data('pichu','Pichu',0)
    ent['MapChars']=[x for x in ent.get('MapChars',[]) if x.get('EntName')!='Pichu']+[pichu]
    team=[('Adagio','tsareena',1),('Sonata','lopunny',1),('Aria','mawile',1)]
    for spawn,(name,species,gender) in zip(ent['Spawners'],team):
        spawn['NPCName']=name;spawn['EntName']=name;spawn['NPCChar']=char_data(species,name,gender)
        spawn['Direction']=4;spawn['EntEnabled']=True
    ent['Markers']=[{'EntName':name,'Direction':direction,'EntEnabled':True,'EntOrder':i,'InteractOrder':0,'triggerType':0,
      'Collider':{'X':x-8,'Y':y-8,'Width':16,'Height':16}}
      for i,(name,x,y,direction) in enumerate([
       ('Pichu_Home_Door',608,450,0),('Pichu_Pond',556,476,6),('Pichu_Crossroads',640,526,0),
       ('Dazzling_Entry_South',739,770,4),('Dazzling_Stand',674,524,4),('Dazzling_Exit_East',968,468,2)])]
    day['Object']['Layers'][0]['Name']='Ciel — jour'
    night=copy.deepcopy(day);no=night['Object'];no['AssetName']='cliffdaytest_nuit';no['Name']['DefaultText']='Cliff Reverie Town — Nuit'
    no['Layers']=make_layers([
      ('night_sea','',0,10,'Mer — animation 8 phases'),('night_terrain','',0,10,'Terrain — animation 4 phases'),
      ('night_canopy','',4,60,'Canopée — avant-plan'),
    ])
    no['BlankBG']['Layers']=[{'Frames':[{'Sheet':sheets['night_sea'],'TexLoc':{'X':0,'Y':0}}],'FrameLength':60}]
    no['Background']={'$type':'RogueEssence.Dungeon.LayeredBG, RogueEssence','Layers':[
      {'BG':make_map_bg('CLIFF_PICHU_NUIT_CIEL')},{'BG':make_map_bg('CLIFF_PICHU_NUIT_ASTRES')},
      {'BG':make_map_bg('CLIFF_PICHU_NUIT_NUAGES_HORIZON',252,-5,True)},
      {'BG':make_map_bg('CLIFF_PICHU_NUIT_NUAGES_MILIEU',168,-9,True)},
      {'BG':make_map_bg('CLIFF_PICHU_NUIT_NUAGES_HAUT',80,-14,True)},
    ]}
    sources={
      'CLIFF_PICHU_DAY_CLOUD_HORIZON':viewer_layers['day_cloud_horizon'],
      'CLIFF_PICHU_DAY_CLOUD_MID':viewer_layers['day_cloud_mid'],
      'CLIFF_PICHU_DAY_CLOUD_HIGH':viewer_layers['day_cloud_high'],
      'CLIFF_PICHU_NUIT_CIEL':ASSETS/'map/cliffdaytest_nuit_BG00_ciel_et_astres.png',
      'CLIFF_PICHU_NUIT_ASTRES':None,
      'CLIFF_PICHU_NUIT_NUAGES_HORIZON':ASSETS/'map/cliffdaytest_nuit_BG01_nuages_animes_wrap.png',
      'CLIFF_PICHU_NUIT_NUAGES_MILIEU':None,'CLIFF_PICHU_NUIT_NUAGES_HAUT':None,
    }
    for name,path in sources.items():
        content=path.read_bytes() if path else transparent_png(984,792)
        write_dir(MOD/f'Content/BG/{name}.dir',content)
    write_tile_index_idx(tile_paths,tile_dir/'index.idx')
    (MOD/'Data/Ground/cliffdaytest.rsground').parent.mkdir(parents=True,exist_ok=True)
    for stem,payload in [('cliffdaytest',day),('cliffdaytest_nuit',night)]:
        (MOD/f'Data/Ground/{stem}.rsground').write_bytes(b'\xef\xbb\xbf'+(json.dumps(payload,ensure_ascii=False,indent=2)+'\n').encode('utf-8'))
    return day,night

LUA='''require 'common'
local cliffdaytest = {}
local function anim(ch, name, looped)
  if ch ~= nil then GROUND:CharSetAnim(ch, name, looped) end
end
local function say(ch, emotion, text)
  UI:SetSpeaker(ch)
  UI:SetSpeakerEmotion(emotion)
  UI:WaitShowDialogue(text)
end
function cliffdaytest.Init(map)
  DEBUG.EnableDbgCoro()
  COMMON.RespawnAllies()
end
function cliffdaytest.Enter(map)
  SV.PichuDazzling = SV.PichuDazzling or {}
  if not SV.PichuDazzling.Seen then cliffdaytest.Cinematique_Rencontre_Team_Dazzling() else GAME:FadeIn(20) end
end
function cliffdaytest.Exit(map) end
function cliffdaytest.Update(map) end
function cliffdaytest.GameSave(map) end
function cliffdaytest.GameLoad(map) GAME:FadeIn(20) end
function cliffdaytest.Cinematique_Rencontre_Team_Dazzling()
  local pichu = CH('Pichu')
  local adagio = CH('Adagio')
  local sonata = CH('Sonata')
  local aria = CH('Aria')
  GAME:CutsceneMode(true)
  if pichu ~= nil then AI:DisableCharacterAI(pichu); anim(pichu, 'Idle', true) end
  if adagio ~= nil then AI:DisableCharacterAI(adagio) end
  if sonata ~= nil then AI:DisableCharacterAI(sonata) end
  if aria ~= nil then AI:DisableCharacterAI(aria) end
  GAME:MoveCamera(608, 476, 1, true)
  GAME:FadeIn(30)
  GROUND:MoveToPosition(pichu, 608, 476, false, 1)
  anim(pichu, 'Idle', true)
  say(pichu, 'Happy', 'Ouah… Quel bon vent marin ce matin !')
  say(pichu, 'Joyous', 'On entend les vagues jusque devant la porte !')
  GROUND:MoveToPosition(pichu, 556, 476, false, 1)
  GROUND:CharSetAnim(pichu, 'Idle', true)
  say(pichu, 'Inspired', 'Un jour, je partirai explorer des endroits dont personne ne connaît encore le nom.')
  GROUND:MoveToPosition(pichu, 612, 476, false, 1)
  GROUND:MoveToPosition(pichu, 640, 526, false, 1)
  GAME:MoveCamera(640, 526, 30, true)
  say(pichu, 'Determined', 'La Guilde… C’est là que commencent les grandes aventures !')
  say(pichu, 'Determined', 'Je vais leur montrer que moi aussi, je peux devenir explorateur !')
  GAME:MoveCamera(700, 600, 30, true)
  local a = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(adagio, 716, 650, false, 1)
    GROUND:MoveToPosition(adagio, 708, 560, false, 1)
    GROUND:MoveToPosition(adagio, 674, 524, false, 1)
  end)
  local b = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(sonata, 704, 668, false, 1)
    GROUND:MoveToPosition(sonata, 702, 574, false, 1)
    GROUND:MoveToPosition(sonata, 692, 506, false, 1)
  end)
  local c = TASK:BranchCoroutine(function()
    GROUND:MoveToPosition(aria, 728, 664, false, 1)
    GROUND:MoveToPosition(aria, 718, 578, false, 1)
    GROUND:MoveToPosition(aria, 694, 542, false, 1)
  end)
  TASK:JoinCoroutines({a, b, c})
  GAME:MoveCamera(660, 526, 24, true)
  GROUND:CharTurnToCharAnimated(sonata, pichu, 4)
  say(sonata, 'Happy', 'Ohhh, regardez-moi ce tout petit bout de chou ! Tu t’es perdu loin de ton nid, bonhomme ?')
  GROUND:CharTurnToCharAnimated(pichu, sonata, 4)
  anim(pichu, 'Hop', false)
  say(pichu, 'Shouting', 'Je ne suis pas un bébé ! Je vais rejoindre la Guilde et devenir explorateur !')
  anim(aria, 'Attack', false)
  say(aria, 'Happy', 'Au premier coup de vent dans un donjon, tu risques de t’envoler avant le premier étage !')
  anim(sonata, 'Appeal', false)
  say(sonata, 'Joyous', 'Et tes joues, elles crépitent toujours quand tu te donnes de grands airs ?')
  anim(pichu, 'Charge', false)
  say(pichu, 'Determined', 'Je peux me débrouiller ! Regardez bien !')
  anim(pichu, 'Shock', false)
  GAME:WaitFrames(18)
  anim(pichu, 'Pain', false)
  say(pichu, 'Pain', 'Bzzzt ! Aïe… mes joues !')
  anim(adagio, 'Kick', false)
  say(adagio, 'Angry', 'La Guilde, ce n’est pas une garderie pour bébés Pokémon en quête d’histoires !')
  anim(aria, 'Rotate', false)
  say(aria, 'Happy', 'Commence par maîtriser tes étincelles avant de rêver aux donjons !')
  anim(pichu, 'Hurt', false)
  say(pichu, 'Worried', 'Je… je vais m’entraîner. Je ne laisserai pas ça m’arrêter.')
  GROUND:CharSetAnim(adagio, 'Walk', true)
  GROUND:CharSetAnim(sonata, 'Walk', true)
  GROUND:CharSetAnim(aria, 'Walk', true)
  say(adagio, 'Happy', 'Allez, les filles. On n’a pas toute la journée.')
  local d = TASK:BranchCoroutine(function() GROUND:MoveToPosition(adagio, 696, 468, false, 1); GROUND:MoveToPosition(adagio, 968, 468, false, 1) end)
  local e = TASK:BranchCoroutine(function() GROUND:MoveToPosition(sonata, 704, 468, false, 1); GROUND:MoveToPosition(sonata, 960, 468, false, 1) end)
  local f = TASK:BranchCoroutine(function() GROUND:MoveToPosition(aria, 712, 468, false, 1); GROUND:MoveToPosition(aria, 952, 468, false, 1) end)
  TASK:JoinCoroutines({d, e, f})
  GAME:MoveCamera(640, 526, 24, true)
  anim(pichu, 'Sit', true)
  say(pichu, 'Teary-Eyed', 'Peut-être qu’elles ont raison… Je n’ai même pas réussi à lancer une étincelle.')
  anim(pichu, 'DeepBreath', false)
  say(pichu, 'Determined', 'Non. Leur rire ne décidera pas de ce que je vaux.')
  anim(pichu, 'Pose', false)
  say(pichu, 'Shouting', 'Je rejoindrai la Guilde. Et je deviendrai explorateur, quoi qu’il arrive !')
  anim(pichu, 'Walk', true)
  GROUND:MoveToPosition(pichu, 708, 556, false, 1)
  GROUND:MoveToPosition(pichu, 716, 650, false, 1)
  GAME:MoveCamera(716, 650, 30, true)
  GROUND:MoveToPosition(pichu, 736, 770, false, 1)
  GAME:WaitFrames(30)
  SV.PichuDazzling.Seen = true
  GAME:CutsceneMode(false)
end
return cliffdaytest
'''

HTML_TEMPLATE=r'''<!doctype html><html lang="fr"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Pichu & Team Dazzling · Cutscene PMDO</title><style>
:root{color-scheme:dark;--bg:#101827;--panel:#19253a;--line:#395071;--gold:#f5ca6c;--text:#eef3fb;--muted:#b8c5d7}*{box-sizing:border-box}body{margin:0;background:radial-gradient(ellipse at top,#273954,#0b111c 66%);color:var(--text);font:15px/1.5 system-ui,sans-serif}header{padding:20px 20px 15px;border-bottom:1px solid var(--line);background:#101a2b}main{max-width:1120px;margin:auto;padding:20px}.eyebrow{color:var(--gold);font-size:.8rem;font-weight:800;letter-spacing:.12em;text-transform:uppercase}h1{margin:4px 0;font-size:clamp(1.4rem,3vw,2rem)}.sub{color:var(--muted);margin:0}.layout{display:grid;grid-template-columns:minmax(0,1fr) 290px;gap:16px;align-items:start}.card{background:var(--panel);border:1px solid var(--line);border-radius:14px;padding:14px;box-shadow:0 18px 40px #0005}.screenwrap{width:100%;display:flex;justify-content:center;background:#080d16;border:1px solid #526b8d;border-radius:8px;padding:10px;overflow:hidden}.screen{width:min(100%,960px);height:auto;aspect-ratio:4/3;image-rendering:pixelated;image-rendering:crisp-edges;display:block}.controls{display:flex;flex-wrap:wrap;align-items:center;gap:8px;margin-top:12px}.controls button,.controls select{border:1px solid #637c9d;background:#293b57;color:#fff;padding:8px 11px;border-radius:7px;font-weight:700;cursor:pointer}.controls button:hover{background:#395477}.controls input[type=range]{flex:1;min-width:160px;accent-color:var(--gold)}.counter{color:var(--gold);font-weight:800;min-width:100px}.mode{margin-left:auto;color:var(--muted);font-size:.9rem}.side h2{font-size:1rem;margin:0 0 10px;color:var(--gold)}.stepname{font-size:1.07rem;font-weight:800;margin:3px 0}.dialog{font-size:.93rem;color:var(--muted);margin:3px 0 12px}.route{display:grid;gap:6px}.route button{width:100%;text-align:left;border:1px solid transparent;background:#111b2d;color:#d8e1ee;border-radius:7px;padding:7px 9px;cursor:pointer;font-size:.85rem}.route button.active{border-color:var(--gold);background:#30334a;color:#fff}.route button:hover{background:#273852}.badges{display:flex;flex-wrap:wrap;gap:6px;margin:12px 0}.badge{padding:4px 8px;border:1px solid var(--line);border-radius:999px;color:#d2e3f6;font-size:.75rem}.note{margin-top:14px;font-size:.84rem;color:var(--muted);border-left:3px solid var(--gold);padding-left:10px}.details{margin-top:18px}.details summary{cursor:pointer;color:var(--gold);font-weight:700}pre{white-space:pre-wrap;background:#0b111c;padding:12px;border-radius:8px;max-height:420px;overflow:auto;color:#d3deeb;font-size:.8rem}.files a{color:#b8dcff;display:inline-block;margin:5px 12px 0 0}.sectiontitle{margin:18px 0 7px;color:var(--gold)}@media(max-width:850px){.layout{grid-template-columns:1fr}.side{display:grid;grid-template-columns:1fr}.screen{width:min(100%,720px)}}
</style></head><body><header><div class="eyebrow">CINÉMATIQUE PMDO · 320 × 240 NATIF</div><h1>Pichu et la Team Dazzling — « Le rêve ne s’éteint pas »</h1><p class="sub">Cliff Reverie Town · cliffdaytest · scènes et sprites PMDO réels · Jour / Nuit</p></header><main><div class="layout"><section class="card"><div class="screenwrap"><canvas id="screen" class="screen" width="320" height="240" aria-label="Viewport PMDO 320 par 240"></canvas></div><div class="controls"><button id="play">⏸ Pause</button><button id="prev">← Étape</button><button id="next">Étape →</button><input id="seek" type="range" min="0" max="22" value="0" aria-label="Étape de la cinématique"><span id="counter" class="counter"></span><select id="speed"><option value="1">1×</option><option value="0.6">0,6×</option><option value="1.5">1,5×</option></select><label class="mode"><input id="night" type="checkbox"> 🌙 Nuit</label></div><div class="badges"><span class="badge">Viewport natif 320×240</span><span class="badge">Pixel-art net ×1 / ×2 / ×3</span><span class="badge">Sprites SpriteCollab · AnimData.xml</span><span class="badge">Tri des personnages par Y</span><span class="badge">Boîte de dialogue PMDO</span></div><h2 class="sectiontitle" id="stageTitle"></h2><p id="dialogue" class="dialog"></p><div class="files"><a href="./source/cutscene_pichu_dazzling_pmdo/mod_pmdo/Data/Ground/cliffdaytest.rsground" download>Carte Jour .rsground</a><a href="./source/cutscene_pichu_dazzling_pmdo/mod_pmdo/Data/Ground/cliffdaytest_nuit.rsground" download>Carte Nuit .rsground</a><a href="./livrables_cutscene_pichu_dazzling_pmdo/MOD_CUTSCENE_PICHU_DAZZLING_PMDO.zip" download>Mod PMDO ZIP</a></div></section><aside class="card side"><h2>Déroulé — 5 actes</h2><div class="stepname" id="act"></div><div class="route" id="route"></div><p class="note">La scène joue les animations officielles réellement déclarées dans <code>AnimData.xml</code>. Le lecteur est une prévisualisation de la cinématique ; les deux fichiers Ground et les scripts Halcyon sont livrés dans le ZIP.</p><details class="details"><summary>Voir le script Halcyon Lua</summary><pre id="lua"></pre></details><details class="details"><summary>Voir les déplacements vérifiés</summary><pre id="paths"></pre></details></aside></div></main>
<script>
const BUNDLE=__BUNDLE__;
const STEPS=__STEPS__;
const LUA=__LUA__;
const canvas=document.getElementById('screen'),ctx=canvas.getContext('2d');ctx.imageSmoothingEnabled=false;
const imgCache=new Map();function image(uri){if(!imgCache.has(uri)){const im=new Image();im.src=uri;imgCache.set(uri,im)}return imgCache.get(uri)}
const day=image(BUNDLE.map.day),night=image(BUNDLE.map.night);
for(const p of Object.values(BUNDLE.pokemon)){for(const a of Object.values(p.anims))image(a.src);for(const q of Object.values(p.portraits))image(q)}
let index=0,playing=true,elapsed=0,last=performance.now();const seek=document.getElementById('seek');
function wrapText(text,max){const words=(text||'').split(/\s+/),lines=[];let line='';for(const w of words){const test=line?line+' '+w:w;if(ctx.measureText(test).width>max&&line){lines.push(line);line=w}else line=test}if(line)lines.push(line);return lines}
function drawSprite(actor,actorName,now,cam){const meta=BUNDLE.pokemon[actorName].anims[actor.anim]||BUNDLE.pokemon[actorName].anims.Idle;const im=image(meta.src);if(!im.complete||!im.naturalWidth)return;const total=meta.durations.reduce((a,b)=>a+b,0);let t=Math.floor(now/55)%Math.max(1,total),col=0;while(col<meta.durations.length-1&&t>=meta.durations[col]){t-=meta.durations[col];col++}const row=meta.rows===1?0:Math.max(0,Math.min(meta.rows-1,actor.dir||0));const sx=col*meta.fw,sy=row*meta.fh;const x=Math.round(actor.x-cam.x+160-meta.fw/2),y=Math.round(actor.y-cam.y+120-meta.fh);ctx.fillStyle='rgba(12,20,32,.26)';ctx.beginPath();ctx.ellipse(actor.x-cam.x+160,actor.y-cam.y+120-2,meta.fw*.28,3,0,0,Math.PI*2);ctx.fill();ctx.drawImage(im,sx,sy,meta.fw,meta.fh,x,y,meta.fw,meta.fh);if(actor.emote)drawEmote(actor.emote,actor.x-cam.x+160,y-5,now)}
function drawEmote(label,x,y,now){const bob=Math.round(Math.sin(now*.007)*1.4);ctx.fillStyle='#fff9e9';ctx.strokeStyle='#213047';ctx.lineWidth=1;ctx.beginPath();ctx.roundRect(Math.round(x-8),Math.round(y-16+bob),16,13,3);ctx.fill();ctx.stroke();ctx.fillStyle=label==='!'||label==='⚡'?'#d93333':'#234a8d';ctx.font='bold 9px sans-serif';ctx.textAlign='center';ctx.textBaseline='middle';ctx.fillText(label==='⚡'?'✦':label,x,y-9+bob)}
function actorState(idx,name,now){const cur=STEPS[idx].actors[name],prev=STEPS[Math.max(0,idx-1)].actors[name];const tr=Math.max(1,STEPS[idx].transition),t=Math.min(1,elapsed/tr);return {...cur,x:prev.x+(cur.x-prev.x)*t,y:prev.y+(cur.y-prev.y)*t}}
function drawDialog(s){const speaker=s.speaker;const char=BUNDLE.pokemon[speaker]||BUNDLE.pokemon.pichu;const emotion=char.portraits[s.emotion]||char.portraits.Normal;const pic=image(emotion);ctx.fillStyle='rgba(3,9,23,.30)';ctx.fillRect(0,168,320,72);ctx.fillStyle='#07152d';ctx.strokeStyle='#64bfe9';ctx.lineWidth=2;ctx.beginPath();ctx.roundRect(8,177,304,55,6);ctx.fill();ctx.stroke();ctx.fillStyle='#10284e';ctx.strokeStyle='#8bd7ff';ctx.beginPath();ctx.roundRect(17,164,Math.min(99,20+ctx.measureText(char.name).width),19,4);ctx.fill();ctx.stroke();ctx.fillStyle='#fff';ctx.textAlign='left';ctx.textBaseline='middle';ctx.font='bold 10px system-ui';ctx.fillText(char.name,24,174);if(pic.complete&&pic.naturalWidth){const px=speaker==='pichu'?12:268;ctx.fillStyle='#091b36';ctx.fillRect(px-2,152,44,44);ctx.strokeStyle='#78c9f2';ctx.strokeRect(px-2,152,44,44);ctx.drawImage(pic,px,154,40,40)}ctx.fillStyle='#f3f5fc';ctx.font='11px system-ui';ctx.textAlign='left';ctx.textBaseline='top';const left=speaker==='pichu'?21:19;const lines=wrapText(s.text,280);lines.slice(0,3).forEach((line,i)=>ctx.fillText(line,left,188+i*14))}
function render(now){const s=STEPS[index],cam=s.camera,map=document.getElementById('night').checked?night:day;if(map.complete&&map.naturalWidth){const sx=Math.max(0,Math.min(BUNDLE.map.width-320,cam.x-160)),sy=Math.max(0,Math.min(BUNDLE.map.height-240,cam.y-120));ctx.drawImage(map,sx,sy,320,240,0,0,320,240)}else{ctx.fillStyle='#416494';ctx.fillRect(0,0,320,240)}const chars=Object.keys(s.actors).filter(k=>s.actors[k].visible).sort((a,b)=>s.actors[a].y-s.actors[b].y);for(const k of chars)drawSprite(actorState(index,k,now),k,now,cam);drawDialog(s);document.getElementById('counter').textContent=`${index+1} / ${STEPS.length}`;document.getElementById('act').textContent=s.act;document.getElementById('stageTitle').textContent=s.title;document.getElementById('dialogue').textContent=`${BUNDLE.pokemon[s.speaker]?.name||s.speaker} : « ${s.text} »`;seek.value=index;document.querySelectorAll('#route button').forEach((b,i)=>b.classList.toggle('active',i===index))}
function change(n){index=(n+STEPS.length)%STEPS.length;elapsed=0;render(performance.now())}document.getElementById('prev').onclick=()=>change(index-1);document.getElementById('next').onclick=()=>change(index+1);seek.oninput=()=>{playing=false;document.getElementById('play').textContent='▶ Lire';change(Number(seek.value))};document.getElementById('night').onchange=()=>render(performance.now());document.getElementById('play').onclick=()=>{playing=!playing;document.getElementById('play').textContent=playing?'⏸ Pause':'▶ Lire';last=performance.now()};document.getElementById('speed').onchange=()=>{};
STEPS.forEach((s,i)=>{const b=document.createElement('button');b.textContent=`${String(i+1).padStart(2,'0')} · ${s.title}`;b.onclick=()=>{playing=false;document.getElementById('play').textContent='▶ Lire';change(i)};document.getElementById('route').append(b)});document.getElementById('lua').textContent=LUA;document.getElementById('paths').textContent='Pichu : (608,476) → (556,476) → (612,476) → (640,526) → (708,556) → (716,650) → (736,770)\nAdagio : (739,770) → (716,650) → (708,560) → (674,524) → (696,468) → (968,468)\nSonata : (717,772) → (704,668) → (702,574) → (692,506) → (704,468) → (960,468)\nAria : (765,773) → (728,664) → (718,578) → (694,542) → (712,468) → (952,468)\nAller-retour contrôlé sur la grille obstacles de la carte canonique.';
function raf(now){const dt=Math.min(80,now-last);last=now;if(playing){elapsed+=dt*Number(document.getElementById('speed').value);if(elapsed>=STEPS[index].duration){change(index+1)}}render(now);requestAnimationFrame(raf)}render(0);requestAnimationFrame(raf);
</script></body></html>'''


def bundle_for_player():
    manifest=json.loads((ASSETS/'manifest.json').read_text(encoding='utf-8'))
    pokemon={}
    for key,spec in CHARACTERS.items():
        folder=ASSETS/'sprite'/spec['id'];root=ET.parse(folder/'AnimData.xml').getroot();anims={}
        for node in root.findall('./Anims/Anim'):
            name=node.findtext('Name');path=folder/f'{name}-Anim.png'
            if not path.exists():continue
            fw=int(node.findtext('FrameWidth'));fh=int(node.findtext('FrameHeight'));durs=[int(n.text) for n in node.findall('./Durations/Duration')]
            width,height=png_dims(path.read_bytes());cols=len(durs);rows=height//fh
            if width!=fw*cols or rows not in (1,8):raise ValueError(f'Géométrie AnimData invalide : {spec["id"]}/{name}')
            anims[name]={'src':data_uri(path),'fw':fw,'fh':fh,'cols':cols,'rows':rows,'durations':durs}
        portrait_dir=ASSETS/'portrait'/spec['id'];portraits={p.stem:data_uri(p) for p in sorted(portrait_dir.glob('*.png'))}
        if 'Normal' not in portraits:raise FileNotFoundError(f"Portrait Normal absent : {spec['id']}")
        pokemon[key]={'id':spec['id'],'name':spec['name'],'anims':anims,'portraits':portraits}
    mapdir=ASSETS/'map'
    return {'map':{'width':984,'height':792,'day':data_uri(mapdir/'cliffdaytest_jour_ref.png'),'night':data_uri(mapdir/'cliffdaytest_nuit.png')},'pokemon':pokemon}


def write_mod_manifest():
    modxml='''<?xml version="1.0" encoding="utf-8"?>\n<Header>\n  <Name>PMDO — Pichu &amp; Team Dazzling · Cliff Reverie Town</Name>\n  <Author>Projet PMDO</Author>\n  <Description>Cutscene française Pichu / Team Dazzling sur cliffdaytest, avec variante Nuit et scripts Halcyon.</Description>\n  <Namespace>pichu_dazzling_pmdo</Namespace>\n  <UUID>'''+str(uuid.uuid5(uuid.NAMESPACE_URL,'https://arena.ai/projet-creation-pmdo/pichu-dazzling'))+'''</UUID>\n  <Version>1.0.0.0</Version>\n  <GameVersion>0.8.12.0</GameVersion>\n  <ModType>Quest</ModType>\n  <Relationships />\n</Header>\n'''
    (MOD/'Mod.xml').write_text(modxml,encoding='utf-8')
    win='''@echo off\r\nsetlocal\r\nset "MODDIR=%~dp0"\r\nfor %%I in ("%MODDIR%..\\..") do set "GAMEDIR=%%~fI"\r\ncd /d "%GAMEDIR%"\r\nif not exist "%GAMEDIR%\\PMDO.exe" (echo PMDO.exe introuvable. Placez ce mod dans PMDO\\MODS\\PichuDazzling.& pause & exit /b 1)\r\n"%GAMEDIR%\\PMDO.exe" -dev -quest "%MODDIR%"\r\n'''
    (MOD/'LANCER_CINEMATIQUE_WINDOWS.bat').write_text(win,encoding='utf-8')
    linux='''#!/usr/bin/env bash\nset -e\nMODDIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"\nGAMEDIR="$(cd -- "$MODDIR/../.." && pwd)"\nif [[ ! -x "$GAMEDIR/PMDO" ]]; then echo "PMDO introuvable. Placez ce mod dans PMDO/MODS/PichuDazzling." >&2; exit 1; fi\ncd "$GAMEDIR"\nexec "$GAMEDIR/PMDO" -dev -quest "$MODDIR"\n'''
    launcher=MOD/'LANCER_CINEMATIQUE_LINUX.sh';launcher.write_text(linux,encoding='utf-8');launcher.chmod(0o755)

def build_html():
    bundle=bundle_for_player()
    script=(MOD/'Data/Script/halcyon/ground/cliffdaytest/init.lua').read_text(encoding='utf-8')
    text=HTML_TEMPLATE.replace('__BUNDLE__',json.dumps(bundle,ensure_ascii=False,separators=(',',':'))).replace('__STEPS__',json.dumps(STEPS,ensure_ascii=False,separators=(',',':'))).replace('__LUA__',json.dumps(script,ensure_ascii=False))
    HTML.write_text(text,encoding='utf-8')
    return HTML.stat().st_size

def generate_lua_files():
    dest=MOD/'Data/Script/halcyon/ground/cliffdaytest';dest.mkdir(parents=True,exist_ok=True)
    (dest/'init.lua').write_text(LUA,encoding='utf-8')
    night=LUA.replace('cliffdaytest','cliffdaytest_nuit').replace('PichuDazzling','PichuDazzlingNuit')
    d2=MOD/'Data/Script/halcyon/ground/cliffdaytest_nuit';d2.mkdir(parents=True,exist_ok=True)
    (d2/'init.lua').write_text(night,encoding='utf-8')

def build_zip():
    OUT.mkdir(parents=True,exist_ok=True);zip_path=OUT/'MOD_CUTSCENE_PICHU_DAZZLING_PMDO.zip'
    with zipfile.ZipFile(zip_path,'w',zipfile.ZIP_DEFLATED,compresslevel=9) as z:
        for p in sorted(MOD.rglob('*')):
            if p.is_file():z.write(p,p.relative_to(MOD.parent))
        z.write(SRC/'assets/manifest.json',Path('provenance/SpriteCollab_manifest.json'))
        z.write(SRC/'README.md',Path('README.md'))
        z.writestr('README_INSTALLATION.txt',"LIRE POUR VOIR LA CINEMATIQUE DANS LE VRAI MOTEUR PMDO 0.8.12\n\n1) Fermer PMDO et extraire cette archive.\n2) Copier le dossier mod_pmdo dans <PMDO>/MODS/PichuDazzling (Mod.xml doit rester à la racine de ce dossier). C'est une Quest indépendante : ne pas fusionner son index.idx avec un autre mod.\n3) Depuis le dossier installé, lancer LANCER_CINEMATIQUE_WINDOWS.bat (Windows) ou LANCER_CINEMATIQUE_LINUX.sh (Linux). Le script démarre PMDO en mode développement avec cette Quest.\n4) Dans le jeu, ouvrir le Dev Warp/l'éditeur Ground, choisir cliffdaytest et entrer au marqueur Pichu_Home_Door. À la première entrée, la cinématique démarre automatiquement. La variante nuit est cliffdaytest_nuit. Pour rejouer, effacer SV.PichuDazzling.Seen ou choisir une sauvegarde neuve.\n\nLe mod inclut ses atlas .tile, index.idx et fonds .dir; il utilise les sprites Pokémon du PMDO installé. Les tests de structure, sprites, atlas et ZIP passent. Le moteur graphique PMDO n'a pas pu être lancé ici : le premier rendu en jeu reste à confirmer sur votre installation.\n")
    return zip_path

def main():
    canonical_ground_bytes()
    viewer_layers=extract_viewer_layers()
    day,night=build_ground_files(viewer_layers);generate_lua_files();write_mod_manifest()
    size=build_html();zip_path=build_zip()
    print(f'[OK] PMDO Ground Jour/Nuit : {MOD / "Data/Ground"}')
    print(f'[OK] Lua Halcyon : {MOD / "Data/Script/halcyon/ground"}')
    print(f'[OK] Aperçu interactif : {HTML} ({size/1024/1024:.2f} MiB)')
    print(f'[OK] Archive mod : {zip_path} ({zip_path.stat().st_size/1024/1024:.2f} MiB)')
    print('[INFO] Import et lecture moteur PMDO non testés dans cet environnement.')
if __name__=='__main__':main()
