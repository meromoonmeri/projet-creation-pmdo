#!/usr/bin/env python3
from pathlib import Path
import json
R=Path(__file__).resolve().parents[1];s=(R/'Data/Script/halcyon/arc_fugitif/scene/d12p04.lua').read_text()
checks={'look_around':'question' in s,'music_stops_before_quake':s.index('FadeOutBGM')<s.index("DUN_Earthquake"),'act_present_before_quake':s.index("{'Charizard'")<s.index("DUN_Earthquake"),'only_two_act_members_first':"{'Charizard'" in s and "{'Tyranitar'" in s,'alakazam_not_first_group':s.index("{'Alakazam'")>s.index('Il combat encore Groudon'),'act_reports_defeat':'Il nous a écrasés' in s,'alakazam_still_battling':'Il combat encore Groudon' in s,'hero_partner_rush':all(x in s for x in ('local rush1=TASK:BranchCoroutine','local rush2=TASK:BranchCoroutine','TASK:JoinCoroutines({rush1,rush2})')),'alakazam_faint_at_boss':"{'Alakazam',208,152" in s and "GetAnimIndex('Faint')" in s,'groudon_after_alakazam':s.rindex('Groudon se réveille')>s.index("{'Alakazam',208,152")}
print(json.dumps({'source':'pret/pmd-red src/dungeon_cutscene_magma_cavern.c MagmaCavernMidDialogue','checks':checks,'runtime':'NOT_TESTED'},ensure_ascii=False,indent=2));raise SystemExit(0 if all(checks.values()) else 1)
