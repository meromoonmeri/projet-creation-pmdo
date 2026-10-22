-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/um0500.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp(6, 5) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [6, 5]
  -- @label_0 [étiquette de flux ExplorerScript]
  elseif (SkyProg.cmp(6, 0) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [6, 0]
  else
  end
end
