-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/D01P11A/enter00.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkyProg = require 'halcyon.skyscenes.progression'
return function(hero, partner)
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  -- @label_0 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  if ((SV.SkyScenarioBitFlags or {})[92] == 1) then -- if ROM: $SCENARIO_MAIN_BIT_FLAG[92]
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 or __sw == 2 then
  -- @label_2 [étiquette de flux ExplorerScript]
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 then
  SkySceneKit.play_scene("d01p11a__un0100", "d01p11a__un01", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UN01', 0) [chaînage scène ROM]
  -- @label_6 [étiquette de flux ExplorerScript]
  do local __sw = 1 -- switch(sector()) [sector(): acting principal (kit PMDO)]
  if __sw == 1 then
  elseif true then -- default
  do local __sw = ((SV.SkyVars or {}).GROUND_GETOUT or -1) -- switch($GROUND_GETOUT) [GameVar GROUND_GETOUT: sortie précédente]
  if __sw == 225 then
  do local __sw = ((SV.SkyVars or {}).EXECUTE_SPECIAL_EPISODE_TYPE or 0) -- switch($EXECUTE_SPECIAL_EPISODE_TYPE) [GameVar EXECUTE_SPECIAL_EPISODE_TYPE: épisode spécial actif]
  if __sw == 0 then
  -- supervision_StationCommon(21) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- @label_45 [étiquette de flux ExplorerScript]
  -- debug_Print('SET_BGM') [neutre/état moteur]
  -- GAP: BGM BGM_OCEAN1 non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  do local __sw = ((SV.SkyVars or {}).GROUND_GETOUT or -1) -- switch($GROUND_GETOUT) [GameVar GROUND_GETOUT: sortie précédente]
  if __sw == 59 then
  -- back2_SetMode(-1) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(2) -- join WaitSubScreen (fondu sub déjà séquencé par SubScreen)
  -- @label_47 [étiquette de flux ExplorerScript]
  -- JumpCommon(CORO_COMMON_ENTER) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  elseif true then -- default
  -- jump @label_47 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 2 then
  -- supervision_StationCommon(41) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_45 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- supervision_StationCommon(1) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_45 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  elseif __sw == 59 then
  -- supervision_StationCommon(2) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_45 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_42 [étiquette de flux ExplorerScript]
  -- supervision_StationCommon(3) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_45 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif __sw == 2 then
  SkySceneKit.play_scene("d01p11a__un0400", "d01p11a__un04", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UN04', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- @label_5 [étiquette de flux ExplorerScript]
  do local __sw = select(1, SkyProg.state()) -- switch(scn($SCENARIO_MAIN)[0]) [scn($SCENARIO_MAIN)[0]: chapitre courant]
  if __sw == 4 then
  SkySceneKit.play_scene("d01p11a__um0300", "d01p11a__um03", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM03', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 5 then
  SkySceneKit.play_scene("d01p11a__um0400", "d01p11a__um04", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM04', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 6 then
  SkySceneKit.play_scene("d01p11a__um0500", "d01p11a__um05", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM05', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 7 then
  SkySceneKit.play_scene("d01p11a__um0600", "d01p11a__um06", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM06', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 8 then
  SkySceneKit.play_scene("d01p11a__um0700", "d01p11a__um07", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM07', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 9 then
  SkySceneKit.play_scene("d01p11a__um0800", "d01p11a__um08", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM08', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 12 then
  SkySceneKit.play_scene("d01p11a__um1100", "d01p11a__um11", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM11', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 13 then
  SkySceneKit.play_scene("d01p11a__um1200", "d01p11a__um12", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM12', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 14 then
  SkySceneKit.play_scene("d01p11a__um1300", "d01p11a__um13", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM13', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 15 then
  SkySceneKit.play_scene("d01p11a__um1400", "d01p11a__um14", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM14', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 16 then
  SkySceneKit.play_scene("d01p11a__um1500", "d01p11a__um15", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM15', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 17 then
  SkySceneKit.play_scene("d01p11a__um1600", "d01p11a__um16", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM16', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 18 then
  SkySceneKit.play_scene("d01p11a__um1700", "d01p11a__um17", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM17', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 19 then
  SkySceneKit.play_scene("d01p11a__um1800", "d01p11a__um18", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM18', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 20 then
  SkySceneKit.play_scene("d01p11a__um1900", "d01p11a__um19", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM19', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 21 then
  SkySceneKit.play_scene("d01p11a__um2000", "d01p11a__um20", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM20', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 22 then
  SkySceneKit.play_scene("d01p11a__um2100", "d01p11a__um21", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM21', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 23 then
  SkySceneKit.play_scene("d01p11a__um2200", "d01p11a__um22", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM22', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 24 then
  SkySceneKit.play_scene("d01p11a__um2300", "d01p11a__um23", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM23', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 25 then
  SkySceneKit.play_scene("d01p11a__um2400", "d01p11a__um24", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM24', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 26 then
  SkySceneKit.play_scene("d01p11a__um2500", "d01p11a__um25", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM25', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 27 then
  SkySceneKit.play_scene("d01p11a__um2600", "d01p11a__um26", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'UM26', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif __sw == 29 then
  if (SkyProg.cmp(29, 93) >= 0) then -- if ROM: scn($SCENARIO_MAIN) >= [29, 93]
  SkySceneKit.play_scene("d01p11a__us2300", "d01p11a__us23", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'US23', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 86) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 86]
  SkySceneKit.play_scene("d01p11a__us2200", "d01p11a__us22", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'US22', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 77) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 77]
  SkySceneKit.play_scene("d01p11a__us2100", "d01p11a__us21", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'US21', 0) [chaînage scène ROM]
  -- debug_Print('OP') [neutre/état moteur]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 68) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 68]
  SkySceneKit.play_scene("d01p11a__us2000", "d01p11a__us20", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'US20', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 54) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 54]
  SkySceneKit.play_scene("d01p11a__us0400", "d01p11a__us04", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'US04', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 40) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 40]
  SkySceneKit.play_scene("d01p11a__us0300", "d01p11a__us03", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'US03', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 32) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 32]
  SkySceneKit.play_scene("d01p11a__us0200", "d01p11a__us02", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'US02', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 7) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 7]
  SkySceneKit.play_scene("d01p11a__us3100", "d01p11a__us31", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'US31', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif (SkyProg.cmp(29, 0) >= 0) then -- elseif ROM: scn($SCENARIO_MAIN) >= [29, 0]
  -- @label_38 [étiquette de flux ExplorerScript]
  SkySceneKit.play_scene("d01p11a__us0100", "d01p11a__us01", hero, partner) -- supervision_ExecuteStationSub(LEVEL_D01P11A, 'US01', 0) [chaînage scène ROM]
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- jump @label_38 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  -- jump @label_6 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  elseif true then -- default
  if (SkyProg.cmp(4, 5) < 0) or (SkyProg.cmp(29, 43) == 0) or (SkyProg.cmp(29, 44) == 0) or (SkyProg.cmp(29, 45) == 0) or (SkyProg.cmp(29, 46) == 0) or (SkyProg.cmp(29, 47) == 0) or (SkyProg.cmp(29, 48) == 0) or (SkyProg.cmp(29, 49) == 0) or (SkyProg.cmp(29, 50) == 0) or (SkyProg.cmp(29, 93) == 0) or (SkyProg.cmp(29, 94) == 0) then -- if ROM: scn($SCENARIO_MAIN) < [4, 5] || scn($SCENARIO_MAIN) == [29, 
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  else
  -- switch(ProcessSpecial(PROCESS_SPECIAL_INIT_RANDOM_NPC_JOBS, 1, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  do local __sw = ((SV.SkyProcResults or {})["PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE"] or 0) -- switch(ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_) [ProcessSpecial(PROCESS_SPECIAL_GET_RANDOM_NPC_JOB_STILL_AVAILABLE): retour du procédé arm9 (SV harnais, défaut 0 état vierge)]
  if __sw == 0 then
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  elseif true then -- default
  -- supervision_StationCommon(5) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  end
  end
  else
  -- jump @label_2 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  elseif true then -- default
  GAME:FadeOut(false,  0)
  -- back_SetGround(LEVEL_D01P11A) [neutre/état moteur]
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
end
