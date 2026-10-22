-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D57P21A/enter01.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- SetAnimation(2) [anim idle native]
  if (SkyProg.cmp_side(43, 8) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [43, 8]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_ExecuteCommon(CORO_EVENT_N04_19) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- supervision_ExecuteCommon(CORO_EVENT_N04_17) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  end
end
