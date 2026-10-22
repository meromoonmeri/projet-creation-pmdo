#!/usr/bin/env python3
"""Compile exact tracked NNV particle sprite payloads for the winter adapter.

This compiles graphics only. It does not claim that GameMaker particle physics,
footprints, sound timing, or PMDO emitter equivalence are complete.
"""
from __future__ import annotations
import argparse,hashlib,json,struct,sys
from pathlib import Path

HERE=Path(__file__).resolve();REPO=HERE.parents[2]
sys.path.insert(0,str(HERE.parent))
sys.path.insert(0,str(REPO/'PMU_ADAPTATION/src'));sys.path.insert(0,str(REPO/'PMU_EXTRACTION/src'));sys.path.insert(0,str(REPO/'tools'))
try:from PIL import Image
except ImportError as exc:raise SystemExit('Pillow missing; install requirements-conversion.lock') from exc
from convert_environment_room import OfficialTiles,ensure_texture_cache,read_gzip,file_sha,canonical_sha
from pmu_adaptation.composer import _png_bytes

SPRITES={
 'NNV_Snow_Sprite_1':2255,
 'NNV_Snow_Sprite_2':2562,
 'NNV_Snow_Footprint_Trail':2500,
}

def write_dir(path:Path,tiles:OfficialTiles,index:int)->dict:
 sprite=tiles.sprites[index];textures=sprite.get('Textures') or []
 if not textures:raise ValueError(f"source sprite {index} has no frames")
 frames=[tiles.sprite(index,frame) for frame in range(len(textures))]
 width,height=int(sprite['Width']),int(sprite['Height']);sheet=Image.new('RGBA',(width*len(frames),height),(0,0,0,0))
 for frame,image in enumerate(frames):sheet.alpha_composite(image,(frame*width,0))
 png=_png_bytes(sheet);loc_height=height-int(sprite['OriginY'])
 path.parent.mkdir(parents=True,exist_ok=True);path.write_bytes(struct.pack('<II',len(png),0)+png+struct.pack('<IIII',width,height,loc_height,len(frames)))
 return {'source_sprite_index':index,'source_sprite_name':sprite['Name'],'source_dimensions':[width,height],
  'source_origin':[int(sprite['OriginX']),int(sprite['OriginY'])],'frame_count':len(frames),'loc_height':loc_height,
  'output':str(path),'output_sha256':file_sha(path),'pixel_transform':'identity_1_to_1'}

def build(repo:Path,extracted:Path,textures:Path,output:Path)->dict:
 evidence=json.loads((repo/'NO_NAME_VILLAGE_ADAPTATION/reports/season-vm-evidence.json').read_text())
 if evidence.get('status')!='SOURCE_PROVEN_EXACT_VM_LOGIC':raise ValueError('canonical season VM evidence unavailable')
 ensure_texture_cache(extracted,textures);tiles=OfficialTiles(extracted,textures);assets=[]
 for name,index in SPRITES.items():
  row=write_dir(output/'Content/Particle'/f'{name}.dir',tiles,index);row['output']=str(Path(row['output']).relative_to(output));assets.append(row)
 audio=json.loads((repo/'NO_NAME_VILLAGE_ADAPTATION/reports/audio-manifest.json').read_text())
 manifest={'schema':'new-era.nnv-canonical-winter-particles.v1','source':{
   'data_win_sha256':'2f33b595b450b40355554d73f5acc5d7272e5d54519e35cd8971e0f336401227',
   'season_vm_evidence':'reports/season-vm-evidence.json','season_vm_evidence_sha256':file_sha(repo/'NO_NAME_VILLAGE_ADAPTATION/reports/season-vm-evidence.json')},
  'source_parameters':evidence['winter_particles'],'assets':assets,
  'footprint_audio':{'source_name':'snpfssnow0','sound_resource_index':352,'source_manifest_status':audio['status'],'asset_status':'MISSING_BINARY_OUTSIDE_TRACKED_EXTRACTION'},
  'status':'ASSETS_COMPILED','conversion_status':'UNIMPLEMENTED','runtime_status':'NOT_RUN','promotion_allowed':False,
  'blockers':['GameMaker shape-0 base particle visual adapter not compiled','three-family emitter concurrency/timing not mapped to proven PMDO API','snow footprint terrain condition not implemented','snow trail fading surface not implemented','snpfssnow0 binary audio not present in tracked extraction','runtime PMDO particle capture not run']}
 manifest['semantic_sha256']=canonical_sha(manifest);(output/'manifest.json').write_text(json.dumps(manifest,ensure_ascii=False,indent=2,sort_keys=True)+'\n')
 return manifest

def main()->int:
 root=REPO/'NO_NAME_VILLAGE_ADAPTATION';p=argparse.ArgumentParser(description=__doc__)
 p.add_argument('--extracted',type=Path,default=root/'extracted/official');p.add_argument('--texture-cache',type=Path,default=REPO/'.runtime-cache/nnv-official-textures')
 p.add_argument('--output',type=Path,default=root/'generated/rmvillage/winter/particles');a=p.parse_args();m=build(REPO,a.extracted,a.texture_cache,a.output)
 print(json.dumps({'status':m['status'],'conversion_status':m['conversion_status'],'assets':len(m['assets']),'blockers':m['blockers']},ensure_ascii=False));return 0
if __name__=='__main__':raise SystemExit(main())
