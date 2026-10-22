-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D73P31A/enter11.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- debug_Print('START') [neutre/état moteur]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_IS_RECURITABLE_IN_TEAM"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_IS_RECURITABLE_IN_T) [ProcessSpecial(PROCESS_SPECIAL_IS_RECURITABLE_IN_TEAM): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 1 then
  -- @label_1 [étiquette de flux ExplorerScript]
  if (SkyProg.cmp(29, 93) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 93]
  SkySceneKit.play_scene("d73p31a__us2300", "d73p31a__us23", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P31A, 'US23', 0) [chaînage scène ROM]
  -- @label_10 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(7) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- debug_Print('LABEL_TEAM_SET') [neutre/état moteur]
  -- supervision_StationCommon(9) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_11 [étiquette de flux ExplorerScript]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_12 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_END') [neutre/état moteur]
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  -- debug_Print('LABEL_PLAYER_SET') [neutre/état moteur]
  do local __sw = ((SV.SkyVars or {}).GROUND_GETOUT or -1) -- switch($GROUND_GETOUT) [GameVar GROUND_GETOUT: sortie précédente]
  if __sw == 430 then
  -- debug_Print('LABEL_FROM_VISUAL') [neutre/état moteur]
  -- supervision_StationCommon(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_14 [étiquette de flux ExplorerScript]
  -- debug_Print('SET_BGM') [neutre/état moteur]
  pcall(function() SOUND:PlayBGM("Time Restored.ogg", true) end)
  -- @label_15 [étiquette de flux ExplorerScript]
  -- debug_Print('LABEL_ENTER_END') [neutre/état moteur]
  -- jump @label_12 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_14 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif (SkyProg.cmp(29, 86) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 86]
  SkySceneKit.play_scene("d73p31a__us2200", "d73p31a__us22", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P31A, 'US22', 0) [chaînage scène ROM]
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 77) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 77]
  SkySceneKit.play_scene("d73p31a__us2100", "d73p31a__us21", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P31A, 'US21', 0) [chaînage scène ROM]
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 68) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 68]
  SkySceneKit.play_scene("d73p31a__us2000", "d73p31a__us20", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P31A, 'US20', 0) [chaînage scène ROM]
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54]
  SkySceneKit.play_scene("d73p31a__us0400", "d73p31a__us04", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P31A, 'US04', 0) [chaînage scène ROM]
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 40) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 40]
  SkySceneKit.play_scene("d73p31a__us0300", "d73p31a__us03", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P31A, 'US03', 0) [chaînage scène ROM]
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 32) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 32]
  SkySceneKit.play_scene("d73p31a__us0200", "d73p31a__us02", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P31A, 'US02', 0) [chaînage scène ROM]
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 7]
  -- @label_9 [étiquette de flux ExplorerScript]
  SkySceneKit.play_scene("d73p31a__us3100", "d73p31a__us31", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D73P31A, 'US31', 0) [chaînage scène ROM]
  -- jump @label_10 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_9 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  GAME:FadeOut(false,  0)
  -- debug_Print('LABEL_BACK_SET') [neutre/état moteur]
  -- back_SetGround(LEVEL_D73P31A) [neutre/état moteur]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
