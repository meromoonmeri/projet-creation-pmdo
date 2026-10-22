-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P17P02A/enter03.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(41, 1) == 0) then -- if ROM: scn($SCENARIO_SIDE) == [41, 1]
  -- @label_0 [étiquette de flux ExplorerScript]
  GAME:FadeOut(false,  30)
  -- screen2_FadeOut [sub déjà caché]
  GAME:WaitFrames(2) -- join WaitScreenFade
  GAME:WaitFrames(2) -- join WaitScreenFadeAll
  GAME:FadeOut(false, 0)
  GAME:FadeIn(0)
  -- supervision_ExecuteCommon(CORO_EVENT_N02_02) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  elseif (SkyProg.cmp_side(42, 0) < 0) then -- elseif ROM: scn($SCENARIO_SIDE) < [42, 0]
  -- supervision_ExecuteCommon(CORO_EVENT_N02_04) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  elseif (SkyProg.cmp_side(42, 0) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [42, 0]
  -- supervision_ExecuteCommon(CORO_EVENT_N03_01) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  else
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
end
