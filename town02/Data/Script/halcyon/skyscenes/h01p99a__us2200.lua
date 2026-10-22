-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/us2200.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp(29, 92) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 92]
  -- @label_0 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_RECURITABLE_IN_TEAM"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_RECURITABLE_IN_T) [ProcessSpecial(PROCESS_SPECIAL_IS_RECURITABLE_IN_TEAM): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  -- @label_6 [étiquette de flux ExplorerScript]
  elseif true then -- default
  -- supervision_Station(6) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif (SkyProg.cmp(29, 91) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 91]
  -- supervision_Station(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 90) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 90]
  -- supervision_Station(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 89) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 89]
  -- supervision_Station(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 88) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 88]
  -- supervision_Station(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif (SkyProg.cmp(29, 87) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 87]
  -- supervision_Station(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  end
end
