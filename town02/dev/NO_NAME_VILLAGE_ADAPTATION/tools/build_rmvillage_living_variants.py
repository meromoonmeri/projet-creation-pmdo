#!/usr/bin/env python3
"""Bind the Pokemon life patch to all four animal-free seasonal environments."""
from __future__ import annotations
import hashlib,json
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def main():
 patch_path=ROOT/'generated/rmvillage/life/entities_patch.json';patch=json.loads(patch_path.read_text());assert patch['entity_count']==49 and patch['source_animal_count']==31
 rows=[]
 for season in ('spring','summer','autumn','winter'):
  env=ROOT/'generated/rmvillage/living'/f'{season}_environment';em=json.loads((env/'manifest.json').read_text());assert em['season']==season and em['conversion_status']=='UNIMPLEMENTED'
  target=ROOT/'generated/rmvillage/living'/season;target.mkdir(parents=True,exist_ok=True)
  full=target/'manifest.json'
  existing=json.loads(full.read_text()) if full.exists() else None
  out={'schema':'new-era.nnv-rmvillage-living-season.v1','room':'rmvillage','season':season,'environment_manifest':str((env/'manifest.json').relative_to(ROOT)),'environment_manifest_sha256':sha(env/'manifest.json'),'life_patch':str(patch_path.relative_to(ROOT)),'life_patch_sha256':sha(patch_path),'entity_count':49,'social_count':5,'wild_count':44,'source_animal_count':31,'source_animal_sprites_in_visual_layers':False,'status':'LIFE_INTEGRATED_CANDIDATE' if season=='summer' else 'LIFE_LAYER_BUNDLE','runtime_status':existing.get('runtime_status','NOT_RUN') if existing else 'NOT_RUN','conversion_status':'UNIMPLEMENTED','certification_status':'NOT_CERTIFIED','promotion_allowed':False,'blockers':['Pokemon AI/routines/dialogues not runtime tested in this living variant','canonical four-value NNV time/lighting/audio system not integrated','wild encounter/battle transition system not implemented','objwinter controller incomplete']}
  if season=='summer' and existing:
   out['outputs']=existing['outputs'];out['ground_sha256']=existing['outputs']['ground_sha256']
  else:
   out['outputs']={'season_layers':em['outputs']['season_layers'],'season_layers_sha256':em['outputs']['season_layers_sha256'],'tile':em['outputs']['tile'],'tile_sha256':em['outputs']['tile_sha256'],'life_script':'generated/rmvillage/life/NNVLife.lua','life_script_sha256':patch['script_sha256'],'ground_script':'generated/rmvillage/life/init.lua','ground_script_sha256':patch['ground_script_sha256']}
  out['semantic_sha256']=hashlib.sha256(json.dumps(out,ensure_ascii=False,sort_keys=True,separators=(',',':')).encode()).hexdigest();full.write_text(json.dumps(out,ensure_ascii=False,indent=2,sort_keys=True)+'\n');rows.append({'season':season,'status':out['status'],'runtime_status':out['runtime_status'],'manifest':str(full.relative_to(ROOT)),'manifest_sha256':sha(full)})
 summary={'schema':'new-era.nnv-rmvillage-living-four-season.v1','room':'rmvillage','variants':rows,'variant_count':4,'entity_count_per_variant':49,'source_animals_converted':31,'status':'FOUR_SEASON_LIFE_BOUND','runtime_status':'NOT_RUN_ALL_VARIANTS','conversion_status':'UNIMPLEMENTED','certification_status':'NOT_CERTIFIED','promotion_allowed':False,'blockers':['living variants not runtime tested','day/night source controllers not integrated','particle controller incomplete','encounter system incomplete']};summary['semantic_sha256']=hashlib.sha256(json.dumps(summary,ensure_ascii=False,sort_keys=True,separators=(',',':')).encode()).hexdigest();(ROOT/'generated/rmvillage/living/summary.json').write_text(json.dumps(summary,ensure_ascii=False,indent=2,sort_keys=True)+'\n');print(json.dumps({'result':'RMVILLAGE_LIVING_VARIANTS_PASS','variants':4,'entities_each':49,'status':summary['status']}))
if __name__=='__main__':main()
