-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P02A/m02a0106.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_G01P02A) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(208, 196, 1, false) end)
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:FadeIn(30)
  GAME:WaitFrames(30)
  pcall(function() SOUND:PlayBattleSE("EVT_Emote_Exclaim_Surprised") end)
  pcall(function() GROUND:CharSetEmote(partner, "exclaim", 1) end)
  GAME:WaitFrames(2) -- join WaitEffect
  GAME:WaitFrames(2) -- join WaitExecuteLives
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english="Th-there's a hatch that leads\nunderground here!", french="Il y a... il y a une échelle qui\nmène sous terre!", german="D-da ist eine Luke, die nach\nunten führt!", italian="Q-Qui c'è una scala che porta di\nsotto!", spanish=" ¡Hay una escalera para bajar!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english="Th-there's a hatch that leads\nunderground here!", french="Il y a... il y a une échelle qui\nmène sous terre!", german="D-da ist eine Luke, die nach\nunten führt!", italian="Q-Qui c'è una scala che porta di\nsotto!", spanish=" ¡Hay una escalera para bajar!"})
  else
  SkySceneKit.say({english="Th-there's a hatch that leads\nunderground here!", french="Il y a... il y a une échelle qui\nmène sous terre!", german="D-da ist eine Luke, die nach\nunten führt!", italian="Q-Qui c'è una scala che porta di\nsotto!", spanish=" ¡Hay una escalera para bajar!"})
  end
  -- message_Close
  GROUND:MoveToPosition(hero, 204, 164, false, 2)
  GAME:WaitFrames(20)
  GROUND:MoveToPosition(partner, 204, 164, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- Destroy() [neutre/état moteur]
  GAME:FadeOut(false, 30)
end
