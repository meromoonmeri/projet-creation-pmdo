-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P01A/enter01.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 or __sw == 2 then
  -- @label_0 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 224 then
  -- debug_Print('BGM_FADEOUT') [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- @label_3 [étiquette de flux ExplorerScript]
  -- main_EnterGround(LEVEL_G01P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif true then -- default
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  if (SkyProg.cmp(29, 48) == 0) then -- if ROM: scn($SCENARIO_MAIN) == [29, 48]
  -- supervision_ExecuteCommon(CORO_EVENT_S03_11) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
end
