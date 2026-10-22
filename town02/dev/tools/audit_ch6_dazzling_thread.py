#!/usr/bin/env python3
import re,json
from pathlib import Path
R=Path(__file__).resolve().parents[1]
e=(R/'Data/Script/halcyon/ground/gloomy_forest_entrance/gloomy_forest_entrance_ch_6.lua').read_text()
i=(R/'Data/Script/halcyon/ground/gloomy_forest_entrance/init.lua').read_text()
m=(R/'Data/Script/halcyon/ground/gloomy_forest_midpoint/gloomy_forest_midpoint_ch_6.lua').read_text()
z=(R/'Data/Script/halcyon/zone/gloomy_forest/init.lua').read_text()
checks={
 'entrance_triggered': 'DazzlingEntranceBlockade()' in i,
 'entrance_once_flag': 'DazzlingEntranceSeen' in e and 'DazzlingEntranceSeen' in i,
 'three_actors_at_entrance': all(x in e for x in ("{'Adagio',224,136","{'Aria',192,160","{'Sonata',248,160")),
 'physical_block_then_move': all(x in e for x in ('MoveToPosition(adagio','MoveToPosition(aria','MoveToPosition(sonata')),
 'hero_silent_response': 'GeneralFunctions.HeroDialogue' in e,
 'relay_clue': 'DazzlingRelayClueSeen' in m,
 'pre_rescue_three_source_slots': all(x in e for x in ('MoveToPosition(adagio,240,144','MoveToPosition(aria,280,176','MoveToPosition(sonata,208,176')),
 'pre_rescue_synchronized_entrance': 'TASK:JoinCoroutines({enter1,enter2,enter3,cam})' in e,
 'pre_rescue_tone_shift': 'DazzlingPreRescueSeen' in e,
 'final_progression': 'DazzlingChapterResolved' in z,
 'world_information': "LivingWorld.Publish('chenipent_rescued'" in z,
 'no_runtime_meanies_literal': not bool(re.search(r'["\'](?:Team Meanies|Meanies)["\']', '\n'.join(p.read_text(errors='ignore') for p in (R/'Data/Script/halcyon').rglob('*.lua')), re.I)),
}
print(json.dumps({'checks':checks,'runtime':'NOT_TESTED'},ensure_ascii=False,indent=2));raise SystemExit(0 if all(checks.values()) else 1)
