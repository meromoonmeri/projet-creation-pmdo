-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T00P01/m01a07a.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- debug_Print('acting_M01A07A') [neutre/état moteur]
  GAME:WaitFrames(1) -- with(...){hold} NDS
  GAME:WaitFrames(1) -- with(...){hold} NDS
  GAME:FadeOut(false, 30)
  -- back_SetGround(LEVEL_T00P01) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_Acting(0) [neutre/état moteur]
  GAME:WaitFrames(1) -- with(...){hold} NDS
  GAME:WaitFrames(1) -- with(...){hold} NDS
  GAME:FadeIn(30)
  pcall(function() UI:SetSpeaker(partner) end)
  SkySceneKit.say({english="Acting Test under way...", french="Acting Test under way...", german="Acting Test under way...", italian="Acting Test under way...", spanish="Acting Test under way..."})
  -- message_Close
  SkySceneKit.play_scene("t00p01__m01a0700", "t00p01__m01a07", hero, partner) -- supervision_ExecuteStation(LEVEL_T00P01, 'M01A07', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
end
