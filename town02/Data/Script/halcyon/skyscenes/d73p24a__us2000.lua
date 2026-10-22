-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P24A/us2000.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp(29, 76) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 76]
  -- @label_0 [étiquette de flux ExplorerScript]
  elseif (SkyProg.cmp(29, 75) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 75]
  elseif (SkyProg.cmp(29, 73) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 73]
  elseif (SkyProg.cmp(29, 72) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 72]
  elseif (SkyProg.cmp(29, 71) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 71]
  elseif (SkyProg.cmp(29, 70) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 70]
  elseif (SkyProg.cmp(29, 69) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 69]
  else
  end
end
