-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/H02P99A/enter00.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- debug_Print('INSIDE') [neutre/état moteur]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp(29, 5) < 0) then -- if ROM: scn($SCENARIO_MAIN) < [29, 5]
  -- @label_1 [étiquette de flux ExplorerScript]
  do local __sw = select(1, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[0]) [scn($SCENARIO_MAIN)[0]: chapitre courant]
  if __sw == 23 then
  SkySceneKit.play_scene("h02p99a__um2200", "h02p99a__um22", hero, partner) -- supervision_ExecuteStationSub(LEVEL_H02P99A, 'UM22', 0) [chaînage scène ROM]
  -- @label_4 [étiquette de flux ExplorerScript]
  if ((SV.SkyScenarioBitFlags or {})[7] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[7]
  -- debug_Print('SAMEHADA_RESUME') [neutre/état moteur]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[7] = 0 -- $SCENARIO_MAIN_BIT_FLAG[7] = 0 (ROM)
  -- supervision_StationCommon(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_16 [étiquette de flux ExplorerScript]
  -- debug_Print('SET_BGM') [neutre/état moteur]
  if (SkyProg.cmp(29, 5) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 5]
  -- GAP: BGM BGM_DO_YOUR_BEST_AS_ALWAYS non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- @label_20 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- jump @label_20 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  -- @label_15 [étiquette de flux ExplorerScript]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  elseif true then -- default
  do local __sw = ((SV.SkyVars or {}).GROUND_GETOUT or -1) -- switch($GROUND_GETOUT) [GameVar GROUND_GETOUT: sortie précédente]
  if true then -- default
  end
  end
  -- @label_18 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_16 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif __sw == 29 then
  if (SkyProg.cmp(29, 93) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 93]
  SkySceneKit.play_scene("h02p99a__us2300", "h02p99a__us23", hero, partner) -- supervision_ExecuteStationSub(LEVEL_H02P99A, 'US23', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 86) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 86]
  SkySceneKit.play_scene("h02p99a__us2200", "h02p99a__us22", hero, partner) -- supervision_ExecuteStationSub(LEVEL_H02P99A, 'US22', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 77) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 77]
  SkySceneKit.play_scene("h02p99a__us2100", "h02p99a__us21", hero, partner) -- supervision_ExecuteStationSub(LEVEL_H02P99A, 'US21', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 68) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 68]
  SkySceneKit.play_scene("h02p99a__us2000", "h02p99a__us20", hero, partner) -- supervision_ExecuteStationSub(LEVEL_H02P99A, 'US20', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54]
  SkySceneKit.play_scene("h02p99a__us0400", "h02p99a__us04", hero, partner) -- supervision_ExecuteStationSub(LEVEL_H02P99A, 'US04', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 40) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 40]
  SkySceneKit.play_scene("h02p99a__us0300", "h02p99a__us03", hero, partner) -- supervision_ExecuteStationSub(LEVEL_H02P99A, 'US03', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 32) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 32]
  SkySceneKit.play_scene("h02p99a__us0200", "h02p99a__us02", hero, partner) -- supervision_ExecuteStationSub(LEVEL_H02P99A, 'US02', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 7]
  SkySceneKit.play_scene("h02p99a__us3100", "h02p99a__us31", hero, partner) -- supervision_ExecuteStationSub(LEVEL_H02P99A, 'US31', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 0) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 0]
  -- @label_13 [étiquette de flux ExplorerScript]
  SkySceneKit.play_scene("h02p99a__us0100", "h02p99a__us01", hero, partner) -- supervision_ExecuteStationSub(LEVEL_H02P99A, 'US01', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_13 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else
  -- supervision_StationCommon(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  GAME:FadeOut(false,  0)
  -- back_SetGround(LEVEL_H02P99A) [neutre/état moteur]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
