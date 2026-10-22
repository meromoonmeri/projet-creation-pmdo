-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/um0705.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  if ((SV.SkyScenarioBitFlags or {})[9] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[9]
  -- @label_0 [étiquette de flux ExplorerScript]
  else
  -- SetAnimation(2) [anim idle native]
  -- SetAnimation(2) [anim idle native]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[9] = 1 -- $SCENARIO_MAIN_BIT_FLAG[9] = 1 (ROM)
  -- supervision_Remove(11) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_ExecuteCommon(CORO_EVENT_M00_02) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
end
