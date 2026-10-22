#!/usr/bin/env python3
"""Convert all 552 Relict RMXP Maps to staged PMDO Ground candidates."""
from __future__ import annotations
import argparse,json,shutil,subprocess,tempfile,zipfile
from collections import defaultdict
from pathlib import Path
from typing import Any
from convert_map_ir_to_pmdo import premultiply,write_tile
from extract_relict_environmental_vfx import gif_control_metadata
from inventory_relict import decode_text,derived_collision,entity_placements,graphics_index,ivar,load,parse_map,sha256_file,tileset_descriptor,tileset_tables,visual_dependencies
from png_rgba import RGBAImage,load_png,png_bytes,save_png
from reminiscencia_environment_policy import ENVIRONMENT_CHARACTER_SHEET_HASHES
from render_pmdo_final_maps import scale_nearest
from render_relict_previews import TileRenderer
from render_rmxp_archive_maps import DEFAULT_EXCLUDED_MAPS,contact_outputs,excluded_placeholder
from ruby_marshal import RubyObject

SOURCE_TILE_SIZE=32; PMDO_TILE_SIZE=16; PMDO_TEX_SIZE=2; PMDO_COLLISION_SIZE=8
PMDO_VIEWPORT=(320,240); SOURCE_VIEWPORT=(640,480); AUTOTILE_FRAME_LENGTH=15; STATIC_FRAME_LENGTH=60

def require(v,m):
 if not v: raise ValueError(m)
def compact(path,obj,bom=False):
 path.parent.mkdir(parents=True,exist_ok=True); data=json.dumps(obj,ensure_ascii=False,separators=(",",":"),sort_keys=False)
 path.write_text(data,encoding="utf-8-sig" if bom else "utf-8")
def deterministic_zip(source:Path,target:Path)->int:
 target.parent.mkdir(parents=True,exist_ok=True)
 with zipfile.ZipFile(target,"w") as z:
  for p in sorted(source.glob("*.rsground")):
   i=zipfile.ZipInfo(p.name,(1980,1,1,0,0,0));i.compress_type=zipfile.ZIP_DEFLATED;i.external_attr=0o100644<<16
   z.writestr(i,p.read_bytes(),compress_type=zipfile.ZIP_DEFLATED,compresslevel=9)
 return len(list(source.glob("*.rsground")))
def image_opacity(im,opacity):
 out=RGBAImage(im.width,im.height,bytearray(im.pixels))
 for i in range(3,len(out.pixels),4): out.pixels[i]=(out.pixels[i]*opacity+127)//255
 return out
def load_fog(path,zoom,opacity):
 if path.suffix.casefold()==".gif":
  delays,_=gif_control_metadata(path)
  with tempfile.TemporaryDirectory() as t:
   subprocess.run(["convert",str(path),"-coalesce","-depth","8","-define","png:color-type=6",str(Path(t)/"f_%03d.png")],check=True)
   frames=[load_png(p) for p in sorted(Path(t).glob("f_*.png"))]
  durations=[v*10 for v in delays]
 else: frames=[load_png(path)];durations=[1000]
 return [image_opacity(scale_nearest(x,max(1,round(x.width*zoom/200)),max(1,round(x.height*zoom/200))),opacity) for x in frames],durations
def empty_cell(): return {"AutoTileset":"","Associates":[],"Layers":[],"NeighborCode":-1}
def visual_cell(sheet,locs,length):
 return {"AutoTileset":"","Associates":[],"Layers":[{"Frames":[{"Sheet":sheet,"TexLoc":{"X":x,"Y":y}} for x,y in locs],"FrameLength":length}],"NeighborCode":-1}
def source_dir(v): return {2:0,4:2,6:6,8:4}.get(v,0)
def marker(i,p):
 x=p["position"]["x"]*16;y=p["position"]["y"]*16
 return {"EntName":f"source_placement_{i+1:04d}","Direction":source_dir(p["graphic"]["direction"]),"EntEnabled":True,"EntOrder":0,"InteractOrder":0,"triggerType":0,"Collider":{"X":x,"Y":y,"Width":16,"Height":16}}
def rows(table,z):
 n=table.x_size*table.y_size;return [[table.values[z*n+y*table.x_size+x] for x in range(table.x_size)] for y in range(table.y_size)]
def event_tiles(entities):
 first={}
 for p in entities["placements"]: first.setdefault(p["source_event_id"],p)
 return [p for p in first.values() if p["classification"]=="ENVIRONMENTAL_TILE_ENTITY" and p["graphic"]["tile_id"] and p["graphic"]["opacity"]]
def character_sources(source):
 out={}
 for p in sorted((source/"Graphics/Characters").rglob("*")):
  if p.is_file(): out.setdefault(p.stem.casefold(),p)
 return out
def env_contexts(map_obj,index):
 out=[]
 for eid,event in sorted((ivar(map_obj,"events",{}) or {}).items(),key=lambda r:int(r[0])):
  representative=False
  for pi,page in enumerate(ivar(event,"pages",[]) or []):
   g=ivar(page,"graphic");name=decode_text(ivar(g,"character_name",""));path=index.get(name.casefold()) if name else None
   if not path or path.suffix.casefold()!=".png" or sha256_file(path) not in ENVIRONMENT_CHARACTER_SHEET_HASHES: continue
   h=sha256_file(path);out.append({"source_event_id":int(eid),"page_index":pi,"representative":not representative,"position":{"x":int(ivar(event,"x",0)),"y":int(ivar(event,"y",0))},"sheet_path":path,"sheet_hash":h,"direction":int(ivar(g,"direction",2)),"pattern":int(ivar(g,"pattern",0))%4,"opacity":int(ivar(g,"opacity",255)),"blend_type":int(ivar(g,"blend_type",0)),"step_animation":bool(ivar(page,"step_anime",False)),"walk_animation":bool(ivar(page,"walk_anime",True)),"move_type":int(ivar(page,"move_type",0)),"move_speed":int(ivar(page,"move_speed",3)),"always_on_top":bool(ivar(page,"always_on_top",False))});representative=True
 return out
def patterns(p): return [0,1,2,3] if p["step_animation"] else [p["pattern"]]
def frame_length(p): return max(1,19-p["move_speed"]*3) if p["step_animation"] else 60
def grid_layer(name,rowdata,sheet,locs,counts):
 h=len(rowdata);w=len(rowdata[0]);cols=[]
 for x in range(w):
  col=[]
  for y in range(h):
   tid=rowdata[y][x];col.append(empty_cell() if not tid else visual_cell(sheet,locs[tid],20 if counts[tid]>1 else 60))
  cols.append(col)
 return {"Name":name,"Layer":0,"Visible":True,"Tiles":cols}
def repeating_layer(name,w,h,sheet,data):
 if not data:return None
 cols=[]
 for x in range(w):
  col=[]
  for y in range(h):
   ls=data["locations"][(x%data["width_cells"],y%data["height_cells"])]
   if isinstance(ls,tuple):ls=[ls]
   col.append(visual_cell(sheet,ls,data.get("frame_length_ticks",60)))
  cols.append(col)
 return {"Name":name,"Layer":0,"Visible":True,"Tiles":cols}
def event_tile_layer(w,h,placements,sheet,locs,counts):
 by={(p["position"]["x"],p["position"]["y"]):p for p in placements};
 if not by:return None
 cols=[]
 for x in range(w):
  col=[]
  for y in range(h):
   p=by.get((x,y))
   if not p:col.append(empty_cell())
   else:
    tid=p["graphic"]["tile_id"];col.append(visual_cell(sheet,locs[tid],20 if counts[tid]>1 else 60))
  cols.append(col)
 return {"Name":"Décors-tuiles source","Layer":0,"Visible":True,"Tiles":cols}
def env_layers(w,h,placements,sheet,atlas):
 result=[]
 for p in placements:
  g=atlas["geometry"][p["sheet_hash"]];cols=[[empty_cell() for _ in range(h)] for _ in range(w)]
  for gy in range(g["grid_y_min"],g["grid_y_max"]):
   for gx in range(g["grid_x_min"],g["grid_x_max"]):
    x=p["position"]["x"]+gx;y=p["position"]["y"]+gy
    if 0<=x<w and 0<=y<h:
     ls=[atlas["locations"][(p["sheet_hash"],p["opacity"],p["direction"],pat,gx,gy)] for pat in patterns(p)]
     cols[x][y]=visual_cell(sheet,ls,frame_length(p))
  result.append({"Name":f"Décor événement source {p['source_event_id']:04d}","Layer":0,"Visible":True,"Tiles":cols})
 return result
def obstacles(masks):
 h=len(masks);w=len(masks[0]);out=[]
 for x in range(w*2):
  col=[]
  for y in range(h*2):
   blocked=masks[y//2][x//2]!=15;col.append({"Bounds":{"X":x*8,"Y":y*8,"Width":8,"Height":8},"Tags":1 if blocked else 0})
  out.append(col)
 return out
def make_ground(asset,name,layers,masks,placements,status):
 unique={}
 for p in placements:unique.setdefault(p["source_event_id"],p)
 return {"Version":"0.8.9.0","Object":{"$type":"RogueEssence.Ground.GroundMap, RogueEssence","TexSize":2,"Name":{"DefaultText":name,"LocalTexts":{}},"Released":False,"Comment":f"Candidat BIBLIOTHEQUE Relict {status}; aucune promotion runtime, casting, dialogue, script ou audio.","obstacles":obstacles(masks),"rand":{"$type":"RogueElements.ReRandom, RogueElements","s":[0,0,0,0]},"Status":{},"Background":{"$type":"RogueEssence.Dungeon.MapBG, RogueEssence","MapLoc":{"X":0,"Y":0},"BGAnim":{"AnimIndex":"","FrameTime":1,"StartFrame":-1,"EndFrame":-1,"AnimDir":-1,"Alpha":255,"AnimFlip":0},"BGMovement":{"X":0,"Y":0},"Parallax":"0, 0","RepeatX":False,"RepeatY":False},"BlankBG":empty_cell(),"Layers":layers,"AssetName":asset,"Music":"","EdgeView":1,"NoSwitching":False,"ViewCenter":None,"ViewOffset":{"X":0,"Y":0},"ActiveChar":None,"Decorations":[{"Name":"Décor","Layer":0,"Visible":True,"Anims":[]}],"Entities":[{"Name":"Placements source expurgés","Visible":True,"MapChars":[],"GroundObjects":[],"Spawners":[],"Markers":[marker(i,p) for i,p in enumerate(unique.values())]}]}}
def render(w,h,layer_rows,tiles,envs,tile_images,sprite_atlas,panorama,fog,excluded):
 if excluded:return excluded_placeholder(w*16,h*16)
 canvas=RGBAImage.empty(w*16,h*16,(0,0,0,255))
 if panorama:
  for y in range(h):
   for x in range(w):canvas.alpha_over(panorama["images"][(x%panorama["width_cells"],y%panorama["height_cells"])],x*16,y*16)
 for rs in layer_rows:
  for y,row in enumerate(rs):
   for x,tid in enumerate(row):
    if tid:canvas.alpha_over(tile_images[tid],x*16,y*16)
 for p in tiles:canvas.alpha_over(tile_images[p["graphic"]["tile_id"]],p["position"]["x"]*16,p["position"]["y"]*16)
 for p in envs:
  g=sprite_atlas["geometry"][p["sheet_hash"]];im=sprite_atlas["images"][(p["sheet_hash"],p["opacity"],p["direction"],p["pattern"])]
  canvas.alpha_over(im,p["position"]["x"]*16+g["left_offset_px"],p["position"]["y"]*16+g["top_offset_px"])
 if fog:
  for y in range(h):
   for x in range(w):canvas.alpha_over(fog["images"][(x%fog["width_cells"],y%fog["height_cells"])],x*16,y*16)
 return canvas

def build(source,archive,output):
 source=source.resolve();archive=archive.resolve();output=output.resolve();shutil.rmtree(output,ignore_errors=True)
 for n in ("grounds","tiles","sidecars","previews"): (output/n).mkdir(parents=True,exist_ok=True)
 infos=load(source/"Data/MapInfos.rxdata");tilesets=load(source/"Data/Tilesets.rxdata");chars=character_sources(source)
 maps={};used=defaultdict(set);entities={};contexts={};representatives={};by_tileset=defaultdict(list);collisions={}
 for p in sorted((source/"Data").glob("Map[0-9][0-9][0-9].rxdata")):
  mid=int(p.stem[3:]);obj,tab=parse_map(p);ts=int(ivar(obj,"tileset_id",0));maps[mid]=(obj,tab,ts);used[ts].update(tab.values)
  ent,_=entity_placements(mid,ivar(obj,"events",{}) or {});ct=env_contexts(obj,chars);keys={(x["source_event_id"],x["page_index"]) for x in ct}
  for row in ent["placements"]:
   if (row["source_event_id"],row["page_index"]) in keys:row["classification"]="ENVIRONMENTAL_SPRITE_ENTITY"
  entities[mid]=ent;contexts[mid]=ct;representatives[mid]=[x for x in ct if x["representative"]];by_tileset[ts]+=representatives[mid]
  used[ts].update(x["graphic"]["tile_id"] for x in event_tiles(ent));t=tileset_tables(ts,tilesets[ts]);collisions[mid]=derived_collision(tab,t["passages"],t["priorities"],t["terrain_tags"])
 require(set(maps)=={int(x) for x in infos},"MapInfos mismatch");graphics=graphics_index(source);atlas_data={};atlas_rows=[]
 for ts in sorted(used):
  tileobj=tilesets[ts];desc=tileset_descriptor(ts,tileobj);deps=visual_dependencies(tileobj,source,graphics,"ARCHIVE_VERIFIED");renderer=TileRenderer(source,deps,desc);sheet=f"relict_tileset_{ts:03d}_Base"
  payloads={};entries=[];locs={};counts={};tile_images={}
  def add(im):
   payload=png_bytes(premultiply(im))
   if payload not in payloads:
    i=len(payloads);xy=(i%64,i//64);payloads[payload]=xy;entries.append((xy[0]|(xy[1]<<32),payload))
   return payloads[payload]
  for tid in sorted(used[ts]):
   if not tid:continue
   fc=1
   if tid<384:
    slot=tid//48-1
    if 0<=slot<len(renderer.autotiles):fc=renderer.animation_frame_count(renderer.autotiles[slot]) or 1
   ls=[]
   for f in range(fc):
    im=scale_nearest(renderer.tile(tid,f),16,16);ls.append(add(im));
    if f==0:tile_images[tid]=im
   locs[tid]=ls;counts[tid]=fc
  sprite={"locations":{},"images":{},"geometry":{}};cache={};unique=set()
  for p in by_tileset[ts]:
   h=p["sheet_hash"]
   if h not in cache:
    im=load_png(p["sheet_path"]);require(im.width%4==0 and im.height%4==0,"sprite matrix");cache[h]=im;sw=im.width//8;sh=im.height//8;left=8-sw//2;top=16-sh;sprite["geometry"][h]={"frame_dimensions_px":[sw,sh],"left_offset_px":left,"top_offset_px":top,"grid_x_min":left//16,"grid_x_max":(left+sw+15)//16,"grid_y_min":top//16,"grid_y_max":(top+sh+15)//16}
   for pat in patterns(p):unique.add((h,p["sheet_path"],p["opacity"],p["direction"],pat))
  dr={2:0,4:1,6:2,8:3}
  for h,path,opacity,direction,pat in sorted(unique,key=lambda x:(x[0],x[2],x[3],x[4])):
   src=cache[h];fw=src.width//4;fh=src.height//4;g=sprite["geometry"][h];sw,sh=g["frame_dimensions_px"];im=image_opacity(scale_nearest(src.crop(pat*fw,dr.get(direction,0)*fh,fw,fh),sw,sh),opacity);sprite["images"][(h,opacity,direction,pat)]=im
   for gy in range(g["grid_y_min"],g["grid_y_max"]):
    for gx in range(g["grid_x_min"],g["grid_x_max"]):
     cell=RGBAImage.empty(16,16);cell.blit_replace(im,g["left_offset_px"]-gx*16,g["top_offset_px"]-gy*16);sprite["locations"][(h,opacity,direction,pat,gx,gy)]=add(cell)
  pano=None;pdeps=[x for x in deps if x["kind"]=="PANORAMA" and x.get("resolved")]
  if pdeps:
   src=load_png(source/pdeps[0]["source_path"]);im=scale_nearest(src,max(1,src.width//2),max(1,src.height//2));wc=(im.width+15)//16;hc=(im.height+15)//16;pl={};pi={}
   for y in range(hc):
    for x in range(wc):
     cell=RGBAImage.empty(16,16);cw=min(16,im.width-x*16);ch=min(16,im.height-y*16);cell.blit_replace(im.crop(x*16,y*16,cw,ch),0,0);pl[(x,y)]=add(cell);pi[(x,y)]=cell
   pano={"width_cells":wc,"height_cells":hc,"locations":pl,"images":pi,"source_name":desc["panorama"]}
  fog=None;fdeps=[x for x in deps if x["kind"]=="FOG" and x.get("resolved")]
  if fdeps:
   opacity=int(ivar(tileobj,"fog_opacity",255));zoom=int(ivar(tileobj,"fog_zoom",100));fs,ds=load_fog(source/fdeps[0]["source_path"],zoom,opacity);require(len({(x.width,x.height) for x in fs})==1 and len(set(ds))==1,"fog frames");wc=(fs[0].width+15)//16;hc=(fs[0].height+15)//16;fl={};fi={}
   for y in range(hc):
    for x in range(wc):
     ls=[]
     for n,im in enumerate(fs):
      cell=RGBAImage.empty(16,16);cw=min(16,im.width-x*16);ch=min(16,im.height-y*16);cell.blit_replace(im.crop(x*16,y*16,cw,ch),0,0);ls.append(add(cell));
      if n==0:fi[(x,y)]=cell
     fl[(x,y)]=ls
   ticks=ds[0]*60/1000;fog={"width_cells":wc,"height_cells":hc,"locations":fl,"images":fi,"source_name":desc["fog"],"frame_count":len(fs),"source_frame_duration_ms":ds[0],"frame_length_ticks":max(1,round(ticks)) if len(fs)>1 else 60,"timing_exact_at_60hz":ticks.is_integer(),"opacity":opacity,"zoom_percent":zoom,"blend_type":int(ivar(tileobj,"fog_blend_type",0)),"scroll_x":int(ivar(tileobj,"fog_sx",0)),"scroll_y":int(ivar(tileobj,"fog_sy",0))}
  tilepath=output/"tiles"/f"{sheet}.tile";write_tile(tilepath,16,entries);unresolved=[{"kind":x["kind"],"source_name":x["source_name"]} for x in deps if not x.get("resolved")]
  atlas_data[ts]={"sheet":sheet,"locations":locs,"frame_counts":counts,"images":tile_images,"environment_sprites":sprite,"panorama":pano,"fog":fog,"fog_name":desc["fog"],"missing_tile_ids":sorted(renderer.missing_ids),"unresolved_dependencies":unresolved}
  atlas_rows.append({"tileset_id":ts,"sheet":sheet,"file":tilepath.relative_to(output).as_posix(),"sha256":sha256_file(tilepath),"size_bytes":tilepath.stat().st_size,"used_tile_id_count":len(used[ts]-{0}),"atlas_payload_count":len(payloads),"panorama_source_name":desc["panorama"] or None,"fog_source_name":desc["fog"] or None,"fog_frame_count":fog["frame_count"] if fog else 0,"environment_sprite_sheet_count":len(sprite["geometry"]),"environment_sprite_payload_count":len(sprite["locations"]),"missing_tile_ids":sorted(renderer.missing_ids),"unresolved_dependencies":unresolved})
 exclusions={};results=[];status_counts=defaultdict(int)
 for mid,(obj,tab,ts) in sorted(maps.items()):
  name=decode_text(ivar(infos[mid],"name",f"Map {mid:03d}"));atlas=atlas_data[ts];ent=entities[mid];envs=representatives[mid];ctx=contexts[mid];layer_rows=[rows(tab,z) for z in range(tab.z_size)];collision=collisions[mid];partial=sorted({v for r in collision["allowed_direction_masks"] for v in r if v not in (0,15)});excluded=mid in exclusions;missing=sorted(set(atlas["missing_tile_ids"])&set(tab.values));unresolved=atlas["unresolved_dependencies"];envadapt=any(x["move_type"]!=0 or x["blend_type"]!=0 for x in ctx)
  status="UNSUPPORTED" if excluded else "ADAPTATION_REQUIRED" if missing or unresolved or partial or atlas["fog_name"] or envadapt else "PMDO_CONVERTED";status_counts[status]+=1;asset=f"relict_map_{mid:03d}";layers=[]
  if excluded:layers=[grid_layer("Scène source expurgée",[[0]*tab.x_size for _ in range(tab.y_size)],atlas["sheet"],{}, {})]
  else:
   p=repeating_layer("Panorama source",tab.x_size,tab.y_size,atlas["sheet"],atlas["panorama"])
   if p:layers.append(p)
   layers += [grid_layer(f"Couche source {z}",rs,atlas["sheet"],atlas["locations"],atlas["frame_counts"]) for z,rs in enumerate(layer_rows)]
   e=event_tile_layer(tab.x_size,tab.y_size,event_tiles(ent),atlas["sheet"],atlas["locations"],atlas["frame_counts"])
   if e:layers.append(e)
   layers += env_layers(tab.x_size,tab.y_size,envs,atlas["sheet"],atlas["environment_sprites"])
   f=repeating_layer("Fog source matérialisé",tab.x_size,tab.y_size,atlas["sheet"],atlas["fog"])
   if f:layers.append(f)
  ground=make_ground(asset,name,layers,collision["allowed_direction_masks"],ent["placements"],status);gp=output/"grounds"/f"{asset}.rsground";compact(gp,ground,True)
  side={"schema_version":"1.0.0","map_id":mid,"source_name":name,"status":status,"source_geometry":{"width_tiles":tab.x_size,"height_tiles":tab.y_size,"tile_size_px":32,"viewport_px":[640,480]},"pmdo_geometry":{"width_cells":tab.x_size,"height_cells":tab.y_size,"tile_size_px":16,"tex_size":2,"width_px":tab.x_size*16,"height_px":tab.y_size*16,"viewport_px":[320,240],"source_scale":[1,2]},"collision":collision,"entities":ent,"environment_sprite_entities":[{k:v for k,v in x.items() if k!="sheet_path"} for x in ctx],"environment_sprite_policy":"HASH_REVIEWED_NON_CASTING_PIXELS_MATERIALIZED; MOVEMENT_OR_NON_NORMAL_BLEND_REQUIRES_ADAPTATION","partial_direction_masks":partial,"partial_collision_policy":"CONSERVATIVE_FULL_BLOCK_IN_GROUND_EXACT_MASK_IN_SIDECAR","missing_tile_ids":missing,"unresolved_dependencies":unresolved,"panorama_converted":atlas["panorama"] is not None,"fog_name":atlas["fog_name"],"fog_materialized":atlas["fog"] is not None,"fog_properties":({k:v for k,v in atlas["fog"].items() if k not in ("locations","images")} if atlas["fog"] else None),"fog_status":"ADAPTATION_REQUIRED" if atlas["fog_name"] else "NOT_USED","fog_adaptation_notes":"Pixels, opacity and zoom materialized; scroll, blend and non-integral timing remain sidecar-authoritative." if atlas["fog_name"] else None,"excluded_visual_scene":exclusions.get(mid)};sp=output/"sidecars"/f"map_{mid:03d}.json";compact(sp,side)
  preview=render(tab.x_size,tab.y_size,layer_rows,event_tiles(ent),envs,atlas["images"],atlas["environment_sprites"],atlas["panorama"],atlas["fog"],excluded);pp=output/"previews"/f"map_{mid:03d}.png";save_png(preview,pp)
  results.append({"map_id":mid,"source_name":name,"status":status,"ground":gp.relative_to(output).as_posix(),"ground_sha256":sha256_file(gp),"sidecar":sp.relative_to(output).as_posix(),"sidecar_sha256":sha256_file(sp),"preview":pp.relative_to(output).as_posix(),"preview_sha256":sha256_file(pp),"source_dimensions_px":[tab.x_size*32,tab.y_size*32],"pmdo_dimensions_px":[tab.x_size*16,tab.y_size*16],"default_viewport_exact_fit":tab.x_size*16==320 and tab.y_size*16==240,"partial_direction_masks":partial,"missing_tile_ids":missing,"unresolved_dependencies":unresolved,"panorama_converted":atlas["panorama"] is not None,"fog_name":atlas["fog_name"],"fog_materialized":atlas["fog"] is not None,"environment_sprite_entity_count":len(envs),"environment_sprite_page_context_count":len(ctx),"environment_sprite_adaptation":envadapt})
 sheet,pages=contact_outputs(output,[{"map_id":x["map_id"],"file":x["preview"]} for x in results]);bundle=output/"relict_grounds.zip";count=deterministic_zip(output/"grounds",bundle);shutil.rmtree(output/"grounds")
 report={"schema_version":"1.0.0","result":"RELICT_PMDO_CONVERSION_PASS","source_authority":{"file":archive.name,"sha256":sha256_file(archive),"size_bytes":archive.stat().st_size,"source_code_executed":False},"viewport_contract":{"source_viewport_px":[640,480],"pmdo_viewport_px":[320,240],"source_tile_size_px":32,"pmdo_tile_size_px":16,"pmdo_tex_size":2,"pmdo_collision_size_px":8,"scale":[1,2],"edge_view":1},"autotile_timing":{"source_graphics_fps":40,"frame_length_ticks":15,"frame_duration_ms":250},"map_count":len(results),"status_counts":dict(sorted(status_counts.items())),"default_viewport_exact_fit_count":sum(x["default_viewport_exact_fit"] for x in results),"panorama_converted_map_count":sum(x["panorama_converted"] for x in results),"fog_adaptation_required_map_count":sum(bool(x["fog_name"]) for x in results),"fog_materialized_map_count":sum(x["fog_materialized"] for x in results),"environment_sprite_entity_count":sum(x["environment_sprite_entity_count"] for x in results),"environment_sprite_page_context_count":sum(x["environment_sprite_page_context_count"] for x in results),"environment_sprite_map_count":sum(bool(x["environment_sprite_entity_count"]) for x in results),"environment_sprite_adaptation_map_count":sum(x["environment_sprite_adaptation"] for x in results),"atlas_count":len(atlas_rows),"atlases":atlas_rows,"ground_storage":{"format":"DETERMINISTIC_ZIP_OF_RSGROUND_FILES","file":bundle.name,"sha256":sha256_file(bundle),"size_bytes":bundle.stat().st_size,"ground_count":count,"extraction_required_before_runtime_validation":True},"contact_sheet":sheet,"contact_pages":pages,"runtime_destination_written":False,"forbidden_content_check":{"runtime_ground_written":False,"runtime_tile_written":False,"casting_pixels_exported":False,"dialogue_exported":False,"script_body_exported":False,"audio_binary_exported":False},"maps":results};compact(output/"conversion_report.json",report);return report

def main():
 p=argparse.ArgumentParser();p.add_argument("--source",type=Path,required=True);p.add_argument("--archive",type=Path,required=True);p.add_argument("--output",type=Path,required=True);a=p.parse_args();r=build(a.source,a.archive,a.output);print(json.dumps({"result":r["result"],"map_count":r["map_count"],"atlas_count":r["atlas_count"],"exact_viewport_fit":r["default_viewport_exact_fit_count"],"status_counts":r["status_counts"]},sort_keys=True));return 0
if __name__=="__main__":raise SystemExit(main())
