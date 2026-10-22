#!/usr/bin/env python3
from pathlib import Path
import argparse,json
ap=argparse.ArgumentParser();ap.add_argument('--input',default='/tmp/ground_gameplay_validator.jsonl');ap.add_argument('--out',default='docs/audit_pmdred_runtime/GAMEPLAY_PILOT.json');a=ap.parse_args();rows=[];errors=[]
for i,line in enumerate(Path(a.input).read_text().splitlines(),1):
 try:rows.append(json.loads(line))
 except Exception as e:errors.append({'line':i,'error':str(e),'raw':line})
grounds=[x for x in rows if 'ground' in x];out={'schema':1,'mode':'AUTOMATED RUNTIME GAMEPLAY PILOT','grounds':grounds,'events':[x for x in rows if 'event' in x],'parse_errors':errors,'summary':{'tested':len(grounds),'load_pass':sum(x.get('load')=='PASS' for x in grounds),'runtime_fail':sum(x.get('verdict')=='RUNTIME_FAIL' for x in grounds),'manual_review':sum(x.get('verdict')=='MANUAL_REVIEW' for x in grounds),'movement_inconclusive':sum(x.get('movement_probe')=='INCONCLUSIVE_SYNC_CONTEXT' for x in grounds)},'limitations':['Pilot validates real PMDO Ground loading, actual player spawn coordinates, Lua initialization, and cross-zone iteration.','Forced movement calls cannot be judged from the synchronous GroundMapEnter callback; zeros are inconclusive, not collision failures.','Camera edges, interactions, boss battle and transitions require later asynchronous validator phases.']};p=Path(a.out);p.parent.mkdir(parents=True,exist_ok=True);p.write_text(json.dumps(out,indent=2,ensure_ascii=False)+'\n');print(json.dumps(out['summary']))
