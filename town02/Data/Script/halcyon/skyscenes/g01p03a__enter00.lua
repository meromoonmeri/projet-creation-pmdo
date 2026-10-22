-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P03A/enter00.ssb (ROM sha256 1fa39d35…).
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
  SkySceneKit.play_scene("g01p03a__un0100", "g01p03a__un01", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UN01', 0) [chaînage scène ROM]
  -- @label_4 [étiquette de flux ExplorerScript]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  elseif true then -- default
  do local __sw = ((SV.SkyVars or {}).GROUND_GETOUT or -1) -- switch($GROUND_GETOUT) [GameVar GROUND_GETOUT: sortie précédente]
  if __sw == 203 then
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 then
  -- supervision_StationCommon(22) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_46 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 2 then
  -- supervision_StationCommon(42) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_46 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- supervision_StationCommon(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_46 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 then
  -- supervision_StationCommon(21) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_46 [étiquette de flux ExplorerScript]
  -- debug_Print('SET_BGM') [neutre/état moteur]
  pcall(function() SOUND:PlayBGM("Wigglytuff's Guild.ogg", true) end)
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif __sw == 2 then
  -- supervision_StationCommon(41) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_46 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_46 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  end
  elseif __sw == 2 then
  SkySceneKit.play_scene("g01p03a__un0400", "g01p03a__un04", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UN04', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_3 [étiquette de flux ExplorerScript]
  do local __sw = select(1, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[0]) [scn($SCENARIO_MAIN)[0]: chapitre courant]
  if __sw == 4 then
  SkySceneKit.play_scene("g01p03a__um0300", "g01p03a__um03", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM03', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  SkySceneKit.play_scene("g01p03a__um0400", "g01p03a__um04", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM04', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 6 then
  SkySceneKit.play_scene("g01p03a__um0500", "g01p03a__um05", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM05', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 7 then
  SkySceneKit.play_scene("g01p03a__um0600", "g01p03a__um06", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM06', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 8 then
  SkySceneKit.play_scene("g01p03a__um0700", "g01p03a__um07", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM07', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 9 then
  SkySceneKit.play_scene("g01p03a__um0800", "g01p03a__um08", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM08', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 12 then
  SkySceneKit.play_scene("g01p03a__um1100", "g01p03a__um11", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM11', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 13 then
  SkySceneKit.play_scene("g01p03a__um1200", "g01p03a__um12", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM12', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 14 then
  SkySceneKit.play_scene("g01p03a__um1300", "g01p03a__um13", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM13', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 15 then
  SkySceneKit.play_scene("g01p03a__um1400", "g01p03a__um14", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM14', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 16 then
  SkySceneKit.play_scene("g01p03a__um1500", "g01p03a__um15", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM15', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 17 then
  SkySceneKit.play_scene("g01p03a__um1600", "g01p03a__um16", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM16', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 18 then
  SkySceneKit.play_scene("g01p03a__um1700", "g01p03a__um17", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM17', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 19 then
  SkySceneKit.play_scene("g01p03a__um1800", "g01p03a__um18", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM18', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 20 then
  SkySceneKit.play_scene("g01p03a__um1900", "g01p03a__um19", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM19', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 21 then
  SkySceneKit.play_scene("g01p03a__um2000", "g01p03a__um20", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM20', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 22 then
  SkySceneKit.play_scene("g01p03a__um2100", "g01p03a__um21", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM21', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 23 then
  SkySceneKit.play_scene("g01p03a__um2200", "g01p03a__um22", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM22', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 24 then
  SkySceneKit.play_scene("g01p03a__um2300", "g01p03a__um23", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM23', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 25 then
  SkySceneKit.play_scene("g01p03a__um2400", "g01p03a__um24", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM24', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 26 then
  SkySceneKit.play_scene("g01p03a__um2500", "g01p03a__um25", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM25', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 27 then
  SkySceneKit.play_scene("g01p03a__um2600", "g01p03a__um26", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'UM26', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 29 then
  if (SkyProg.cmp(29, 93) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 93]
  SkySceneKit.play_scene("g01p03a__us2300", "g01p03a__us23", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'US23', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 86) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 86]
  SkySceneKit.play_scene("g01p03a__us2200", "g01p03a__us22", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'US22', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 77) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 77]
  SkySceneKit.play_scene("g01p03a__us2100", "g01p03a__us21", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'US21', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 68) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 68]
  SkySceneKit.play_scene("g01p03a__us2000", "g01p03a__us20", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'US20', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54]
  SkySceneKit.play_scene("g01p03a__us0400", "g01p03a__us04", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'US04', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 40) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 40]
  SkySceneKit.play_scene("g01p03a__us0300", "g01p03a__us03", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'US03', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 32) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 32]
  SkySceneKit.play_scene("g01p03a__us0200", "g01p03a__us02", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'US02', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 7]
  SkySceneKit.play_scene("g01p03a__us3100", "g01p03a__us31", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'US31', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 0) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 0]
  -- @label_40 [étiquette de flux ExplorerScript]
  SkySceneKit.play_scene("g01p03a__us0100", "g01p03a__us01", hero, partner) -- supervision_ExecuteStationSub(LEVEL_G01P03A, 'US01', 0) [chaînage scène ROM]
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_40 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  -- jump @label_4 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif true then -- default
  GAME:FadeOut(false,  0)
  -- back_SetGround(LEVEL_G01P03A) [neutre/état moteur]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
