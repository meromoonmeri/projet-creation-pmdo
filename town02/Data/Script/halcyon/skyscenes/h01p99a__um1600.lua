-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/um1600.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- supervision_Station(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp(17, 3) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [17, 3]
  -- @label_0 [étiquette de flux ExplorerScript]
  if ((SV.SkyTalkBitFlags or {})[24] == 1) then -- if ROM: $SCENARIO_TALK_BIT_FLAG[24]
  -- @label_2 [étiquette de flux ExplorerScript]
  else
  -- supervision_Station(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (SkyProg.cmp(17, 1) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [17, 1]
  -- supervision_Station(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  end
end
