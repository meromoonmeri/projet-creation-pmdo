-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P19P01A/enter05.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  if (SkyProg.cmp_side(42, 5) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [42, 5]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_SET_N03_19') [neutre/état moteur]
  -- supervision_ExecuteCommon(CORO_EVENT_N03_19) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  elseif (SkyProg.cmp_side(42, 2) >= 0) then -- elseif ROM: scn($SCENARIO_SIDE) >= [42, 2]
  -- @label_1 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_SET_N03_18') [neutre/état moteur]
  -- supervision_ExecuteCommon(CORO_EVENT_N03_18) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  else
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
end
