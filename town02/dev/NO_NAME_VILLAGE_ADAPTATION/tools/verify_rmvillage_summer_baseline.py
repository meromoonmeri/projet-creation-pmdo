#!/usr/bin/env python3
"""Fail-closed guard for the validated rmvillage summer PMDO runtime component."""
from __future__ import annotations
import hashlib,json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[1]
BASELINE=ROOT/'generated/rmvillage/summer/runtime_baseline.json'

def sha(path:Path)->str:return hashlib.sha256(path.read_bytes()).hexdigest()
def require(ok:bool,message:str)->None:
 if not ok:raise SystemExit('RMVILLAGE_SUMMER_BASELINE_FAIL '+message)

def main()->int:
 data=json.loads(BASELINE.read_text());require(data['schema']=='new-era.nnv-rmvillage-summer-runtime-baseline.v1','schema')
 for row in data['files']:
  path=ROOT/row['path'];require(path.is_file(),f"missing:{row['path']}");require(sha(path)==row['sha256'],f"hash:{row['path']}")
 summer=ROOT/'generated/rmvillage/summer';manifest=json.loads((summer/'manifest.json').read_text());report=json.loads((summer/'runtime/runtime_report.json').read_text());termination=json.loads((summer/'runtime/termination.json').read_text())
 require(manifest['runtime_status']=='RUNTIME_TESTED_PASS','manifest runtime status')
 require(manifest['conversion_status']=='UNIMPLEMENTED','manifest conversion status elevated')
 require(not manifest['promotion_allowed'],'manifest promotion allowed')
 require(report['functional_runtime_status']=='PASS','functional runtime')
 require(report['runtime_status']=='RUNTIME_TESTED_PASS','report runtime status')
 require(report['conversion_status']=='UNIMPLEMENTED','report conversion status elevated')
 require(report['certification_status']=='NOT_CERTIFIED','report certification status elevated')
 require(not report['promotion_allowed'],'report promotion allowed')
 probes=report['probes'];require(probes['load']=='PASS' and probes['movement']=='PASS' and probes['blocked']=='PASS' and probes['verdict']=='RUNTIME_PASS','runtime probes')
 require(report['animation_capture']['status']=='PASS' and len(report['captures'])==12,'animation captures')
 require(termination['terminal_seen'] and termination['graceful_exit_observed'],'native terminal/unload')
 term=termination['termination'];require(term['result']=='PASS' and term['kind']=='NORMAL_EXIT' and term['exit_code']==0 and not term['forced_kill'],'native termination')
 canonical=dict(data);expected=canonical.pop('semantic_sha256');actual=hashlib.sha256(json.dumps(canonical,ensure_ascii=False,sort_keys=True,separators=(',',':')).encode()).hexdigest();require(actual==expected,'baseline semantic hash')
 print('RMVILLAGE_SUMMER_BASELINE_PASS files=%d captures=%d pmdo=%s'%(len(data['files']),len(report['captures']),report['pmdo_sha256']))
 return 0
if __name__=='__main__':raise SystemExit(main())
