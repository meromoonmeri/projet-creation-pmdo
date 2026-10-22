-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/us2200.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 92]
  -- @label_0 [étiquette de flux ExplorerScript]
  elseif (SkyProg.cmp(29, 91) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91]
  elseif (SkyProg.cmp(29, 90) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 90]
  elseif (SkyProg.cmp(29, 89) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 89]
  elseif (SkyProg.cmp(29, 88) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 88]
  elseif (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 87]
  else
  end
end
