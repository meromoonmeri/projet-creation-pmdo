#!/usr/bin/env python3
"""Index staged imported dungeons in the exact PMDO 0.8.12 runtime fixture."""
import argparse,json,shutil,subprocess
from pathlib import Path
from inventory_relict import sha256_file,write_json
from validate_pmdo_runtime import PMDO,command,runtime_env
EXPECTED=[
'reminiscencia_forest_pmdo','reminiscencia_cave_pmdo','reminiscencia_snow_forest_pmdo','reminiscencia_prison_pmdo','reminiscencia_deciduous_forest_pmdo','reminiscencia_justice_pmdo','reminiscencia_temple_pmdo','reminiscencia_lake_pmdo','reminiscencia_volcano_pmdo','reminiscencia_cliff_pmdo','reminiscencia_tower_pmdo','reminiscencia_mine_pmdo','reminiscencia_wheat_pmdo','reminiscencia_bay_pmdo','reminiscencia_rift_pmdo','reminiscencia_burned_tower_pmdo','reminiscencia_meteor_falls_pmdo','relict_destiny_tower_pmdo','relict_alabaster_icelands_pmdo','relict_mt_coronet_pmdo','relict_ancient_retreat_pmdo','relict_cobalt_coastlands_pmdo']
def main():
 p=argparse.ArgumentParser();p.add_argument('--repo',type=Path,required=True);p.add_argument('--workspace',type=Path,required=True);a=p.parse_args();repo=a.repo.resolve();workspace=a.workspace.resolve();source=repo/'.runtime-cache/bibliotheque-reminiscencia-map074-fixture';dest=repo/'.runtime-cache/bibliotheque-imported-dungeons-fixture';shutil.rmtree(dest,ignore_errors=True);shutil.copytree(source,dest,symlinks=True);manifest=json.load(open(dest/'fixture_manifest.json'));manifest['quest']=str(dest/'quest')+'/';manifest['appdata']=str(dest/'appdata')+'/';mod_link=dest/'appdata/MODS'/manifest['quest_name'];mod_link.unlink(missing_ok=True);mod_link.symlink_to(dest/'quest',target_is_directory=True);zones=dest/'quest/Data/Zone'
 for game in ('reminiscencia','relict'):
  for z in (workspace/f'games/{game}/conversion/pmdo_dungeons/zones').glob('*.json'):shutil.copy2(z,zones/z.name)
 proc=subprocess.run(command(manifest,'-index','zone'),cwd=repo,env=runtime_env(False),stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=300,check=True);log=proc.stdout.decode(errors='replace');bad=[x for x in ('error','exception','failed to load') if x in log.lower()]
 if bad:raise ValueError('PMDO zone index error signature: '+','.join(bad))
 index=json.load(open(zones/'index.idx',encoding='utf-8-sig'));keys=set(index['Object'])-{'$type'};missing=sorted(set(EXPECTED)-keys)
 if missing:raise ValueError('zones absent from PMDO index: '+str(missing))
 report={'schema_version':'1.0.0','result':'IMPORTED_PMDO_DUNGEONS_RUNTIME_INDEX_PASS','pmdo_sha256':sha256_file(PMDO),'zone_count':len(EXPECTED),'indexed_zone_ids':EXPECTED,'missing_zone_ids':missing,'error_signatures':bad,'runtime_destination_written':False}
 for game in ('reminiscencia','relict'):
  root=workspace/f'games/{game}/conversion/pmdo_dungeons';write_json(root/'runtime_index_report.json',report);(root/'runtime_index.log').write_text(log)
 print(json.dumps({'result':report['result'],'zone_count':report['zone_count'],'pmdo_sha256':report['pmdo_sha256']},sort_keys=True));return 0
if __name__=='__main__':raise SystemExit(main())
