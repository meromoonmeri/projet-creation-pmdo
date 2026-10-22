-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/G01P01C/n02a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  if true --[[BranchDebug: retail EU]] then -- if ROM: not debug
  -- @label_0 [étiquette de flux ExplorerScript]
  SV.SkyScenarioSide = {main=41, sub=1} -- $SCENARIO_SIDE = scn[41,1] (ROM)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- back_SetGround(LEVEL_G01P01C) [neutre/état moteur]
  -- supervision_Acting(0) [neutre/état moteur]
  -- supervision_StationCommon(0) [gestion de station NDS: le chargement/la coroutine commune est assurée par le harnais journey PMDO]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 16.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  -- camera_SetMyself() [neutre/état moteur]
  -- GAP: BGM BGM_FIRE_CRACKLING_LOUDER non mappé au roster (REQUIRES_MOD_ASSET ou canal ambiance)
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:FadeIn(60)
  GAME:WaitFrames(150)
  pcall(function() SOUND:FadeOutBGM(120) end)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  GAME:FadeOut(false, 60)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  else
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[M:D2][CS:C]Start from where?[CR]", french="[M:D2][CS:C]Start from where?[CR]", german="[M:D2][CS:C]Start from where?[CR]", italian="[M:D2][CS:C]Start from where?[CR]", spanish="[M:D2][CS:C]Start from where?[CR]"})
  do local __choice = SkySceneKit.ask({{english="[M:D2]Beginning", french="[M:D2]Beginning", german="[M:D2]Beginning", italian="[M:D2]Beginning", spanish="[M:D2]Beginning"}, {english="[M:D2]SectionA", french="[M:D2]SectionA", german="[M:D2]SectionA", italian="[M:D2]SectionA", spanish="[M:D2]SectionA"}, {english="[M:D2]SectionB", french="[M:D2]SectionB", german="[M:D2]SectionB", italian="[M:D2]SectionB", spanish="[M:D2]SectionB"}, {english="[M:D2]SectionC", french="[M:D2]SectionC", german="[M:D2]SectionC", italian="[M:D2]SectionC", spanish="[M:D2]SectionC"}, {english="[M:D2]SectionD", french="[M:D2]SectionD", german="[M:D2]SectionD", italian="[M:D2]SectionD", spanish="[M:D2]SectionD"}, {english="[M:D2]SectionG", french="[M:D2]SectionG", german="[M:D2]SectionG", italian="[M:D2]SectionG", spanish="[M:D2]SectionG"}, {english="[M:D2]SectionH", french="[M:D2]SectionH", german="[M:D2]SectionH", italian="[M:D2]SectionH", spanish="[M:D2]SectionH"}, {english="[M:D2]SectionI", french="[M:D2]SectionI", german="[M:D2]SectionI", italian="[M:D2]SectionI", spanish="[M:D2]SectionI"}, {english="[M:D2]SectionJ", french="[M:D2]SectionJ", german="[M:D2]SectionJ", italian="[M:D2]SectionJ", spanish="[M:D2]SectionJ"}, {english="[M:D2]SectionK", french="[M:D2]SectionK", german="[M:D2]SectionK", italian="[M:D2]SectionK", spanish="[M:D2]SectionK"}, {english="[M:D2]SectionL", french="[M:D2]SectionL", german="[M:D2]SectionL", italian="[M:D2]SectionL", spanish="[M:D2]SectionL"}, {english="[M:D2]SectionM", french="[M:D2]SectionM", german="[M:D2]SectionM", italian="[M:D2]SectionM", spanish="[M:D2]SectionM"}, {english="[M:D0]Fortune Ravine Boss 2nd Try", french="[M:D0]Fortune Ravine Boss 2nd Try", german="[M:D0]Fortune Ravine Boss 2nd Try", italian="[M:D0]Fortune Ravine Boss 2nd Try", spanish="[M:D0]Fortune Ravine Boss 2nd Try"}, {english="[M:D2]TALK-N02-01", french="[M:D2]TALK-N02-01", german="[M:D2]TALK-N02-01", italian="[M:D2]TALK-N02-01", spanish="[M:D2]TALK-N02-01"}, {english="[M:D2]TALK-N02-02", french="[M:D2]TALK-N02-02", german="[M:D2]TALK-N02-02", italian="[M:D2]TALK-N02-02", spanish="[M:D2]TALK-N02-02"}, {english="[M:D2]TALK-N02-03", french="[M:D2]TALK-N02-03", german="[M:D2]TALK-N02-03", italian="[M:D2]TALK-N02-03", spanish="[M:D2]TALK-N02-03"}, {english="[M:D2]TALK-N02-04", french="[M:D2]TALK-N02-04", german="[M:D2]TALK-N02-04", italian="[M:D2]TALK-N02-04", spanish="[M:D2]TALK-N02-04"}, {english="[M:D2]TALK-N03-01", french="[M:D2]TALK-N03-01", german="[M:D2]TALK-N03-01", italian="[M:D2]TALK-N03-01", spanish="[M:D2]TALK-N03-01"}, {english="[M:D2]TALK-N03-02", french="[M:D2]TALK-N03-02", german="[M:D2]TALK-N03-02", italian="[M:D2]TALK-N03-02", spanish="[M:D2]TALK-N03-02"}, {english="[M:D2]TALK-N03-03", french="[M:D2]TALK-N03-03", german="[M:D2]TALK-N03-03", italian="[M:D2]TALK-N03-03", spanish="[M:D2]TALK-N03-03"}, {english="[M:D2]TALK-N03-04", french="[M:D2]TALK-N03-04", german="[M:D2]TALK-N03-04", italian="[M:D2]TALK-N03-04", spanish="[M:D2]TALK-N03-04"}, {english="[M:D2]TALK-N03-05", french="[M:D2]TALK-N03-05", german="[M:D2]TALK-N03-05", italian="[M:D2]TALK-N03-05", spanish="[M:D2]TALK-N03-05"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  SV.SkyScenarioSide = {main=41, sub=1} -- $SCENARIO_SIDE = scn[41,1] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE02_TALK = SV.SkyVars.SIDE02_TALK or {}; SV.SkyVars.SIDE02_TALK[1] = 0 -- $SIDE02_TALK[1] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE02_TALK = SV.SkyVars.SIDE02_TALK or {}; SV.SkyVars.SIDE02_TALK[2] = 0 -- $SIDE02_TALK[2] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE02_TALK = SV.SkyVars.SIDE02_TALK or {}; SV.SkyVars.SIDE02_TALK[0] = 0 -- $SIDE02_TALK[0] = 0 (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[128] = 0 -- dungeon_mode(128) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[176] = 0 -- dungeon_mode(176) = DMODE_CLOSED (ROM)
  -- main_EnterGround(LEVEL_P17P02A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 3 then
  -- message_Close
  SV.SkyScenarioSide = {main=41, sub=2} -- $SCENARIO_SIDE = scn[41,2] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE02_TALK = SV.SkyVars.SIDE02_TALK or {}; SV.SkyVars.SIDE02_TALK[1] = 0 -- $SIDE02_TALK[1] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE02_TALK = SV.SkyVars.SIDE02_TALK or {}; SV.SkyVars.SIDE02_TALK[2] = 0 -- $SIDE02_TALK[2] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE02_TALK = SV.SkyVars.SIDE02_TALK or {}; SV.SkyVars.SIDE02_TALK[0] = 0 -- $SIDE02_TALK[0] = 0 (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[128] = 0 -- dungeon_mode(128) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[176] = 0 -- dungeon_mode(176) = DMODE_CLOSED (ROM)
  -- main_EnterGround(LEVEL_P16P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 4 then
  -- message_Close
  SV.SkyScenarioSide = {main=41, sub=3} -- $SCENARIO_SIDE = scn[41,3] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[128] = 0 -- dungeon_mode(128) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[176] = 0 -- dungeon_mode(176) = DMODE_CLOSED (ROM)
  -- main_EnterGround(LEVEL_P17P02A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 5 then
  -- message_Close
  SV.SkyScenarioSide = {main=41, sub=5} -- $SCENARIO_SIDE = scn[41,5] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[128] = 0 -- dungeon_mode(128) = DMODE_CLOSED (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[176] = 0 -- dungeon_mode(176) = DMODE_CLOSED (ROM)
  -- main_EnterGround(LEVEL_P17P02A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 6 then
  -- message_Close
  SV.SkyScenarioSide = {main=42, sub=0} -- $SCENARIO_SIDE = scn[42,0] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[128] = 3 -- dungeon_mode(128) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[176] = 1 -- dungeon_mode(176) = DMODE_OPEN (ROM)
  -- main_EnterGround(LEVEL_P17P02A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 7 then
  -- message_Close
  SV.SkyScenarioSide = {main=42, sub=2} -- $SCENARIO_SIDE = scn[42,2] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[128] = 3 -- dungeon_mode(128) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[176] = 1 -- dungeon_mode(176) = DMODE_OPEN (ROM)
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_P19P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 8 then
  -- message_Close
  SV.SkyScenarioSide = {main=42, sub=3} -- $SCENARIO_SIDE = scn[42,3] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[128] = 3 -- dungeon_mode(128) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[176] = 1 -- dungeon_mode(176) = DMODE_OPEN (ROM)
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_P19P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 9 then
  -- message_Close
  SV.SkyScenarioSide = {main=42, sub=4} -- $SCENARIO_SIDE = scn[42,4] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[128] = 3 -- dungeon_mode(128) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[176] = 1 -- dungeon_mode(176) = DMODE_OPEN (ROM)
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_P17P02A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 10 then
  -- message_Close
  SV.SkyScenarioSide = {main=42, sub=5} -- $SCENARIO_SIDE = scn[42,5] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[128] = 3 -- dungeon_mode(128) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[176] = 1 -- dungeon_mode(176) = DMODE_OPEN (ROM)
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_P19P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 11 then
  -- message_Close
  SV.SkyScenarioSide = {main=42, sub=6} -- $SCENARIO_SIDE = scn[42,6] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[128] = 3 -- dungeon_mode(128) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[176] = 1 -- dungeon_mode(176) = DMODE_OPEN (ROM)
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_P19P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 12 then
  -- message_Close
  SV.SkyScenarioSide = {main=42, sub=5} -- $SCENARIO_SIDE = scn[42,5] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[128] = 3 -- dungeon_mode(128) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[176] = 1 -- dungeon_mode(176) = DMODE_OPEN (ROM)
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_D45P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 13 then
  -- message_Close
  SV.SkyScenarioSide = {main=42, sub=9} -- $SCENARIO_SIDE = scn[42,9] (ROM)
  SkySceneKit.play_scene("d45p42a__n03a160100", "d45p42a__n03a1601", hero, partner) -- supervision_ExecuteActing(LEVEL_D45P42A, 'N03A1601', 0) [chaînage scène ROM]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 14 then
  SV.SkyScenarioSide = {main=41, sub=1} -- $SCENARIO_SIDE = scn[41,1] (ROM)
  -- message_Close
  -- main_EnterGround(LEVEL_P17P02A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 15 then
  SV.SkyScenarioSide = {main=41, sub=2} -- $SCENARIO_SIDE = scn[41,2] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE02_TALK = SV.SkyVars.SIDE02_TALK or {}; SV.SkyVars.SIDE02_TALK[1] = 0 -- $SIDE02_TALK[1] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE02_TALK = SV.SkyVars.SIDE02_TALK or {}; SV.SkyVars.SIDE02_TALK[2] = 0 -- $SIDE02_TALK[2] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE02_TALK = SV.SkyVars.SIDE02_TALK or {}; SV.SkyVars.SIDE02_TALK[0] = 0 -- $SIDE02_TALK[0] = 0 (ROM)
  -- message_Close
  -- main_EnterGround(LEVEL_P16P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 16 then
  SV.SkyScenarioSide = {main=41, sub=3} -- $SCENARIO_SIDE = scn[41,3] (ROM)
  -- main_EnterGround(LEVEL_P17P02A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 17 then
  SV.SkyScenarioSide = {main=42, sub=0} -- $SCENARIO_SIDE = scn[42,0] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[128] = 3 -- dungeon_mode(128) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[176] = 1 -- dungeon_mode(176) = DMODE_OPEN (ROM)
  -- message_Close
  -- main_EnterGround(LEVEL_P17P02A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 18 then
  SV.SkyScenarioSide = {main=42, sub=2} -- $SCENARIO_SIDE = scn[42,2] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[128] = 3 -- dungeon_mode(128) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[176] = 1 -- dungeon_mode(176) = DMODE_OPEN (ROM)
  -- message_Close
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_P19P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 19 then
  SV.SkyScenarioSide = {main=42, sub=4} -- $SCENARIO_SIDE = scn[42,4] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[128] = 3 -- dungeon_mode(128) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[176] = 1 -- dungeon_mode(176) = DMODE_OPEN (ROM)
  -- message_Close
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_P17P02A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 20 then
  SV.SkyScenarioSide = {main=42, sub=5} -- $SCENARIO_SIDE = scn[42,5] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[128] = 3 -- dungeon_mode(128) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[176] = 1 -- dungeon_mode(176) = DMODE_OPEN (ROM)
  -- message_Close
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterGround(LEVEL_P19P01A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 21 then
  SV.SkyScenarioSide = {main=42, sub=7} -- $SCENARIO_SIDE = scn[42,7] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[128] = 3 -- dungeon_mode(128) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[176] = 1 -- dungeon_mode(176) = DMODE_OPEN (ROM)
  -- message_Close
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterDungeon(130, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D45P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 22 then
  SV.SkyScenarioSide = {main=42, sub=8} -- $SCENARIO_SIDE = scn[42,8] (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[128] = 3 -- dungeon_mode(128) = DMODE_OPEN_AND_REQUEST (ROM)
  SV.SkyDungeonMode = SV.SkyDungeonMode or {}; SV.SkyDungeonMode[176] = 1 -- dungeon_mode(176) = DMODE_OPEN (ROM)
  -- message_Close
  -- switch(ProcessSpecial(3, 0, 0)) [procédé/menu moteur NDS, corps vide: aucun embranchement canonique — équivalent moteur PMDO]
  -- main_EnterDungeon(130, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D45P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else -- default/annulation
  -- message_Close
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
