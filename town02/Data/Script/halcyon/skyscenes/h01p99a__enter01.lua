-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H01P99A/enter01.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 then
  -- @label_0 [étiquette de flux ExplorerScript]
  if (SkyProg.cmp_side(40, 1) == 0) then -- if ROM: scn($SCENARIO_SIDE) == [40, 1]
  GAME:FadeOut(false,  30)
  -- screen2_FadeOut [sub déjà caché]
  GAME:WaitFrames(2) -- join WaitScreenFade
  GAME:WaitFrames(2) -- join WaitScreenFadeAll
  GAME:FadeOut(false, 0)
  GAME:FadeIn(0)
  -- supervision_ExecuteCommon(CORO_EVENT_N01_05_07) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- @label_1 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).GROUND_ENTER or -1) -- switch($GROUND_ENTER) [GameVar GROUND_ENTER: point d'entrée du ground]
  if __sw == 218 then
  -- debug_Print('BGM_FADEOUT') [neutre/état moteur]
  pcall(function() SOUND:FadeOutBGM(60) end)
  -- @label_4 [étiquette de flux ExplorerScript]
  -- main_EnterGround(LEVEL_T01P02A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif true then -- default
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif __sw == 2 then
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  if (SkyProg.cmp(12, 3) == 0) then -- if ROM: scn($SCENARIO_MAIN) == [12, 3]
  GAME:FadeOut(false,  30)
  -- screen2_FadeOut [sub déjà caché]
  GAME:WaitFrames(2) -- join WaitScreenFade
  GAME:WaitFrames(2) -- join WaitScreenFadeAll
  GAME:FadeOut(false, 0)
  GAME:FadeIn(0)
  -- supervision_ExecuteCommon(CORO_EVENT_M11_05) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
end
