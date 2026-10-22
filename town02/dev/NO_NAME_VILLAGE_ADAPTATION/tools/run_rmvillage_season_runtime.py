#!/usr/bin/env python3
"""Materialize and execute one canonical rmvillage season in exact PMDO 0.8.12."""
from __future__ import annotations
import argparse,hashlib,json,os,shutil,subprocess,sys
from pathlib import Path
HERE=Path(__file__).resolve();REPO=HERE.parents[2]
for p in (REPO/'PMU_ADAPTATION/src',REPO/'PMU_EXTRACTION/src',REPO/'tools'):sys.path.insert(0,str(p))
from pmu_adaptation.runtime import build_fixture
from smart_dungeon.ground_runtime import runtime_env
SEASONS=('spring','autumn','winter')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def require(v,m):
 if not v:raise RuntimeError(m)
def main()->int:
 ap=argparse.ArgumentParser(description=__doc__);ap.add_argument('--season',choices=SEASONS,required=True);ap.add_argument('--timeout',type=int,default=600);a=ap.parse_args()
 summer_guard=subprocess.run([sys.executable,str(REPO/'NO_NAME_VILLAGE_ADAPTATION/tools/verify_rmvillage_summer_baseline.py')],cwd=REPO,capture_output=True,text=True);require(summer_guard.returncode==0,summer_guard.stdout+summer_guard.stderr)
 runtime_py=REPO/'.runtime-cache/test-venv/bin/python';pmdo=REPO/'.runtime-cache/pmdo-headless-bundle/PMDO';require(runtime_py.is_file() and pmdo.is_file(),'exact Agent A runtime cache missing')
 ground=REPO/f'.runtime-cache/nnv-seasons/nnv_rmvillage_{a.season}.rsground';subprocess.run([sys.executable,str(REPO/'NO_NAME_VILLAGE_ADAPTATION/tools/materialize_rmvillage_season.py'),'--season',a.season,'--output',str(ground)],cwd=REPO,check=True)
 season_root=REPO/'NO_NAME_VILLAGE_ADAPTATION/generated/rmvillage'/a.season;manifest_path=season_root/'manifest.json';manifest=json.loads(manifest_path.read_text());tile=season_root/manifest['outputs']['tile']
 fixture_root=REPO/'.runtime-cache/nnv-season-runtime'/a.season;fixture=build_fixture(REPO,ground,tile,fixture_root,[0,1,2,3,6,11]);env=runtime_env(REPO)
 index_cmd=[str(pmdo),'-asset',fixture['asset_root'],'-appdata',fixture['appdata'],'-quest',fixture['quest_name'],'-index','zone'];index=subprocess.run(index_cmd,cwd=REPO,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=600);require(index.returncode==0,'PMDO index failed')
 events=Path('/tmp/smart_ground_runtime_validator.jsonl');events.unlink(missing_ok=True);screens=Path(fixture['appdata'])/'SCREENSHOT';shutil.rmtree(screens,ignore_errors=True);screens.mkdir(parents=True)
 raw=fixture_root/'raw-runtime';shutil.rmtree(raw,ignore_errors=True);raw.mkdir()
 gate=[str(runtime_py),str(REPO/'tools/run_pmdred_eu_pmdo_termination_gate.py'),'--pmdo',str(pmdo),'--asset',fixture['asset_root'],'--appdata',fixture['appdata'],'--quest',fixture['quest_name'],'--events',str(events),'--runtime-log',str(raw/'runtime.log'),'--event-copy',str(raw/'events.jsonl'),'--status-json',str(raw/'termination.json'),'--terminal-timeout',str(a.timeout),'--post-end-delay','1.0','--shutdown-signal','INT','--reset-events']
 run=subprocess.run(gate,cwd=REPO,env=env,stdout=subprocess.PIPE,stderr=subprocess.STDOUT,timeout=a.timeout+100);(raw/'stdout.log').write_bytes(run.stdout);require(run.returncode==0,run.stdout.decode(errors='replace')[-1000:])
 destination=season_root/'runtime';shutil.rmtree(destination,ignore_errors=True);destination.mkdir();(destination/'index.log').write_bytes(index.stdout)
 for src,name in [(raw/'runtime.log','runtime.log'),(raw/'events.jsonl','events.jsonl'),(raw/'termination.json','termination.json'),(raw/'stdout.log','termination.stdout.log')]:shutil.copy2(src,destination/name)
 shots=sorted(screens.glob('*.png'),key=lambda p:p.stat().st_mtime_ns);labels=[(c['label'],t) for c in fixture['captures'] for t in fixture['ticks']];require(len(shots)==len(labels),'capture count')
 captures=[]
 for source,(label,tick) in zip(shots,labels,strict=True):
  target=destination/f'{label}_tick_{tick:03d}.png';shutil.copy2(source,target);captures.append({'label':label,'tick':tick,'file':target.name,'sha256':sha(target),'bytes':target.stat().st_size})
 runtime_bytes=(destination/'runtime.log').read_bytes().lower()
 for signature in (b'exception depth',b'unhandled exception',b'failed to load',b'missing data:',b'index was outside the bounds'):
  require(signature not in runtime_bytes,f'runtime error signature: {signature.decode()}')
 event_rows=[json.loads(line) for line in (destination/'events.jsonl').read_text().splitlines()];results=[x for x in event_rows if x.get('event')=='result'];require(len(results)==1 and results[0].get('verdict')=='RUNTIME_PASS','runtime probes')
 termination=json.loads((destination/'termination.json').read_text());require(termination['termination']['kind']=='NORMAL_EXIT' and termination['termination']['exit_code']==0 and termination['graceful_exit_observed'],'termination')
 report={'schema':'new-era.nnv-rmvillage-runtime.v2','room':'rmvillage','season':a.season,'pmdo_version':'0.8.12','pmdo_sha256':sha(pmdo),'method':'Agent A ignored overlay + patched SDL + SwiftShader/ANGLE + exact LoadPhase.Unload termination','ground_sha256':sha(ground),'tile_sha256':sha(tile),'index':{'status':'PASS','file':'index.log','sha256':sha(destination/'index.log')},'probes':results[0],'captures':captures,'animation_capture':{'status':'PASS' if len({x['sha256'] for x in captures})>2 else 'INCONCLUSIVE','distinct_capture_hashes':len({x['sha256'] for x in captures}),'ticks':fixture['ticks']},'termination':termination,'functional_runtime_status':'PASS','termination_status':'PASS','runtime_status':'RUNTIME_TESTED_PASS','conversion_status':'UNIMPLEMENTED','certification_status':'NOT_CERTIFIED','promotion_allowed':False,'remaining_blockers':['four-season router not validated as one production flow','canonical NNV particle controller not runtime-integrated','social and wild Pokemon not integrated']}
 report['semantic_sha256']=hashlib.sha256(json.dumps(report,ensure_ascii=False,sort_keys=True,separators=(',',':')).encode()).hexdigest();report_path=destination/'runtime_report.json';report_path.write_text(json.dumps(report,ensure_ascii=False,indent=2,sort_keys=True)+'\n')
 manifest['runtime_status']='RUNTIME_TESTED_PASS';manifest['outputs']['runtime_report']=str(report_path.relative_to(season_root));manifest['outputs']['runtime_report_sha256']=sha(report_path);manifest['blockers']=[x for x in manifest['blockers'] if x!='seasonal layer bundle not materialized as a standalone PMDO Ground'];manifest.pop('manifest_semantic_sha256',None);manifest['manifest_semantic_sha256']=hashlib.sha256(json.dumps(manifest,ensure_ascii=False,sort_keys=True,separators=(',',':')).encode()).hexdigest();manifest_path.write_text(json.dumps(manifest,ensure_ascii=False,indent=2,sort_keys=True)+'\n')
 print(json.dumps({'result':'RMVILLAGE_SEASON_RUNTIME_PASS','season':a.season,'captures':len(captures),'runtime_status':manifest['runtime_status'],'conversion_status':manifest['conversion_status']}));return 0
if __name__=='__main__':raise SystemExit(main())
