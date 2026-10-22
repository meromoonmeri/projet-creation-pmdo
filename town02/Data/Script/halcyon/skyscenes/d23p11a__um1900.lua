-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D23P11A/um1900.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- switch(sector()) corps vide [sector(): acting principal (kit PMDO)]
  if (SkyProg.cmp(20, 4) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [20, 4]
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_Station(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(20, 3) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [20, 3]
  -- supervision_Station(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  end
end
