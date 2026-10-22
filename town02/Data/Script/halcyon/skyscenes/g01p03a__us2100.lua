-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/us2100.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp(29, 85) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 85]
  -- @label_0 [étiquette de flux ExplorerScript]
  elseif (SkyProg.cmp(29, 84) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 84]
  elseif (SkyProg.cmp(29, 83) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 83]
  elseif (SkyProg.cmp(29, 82) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 82]
  elseif (SkyProg.cmp(29, 81) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 81]
  elseif (SkyProg.cmp(29, 80) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 80]
  -- supervision_Station(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 78) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 78]
  -- supervision_Station(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  end
end
