-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D45P21A/enter00.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  -- debug_Print('ENTER') [neutre/état moteur]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- debug_Print('CHARA_SET') [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if true then -- default
  end
  end
  -- @label_2 [étiquette de flux ExplorerScript]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_3 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_END') [neutre/état moteur]
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  -- debug_Print('LABEL_PLAYE_SET') [neutre/état moteur]
  -- debug_Print('LABEL_PLAYER_SET_RESUME') [neutre/état moteur]
  if ((SV.SkyScenarioBitFlags or {})[7] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[7]
  -- debug_Print('LABEL_PUPURIN_RESUME') [neutre/état moteur]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[7] = 0 -- $SCENARIO_MAIN_BIT_FLAG[7] = 0 (ROM)
  -- supervision_StationCommon(32) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_6 [étiquette de flux ExplorerScript]
  -- debug_Print('SET_BGM') [neutre/état moteur]
  -- GAP: BGM BGM_FORTUNE_RAVINE_DEPTHS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- debug_Print('LABEL_ENTER_END') [neutre/état moteur]
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- @label_5 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_PUPURIN_SET_NORMAL') [neutre/état moteur]
  -- supervision_StationCommon(31) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif true then -- default
  GAME:FadeOut(false,  0)
  -- debug_Print('LABEL_BACK_SET') [neutre/état moteur]
  -- back_SetGround(LEVEL_D45P21A) [neutre/état moteur]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
