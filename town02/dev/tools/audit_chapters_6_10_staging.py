#!/usr/bin/env python3
import re,json
from pathlib import Path
ROOT=Path('Data/Script/halcyon');OUT=Path('docs/audit_global/chapters_6_10');OUT.mkdir(parents=True,exist_ok=True)
patterns={
'dialogue':r'WaitShowDialogue|HeroDialogue|BeginChoiceMenu|ChoiceMenuYesNo',
'movement':r'MoveInDirection|MoveToPosition|AnimateInDirection|TeleportTo',
'turn_head':r'CharAnimateTurnTo|CharTurnToChar|LookAround',
'reaction':r'SetEmotion|CharSetEmote|CharSetAnim',
'camera':r'MoveCamera|ResetCamera',
'pause':r'WaitFrames',
'battle':r'BossTransition|EnterDungeon|ContinueDungeon',
'transition':r'EnterGroundMap|EnterZone|EnterDungeon|ContinueDungeon',
}
allfiles=list(ROOT.rglob('*.lua'))
results={}
for ch in range(6,11):
 files=[]
 for p in allfiles:
  s=str(p).lower();txt=p.read_text(errors='ignore')
  if re.search(rf'(?:_ch_|chapter|chapitre){ch}(?:\D|$)',s) or re.search(rf'SV\.Chapter{ch}\b',txt):files.append((p,txt))
 counts={k:sum(len(re.findall(v,t,re.I)) for p,t in files) for k,v in patterns.items()}
 thin=[]
 for p,t in files:
  d=len(re.findall(patterns['dialogue'],t,re.I));stage=sum(len(re.findall(patterns[k],t,re.I)) for k in ['movement','turn_head','reaction','camera','pause'])
  if d>=4 and stage<max(2,d//4):thin.append({'file':str(p),'dialogue':d,'staging':stage,'class':'NEEDS_STAGING'})
 status='NEEDS_DIALOGUE' if counts['dialogue']<1000 else ('NEEDS_STAGING' if thin else 'STATIC_PASS')
 results[str(ch)]={'chapter':ch,'TOTAL_DIALOGUE_LINES':counts['dialogue'],'NEW_DIALOGUE_LINES':0,'CUTSCENES':len(files),'CUTSCENE_DURATION':'NOT_MEASURED','CHARACTERS_INVOLVED':'NOT_RELIABLY_INFERRED','REACTIONS':counts['reaction'],'MOVEMENT_EVENTS':counts['movement'],'HEAD_TURN_EVENTS':counts['turn_head'],'EMOTIONAL_BEATS':counts['reaction'],'WORLD_BUILDING_BEATS':'MANUAL_REVIEW','COMEDIC_BEATS':'MANUAL_REVIEW','DRAMATIC_BEATS':'MANUAL_REVIEW','PLOT_REVELATIONS':'MANUAL_REVIEW','CONSEQUENCES':'MANUAL_REVIEW','CAMERA_EVENTS':counts['camera'],'PAUSES':counts['pause'],'TRANSITIONS':counts['transition'],'RUNTIME_STATUS':'NOT_TESTED','STATIC_STATUS':status,'FILES':len(files),'THIN_SCENES':thin}
 json.dump(results[str(ch)],open(OUT/f'CHAPTER_{ch}_STAGING.json','w'),indent=2)
json.dump({'classification':'STATIC_STAGING_BASELINE_NOT_RUNTIME','chapters':results},open(OUT/'SUMMARY.json','w'),indent=2)
md=['# Chapters 6–10 staging baseline','','No runtime PASS is inferred. Dialogue “lines” are dialogue API calls, not wrapped visual lines.','', '| Chapter | Dialogue calls | Movement | Turns/looks | Reactions | Camera | Pauses | Thin scenes | Status |','|---:|---:|---:|---:|---:|---:|---:|---:|---|']
for c,r in results.items():md.append(f"| {c} | {r['TOTAL_DIALOGUE_LINES']} | {r['MOVEMENT_EVENTS']} | {r['HEAD_TURN_EVENTS']} | {r['REACTIONS']} | {r['CAMERA_EVENTS']} | {r['PAUSES']} | {len(r['THIN_SCENES'])} | {r['STATIC_STATUS']} |")
open(OUT/'REPORT.md','w').write('\n'.join(md)+'\n')
print(json.dumps({c:{k:r[k] for k in ['TOTAL_DIALOGUE_LINES','MOVEMENT_EVENTS','HEAD_TURN_EVENTS','REACTIONS','STATIC_STATUS']} for c,r in results.items()},indent=2))
