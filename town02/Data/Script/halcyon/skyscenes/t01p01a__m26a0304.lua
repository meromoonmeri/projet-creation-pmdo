-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m26a0304.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:PlayBGM("Time Restored.ogg", true) end)
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(99) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  -- camera_SetMyself() [neutre/état moteur]
  pcall(function() local g=GAME:GetCurrentGround(); GAME:MoveCamera(g.ViewCenter.X+(-200), g.ViewCenter.Y+(0), 400, false) end) -- MovePositionOffset performer/caméra
  local npc_npc_kemusso = SkySceneKit.spawn_npc("wurmple", 216, 200, Direction.Right, "NPC_KEMUSSO")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_oosubame = SkySceneKit.spawn_npc("swellow", 248, 200, Direction.Left, "NPC_OOSUBAME")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_heigani = SkySceneKit.spawn_npc("corphish", 328, 224, Direction.UpRight, "NPC_HEIGANI")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_himeguma = SkySceneKit.spawn_npc("teddiursa", 360, 160, Direction.DownRight, "NPC_HIMEGUMA")
  -- SetAnimation(4) [anim idle native]
  local npc_npc_bippa = SkySceneKit.spawn_npc("bidoof", 520, 200, Direction.Up, "NPC_BIPPA")
  -- SetAnimation(4) [anim idle native]
  pcall(function() GROUND:CharSetEmote(npc_npc_himeguma, "happy", 1) end)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(60)
  pcall(function() UI:SetSpeaker(partner) end) -- message_SetActor(ACTOR_ATTENDANT1)
  if ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 1 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 1
  SkySceneKit.say({english=" It's Treasure Town!", french=" C'est Bourg-Trésor!", german=" Das ist Schatzstadt!", italian=" È Borgo Tesoro!", spanish=" ¡Es Aldea Tesoro!"})
  elseif ((SV.SkyVars or {}).PARTNER_TALK_KIND or 0) == 2 then -- message_SwitchTalk($PARTNER_TALK_KIND) case 2
  SkySceneKit.say({english=" It's Treasure Town!", french=" C'est Bourg-Trésor!", german=" Das ist Schatzstadt!", italian=" È Borgo Tesoro!", spanish=" ¡Es Aldea Tesoro!"})
  else
  SkySceneKit.say({english=" It's Treasure Town!", french=" C'est Bourg-Trésor!", german=" Das ist Schatzstadt!", italian=" È Borgo Tesoro!", spanish=" ¡Es Aldea Tesoro!"})
  end
  GAME:WaitFrames(240)
  -- message_CloseEnforce
  GAME:FadeOut(false,  60)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  SkySceneKit.cleanup_npcs()
end
