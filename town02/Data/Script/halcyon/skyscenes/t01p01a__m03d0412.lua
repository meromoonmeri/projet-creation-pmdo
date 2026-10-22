-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P01A/m03d0412.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_T01P01A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_LoadStation(LEVEL_T01P01A, 'UM03') [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Station(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera_SetMyself() [neutre/état moteur]
  GAME:FadeOut(false, 0) -- screen_FlushOut
  GAME:WaitFrames(1)
  local npc_npc_suriipu = SkySceneKit.spawn_npc("drowzee", 360, 168, Direction.Right, "NPC_SURIIPU")
  GROUND:MoveToPosition(npc_npc_suriipu, 400, 196, false, 2)
  -- CallCommon CORO_FADE_OUT_ALL_BEFORE (fermeture/attente message: géré par say())
  GAME:FadeIn(30)
  GAME:WaitFrames(45)
  pcall(function() GROUND:CharSetEmote(hero, "shock", 1) end)
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(4), p.Y+(0), false, 2) end
  do local p=hero.Position; GROUND:MoveToPosition(hero, p.X+(-4), p.Y+(0), false, 2) end -- SlidePositionOffset
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() GROUND:CharTurnToCharAnimated(npc_npc_suriipu, hero, 4) end)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  pcall(function() UI:SetSpeaker(npc_npc_suriipu) end)
  SkySceneKit.say({english=" Whoops![K] Excuse me.", french=" Oh![K] Pardon.", german=" Hoppla![K] Entschuldigung.", italian=" Ops![K] Scusa.", spanish=" ¡Vaya![K] Perdón."})
  -- message_Close
  GAME:FadeOut(false,  30)
  -- CallCommon CORO_FADE_OUT_ALL_AFTER (fermeture/attente message: géré par say())
  GAME:FadeIn(0) -- screen_FlushIn
  SkySceneKit.cleanup_npcs()
end
