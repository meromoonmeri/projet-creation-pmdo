#!/usr/bin/env python3
from pathlib import Path
import json,re
R=Path(__file__).resolve().parents[1];t=(R/'Data/Script/halcyon/TownLife.lua').read_text();m=(R/'Data/Script/halcyon/ground/metano_town/init.lua').read_text()
groups=re.findall(r"\{ '([^']+)','([^']+)',\n\s*\{",t)
checks={'five_social_groups':len(groups)>=5,'once_per_day':'SeenSocialDay==day' in t and 'SeenSocialDay=day' in t,'same_area_only':'pa[4]==pb[4]' in t,'no_visible_teleport':'TeleportTo' not in t[t.index('function TownLife.PlayDailySocial'):],'camera':'MoveCamera' in t[t.index('function TownLife.PlayDailySocial'):],'actor_turns':'CharTurnToCharAnimated' in t,'actor_emotes':'CharSetEmote' in t,'cleanup_ai':'AI:EnableCharacterAI(g.a)' in t and 'GAME:CutsceneMode(false)' in t,'weather_reaction':"Weather.Current=='orage'" in t,'world_event_reaction':'DazzlingChapterResolved' in t,'story_priority':'not t.MissionCompleted' in m,'daily_hook':'TownLife.PlayDailySocial()' in m}
print(json.dumps({'social_groups':groups,'checks':checks,'runtime':'NOT_TESTED'},ensure_ascii=False,indent=2));raise SystemExit(0 if all(checks.values()) else 1)
