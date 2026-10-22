-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D42P21A/enter00.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- debug_Print('START') [neutre/état moteur]
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 then
  -- @label_0 [étiquette de flux ExplorerScript]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 2 -- $EVENT_LOCAL = 2 (ROM)
  -- @label_2 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_CONDITION_SET_END') [neutre/état moteur]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_4 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- debug_Print('LABEL_TEAM_SET') [neutre/état moteur]
  if (((SV.SkyVars or {}).EVENT_LOCAL or 0) == 2) then -- if ROM: $EVENT_LOCAL == 2
  if ((SV.SkyScenarioBitFlags or {})[7] == 1) or (SkyProg.cmp_side(40, 5) >= 0) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[7] || scn($SCENARIO_SIDE) >= [40, 5]
  -- @label_7 [étiquette de flux ExplorerScript]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_8 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_END') [neutre/état moteur]
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  -- debug_Print('LABEL_PLAYER_SET') [neutre/état moteur]
  if ((SV.SkyScenarioBitFlags or {})[4] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[4]
  -- debug_Print('LABEL_REBIRTH') [neutre/état moteur]
  if (((SV.SkyVars or {}).EVENT_LOCAL or 0) == 1) then -- if ROM: $EVENT_LOCAL == 1
  -- debug_Print('LABEL_LEADER_REBIRTH') [neutre/état moteur]
  -- supervision_StationCommon(6) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_12 [étiquette de flux ExplorerScript]
  -- debug_Print('SET_BGM') [neutre/état moteur]
  -- GAP: BGM BGM_DEEP_STAR_CAVE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- debug_Print('LABEL_ENTER_END') [neutre/état moteur]
  if ((SV.SkyScenarioBitFlags or {})[4] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[4]
  if (((SV.SkyVars or {}).EVENT_LOCAL or 0) == 1) then -- if ROM: $EVENT_LOCAL == 1
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[4] = 0 -- $SCENARIO_MAIN_BIT_FLAG[4] = 0 (ROM)
  -- jump @label_8 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- debug_Print('LABEL_REBIRTH_START') [neutre/état moteur]
  GAME:WaitFrames(2) -- join WaitLockLives
  pcall(function() GAME:MoveCamera(228, 284, 1, false) end)
  GAME:FadeIn(30)
  GAME:FadeIn(30)
  SkySceneKit.unlock(0) -- Unlock(0) NDS
  GAME:WaitFrames(15)
  SkySceneKit.unlock(10) -- Unlock(10) NDS
  SkySceneKit.lock(3) -- Lock(3) NDS
  GAME:WaitFrames(15)
  pcall(function() GROUND:CharTurnToCharAnimated(hero, partner, 4) end)
  pcall(function() GROUND:CharTurnToCharAnimated(partner, hero, 4) end)
  GAME:WaitFrames(15)
  SkySceneKit.unlock(0) -- Unlock(0) NDS
  SkySceneKit.unlock(10) -- Unlock(10) NDS
  pcall(function() GAME:MoveCamera(0, 0, 1, true) end) -- caméra défaut
  -- supervision_Suspend(-2) [neutre/état moteur]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[4] = 0 -- $SCENARIO_MAIN_BIT_FLAG[4] = 0 (ROM)
  end
  else
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  else
  -- supervision_StationCommon(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  -- @label_10 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_PLAYER_SET_RESUME') [neutre/état moteur]
  if ((SV.SkyScenarioBitFlags or {})[7] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[7]
  -- debug_Print('LABEL_RESUME') [neutre/état moteur]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[7] = 0 -- $SCENARIO_MAIN_BIT_FLAG[7] = 0 (ROM)
  if (((SV.SkyVars or {}).EVENT_LOCAL or 0) == 1) then -- if ROM: $EVENT_LOCAL == 1
  -- debug_Print('LABEL_LEADER_RESUME') [neutre/état moteur]
  -- supervision_StationCommon(4) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (((SV.SkyVars or {}).EVENT_LOCAL or 0) == 2) then -- elseif ROM: $EVENT_LOCAL == 2
  -- debug_Print('LABEL_BIPPA_RESUME') [neutre/état moteur]
  if (SkyProg.cmp_side(40, 5) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 5]
  -- @label_17 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(24) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- supervision_StationCommon(31) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(23) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_17 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  -- supervision_StationCommon(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  -- @label_14 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_PLAYER_SET_NORMAL') [neutre/état moteur]
  if (((SV.SkyVars or {}).EVENT_LOCAL or 0) == 1) then -- if ROM: $EVENT_LOCAL == 1
  -- debug_Print('LABEL_LEADER_SET') [neutre/état moteur]
  -- supervision_StationCommon(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (((SV.SkyVars or {}).EVENT_LOCAL or 0) == 2) then -- elseif ROM: $EVENT_LOCAL == 2
  -- debug_Print('LABEL_BIPPA_SET') [neutre/état moteur]
  if (SkyProg.cmp_side(40, 5) >= 0) then -- if ROM: scn($SCENARIO_SIDE) >= [40, 5]
  -- @label_20 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(22) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- supervision_StationCommon(21) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  else
  -- supervision_StationCommon(30) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif (((SV.SkyVars or {}).EVENT_LOCAL or 0) == 1) then -- elseif ROM: $EVENT_LOCAL == 1
  -- supervision_StationCommon(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- supervision_StationCommon(8) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  GAME:FadeOut(false,  0)
  -- debug_Print('LABEL_BACK_SET') [neutre/état moteur]
  -- back_SetGround(LEVEL_D42P21A) [neutre/état moteur]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  -- @label_1 [étiquette de flux ExplorerScript]
  if (SkyProg.cmp(29, 5) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 5]
  -- debug_Print('LABEL_CONDITION_SET_LEADER') [neutre/état moteur]
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 1 -- $EVENT_LOCAL = 1 (ROM)
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.EVENT_LOCAL = 0 -- $EVENT_LOCAL = 0 (ROM)
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
end
