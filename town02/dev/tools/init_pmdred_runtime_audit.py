#!/usr/bin/env python3
from pathlib import Path
import json
ROOT=Path(__file__).resolve().parents[1];src=json.load(open(ROOT/'docs/audit_pmdred_full/FULL_AUDIT.json'));grounds=sorted({r['ground'] for r in src['grounds'] if r.get('runtime')});out=ROOT/'docs/audit_pmdred_runtime';out.mkdir(parents=True,exist_ok=True)
checks=('Load','Tiles','Spawn','Collision','Camera','Markers','Relays','Boss','Lua','Transitions')
rows=[{'Ground':g,**{k:'NOT_TESTED' for k in checks},'Verdict':'NOT_TESTED','Evidence':[]} for g in grounds]
report={'schema':1,'scope':'41 PMD Red Grounds integrated at runtime','classification':['RUNTIME_PASS','RUNTIME_WARNING','RUNTIME_FAIL','RUNTIME_CRITICAL','NOT_TESTED'],'summary':{'grounds':len(grounds),'runtime_pass':0,'runtime_warning':0,'runtime_fail':0,'runtime_critical':0,'not_tested':len(grounds),'load_errors':0,'tile_errors':0,'lua_errors':0,'collision_errors':0,'camera_errors':0,'marker_errors':0,'relay_errors':0,'boss_errors':0,'transition_errors':0,'corrections':0},'environment':{'pmdo_required':'0.8.12','executable_available':False,'attempt':'PMDOSetup Linux 0.8.12 downloaded and executed','blocker':'installer GitHub API request returned HTTP 403 rate limit exceeded; no RogueEssence executable was produced','evidence':'installer_attempt.log'},'grounds':rows,'rule':'No static result was promoted to runtime pass.'}
(out/'RUNTIME_AUDIT.json').write_text(json.dumps(report,indent=2,ensure_ascii=False)+'\n');(out/'PASS.txt').write_text('');(out/'FAIL.txt').write_text('');(out/'MANUAL_REVIEW.txt').write_text('\n'.join(grounds)+'\n')
for f in ('LUA_ERRORS','TILE_ERRORS','BOSS_ERRORS','RELAY_ERRORS','TRANSITION_ERRORS','CAMERA_ERRORS','COLLISION_ERRORS','CORRECTIONS'):(out/(f+'.json')).write_text('[]\n')
lines=['# Runtime audit — PMD Red imports','',f'Corpus: **{len(grounds)} Grounds**.','', '**Verdict actuel : 41 NOT_TESTED. Aucun PASS_STATIC promu.**','', '## Tentative moteur réelle','', 'PMDOSetup Linux 0.8.12 a été téléchargé et exécuté. L’installation a échoué avant de produire RogueEssence : `HTTP 403 rate limit exceeded`. Voir `installer_attempt.log`.','', 'Sans exécutable, `GraphicsManager.GetTile`, `BaseSheet.Load`, Lua, caméra, collisions et transitions ne peuvent pas être honnêtement classés runtime.','', '## Matrice']
lines+=['|Ground|'+'|'.join(checks)+'|Verdict|','|---|'+'|'.join(['---']*len(checks))+'|---|']
for r in rows:lines.append('|'+r['Ground']+'|'+'|'.join(r[k] for k in checks)+'|'+r['Verdict']+'|')
(out/'RUNTIME_REPORT.md').write_text('\n'.join(lines)+'\n');print(json.dumps(report['summary']))
