-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P01A/us0300.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp(29, 53) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 53]
  -- @label_0 [étiquette de flux ExplorerScript]
  elseif (SkyProg.cmp(29, 52) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 52]
  elseif (SkyProg.cmp(29, 50) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 50]
  elseif (SkyProg.cmp(29, 49) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 49]
  elseif (SkyProg.cmp(29, 48) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 48]
  elseif (SkyProg.cmp(29, 47) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 47]
  elseif (SkyProg.cmp(29, 46) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 46]
  elseif (SkyProg.cmp(29, 45) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 45]
  elseif (SkyProg.cmp(29, 44) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 44]
  elseif (SkyProg.cmp(29, 43) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 43]
  elseif (SkyProg.cmp(29, 42) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 42]
  elseif (SkyProg.cmp(29, 41) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 41]
  elseif (SkyProg.cmp(29, 40) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 40]
  else
  end
end
