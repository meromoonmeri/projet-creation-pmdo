-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D32P12A/enter00.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  elseif true then -- default
  if (SkyProg.cmp(29, 67) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 67]
  -- @label_2 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_4 [étiquette de flux ExplorerScript]
  -- debug_Print('SET_BGM') [neutre/état moteur]
  -- GAP: BGM BGM_IN_THE_DEPTHS_OF_THE_PIT non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif ((SV.SkyScenarioBitFlags or {})[44] == 1) then -- elseif ROM: $SCENARIO_MAIN_BIT_FLAG[44]
  -- supervision_StationCommon(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif true then -- default
  GAME:FadeOut(false,  0)
  -- back_SetGround(LEVEL_D32P12A) [neutre/état moteur]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
