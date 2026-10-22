-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/T01P03A/enter01.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 or __sw == 2 then
  -- @label_0 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 325 then
  -- debug_Print('BGM_FADEOUT') [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- @label_4 [étiquette de flux ExplorerScript]
  -- main_EnterGround(LEVEL_T01P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif true then -- default
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  if (SkyProg.cmp(29, 1) == 0) then -- if ROM: scn($SCENARIO_MAIN) == [29, 1]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_S01_02) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  elseif (SkyProg.cmp(29, 98) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 98]
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 or __sw == 1 or __sw == 2 or __sw == 4 or __sw == 3 then
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  if ((SV.SkyScenarioBitFlags or {})[95] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[95]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[95] = 1 -- $SCENARIO_MAIN_BIT_FLAG[95] = 1 (ROM)
  GAME:FadeOut(false,  30)
  -- screen2_FadeOut [sub déjà caché]
  GAME:WaitFrames(2) -- join WaitScreenFade
  GAME:WaitFrames(2) -- join WaitScreenFadeAll
  GAME:FadeOut(false, 0)
  GAME:FadeIn(0)
  -- supervision_ExecuteCommon(CORO_EVENT_M00_14) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  end
  end
  end
  else
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
end
