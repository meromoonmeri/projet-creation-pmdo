#!/usr/bin/env python3
"""Build Nova source-render manifest and encyclopedic PMDO catalog."""
import argparse,hashlib,json,shutil
from pathlib import Path
from inventory_relict import sha256_file,write_json
from png_rgba import load_png
COMMIT='6963878956ec4c53833c03f26aa6a9aafd17800f';ARCHIVE_SHA='d564158bae3cf34dd7e0d00b0377ff7059f91d91bb374a23ece4eff7ddfa94cb';ARCHIVE_SIZE=284771731
def load(p):return json.loads(p.read_text(encoding='utf-8'))
def build(game):
 game=game.resolve();cand=game/'conversion/pmdo_candidates';report=load(cand/'conversion_report.json');vfx=load(game/'vfx/manifest.json');source_root=game/'conversion/pmdo_renders';maps={x['map_id']:x for x in report['maps']};ids=set(range(1,168))
 if set(maps)!=ids:raise ValueError('Nova map coverage differs from 001..167')
 runtime=sorted(int(p.parent.name.split('_')[1]) for p in (cand/'runtime').glob('map_*/runtime_report.json'))
 metadata=game/'metadata';metadata.mkdir(parents=True,exist_ok=True);write_json(metadata/'source_archive.json',{'schema_version':'1.0.0','game_id':'nova','repository':'https://github.com/meromoonmeri/BIBLIOTHEQUE','source_commit':COMMIT,'source_pointer':'Nova/NovaV2.0.zip','verified_sha256':ARCHIVE_SHA,'verified_size_bytes':ARCHIVE_SIZE,'source_code_executed':False,'raw_archive_tracked_in_new_era':False,'source_viewport_px':[960,540],'source_tile_size_px':32})
 renders=[]
 for mid,row in sorted(maps.items()):
  p=source_root/'maps'/f'map_{mid:03d}.png';im=load_png(p);renders.append({'map_id':mid,'source_name':row['source_name'],'file':p.relative_to(source_root).as_posix(),'sha256':sha256_file(p),'dimensions_px':[im.width,im.height],'tile_size_px':32,'missing_tile_ids':row['missing_tile_ids'],'status':'ADAPTATION_REQUIRED' if row['missing_tile_ids'] else 'SOURCE_DOCUMENTED','actor_pixels_exported':False})
 source_manifest={'schema_version':'1.0.0','result':'NOVA_SOURCE_RENDER_INVENTORY_PASS','game_id':'nova','map_count':167,'complete_render_count':sum(not x['missing_tile_ids'] for x in renders),'diagnostic_render_count':sum(bool(x['missing_tile_ids']) for x in renders),'source_archive_sha256':ARCHIVE_SHA,'source_viewport_px':[960,540],'renders':renders};write_json(source_root/'manifest.json',source_manifest)
 zones=game/'zones';tilesets=game/'tilesets';manifests=game/'manifests'
 for p in (zones,tilesets,manifests):shutil.rmtree(p,ignore_errors=True);p.mkdir(parents=True)
 timeline={x['map_id']:x for x in vfx['timelines']};zrows=[]
 for mid,row in sorted(maps.items()):
  side=load(cand/row['sidecar']);rt=f'conversion/pmdo_candidates/runtime/map_{mid:03d}/runtime_report.json' if mid in runtime else None
  payload={'schema_version':'1.0.0','game_id':'nova','map_id':mid,'source_identity':{'name':row['source_name']},'status':row['status'],'geometry':{'source_pixels':row['source_dimensions_px'],'source_tile_size_px':32,'source_viewport_px':[960,540],'pmdo_pixels':row['pmdo_dimensions_px'],'pmdo_tile_size_px':16,'pmdo_collision_size_px':8,'pmdo_viewport_px':[320,240],'pmdo_tex_size':2,'edge_view':'Clamp','source_scale':[1,2],'camera_adaptation':'SOURCE_16_9_VIEW_480x270_CROPPED_BY_TARGET_4_3_VIEW_320x240'},'visuals':{'panorama_converted':row['panorama_converted'],'fog_name':row['fog_name'],'fog_materialized':row['fog_materialized'],'environment_sprite_entity_count':row['environment_sprite_entity_count'],'environment_sprite_page_context_count':row['environment_sprite_page_context_count'],'missing_tile_ids':row['missing_tile_ids'],'unresolved_dependencies':row['unresolved_dependencies']},'collision':{'partial_direction_masks':row['partial_direction_masks'],'exact_mask_in_sidecar':True,'native_policy':side['partial_collision_policy']},'entities':{'source_event_count':side['entities']['source_event_count'],'page_placement_count':side['entities']['page_placement_count'],'identities_redacted':True},'artifacts':{'ground_bundle':'conversion/pmdo_candidates/'+report['ground_storage']['file'],'ground_member':row['ground'],'ground_sha256':row['ground_sha256'],'sidecar':'conversion/pmdo_candidates/'+row['sidecar'],'sidecar_sha256':row['sidecar_sha256'],'preview':'conversion/pmdo_candidates/'+row['preview'],'preview_sha256':row['preview_sha256'],'source_render':'conversion/pmdo_renders/maps/map_%03d.png'%mid,'source_render_sha256':renders[mid-1]['sha256'],'visual_timeline':timeline[mid]['file'],'visual_timeline_sha256':timeline[mid]['sha256'],'runtime_report':rt,'runtime_report_sha256':sha256_file(game/rt) if rt else None},'provenance':{'source_archive_sha256':ARCHIVE_SHA,'source_commit':COMMIT}}
  p=zones/f'map_{mid:03d}.json';write_json(p,payload);zrows.append({'map_id':mid,'status':row['status'],'file':p.relative_to(game).as_posix(),'sha256':sha256_file(p)})
 trows=[]
 for a in report['atlases']:
  payload={'schema_version':'1.0.0','game_id':'nova','tileset_id':a['tileset_id'],'map_ids':[x['map_id'] for x in report['maps'] if x['tileset_id']==a['tileset_id']],'pmdo':a}
  p=tilesets/f"tileset_{a['tileset_id']:03d}.json";write_json(p,payload);trows.append({'tileset_id':a['tileset_id'],'file':p.relative_to(game).as_posix(),'sha256':sha256_file(p)})
 catalog={'schema_version':'1.0.0','result':'NOVA_ENCYCLOPEDIC_CATALOG_PASS','game_id':'nova','map_count':167,'tileset_count':len(trows),'status_counts':report['status_counts'],'runtime_validated_map_ids':runtime,'zones':zrows,'tilesets':trows,'authorities':{'candidate_report':{'file':'conversion/pmdo_candidates/conversion_report.json','sha256':sha256_file(cand/'conversion_report.json')},'source_render_manifest':{'file':'conversion/pmdo_renders/manifest.json','sha256':sha256_file(source_root/'manifest.json')},'vfx_manifest':{'file':'vfx/manifest.json','sha256':sha256_file(game/'vfx/manifest.json')},'animations_manifest':{'file':'animations/manifest.json','sha256':sha256_file(game/'animations/manifest.json')}}};write_json(manifests/'pmdo_catalog.json',catalog)
 for n,text in [('previews/README.md','# Previews Nova\n\nPreviews cibles et planches: `conversion/pmdo_candidates/`.\n'),('reports/README.md','# Rapports Nova\n\nVoir `../../../reports/NOVA_PMDO_CONVERSION.md`.\n')]:p=game/n;p.parent.mkdir(exist_ok=True);p.write_text(text)
 return catalog
if __name__=='__main__':
 p=argparse.ArgumentParser();p.add_argument('--game-root',type=Path,required=True);a=p.parse_args();r=build(a.game_root);print(json.dumps({'result':r['result'],'map_count':r['map_count'],'tileset_count':r['tileset_count'],'runtime_validated_map_ids':r['runtime_validated_map_ids']},sort_keys=True))
