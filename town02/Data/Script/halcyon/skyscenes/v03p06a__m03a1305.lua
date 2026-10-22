-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P06A/m03a1305.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_V03P06A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  pcall(function() GAME:MoveCamera(204, 156, 1, false) end)
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  GAME:WaitFrames(30)
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" Like in a forest...", french="Ils peuvent se trouver par\nexemple dans une forêt...", german=" Zum Beispiel in einem Wald...", italian=" Ad esempio in una foresta...", spanish="Como por ejemplo en lo más\nprofundo de un bosque..."})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" Like in a forest...", french="Ils peuvent se trouver par\nexemple dans une forêt...", german=" Zum Beispiel in einem Wald...", italian=" Ad esempio in una foresta...", spanish="Como por ejemplo en lo más\nprofundo de un bosque..."})
  else
  SkySceneKit.say({english=" Like in a forest...", french="Ils peuvent se trouver par\nexemple dans une forêt...", german=" Zum Beispiel in einem Wald...", italian=" Ad esempio in una foresta...", spanish="Como por ejemplo en lo más\nprofundo de un bosque..."})
  end
  -- message_Close
  GAME:FadeOut(false, 30)
end
