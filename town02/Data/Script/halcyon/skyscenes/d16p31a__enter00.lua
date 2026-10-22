-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D16P31A/enter00.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
return function(hero, partner)
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(8) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(31) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  do local __sw = ((SV.SkyVars or {}).CRYSTAL_COLOR_01 or 0) -- switch($CRYSTAL_COLOR_01) [GameVar CRYSTAL_COLOR_01 (Crevice Cave)]
  if __sw == 2 then
  -- supervision_StationCommon(16) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 0 then
  -- supervision_StationCommon(19) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- supervision_StationCommon(22) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- supervision_StationCommon(25) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 1 then
  -- supervision_StationCommon(28) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_7 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- supervision_StationCommon(13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_7 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).CRYSTAL_COLOR_02 or 0) -- switch($CRYSTAL_COLOR_02) [GameVar CRYSTAL_COLOR_02]
  if __sw == 2 then
  -- supervision_StationCommon(17) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 0 then
  -- supervision_StationCommon(20) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- supervision_StationCommon(23) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- supervision_StationCommon(26) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 1 then
  -- supervision_StationCommon(29) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- supervision_StationCommon(14) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_14 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).CRYSTAL_COLOR_03 or 0) -- switch($CRYSTAL_COLOR_03) [GameVar CRYSTAL_COLOR_03]
  if __sw == 2 then
  -- supervision_StationCommon(18) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 0 then
  -- supervision_StationCommon(21) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 3 then
  -- supervision_StationCommon(24) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 4 then
  -- supervision_StationCommon(27) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 1 then
  -- supervision_StationCommon(30) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_21 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- supervision_StationCommon(15) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_21 [étiquette de flux ExplorerScript]
  if ((SV.SkyScenarioBitFlags or {})[7] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[7]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[7] = 0 -- $SCENARIO_MAIN_BIT_FLAG[7] = 0 (ROM)
  -- supervision_StationCommon(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_24 [étiquette de flux ExplorerScript]
  -- debug_Print('SET_BGM') [neutre/état moteur]
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- @label_23 [étiquette de flux ExplorerScript]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  elseif true then -- default
  -- switch($GROUND_GETOUT) corps vide [GameVar GROUND_GETOUT: sortie précédente]
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_24 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  end
  end
  end
  elseif true then -- default
  GAME:FadeOut(false,  0)
  -- back_SetGround(LEVEL_D16P31A) [neutre/état moteur]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
