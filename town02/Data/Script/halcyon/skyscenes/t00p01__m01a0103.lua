-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a0103.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- ExecuteCommon(CORO_LIVES_REPLY_NORMAL, 0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Who are you?", french="Who are you?", german="Who are you?", italian="Chi siete?", spanish="Who are you?"})
  pcall(function() UI:ResetSpeaker() end)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[STS]Everyone:[STE] We are...", french="[STS]Everyone:[STE] We are...", german="[STS]Everyone:[STE] We are...", italian="[STS]Tutti[STE]: Siamo...", spanish="[STS]Everyone:[STE] We are..."})
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[STS]Everyone:[STE] [hero] and [partner]!", french="[STS]Everyone:[STE] [hero] and [partner]!", german="[STS]Everyone:[STE] [hero] and [partner]!", italian="[STS]Tutti[STE]: [hero] e [partner]!", spanish="[STS]Everyone:[STE] [hero] and [partner]!"})
  -- message_KeyWait
  GAME:WaitFrames(60)
  -- message_Close
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[c_name:PLAYER]", french="[c_name:PLAYER]", german="[c_name:PLAYER]", italian="[c_name:PLAYER]", spanish="[c_name:PLAYER]"})
  -- message_Close
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 4 then -- message_SwitchMonologue($HERO_TALK_KIND) case 4
  SkySceneKit.say({english="Male", french="Male", german="Male", italian="Male", spanish="Male"})
  elseif ((SV.SkyVars or {}).HERO_TALK_KIND or 0) == 5 then -- message_SwitchMonologue($HERO_TALK_KIND) case 5
  SkySceneKit.say({english="Female", french="Female", german="Female", italian="Female", spanish="Female"})
  else
  SkySceneKit.say({english="Mystery", french="Mystery", german="Mystery", italian="Mystery", spanish="Mystery"})
  end
  GAME:WaitFrames(20)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Male", french="Male", german="Male", italian="Male", spanish="Male"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Yo!", french="Yo!", german="Yo!", italian="Yo!", spanish="Yo!"})
  else
  SkySceneKit.say({english="Hey!", french="Hey!", german="Hey!", italian="Hey!", spanish="Hey!"})
  end
  -- message_Close
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Good-bye.", french="Good-bye.", german="Good-bye.", italian="Good-bye.", spanish="Good-bye."})
  -- message_Close
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Good-bye.", french="Good-bye.", german="Good-bye.", italian="Good-bye.", spanish="Good-bye."})
  GAME:WaitFrames(30)
  -- message_CloseEnforce
  -- JumpCommon(CORO_END_TALK) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
end
