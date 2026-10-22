-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P07A/enter00.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 then
  SkySceneKit.play_scene("g01p07a__un0100", "g01p07a__un01", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P07A, 'UN01', 0) [chaînage scène ROM]
  -- @label_4 [étiquette de flux ExplorerScript]
  if ((SV.SkyScenarioBitFlags or {})[7] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[7]
  SV.SkyScenarioBitFlags = SV.SkyScenarioBitFlags or {}; SV.SkyScenarioBitFlags[7] = 0 -- $SCENARIO_MAIN_BIT_FLAG[7] = 0 (ROM)
  -- supervision_StationCommon(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_18 [étiquette de flux ExplorerScript]
  -- debug_Print('SET_BGM') [neutre/état moteur]
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  else
  -- @label_17 [étiquette de flux ExplorerScript]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  elseif true then -- default
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 then
  -- supervision_StationCommon(21) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 2 then
  -- supervision_StationCommon(41) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_18 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  elseif __sw == 2 then
  SkySceneKit.play_scene("g01p07a__un0400", "g01p07a__un04", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P07A, 'UN04', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_3 [étiquette de flux ExplorerScript]
  if (SkyProg.cmp(29, 5) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 5]
  -- @label_5 [étiquette de flux ExplorerScript]
  do local __sw = select(1, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[0]) [scn($SCENARIO_MAIN)[0]: chapitre courant]
  if __sw == 29 then
  if (SkyProg.cmp(29, 93) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 93]
  SkySceneKit.play_scene("g01p07a__us2300", "g01p07a__us23", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P07A, 'US23', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 86) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 86]
  SkySceneKit.play_scene("g01p07a__us2200", "g01p07a__us22", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P07A, 'US22', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 77) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 77]
  SkySceneKit.play_scene("g01p07a__us2100", "g01p07a__us21", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P07A, 'US21', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 68) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 68]
  SkySceneKit.play_scene("g01p07a__us2000", "g01p07a__us20", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P07A, 'US20', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54]
  SkySceneKit.play_scene("g01p07a__us0400", "g01p07a__us04", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P07A, 'US04', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 40) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 40]
  SkySceneKit.play_scene("g01p07a__us0300", "g01p07a__us03", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P07A, 'US03', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 32) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 32]
  SkySceneKit.play_scene("g01p07a__us0200", "g01p07a__us02", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P07A, 'US02', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 7]
  SkySceneKit.play_scene("g01p07a__us3100", "g01p07a__us31", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P07A, 'US31', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 0) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 0]
  -- @label_15 [étiquette de flux ExplorerScript]
  SkySceneKit.play_scene("g01p07a__us0100", "g01p07a__us01", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P07A, 'US01', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_15 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  else
  -- supervision_StationCommon(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_5 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  elseif true then -- default
  GAME:FadeOut(false,  0)
  -- back_SetGround(LEVEL_G01P07A) [neutre/état moteur]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
