#!/usr/bin/env python3
from pathlib import Path
import re,json
ROOT=Path(__file__).resolve().parents[1];base=ROOT/'Data/Script/halcyon';rows=[];findings=[]
for p in sorted(base.rglob('*.lua')):
 s=p.read_text(errors='ignore');ctx=(str(p)+' '+s[:1200]).lower();chs={int(x) for x in re.findall(r'(?:chapter|chapitre|_ch_|\bch)\s*_?([0-9]{1,2})',ctx) if 5<=int(x)<=32}
 if not chs:continue
 q={k:len(re.findall(v,s)) for k,v in {'dialogues':r'UI:(?:WaitShowDialogue|ShowDialogue)\s*\(','camera':r'GAME:MoveCamera\s*\(','moves':r'GROUND:(?:MoveToPosition|MoveInDirection)\s*\(','turns':r'GROUND:(?:CharAnimateTurnTo|CharTurnToChar|CharTurnToCharAnimated)\s*\(','emotes':r'(?:SetEmotion|CharSetEmote)\s*\(','ost':r'SOUND:(?:PlayBGM|FadeOutBGM)\s*\('}.items()};q.update(file=str(p.relative_to(ROOT)),chapters=sorted(chs));rows.append(q)
 if q['dialogues'] and not(q['camera'] or q['moves'] or q['turns']):findings.append({'file':q['file'],'issue':'dialogue-only scene'})
summary={str(ch):{k:0 for k in ('files','dialogues','camera','moves','turns','emotes','ost')} for ch in range(5,33)}
for r in rows:
 for ch in r['chapters']:
  s=summary[str(ch)];s['files']+=1
  for k in ('dialogues','camera','moves','turns','emotes','ost'):s[k]+=r[k]
out={'schema':1,'rules_source':'prompt_exhaustif_cutscenes_pmd (2).md','target_dialogue_lines':1000,'measured_dialogue_calls':sum(x['dialogues'] for x in rows),'chapters':summary,'files':rows,'static_findings':findings,'runtime_validation':'required before completion claim'};dest=ROOT/'docs/canonical/CUTSCENE_AUDIT_CH5_CH32.json';dest.parent.mkdir(parents=True,exist_ok=True);dest.write_text(json.dumps(out,indent=2,ensure_ascii=False)+'\n');print(json.dumps({'files':len(rows),'dialogues':out['measured_dialogue_calls'],'findings':len(findings)}))
