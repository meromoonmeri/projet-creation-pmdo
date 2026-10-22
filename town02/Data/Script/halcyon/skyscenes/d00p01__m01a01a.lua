-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D00P01/m01a01a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- back_SetGround(LEVEL_D00P01) [neutre/état moteur]
  GAME:FadeIn(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="Set Dungeon Background Display Test", french="Set Dungeon Background Display Test", german="Set Dungeon Background Display Test", italian="Set Dungeon Background Display Test", spanish="Set Dungeon Background Display Test"})
  -- message_Close
  GAME:FadeOut(false, 30)
  SkySceneKit.play_scene("t00p01__m01a0100", "t00p01__m01a01", hero, partner) -- supervision_ExecuteStation(LEVEL_T00P01, 'M01A01', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
end
