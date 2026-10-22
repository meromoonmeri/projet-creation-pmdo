-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P02A/enter02.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 or __sw == 2 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- main_EnterGround(LEVEL_G01P03A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif true then -- default
  if (SkyProg.cmp(6, 2) == 0) then -- if ROM: scn($SCENARIO_MAIN) == [6, 2]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M00_01) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  elseif (SkyProg.cmp(7, 1) == 0) then -- elseif ROM: scn($SCENARIO_MAIN) == [7, 1]
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M06_02) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  GAME:WaitFrames(1) -- hold
  elseif (SkyProg.cmp(23, 1) == 0) then -- elseif ROM: scn($SCENARIO_MAIN) == [23, 1]
  -- debug_Print('BGM_FADEOUT') [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(60) end)
  GAME:FadeOut(false, 30)
  -- supervision_ExecuteCommon(CORO_EVENT_M22_03) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
end
