-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D22P11A/enter00.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- debug_Print('MAPIN D22P11A') [neutre/état moteur]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- debug_Print('CHARA_SET') [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 4 then
  -- debug_Print('UN08') [neutre/état moteur]
  SkySceneKit.play_scene("d22p11a__un0800", "d22p11a__un08", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D22P11A, 'UN08', 0) [chaînage scène ROM]
  -- @label_3 [étiquette de flux ExplorerScript]
  -- debug_Print('PLAYER_SET') [neutre/état moteur]
  if ((SV.SkyScenarioBitFlags or {})[7] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[7]
  -- debug_Print('PLAYER_RESUME') [neutre/état moteur]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[7] = 0 -- $SCENARIO_MAIN_BIT_FLAG[7] = 0 (ROM)
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 4 then
  -- debug_Print('PLAYER_RESUME_FUTURE') [neutre/état moteur]
  -- supervision_StationCommon(52) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_7 [étiquette de flux ExplorerScript]
  -- debug_Print('SET_BGM') [neutre/état moteur]
  -- GAP: BGM BGM_DUSK_FOREST non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  -- supervision_StationCommon(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else
  -- @label_5 [étiquette de flux ExplorerScript]
  -- debug_Print('PLAYER_SET_NORMAL') [neutre/état moteur]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  elseif true then -- default
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 4 then
  -- supervision_StationCommon(51) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  elseif true then -- default
  do local __sw = select(1, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[0]) [scn($SCENARIO_MAIN)[0]: chapitre courant]
  if __sw == 20 then
  SkySceneKit.play_scene("d22p11a__um1900", "d22p11a__um19", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D22P11A, 'UM19', 0) [chaînage scène ROM]
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif true then -- default
  -- debug_Print('BACK_SET') [neutre/état moteur]
  GAME:FadeOut(false,  0)
  -- back_SetGround(LEVEL_D22P11A) [neutre/état moteur]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
