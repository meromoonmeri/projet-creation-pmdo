-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/P01P04A/enter00.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  -- debug_Print('CAFE') [neutre/état moteur]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(20) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if (SkyProg.cmp(8, 5) == 0) or (SkyProg.cmp(8, 6) == 0) or (SkyProg.cmp(29, 8) == 0) or (SkyProg.cmp(29, 9) == 0) then -- if ROM: scn($SCENARIO_MAIN) == [8, 5] || scn($SCENARIO_MAIN) == [8, 
  -- @label_1 [étiquette de flux ExplorerScript]
  if ((SV.SkyScenarioBitFlags or {})[93] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[93]
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 or __sw == 2 then
  -- @label_3 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(10) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(11) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(12) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- supervision_StationCommon(13) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  do local __sw = select(1, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[0]) [scn($SCENARIO_MAIN)[0]: chapitre courant]
  if __sw == 4 then
  SkySceneKit.play_scene("p01p04a__um0300", "p01p04a__um03", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM03', 0) [chaînage scène ROM]
  -- @label_27 [étiquette de flux ExplorerScript]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  elseif true then -- default
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- debug_Print('SET_BGM') [neutre/état moteur]
  -- GAP: BGM BGM_SPINDAS_CAFE non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  end
  end
  elseif __sw == 5 then
  SkySceneKit.play_scene("p01p04a__um0400", "p01p04a__um04", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM04', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 6 then
  SkySceneKit.play_scene("p01p04a__um0500", "p01p04a__um05", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM05', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 7 then
  SkySceneKit.play_scene("p01p04a__um0600", "p01p04a__um06", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM06', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 8 then
  SkySceneKit.play_scene("p01p04a__um0700", "p01p04a__um07", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM07', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 9 then
  SkySceneKit.play_scene("p01p04a__um0800", "p01p04a__um08", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM08', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 12 then
  SkySceneKit.play_scene("p01p04a__um1100", "p01p04a__um11", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM11', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 13 then
  SkySceneKit.play_scene("p01p04a__um1200", "p01p04a__um12", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM12', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 14 then
  SkySceneKit.play_scene("p01p04a__um1300", "p01p04a__um13", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM13', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 15 then
  SkySceneKit.play_scene("p01p04a__um1400", "p01p04a__um14", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM14', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 16 then
  SkySceneKit.play_scene("p01p04a__um1500", "p01p04a__um15", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM15', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 17 then
  SkySceneKit.play_scene("p01p04a__um1600", "p01p04a__um16", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM16', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 18 then
  SkySceneKit.play_scene("p01p04a__um1700", "p01p04a__um17", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM17', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 19 then
  SkySceneKit.play_scene("p01p04a__um1800", "p01p04a__um18", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM18', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 20 then
  SkySceneKit.play_scene("p01p04a__um1900", "p01p04a__um19", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM19', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 21 then
  SkySceneKit.play_scene("p01p04a__um2000", "p01p04a__um20", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM20', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 22 then
  SkySceneKit.play_scene("p01p04a__um2100", "p01p04a__um21", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM21', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 23 then
  SkySceneKit.play_scene("p01p04a__um2200", "p01p04a__um22", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM22', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 24 then
  SkySceneKit.play_scene("p01p04a__um2300", "p01p04a__um23", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM23', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 25 then
  SkySceneKit.play_scene("p01p04a__um2400", "p01p04a__um24", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM24', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 26 then
  SkySceneKit.play_scene("p01p04a__um2500", "p01p04a__um25", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM25', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 27 then
  SkySceneKit.play_scene("p01p04a__um2600", "p01p04a__um26", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'UM26', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 29 then
  if (SkyProg.cmp(29, 93) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 93]
  SkySceneKit.play_scene("p01p04a__us2300", "p01p04a__us23", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'US23', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 86) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 86]
  SkySceneKit.play_scene("p01p04a__us2200", "p01p04a__us22", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'US22', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 77) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 77]
  SkySceneKit.play_scene("p01p04a__us2100", "p01p04a__us21", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'US21', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 68) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 68]
  SkySceneKit.play_scene("p01p04a__us2000", "p01p04a__us20", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'US20', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54]
  SkySceneKit.play_scene("p01p04a__us0400", "p01p04a__us04", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'US04', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 40) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 40]
  SkySceneKit.play_scene("p01p04a__us0300", "p01p04a__us03", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'US03', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 32) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 32]
  SkySceneKit.play_scene("p01p04a__us0200", "p01p04a__us02", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'US02', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 7]
  SkySceneKit.play_scene("p01p04a__us3100", "p01p04a__us31", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'US31', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 0) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 0]
  -- @label_36 [étiquette de flux ExplorerScript]
  SkySceneKit.play_scene("p01p04a__us0100", "p01p04a__us01", hero, partner) -- supervision_ExecuteStationSub(LEVEL_P01P04A, 'US01', 0) [chaînage scène ROM]
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_36 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  -- jump @label_27 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif true then -- default
  if (SkyProg.cmp(7, 4) < 0) or (SkyProg.cmp(8, 4) == 0) or (SkyProg.cmp(8, 5) == 0) or (SkyProg.cmp(8, 6) == 0) or (SkyProg.cmp(29, 7) == 0) or (SkyProg.cmp(29, 8) == 0) or (SkyProg.cmp(29, 9) == 0) or (SkyProg.cmp(29, 46) == 0) or (SkyProg.cmp(29, 47) == 0) or (SkyProg.cmp(29, 48) == 0) then -- if ROM: scn($SCENARIO_MAIN) < [7, 4] || scn($SCENARIO_MAIN) == [8, 4
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- supervision_StationCommon(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  else
  -- jump @label_3 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  else
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_1 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  GAME:FadeOut(false,  0)
  -- back_SetGround(LEVEL_P01P04A) [neutre/état moteur]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
