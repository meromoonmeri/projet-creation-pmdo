-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P31A/us0305.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp(29, 31) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 31]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_Station(23) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 30) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 30]
  elseif (SkyProg.cmp(29, 29) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 29]
  elseif (SkyProg.cmp(29, 28) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 28]
  elseif (SkyProg.cmp(29, 27) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 27]
  elseif (SkyProg.cmp(29, 26) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 26]
  elseif (SkyProg.cmp(29, 25) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 25]
  elseif (SkyProg.cmp(29, 24) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 24]
  elseif (SkyProg.cmp(29, 23) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 23]
  elseif (SkyProg.cmp(29, 22) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 22]
  elseif (SkyProg.cmp(29, 21) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 21]
  elseif (SkyProg.cmp(29, 20) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 20]
  elseif (SkyProg.cmp(29, 19) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 19]
  elseif (SkyProg.cmp(29, 18) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 18]
  elseif (SkyProg.cmp(29, 17) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 17]
  elseif (SkyProg.cmp(29, 16) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 16]
  elseif (SkyProg.cmp(29, 15) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 15]
  elseif (SkyProg.cmp(29, 14) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 14]
  elseif (SkyProg.cmp(29, 13) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 13]
  elseif (SkyProg.cmp(29, 12) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 12]
  elseif (SkyProg.cmp(29, 11) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 11]
  elseif (SkyProg.cmp(29, 10) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 10]
  elseif (SkyProg.cmp(29, 8) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 8]
  -- @label_22 [étiquette de flux ExplorerScript]
  else
  -- jump @label_22 [saut final de branche vers l'épilogue commun: flux naturel]
  end
end
