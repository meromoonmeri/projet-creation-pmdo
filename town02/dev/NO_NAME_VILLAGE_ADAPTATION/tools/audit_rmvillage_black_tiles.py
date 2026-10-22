#!/usr/bin/env python3
"""Audit rmvillage for missing references, black cells and runtime black frames."""
from __future__ import annotations
import gzip,hashlib,json,struct
from pathlib import Path
try:from PIL import Image
except ImportError as exc:raise SystemExit('Pillow missing; install requirements-conversion.lock') from exc
ROOT=Path(__file__).resolve().parents[1];VILLAGE=ROOT/'generated/rmvillage';SEASONS=('spring','summer','autumn','winter')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def tile_keys(path):
 b=path.read_bytes();size,count=struct.unpack_from('<II',b,0);keys=set();payloads={}
 for i in range(count):
  key,offset=struct.unpack_from('<QQ',b,8+i*16);keys.add(key);length=struct.unpack_from('<Q',b,offset)[0]
  if offset+8+length>len(b) or b[offset+8:offset+16]!=b'\x89PNG\r\n\x1a\n':raise ValueError(f'invalid tile payload {path}:{i}')
  payloads[offset]=length
 return size,count,keys,len(payloads)
def layers_for(season,root,manifest):
 if season=='summer':return json.loads((root/manifest['outputs']['ground']).read_text(encoding='utf-8-sig'))['Object']['Layers']
 with gzip.open(root/manifest['outputs']['season_layers'],'rt',encoding='utf-8') as stream:return json.load(stream)['layers']
def main():
 summer=json.loads((VILLAGE/'summer/manifest.json').read_text());ground=json.loads((VILLAGE/'summer'/summer['outputs']['ground']).read_text(encoding='utf-8-sig'))['Object'];obstacles=ground['obstacles'];rows=[];problems=[]
 for season in SEASONS:
  root=VILLAGE/season;m=json.loads((root/'manifest.json').read_text());tile=root/m['outputs']['tile'];size,count,keys,unique=tile_keys(tile);layers=layers_for(season,root,m);references=missing=0
  for layer in layers:
   for column in layer['Tiles']:
    for cell in column:
     for tile_layer in cell.get('Layers',[]):
      for frame in tile_layer.get('Frames',[]):
       references+=1;loc=frame['TexLoc'];key=int(loc['X'])|(int(loc['Y'])<<32)
       if frame['Sheet']!=tile.stem or key not in keys:missing+=1
  image=Image.open(root/m['outputs']['candidate_render']).convert('RGBA');full_black=[];transparent=[]
  for y in range(78):
   for x in range(78):
    extrema=image.crop((x*64,y*64,(x+1)*64,(y+1)*64)).getextrema()
    if extrema[3][1]==0:transparent.append([x,y])
    if all(channel[1]==0 for channel in extrema[:3]) and extrema[3][0]>0:full_black.append([x,y])
  reduced=image.convert('RGB').resize((624,624),Image.Resampling.BOX);pixels=reduced.load();walkable_holes=[]
  for x in range(624):
   for y in range(624):
    if obstacles[x][y]['Tags']==0 and max(pixels[x,y])<8:walkable_holes.append([x,y])
  captures=[]
  runtime=root/'runtime'
  for capture in sorted(runtime.glob('*_tick_*.png')):
   shot=Image.open(capture).convert('RGB');colors=shot.getcolors(maxcolors=shot.width*shot.height) or [];black=sum(n for n,color in colors if color==(0,0,0));magenta=sum(n for n,color in colors if color in {(255,0,255),(128,0,128)});all_black=black==shot.width*shot.height
   captures.append({'file':capture.name,'sha256':sha(capture),'dimensions':[shot.width,shot.height],'black_pixels':black,'magenta_error_pixels':magenta,'all_black':all_black})
  row={'season':season,'tile_size':size,'tile_entries':count,'unique_payloads':unique,'tile_references':references,'missing_tile_references':missing,'full_black_visual_cells':full_black,'transparent_visual_cells':transparent,'walkable_dark_holes_8px':walkable_holes,'runtime_captures':captures,'runtime_capture_count':len(captures),'source_candidate_max_channel_error':m['visual_metrics']['max_channel_error'],'source_candidate_alpha_exact':m['visual_metrics']['alpha_exact']};rows.append(row)
  if missing or full_black or transparent or walkable_holes or len(captures)!=12 or any(c['all_black'] or c['magenta_error_pixels'] for c in captures):problems.append(season)
 out={'schema':'new-era.nnv-rmvillage-black-tile-audit.v1','room':'rmvillage','scope':'four 4992x4992 seasonal candidates + 48 PMDO runtime captures','result':'BLACK_TILE_AUDIT_PASS' if not problems else 'BLACK_TILE_AUDIT_FAIL','problem_seasons':problems,'seasons':rows,'meaning':'Pure black outline pixels are allowed; full black/transparent 64px cells, dark walkable 8px holes, missing tile references, all-black captures and magenta error pixels fail.'}
 out['semantic_sha256']=hashlib.sha256(json.dumps(out,ensure_ascii=False,sort_keys=True,separators=(',',':')).encode()).hexdigest();path=VILLAGE/'black_tile_audit.json';path.write_text(json.dumps(out,ensure_ascii=False,indent=2,sort_keys=True)+'\n');print(out['result'],json.dumps({r['season']:{'missing':r['missing_tile_references'],'black_cells':len(r['full_black_visual_cells']),'dark_holes':len(r['walkable_dark_holes_8px']),'captures':r['runtime_capture_count']} for r in rows},sort_keys=True));return 0 if not problems else 1
if __name__=='__main__':raise SystemExit(main())
