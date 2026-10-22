-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P01A/us0200.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp(29, 39) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 39]
  -- @label_0 [étiquette de flux ExplorerScript]
  elseif (SkyProg.cmp(29, 33) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 33]
  elseif (SkyProg.cmp(29, 32) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 32]
  else
  end
end
