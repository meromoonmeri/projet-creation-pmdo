#!/usr/bin/env python3
"""Restore effective templates and event-driven environment layers in PMDO candidates."""
from __future__ import annotations
import argparse,hashlib,json,math,re,shutil,tempfile,zipfile,zlib
from collections import defaultdict
from pathlib import Path
from typing import Any
from convert_map_ir_to_pmdo import premultiply,read_tile,write_tile
from inventory_relict import decode_text,ivar,load,parse_map,sha256_file,write_json
from png_rgba import RGBAImage,load_png,png_bytes,save_png
from render_pmdo_final_maps import additive_over,scale_nearest
from render_rmxp_archive_maps import contact_outputs
from ruby_marshal import load_bytes
TILE=16
DUNGEONS={7:'forest',84:'cave',119:'snow_forest',164:'prison',191:'deciduous_forest',203:'justice',213:'temple',195:'lake',296:'volcano',299:'cliff',208:'tower',341:'mine',319:'wheat',417:'bay',446:'rift',468:'burned_tower',518:'meteor_falls'}
GENERATOR_FILES={7:'2320 Bosque.rb',84:'2330 Cueva.rb',518:'2332 MeteorFalls.rb',119:'2340 Bosque Nieve.rb',164:'2350 Prision.rb',191:'2360 Bosque Caduco.rb',203:'2370 Palacio de Justicia.rb',213:'2380 Templo Varuna.rb',195:'2390 Lago Caduco.rb',208:'2400 Torre Caduco.rb',296:'2410 Volcan.rb',299:'2420 Risco.rb',319:'2430 Trigal.rb',341:'2440 Mina.rb',417:'2441 Bahia.rb',446:'2442 Brecha.rb',468:'2443 Quemada.rb'}
RELICT_CONTROLLERS={3,4,10,15};RELICT_INTENTIONAL_VOID={13,19,25,27}
def compact(path,obj,bom=False):
 path.parent.mkdir(parents=True,exist_ok=True);path.write_text(('\ufeff' if bom else '')+json.dumps(obj,ensure_ascii=False,separators=(',',':')),encoding='utf-8')
def empty():return {'AutoTileset':'','Associates':[],'Layers':[],'NeighborCode':-1}
def visual(sheet,locs,length=60):return {'AutoTileset':'','Associates':[],'Layers':[{'Frames':[{'Sheet':sheet,'TexLoc':{'X':x,'Y':y}} for x,y in locs],'FrameLength':length}],'NeighborCode':-1}
def opacity(im,value):
 out=RGBAImage(im.width,im.height,bytearray(im.pixels))
 for i in range(3,len(out.pixels),4):out.pixels[i]=(out.pixels[i]*value+127)//255
 return out
def template_records(source):
 data=load(source/'Data/MapTemplates.dat');records=[];byid=defaultdict(list)
 for key,obj in data.items():
  raw=ivar(obj,'map_data');decoded=load_bytes(zlib.decompress(raw));row={'template_name':decode_text(key),'map_id':int(ivar(obj,'map_id')),'effective_width_tiles':int(ivar(obj,'width')),'effective_height_tiles':int(ivar(obj,'height')),'placement_pattern':decode_text(ivar(obj,'pattern','')),'compressed_map_data_sha256':hashlib.sha256(raw).hexdigest(),'source_tileset_id':int(ivar(decoded,'tileset_id',0))};records.append(row);byid[row['map_id']].append(row)
 return sorted(records,key=lambda x:(x['map_id'],x['template_name'])),byid
def generator_memberships(source,records):
 used=defaultdict(list);root=source/'Data/export'
 for did,file in GENERATOR_FILES.items():
  text=(root/file).read_text(encoding='utf-8-sig',errors='replace');keys=set(re.findall(r'\$map_templates\["([^"]+)"\]',text))
  for row in records:
   if row['template_name'] in keys:used[row['template_name']].append(did)
 return used
def vfx_assets(game):
 manifest=json.load(open(game/'vfx/manifest.json'));byname={};byhash={}
 for row in manifest['environment_assets']:
  byname[(row['kind'],row.get('source_name') or row.get('name'))]=row
  name=row.get('source_name') or row.get('name')
  if name:byhash[hashlib.sha256(name.encode()).hexdigest()]=row
 return manifest,byname,byhash
def frames_for(game,row):
 p=game/row['output']
 if p.suffix.lower()=='.png':return [load_png(p)],[1000]
 meta=json.load(open(p));rows=meta.get('frames') or meta['layers'][0]['frames'];return [load_png(p.parent/f['file']) for f in rows],[int(f['duration_ms']) for f in rows]
def dynamic_states(game,map_id,byname,byhash):
 p=game/f'vfx/timelines/maps/map_{map_id:03d}.json';payload=json.load(open(p));commands=[]
 for seq in payload.get('sequences',[]):commands += seq['timeline']
 commands.sort(key=lambda x:x.get('source_index',0));pan=[];fogs=[];pictures=[];slots=set()
 for c in commands:
  if c['category']=='map_visual_settings':
   q=c['parameters'];name=q.get('environment_name');kind='PANORAMA' if q.get('setting_type')==0 else 'FOG';row=byname.get((kind,name))
   if not row or not name:continue
   vals=q.get('values',[]);state={'kind':kind,'name':name,'asset':row,'source_index':c.get('source_index',0),'hue':int(vals[0]) if vals else 0}
   if kind=='FOG':state.update({'opacity':int(vals[1]) if len(vals)>1 else 255,'blend_type':int(vals[2]) if len(vals)>2 else 0,'zoom_percent':int(vals[3]) if len(vals)>3 else 100,'scroll_x':int(vals[4]) if len(vals)>4 else 0,'scroll_y':int(vals[5]) if len(vals)>5 else 0});fogs.append(state)
   else:pan.append(state)
  elif c['category']=='picture_show_review_required':
   q=c['parameters'];row=byhash.get(q['source_identity_sha256']);nums=q.get('numeric_and_safe_parameters',[]);slot=int(nums[0]) if nums else 0
   if not row or slot in slots:continue
   slots.add(slot);pictures.append({'kind':'ENVIRONMENT_OVERLAY','name':row.get('source_name'),'asset':row,'source_index':c.get('source_index',0),'slot':slot,'x':int(nums[3]) if len(nums)>3 else 0,'y':int(nums[4]) if len(nums)>4 else 0,'scale_x':int(nums[5]) if len(nums)>5 else 100,'scale_y':int(nums[6]) if len(nums)>6 else 100,'opacity':max(1,int(nums[7]) if len(nums)>7 else 255),'blend_type':int(nums[8]) if len(nums)>8 else 0})
 # The first panorama/fog is the source state at map entry. Alternatives stay in the manifest.
 selected=([pan[0]] if pan else [])+([fogs[0]] if fogs else [])+pictures
 return selected,pan+fogs+pictures
def sheet_of(ground):
 for layer in ground['Object']['Layers']:
  for col in layer['Tiles']:
   for cell in col:
    for tl in cell.get('Layers',[]):
     for f in tl.get('Frames',[]):
      if f.get('Sheet'):return f['Sheet']
 raise ValueError('Ground has no sheet')
def layer_from_asset(sheet,state,frames,durations,width,height,add_payload):
 kind=state['kind'];zoom=state.get('zoom_percent',100);sx=state.get('scale_x',100);sy=state.get('scale_y',100)
 scaled=[]
 for im in frames:
  factor_x=(zoom/200) if kind=='FOG' else (sx/200 if kind=='ENVIRONMENT_OVERLAY' else .5);factor_y=(zoom/200) if kind=='FOG' else (sy/200 if kind=='ENVIRONMENT_OVERLAY' else .5)
  nim=scale_nearest(im,max(1,round(im.width*factor_x)),max(1,round(im.height*factor_y)));nim=opacity(nim,state.get('opacity',255));scaled.append(nim)
 wc=max((im.width+15)//16 for im in scaled);hc=max((im.height+15)//16 for im in scaled);locations={};first={}
 for y in range(hc):
  for x in range(wc):
   ls=[]
   for fi,im in enumerate(scaled):
    tile=RGBAImage.empty(16,16);cw=min(16,max(0,im.width-x*16));ch=min(16,max(0,im.height-y*16))
    if cw and ch:tile.blit_replace(im.crop(x*16,y*16,cw,ch),0,0)
    ls.append(add_payload(tile));
    if fi==0:first[(x,y)]=tile
   locations[(x,y)]=ls
 ticks=max(1,round((durations[0] if durations else 1000)*60/1000)) if len(scaled)>1 else 60;cols=[];repeat=kind in ('PANORAMA','FOG');ox=round(state.get('x',0)/2);oy=round(state.get('y',0)/2)
 for x in range(width):
  col=[]
  for y in range(height):
   px=x if repeat else x-(ox//16);py=y if repeat else y-(oy//16)
   if repeat:loc=locations[(px%wc,py%hc)];col.append(visual(sheet,loc,ticks))
   elif 0<=px<wc and 0<=py<hc:col.append(visual(sheet,locations[(px,py)],ticks))
   else:col.append(empty())
  cols.append(col)
 return {'Name':f"{kind} dynamique — {state['name']}",'Layer':0,'Visible':True,'Tiles':cols},scaled[0],{'width_cells':wc,'height_cells':hc,'repeat':repeat,'offset_px':[ox,oy],'frame_count':len(scaled),'frame_duration_ms':durations[0] if durations else None,'blend_type':state.get('blend_type',0),'scroll':[state.get('scroll_x',0),state.get('scroll_y',0)]}
def preview_apply(old,state,image):
 w,h=old.width,old.height;kind=state['kind']
 if kind=='PANORAMA':
  base=RGBAImage.empty(w,h,(0,0,0,255))
  for y in range(0,h,image.height):
   for x in range(0,w,image.width):base.alpha_over(image,x,y)
  for i in range(0,len(old.pixels),4):
   if old.pixels[i:i+4] != bytearray((0,0,0,255)):base.pixels[i:i+4]=old.pixels[i:i+4]
  return base
 out=RGBAImage(old.width,old.height,bytearray(old.pixels));x=round(state.get('x',0)/2);y=round(state.get('y',0)/2)
 if kind=='FOG':
  for py in range(0,h,image.height):
   for px in range(0,w,image.width):out.alpha_over(image,px,py)
 else:out.alpha_over(image,x,y)
 return out
def unpremultiply(im):
 out=RGBAImage(im.width,im.height,bytearray(im.pixels))
 for i in range(0,len(out.pixels),4):
  a=out.pixels[i+3]
  if a:
   for c in range(3):out.pixels[i+c]=min(255,(out.pixels[i+c]*255+a//2)//a)
 return out
def render_ground(ground,tile_path,temp,cache):
 _,payloads=read_tile(tile_path);images={}
 for loc,payload in payloads.items():
  key=hashlib.sha256(payload).hexdigest()
  if key not in cache:
   path=temp/f'{key}.png'
   if not path.exists():path.write_bytes(payload)
   cache[key]=unpremultiply(load_png(path))
  images[loc]=cache[key]
 o=ground['Object'];w=len(o['Layers'][0]['Tiles']);h=len(o['Layers'][0]['Tiles'][0]);canvas=RGBAImage.empty(w*16,h*16,(0,0,0,255))
 for layer in o['Layers']:
  for x,col in enumerate(layer['Tiles']):
   for y,cell in enumerate(col):
    for tl in cell.get('Layers',[]):
     frames=tl.get('Frames',[])
     if frames:
      loc=frames[0]['TexLoc'];im=images.get((loc['X'],loc['Y']))
      if im:canvas.alpha_over(im,x*16,y*16)
 return canvas
def crop_ground(ground,w,h):
 o=ground['Object']
 for layer in o['Layers']:layer['Tiles']=[col[:h] for col in layer['Tiles'][:w]]
 o['obstacles']=[col[:h*2] for col in o['obstacles'][:w*2]]
 return ground
def deterministic_zip(grounds,target):
 with zipfile.ZipFile(target,'w') as z:
  for name,data in sorted(grounds.items()):
   info=zipfile.ZipInfo(name,(1980,1,1,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED;info.external_attr=0o100644<<16;z.writestr(info,data,compress_type=zipfile.ZIP_DEFLATED,compresslevel=9)
def map_transfers(game,map_id):
 p=game/f'vfx/timelines/maps/map_{map_id:03d}.json';d=json.load(open(p));out=[]
 for seq in d.get('sequences',[]):
  for c in seq['timeline']:
   if c['category']=='map_transfer':
    vals=c.get('parameters',[]);target=vals[1] if len(vals)>1 and isinstance(vals[1],int) else None
    out.append({'source_event_id':seq['source_event_id'],'page_index':seq['page_index'],'target_map_id':target,'safe_parameters':vals})
 return out
def viewport_policy(game_name,map_id,width,height,role):
 if role=='COMPONENT_TEMPLATE':return {'mode':'INHERIT_GENERATED_DUNGEON','viewport_px':None,'zoom_change':False,'reason':'Composant non explorable; le cadrage appartient au donjon assemblé.'}
 if role in ('LOGIC_CONTROLLER','CINEMATIC_CONTROLLER','EXCLUDED_CASTING_SCENE'):return {'mode':'NO_EXPLORATION_VIEWPORT','viewport_px':None,'zoom_change':False,'reason':'Contrôleur ou scène de casting exclue sans environnement exportable; aucun remplissage artificiel.'}
 if role=='CINEMATIC_TRANSITION':return {'mode':'FIXED_SCENE_320x240','viewport_px':[320,240],'zoom_change':False,'reason':'État visuel plein écran piloté par événement.'}
 if role=='INTENTIONAL_SCENE_VOID':return {'mode':'SOURCE_SCENE_CAMERA','viewport_px':[320,240],'zoom_change':False,'reason':'Vide noir intentionnel conservé; caméra locale, aucun dézoom.'}
 if width>20 or height>15:return {'mode':'PLAYER_FOLLOW_CLAMP','viewport_px':[320,240],'zoom_change':False,'reason':'Grande zone: exploration locale façon PMDO/Metano, sans afficher toute la carte.'}
 return {'mode':'ORIGINAL_ONE_SCREEN_CLAMP','viewport_px':[320,240],'zoom_change':False,'reason':'La vue originale à échelle entière est déjà lisible.'}
def process(game_name,source,workspace):
 game=workspace/f'games/{game_name}';out=game/'conversion/pmdo_candidates';report=json.load(open(out/'conversion_report.json'));rows={r['map_id']:r for r in report['maps']};manifest,byname,byhash=vfx_assets(game);template_list=[];templates={};memberships={}
 if game_name=='reminiscencia':template_list,templates=template_records(source);memberships=generator_memberships(source,template_list)
 with zipfile.ZipFile(out/report['ground_storage']['file']) as z:grounds={i.filename:z.read(i.filename) for i in z.infolist()}
 atlas_cache={};atlas_meta={a['sheet']:a for a in report['atlases']};composition=[];black_audit=[]
 for mid,row in sorted(rows.items()):
  side_path=out/row['sidecar'];side=json.load(open(side_path));ground_name=f'{game_name}_map_{mid:03d}.rsground';ground=json.loads(grounds[ground_name].decode('utf-8-sig'))
  try:sheet=sheet_of(ground)
  except ValueError:
   source_map,_=parse_map(source/f'Data/Map{mid:03d}.rxdata');sheet=f'{game_name}_tileset_{int(ivar(source_map,"tileset_id",0)):03d}_Base'
  tile_path=out/f'tiles/{sheet}.tile'
  if sheet not in atlas_cache:
   _,payloads=read_tile(tile_path);entries=[(x|(y<<32),p) for (x,y),p in sorted(payloads.items(),key=lambda q:(q[0][1],q[0][0]))];dedupe={p:loc for loc,p in payloads.items()};next_index=max((y*64+x for x,y in payloads),default=-1)+1
   atlas_cache[sheet]={'entries':entries,'dedupe':dedupe,'next':next_index,'path':tile_path}
  cache=atlas_cache[sheet]
  def add_payload(im):
   payload=png_bytes(premultiply(im));loc=cache['dedupe'].get(payload)
   if loc is None:
    i=cache['next'];cache['next']+=1;loc=(i%64,i//64);cache['dedupe'][payload]=loc;cache['entries'].append((loc[0]|(loc[1]<<32),payload))
   return loc
  selected,allstates=dynamic_states(game,mid,byname,byhash);preview=load_png(out/row['preview']);materialized=[]
  for state in selected:
   frames,durations=frames_for(game,state['asset']);layer,first,detail=layer_from_asset(sheet,state,frames,durations,len(ground['Object']['Layers'][0]['Tiles']),len(ground['Object']['Layers'][0]['Tiles'][0]),add_payload)
   if state['kind']=='PANORAMA':ground['Object']['Layers'].insert(0,layer)
   else:ground['Object']['Layers'].append(layer)
   preview=preview_apply(preview,state,first);materialized.append({k:v for k,v in state.items() if k!='asset'}|detail)
  role='STANDARD_MAP';effective=None
  if game_name=='reminiscencia' and mid in templates:
   t=templates[mid][0];effective=[t['effective_width_tiles'],t['effective_height_tiles']];ground=crop_ground(ground,*effective);preview=preview.crop(0,0,effective[0]*16,effective[1]*16);role='COMPONENT_TEMPLATE';side['source_container_geometry']=dict(side['source_geometry']);side['effective_template_geometry']={'width_tiles':effective[0],'height_tiles':effective[1],'authority':'Data/MapTemplates.dat','template_names':[x['template_name'] for x in templates[mid]],'placement_patterns':[x['placement_pattern'] for x in templates[mid]]};side['pmdo_geometry']['width_cells']=effective[0];side['pmdo_geometry']['height_cells']=effective[1];side['pmdo_geometry']['width_px']=effective[0]*16;side['pmdo_geometry']['height_px']=effective[1]*16
  all_zero=all(v==0 for line in side['collision']['effective_tile_ids'] for v in line)
  if row.get('status')=='UNSUPPORTED':role='EXCLUDED_CASTING_SCENE'
  elif game_name=='reminiscencia' and all_zero and role!='COMPONENT_TEMPLATE':role='CINEMATIC_TRANSITION' if selected else 'LOGIC_CONTROLLER'
  if game_name=='relict':
   if mid in RELICT_CONTROLLERS:role='LOGIC_CONTROLLER'
   elif mid in RELICT_INTENTIONAL_VOID:role='INTENTIONAL_SCENE_VOID'
   elif selected:role='CINEMATIC_TRANSITION' if all_zero else 'STANDARD_MAP'
  black=sum(preview.pixels[i:i+4]==bytearray((0,0,0,255)) for i in range(0,len(preview.pixels),4));black_ratio=black/(preview.width*preview.height)
  if role=='STANDARD_MAP' and black_ratio>=.999:role='CINEMATIC_CONTROLLER'
  width=effective[0] if effective else side['source_geometry']['width_tiles'];height=effective[1] if effective else side['source_geometry']['height_tiles'];policy=viewport_policy(game_name,mid,width,height,role);side['assembly']={'role':role,'dynamic_environment_materialized':materialized,'all_dynamic_states':[{k:v for k,v in s.items() if k!='asset'} for s in allstates],'viewport_policy':policy,'transfers':map_transfers(game,mid)};side['status']='ADAPTATION_REQUIRED' if role in ('LOGIC_CONTROLLER','CINEMATIC_CONTROLLER','COMPONENT_TEMPLATE') or any(x.get('blend_type') or x.get('scroll')!=[0,0] for x in materialized) else side['status'];compact(side_path,side);save_png(preview,out/row['preview'])
  ground['Object']['Comment']+=' Assemblage: '+role+'; viewport '+policy['mode']+'.';raw=('\ufeff'+json.dumps(ground,ensure_ascii=False,separators=(',',':'))).encode();grounds[ground_name]=raw;row['ground_sha256']=hashlib.sha256(raw).hexdigest();row['sidecar_sha256']=sha256_file(side_path);row['preview_sha256']=sha256_file(out/row['preview']);row['assembly_role']=role;row['viewport_policy']=policy;row['dynamic_environment_materialized_count']=len(materialized)
  if effective:row['source_container_dimensions_px']=row['source_dimensions_px'];row['source_dimensions_px']=[effective[0]*32,effective[1]*32];row['pmdo_dimensions_px']=[effective[0]*16,effective[1]*16];row['default_viewport_exact_fit']=effective==[20,15]
  composition.append({'map_id':mid,'source_name':row['source_name'],'role':role,'effective_dimensions_tiles':effective or [width,height],'dynamic_environment':materialized,'transfers':side['assembly']['transfers'],'viewport':policy})
  black_audit.append({'map_id':mid,'role':role,'black_pixel_ratio':black_ratio,'intentional_or_nonvisual':role in ('LOGIC_CONTROLLER','CINEMATIC_CONTROLLER','EXCLUDED_CASTING_SCENE','COMPONENT_TEMPLATE','INTENTIONAL_SCENE_VOID')})
 for sheet,cache in atlas_cache.items():
  write_tile(cache['path'],16,cache['entries']);meta=atlas_meta[sheet];meta['sha256']=sha256_file(cache['path']);meta['size_bytes']=cache['path'].stat().st_size;meta['assembled_payload_count']=len(cache['dedupe'])
 # Re-render from the actual serialized Ground and premultiplied atlas so previews match PMDO.
 with tempfile.TemporaryDirectory() as td:
  temp=Path(td);image_cache={};audit_by={x['map_id']:x for x in black_audit}
  for mid,row in sorted(rows.items()):
   ground=json.loads(grounds[f'{game_name}_map_{mid:03d}.rsground'].decode('utf-8-sig'))
   try:sheet_name=sheet_of(ground)
   except ValueError:
    source_map,_=parse_map(source/f'Data/Map{mid:03d}.rxdata');sheet_name=f'{game_name}_tileset_{int(ivar(source_map,"tileset_id",0)):03d}_Base'
   preview=render_ground(ground,out/f'tiles/{sheet_name}.tile',temp,image_cache);save_png(preview,out/row['preview']);row['preview_sha256']=sha256_file(out/row['preview']);black=sum(preview.pixels[i:i+4]==bytearray((0,0,0,255)) for i in range(0,len(preview.pixels),4));audit_by[mid]['black_pixel_ratio']=black/(preview.width*preview.height)
 deterministic_zip(grounds,out/report['ground_storage']['file']);report['ground_storage']['sha256']=sha256_file(out/report['ground_storage']['file']);report['ground_storage']['size_bytes']=(out/report['ground_storage']['file']).stat().st_size;report['default_viewport_exact_fit_count']=sum(r['default_viewport_exact_fit'] for r in rows.values());report['assembly']={'result':'ASSEMBLED_MAPS_PASS','template_component_count':len(templates),'dynamic_environment_map_count':sum(r['dynamic_environment_materialized_count']>0 for r in rows.values()),'logic_controller_count':sum(r['assembly_role']=='LOGIC_CONTROLLER' for r in rows.values()),'cinematic_controller_count':sum(r['assembly_role']=='CINEMATIC_CONTROLLER' for r in rows.values()),'viewport_policy':'PER_MAP_NO_GLOBAL_ZOOM'};sheet,pages=contact_outputs(out,[{'map_id':r['map_id'],'file':r['preview']} for r in report['maps']]);report['contact_sheet']=sheet;report['contact_pages']=pages;compact(out/'conversion_report.json',report)
 assembly_root=game/'manifests';assembly_root.mkdir(exist_ok=True);payload={'schema_version':'1.0.0','result':f'{game_name.upper()}_ASSEMBLY_MANIFEST_PASS','game_id':game_name,'maps':composition,'black_audit':black_audit,'source_connections_dat_count':len(load(source/'Data/connections.dat')) if (source/'Data/connections.dat').exists() else 0}
 if game_name=='reminiscencia':
  payload['map_templates']=[r|{'generator_dungeon_ids':memberships.get(r['template_name'],[])} for r in template_list];payload['generated_dungeons']=[{'map_id':mid,'family':family,'source_generator':GENERATOR_FILES[mid],'template_names':sorted([name for name,ids in memberships.items() if mid in ids]),'composition':'SOURCE_GENERATED_SNAPSHOT_PLUS_RUNTIME_TEMPLATE_RULES','viewport':viewport_policy(game_name,mid,20,15,'STANDARD_MAP')} for mid,family in DUNGEONS.items()]
 write_json(assembly_root/'assembly_manifest.json',payload);return report,payload
def main():
 p=argparse.ArgumentParser();p.add_argument('--workspace',type=Path,required=True);p.add_argument('--reminiscencia-source',type=Path,required=True);p.add_argument('--relict-source',type=Path,required=True);a=p.parse_args()
 for game,source in [('reminiscencia',a.reminiscencia_source),('relict',a.relict_source)]:
  r,m=process(game,source.resolve(),a.workspace.resolve());print(json.dumps({'game':game,'maps':r['map_count'],'templates':r['assembly']['template_component_count'],'dynamic_maps':r['assembly']['dynamic_environment_map_count'],'controllers':r['assembly']['logic_controller_count'],'result':m['result']},sort_keys=True))
if __name__=='__main__':main()
