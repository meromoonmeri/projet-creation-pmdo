#!/usr/bin/env python3
"""Extract redacted Nova environmental timelines, assets and animations."""
from __future__ import annotations
import argparse,colorsys,json,re,shutil
from collections import Counter,defaultdict
from pathlib import Path
from typing import Any
from extract_relict_environmental_vfx import common_event_timelines,extract_gif_frames,map_timeline,resolve_asset
from inventory_relict import decode_text,ivar,load,parse_map,sha256_bytes,sha256_file,write_json
from png_rgba import RGBAImage,load_png,save_png
from nova_environment_policy import ENVIRONMENT_CHARACTER_SHEET_HASHES
from render_pmdo_final_maps import additive_over,scale_nearest
from ruby_marshal import RubyObject,decode_table
FPS=40;FRAME_MS=50;COMMIT="6963878956ec4c53833c03f26aa6a9aafd17800f"
INCLUDED_PICTURES={
"5f3f3b44dc0554d7db961876c1005226ac2820eb12c016acfdc22682fb78f91b","7eea50d6499cc06aad5eb92512d29004ea9013e5ff67b1d46759c93643b970aa","a857599072608a0106b0c469a8daa7695bd2d918f984fa01be35da12d5e808f5","dc2e653792a422cb1a0fcd64d6dc4bfe1f351cf331d2a91bdb390495349c6dfe","106b1e208ead9fc96aef2318cd887b1dda60ae791e474c437796ad7499556536","1ad00bc376a5ea3c1f1f18f30af577f284357135b7a31951d59290511f667b8e","095e0f78fe7c981dbc64bb56d5310ef802e2bdb8324683ecf8841a602c72eb08","70d3448bbb853d05706457120ac73249d7c7609992c5764fd2e94289a6f05d20","b0e7a0826d62414967948a19ea84e8ebee39f713c17eb66edbb03a16293e65e8","6187e807779f9766396fdc06512b0fcee904662c7b7710642b5e2c2a574f88ef","68ffbe233a39ff592eef17394ab27205eae47c4a8889b9e679cc403d1af1c9ae","728a8c28726d2fca278cb4749792261c2df8fd431cc8e4a6d1dc5ce3dceea6c8","6dc7876f1f0c8cc407a74d902557e6b3a812eda4abd767cca91d8f48c6777b19","cf1fbc0c46db286e86cb37e18610cb9965eede35969f86c5f5062e7401f37268","39024795eff811f41eb245c8e2060296eebf5c92d7060ae854f37f044469e7d1","d6b8843fefc28a18f40808a08ab366c118fd2bf0bc32860f54b4aa3e3e875f69","f5604f121b08f900c4527865dfbe428bd74cb1762551257d854ec97182515957","ad3cda9bca667e5349bc37f6779a8da4b2564c6a22e73662a777645c63c70b83","991e68ad1d07b375faa43f3851cd4445f1b859c73f76d7134208521a0eaff2f9","b80bc1faa1a7330bb20ab77b0cbf1e15e80342c77bba55d935f78734a638980a","4db3162b6cbd85598bbeae993017632fecf72ab974b0a23bfc1f1089243ee834","0baced00faffb8f156d1d3fb60b1a95c01dcb2437c64c8be07dc4e1500750610","a63995717e17c5c5f2988ead8e9b13154a5b3a5d657c306fafba9932c36a37c5","77cc25cfba4e64b6a73a346938f9dd174fad8aff5fef5be4e681b5abebc3b38b","361cbe35590266c12d9a34c5ccc24493b4e7b518f811d3a80085d8893602c5ef","e13507ea50ce97b3cbc9d261eb700f636f92d3fb78cc912dd6cd0b01bb3f2aa2","c9924fde9fe26028461bb6c50c5df1144594c54403599acb191d6f2bf71ce2ee","9c3df290696ca9bf5a9f56fe5912fc82e712364fcd46209c630df9722c4171b6","b8d287ffa331a577f2ee3a098b2e73d8ad4fca4dc16cd2c600c242f93085d592","85460208e63001639f3461f38401f31dba567ed222a56796dee52ec5ea2cf233","dd5f995a5f041972fc08eceb6ed8e9bc5fbbf81496faf0a92d6f7f215a4802af"}
def req(v,m):
 if not v:raise ValueError(m)
def slug(s):return re.sub(r"[^a-z0-9]+","_",s.casefold()).strip("_") or "asset"
def timing(payload):
 payload["timing"]={"source_unit":"Graphics frames","nominal_frame_rate":40,"nominal_frame_duration_ms":25,"authority":"RGSS event update authority: 40 Hz","branching_note":"wait durations are exact per command; do not sum branches"}
 for seq in payload.get("sequences",[]):
  for c in seq["timeline"]:
   if c["category"]=="wait":
    n=c["parameters"]["frames"];c["parameters"]={"frames":n,"nominal_ms_at_source_40fps":n*25}
   if c["category"]=="script_visual_candidate_review":
    d=c["parameters"]["source_block_sha256"][:12];safe={"4ac28816c64e":["Fire",9.0,20],"cd5ee55b8301":["Ash",9.0,20],"90ed5880395b":[2,100,466]}.get(d)
    if safe:c["category"]="script_visual_block";c["parameters"]["category"]="script_visual_block";c["parameters"]["calls"]=[{"call":"weather" if isinstance(safe[0],str) else "change_map_weather","safe_parameters":safe}]
def contact(images,out):
 cell=128;cols=min(8,len(images));rows=(len(images)+cols-1)//cols;dst=RGBAImage.empty(cols*cell,rows*cell,(24,24,24,255))
 for i,im in enumerate(images):
  f=min(cell/im.width,cell/im.height);w=max(1,round(im.width*f));h=max(1,round(im.height*f));thumb=scale_nearest(im,w,h);dst.alpha_over(thumb,i%cols*cell+(cell-w)//2,i//cols*cell+(cell-h)//2)
 save_png(dst,out);return {"file":out.name,"sha256":sha256_file(out),"dimensions_px":[dst.width,dst.height]}
def static_refs(source,maps):
 tilesets=load(source/"Data/Tilesets.rxdata");usage=defaultdict(list)
 for mid,m in maps.items():usage[int(ivar(m,"tileset_id",0))].append(mid)
 out=[]
 for ts,mids in usage.items():
  t=tilesets[ts]
  for kind,directory,field in (("PANORAMA","Panoramas","panorama_name"),("FOG","Fogs","fog_name")):
   name=decode_text(ivar(t,field,""))
   if name:out.append({"kind":kind,"directory":directory,"name":name,"source":"TILESET_DEFAULT","tileset_id":ts,"map_ids":sorted(mids),"hue":int(ivar(t,"fog_hue" if kind=="FOG" else "panorama_hue",0)),"opacity":int(ivar(t,"fog_opacity",255)) if kind=="FOG" else 255,"blend_type":int(ivar(t,"fog_blend_type",0)) if kind=="FOG" else 0,"zoom_percent":int(ivar(t,"fog_zoom",100)) if kind=="FOG" else 100,"scroll_x":int(ivar(t,"fog_sx",0)) if kind=="FOG" else 0,"scroll_y":int(ivar(t,"fog_sy",0)) if kind=="FOG" else 0})
 return out
def signed(v):return v-65536 if v>=32768 else v
def cells(frame):
 t=decode_table(ivar(frame,"cell_data"));out=[]
 for i in range(t.x_size):
  v=[t.values[i+a*t.x_size] for a in range(8)];pat=signed(v[0])
  if pat>=0:out.append({"source_cell_index":i,"pattern":pat,"x":signed(v[1]),"y":signed(v[2]),"zoom_percent":v[3],"angle_degrees":signed(v[4]),"mirror":bool(v[5]),"opacity":v[6],"blend_type":v[7]})
 return out
def hue(im,degrees):
 if not degrees%360:return im
 out=RGBAImage(im.width,im.height,bytearray(im.pixels));shift=degrees/360
 for i in range(0,len(out.pixels),4):
  if not out.pixels[i+3]:continue
  r,g,b=(out.pixels[i+j]/255 for j in range(3));h,s,v=colorsys.rgb_to_hsv(r,g,b);r,g,b=colorsys.hsv_to_rgb((h+shift)%1,s,v);out.pixels[i:i+3]=bytes((round(r*255),round(g*255),round(b*255)))
 return out
def opacity(im,value):
 out=RGBAImage(im.width,im.height,bytearray(im.pixels))
 for i in range(3,len(out.pixels),4):out.pixels[i]=(out.pixels[i]*value+127)//255
 return out
def used_animations(maps,common):
 out=defaultdict(Counter)
 def scan(rows,ctx):
  scripts=[]
  for c in rows:
   if not isinstance(c,RubyObject):continue
   code=int(ivar(c,"code",0));p=ivar(c,"parameters",[]) or []
   if code==207 and len(p)>1:out[int(p[1])][ctx]+=1
   if code in (355,655) and p:scripts.append(decode_text(p[0]))
  for x in re.findall(r"addUserAnimation\s*\(\s*(\d+)","\n".join(scripts)):out[int(x)][ctx+"_script"]+=1
 for mid,m in maps.items():
  for e in (ivar(m,"events",{}) or {}).values():
   for p in ivar(e,"pages",[]) or []:scan(ivar(p,"list",[]) or [],f"map_{mid:03d}")
 for i,e in enumerate(common):
  if isinstance(e,RubyObject):scan(ivar(e,"list",[]) or [],f"common_event_{i:03d}")
 return {k:dict(v) for k,v in sorted(out.items())}
def render_animation(aid,a,source,dest,usage):
 name=decode_text(ivar(a,"animation_name",""));path=resolve_asset(source,"Animations",name);req(path,"animation sheet missing");sheet=hue(load_png(path),int(ivar(a,"animation_hue",0)));fc=[cells(x) for x in ivar(a,"frames",[]) or []];ext=[]
 for cs in fc:
  for c in cs:
   n=max(1,round(192*c["zoom_percent"]/100));ext.append((c["x"]-n//2,c["y"]-n//2,c["x"]-n//2+n,c["y"]-n//2+n))
 minx=min((x[0] for x in ext),default=-96);miny=min((x[1] for x in ext),default=-96);maxx=max((x[2] for x in ext),default=96);maxy=max((x[3] for x in ext),default=96);w=maxx-minx;h=maxy-miny;dest.mkdir(parents=True,exist_ok=True);frames=[];ims=[];adds=0
 for fi,cs in enumerate(fc):
  canvas=RGBAImage.empty(w,h)
  for c in cs:
   pat=c["pattern"];sprite=sheet.crop(pat%5*192,pat//5*192,192,192);n=max(1,round(192*c["zoom_percent"]/100));sprite=scale_nearest(sprite,n,n) if n!=192 else sprite
   if c["mirror"]:
    tmp=RGBAImage.empty(n,n)
    for y in range(n):
     for x in range(n):tmp.pixels[(y*n+x)*4:(y*n+x)*4+4]=sprite.pixels[(y*n+n-1-x)*4:(y*n+n-1-x)*4+4]
    sprite=tmp
   req(c["angle_degrees"]==0,"rotation unsupported");sprite=opacity(sprite,c["opacity"]);x=c["x"]-n//2-minx;y=c["y"]-n//2-miny
   if c["blend_type"]==1:additive_over(canvas,sprite,x,y);adds+=1
   else:req(c["blend_type"]==0,"subtractive blend");canvas.alpha_over(sprite,x,y)
  fp=dest/f"frame_{fi:03d}.png";save_png(canvas,fp);ims.append(canvas);frames.append({"index":fi,"file":fp.name,"sha256":sha256_file(fp),"duration_ms":FRAME_MS,"cells":cs})
 timings=[]
 for t in ivar(a,"timings",[]) or []:
  se=ivar(t,"se");sn=decode_text(ivar(se,"name","")) if isinstance(se,RubyObject) else "";co=ivar(t,"flash_color");timings.append({"frame":int(ivar(t,"frame",0)),"flash_scope":int(ivar(t,"flash_scope",0)),"flash_color":{"red":ivar(co,"red",0),"green":ivar(co,"green",0),"blue":ivar(co,"blue",0),"alpha":ivar(co,"alpha",0)},"flash_duration_frames":int(ivar(t,"flash_duration",0)),"condition":int(ivar(t,"condition",0)),"audio_exported":False,"audio_identity_sha256":sha256_bytes(sn.encode()) if sn else None})
 meta={"schema_version":"1.0.0","animation_id":f"nova_rgss_animation_{aid:03d}","source_animation_id":aid,"source_name_sha256":sha256_bytes(decode_text(ivar(a,"name","")).encode()),"status":"SOURCE_DOCUMENTED","usage":usage,"position_mode":int(ivar(a,"position",1)),"frame_count":len(frames),"loop":False,"source_frame_duration_ms":FRAME_MS,"timing_authority":{"frames_per_second":20,"script":"Data/Scripts/005_Sprites/008_Sprite_AnimationSprite.rb","script_sha256":sha256_file(source/"Data/Scripts/005_Sprites/008_Sprite_AnimationSprite.rb")},"canvas":{"dimensions_px":[w,h],"origin_px":[-minx,-miny],"pmdo_scale":[1,2]},"source_sheet":{"identity_sha256":sha256_bytes(name.encode()),"source_sha256":sha256_file(path),"dimensions_px":[sheet.width,sheet.height],"hue_degrees":int(ivar(a,"animation_hue",0)),"pixels_exported_only_as_composed_frames":True},"blend_modes":{"0":"NORMAL_ALPHA","1":"ADDITIVE"},"additive_cell_render_count":adds,"frames":frames,"timings":timings,"contact_sheet":contact(ims,dest/"contact_sheet.png"),"audio_exported":False,"casting_sprites_exported":False};write_json(dest/"metadata.json",meta);return {"source_animation_id":aid,"file":"metadata.json","metadata_sha256":sha256_file(dest/"metadata.json"),"frame_count":len(frames),"status":"SOURCE_DOCUMENTED"}
def entity_sprites(source,game,maps):
 grouped=defaultdict(list);allnames=set()
 for mid,m in maps.items():
  for eid,e in (ivar(m,"events",{}) or {}).items():
   for pi,p in enumerate(ivar(e,"pages",[]) or []):
    g=ivar(p,"graphic");name=decode_text(ivar(g,"character_name",""))
    if not name:continue
    allnames.add(name);grouped[name].append({"map_id":mid,"source_event_id":int(eid),"page_index":pi,"position":{"x":int(ivar(e,"x",0)),"y":int(ivar(e,"y",0))},"direction":int(ivar(g,"direction",2)),"pattern":int(ivar(g,"pattern",0)),"opacity":int(ivar(g,"opacity",255)),"blend_type":int(ivar(g,"blend_type",0)),"move_type":int(ivar(p,"move_type",0)),"move_speed":int(ivar(p,"move_speed",3)),"move_frequency":int(ivar(p,"move_frequency",3)),"walk_animation":bool(ivar(p,"walk_anime",True)),"step_animation":bool(ivar(p,"step_anime",False))})
 rows=[];included=0;excluded=0
 for name,contexts in sorted(grouped.items()):
  path=resolve_asset(source,"Characters",name)
  if not path or sha256_file(path) not in ENVIRONMENT_CHARACTER_SHEET_HASHES:excluded+=1;continue
  im=load_png(path);req(im.width%4==0 and im.height%4==0,"entity matrix");fw=im.width//4;fh=im.height//4;hsh=sha256_file(path);dest=game/"vfx/entity_sprites"/f"nova_environment_entity_{hsh[:12]}";frames=[];ims=[]
  for ri,direction in enumerate((2,4,6,8)):
   for pat in range(4):
    fr=im.crop(pat*fw,ri*fh,fw,fh);fp=dest/f"direction_{direction}_pattern_{pat}.png";save_png(fr,fp);ims.append(fr);frames.append({"direction":direction,"pattern":pat,"file":fp.name,"sha256":sha256_file(fp)})
  meta={"schema_version":"1.0.0","asset_id":dest.name,"kind":"ENVIRONMENT_ENTITY_SPRITE","status":"SOURCE_DOCUMENTED","source_name":name,"source_sha256":hsh,"source_dimensions_px":[im.width,im.height],"frame_dimensions_px":[fw,fh],"directions":[2,4,6,8],"patterns":[0,1,2,3],"frames":frames,"contexts":contexts,"animation_timing":{"formula":"pattern_time = pattern_update_speed / 4 seconds","timing_unit":"System.uptime seconds","authority_sha256":sha256_file(source/"Data/Scripts/004_Game classes/006_Game_Character.rb"),"context_dependent":True},"pmdo_scale":[1,2],"contact_sheet":contact(ims,dest/"contact_sheet.png"),"casting_pixels_exported":False};write_json(dest/"metadata.json",meta);included+=len(contexts);rows.append({"asset_id":dest.name,"source_sha256":hsh,"file":(dest/"metadata.json").relative_to(game).as_posix(),"metadata_sha256":sha256_file(dest/"metadata.json"),"context_count":len(contexts),"frame_count":16})
 return rows,included,excluded
def build(source,game):
 source=source.resolve();game=game.resolve();vfx=game/"vfx";anims=game/"animations"
 for p in (vfx,anims):shutil.rmtree(p,ignore_errors=True);p.mkdir(parents=True)
 maps={};refs=[];timeline_rows=[];counts=Counter();review=0
 for p in sorted((source/"Data").glob("Map[0-9][0-9][0-9].rxdata")):
  mid=int(p.stem[3:]);m,_=parse_map(p);maps[mid]=m;payload,r=map_timeline(mid,m,None);timing(payload)
  for s in payload["sequences"]:
   for c in s["timeline"]:counts[c["category"]]+=1;review+=c["category"]=="script_visual_candidate_review"
  target=vfx/"timelines/maps"/f"map_{mid:03d}.json";write_json(target,payload);timeline_rows.append({"map_id":mid,"file":target.relative_to(game).as_posix(),"sha256":sha256_file(target),"sequence_count":payload["sequence_count"]});refs+=r
 common=load(source/"Data/CommonEvents.rxdata");cp,cr=common_event_timelines(source)
 for e in cp["events"]:
  wrap={"sequences":[{"timeline":e["timeline"]}]};timing(wrap);e["timing"]=wrap["timing"]
  for c in e["timeline"]:counts[c["category"]]+=1;review+=c["category"]=="script_visual_candidate_review"
 cpath=vfx/"timelines/common_events.json";write_json(cpath,cp);refs+=cr;refs+=static_refs(source,maps);group=defaultdict(list)
 for r in refs:
  key=(r["kind"],r["directory"],r["name"]);group[key].append({k:v for k,v in r.items() if k not in ("kind","directory","name")})
 assets=[];excluded=[];unresolved=[];animated=0
 for (kind,directory,name),contexts in sorted(group.items()):
  path=resolve_asset(source,directory,name)
  if not path:unresolved.append({"kind":kind,"source_identity_sha256":sha256_bytes(name.encode()),"contexts":contexts,"status":"UNSUPPORTED"});continue
  h=sha256_file(path)
  if kind=="PICTURE_REVIEW" and h not in INCLUDED_PICTURES:excluded.append({"kind":"PICTURE","source_identity_sha256":sha256_bytes(name.encode()),"source_sha256":h,"contexts":contexts,"pixels_exported":False,"status":"EXCLUDED_CAST_OR_UI"});continue
  if kind=="PICTURE_REVIEW":kind="ENVIRONMENT_OVERLAY"
  aid=f"nova_{slug(kind)}_{slug(name)}_{h[:12]}"
  if path.suffix.casefold()==".gif":
   animated+=1;dest=vfx/"animations"/aid;frames,gif=extract_gif_frames(path,dest);out=dest/"metadata.json";write_json(out,{"schema_version":"1.0.0","asset_id":aid,"kind":kind,"status":"SOURCE_DOCUMENTED","frame_count":len(frames),"frames":frames,"loop":gif["loop"],"loop_count":gif["loop_count"],"timing_authority":"GIF_GRAPHIC_CONTROL_EXTENSION","contexts":contexts,"source_sha256":h,"source_dimensions_preserved":True,"pmdo_scale":[1,2],"contact_sheet":{"file":gif["contact_sheet"].relative_to(dest).as_posix(),"sha256":sha256_file(gif["contact_sheet"])}})
  else:im=load_png(path);out=vfx/"assets"/slug(kind)/f"{aid}.png";save_png(im,out)
  assets.append({"asset_id":aid,"kind":kind,"source_name":name,"source_sha256":h,"contexts":contexts,"output":out.relative_to(game).as_posix(),"output_sha256":sha256_file(out),"status":"SOURCE_DOCUMENTED"})
 contact_images=[]
 for r in assets:
  out=game/r["output"]
  if out.suffix==".png":contact_images.append(load_png(out))
  else:
   m=json.loads(out.read_text());contact_images.append(load_png(out.parent/m["frames"][0]["file"]))
 envcontact=contact(contact_images,vfx/"contact_sheet.png");entity_rows,entity_contexts,excluded_sheets=entity_sprites(source,game,maps);used=used_animations(maps,common);adata=load(source/"Data/Animations.rxdata");arows=[]
 for aid,usage in used.items():
  dest=anims/f"nova_rgss_animation_{aid:03d}";row=render_animation(aid,adata[aid],source,dest,usage);row["file"]=(dest/"metadata.json").relative_to(game).as_posix();arows.append(row)
 aman={"schema_version":"1.0.0","result":"NOVA_USED_ANIMATIONS_EXTRACTED","animation_count":len(arows),"total_frame_count":sum(x["frame_count"] for x in arows),"frame_duration_ms":FRAME_MS,"animations":arows};write_json(anims/"manifest.json",aman)
 manifest={"schema_version":"1.0.0","result":"NOVA_ENVIRONMENTAL_VFX_AUDIT_PASS","source_commit":COMMIT,"map_timeline_count":len(timeline_rows),"common_event_timeline_count":cp["event_count"],"visual_command_counts":dict(sorted(counts.items())),"static_script_visual_audit_required_count":review,"environment_asset_count":len(assets),"animated_environment_asset_count":animated,"included_environmental_picture_count":sum(x["kind"]=="ENVIRONMENT_OVERLAY" for x in assets),"excluded_cast_or_ui_picture_count":len(excluded),"unresolved_environment_count":len(unresolved),"used_rgss_animation_count":len(arows),"used_rgss_animation_frame_count":aman["total_frame_count"],"environment_entity_sprite_sheet_count":len(entity_rows),"environment_entity_sprite_context_count":entity_contexts,"excluded_character_sheet_count":excluded_sheets,"environment_entity_sprites":entity_rows,"dialogue_contents_exported":False,"script_bodies_exported":False,"casting_pixels_exported":False,"timing_authorities":{"event_fps":40,"settings_sha256":sha256_file(source/"Data/Scripts/001_Settings.rb"),"animation_script_sha256":sha256_file(source/"Data/Scripts/005_Sprites/008_Sprite_AnimationSprite.rb")},"timelines":timeline_rows,"common_events":{"file":cpath.relative_to(game).as_posix(),"sha256":sha256_file(cpath)},"environment_assets":assets,"environment_contact_sheet":envcontact,"excluded_assets":excluded,"unresolved_assets":unresolved,"animations":{"file":(anims/"manifest.json").relative_to(game).as_posix(),"sha256":sha256_file(anims/"manifest.json")}}
 req(review==0 and not unresolved,"unresolved visual audit");req(len(assets)+len(excluded)==len(group),"classification mismatch");write_json(vfx/"manifest.json",manifest);(vfx/"README.md").write_text("# VFX environnementaux Nova\n\nTimelines, fogs, panoramas, Pictures et animations expurgés.\n",encoding="utf-8");return manifest
def main():
 p=argparse.ArgumentParser();p.add_argument("--source",type=Path,required=True);p.add_argument("--game-root",type=Path,required=True);a=p.parse_args();r=build(a.source,a.game_root);print(json.dumps({k:r[k] for k in ("result","map_timeline_count","environment_asset_count","animated_environment_asset_count","included_environmental_picture_count","excluded_cast_or_ui_picture_count","used_rgss_animation_count","used_rgss_animation_frame_count","environment_entity_sprite_sheet_count","environment_entity_sprite_context_count","unresolved_environment_count")},sort_keys=True));return 0
if __name__=="__main__":raise SystemExit(main())
