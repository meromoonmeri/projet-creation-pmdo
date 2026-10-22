-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/V03P07A/m08a0202.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  -- back_SetGround(LEVEL_V03P07A) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1)
  local npc_npc_juputoru = SkySceneKit.spawn_npc("grovyle", 160, 256, Direction.Up, "NPC_JUPUTORU")
  -- SetAnimation(42) [anim idle native]
  -- camera_SetMyself() [neutre/état moteur]
  -- SetAnimation(3) [anim idle native]
  -- SetAnimation(3) [anim idle native]
  GAME:FadeIn(30)
  pcall(function() SOUND:PlayBGM("Time Gear Remix.ogg", true) end)
  GAME:WaitFrames(50)
  GROUND:MoveToPosition(npc_npc_juputoru, 156, 164, false, 2)
  GAME:WaitFrames(2) -- join WaitExecuteLives
  -- SetAnimation(256) [anim idle native]
  GAME:WaitFrames(60)
  GAME:FadeOut(false, 15)
  GAME:WaitFrames(30)
  -- message_ResetActor() [neutre/état moteur]
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english=" This is the second one!", french=" C'est le deuxième!", german=" Es ist das zweite!", italian=" È il secondo!", spanish=" Este es el segundo."})
  -- message_Close
  GAME:FadeOut(false, 15)
  SkySceneKit.cleanup_npcs()
end
