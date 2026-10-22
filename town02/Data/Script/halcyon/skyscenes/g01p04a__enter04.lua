-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P04A/enter04.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 then
  -- @label_0 [étiquette de flux ExplorerScript]
  if ((SV.SkyScenarioBitFlags or {})[1] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[1]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[1] = 0 -- $SCENARIO_MAIN_BIT_FLAG[1] = 0 (ROM)
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_N01_10CHOUREI) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- return [fin de routine SSB]
  else
  -- @label_2 [étiquette de flux ExplorerScript]
  -- main_EnterGround(LEVEL_G01P08A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  end
  elseif true then -- default
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
