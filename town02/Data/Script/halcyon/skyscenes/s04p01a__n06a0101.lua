-- GÉNÉRÉ par dev/tools/sky_compile_scenes.py — NE PAS ÉDITER À LA MAIN.
-- Scène canonique PMD Sky EU : SCRIPT/S04P01A/n06a0101.ssb (ROM sha256 1fa39d35…).
-- Dialogues 5 langues ROM embarqués ; conventions du pilote m01a0204.
local SkySceneKit = require 'halcyon.skyscenes.kit'
local SkySubScreen = require 'halcyon.skyscenes.subscreen'
return function(hero, partner)
  pcall(function() SOUND:StopBGM() end)
  if true --[[BranchDebug: retail EU]] then -- if ROM: not debug
  -- @label_0 [étiquette de flux ExplorerScript]
  pcall(function() SOUND:StopBGM() end)
  SV.SkyScenarioSide = {main=45, sub=1} -- $SCENARIO_SIDE = scn[45,1] (ROM)
  -- back2_SetMode(4) [mode d'affichage sub NDS: géré par SubScreen]
  -- back2_SetGround(V02P06A) [décor sub chargé: Sub_v02p06a]
  -- camera2_SetPositionMark(Position<'m0', 19.5, 15.5>) [caméra sub NDS: nappe Sub_ cadrée fenêtre NDS, recadrage dynamique non simulé - documenté]
  SkySubScreen.Show("v02p06a", 60, false) -- screen2_FadeIn: TOP_FOCUS (timeline ROM)
  GAME:WaitFrames(150)
  SkySubScreen.Hide(60) -- screen2_FadeOut: retour BOTTOM_FOCUS (timeline ROM)
  -- back2_SetMode(0) [mode d'affichage sub NDS: géré par SubScreen]
  GAME:WaitFrames(30)
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[CN]One evening...", french="[CN]Un soir...", german="[CN]Eines Abends...", italian="[CN]Una notte...", spanish="[CN]Una noche..."})
  -- message_Close
  else
  pcall(function() UI:ResetSpeaker() end)
  SkySceneKit.say({english="[M:D2][CS:C]Start from where?[CR]", french="[M:D2][CS:C]Start from where?[CR]", german="[M:D2][CS:C]Start from where?[CR]", italian="[M:D2][CS:C]Start from where?[CR]", spanish="[M:D2][CS:C]Start from where?[CR]"})
  do local __choice = SkySceneKit.ask({{english="[M:D2]Beginning", french="[M:D2]Beginning", german="[M:D2]Beginning", italian="[M:D2]Beginning", spanish="[M:D2]Beginning"}, {english="[M:D2]SouthernJungle", french="[M:D2]SouthernJungle", german="[M:D2]SouthernJungle", italian="[M:D2]SouthernJungle", spanish="[M:D2]SouthernJungle"}, {english="[M:D2]SouthernJungle2ndTry", french="[M:D2]SouthernJungle2ndTry", german="[M:D2]SouthernJungle2ndTry", italian="[M:D2]SouthernJungle2ndTry", spanish="[M:D2]SouthernJungle2ndTry"}, {english="[M:D2]BoulderQuarry", french="[M:D2]BoulderQuarry", german="[M:D2]BoulderQuarry", italian="[M:D2]BoulderQuarry", spanish="[M:D2]BoulderQuarry"}, {english="[M:D2]BoulderQuarry2ndTry", french="[M:D2]BoulderQuarry2ndTry", german="[M:D2]BoulderQuarry2ndTry", italian="[M:D2]BoulderQuarry2ndTry", spanish="[M:D2]BoulderQuarry2ndTry"}, {english="[M:D2]BoulderQuarryMidpoint", french="[M:D2]BoulderQuarryMidpoint", german="[M:D2]BoulderQuarryMidpoint", italian="[M:D2]BoulderQuarryMidpoint", spanish="[M:D2]BoulderQuarryMidpoint"}, {english="[M:D2]DeepBoulderQuarry2ndTry", french="[M:D2]DeepBoulderQuarry2ndTry", german="[M:D2]DeepBoulderQuarry2ndTry", italian="[M:D2]DeepBoulderQuarry2ndTry", spanish="[M:D2]DeepBoulderQuarry2ndTry"}, {english="[M:D2]BoulderQuarryBoss2ndTry", french="[M:D2]BoulderQuarryBoss2ndTry", german="[M:D2]BoulderQuarryBoss2ndTry", italian="[M:D2]BoulderQuarryBoss2ndTry", spanish="[M:D2]BoulderQuarryBoss2ndTry"}, {english="[M:D2]DeepBoulderQuarryBoss2ndTry", french="[M:D2]DeepBoulderQuarryBoss2ndTry", german="[M:D2]DeepBoulderQuarryBoss2ndTry", italian="[M:D2]DeepBoulderQuarryBoss2ndTry", spanish="[M:D2]DeepBoulderQuarryBoss2ndTry"}, {english="[M:D2]IllusionStoneChamber", french="[M:D2]IllusionStoneChamber", german="[M:D2]IllusionStoneChamber", italian="[M:D2]IllusionStoneChamber", spanish="[M:D2]IllusionStoneChamber"}, {english="[M:D2]IllusionStoneChamberAllClear", french="[M:D2]IllusionStoneChamberAllClear", german="[M:D2]IllusionStoneChamberAllClear", italian="[M:D2]IllusionStoneChamberAllClear", spanish="[M:D2]IllusionStoneChamberAllClear"}, {english="[M:D2]LimestoneCavern2ndTry", french="[M:D2]LimestoneCavern2ndTry", german="[M:D2]LimestoneCavern2ndTry", italian="[M:D2]LimestoneCavern2ndTry", spanish="[M:D2]LimestoneCavern2ndTry"}, {english="[M:D2]LimestoneCavernMidpoint", french="[M:D2]LimestoneCavernMidpoint", german="[M:D2]LimestoneCavernMidpoint", italian="[M:D2]LimestoneCavernMidpoint", spanish="[M:D2]LimestoneCavernMidpoint"}, {english="[M:D2]DeepLimestoneCavern2ndTry", french="[M:D2]DeepLimestoneCavern2ndTry", german="[M:D2]DeepLimestoneCavern2ndTry", italian="[M:D2]DeepLimestoneCavern2ndTry", spanish="[M:D2]DeepLimestoneCavern2ndTry"}, {english="[M:D2]LimestoneCavernDepths2ndTry", french="[M:D2]LimestoneCavernDepths2ndTry", german="[M:D2]LimestoneCavernDepths2ndTry", italian="[M:D2]LimestoneCavernDepths2ndTry", spanish="[M:D2]LimestoneCavernDepths2ndTry"}, {english="[M:D2]DeepLimestoneCavernBoss2ndTry", french="[M:D2]DeepLimestoneCavernBoss2ndTry", german="[M:D2]DeepLimestoneCavernBoss2ndTry", italian="[M:D2]DeepLimestoneCavernBoss2ndTry", spanish="[M:D2]DeepLimestoneCavernBoss2ndTry"}, {english="[M:D2]LimestoneCavernBoss2ndTry", french="[M:D2]LimestoneCavernBoss2ndTry", german="[M:D2]LimestoneCavernBoss2ndTry", italian="[M:D2]LimestoneCavernBoss2ndTry", spanish="[M:D2]LimestoneCavernBoss2ndTry"}, {english="[M:D2]TALK-N06-01", french="[M:D2]TALK-N06-01", german="[M:D2]TALK-N06-01", italian="[M:D2]TALK-N06-01", spanish="[M:D2]TALK-N06-01"}, {english="[M:D2]TALK-N06-02", french="[M:D2]TALK-N06-02", german="[M:D2]TALK-N06-02", italian="[M:D2]TALK-N06-02", spanish="[M:D2]TALK-N06-02"}, {english="[M:D2]TALK-N06-03", french="[M:D2]TALK-N06-03", german="[M:D2]TALK-N06-03", italian="[M:D2]TALK-N06-03", spanish="[M:D2]TALK-N06-03"}, {english="[M:D2]TALK-N06-04", french="[M:D2]TALK-N06-04", german="[M:D2]TALK-N06-04", italian="[M:D2]TALK-N06-04", spanish="[M:D2]TALK-N06-04"}, {english="[M:D2]TALK-N06-05", french="[M:D2]TALK-N06-05", german="[M:D2]TALK-N06-05", italian="[M:D2]TALK-N06-05", spanish="[M:D2]TALK-N06-05"}, {english="[M:D2]TALK-N06-06", french="[M:D2]TALK-N06-06", german="[M:D2]TALK-N06-06", italian="[M:D2]TALK-N06-06", spanish="[M:D2]TALK-N06-06"}, {english="[M:D2]TALK-N06-07", french="[M:D2]TALK-N06-07", german="[M:D2]TALK-N06-07", italian="[M:D2]TALK-N06-07", spanish="[M:D2]TALK-N06-07"}, {english="[M:D2]TALK-N06-08", french="[M:D2]TALK-N06-08", german="[M:D2]TALK-N06-08", italian="[M:D2]TALK-N06-08", spanish="[M:D2]TALK-N06-08"}, {english="[M:D2]TALK-N06-09", french="[M:D2]TALK-N06-09", german="[M:D2]TALK-N06-09", italian="[M:D2]TALK-N06-09", spanish="[M:D2]TALK-N06-09"}, {english="[M:D2]TALK-N06-10", french="[M:D2]TALK-N06-10", german="[M:D2]TALK-N06-10", italian="[M:D2]TALK-N06-10", spanish="[M:D2]TALK-N06-10"}, {english="[M:D2]TALK-N06-11", french="[M:D2]TALK-N06-11", german="[M:D2]TALK-N06-11", italian="[M:D2]TALK-N06-11", spanish="[M:D2]TALK-N06-11"}, {english="[M:D2]TALK-N06-12", french="[M:D2]TALK-N06-12", german="[M:D2]TALK-N06-12", italian="[M:D2]TALK-N06-12", spanish="[M:D2]TALK-N06-12"}, {english="[M:D2]TALK-N06-13", french="[M:D2]TALK-N06-13", german="[M:D2]TALK-N06-13", italian="[M:D2]TALK-N06-13", spanish="[M:D2]TALK-N06-13"}, {english="[M:D2]TALK-N06-14", french="[M:D2]TALK-N06-14", german="[M:D2]TALK-N06-14", italian="[M:D2]TALK-N06-14", spanish="[M:D2]TALK-N06-14"}, {english="[M:D2]TALK-N06-15", french="[M:D2]TALK-N06-15", german="[M:D2]TALK-N06-15", italian="[M:D2]TALK-N06-15", spanish="[M:D2]TALK-N06-15"}, {english="[M:D2]TALK-N06-16", french="[M:D2]TALK-N06-16", german="[M:D2]TALK-N06-16", italian="[M:D2]TALK-N06-16", spanish="[M:D2]TALK-N06-16"}, {english="[M:D2]TALK-N06-17", french="[M:D2]TALK-N06-17", german="[M:D2]TALK-N06-17", italian="[M:D2]TALK-N06-17", spanish="[M:D2]TALK-N06-17"}, {english="[M:D2]TALK-N06-18", french="[M:D2]TALK-N06-18", german="[M:D2]TALK-N06-18", italian="[M:D2]TALK-N06-18", spanish="[M:D2]TALK-N06-18"}}) -- message_SwitchMenu(0, 1) ROM
  if __choice == 2 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[0] = 0 -- $SIDE06_ROOM[0] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[1] = 0 -- $SIDE06_ROOM[1] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[2] = 0 -- $SIDE06_ROOM[2] = 0 (ROM)
  SV.SkyScenarioSide = {main=45, sub=1} -- $SCENARIO_SIDE = scn[45,1] (ROM)
  -- main_EnterGround(LEVEL_D54P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 3 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[0] = 0 -- $SIDE06_ROOM[0] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[1] = 0 -- $SIDE06_ROOM[1] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[2] = 0 -- $SIDE06_ROOM[2] = 0 (ROM)
  SV.SkyScenarioSide = {main=45, sub=2} -- $SCENARIO_SIDE = scn[45,2] (ROM)
  -- main_EnterGround(LEVEL_D54P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 4 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[0] = 0 -- $SIDE06_ROOM[0] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[1] = 0 -- $SIDE06_ROOM[1] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[2] = 0 -- $SIDE06_ROOM[2] = 0 (ROM)
  SV.SkyScenarioSide = {main=45, sub=3} -- $SCENARIO_SIDE = scn[45,3] (ROM)
  -- main_EnterGround(LEVEL_D55P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 5 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[0] = 0 -- $SIDE06_ROOM[0] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[1] = 0 -- $SIDE06_ROOM[1] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[2] = 0 -- $SIDE06_ROOM[2] = 0 (ROM)
  SV.SkyScenarioSide = {main=45, sub=4} -- $SCENARIO_SIDE = scn[45,4] (ROM)
  -- main_EnterGround(LEVEL_D55P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 6 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[0] = 0 -- $SIDE06_ROOM[0] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[1] = 0 -- $SIDE06_ROOM[1] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[2] = 0 -- $SIDE06_ROOM[2] = 0 (ROM)
  SV.SkyScenarioSide = {main=45, sub=5} -- $SCENARIO_SIDE = scn[45,5] (ROM)
  -- main_EnterGround(LEVEL_D55P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 7 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[0] = 0 -- $SIDE06_ROOM[0] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[1] = 0 -- $SIDE06_ROOM[1] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[2] = 0 -- $SIDE06_ROOM[2] = 0 (ROM)
  SV.SkyScenarioSide = {main=45, sub=6} -- $SCENARIO_SIDE = scn[45,6] (ROM)
  -- main_EnterGround(LEVEL_D55P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 8 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[0] = 0 -- $SIDE06_ROOM[0] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[1] = 0 -- $SIDE06_ROOM[1] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[2] = 0 -- $SIDE06_ROOM[2] = 0 (ROM)
  SV.SkyScenarioSide = {main=45, sub=7} -- $SCENARIO_SIDE = scn[45,7] (ROM)
  -- main_EnterGround(LEVEL_D55P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 9 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[0] = 0 -- $SIDE06_ROOM[0] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[1] = 0 -- $SIDE06_ROOM[1] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[2] = 0 -- $SIDE06_ROOM[2] = 0 (ROM)
  SV.SkyScenarioSide = {main=45, sub=7} -- $SCENARIO_SIDE = scn[45,7] (ROM)
  -- main_EnterGround(LEVEL_D55P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 10 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[0] = 0 -- $SIDE06_ROOM[0] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[1] = 0 -- $SIDE06_ROOM[1] = 0 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[2] = 0 -- $SIDE06_ROOM[2] = 0 (ROM)
  SV.SkyScenarioSide = {main=45, sub=7} -- $SCENARIO_SIDE = scn[45,7] (ROM)
  -- main_EnterGround(LEVEL_D56P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 11 then
  -- message_Close
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[0] = 1 -- $SIDE06_ROOM[0] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[1] = 1 -- $SIDE06_ROOM[1] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[2] = 0 -- $SIDE06_ROOM[2] = 0 (ROM)
  SV.SkyScenarioSide = {main=45, sub=9} -- $SCENARIO_SIDE = scn[45,9] (ROM)
  -- main_EnterGround(LEVEL_D56P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 12 then
  -- message_Close
  SV.SkyScenarioSide = {main=45, sub=10} -- $SCENARIO_SIDE = scn[45,10] (ROM)
  -- main_EnterGround(LEVEL_D56P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 13 then
  -- message_Close
  SV.SkyScenarioSide = {main=45, sub=11} -- $SCENARIO_SIDE = scn[45,11] (ROM)
  -- main_EnterGround(LEVEL_D56P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 14 then
  -- message_Close
  SV.SkyScenarioSide = {main=45, sub=12} -- $SCENARIO_SIDE = scn[45,12] (ROM)
  -- main_EnterGround(LEVEL_D56P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 15 then
  -- message_Close
  SV.SkyScenarioSide = {main=45, sub=13} -- $SCENARIO_SIDE = scn[45,13] (ROM)
  -- main_EnterGround(LEVEL_D56P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 16 then
  -- message_Close
  SV.SkyScenarioSide = {main=45, sub=13} -- $SCENARIO_SIDE = scn[45,13] (ROM)
  -- main_EnterGround(LEVEL_D56P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 17 then
  -- message_Close
  SV.SkyScenarioSide = {main=45, sub=13} -- $SCENARIO_SIDE = scn[45,13] (ROM)
  -- main_EnterGround(LEVEL_D56P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 18 then
  SV.SkyScenarioSide = {main=45, sub=1} -- $SCENARIO_SIDE = scn[45,1] (ROM)
  -- message_Close
  -- main_EnterGround(LEVEL_D54P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 19 then
  SV.SkyScenarioSide = {main=45, sub=2} -- $SCENARIO_SIDE = scn[45,2] (ROM)
  -- message_Close
  -- main_EnterGround(LEVEL_D54P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 20 then
  SV.SkyScenarioSide = {main=45, sub=3} -- $SCENARIO_SIDE = scn[45,3] (ROM)
  -- message_Close
  -- main_EnterGround(LEVEL_D55P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 21 then
  SV.SkyScenarioSide = {main=45, sub=4} -- $SCENARIO_SIDE = scn[45,4] (ROM)
  -- message_Close
  -- main_EnterGround(LEVEL_D55P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 22 then
  SV.SkyScenarioSide = {main=45, sub=5} -- $SCENARIO_SIDE = scn[45,5] (ROM)
  -- message_Close
  -- main_EnterDungeon(150, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D55P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 23 then
  SV.SkyScenarioSide = {main=45, sub=6} -- $SCENARIO_SIDE = scn[45,6] (ROM)
  -- message_Close
  -- main_EnterDungeon(150, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D55P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 24 then
  SV.SkyScenarioSide = {main=45, sub=7} -- $SCENARIO_SIDE = scn[45,7] (ROM)
  -- message_Close
  -- main_EnterDungeon(150, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D55P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 25 then
  SV.SkyScenarioSide = {main=45, sub=7} -- $SCENARIO_SIDE = scn[45,7] (ROM)
  -- message_Close
  -- main_EnterGround(LEVEL_D56P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 26 then
  SV.SkyScenarioSide = {main=45, sub=8} -- $SCENARIO_SIDE = scn[45,8] (ROM)
  -- message_Close
  -- main_EnterGround(LEVEL_D56P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 27 then
  SV.SkyScenarioSide = {main=45, sub=8} -- $SCENARIO_SIDE = scn[45,8] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[0] = 1 -- $SIDE06_ROOM[0] = 1 (ROM)
  -- message_Close
  -- main_EnterGround(LEVEL_D56P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 28 then
  SV.SkyScenarioSide = {main=45, sub=8} -- $SCENARIO_SIDE = scn[45,8] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[2] = 1 -- $SIDE06_ROOM[2] = 1 (ROM)
  -- message_Close
  -- main_EnterGround(LEVEL_D56P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 29 then
  SV.SkyScenarioSide = {main=45, sub=8} -- $SCENARIO_SIDE = scn[45,8] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[1] = 1 -- $SIDE06_ROOM[1] = 1 (ROM)
  -- message_Close
  -- main_EnterGround(LEVEL_D56P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 30 then
  SV.SkyScenarioSide = {main=45, sub=8} -- $SCENARIO_SIDE = scn[45,8] (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[2] = 1 -- $SIDE06_ROOM[2] = 1 (ROM)
  -- message_Close
  -- main_EnterGround(LEVEL_D56P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 31 then
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[0] = 1 -- $SIDE06_ROOM[0] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[1] = 1 -- $SIDE06_ROOM[1] = 1 (ROM)
  SV.SkyVars = SV.SkyVars or {}
  SV.SkyVars.SIDE06_ROOM = SV.SkyVars.SIDE06_ROOM or {}; SV.SkyVars.SIDE06_ROOM[2] = 0 -- $SIDE06_ROOM[2] = 0 (ROM)
  SV.SkyScenarioSide = {main=45, sub=9} -- $SCENARIO_SIDE = scn[45,9] (ROM)
  -- message_Close
  -- main_EnterGround(LEVEL_D56P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 32 then
  SV.SkyScenarioSide = {main=45, sub=10} -- $SCENARIO_SIDE = scn[45,10] (ROM)
  -- message_Close
  -- main_EnterGround(LEVEL_D56P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 33 then
  SV.SkyScenarioSide = {main=45, sub=11} -- $SCENARIO_SIDE = scn[45,11] (ROM)
  -- message_Close
  -- main_EnterDungeon(155, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D56P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 34 then
  SV.SkyScenarioSide = {main=45, sub=13} -- $SCENARIO_SIDE = scn[45,13] (ROM)
  -- message_Close
  -- main_EnterDungeon(155, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  -- switch(message_Menu(MENU_DUNGEON_INITIALIZE_TEAM)) [menu système NDS sans embranchement (corps vide): équivalent géré par le moteur PMDO]
  -- main_EnterGround(LEVEL_D56P21A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  elseif __choice == 35 then
  SV.SkyScenarioSide = {main=45, sub=13} -- $SCENARIO_SIDE = scn[45,13] (ROM)
  -- message_Close
  -- main_EnterGround(LEVEL_D56P11A, 30) [transition de zone NDS: assurée par le harnais journey/EnterZone PMDO]
  GAME:WaitFrames(1) -- hold
  else -- default/annulation
  -- message_Close
  -- jump @label_0 [saut final de branche vers l'épilogue commun: flux naturel]
  end
  end
  end
  SkySubScreen.Hide(10) -- fin de scène: nappe sub retirée
end
